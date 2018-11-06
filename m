From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 17:17:16 +0000
Subject: [PATCH 08/10] target/core: Fix TAS handling for aborted commands
Message-Id: <20181106171718.89594-9-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The TASK ABORTED STATUS (TAS) bit is defined as follows in SAM:
"TASK_ABORTED: this status shall be returned if a command is aborted
by a command or task management function on another I_T nexus and the
control mode page TAS bit is set to one". TAS handling is spread over
the target core and the iSCSI target driver. If a LUN RESET is
received, the target core will send the TASK_ABORTED response for all
commands for which such a response has to be sent. If an ABORT TASK
is received, only the iSCSI target driver will send the TASK_ABORTED
response for the commands for which that response has to be sent.
That is a bug since all target drivers have to honor the TAS bit. Fix
this by moving the code that handles TAS from the iSCSI target driver
into the target core. Additionally, if a command has been aborted,
instead of sending the TASK_ABORTED status from the context that
processes the SCSI command send it from the context of the ABORT TMF.
The core_tmr_abort_task() change in this patch causes the CMD_T_TAS
flag to be set if a TASK_ABORTED status has to be sent back to the
initiator that submitted the command. If that flag has been set
transport_cmd_finish_abort() will send the TASK_ABORTED response.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c      | 11 ++---
 drivers/target/iscsi/iscsi_target_erl1.c | 28 ++----------
 drivers/target/target_core_tmr.c         |  3 +-
 drivers/target/target_core_transport.c   | 55 +-----------------------
 include/target/target_core_base.h        |  1 -
 include/target/target_core_fabric.h      |  1 -
 6 files changed, 10 insertions(+), 89 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c1d5a173553d..984941e036c8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1493,8 +1493,6 @@ __iscsit_check_dataout_hdr(struct iscsi_conn *conn, void *buf,
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
 				iscsit_stop_dataout_timer(cmd);
 
-			transport_check_aborted_status(se_cmd,
-					(hdr->flags & ISCSI_FLAG_CMD_FINAL));
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
 	} else {
@@ -1509,12 +1507,9 @@ __iscsit_check_dataout_hdr(struct iscsi_conn *conn, void *buf,
 		 * TASK_ABORTED status.
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
-			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
-				if (--cmd->outstanding_r2ts < 1) {
-					iscsit_stop_dataout_timer(cmd);
-					transport_check_aborted_status(
-							se_cmd, 1);
-				}
+			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
+			    --cmd->outstanding_r2ts < 1)
+				iscsit_stop_dataout_timer(cmd);
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index a211e8154f4c..1b54a9c70851 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -943,20 +943,8 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 				return 0;
 			}
 			spin_unlock_bh(&cmd->istate_lock);
-			/*
-			 * Determine if delayed TASK_ABORTED status for WRITEs
-			 * should be sent now if no unsolicited data out
-			 * payloads are expected, or if the delayed status
-			 * should be sent after unsolicited data out with
-			 * ISCSI_FLAG_CMD_FINAL set in iscsi_handle_data_out()
-			 */
-			if (transport_check_aborted_status(se_cmd,
-					(cmd->unsolicited_data = 0)) != 0)
+			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
 				return 0;
-			/*
-			 * Otherwise send CHECK_CONDITION and sense for
-			 * exception
-			 */
 			return transport_send_check_condition_and_sense(se_cmd,
 					cmd->sense_reason, 0);
 		}
@@ -974,13 +962,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				/*
-				 * Send the delayed TASK_ABORTED status for
-				 * WRITEs if no more unsolicitied data is
-				 * expected.
-				 */
-				if (transport_check_aborted_status(se_cmd, 1)
-						!= 0)
+				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
 					return 0;
 
 				iscsit_set_dataout_sequence_values(cmd);
@@ -995,11 +977,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 
 		if ((cmd->data_direction = DMA_TO_DEVICE) &&
 		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-			/*
-			 * Send the delayed TASK_ABORTED status for WRITEs if
-			 * no more nsolicitied data is expected.
-			 */
-			if (transport_check_aborted_status(se_cmd, 1) != 0)
+			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
 				return 0;
 
 			iscsit_set_unsoliticed_dataout(cmd);
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 6d1179a7f043..bca0f8a25f92 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -165,7 +165,8 @@ void core_tmr_abort_task(
 		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
 			se_cmd->se_tfo->get_fabric_name(), ref_tag);
 
-		if (!__target_check_io_state(se_cmd, se_sess, 0))
+		if (!__target_check_io_state(se_cmd, se_sess,
+					     dev->dev_attrib.emulate_tas))
 			continue;
 
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 34cfd6a83505..b42187f69eea 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1804,7 +1804,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	if (cmd->transport_complete_callback)
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
-	if (transport_check_aborted_status(cmd, 1))
+	if (cmd->transport_state & CMD_T_ABORTED)
 		return;
 
 	switch (sense_reason) {
@@ -2011,8 +2011,6 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	return true;
 }
 
-static int __transport_check_aborted_status(struct se_cmd *, int);
-
 void target_execute_cmd(struct se_cmd *cmd)
 {
 	/*
@@ -2022,7 +2020,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 * If the received CDB has already been aborted stop processing it here.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
-	if (__transport_check_aborted_status(cmd, 1)) {
+	if (cmd->transport_state & CMD_T_ABORTED) {
 		spin_unlock_irq(&cmd->t_state_lock);
 		return;
 	}
@@ -3236,55 +3234,6 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
-static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
-	__releases(&cmd->t_state_lock)
-	__acquires(&cmd->t_state_lock)
-{
-	int ret;
-
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
-
-	if (!(cmd->transport_state & CMD_T_ABORTED))
-		return 0;
-	/*
-	 * If cmd has been aborted but either no status is to be sent or it has
-	 * already been sent, just return
-	 */
-	if (!send_status || !(cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS)) {
-		if (send_status)
-			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
-		return 1;
-	}
-
-	pr_debug("Sending delayed SAM_STAT_TASK_ABORTED status for CDB:"
-		" 0x%02x ITT: 0x%08llx\n", cmd->t_task_cdb[0], cmd->tag);
-
-	cmd->se_cmd_flags &= ~SCF_SEND_DELAYED_TAS;
-	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-	trace_target_cmd_complete(cmd);
-
-	spin_unlock_irq(&cmd->t_state_lock);
-	ret = cmd->se_tfo->queue_status(cmd);
-	if (ret)
-		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
-	spin_lock_irq(&cmd->t_state_lock);
-
-	return 1;
-}
-
-int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
-{
-	int ret;
-
-	spin_lock_irq(&cmd->t_state_lock);
-	ret = __transport_check_aborted_status(cmd, send_status);
-	spin_unlock_irq(&cmd->t_state_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL(transport_check_aborted_status);
-
 void transport_send_task_abort(struct se_cmd *cmd)
 {
 	unsigned long flags;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bff51baee7e0..31358b0403c8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -134,7 +134,6 @@ enum se_cmd_flags_table {
 	SCF_SENT_CHECK_CONDITION	= 0x00000800,
 	SCF_OVERFLOW_BIT		= 0x00001000,
 	SCF_UNDERFLOW_BIT		= 0x00002000,
-	SCF_SEND_DELAYED_TAS		= 0x00004000,
 	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6859277fc409..3c100c1f3173 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -161,7 +161,6 @@ void	target_execute_cmd(struct se_cmd *cmd);
 int	transport_generic_free_cmd(struct se_cmd *, int);
 
 bool	transport_wait_for_tasks(struct se_cmd *);
-int	transport_check_aborted_status(struct se_cmd *, int);
 int	transport_send_check_condition_and_sense(struct se_cmd *,
 		sense_reason_t, int);
 int	target_get_sess_cmd(struct se_cmd *, bool);
-- 
2.19.1.930.g4563a0d9d0-goog
