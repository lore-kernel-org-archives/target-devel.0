From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 25 Oct 2020 23:03:13 +0000
Subject: [PATCH 2/7] target: remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
Message-Id: <1603666998-8086-3-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

TARGET_SCF_LOOKUP_LUN_FROM_TAG is no longer used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 33 ---------------------------------
 include/target/target_core_base.h      |  1 -
 2 files changed, 34 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0..ee2d2db 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1764,29 +1764,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
-static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 tag,
-				       u64 *unpacked_lun)
-{
-	struct se_cmd *se_cmd;
-	unsigned long flags;
-	bool ret = false;
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (se_cmd->tag = tag) {
-			*unpacked_lun = se_cmd->orig_fe_lun;
-			ret = true;
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-
-	return ret;
-}
-
 /**
  * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
  *                     for TMR CDBs
@@ -1834,16 +1811,6 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-	/*
-	 * If this is ABORT_TASK with no explicit fabric provided LUN,
-	 * go ahead and search active session tags for a match to figure
-	 * out unpacked_lun for the original se_cmd.
-	 */
-	if (tm_type = TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag,
-						&se_cmd->orig_fe_lun))
-			goto failure;
-	}
 
 	ret = transport_lookup_tmr_lun(se_cmd);
 	if (ret)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 549947d..b3c9946 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -195,7 +195,6 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_USE_CPUID		= 0x08,
-	TARGET_SCF_LOOKUP_LUN_FROM_TAG	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
1.8.3.1
