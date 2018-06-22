From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 03:52:39 +0000
Subject: [PATCH 2/3] tcmu: track nl commands
Message-Id: <1529639560-9429-3-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The next patch is going to fix the hung nl command issue
so this adds a list of outstanding nl commands that we
can later abort when the daemon is restarted.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 68 ++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 898a561..73a5768 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -103,9 +103,16 @@ struct tcmu_hba {
 
 #define TCMU_CONFIG_LEN 256
 
+static DEFINE_MUTEX(tcmu_nl_cmd_mutex);
+static LIST_HEAD(tcmu_nl_cmd_list);
+
+struct tcmu_dev;
+
 struct tcmu_nl_cmd {
 	/* wake up thread waiting for reply */
 	struct completion complete;
+	struct list_head nl_list;
+	struct tcmu_dev *udev;
 	int cmd;
 	int status;
 };
@@ -157,7 +164,6 @@ struct tcmu_dev {
 
 	struct list_head timedout_entry;
 
-	spinlock_t nl_cmd_lock;
 	struct tcmu_nl_cmd curr_nl_cmd;
 	/* wake up threads waiting on curr_nl_cmd */
 	wait_queue_head_t nl_cmd_wq;
@@ -270,11 +276,9 @@ static struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX+1] = {
 
 static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 {
-	struct se_device *dev;
-	struct tcmu_dev *udev;
+	struct tcmu_dev *udev = NULL;
 	struct tcmu_nl_cmd *nl_cmd;
 	int dev_id, rc, ret = 0;
-	bool is_removed = (completed_cmd = TCMU_CMD_REMOVED_DEVICE);
 
 	if (!info->attrs[TCMU_ATTR_CMD_STATUS] ||
 	    !info->attrs[TCMU_ATTR_DEVICE_ID]) {
@@ -285,33 +289,36 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	dev_id = nla_get_u32(info->attrs[TCMU_ATTR_DEVICE_ID]);
 	rc = nla_get_s32(info->attrs[TCMU_ATTR_CMD_STATUS]);
 
-	dev = target_find_device(dev_id, !is_removed);
-	if (!dev) {
-		printk(KERN_ERR "tcmu nl cmd %u/%u completion could not find device with dev id %u.\n",
-		       completed_cmd, rc, dev_id);
-		return -ENODEV;
+	mutex_lock(&tcmu_nl_cmd_mutex);
+	list_for_each_entry(nl_cmd, &tcmu_nl_cmd_list, nl_list) {
+		if (nl_cmd->udev->se_dev.dev_index = dev_id) {
+			udev = nl_cmd->udev;
+			break;
+		}
 	}
-	udev = TCMU_DEV(dev);
 
-	spin_lock(&udev->nl_cmd_lock);
-	nl_cmd = &udev->curr_nl_cmd;
+	if (!udev) {
+		pr_err(KERN_ERR "tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
+		       completed_cmd, rc, dev_id);
+		ret = -ENODEV;
+		goto unlock;
+	}
+	list_del(&nl_cmd->nl_list);
 
-	pr_debug("genl cmd done got id %d curr %d done %d rc %d\n", dev_id,
-		 nl_cmd->cmd, completed_cmd, rc);
+	pr_debug("%s genl cmd done got id %d curr %d done %d rc %d\n",
+		 udev->name, dev_id, nl_cmd->cmd, completed_cmd, rc);
 
 	if (nl_cmd->cmd != completed_cmd) {
-		printk(KERN_ERR "Mismatched commands (Expecting reply for %d. Current %d).\n",
-		       completed_cmd, nl_cmd->cmd);
+		pr_err("Mismatched commands on %s (Expecting reply for %d. Current %d).\n",
+		       udev->name, completed_cmd, nl_cmd->cmd);
 		ret = -EINVAL;
-	} else {
-		nl_cmd->status = rc;
+		goto unlock;
 	}
 
-	spin_unlock(&udev->nl_cmd_lock);
-	if (!is_removed)
-		target_undepend_item(&dev->dev_group.cg_item);
-	if (!ret)
-		complete(&nl_cmd->complete);
+	nl_cmd->status = rc;
+	complete(&nl_cmd->complete);
+unlock:
+	mutex_unlock(&tcmu_nl_cmd_mutex);
 	return ret;
 }
 
@@ -1258,7 +1265,6 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
 	init_waitqueue_head(&udev->nl_cmd_wq);
-	spin_lock_init(&udev->nl_cmd_lock);
 
 	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
 
@@ -1544,10 +1550,10 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 		return;
 
 relock:
-	spin_lock(&udev->nl_cmd_lock);
+	mutex_lock(&tcmu_nl_cmd_mutex);
 
 	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
-		spin_unlock(&udev->nl_cmd_lock);
+		mutex_unlock(&tcmu_nl_cmd_mutex);
 		pr_debug("sleeping for open nl cmd\n");
 		wait_event(udev->nl_cmd_wq, (nl_cmd->cmd = TCMU_CMD_UNSPEC));
 		goto relock;
@@ -1555,9 +1561,13 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 
 	memset(nl_cmd, 0, sizeof(*nl_cmd));
 	nl_cmd->cmd = cmd;
+	nl_cmd->udev = udev;
 	init_completion(&nl_cmd->complete);
+	INIT_LIST_HEAD(&nl_cmd->nl_list);
+
+	list_add_tail(&nl_cmd->nl_list, &tcmu_nl_cmd_list);
 
-	spin_unlock(&udev->nl_cmd_lock);
+	mutex_unlock(&tcmu_nl_cmd_mutex);
 }
 
 static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
@@ -1574,11 +1584,11 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	pr_debug("sleeping for nl reply\n");
 	wait_for_completion(&nl_cmd->complete);
 
-	spin_lock(&udev->nl_cmd_lock);
+	mutex_lock(&tcmu_nl_cmd_mutex);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
 	ret = nl_cmd->status;
 	nl_cmd->status = 0;
-	spin_unlock(&udev->nl_cmd_lock);
+	mutex_unlock(&tcmu_nl_cmd_mutex);
 
 	wake_up_all(&udev->nl_cmd_wq);
 
-- 
2.7.2

