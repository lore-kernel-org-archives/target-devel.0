From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:51 +0000
Subject: [PATCH 14/17] target/qla2xxx: Simplify the code for handling aborted commands
Message-Id: <20180917213554.987-15-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since the target core waits anyway until a target driver has
finished processing a command, remove similar waiting code from
the tcm_qla2xxx driver. With this change applied command abortion
works as follows:
* tcm_qla2xxx receives an ABTS and calls target_submit_tmr().
* The target core calls core_tmr_abort_task(). That function
  sets the CMD_T_ABORTED flag and next calls transport_wait_for_tasks().
* If CMD_T_ACTIVE is still set, __transport_wait_for_tasks() sets
  CMD_T_STOP and waits for t_transport_stop_comp.
* When tcm_qla2xxx_handle_data_work() gets called, it either invokes
  transport_generic_request_failure() or target_execute_cmd().
* Both functions start with calling __transport_check_aborted_status()
  and return 1 if CMD_T_ABORTED was set. Otherwise the command that
  is being executed is completed and target_complete_cmd() completes
  t_transport_stop_comp.
* Once transport_wait_for_tasks() returns the target core considers
  the TMF as finished.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index e03d12a5f986..2cedfd4f15a3 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -414,21 +414,14 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 static int tcm_qla2xxx_write_pending_status(struct se_cmd *se_cmd)
 {
 	unsigned long flags;
-	/*
-	 * Check for WRITE_PENDING status to determine if we need to wait for
-	 * CTIO aborts to be posted via hardware in tcm_qla2xxx_handle_data().
-	 */
+	bool wp;
+
 	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
-	if (se_cmd->t_state = TRANSPORT_WRITE_PENDING ||
-	    se_cmd->t_state = TRANSPORT_COMPLETE_QF_WP) {
-		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
-		wait_for_completion_timeout(&se_cmd->t_transport_stop_comp,
-						50);
-		return 0;
-	}
+	wp = se_cmd->t_state = TRANSPORT_WRITE_PENDING ||
+		se_cmd->t_state = TRANSPORT_COMPLETE_QF_WP;
 	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
 
-	return 0;
+	return wp;
 }
 
 static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
@@ -508,15 +501,6 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 
 	cmd->qpair->tgt_counters.qla_core_ret_ctio++;
 	if (!cmd->write_data_transferred) {
-		/*
-		 * Check if se_cmd has already been aborted via LUN_RESET, and
-		 * waiting upon completion in tcm_qla2xxx_write_pending_status()
-		 */
-		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
-			complete(&cmd->se_cmd.t_transport_stop_comp);
-			return;
-		}
-
 		switch (cmd->dif_err_code) {
 		case DIF_ERR_GRD:
 			cmd->se_cmd.pi_err -- 
2.18.0
