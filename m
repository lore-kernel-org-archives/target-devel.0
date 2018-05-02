From: Zhu Lingshan <lszhu@suse.com>
Date: Wed, 02 May 2018 03:13:44 +0000
Subject: [RESEND V2 6/6] tcmu: refactor nl wr_cache attr with new helpers
Message-Id: <20180502031344.3120-6-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

use new netlink events helpers tcmu_netlink_init() and
tcmu_netlink_send() to refactor netlink event attribute
TCMU_ATTR_WRITECACHE(belongs to TCMU_CMD_RECONFIG_DEVICE)
which is also emulate_write_cache in configFS.

Removed tcmu_netlink_event() since we have new netlink
events helpers now.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
Changes in V2:
  - return tcmu_netlink_event_send() directly, instead of a ret value.

 drivers/target/target_core_user.c | 89 +++++++++------------------------------
 1 file changed, 20 insertions(+), 69 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c5bc2e1a9c49..5e7bb69488e1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1586,73 +1586,6 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	return ret;
 }
 
-static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
-			      int reconfig_attr, const void *reconfig_data)
-{
-	struct sk_buff *skb;
-	void *msg_header;
-	int ret = -ENOMEM;
-
-	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb)
-		return ret;
-
-	msg_header = genlmsg_put(skb, 0, 0, &tcmu_genl_family, 0, cmd);
-	if (!msg_header)
-		goto free_skb;
-
-	ret = nla_put_string(skb, TCMU_ATTR_DEVICE, udev->uio_info.name);
-	if (ret < 0)
-		goto free_skb;
-
-	ret = nla_put_u32(skb, TCMU_ATTR_MINOR, udev->uio_info.uio_dev->minor);
-	if (ret < 0)
-		goto free_skb;
-
-	ret = nla_put_u32(skb, TCMU_ATTR_DEVICE_ID, udev->se_dev.dev_index);
-	if (ret < 0)
-		goto free_skb;
-
-	if (cmd = TCMU_CMD_RECONFIG_DEVICE) {
-		switch (reconfig_attr) {
-		case TCMU_ATTR_DEV_CFG:
-			ret = nla_put_string(skb, reconfig_attr, reconfig_data);
-			break;
-		case TCMU_ATTR_DEV_SIZE:
-			ret = nla_put_u64_64bit(skb, reconfig_attr,
-						*((u64 *)reconfig_data),
-						TCMU_ATTR_PAD);
-			break;
-		case TCMU_ATTR_WRITECACHE:
-			ret = nla_put_u8(skb, reconfig_attr,
-					  *((u8 *)reconfig_data));
-			break;
-		default:
-			BUG();
-		}
-
-		if (ret < 0)
-			goto free_skb;
-	}
-
-	genlmsg_end(skb, msg_header);
-
-	tcmu_init_genl_cmd_reply(udev, cmd);
-
-	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
-				TCMU_MCGRP_CONFIG, GFP_KERNEL);
-	/* We don't care if no one is listening */
-	if (ret = -ESRCH)
-		ret = 0;
-	if (!ret)
-		ret = tcmu_wait_genl_cmd_reply(udev);
-
-	return ret;
-free_skb:
-	nlmsg_free(skb);
-	return ret;
-}
-
 static int tcmu_netlink_event_init(struct tcmu_dev *udev,
 				   enum tcmu_genl_cmd cmd,
 				   struct sk_buff **buf, void **hdr)
@@ -2382,6 +2315,25 @@ static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
 	return snprintf(page, PAGE_SIZE, "%i\n", da->emulate_write_cache);
 }
 
+static int tcmu_send_emulate_write_cache(struct tcmu_dev *udev, u8 val)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_RECONFIG_DEVICE,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u8(skb, TCMU_ATTR_WRITECACHE, val);
+	if (ret < 0) {
+		nlmsg_free(skb);
+		return ret;
+	}
+	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
+				       &skb, &msg_header);
+}
+
 static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 					      const char *page, size_t count)
 {
@@ -2397,8 +2349,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
-		ret = tcmu_netlink_event(udev, TCMU_CMD_RECONFIG_DEVICE,
-					 TCMU_ATTR_WRITECACHE, &val);
+		ret = tcmu_send_emulate_write_cache(udev, val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
-- 
2.14.3

