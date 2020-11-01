From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 01 Nov 2020 18:59:29 +0000
Subject: [PATCH 3/8] qla2xxx: drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
Message-Id: <1604257174-4524-4-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

It looks like only the __qlt_24xx_handle_abts code path does not know
the lun for an abort and it uses the TARGET_SCF_LOOKUP_LUN_FROM_TAG
flag to have lio core look it up. LIO uses target_lookup_lun_from_tag
to go from cmd tag to lun for the driver. However, qla2xxx has a
tcm_qla2xxx_find_cmd_by_tag which does almost the same thing as the
LIO helper (it finds the cmd but does not return the lun). This patch
has qla2xxx use its internal helper.

This is more of a transition patch and that is why I'm having qla2xxx
use its internal function instead of killing it. The tcm qla2xxx driver
is the only that needs the sess_cmd_list, so the first couple of patches
move that list from LIO core to the driver. The final patches then
remove the sess_cmd_lock from the main IO path.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 21 +++++++++++----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +---
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a27a625..f88548b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2083,6 +2083,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct qla_qpair_hint *h = &vha->vha_tgt.qla_tgt->qphints[0];
+	struct qla_tgt_cmd *abort_cmd;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -2110,17 +2111,17 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	 */
 	mcmd->se_cmd.cpuid = h->cpuid;
 
-	if (ha->tgt.tgt_ops->find_cmd_by_tag) {
-		struct qla_tgt_cmd *abort_cmd;
-
-		abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
+	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-		if (abort_cmd && abort_cmd->qpair) {
-			mcmd->qpair = abort_cmd->qpair;
-			mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
-			mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
-			mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
-		}
+	if (!abort_cmd)
+		return -EIO;
+	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
+
+	if (abort_cmd->qpair) {
+		mcmd->qpair = abort_cmd->qpair;
+		mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
+		mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
+		mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
 	}
 
 	INIT_WORK(&mcmd->work, qlt_do_tmr_work);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 61017ac..f5a91bf 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -574,13 +574,11 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	struct fc_port *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	int transl_tmr_func = 0;
-	int flags = TARGET_SCF_ACK_KREF;
 
 	switch (tmr_func) {
 	case QLA_TGT_ABTS:
 		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
 		transl_tmr_func = TMR_ABORT_TASK;
-		flags |= TARGET_SCF_LOOKUP_LUN_FROM_TAG;
 		break;
 	case QLA_TGT_2G_ABORT_TASK:
 		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
@@ -613,7 +611,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-	    transl_tmr_func, GFP_ATOMIC, tag, flags);
+	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
-- 
1.8.3.1
