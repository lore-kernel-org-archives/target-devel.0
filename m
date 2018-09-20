From: xiubli@redhat.com
Date: Thu, 20 Sep 2018 08:14:11 +0000
Subject: [PATCH v2] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <20180920081411.1628-1-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Currently there has one cmd timeout timer and one qfull timer for
each udev, and whenever there has any new coming cmd it will update
the cmd timer or qfull timer. And for some corner case the timers
are always working only for the ringbuffer's and full queue's newest
cmd. That's to say the timer won't be fired even there has one cmd
stuck for a very long time and the deadline is reached.

This fix will keep the cmd/qfull timers to be pended for the oldest
cmd in ringbuffer and full queue, and will update them with the next
cmd's deadline only when the old cmd's deadline is reached or removed
from the ringbuffer and full queue.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- Add qfull timer
- Addressed all the comments from Mike, thanks.

 drivers/target/target_core_user.c | 52 ++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9cd404acdb82..99e73dfb0d2e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -159,9 +159,11 @@ struct tcmu_dev {
 
 	struct timer_list cmd_timer;
 	unsigned int cmd_time_out;
+	unsigned long cmd_next_deadline;
 
 	struct timer_list qfull_timer;
 	int qfull_time_out;
+	unsigned long qfull_next_deadline;
 
 	struct list_head timedout_entry;
 
@@ -915,7 +917,9 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
 		return 0;
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
-	mod_timer(timer, tcmu_cmd->deadline);
+	if (!timer_pending(timer))
+		mod_timer(timer, tcmu_cmd->deadline);
+
 	return 0;
 }
 
@@ -1197,6 +1201,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
+	struct tcmu_cmd *cmd;
 	int handled = 0;
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
@@ -1210,7 +1215,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	while (udev->cmdr_last_cleaned != READ_ONCE(mb->cmd_tail)) {
 
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
-		struct tcmu_cmd *cmd;
 
 		tcmu_flush_dcache_range(entry, sizeof(*entry));
 
@@ -1252,6 +1256,22 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			    tcmu_global_max_blocks)
 				schedule_delayed_work(&tcmu_unmap_work, 0);
 		}
+	} else if (udev->cmd_time_out) {
+		unsigned long deadline;
+		bool is_running;
+		int i;
+
+		deadline = round_jiffies_up(jiffies + msecs_to_jiffies(UINT_MAX));
+		udev->cmd_next_deadline = deadline;
+		idr_for_each_entry(&udev->commands, cmd, i) {
+			is_running = list_empty(&cmd->cmdr_queue_entry);
+			if (is_running && udev->cmd_next_deadline > cmd->deadline)
+				udev->cmd_next_deadline = cmd->deadline;
+		}
+		if (udev->cmd_next_deadline != deadline)
+			mod_timer(&udev->cmd_timer, udev->cmd_next_deadline);
+		else
+			del_timer(&udev->cmd_timer);
 	}
 
 	return handled;
@@ -1261,18 +1281,23 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 {
 	struct tcmu_cmd *cmd = p;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
+	bool is_running = list_empty(&cmd->cmdr_queue_entry);
+	struct se_cmd *se_cmd = cmd->se_cmd;
 	u8 scsi_status;
-	struct se_cmd *se_cmd;
-	bool is_running;
 
 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
 		return 0;
 
-	if (!time_after(jiffies, cmd->deadline))
+	if (!time_after(jiffies, cmd->deadline)) {
+		if (is_running) {
+			if (udev->cmd_next_deadline > cmd->deadline)
+				udev->cmd_next_deadline = cmd->deadline;
+		} else {
+			if (udev->qfull_next_deadline > cmd->deadline)
+				udev->qfull_next_deadline = cmd->deadline;
+		}
 		return 0;
-
-	is_running = list_empty(&cmd->cmdr_queue_entry);
-	se_cmd = cmd->se_cmd;
+	}
 
 	if (is_running) {
 		/*
@@ -2661,11 +2686,22 @@ static void check_timedout_devices(void)
 	list_splice_init(&timed_out_udevs, &devs);
 
 	list_for_each_entry_safe(udev, tmp_dev, &devs, timedout_entry) {
+		unsigned long max_deadline;
+
 		list_del_init(&udev->timedout_entry);
 		spin_unlock_bh(&timed_out_udevs_lock);
 
 		mutex_lock(&udev->cmdr_lock);
+		max_deadline = round_jiffies_up(jiffies + msecs_to_jiffies(UINT_MAX));
+		udev->cmd_next_deadline = max_deadline;
+		udev->qfull_next_deadline = max_deadline;
 		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
+
+		if (udev->cmd_next_deadline != max_deadline)
+			mod_timer(&udev->cmd_timer, udev->cmd_next_deadline);
+		if (udev->qfull_next_deadline != max_deadline)
+			mod_timer(&udev->qfull_timer, udev->qfull_next_deadline);
+
 		mutex_unlock(&udev->cmdr_lock);
 
 		spin_lock_bh(&timed_out_udevs_lock);
-- 
2.19.0.216.g2d3b1c576
