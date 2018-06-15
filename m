From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:37 +0000
Subject: [PATCH 28/33] TCMU PR: implementation of PR Reserve for TCMU
Message-Id: <20180615182342.6239-28-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added functions to handle Persistent Reservation
Reserve against TCMU devices.

Function tcm_rbd_pr_info_rsv_set() will help set PR information
in struct tcmu_pr_info, function tcmu_execute_pr_reserve() will
help handle PR reserve requests against TCMU devices.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 162 ++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bde325888477..8390b1d37873 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2970,6 +2970,167 @@ static int is_passthrough_pr_supportive_dev(struct tcmu_dev *udev)
 	return ret;
 }
 
+
+
+static int tcm_rbd_pr_info_rsv_set(struct tcmu_pr_info *pr_info, u64 key,
+				   char *nexus, int type)
+{
+	struct tcmu_pr_rsv *rsv;
+
+	if (pr_info->rsv != NULL) {
+		pr_debug("rsv_set called with existing reservation\n");
+		return -EINVAL;
+	}
+
+	rsv = kmalloc(sizeof(*rsv), GFP_KERNEL);
+	if (!rsv)
+		return -ENOMEM;
+
+	rsv->key = key;
+	strlcpy(rsv->it_nexus, nexus, ARRAY_SIZE(rsv->it_nexus));
+	rsv->type = type;
+	pr_info->rsv = rsv;
+	pr_debug("pr_info rsv set: 0x%llx %s %d\n", key, nexus, type);
+
+	return 0;
+}
+
+
+static sense_reason_t
+tcmu_execute_pr_reserve(struct se_cmd *cmd, int type, u64 key)
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
+	udev->pr_info.pr_info_buf = kzalloc(TCMU_PR_INFO_XATTR_MAX_SIZE,
+					    GFP_KERNEL);
+	if (!udev->pr_info.pr_info_buf)
+		return TCM_OUT_OF_RESOURCES;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_info_free;
+	}
+
+	rc = tcmu_gen_it_nexus(cmd->se_sess, nexus_buf,
+				  ARRAY_SIZE(nexus_buf));
+	if (rc < 0) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_info_free;
+	}
+
+retry:
+	pr_info = NULL;
+	pr_xattr = NULL;
+	pr_xattr_len = 0;
+	rc = tcmu_pr_info_get(udev, &pr_info, &pr_xattr,
+				 &pr_xattr_len);
+	if (rc < 0) {
+		/* existing registration required for reservation */
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
+			pr_debug("found existing PR reg for %s\n",
+				 nexus_buf);
+			existing_reg = reg;
+			break;
+		}
+	}
+
+	if (!existing_reg) {
+		pr_err("SPC-3 PR: Unable to locate registration for RESERVE\n");
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err_info_free;
+	}
+
+	if (key != existing_reg->key) {
+		pr_err("SPC-3 PR RESERVE: Received res_key: 0x%016llx ", key);
+		pr_err("does not match existing SA REGISTER res_key: ");
+		pr_err("0x%016llx\n", existing_reg->key);
+		ret = TCM_RESERVATION_CONFLICT;
+		goto err_info_free;
+	}
+
+	if (pr_info->rsv) {
+		if (!tcmu_is_rsv_holder(pr_info->rsv, existing_reg, NULL)) {
+			pr_err("SPC-3 PR: Attempted RESERVE from %s while ",
+			       nexus_buf);
+			pr_err("reservation already held by %s, ",
+			       pr_info->rsv->it_nexus);
+			pr_err("returning RESERVATION_CONFLICT\n");
+			ret = TCM_RESERVATION_CONFLICT;
+			goto err_info_free;
+		}
+
+		if (pr_info->rsv->type != type) {
+			/* scope already checked */
+			pr_err("SPC-3 PR: Attempted RESERVE from %s ",
+			       existing_reg->it_nexus);
+			pr_err("trying to change TYPE, ");
+			pr_err("returning RESERVATION_CONFLICT\n");
+			ret = TCM_RESERVATION_CONFLICT;
+			goto err_info_free;
+		}
+
+		pr_debug("reserve matches existing reservation, ");
+		pr_debug("nothing to do\n");
+		goto done;
+	}
+
+	/* new reservation */
+	rc = tcm_rbd_pr_info_rsv_set(pr_info, key, nexus_buf, type);
+	if (rc < 0) {
+		pr_err("failed to set PR info reservation\n");
+		ret = TCM_OUT_OF_RESOURCES;
+		goto err_info_free;
+	}
+
+	rc = tcmu_pr_info_replace(udev, pr_xattr, pr_xattr_len,
+				     pr_info);
+	if (rc = -ECANCELED) {
+		pr_warn("atomic PR info update failed due to parallel ");
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
+done:
+	ret = TCM_NO_SENSE;
+err_info_free:
+	tcmu_pr_info_free(pr_info);
+	kfree(pr_xattr);
+	kfree(udev->pr_info.pr_info_buf);
+	return ret;
+}
+
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -3724,6 +3885,7 @@ static struct configfs_attribute *tcmu_action_attrs[] = {
 static struct target_pr_ops tcmu_pr_ops = {
 	.pr_read_keys		= tcmu_execute_pr_read_keys,
 	.pr_register		= tcmu_execute_pr_register,
+	.pr_reserve		= tcmu_execute_pr_reserve,
 };
 
 static struct target_backend_ops tcmu_ops = {
-- 
2.17.1

