From: Mike Christie <mchristi@redhat.com>
Date: Wed, 06 Dec 2017 07:08:19 +0000
Subject: [RFC PATCH 3/3] tcmu: allow userspace to reset ring
Message-Id: <1512544099-7520-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch adds 2 tcmu attrs to block/unblock a device and
reset the ring buffer. They are used when the userspace
daemon has crashed or forced to shutdown while IO is executing.
On restart, the daemon can block the device so new IO is not
sent to userspace while it puts the ring in a clean state.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 162 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 30bd7d8..87efd87 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -121,6 +121,7 @@ struct tcmu_dev {
 
 #define TCMU_DEV_BIT_OPEN 0
 #define TCMU_DEV_BIT_BROKEN 1
+#define TCMU_DEV_BIT_BLOCKED 2
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -801,6 +802,7 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
 	if (tcmu_cmd->cmd_id)
 		goto setup_timer;
 
+
 	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
 	if (cmd_id < 0) {
 		pr_err("tcmu: Could not allocate cmd id.\n");
@@ -875,6 +877,11 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 
 	*scsi_err = TCM_NO_SENSE;
 
+	if (test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags)) {
+		*scsi_err = TCM_LUN_BUSY;
+		return -1;
+	}
+
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
 		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		return -1;
@@ -1260,7 +1267,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_cmdr_queue(struct tcmu_dev *udev)
+static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
@@ -1271,7 +1278,7 @@ static bool run_cmdr_queue(struct tcmu_dev *udev)
 	if (list_empty(&udev->cmdr_queue))
 		return true;
 
-	pr_debug("running %s's cmdr queue\n", udev->name);
+	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
 	list_splice_init(&udev->cmdr_queue, &cmds);
 
@@ -1281,6 +1288,20 @@ static bool run_cmdr_queue(struct tcmu_dev *udev)
 	        pr_debug("removing cmd %u on dev %s from queue\n",
 		         tcmu_cmd->cmd_id, udev->name);
 
+		if (fail) {
+			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+			/*
+			 * We were not able to even start the command, so
+			 * fail with busy to allow a retry in case runner
+			 * was only temporarily down. If the device is being
+			 * removed then LIO core will do the right thing and
+			 * fail the retry.
+			 */
+			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
+			tcmu_free_cmd(tcmu_cmd);
+			continue;
+		}
+
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 		if (ret < 0) {
 		        pr_debug("cmd %u on dev %s failed with %u\n",
@@ -1317,7 +1338,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 	mutex_lock(&udev->cmdr_lock);
 	tcmu_handle_completions(udev);
-	run_cmdr_queue(udev);
+	run_cmdr_queue(udev, false);
 	mutex_unlock(&udev->cmdr_lock);
 
 	return 0;
@@ -1830,6 +1851,78 @@ static void tcmu_destroy_device(struct se_device *dev)
 	kref_put(&udev->kref, tcmu_dev_kref_release);
 }
 
+static void tcmu_unblock_dev(struct tcmu_dev *udev)
+{
+	mutex_lock(&udev->cmdr_lock);
+	clear_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags);
+	mutex_unlock(&udev->cmdr_lock);
+}
+
+static void tcmu_block_dev(struct tcmu_dev *udev)
+{
+	mutex_lock(&udev->cmdr_lock);
+
+	if (test_and_set_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags))
+		goto unlock;
+
+	/* complete IO that has executed successfully */
+	tcmu_handle_completions(udev);
+	/* fail IO waiting to be queued */
+	run_cmdr_queue(udev, true);
+
+unlock:
+	mutex_unlock(&udev->cmdr_lock);
+}
+
+static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+{
+	struct tcmu_mailbox *mb;
+	struct tcmu_cmd *cmd;
+	int i;
+
+	mutex_lock(&udev->cmdr_lock);
+
+	idr_for_each_entry(&udev->commands, cmd, i) {
+		if (!list_empty(&cmd->cmdr_queue_entry))
+			continue;
+
+		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
+			  cmd->cmd_id, udev->name,
+			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
+
+		idr_remove(&udev->commands, i);
+		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			if (err_level = 1) {
+				/*
+				 * Userspace was not able to start the
+				 * command or it is retryable.
+				 */
+				target_complete_cmd(cmd->se_cmd, SAM_STAT_BUSY);
+			} else {
+				/* hard failure */
+				target_complete_cmd(cmd->se_cmd,
+						    SAM_STAT_CHECK_CONDITION);
+			}
+		}
+		tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
+		tcmu_free_cmd(cmd);
+	}
+
+	mb = udev->mb_addr;
+	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	pr_debug("mb last %u head %u tail %u\n", udev->cmdr_last_cleaned,
+		 mb->cmd_tail, mb->cmd_head);
+
+	udev->cmdr_last_cleaned = 0;
+	mb->cmd_tail = 0;
+	mb->cmd_head = 0;
+	tcmu_flush_dcache_range(mb, sizeof(*mb));
+
+	del_timer(&udev->cmd_timer);
+
+	mutex_unlock(&udev->cmdr_lock);
+}
+
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
 	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_err,
@@ -2221,6 +2314,67 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_block_dev_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	if (test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags))
+		return snprintf(page, PAGE_SIZE, "%s\n", "blocked");
+	else
+		return snprintf(page, PAGE_SIZE, "%s\n", "unblocked");
+}
+
+static ssize_t tcmu_block_dev_store(struct config_item *item, const char *page,
+				    size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val > 1) {
+		pr_err("Invalid block value %d\n", val);
+		return -EINVAL;
+	}
+
+	if (!val)
+		tcmu_unblock_dev(udev);
+	else
+		tcmu_block_dev(udev);
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, block_dev);
+
+static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
+				     size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val != 1 && val != 2) {
+		pr_err("Invalid reset ring value %d\n", val);
+		return -EINVAL;
+	}
+
+	tcmu_reset_ring(udev, val);
+	return count;
+}
+CONFIGFS_ATTR_WO(tcmu_, reset_ring);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
@@ -2229,6 +2383,8 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	&tcmu_attr_nl_reply_supported,
+	&tcmu_attr_block_dev,
+	&tcmu_attr_reset_ring,
 	NULL,
 };
 
-- 
2.7.2

