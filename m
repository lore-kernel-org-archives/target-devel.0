From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:31 +0000
Subject: [PATCH 22/33] TCMU PR: add a function to handle TCMU PR register
Message-Id: <20180615182342.6239-22-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_execute_pr_register() which
can help to handle Persistent Reservation register operation
for TCMU devices.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 138 ++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 559e0d40d63b..c3adff826163 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2691,6 +2691,144 @@ static int tcmu_pr_info_replace(struct tcmu_dev *udev,
 	return 0;
 }
 
+static sense_reason_t
+tcmu_execute_pr_register(struct se_cmd *cmd, u64 old_key,
+			 u64 new_key, bool aptpl, bool all_tg_pt,
+			 bool spec_i_pt, bool ignore_existing)
+{
+	struct se_device *dev = cmd->se_dev;
+	char nexus_buf[TCMU_PR_IT_NEXUS_MAXLEN];
+	struct tcmu_pr_info *pr_info;
+	struct tcmu_pr_reg *reg;
+	struct tcmu_pr_reg *existing_reg;
+	char *pr_xattr;
+	int pr_xattr_len;
+	int rc;
+	sense_reason_t ret;
+	int retries = 0;
+	char *pr_buf_ptr = NULL;
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	mutex_lock(&udev->pr_info.pr_info_lock);
+	udev->pr_info.pr_info_buf = kzalloc(TCMU_PR_INFO_XATTR_MAX_SIZE,
+					    GFP_KERNEL);
+	pr_buf_ptr = udev->pr_info.pr_info_buf;
+	if (!pr_buf_ptr) {
+		ret = TCM_OUT_OF_RESOURCES;
+		goto err_out;
+	}
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_out;
+	}
+
+	if (!aptpl) {
+		/*
+		 * Currently unsupported by block layer API (hch):
+		 * reservations not persistent through a power loss are
+		 * basically useless, so I decided to force them on in the API.
+		 */
+		pr_warn("PR register with aptpl unset. Treating as aptpl=1\n");
+		aptpl = true;
+	}
+
+	if (all_tg_pt || spec_i_pt) {
+		pr_err("failing PR register with all_tg_pt=%d spec_i_pt=%d\n",
+		       all_tg_pt, spec_i_pt);
+		ret = TCM_INVALID_CDB_FIELD;
+		goto err_out;
+	}
+
+	rc = tcmu_gen_it_nexus(cmd->se_sess, nexus_buf, ARRAY_SIZE(nexus_buf));
+	if (rc < 0) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_out;
+	}
+
+	pr_debug("generated nexus: %s\n", nexus_buf);
+
+retry:
+	pr_info = NULL;
+	pr_xattr = NULL;
+	pr_xattr_len = 0;
+	rc = tcmu_pr_info_get(udev, &pr_info, &pr_xattr, &pr_xattr_len);
+	if ((rc = -ENODATA) && (retries = 0)) {
+		pr_warn("PR info not present, initializing\n");
+		rc = tcmu_pr_info_init(udev, &pr_info, &pr_xattr,
+				       &pr_xattr_len);
+	}
+	if (rc < 0) {
+		pr_err("failed to obtain PR info\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_out;
+	}
+
+	/* check for an existing registration */
+	existing_reg = NULL;
+	list_for_each_entry(reg, &pr_info->regs, regs_node) {
+		if (!strncmp(reg->it_nexus, nexus_buf, ARRAY_SIZE(nexus_buf))) {
+			pr_err("found existing PR reg for %s\n", nexus_buf);
+			existing_reg = reg;
+			break;
+		}
+	}
+
+	if (!existing_reg) {
+		ret = tcmu_execute_pr_register_new(pr_info, old_key, new_key,
+						   nexus_buf, ignore_existing);
+	} else {
+		ret = tcmu_execute_pr_register_existing(pr_info, old_key,
+							new_key, nexus_buf,
+							existing_reg,
+							ignore_existing);
+	}
+	if (ret)
+		goto err_out;
+
+	/*
+	 * The Persistent Reservations Generation (PRGENERATION) field shall
+	 * contain the value of a 32-bit wrapping counter that the device server
+	 * shall update (e.g., increment) during the processing of any
+	 * PERSISTENT RESERVE OUT command as described in table 216 (see
+	 * 6.16.2). The PRgeneration value shall not be updated by a PERSISTENT
+	 * RESERVE IN command or by a PERSISTENT RESERVE OUT command that is
+	 * terminated due to an error or reservation conflict.
+	 */
+	pr_info->gen++;
+
+	rc = tcmu_pr_info_replace(udev, pr_xattr, pr_xattr_len, pr_info);
+	if (rc = -ECANCELED) {
+		int pr_xattr_changed_len = 0;
+		/* PR info has changed since we read it */
+		rc = tcmu_get_dev_pr_info(udev, &pr_xattr_changed_len);
+		pr_warn("atomic PR info update failed due to parallel,");
+		pr_warn("change, expected(%d) %s, now(%d) %s\n",
+			pr_xattr_len, pr_xattr, pr_xattr_changed_len,
+			pr_buf_ptr);
+		retries++;
+		if (retries <= TCMU_PR_REG_MAX_RETRIES) {
+			tcmu_pr_info_free(pr_info);
+			kfree(pr_xattr);
+			goto retry;
+		}
+	}
+	if (rc < 0) {
+		pr_err("atomic PR info update failed: %d\n", rc);
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_out;
+	}
+
+	ret = TCM_NO_SENSE;
+err_out:
+	tcmu_pr_info_free(pr_info);
+	kfree(pr_xattr);
+	kfree(udev->pr_info.pr_info_buf);
+	mutex_unlock(&udev->pr_info.pr_info_lock);
+	return ret;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

