From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:19 +0000
Subject: [PATCH 3/7] target: fix crash during SPEC_I_PT handling
Message-Id: <1593654203-12442-4-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

__core_scsi3_add_registration clears the t10_pr_registration
pr_reg_deve and does a core_scsi3_lunacl_undepend_item which does an
undepend and also does a kref_put from the get done in
__core_scsi3_alloc_registration. So when we get to the bottom of
core_scsi3_decode_spec_i_port the pr_reg_deve is NULL and we crash when
trying to access the local_pr_reg's pr_reg_deve. We've also done an extra
undepend for local_pr_reg and if we didn't crash on the NULL we would
have done an extra kref_put too.

This patch has us do a core_scsi3_lunacl_depend_item for local_pr_reg
and then let __core_scsi3_add_registration handle the cleanup for the
pr_reg_deve. We then just skip the undepend for the acl and tpg for the
local pr_reg.

The erorr path then works in a similar way, but we always do the
core_scsi3_lunacl_undepend_item since we never call
__core_scsi3_add_registration in that code path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pr.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 293f518..d5e6344 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1521,13 +1521,16 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 		kfree(tidh_new);
 		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 	}
+
+	if (core_scsi3_lunacl_depend_item(local_pr_reg->pr_reg_deve)) {
+		kfree(tidh_new);
+		kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
+			 target_pr_kref_release);
+		kmem_cache_free(t10_pr_reg_cache, local_pr_reg);
+		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
+	}
+
 	tidh_new->dest_pr_reg = local_pr_reg;
-	/*
-	 * The local I_T nexus does not hold any configfs dependances,
-	 * so we set tidh_new->dest_se_deve to NULL to prevent the
-	 * configfs_undepend_item() calls in the tid_dest_list loops below.
-	 */
-	tidh_new->dest_se_deve = NULL;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
@@ -1816,12 +1819,9 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			dest_node_acl->initiatorname, i_buf, (dest_se_deve) ?
 			dest_se_deve->mapped_lun : 0);
 
-		if (!dest_se_deve) {
-			kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
-				 target_pr_kref_release);
+		if (dest_pr_reg = local_pr_reg)
 			continue;
-		}
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
 		core_scsi3_nodeacl_undepend_item(dest_node_acl);
 		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
@@ -1835,11 +1835,16 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	 * including *dest_pr_reg and the configfs dependances..
 	 */
 	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		bool is_local = false;
+
 		dest_tpg = tidh->dest_tpg;
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
 
+		if (dest_pr_reg = local_pr_reg)
+			is_local = true;
+
 		list_del(&tidh->dest_list);
 		kfree(tidh);
 		/*
@@ -1855,13 +1860,11 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 		}
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
+		core_scsi3_lunacl_undepend_item(dest_se_deve);
 
-		if (!dest_se_deve) {
-			kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
-				 target_pr_kref_release);
+		if (is_local)
 			continue;
-		}
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
 		core_scsi3_nodeacl_undepend_item(dest_node_acl);
 		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
-- 
1.8.3.1
