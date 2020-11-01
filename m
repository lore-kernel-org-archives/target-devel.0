From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 01 Nov 2020 18:59:27 +0000
Subject: [PATCH 1/8] target: fix lun ref count handling
Message-Id: <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

This fixes 2 bugs in the lun refcounting.

1. For the TCM_WRITE_PROTECTED case we were returning an error after
taking a ref to the lun, but never dropping it (caller just send
status and drops cmd ref).

2. We still need to do a percpu_ref_tryget_live for the virt lun0 like
we do for other luns, because the tpg code does the refcount/wait
process like it does with other luns.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_device.c | 43 +++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 405d82d..1f673fb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -65,6 +65,16 @@
 			atomic_long_add(se_cmd->data_length,
 					&deve->read_bytes);
 
+		if ((se_cmd->data_direction = DMA_TO_DEVICE) &&
+		    deve->lun_access_ro) {
+			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				" Access for 0x%08llx\n",
+				se_cmd->se_tfo->fabric_name,
+				se_cmd->orig_fe_lun);
+			rcu_read_unlock();
+			return TCM_WRITE_PROTECTED;
+		}
+
 		se_lun = rcu_dereference(deve->se_lun);
 
 		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
@@ -76,17 +86,6 @@
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
-
-		if ((se_cmd->data_direction = DMA_TO_DEVICE) &&
-		    deve->lun_access_ro) {
-			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				" Access for 0x%08llx\n",
-				se_cmd->se_tfo->fabric_name,
-				se_cmd->orig_fe_lun);
-			rcu_read_unlock();
-			ret = TCM_WRITE_PROTECTED;
-			goto ref_dev;
-		}
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -106,21 +105,20 @@
 			return TCM_NON_EXISTENT_LUN;
 		}
 
-		se_lun = se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
-
-		percpu_ref_get(&se_lun->lun_ref);
-		se_cmd->lun_ref_active = true;
-
 		/*
 		 * Force WRITE PROTECT for virtual LUN 0
 		 */
 		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
-		    (se_cmd->data_direction != DMA_NONE)) {
-			ret = TCM_WRITE_PROTECTED;
-			goto ref_dev;
-		}
+		    (se_cmd->data_direction != DMA_NONE))
+			return TCM_WRITE_PROTECTED;
+
+		se_lun = se_sess->se_tpg->tpg_virt_lun0;
+		if (!percpu_ref_tryget_live(&se_lun->lun_ref))
+			return TCM_NON_EXISTENT_LUN;
+
+		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
+		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
+		se_cmd->lun_ref_active = true;
 	}
 	/*
 	 * RCU reference protected by percpu se_lun->lun_ref taken above that
@@ -128,7 +126,6 @@
 	 * pointer can be kfree_rcu() by the final se_lun->lun_group put via
 	 * target_core_fabric_configfs.c:target_fabric_port_release
 	 */
-ref_dev:
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	atomic_long_inc(&se_cmd->se_dev->num_cmds);
 
-- 
1.8.3.1
