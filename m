From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:22 +0000
Subject: [PATCH 13/33] TCMU PR: add a PR info decoder function
Message-Id: <20180615182342.6239-13-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_pr_info_decode() which can decode
Persistent Reservation info, from the string to a struct
tcmu_pr_info. This function will call the pervious added decoder
like tcmu_pr_info_reg_decode() to do it's work.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 108 ++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 09a4f97243b8..12f4a5a5c1e1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -99,6 +99,14 @@
 
 #define TCMU_PR_IT_NEXUS_MAXLEN		484
 
+#define TCMU_PR_INFO_XATTR_FIELD_VER		0
+#define TCMU_PR_INFO_XATTR_FIELD_SEQ		1
+#define TCMU_PR_INFO_XATTR_FIELD_SCSI2_RSV	2
+#define TCMU_PR_INFO_XATTR_FIELD_GEN		3
+#define TCMU_PR_INFO_XATTR_FIELD_SCSI3_RSV	4
+#define TCMU_PR_INFO_XATTR_FIELD_NUM_REGS	5
+#define TCMU_PR_INFO_XATTR_FIELD_REGS_START	6
+
 static u8 tcmu_kern_cmd_reply_supported;
 
 static struct device *tcmu_root_device;
@@ -2145,6 +2153,106 @@ tcmu_pr_info_free(struct tcmu_pr_info *pr_info)
 	kfree(pr_info);
 }
 
+static int tcmu_pr_info_decode(char *pr_xattr, int pr_xattr_len,
+			       struct tcmu_pr_info **_pr_info)
+{
+	struct tcmu_pr_info *pr_info;
+	int rc;
+	int field;
+	int i;
+	char *p;
+	char *str;
+	char *end;
+
+	WARN_ON(!_pr_info);
+
+	if (!pr_xattr_len) {
+		pr_err("zero length PR xattr\n");
+		return -EINVAL;
+	}
+
+	pr_debug("decoding PR xattr: %s\n", pr_xattr);
+
+	pr_info = kzalloc(sizeof(*pr_info), GFP_KERNEL);
+	if (!pr_info)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&pr_info->regs);
+
+	p = pr_xattr;
+	end = pr_xattr + pr_xattr_len;
+	field = 0;
+	i = 0;
+	/*
+	 * '\n' separator between header fields and each reg entry.
+	 * reg subfields are further separated by ' '.
+	 */
+	for (str = strsep(&p, "\n"); str && *str != '\0' && (p <= end);
+	     str = strsep(&p, "\n")) {
+		if (field = TCMU_PR_INFO_XATTR_FIELD_VER) {
+			rc = tcmu_pr_info_vers_decode(str, &pr_info->vers);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field = TCMU_PR_INFO_XATTR_FIELD_SEQ) {
+			rc = tcmu_pr_info_seq_decode(str, &pr_info->seq);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field = TCMU_PR_INFO_XATTR_FIELD_SCSI2_RSV) {
+			rc = tcmu_pr_info_scsi2_rsv_decode(str,
+							   &pr_info->scsi2_rsv);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field = TCMU_PR_INFO_XATTR_FIELD_GEN) {
+			rc = tcmu_pr_info_gen_decode(str, &pr_info->gen);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field = TCMU_PR_INFO_XATTR_FIELD_SCSI3_RSV) {
+			rc = tcmu_pr_info_rsv_decode(str, &pr_info->rsv);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field = TCMU_PR_INFO_XATTR_FIELD_NUM_REGS) {
+			rc = tcmu_pr_info_num_regs_decode(str,
+							  &pr_info->num_regs);
+			if (rc < 0)
+				goto err_info_free;
+		} else if (field >= TCMU_PR_INFO_XATTR_FIELD_REGS_START) {
+			struct tcmu_pr_reg *reg;
+
+			rc = tcmu_pr_info_reg_decode(str, &reg);
+			if (rc < 0)
+				goto err_info_free;
+			list_add_tail(&reg->regs_node, &pr_info->regs);
+			i++;
+		} else {
+			pr_debug("skipping parsing of field %d\n", field);
+		}
+
+		field++;
+	}
+
+	if (field <= TCMU_PR_INFO_XATTR_FIELD_NUM_REGS) {
+		pr_err("pr_info missing basic fields, stopped at %d\n", field);
+		rc = -EINVAL;
+		goto err_info_free;
+	}
+
+	if (i != pr_info->num_regs) {
+		pr_err("processed %d registrations, expected %d\n",
+		       i, pr_info->num_regs);
+		rc = -EINVAL;
+		goto err_info_free;
+	}
+
+	pr_debug("successfully processed all PR data\n");
+	*_pr_info = pr_info;
+
+	return 0;
+
+err_info_free:
+	tcmu_pr_info_free(pr_info);
+	return rc;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

