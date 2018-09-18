From: xiubli@redhat.com
Date: Tue, 18 Sep 2018 10:32:55 +0000
Subject: [PATCH] scsi: tcmu: setup one timeout timer for each cmd
Message-Id: <20180918103255.15209-1-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Currently there has one cmd timeout timer for each udev, and whenever
there has any new coming cmd it will update the timer. And for some
corner case the timer is always working only for the ringbuffer's
newest cmd. That's to say the timer won't be fired even there has one
cmd stuck for a very long time.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/target/target_core_user.c | 69 +++++++++++++++----------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9cd404acdb82..ed3d6f055037 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -157,7 +157,6 @@ struct tcmu_dev {
 
 	struct idr commands;
 
-	struct timer_list cmd_timer;
 	unsigned int cmd_time_out;
 
 	struct timer_list qfull_timer;
@@ -190,6 +189,7 @@ struct tcmu_cmd {
 	uint32_t *dbi;
 
 	unsigned long deadline;
+	struct timer_list cmd_timer;
 
 #define TCMU_CMD_BIT_EXPIRED 0
 	unsigned long flags;
@@ -576,6 +576,32 @@ static inline uint32_t tcmu_cmd_get_block_cnt(struct tcmu_cmd *tcmu_cmd)
 	return data_length / DATA_BLOCK_SIZE;
 }
 
+static void tcmu_device_timedout(struct tcmu_dev *udev)
+{
+	spin_lock(&timed_out_udevs_lock);
+	if (list_empty(&udev->timedout_entry))
+		list_add_tail(&udev->timedout_entry, &timed_out_udevs);
+	spin_unlock(&timed_out_udevs_lock);
+
+	schedule_delayed_work(&tcmu_unmap_work, 0);
+}
+
+static void tcmu_cmd_timedout(struct timer_list *t)
+{
+	struct tcmu_cmd *tcmu_cmd = from_timer(tcmu_cmd, t, cmd_timer);
+
+	pr_debug("cmd %hu timeout has expired\n", tcmu_cmd->cmd_id);
+	tcmu_device_timedout(tcmu_cmd->tcmu_dev);
+}
+
+static void tcmu_qfull_timedout(struct timer_list *t)
+{
+	struct tcmu_dev *udev = from_timer(udev, t, qfull_timer);
+
+	pr_debug("%s qfull timeout has expired\n", udev->name);
+	tcmu_device_timedout(udev);
+}
+
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
@@ -599,6 +625,8 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 		return NULL;
 	}
 
+	timer_setup(&tcmu_cmd->cmd_timer, tcmu_cmd_timedout, 0);
+
 	return tcmu_cmd;
 }
 
@@ -1068,7 +1096,7 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 	entry->req.iov_bidi_cnt = iov_cnt;
 
 	ret = tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out,
-				   &udev->cmd_timer);
+				   &tcmu_cmd->cmd_timer);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 
@@ -1230,6 +1258,8 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			break;
 		}
 
+		del_timer(&cmd->cmd_timer);
+
 		tcmu_handle_completion(cmd, entry);
 
 		UPDATE_HEAD(udev->cmdr_last_cleaned,
@@ -1240,9 +1270,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	}
 
 	if (mb->cmd_tail = mb->cmd_head) {
-		/* no more pending commands */
-		del_timer(&udev->cmd_timer);
-
 		if (list_empty(&udev->cmdr_queue)) {
 			/*
 			 * no more pending or waiting commands so try to
@@ -1302,32 +1329,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 	return 0;
 }
 
-static void tcmu_device_timedout(struct tcmu_dev *udev)
-{
-	spin_lock(&timed_out_udevs_lock);
-	if (list_empty(&udev->timedout_entry))
-		list_add_tail(&udev->timedout_entry, &timed_out_udevs);
-	spin_unlock(&timed_out_udevs_lock);
-
-	schedule_delayed_work(&tcmu_unmap_work, 0);
-}
-
-static void tcmu_cmd_timedout(struct timer_list *t)
-{
-	struct tcmu_dev *udev = from_timer(udev, t, cmd_timer);
-
-	pr_debug("%s cmd timeout has expired\n", udev->name);
-	tcmu_device_timedout(udev);
-}
-
-static void tcmu_qfull_timedout(struct timer_list *t)
-{
-	struct tcmu_dev *udev = from_timer(udev, t, qfull_timer);
-
-	pr_debug("%s qfull timeout has expired\n", udev->name);
-	tcmu_device_timedout(udev);
-}
-
 static int tcmu_attach_hba(struct se_hba *hba, u32 host_id)
 {
 	struct tcmu_hba *tcmu_hba;
@@ -1376,7 +1377,6 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	idr_init(&udev->commands);
 
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
-	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
 	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
 
@@ -1950,7 +1950,6 @@ static void tcmu_destroy_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
 
-	del_timer_sync(&udev->cmd_timer);
 	del_timer_sync(&udev->qfull_timer);
 
 	mutex_lock(&root_udev_mutex);
@@ -2006,6 +2005,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			del_timer(&cmd->cmd_timer);
+
 			if (err_level = 1) {
 				/*
 				 * Userspace was not able to start the
@@ -2032,8 +2033,6 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
 
-	del_timer(&udev->cmd_timer);
-
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-- 
2.19.0.216.g2d3b1c576
