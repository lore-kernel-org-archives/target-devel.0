From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:13 +0000
Subject: [PATCH 04/33] TCMU PR: add functions can store PR info into devs
Message-Id: <20180615182342.6239-4-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_send_set_pr_info_event() to
store Persistent Reservation information into a TCMU
device (for example, if we use a RBD device, the information
will be stored in it's metadata), added it's wrapper function
tcmu_set_dev_pr_info() as well.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a1ed70d0988a..d368c656ef79 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1698,6 +1698,26 @@ static int tcmu_send_get_pr_info_event(struct tcmu_dev *udev)
 				       &skb, &msg_header);
 }
 
+static int tcmu_send_set_pr_info_event(struct tcmu_dev *udev, char *buf)
+{
+	struct sk_buff *skb = NULL;
+	void *msg_header = NULL;
+	int ret = 0;
+
+	ret = tcmu_netlink_event_init(udev, TCMU_CMD_SET_PR_INFO,
+				      &skb, &msg_header);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_string(skb, TCMU_ATTR_PR_INFO, buf);
+	if (ret < 0) {
+		nlmsg_free(skb);
+		return ret;
+	}
+
+	return tcmu_netlink_event_send(udev, TCMU_CMD_SET_PR_INFO,
+				       &skb, &msg_header);
+}
+
 static int tcmu_update_uio_info(struct tcmu_dev *udev)
 {
 	struct tcmu_hba *hba = udev->hba->hba_ptr;
@@ -1740,6 +1760,15 @@ static int tcmu_get_dev_pr_info(struct tcmu_dev *udev, int *val_len)
 	return ret;
 }
 
+/*
+ * This function will store PR INFO(a string) to a TCMU
+ * device metadata.
+ */
+static int tcmu_set_dev_pr_info(struct tcmu_dev *udev, void *val)
+{
+	return tcmu_send_set_pr_info_event(udev, val);
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

