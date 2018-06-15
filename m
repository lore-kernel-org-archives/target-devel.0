From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:23 +0000
Subject: [PATCH 14/33] TCMU PR: add a function can get PR info from a dev
Message-Id: <20180615182342.6239-14-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_pr_info_get() which can help
get Persistent Reservation information from a TCMU device.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 12f4a5a5c1e1..0f8eeed61c60 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2253,6 +2253,57 @@ static int tcmu_pr_info_decode(char *pr_xattr, int pr_xattr_len,
 	return rc;
 }
 
+static int tcmu_pr_info_get(struct tcmu_dev *udev,
+			    struct tcmu_pr_info **_pr_info,
+			    char **_pr_xattr, int *_pr_xattr_len)
+{
+	int rc;
+	char *pr_xattr = udev->pr_info.pr_info_buf;
+	char *dup_xattr = NULL;
+	int pr_xattr_len = 0;
+	struct tcmu_pr_info *pr_info = NULL;
+
+	if (!_pr_info) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	rc = tcmu_get_dev_pr_info(udev, &pr_xattr_len);
+
+	if (rc) {
+		if (rc != -ENODATA)
+			pr_err("failed to obtain PR xattr: %d\n", rc);
+		return rc;
+	}
+
+	if (_pr_xattr) {
+		/* dup before decode, which trashes @pr_xattr */
+		dup_xattr = kstrdup(pr_xattr, GFP_KERNEL);
+		if (!dup_xattr)
+			return -ENOMEM;
+	}
+
+	rc = tcmu_pr_info_decode(pr_xattr, pr_xattr_len, &pr_info);
+	if (rc) {
+		pr_err("failed to decode PR xattr: %d\n", rc);
+		goto err_dup_xattr_free;
+	}
+
+	if (_pr_xattr) {
+		WARN_ON(!_pr_xattr_len);
+		*_pr_xattr = dup_xattr;
+		*_pr_xattr_len = pr_xattr_len;
+	}
+
+	*_pr_info = pr_info;
+	pr_debug("successfully obtained PR info\n");
+	return 0;
+
+err_dup_xattr_free:
+	kfree(dup_xattr);
+	return rc;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

