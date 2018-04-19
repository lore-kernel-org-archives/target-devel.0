From: Zhu Lingshan <lszhu@suse.com>
Date: Thu, 19 Apr 2018 09:38:20 +0000
Subject: [PATCH v2 3/6] tcmu: refactor rm_device cmd with new nl helpers
Message-Id: <20180419093823.3441-3-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

use new netlink events helpers tcmu_netlink_init() and
tcmu_netlink_send() to refactor netlink event
TCMU_CMD_REMOVED_DEVICE

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
Changes in V2:
  - return tcmu_netlink_event_send() directly, instead of a ret value.

 drivers/target/target_core_user.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 52d0e868a192..24e1f0b3662e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1727,6 +1727,20 @@ static int tcmu_send_dev_add_event(struct tcmu_dev *udev)
 
 }
 
+static int tcmu_send_dev_remove_event(struct tcmu_dev *udev)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_REMOVED_DEVICE,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+	return tcmu_netlink_event_send(udev, TCMU_CMD_REMOVED_DEVICE,
+				       &skb, &msg_header);
+}
+
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
@@ -1886,7 +1900,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 	list_del(&udev->node);
 	mutex_unlock(&root_udev_mutex);
 
-	tcmu_netlink_event(udev, TCMU_CMD_REMOVED_DEVICE, 0, NULL);
+	tcmu_send_dev_remove_event(udev);
 
 	uio_unregister_device(&udev->uio_info);
 
-- 
2.14.3

