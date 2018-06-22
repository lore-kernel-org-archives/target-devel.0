From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 03:52:40 +0000
Subject: [PATCH 3/3] tcmu: add module wide block/reset_netlink support
Message-Id: <1529639560-9429-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch based on Xiubo's patches adds 2 tcmu attr to block and
resetup the netlink interface. It's used during userspace daemon
reinitialization after the daemon has crashed while there is
outstanding nl requests. The daemon can block the nl interface,
kill outstanding requests in the kernel and then reopen the
netlink socket and unblock it to allow new requests.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 115 +++++++++++++++++++++++++++++++++++---
 1 file changed, 107 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 73a5768..0b2491d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -94,6 +94,7 @@
 #define TCMU_GLOBAL_MAX_BLOCKS_DEF (512 * 1024)
 
 static u8 tcmu_kern_cmd_reply_supported;
+static u8 tcmu_netlink_blocked;
 
 static struct device *tcmu_root_device;
 
@@ -257,6 +258,92 @@ MODULE_PARM_DESC(global_max_data_area_mb,
 		 "Max MBs allowed to be allocated to all the tcmu device's "
 		 "data areas.");
 
+static int tcmu_get_block_netlink(char *buffer,
+				  const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%s\n", tcmu_netlink_blocked ?
+		       "blocked" : "unblocked");
+}
+
+static int tcmu_set_block_netlink(const char *str,
+				  const struct kernel_param *kp)
+{
+	int ret;
+	u8 val;
+
+	ret = kstrtou8(str, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val > 1 || val < 0) {
+		pr_err("Invalid block netlink value %u\n", val);
+		return -EINVAL;
+	}
+
+	tcmu_netlink_blocked = val;
+	return 0;
+}
+
+static const struct kernel_param_ops tcmu_block_netlink_op = {
+	.set = tcmu_set_block_netlink,
+	.get = tcmu_get_block_netlink,
+};
+
+module_param_cb(block_netlink, &tcmu_block_netlink_op, NULL, S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(block_netlink, "Block new netlink commands.");
+
+static int tcmu_fail_netlink_cmd(struct tcmu_nl_cmd *nl_cmd)
+{
+	struct tcmu_dev *udev = nl_cmd->udev;
+
+	if (!tcmu_netlink_blocked) {
+		pr_err("Could not reset device's netlink interface. Netlink is not blocked.\n");
+		return -EBUSY;
+	}
+
+	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
+		pr_debug("Aborting nl cmd %d on %s\n", nl_cmd->cmd, udev->name);
+		nl_cmd->status = -EINTR;
+		list_del(&nl_cmd->nl_list);
+		complete(&nl_cmd->complete);
+	}
+	return 0;
+}
+
+static int tcmu_set_reset_netlink(const char *str,
+				  const struct kernel_param *kp)
+{
+	struct tcmu_nl_cmd *nl_cmd, *tmp_cmd;
+	int ret;
+	u8 val;
+
+	ret = kstrtou8(str, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val != 1) {
+		pr_err("Invalid reset netlink value %u\n", val);
+		return -EINVAL;
+	}
+
+	mutex_lock(&tcmu_nl_cmd_mutex);
+	list_for_each_entry_safe(nl_cmd, tmp_cmd, &tcmu_nl_cmd_list, nl_list) {
+		ret = tcmu_fail_netlink_cmd(nl_cmd);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&tcmu_nl_cmd_mutex);
+
+	return ret;
+}
+
+static const struct kernel_param_ops tcmu_reset_netlink_op = {
+	.set = tcmu_set_reset_netlink,
+};
+
+module_param_cb(reset_netlink, &tcmu_reset_netlink_op, NULL, S_IWUSR);
+MODULE_PARM_DESC(reset_netlink, "Reset netlink commands.");
+
 /* multicast group */
 enum tcmu_multicast_groups {
 	TCMU_MCGRP_CONFIG,
@@ -305,8 +392,9 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	}
 	list_del(&nl_cmd->nl_list);
 
-	pr_debug("%s genl cmd done got id %d curr %d done %d rc %d\n",
-		 udev->name, dev_id, nl_cmd->cmd, completed_cmd, rc);
+	pr_debug("%s genl cmd done got id %d curr %d done %d rc %d stat %d\n",
+		 udev->name, dev_id, nl_cmd->cmd, completed_cmd, rc,
+		 nl_cmd->status);
 
 	if (nl_cmd->cmd != completed_cmd) {
 		pr_err("Mismatched commands on %s (Expecting reply for %d. Current %d).\n",
@@ -1539,19 +1627,26 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
 	return 0;
 }
 
-static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
+static int tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 {
 	struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
 
 	if (!tcmu_kern_cmd_reply_supported)
-		return;
+		return 0;
 
 	if (udev->nl_reply_supported <= 0)
-		return;
+		return 0;
 
 relock:
 	mutex_lock(&tcmu_nl_cmd_mutex);
 
+	if (tcmu_netlink_blocked) {
+		mutex_unlock(&tcmu_nl_cmd_mutex);
+		pr_warn("Failing nl cmd %d on %s. Interface is blocked.\n", cmd,
+			udev->name);
+		return -EAGAIN;
+	}
+
 	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
 		mutex_unlock(&tcmu_nl_cmd_mutex);
 		pr_debug("sleeping for open nl cmd\n");
@@ -1568,6 +1663,7 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 	list_add_tail(&nl_cmd->nl_list, &tcmu_nl_cmd_list);
 
 	mutex_unlock(&tcmu_nl_cmd_mutex);
+	return 0;
 }
 
 static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
@@ -1587,7 +1683,6 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	mutex_lock(&tcmu_nl_cmd_mutex);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
 	ret = nl_cmd->status;
-	nl_cmd->status = 0;
 	mutex_unlock(&tcmu_nl_cmd_mutex);
 
 	wake_up_all(&udev->nl_cmd_wq);
@@ -1642,11 +1737,15 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 
 	genlmsg_end(skb, msg_header);
 
-	tcmu_init_genl_cmd_reply(udev, cmd);
+	ret = tcmu_init_genl_cmd_reply(udev, cmd);
+	if (ret) {
+		nlmsg_free(skb);
+		return ret;
+	}
 
 	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
 				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
-       /* We don't care if no one is listening */
+	/* We don't care if no one is listening */
 	if (ret = -ESRCH)
 		ret = 0;
 	if (!ret)
-- 
2.7.2

