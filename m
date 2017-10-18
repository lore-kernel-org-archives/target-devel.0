From: David Disseldorp <ddiss@suse.de>
Date: Wed, 18 Oct 2017 23:39:20 +0000
Subject: [PATCH v3 2/2] target: fix ALUA state file path truncation
Message-Id: <20171018233920.20750-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A sufficiently long Unit Serial string, dbroot path, and/or ALUA target
portal group name may result in truncation of the ALUA state file path
prior to usage. Fix this by using kasprintf() instead.

Fixes: fdddf932269a ("target: use new "dbroot" target attribute")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changes since v2:
- rework core_alua_update_tpg_primary_metadata() error path, as
  suggested by Christoph.

 drivers/target/target_core_alua.c | 51 +++++++++++++++++++++------------------
 drivers/target/target_core_alua.h |  9 -------
 2 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 928127642574..e46ca968009c 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -918,7 +918,7 @@ static int core_alua_update_tpg_primary_metadata(
 {
 	unsigned char *md_buf;
 	struct t10_wwn *wwn = &tg_pt_gp->tg_pt_gp_dev->t10_wwn;
-	char path[ALUA_METADATA_PATH_LEN];
+	char *path;
 	int len, rc;
 
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
@@ -927,8 +927,6 @@ static int core_alua_update_tpg_primary_metadata(
 		return -ENOMEM;
 	}
 
-	memset(path, 0, ALUA_METADATA_PATH_LEN);
-
 	len = snprintf(md_buf, ALUA_MD_BUF_LEN,
 			"tg_pt_gp_id=%hu\n"
 			"alua_access_state=0x%02x\n"
@@ -937,11 +935,14 @@ static int core_alua_update_tpg_primary_metadata(
 			tg_pt_gp->tg_pt_gp_alua_access_state,
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
-	snprintf(path, ALUA_METADATA_PATH_LEN,
-		"%s/alua/tpgs_%s/%s", db_root, &wwn->unit_serial[0],
-		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
-
-	rc = core_alua_write_tpg_metadata(path, md_buf, len);
+	rc = -ENOMEM;
+	path = kasprintf(GFP_KERNEL, "%s/alua/tpgs_%s/%s", db_root,
+			&wwn->unit_serial[0],
+			config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
+	if (path) {
+		rc = core_alua_write_tpg_metadata(path, md_buf, len);
+		kfree(path);
+	}
 	kfree(md_buf);
 	return rc;
 }
@@ -1209,7 +1210,7 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 {
 	struct se_portal_group *se_tpg = lun->lun_tpg;
 	unsigned char *md_buf;
-	char path[ALUA_METADATA_PATH_LEN], wwn[ALUA_SECONDARY_METADATA_WWN_LEN];
+	char *path;
 	int len, rc;
 
 	mutex_lock(&lun->lun_tg_pt_md_mutex);
@@ -1221,28 +1222,32 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 		goto out_unlock;
 	}
 
-	memset(path, 0, ALUA_METADATA_PATH_LEN);
-	memset(wwn, 0, ALUA_SECONDARY_METADATA_WWN_LEN);
-
-	len = snprintf(wwn, ALUA_SECONDARY_METADATA_WWN_LEN, "%s",
-			se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg));
-
-	if (se_tpg->se_tpg_tfo->tpg_get_tag != NULL)
-		snprintf(wwn+len, ALUA_SECONDARY_METADATA_WWN_LEN-len, "+%hu",
-				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
-
 	len = snprintf(md_buf, ALUA_MD_BUF_LEN, "alua_tg_pt_offline=%d\n"
 			"alua_tg_pt_status=0x%02x\n",
 			atomic_read(&lun->lun_tg_pt_secondary_offline),
 			lun->lun_tg_pt_secondary_stat);
 
-	snprintf(path, ALUA_METADATA_PATH_LEN, "%s/alua/%s/%s/lun_%llu",
-			db_root, se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
-			lun->unpacked_lun);
+	if (se_tpg->se_tpg_tfo->tpg_get_tag != NULL) {
+		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s+%hu/lun_%llu",
+				db_root, se_tpg->se_tpg_tfo->get_fabric_name(),
+				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
+				lun->unpacked_lun);
+	} else {
+		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s/lun_%llu",
+				db_root, se_tpg->se_tpg_tfo->get_fabric_name(),
+				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+				lun->unpacked_lun);
+	}
+	if (!path) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
 
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
+	kfree(path);
+out_free:
 	kfree(md_buf);
-
 out_unlock:
 	mutex_unlock(&lun->lun_tg_pt_md_mutex);
 	return rc;
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index c69c11baf07f..90643300cd32 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -71,15 +71,6 @@
  */
 #define ALUA_DEFAULT_IMPLICIT_TRANS_SECS			0
 #define ALUA_MAX_IMPLICIT_TRANS_SECS			255
-/*
- * Used by core_alua_update_tpg_primary_metadata() and
- * core_alua_update_tpg_secondary_metadata()
- */
-#define ALUA_METADATA_PATH_LEN				512
-/*
- * Used by core_alua_update_tpg_secondary_metadata()
- */
-#define ALUA_SECONDARY_METADATA_WWN_LEN			256
 
 /* Used by core_alua_update_tpg_(primary,secondary)_metadata */
 #define ALUA_MD_BUF_LEN					1024
-- 
2.13.6

