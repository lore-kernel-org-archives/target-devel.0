From: David Disseldorp <ddiss@suse.de>
Date: Thu, 22 Nov 2018 13:38:00 +0000
Subject: [RFC PATCH] target: sanitize ALUA and PR state file paths before use
Message-Id: <20181122133800.1251-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Block ALUA and PR state storage if any of the dynamic subdirectory
components include a path separator.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
Note:
Submitted as an RFC, as I've not properly tested the alua code path.
I'm also not sure whether it's reasonable to break existing setups
with a '/' in the configured unit_serial. Where "break" means fail
APTPL PR requests; ALUA state-save failures are ignored internally.

 drivers/target/target_core_alua.c | 27 ++++++++++++++++++++-------
 drivers/target/target_core_pr.c   |  5 +++++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4f134b0c3e29..517945f881e0 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -918,9 +918,16 @@ static int core_alua_update_tpg_primary_metadata(
 {
 	unsigned char *md_buf;
 	struct t10_wwn *wwn = &tg_pt_gp->tg_pt_gp_dev->t10_wwn;
+	const char *tpgs_name;
 	char *path;
 	int len, rc;
 
+	tpgs_name = config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item);
+	if (strchr(wwn->unit_serial, '/') || strchr(tpgs_name, '/')) {
+		pr_err("Unable to construct valid ALUA metadata path\n");
+		return -EINVAL;
+	}
+
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
 		pr_err("Unable to allocate buf for ALUA metadata\n");
@@ -937,8 +944,7 @@ static int core_alua_update_tpg_primary_metadata(
 
 	rc = -ENOMEM;
 	path = kasprintf(GFP_KERNEL, "%s/alua/tpgs_%s/%s", db_root,
-			&wwn->unit_serial[0],
-			config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
+			&wwn->unit_serial[0], tpgs_name);
 	if (path) {
 		rc = core_alua_write_tpg_metadata(path, md_buf, len);
 		kfree(path);
@@ -1210,6 +1216,8 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 {
 	struct se_portal_group *se_tpg = lun->lun_tpg;
 	unsigned char *md_buf;
+	const char *fabric_name;
+	const char *wwn;
 	char *path;
 	int len, rc;
 
@@ -1227,17 +1235,22 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 			atomic_read(&lun->lun_tg_pt_secondary_offline),
 			lun->lun_tg_pt_secondary_stat);
 
+	fabric_name = se_tpg->se_tpg_tfo->get_fabric_name();
+	wwn = se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg);
+	if (strchr(fabric_name, '/') || strchr(wwn, '/')) {
+		pr_err("Unable to construct valid ALUA metadata path\n");
+		rc = -EINVAL;
+		goto out_free;
+	}
+
 	if (se_tpg->se_tpg_tfo->tpg_get_tag != NULL) {
 		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s+%hu/lun_%llu",
-				db_root, se_tpg->se_tpg_tfo->get_fabric_name(),
-				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+				db_root, fabric_name, wwn,
 				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
 				lun->unpacked_lun);
 	} else {
 		path = kasprintf(GFP_KERNEL, "%s/alua/%s/%s/lun_%llu",
-				db_root, se_tpg->se_tpg_tfo->get_fabric_name(),
-				se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
-				lun->unpacked_lun);
+				db_root, fabric_name, wwn, lun->unpacked_lun);
 	}
 	if (!path) {
 		rc = -ENOMEM;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 10db5656fd5d..48397cf919d4 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1980,6 +1980,11 @@ static int __core_scsi3_write_aptpl_to_file(
 	int ret;
 	loff_t pos = 0;
 
+	if (strchr(wwn->unit_serial, '/')) {
+		pr_err("Unable to construct valid APTPL metadata path\n");
+		return -EINVAL;
+	}
+
 	path = kasprintf(GFP_KERNEL, "%s/pr/aptpl_%s", db_root,
 			&wwn->unit_serial[0]);
 	if (!path)
-- 
2.13.7
