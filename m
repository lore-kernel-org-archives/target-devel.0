From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 21:40:20 +0000
Subject: [PATCH 3/6] tcmu: simplify nl interface
Message-Id: <1529703623-9606-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Just return EBUSY if a nl request comes in while processing
one. The upper layers do not support sending multiple create/remove
requests at the same time (you cannot have a create and remove at the
same time or do multiple creates or removes at the same time) and doing
a reconfig while a create/remove is still executing does not make sense.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 73a5768..9835ea3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -165,8 +165,6 @@ struct tcmu_dev {
 	struct list_head timedout_entry;
 
 	struct tcmu_nl_cmd curr_nl_cmd;
-	/* wake up threads waiting on curr_nl_cmd */
-	wait_queue_head_t nl_cmd_wq;
 
 	char dev_config[TCMU_CONFIG_LEN];
 
@@ -1264,8 +1262,6 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
-	init_waitqueue_head(&udev->nl_cmd_wq);
-
 	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
 
 	return &udev->se_dev;
@@ -1539,24 +1535,23 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
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
 
-relock:
 	mutex_lock(&tcmu_nl_cmd_mutex);
 
 	if (nl_cmd->cmd != TCMU_CMD_UNSPEC) {
 		mutex_unlock(&tcmu_nl_cmd_mutex);
-		pr_debug("sleeping for open nl cmd\n");
-		wait_event(udev->nl_cmd_wq, (nl_cmd->cmd = TCMU_CMD_UNSPEC));
-		goto relock;
+		pr_warn("netlink cmd %d already executing on %s\n",
+			 nl_cmd->cmd, udev->name);
+		return -EBUSY;
 	}
 
 	memset(nl_cmd, 0, sizeof(*nl_cmd));
@@ -1568,6 +1563,7 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
 	list_add_tail(&nl_cmd->nl_list, &tcmu_nl_cmd_list);
 
 	mutex_unlock(&tcmu_nl_cmd_mutex);
+	return 0;
 }
 
 static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
@@ -1590,8 +1586,6 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	nl_cmd->status = 0;
 	mutex_unlock(&tcmu_nl_cmd_mutex);
 
-	wake_up_all(&udev->nl_cmd_wq);
-
 	return ret;
 }
 
@@ -1642,7 +1636,11 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 
 	genlmsg_end(skb, msg_header);
 
-	tcmu_init_genl_cmd_reply(udev, cmd);
+	ret = tcmu_init_genl_cmd_reply(udev, cmd);
+	if (ret) {
+		nlmsg_free(skb);
+		return ret;
+	}
 
 	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
 				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
-- 
2.7.2

