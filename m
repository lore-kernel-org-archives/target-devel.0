From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:30 +0000
Subject: [PATCH 21/33] TCMU PR: add a func to update PR info on TCMU dev
Message-Id: <20180615182342.6239-21-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch  added a function tcmu_pr_info_replace() which can
help update Persistent Reservation information stored on a
TCMU device. It will generate a new string based on the provided
struct tcmu_pr_info struct, then write it to the device.For example,
If we are using RBD, it will update PR info to RBD meatada.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4b426a9061b1..559e0d40d63b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -111,6 +111,8 @@
 /* don't allow encoded PR info to exceed 8K */
 #define TCMU_PR_INFO_XATTR_MAX_SIZE 8192
 
+#define TCMU_PR_REG_MAX_RETRIES		5
+
 #define TCMU_PR_INFO_XATTR_ENCODED_SCSI2_RSV_MAXLEN		\
 	(TCMU_PR_IT_NEXUS_MAXLEN + sizeof("\n"))
 
@@ -2648,6 +2650,47 @@ tcmu_execute_pr_register_existing(struct tcmu_pr_info *pr_info,
 	return ret;
 }
 
+static int tcmu_pr_info_replace(struct tcmu_dev *udev,
+				char *pr_xattr_old, int pr_xattr_len_old,
+				struct tcmu_pr_info *pr_info_new)
+{
+	int rc;
+	char *pr_xattr_new = NULL;
+	int pr_xattr_len_new = 0;
+
+	WARN_ON(!pr_xattr_old || !pr_info_new);
+
+	/* bump seqnum prior to xattr write. Not rolled back on failure */
+	pr_info_new->seq++;
+	rc = tcmu_pr_info_encode(pr_info_new, &pr_xattr_new,
+				 &pr_xattr_len_new);
+
+	if (rc) {
+		pr_err("failed to encode PR xattr: %d\n", rc);
+		return rc;
+	}
+
+	if (pr_xattr_len_new > TCMU_PR_INFO_XATTR_MAX_SIZE) {
+		pr_err("unable to store oversize (%d) PR info: %s\n",
+		       pr_xattr_len_new, pr_xattr_new);
+		rc = -E2BIG;
+		goto err_xattr_new_free;
+	}
+
+	rc = tcmu_set_dev_pr_info(udev, pr_xattr_new);
+	if (rc) {
+		pr_err("failed to set PR xattr: %d\n", rc);
+		goto err_xattr_new_free;
+	}
+
+	pr_debug("successfully replaced PR info\n");
+	rc = 0;
+err_xattr_new_free:
+	kfree(pr_xattr_new);
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

