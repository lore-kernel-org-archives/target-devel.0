From: Zhu Lingshan <lszhu@suse.com>
Date: Thu, 19 Apr 2018 09:38:21 +0000
Subject: [PATCH v2 4/6] tcmu: refactor nl dev_cfg attr with new nl helpers
Message-Id: <20180419093823.3441-4-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

use new netlink events helpers tcmu_netlink_init() and
tcmu_netlink_send() to refactor netlink event attribute
TCMU_ATTR_DEV_CFG(belongs to TCMU_CMD_RECONFIG_DEVICE)
which is also dev_config in configFS.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
Changes in V2:
  - return tcmu_netlink_event_send() directly, instead of a ret value.

 drivers/target/target_core_user.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 24e1f0b3662e..21ce7dd8420d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2237,6 +2237,27 @@ static ssize_t tcmu_dev_config_show(struct config_item *item, char *page)
 	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_config);
 }
 
+static int tcmu_send_dev_config_event(struct tcmu_dev *udev,
+				      const char *reconfig_data)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_RECONFIG_DEVICE,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_string(skb, TCMU_ATTR_DEV_CFG, reconfig_data);
+	if (ret < 0) {
+		nlmsg_free(skb);
+		return ret;
+	}
+	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
+				       &skb, &msg_header);
+}
+
+
 static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
 				     size_t count)
 {
@@ -2251,8 +2272,7 @@ static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
 
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
-		ret = tcmu_netlink_event(udev, TCMU_CMD_RECONFIG_DEVICE,
-					 TCMU_ATTR_DEV_CFG, page);
+		ret = tcmu_send_dev_config_event(udev, page);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
-- 
2.14.3

