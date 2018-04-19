From: xiubli@redhat.com
Date: Thu, 19 Apr 2018 07:46:04 +0000
Subject: [PATCHv4 3/3] tcmu: add module wide action/reset_netlink support
Message-Id: <1524123964-21347-4-git-send-email-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch adds 1 tcmu attr to reset and complete all the blocked
netlink waiting threads. It's used when the userspace daemon like
tcmu-runner has crashed or forced to shutdown just before the
netlink requests be replied to the kernel, then the netlink requeting
threads will get stuck forever. We must reboot the machine to recover
from it and by this the rebootng is not a must then.

The Call Trace will be something like:
=======
INFO: task targetctl:22655 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
targetctl       D ffff880169718fd0     0 22655  17249 0x00000080
Call Trace:
 [<ffffffff816ab6d9>] schedule+0x29/0x70
 [<ffffffff816a90e9>] schedule_timeout+0x239/0x2c0
 [<ffffffff81574d42>] ? skb_release_data+0xf2/0x140
 [<ffffffff816aba8d>] wait_for_completion+0xfd/0x140
 [<ffffffff810c6440>] ? wake_up_state+0x20/0x20
 [<ffffffffc0159f5a>] tcmu_netlink_event+0x26a/0x3a0 [target_core_user]
 [<ffffffff810b34b0>] ? wake_up_atomic_t+0x30/0x30
 [<ffffffffc015a2c6>] tcmu_configure_device+0x236/0x350 [target_core_user]
 [<ffffffffc05085df>] target_configure_device+0x3f/0x3b0 [target_core_mod]
 [<ffffffffc0502e7c>] target_core_store_dev_enable+0x2c/0x60 [target_core_mod]
 [<ffffffffc0501244>] target_core_dev_store+0x24/0x40 [target_core_mod]
 [<ffffffff8128a0e4>] configfs_write_file+0xc4/0x130
 [<ffffffff81202aed>] vfs_write+0xbd/0x1e0
 [<ffffffff812038ff>] SyS_write+0x7f/0xe0
 [<ffffffff816b89fd>] system_call_fastpath+0x16/0x1b
=======

Be careful of using this, it could reset the normal netlink requesting
operations, so we should use this only when the user space daemon from
starting and just before the daemon could receive and handle the nl
requests.

Changes since v1(suggested by Mike Christie):
v2: - Makes the reset per device.
v3: - Remove nl_cmd->complete, use status instead
    - Fix lock issue
    - Check if a nl command is even waiting before trying to wake up
v4: - Add module wide action support and make the reset netlink for the
      module wide

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/target/target_core_user.c | 77 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4ad89ea..f520933 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -96,6 +96,7 @@
 static u8 tcmu_kern_cmd_reply_supported;
 
 static struct device *tcmu_root_device;
+static struct target_backend_ops tcmu_ops;
 
 struct tcmu_hba {
 	u32 host_id;
@@ -104,8 +105,7 @@ struct tcmu_hba {
 #define TCMU_CONFIG_LEN 256
 
 struct tcmu_nl_cmd {
-	/* wake up thread waiting for reply */
-	struct completion complete;
+	unsigned int waiter;
 	int cmd;
 	int status;
 };
@@ -159,9 +159,12 @@ struct tcmu_dev {
 
 	spinlock_t nl_cmd_lock;
 	struct tcmu_nl_cmd curr_nl_cmd;
-	/* wake up threads waiting on curr_nl_cmd */
+	/* wake up threads waiting on nl_cmd_wq */
 	wait_queue_head_t nl_cmd_wq;
 
+	/* complete thread waiting complete_wq */
+	wait_queue_head_t complete_wq;
+
 	char dev_config[TCMU_CONFIG_LEN];
 
 	int nl_reply_supported;
@@ -307,11 +310,14 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 		nl_cmd->status = rc;
 	}
 
-	spin_unlock(&udev->nl_cmd_lock);
 	if (!is_removed)
 		 target_undepend_item(&dev->dev_group.cg_item);
-	if (!ret)
-		complete(&nl_cmd->complete);
+	if (!ret && nl_cmd->waiter) {
+		nl_cmd->waiter--;
+		wake_up(&udev->complete_wq);
+	}
+	spin_unlock(&udev->nl_cmd_lock);
+
 	return ret;
 }
 
@@ -1258,6 +1264,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
 	init_waitqueue_head(&udev->nl_cmd_wq);
+	init_waitqueue_head(&udev->complete_wq);
 	spin_lock_init(&udev->nl_cmd_lock);
 
 	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
@@ -1555,7 +1562,7 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 
 	memset(nl_cmd, 0, sizeof(*nl_cmd));
 	nl_cmd->cmd = cmd;
-	init_completion(&nl_cmd->complete);
+	nl_cmd->status = 1;
 
 	spin_unlock(&udev->nl_cmd_lock);
 }
@@ -1572,13 +1579,16 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	if (udev->nl_reply_supported <= 0)
 		return 0;
 
+	spin_lock(&udev->nl_cmd_lock);
+	nl_cmd->waiter++;
+	spin_unlock(&udev->nl_cmd_lock);
+
 	pr_debug("sleeping for nl reply\n");
-	wait_for_completion(&nl_cmd->complete);
+	wait_event(udev->complete_wq, nl_cmd->status != 1);
 
 	spin_lock(&udev->nl_cmd_lock);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
 	ret = nl_cmd->status;
-	nl_cmd->status = 0;
 	spin_unlock(&udev->nl_cmd_lock);
 
 	wake_up_all(&udev->nl_cmd_wq);
@@ -2366,6 +2376,54 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 	NULL,
 };
 
+static int tcmu_complete_wake_up_iter(struct se_device *se_dev, void *data)
+{
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	struct tcmu_nl_cmd *nl_cmd;
+
+	if (se_dev->transport != &tcmu_ops)
+		return 0;
+
+	spin_lock(&udev->nl_cmd_lock);
+	nl_cmd = &udev->curr_nl_cmd;
+	if (nl_cmd->waiter) {
+		nl_cmd->waiter--;
+		nl_cmd->status = -EINTR;
+		wake_up(&udev->complete_wq);
+	}
+	spin_unlock(&udev->nl_cmd_lock);
+
+	return 0;
+}
+
+static ssize_t tcmu_reset_netlink_store(struct config_item *item, const char *page,
+				    size_t count)
+{
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val != 1) {
+		pr_err("Invalid block value %d\n", val);
+		return -EINVAL;
+	}
+
+	ret = target_for_each_device(tcmu_complete_wake_up_iter, NULL);
+	if (ret)
+		return ret;
+
+	return count;
+}
+CONFIGFS_ATTR_WO(tcmu_, reset_netlink);
+
+static struct configfs_attribute *tcmu_mod_action_attrs[] = {
+	&tcmu_attr_reset_netlink,
+	NULL,
+};
+
 static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
@@ -2382,6 +2440,7 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 	.get_device_type	= sbc_get_device_type,
 	.get_blocks		= tcmu_get_blocks,
 	.tb_dev_action_attrs	= tcmu_action_attrs,
+	.tb_mod_action_attrs	= tcmu_mod_action_attrs,
 };
 
 static void find_free_blocks(void)
-- 
1.8.3.1

