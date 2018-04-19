From: Zhu Lingshan <lszhu@suse.com>
Date: Thu, 19 Apr 2018 09:38:19 +0000
Subject: [PATCH v2 2/6] tcmu: refactor add_device cmd with new nl helpers
Message-Id: <20180419093823.3441-2-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

use new netlink events helpers tcmu_netlink_init() and
tcmu_netlink_send() to refactor netlink event
TCMU_CMD_ADDED_DEVICE

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
Changes in V2:
  - return tcmu_netlink_event_send() directly, instead of a ret value.

 drivers/target/target_core_user.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d8f6a53f6bca..52d0e868a192 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1712,6 +1712,21 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
 	return ret;
 }
 
+static int tcmu_send_dev_add_event(struct tcmu_dev *udev)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_ADDED_DEVICE, &skb,
+				      &msg_header);
+	if (ret < 0)
+		return ret;
+	return tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, &skb,
+				       &msg_header);
+
+}
+
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
@@ -1821,7 +1836,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	 */
 	kref_get(&udev->kref);
 
-	ret = tcmu_netlink_event(udev, TCMU_CMD_ADDED_DEVICE, 0, NULL);
+	ret = tcmu_send_dev_add_event(udev);
 	if (ret)
 		goto err_netlink;
 
-- 
2.14.3

