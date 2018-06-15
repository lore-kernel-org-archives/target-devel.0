From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:24 +0000
Subject: [PATCH 15/33] TCMU PR: add a PR info encoder function
Message-Id: <20180615182342.6239-15-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_pr_info_encode() which can
encode Persistent Reservation info, from a struct tcmu_pr_info
to a string, so that we can store this string on a TCMU device.
This function will call the pervious added encoder like
tcmu_pr_info_reg_encode() to do it's work.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 133 ++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0f8eeed61c60..957e444d853b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -107,6 +107,31 @@
 #define TCMU_PR_INFO_XATTR_FIELD_NUM_REGS	5
 #define TCMU_PR_INFO_XATTR_FIELD_REGS_START	6
 
+/* don't allow encoded PR info to exceed 8K */
+#define TCMU_PR_INFO_XATTR_MAX_SIZE 8192
+
+#define TCMU_PR_INFO_XATTR_ENCODED_SCSI2_RSV_MAXLEN		\
+	(TCMU_PR_IT_NEXUS_MAXLEN + sizeof("\n"))
+
+#define TCMU_PR_INFO_XATTR_ENCODED_PR_RSV_MAXLEN		\
+	((sizeof("0x") + sizeof(u64) * 2) + sizeof(" ") +	\
+	 TCMU_PR_IT_NEXUS_MAXLEN + sizeof(" ") +		\
+	 (sizeof("0x") + sizeof(u64) * 2) + sizeof("\n"))
+
+#define TCMU_PR_INFO_XATTR_ENCODED_PR_REG_MAXLEN		\
+	((sizeof("0x") + sizeof(u64) * 2) + sizeof(" ") +	\
+	 TCMU_PR_IT_NEXUS_MAXLEN + sizeof("\n"))
+
+#define TCMU_PR_INFO_XATTR_ENCODED_MAXLEN(_num_regs)			\
+	 ((sizeof("0x") + sizeof(u32) * 2) + sizeof("\n") +		\
+	 (sizeof("0x") + sizeof(u32) * 2) + sizeof("\n") +		\
+	 TCMU_PR_INFO_XATTR_ENCODED_SCSI2_RSV_MAXLEN +		\
+	 (sizeof("0x") + sizeof(u32) * 2) + sizeof("\n") +		\
+	 TCMU_PR_INFO_XATTR_ENCODED_PR_RSV_MAXLEN +			\
+	 (sizeof("0x") + sizeof(u32) * 2) + sizeof("\n") +		\
+	 (TCMU_PR_INFO_XATTR_ENCODED_PR_REG_MAXLEN * _num_regs) +	\
+	 sizeof("\0"))
+
 static u8 tcmu_kern_cmd_reply_supported;
 
 static struct device *tcmu_root_device;
@@ -2304,6 +2329,114 @@ static int tcmu_pr_info_get(struct tcmu_dev *udev,
 	return rc;
 }
 
+static int tcmu_pr_info_encode(struct tcmu_pr_info *pr_info,
+			       char **_pr_xattr, int *pr_xattr_len)
+{
+	struct tcmu_pr_reg *reg;
+	char *pr_xattr;
+	char *p;
+	size_t buf_remain;
+	int rc;
+	int i;
+
+	if (pr_info->vers != TCMU_PR_INFO_XATTR_VERS) {
+		pr_err("unsupported PR info version: %u\n", pr_info->vers);
+		return -EINVAL;
+	}
+
+	buf_remain = TCMU_PR_INFO_XATTR_ENCODED_MAXLEN(pr_info->num_regs);
+	if (buf_remain > TCMU_PR_INFO_XATTR_MAX_SIZE) {
+		pr_err("PR info too large for encoding: %zd\n", buf_remain);
+		return -EINVAL;
+	}
+	pr_debug("encoding PR info: vers=%u, seq=%u, gen=%u, num regs=%u ",
+	       pr_info->vers, pr_info->seq, pr_info->gen, pr_info->num_regs);
+	pr_debug("into %zd bytes\n", buf_remain);
+
+	pr_xattr = kmalloc(buf_remain, GFP_KERNEL);
+	if (!pr_xattr)
+		return -ENOMEM;
+
+	p = pr_xattr;
+	rc = tcmu_pr_info_vers_seq_encode(p, buf_remain, pr_info->vers,
+					  pr_info->seq);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	p += rc;
+	buf_remain -= rc;
+
+	rc = tcmu_pr_info_scsi2_rsv_encode(p, buf_remain, pr_info->scsi2_rsv);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	p += rc;
+	buf_remain -= rc;
+
+	rc = tcmu_pr_info_gen_encode(p, buf_remain, pr_info->gen);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	p += rc;
+	buf_remain -= rc;
+
+	rc = tcmu_pr_info_rsv_encode(p, buf_remain, pr_info->rsv);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	p += rc;
+	buf_remain -= rc;
+
+	rc = tcmu_pr_info_num_regs_encode(p, buf_remain, pr_info->num_regs);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	p += rc;
+	buf_remain -= rc;
+
+	i = 0;
+	list_for_each_entry(reg, &pr_info->regs, regs_node) {
+		rc = tcmu_pr_info_reg_encode(p, buf_remain, reg);
+		if (rc < 0) {
+			rc = -EINVAL;
+			goto err_xattr_free;
+		}
+
+		p += rc;
+		buf_remain -= rc;
+		i++;
+	}
+
+	if (i != pr_info->num_regs) {
+		pr_err("mismatch between PR num_regs and list entries!\n");
+		rc = -EINVAL;
+		goto err_xattr_free;
+	}
+
+	*_pr_xattr = pr_xattr;
+	/* +1 to include null term */
+	*pr_xattr_len = (p - pr_xattr) + 1;
+
+	pr_err("successfully encoded all %d PR regs into %d bytes: %s\n",
+	       pr_info->num_regs, *pr_xattr_len, pr_xattr);
+
+	return 0;
+
+err_xattr_free:
+	kfree(pr_xattr);
+	return rc;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

