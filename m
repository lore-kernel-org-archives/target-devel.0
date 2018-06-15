From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:41 +0000
Subject: [PATCH 32/33] TCMU PR: implementation of PR clear for TCMU
Message-Id: <20180615182342.6239-32-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_execute_pr_clear() which can
help perform Persistent Reservation clear operation,
this means clear reservations and registrations.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 108 ++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 532401a9f433..c8d0ea330984 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -3251,6 +3251,114 @@ tcmu_execute_pr_release(struct se_cmd *cmd, int type, u64 key)
 }
 
 
+static sense_reason_t
+tcmu_execute_pr_clear(struct se_cmd *cmd, u64 key)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+	char nexus_buf[TCMU_PR_IT_NEXUS_MAXLEN];
+	struct tcmu_pr_info *pr_info;
+	struct tcmu_pr_reg *reg;
+	struct tcmu_pr_reg *existing_reg;
+	char *pr_xattr;
+	int pr_xattr_len;
+	int rc;
+	sense_reason_t ret;
+	int retries = 0;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	rc = tcmu_gen_it_nexus(cmd->se_sess, nexus_buf,
+				  ARRAY_SIZE(nexus_buf));
+	if (rc < 0)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	mutex_lock(&udev->pr_info.pr_info_lock);
+	udev->pr_info.pr_info_buf = kzalloc(TCMU_PR_INFO_XATTR_MAX_SIZE,
+					    GFP_KERNEL);
+
+retry:
+	pr_info = NULL;
+	pr_xattr = NULL;
+	pr_xattr_len = 0;
+	rc = tcmu_pr_info_get(udev, &pr_info, &pr_xattr,
+				 &pr_xattr_len);
+	if (rc < 0) {
+		/* existing registration required for clear */
+		pr_err("failed to obtain PR info\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_info_free;
+	}
+
+	/* check for an existing registration */
+	existing_reg = NULL;
+	list_for_each_entry(reg, &pr_info->regs, regs_node) {
+		if (!strncmp(reg->it_nexus, nexus_buf,
+			     ARRAY_SIZE(nexus_buf))) {
+			pr_debug("found existing PR reg for %s\n", nexus_buf);
+			existing_reg = reg;
+			break;
+		}
+	}
+
+	if (!existing_reg) {
+		pr_err("SPC-3 PR: Unable to locate registration for CLEAR\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_info_free;
+	}
+
+	if (key != existing_reg->key) {
+		pr_err("SPC-3 PR CLEAR: Received res_key: 0x%016llx ", key);
+		pr_err("does not match existing SA res_key: 0x%016llx\n",
+		       existing_reg->key);
+		ret = TCM_RESERVATION_CONFLICT;
+		goto err_info_free;
+	}
+
+	/* release the persistent reservation, if any */
+	if (pr_info->rsv)
+		tcmu_pr_info_rsv_clear(pr_info);
+
+	/* remove all registrations */
+	list_for_each_entry_safe(existing_reg, reg, &pr_info->regs, regs_node) {
+		tcmu_pr_info_clear_reg(pr_info, existing_reg);
+	}
+
+	/* PR generation must be incremented on successful CLEAR */
+	pr_info->gen++;
+
+	rc = tcmu_pr_info_replace(udev, pr_xattr, pr_xattr_len,
+				     pr_info);
+	if (rc = -ECANCELED) {
+		pr_warn("Atomic PR info update failed due to parallel ");
+		pr_warn("change, expected(%d) %s. Retrying...\n",
+			pr_xattr_len, pr_xattr);
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
+		goto err_info_free;
+	}
+
+	ret = TCM_NO_SENSE;
+err_info_free:
+	tcmu_pr_info_free(pr_info);
+	kfree(pr_xattr);
+	kfree(udev->pr_info.pr_info_buf);
+	mutex_unlock(&udev->pr_info.pr_info_lock);
+	return ret;
+}
+
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

