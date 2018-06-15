From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:25 +0000
Subject: [PATCH 16/33] TCMU PR: init PR info when empty for TCMU dev
Message-Id: <20180615182342.6239-16-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When try to register an IT_Nexus, if tcmu_pr_info_get()
returns -ENODATA, this means the string stored on the
TCMU DEVICE records(for example, RBD metadata) which represent
Persistent Reservation information is empty,there are no
registrations, we should initialize a new struct
tcmu_pr_info.

This patch added a function tcmu_pr_info_init() to initialize
Persistent Reservation struct tcmu_pr_info, encode it to a
string, and store this string in the TCMU device records.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 48 +++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 957e444d853b..8d860b59d277 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2437,6 +2437,54 @@ static int tcmu_pr_info_encode(struct tcmu_pr_info *pr_info,
 	return rc;
 }
 
+static int tcmu_pr_info_init(struct tcmu_dev *udev,
+			     struct tcmu_pr_info **_pr_info,
+			     char **_pr_xattr, int *_pr_xattr_len)
+{
+	struct tcmu_pr_info *pr_info;
+	char *pr_xattr = NULL;
+	int pr_xattr_len = 0;
+	int rc;
+
+	pr_info = kzalloc(sizeof(*pr_info), GFP_KERNEL);
+	if (!pr_info)
+		return -ENOMEM;
+
+	pr_info->vers = TCMU_PR_INFO_XATTR_VERS;
+	INIT_LIST_HEAD(&pr_info->regs);
+	pr_info->seq = 1;
+
+	rc = tcmu_pr_info_encode(pr_info, &pr_xattr, &pr_xattr_len);
+	if (rc) {
+		pr_err("failed to encode PR xattr: %d\n", rc);
+		goto err_info_free;
+	}
+
+	rc = tcmu_set_dev_pr_info(udev, pr_xattr);
+	if (rc) {
+		pr_err("failed to set PR xattr: %d\n", rc);
+		goto err_xattr_free;
+	}
+
+	*_pr_info = pr_info;
+	if (_pr_xattr) {
+		WARN_ON(!_pr_xattr_len);
+		*_pr_xattr = pr_xattr;
+		*_pr_xattr_len = pr_xattr_len;
+	} else {
+		kfree(pr_xattr);
+	}
+	pr_debug("successfully initialized PR info\n");
+
+	return 0;
+
+err_xattr_free:
+	kfree(pr_xattr);
+err_info_free:
+	kfree(pr_info);
+	return rc;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

