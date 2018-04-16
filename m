From: Zhu Lingshan <lszhu@suse.com>
Date: Mon, 16 Apr 2018 11:04:24 +0000
Subject: [PATCH 2/6] tcmu: refactor add_device cmd with new nl helpers
Message-Id: <20180416110428.5273-2-lszhu@suse.com>
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
 drivers/target/target_core_user.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 98013d359d75..47b73debd9fd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1710,6 +1710,22 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
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
+	ret = tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, &skb,
+				      &msg_header);
+
+	return ret;
+}
+
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
@@ -1819,7 +1835,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	 */
 	kref_get(&udev->kref);
 
-	ret = tcmu_netlink_event(udev, TCMU_CMD_ADDED_DEVICE, 0, NULL);
+	ret = tcmu_send_dev_add_event(udev);
 	if (ret)
 		goto err_netlink;
 
-- 
2.14.3

