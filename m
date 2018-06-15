From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:12 +0000
Subject: [PATCH 03/33] TCMU PR: add functions can get PR info from a dev
Message-Id: <20180615182342.6239-3-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch  added a function tcmu_send_get_pr_info_event() to
get Persistent Reservation info from a TCMU device, added it's
wrapper function tcmu_get_dev_pr_info() as well.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1efc2800ca14..a1ed70d0988a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1683,6 +1683,21 @@ static int tcmu_send_dev_remove_event(struct tcmu_dev *udev)
 				       &skb, &msg_header);
 }
 
+static int tcmu_send_get_pr_info_event(struct tcmu_dev *udev)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_GET_PR_INFO,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+
+	return tcmu_netlink_event_send(udev, TCMU_CMD_GET_PR_INFO,
+				       &skb, &msg_header);
+}
+
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
@@ -1709,6 +1724,22 @@ static int tcmu_update_uio_info(struct tcmu_dev *udev)
 	return 0;
 }
 
+/*
+ * This funtion will get PR INFO(a string)from a TCMU device.
+ * PR INFO will be stored at udev->pr_info.pr_info_buf.
+ */
+static int tcmu_get_dev_pr_info(struct tcmu_dev *udev, int *val_len)
+{
+	int ret = 0;
+
+	ret = tcmu_send_get_pr_info_event(udev);
+	*val_len = strlen(udev->pr_info.pr_info_buf);
+	if (*val_len = 0)
+		ret = -ENODATA;
+
+	return ret;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

