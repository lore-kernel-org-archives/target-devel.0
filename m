From: xiubli@redhat.com
Date: Wed, 17 Oct 2018 07:54:36 +0000
Subject: [PATCH v3] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <20181017075436.2323-1-xiubli@redhat.com>
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

Changed in V3:
- Add inflight queue support, thanks Mike.

Changed in V2:
- Add qfull timer
- Addressed all the comments from Mike, thanks.

 drivers/target/target_core_user.c | 89 ++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9cd404a..00ed7bb 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -148,7 +148,7 @@ struct tcmu_dev {
 	size_t ring_size;
 
 	struct mutex cmdr_lock;
-	struct list_head cmdr_queue;
+	struct list_head cmdr_qfull_queue;
 
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
@@ -159,6 +159,7 @@ struct tcmu_dev {
 
 	struct timer_list cmd_timer;
 	unsigned int cmd_time_out;
+	struct list_head cmdr_inflight_queue;
 
 	struct timer_list qfull_timer;
 	int qfull_time_out;
@@ -192,6 +193,7 @@ struct tcmu_cmd {
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
+#define TCMU_CMD_BIT_INFLIGHT 1
 	unsigned long flags;
 };
 /*
@@ -915,11 +917,13 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
 		return 0;
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
-	mod_timer(timer, tcmu_cmd->deadline);
+	if (!timer_pending(timer))
+		mod_timer(timer, tcmu_cmd->deadline);
+
 	return 0;
 }
 
-static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
+static int add_to_cmdr_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	unsigned int tmo;
@@ -942,7 +946,7 @@ static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
 	if (ret)
 		return ret;
 
-	list_add_tail(&tcmu_cmd->cmdr_queue_entry, &udev->cmdr_queue);
+	list_add_tail(&tcmu_cmd->cmdr_queue_entry, &udev->cmdr_qfull_queue);
 	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
 		 tcmu_cmd->cmd_id, udev->name);
 	return 0;
@@ -999,7 +1003,7 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
-	if (!list_empty(&udev->cmdr_queue))
+	if (!list_empty(&udev->cmdr_qfull_queue))
 		goto queue;
 
 	mb = udev->mb_addr;
@@ -1096,13 +1100,16 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
 
+	list_add_tail(&tcmu_cmd->cmdr_queue_entry, &udev->cmdr_inflight_queue);
+	set_bit(TCMU_CMD_BIT_INFLIGHT, &tcmu_cmd->flags);
+
 	/* TODO: only if FLUSH and FUA? */
 	uio_event_notify(&udev->uio_info);
 
 	return 0;
 
 queue:
-	if (add_to_cmdr_queue(tcmu_cmd)) {
+	if (add_to_cmdr_qfull_queue(tcmu_cmd)) {
 		*scsi_err = TCM_OUT_OF_RESOURCES;
 		return -1;
 	}
@@ -1194,9 +1201,22 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	tcmu_free_cmd(cmd);
 }
 
+static unsigned long tcmu_get_next_deadline(struct list_head *queue)
+{
+	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
+
+	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, queue, cmdr_queue_entry) {
+		if (!time_after(jiffies, tcmu_cmd->deadline))
+			return tcmu_cmd->deadline;
+	}
+
+	return 0;
+}
+
 static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
+	struct tcmu_cmd *cmd;
 	int handled = 0;
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
@@ -1210,7 +1230,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	while (udev->cmdr_last_cleaned != READ_ONCE(mb->cmd_tail)) {
 
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
-		struct tcmu_cmd *cmd;
 
 		tcmu_flush_dcache_range(entry, sizeof(*entry));
 
@@ -1230,6 +1249,9 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			break;
 		}
 
+		clear_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
+		list_del_init(&cmd->cmdr_queue_entry);
+
 		tcmu_handle_completion(cmd, entry);
 
 		UPDATE_HEAD(udev->cmdr_last_cleaned,
@@ -1243,7 +1265,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		/* no more pending commands */
 		del_timer(&udev->cmd_timer);
 
-		if (list_empty(&udev->cmdr_queue)) {
+		if (list_empty(&udev->cmdr_qfull_queue)) {
 			/*
 			 * no more pending or waiting commands so try to
 			 * reclaim blocks if needed.
@@ -1252,6 +1274,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			    tcmu_global_max_blocks)
 				schedule_delayed_work(&tcmu_unmap_work, 0);
 		}
+	} else if (udev->cmd_time_out) {
+		unsigned long deadline;
+
+		deadline = tcmu_get_next_deadline(&udev->cmdr_inflight_queue);
+		if (deadline)
+			mod_timer(&udev->cmd_timer, deadline);
+		else
+			del_timer(&udev->cmd_timer);
 	}
 
 	return handled;
@@ -1271,7 +1301,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 	if (!time_after(jiffies, cmd->deadline))
 		return 0;
 
-	is_running = list_empty(&cmd->cmdr_queue_entry);
+	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
 	se_cmd = cmd->se_cmd;
 
 	if (is_running) {
@@ -1289,7 +1319,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 	} else {
 		list_del_init(&cmd->cmdr_queue_entry);
-
 		idr_remove(&udev->commands, id);
 		tcmu_free_cmd(cmd);
 		scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -1372,7 +1401,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 
 	INIT_LIST_HEAD(&udev->node);
 	INIT_LIST_HEAD(&udev->timedout_entry);
-	INIT_LIST_HEAD(&udev->cmdr_queue);
+	INIT_LIST_HEAD(&udev->cmdr_qfull_queue);
+	INIT_LIST_HEAD(&udev->cmdr_inflight_queue);
 	idr_init(&udev->commands);
 
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
@@ -1383,20 +1413,21 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
+static bool run_cmdr_qfull_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
 	bool drained = true;
 	sense_reason_t scsi_ret;
+	unsigned long deadline;
 	int ret;
 
-	if (list_empty(&udev->cmdr_queue))
+	if (list_empty(&udev->cmdr_qfull_queue))
 		return true;
 
 	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
-	list_splice_init(&udev->cmdr_queue, &cmds);
+	list_splice_init(&udev->cmdr_qfull_queue, &cmds);
 
 	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, cmdr_queue_entry) {
 		list_del_init(&tcmu_cmd->cmdr_queue_entry);
@@ -1437,13 +1468,18 @@ static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
 			 * cmd was requeued, so just put all cmds back in
 			 * the queue
 			 */
-			list_splice_tail(&cmds, &udev->cmdr_queue);
+			list_splice_tail(&cmds, &udev->cmdr_qfull_queue);
 			drained = false;
 			goto done;
 		}
 	}
-	if (list_empty(&udev->cmdr_queue))
+
+	deadline = tcmu_get_next_deadline(&udev->cmdr_qfull_queue);
+	if (deadline)
+		mod_timer(&udev->qfull_timer, deadline);
+	else
 		del_timer(&udev->qfull_timer);
+
 done:
 	return drained;
 }
@@ -1454,7 +1490,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 	mutex_lock(&udev->cmdr_lock);
 	tcmu_handle_completions(udev);
-	run_cmdr_queue(udev, false);
+	run_cmdr_qfull_queue(udev, false);
 	mutex_unlock(&udev->cmdr_lock);
 
 	return 0;
@@ -1982,7 +2018,7 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
 	/* complete IO that has executed successfully */
 	tcmu_handle_completions(udev);
 	/* fail IO waiting to be queued */
-	run_cmdr_queue(udev, true);
+	run_cmdr_qfull_queue(udev, true);
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
@@ -1997,7 +2033,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (!list_empty(&cmd->cmdr_queue_entry))
+		if (!test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags))
 			continue;
 
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
@@ -2661,11 +2697,26 @@ static void check_timedout_devices(void)
 	list_splice_init(&timed_out_udevs, &devs);
 
 	list_for_each_entry_safe(udev, tmp_dev, &devs, timedout_entry) {
+		unsigned long deadline;
+
 		list_del_init(&udev->timedout_entry);
 		spin_unlock_bh(&timed_out_udevs_lock);
 
 		mutex_lock(&udev->cmdr_lock);
 		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
+
+		deadline = tcmu_get_next_deadline(&udev->cmdr_inflight_queue);
+		if (deadline)
+			mod_timer(&udev->cmd_timer, deadline);
+		else
+			del_timer(&udev->cmd_timer);
+
+		deadline = tcmu_get_next_deadline(&udev->cmdr_qfull_queue);
+		if (deadline)
+			mod_timer(&udev->qfull_timer, deadline);
+		else
+			del_timer(&udev->qfull_timer);
+
 		mutex_unlock(&udev->cmdr_lock);
 
 		spin_lock_bh(&timed_out_udevs_lock);
-- 
1.8.3.1
