From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 05:54:33 +0000
Subject: [PATCH-4.9.y 2/2] qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT (v2)
Message-Id: <1510812307-14530-3-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812307-14530-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812307-14530-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Pascal de Bruijn <p.debruijn@unilogic.nl>, Lukasz Engel <lukasz.engel@softax.pl>, Quinn Tran <quinn.tran@cavium.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 6bcbb3174caa5f1ccc894f8ae077631659d5a629 upstream.

This patch drops two incorrect usages of tcm_qla2xxx_free_cmd()
during TMR ABORT within tcm_qla2xxx_handle_data_work() and
tcm_qla2xxx_aborted_task(), which where attempting to dispatch
into workqueue context to do tcm_qla2xxx_complete_free() and
subsequently invoke transport_generic_free_cmd().

This is incorrect because during TMR ABORT target-core will
drop the outstanding se_cmd->cmd_kref references once it has
quiesced the se_cmd via transport_wait_for_tasks(), and in
the case of qla2xxx it should not attempt to do it's own
transport_generic_free_cmd() once the abort has occured.

As reported by Pascal, this was originally manifesting as a
BUG_ON(cmd->cmd_in_wq) in qlt_free_cmd() during TMR ABORT,
with a LIO backend that had sufficently high enough WRITE
latency to trigger a host side TMR ABORT_TASK.

(v2: Drop the qla_tgt_cmd->write_pending_abort_comp changes,
     as they will be addressed in a seperate series)

Reported-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
Tested-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
Cc: Pascal de Bruijn <p.debruijn@unilogic.nl>
Reported-by: Lukasz Engel <lukasz.engel@softax.pl>
Cc: Lukasz Engel <lukasz.engel@softax.pl>
Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..0ad8ece 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -484,7 +484,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
-	unsigned long flags;
 
 	/*
 	 * Ensure that the complete FCP WRITE payload has been received.
@@ -492,17 +491,6 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	 */
 	cmd->cmd_in_wq = 0;
 
-	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	cmd->cmd_flags |= CMD_FLAG_DATA_WORK;
-	if (cmd->aborted) {
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
-		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-
-		tcm_qla2xxx_free_cmd(cmd);
-		return;
-	}
-	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-
 	cmd->vha->tgt_counters.qla_core_ret_ctio++;
 	if (!cmd->write_data_transferred) {
 		/*
@@ -682,34 +670,13 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 	qlt_xmit_tm_rsp(mcmd);
 }
 
-
-#define DATA_WORK_NOT_FREE(_flags) \
-	(( _flags & (CMD_FLAG_DATA_WORK|CMD_FLAG_DATA_WORK_FREE)) = \
-	 CMD_FLAG_DATA_WORK)
 static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	unsigned long flags;
 
 	if (qlt_abort_cmd(cmd))
 		return;
-
-	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	if ((cmd->state = QLA_TGT_STATE_NEW)||
-		((cmd->state = QLA_TGT_STATE_DATA_IN) &&
-		 DATA_WORK_NOT_FREE(cmd->cmd_flags)) ) {
-
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
-		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-		/* Cmd have not reached firmware.
-		 * Use this trigger to free it. */
-		tcm_qla2xxx_free_cmd(cmd);
-		return;
-	}
-	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-	return;
-
 }
 
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
-- 
1.8.5.3

