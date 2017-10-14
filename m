From: David Disseldorp <ddiss@suse.de>
Date: Sat, 14 Oct 2017 21:03:52 +0000
Subject: [PATCH 2/2] target: add ALUA state file path truncation detection
Message-Id: <20171014210352.8713-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A sufficiently long Unit Serial string, dbroot path, and/or ALUA target
portal group name may result in truncation of the ALUA state file path
prior to usage. Add checks for snprintf() truncation.

Fixes: fdddf932269a ("target: use new "dbroot" target attribute")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_alua.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 928127642574..2351fe60c0e7 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -921,14 +921,23 @@ static int core_alua_update_tpg_primary_metadata(
 	char path[ALUA_METADATA_PATH_LEN];
 	int len, rc;
 
+	memset(path, 0, ALUA_METADATA_PATH_LEN);
+
+	len = snprintf(path, ALUA_METADATA_PATH_LEN,
+			"%s/alua/tpgs_%s/%s", db_root, &wwn->unit_serial[0],
+			config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
+	if (len >= ALUA_METADATA_PATH_LEN) {
+		pr_err("WWN value for struct se_device does not fit"
+			" into path buffer\n");
+		return -EMSGSIZE;
+	}
+
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
 		pr_err("Unable to allocate buf for ALUA metadata\n");
 		return -ENOMEM;
 	}
 
-	memset(path, 0, ALUA_METADATA_PATH_LEN);
-
 	len = snprintf(md_buf, ALUA_MD_BUF_LEN,
 			"tg_pt_gp_id=%hu\n"
 			"alua_access_state=0x%02x\n"
@@ -937,10 +946,6 @@ static int core_alua_update_tpg_primary_metadata(
 			tg_pt_gp->tg_pt_gp_alua_access_state,
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
-	snprintf(path, ALUA_METADATA_PATH_LEN,
-		"%s/alua/tpgs_%s/%s", db_root, &wwn->unit_serial[0],
-		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
-
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
 	kfree(md_buf);
 	return rc;
@@ -1231,18 +1236,28 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 		snprintf(wwn+len, ALUA_SECONDARY_METADATA_WWN_LEN-len, "+%hu",
 				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
+	len = snprintf(path, ALUA_METADATA_PATH_LEN, "%s/alua/%s/%s/lun_%llu",
+			db_root, se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
+			lun->unpacked_lun);
+	if (len >= ALUA_METADATA_PATH_LEN) {
+		pr_err("WWN value for struct se_device does not fit"
+			" into path buffer\n");
+		rc = -EMSGSIZE;
+		goto out_free;
+	}
+
 	len = snprintf(md_buf, ALUA_MD_BUF_LEN, "alua_tg_pt_offline=%d\n"
 			"alua_tg_pt_status=0x%02x\n",
 			atomic_read(&lun->lun_tg_pt_secondary_offline),
 			lun->lun_tg_pt_secondary_stat);
-
-	snprintf(path, ALUA_METADATA_PATH_LEN, "%s/alua/%s/%s/lun_%llu",
-			db_root, se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
-			lun->unpacked_lun);
+	if (len >= ALUA_MD_BUF_LEN) {
+		rc = -EMSGSIZE;
+		goto out_free;
+	}
 
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
+out_free:
 	kfree(md_buf);
-
 out_unlock:
 	mutex_unlock(&lun->lun_tg_pt_md_mutex);
 	return rc;
-- 
2.13.6

