From: Zhu Lingshan <lszhu@suse.com>
Date: Wed, 02 May 2018 03:13:43 +0000
Subject: [RESEND V2 5/6] tcmu: refactor nl dev_size attr with new helpers
Message-Id: <20180502031344.3120-5-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

use new netlink events helpers tcmu_netlink_init() and
tcmu_netlink_send() to refactor netlink event attribute
TCMU_ATTR_DEV_SIZE(belongs to TCMU_CMD_RECONFIG_DEVICE)
which is also dev_size in configFS.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
Changes in V2:
  - return tcmu_netlink_event_send() directly, instead of a ret value.
  
 drivers/target/target_core_user.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 21ce7dd8420d..c5bc2e1a9c49 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2299,6 +2299,26 @@ static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
 	return snprintf(page, PAGE_SIZE, "%zu\n", udev->dev_size);
 }
 
+static int tcmu_send_dev_size_event(struct tcmu_dev *udev, u64 size)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_RECONFIG_DEVICE,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u64_64bit(skb, TCMU_ATTR_DEV_SIZE,
+				size, TCMU_ATTR_PAD);
+	if (ret < 0) {
+		nlmsg_free(skb);
+		return ret;
+	}
+	return tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
+				       &skb, &msg_header);
+}
+
 static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 				   size_t count)
 {
@@ -2314,8 +2334,7 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 
 	/* Check if device has been configured before */
 	if (tcmu_dev_configured(udev)) {
-		ret = tcmu_netlink_event(udev, TCMU_CMD_RECONFIG_DEVICE,
-					 TCMU_ATTR_DEV_SIZE, &val);
+		ret = tcmu_send_dev_size_event(udev, val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
 			return ret;
-- 
2.14.3

