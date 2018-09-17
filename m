From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:48 +0000
Subject: [PATCH 11/17] target/core: Make ABORT and LUN RESET handling synchronous
Message-Id: <20180917213554.987-12-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of invoking target driver callback functions from the
context that handles an abort or LUN RESET task management function,
only set the abort flag from that context and perform the actual
abort handling from the context of the regular command processing
flow. This approach has the following advantages:
- The task management function code becomes much easier to read and
  to verify since the number of potential race conditions against
  the command processing flow is strongly reduced.
- It is no longer needed to store the command state into the command
  itself since that information is no longer needed from the context
  where a task management function is processed.

Notes:
- With this patch applied for SCSI commands the CMD_T_ABORTED flag is
  checked at two stages by the target core during command execution:
  just before local execution of a command starts (see also
  target_execute_cmd()) and also just before the response is sent
  (see also target_complete_cmd()).
- The SCF_SEND_DELAYED_TAS has been removed. This flag was used to
  make the second transport_check_aborted_status() call send the
  command status back to the initiator. The new approach is that the
  CMD_T_ABORTED flag is checked from inside target_complete_cmd().
  If that flag is set when that function is called, appropriate
  action is taken - either send the TASK ABORTED status back to the
  initiator or abort the command without sending a response.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_internal.h  |   2 -
 drivers/target/target_core_tmr.c       |  49 ++--
 drivers/target/target_core_transport.c | 304 ++++++++++---------------
 include/target/target_core_base.h      |   1 -
 include/target/target_core_fabric.h    |   1 +
 5 files changed, 153 insertions(+), 204 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 0c6635587930..853344415963 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-int	transport_cmd_finish_abort(struct se_cmd *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
@@ -148,7 +147,6 @@ int	transport_dump_vpd_assoc(struct t10_vpd *, unsigned char *, int);
 int	transport_dump_vpd_ident_type(struct t10_vpd *, unsigned char *, int);
 int	transport_dump_vpd_ident(struct t10_vpd *, unsigned char *, int);
 void	transport_clear_lun_ref(struct se_lun *);
-void	transport_send_task_abort(struct se_cmd *);
 sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
 void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 6d1179a7f043..2750a2c7b563 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -170,11 +170,15 @@ void core_tmr_abort_task(
 
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
-		cancel_work_sync(&se_cmd->work);
-		transport_wait_for_tasks(se_cmd);
+		/*
+		 * Ensure that this ABORT request is visible to the LU RESET
+		 * code.
+		 */
+		if (!tmr->tmr_dev)
+			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd,
+						se_cmd->orig_fe_lun) < 0);
 
-		if (!transport_cmd_finish_abort(se_cmd))
-			target_put_sess_cmd(se_cmd);
+		target_put_cmd_and_wait(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
 				" ref_tag: %llu\n", ref_tag);
@@ -268,14 +272,28 @@ static void core_tmr_drain_tmr_list(
 			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
 
-		cancel_work_sync(&cmd->work);
-		transport_wait_for_tasks(cmd);
-
-		if (!transport_cmd_finish_abort(cmd))
-			target_put_sess_cmd(cmd);
+		target_put_cmd_and_wait(cmd);
 	}
 }
 
+/**
+ * core_tmr_drain_state_list() - abort SCSI commands associated with a device
+ *
+ * @dev:       Device for which to abort outstanding SCSI commands.
+ * @prout_cmd: Pointer to the SCSI PREEMPT AND ABORT if this function is called
+ *             to realize the PREEMPT AND ABORT functionality.
+ * @tmr_sess:  Session through which the LUN RESET has been received.
+ * @tas:       Task Aborted Status (TAS) bit from the SCSI control mode page.
+ *             A quote from SPC-4, paragraph "7.5.10 Control mode page":
+ *             "A task aborted status (TAS) bit set to zero specifies that
+ *             aborted commands shall be terminated by the device server
+ *             without any response to the application client. A TAS bit set
+ *             to one specifies that commands aborted by the actions of an I_T
+ *             nexus other than the I_T nexus on which the command was
+ *             received shall be completed with TASK ABORTED status."
+ * @preempt_and_abort_list: For the PREEMPT AND ABORT functionality, a list
+ *             with registrations that will be preempted.
+ */
 static void core_tmr_drain_state_list(
 	struct se_device *dev,
 	struct se_cmd *prout_cmd,
@@ -350,18 +368,7 @@ static void core_tmr_drain_state_list(
 			 cmd->tag, (preempt_and_abort_list) ? "preempt" : "",
 			 cmd->pr_res_key);
 
-		/*
-		 * If the command may be queued onto a workqueue cancel it now.
-		 *
-		 * This is equivalent to removal from the execute queue in the
-		 * loop above, but we do it down here given that
-		 * cancel_work_sync may block.
-		 */
-		cancel_work_sync(&cmd->work);
-		transport_wait_for_tasks(cmd);
-
-		if (!transport_cmd_finish_abort(cmd))
-			target_put_sess_cmd(cmd);
+		target_put_cmd_and_wait(cmd);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1fecd2bb53af..230a46b03925 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -710,32 +710,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		percpu_ref_put(&lun->lun_ref);
 }
 
-int transport_cmd_finish_abort(struct se_cmd *cmd)
-{
-	bool send_tas = cmd->transport_state & CMD_T_TAS;
-	bool ack_kref = (cmd->se_cmd_flags & SCF_ACK_KREF);
-	int ret = 0;
-
-	if (send_tas)
-		transport_send_task_abort(cmd);
-
-	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD)
-		transport_lun_remove_cmd(cmd);
-	/*
-	 * Allow the fabric driver to unmap any resources before
-	 * releasing the descriptor via TFO->release_cmd()
-	 */
-	if (!send_tas)
-		cmd->se_tfo->aborted_task(cmd);
-
-	if (transport_cmd_check_stop_to_fabric(cmd))
-		return 1;
-	if (!send_tas && ack_kref)
-		ret = target_put_sess_cmd(cmd);
-
-	return ret;
-}
-
 static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -785,12 +759,76 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd, unsigned char *sense)
 }
 EXPORT_SYMBOL(transport_copy_sense_to_cmd);
 
+static void target_handle_abort(struct se_cmd *cmd)
+{
+	bool tas = cmd->transport_state & CMD_T_TAS;
+	bool ack_kref = cmd->se_cmd_flags & SCF_ACK_KREF;
+	int ret;
+
+	pr_debug("tag %#llx: send_abort_response = %d\n", cmd->tag, tas);
+
+	if (cmd->transport_complete_callback)
+		cmd->transport_complete_callback(cmd, false, NULL);
+
+	if (tas) {
+		if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
+			cmd->scsi_status = SAM_STAT_TASK_ABORTED;
+			pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
+				 cmd->t_task_cdb[0], cmd->tag);
+			trace_target_cmd_complete(cmd);
+			ret = cmd->se_tfo->queue_status(cmd);
+			if (ret) {
+				transport_handle_queue_full(cmd, cmd->se_dev,
+							    ret, false);
+				return;
+			}
+		} else {
+			cmd->se_tmr_req->response = TMR_FUNCTION_REJECTED;
+			cmd->se_tfo->queue_tm_rsp(cmd);
+		}
+	} else {
+		/*
+		 * Allow the fabric driver to unmap any resources before
+		 * releasing the descriptor via TFO->release_cmd().
+		 */
+		cmd->se_tfo->aborted_task(cmd);
+		if (ack_kref)
+			WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
+		/*
+		 * To do: establish a unit attention condition on the I_T
+		 * nexus associated with cmd. See also the paragraph "Aborting
+		 * commands" in SAM.
+		 */
+	}
+
+	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) = 0);
+
+	transport_lun_remove_cmd(cmd);
+
+	transport_cmd_check_stop_to_fabric(cmd);
+}
+
+static void target_abort_work(struct work_struct *work)
+{
+	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
+
+	target_handle_abort(cmd);
+}
+
+/* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	struct se_device *dev = cmd->se_dev;
 	int success;
 	unsigned long flags;
 
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		INIT_WORK(&cmd->work, target_abort_work);
+		goto queue_work;
+	} else if (cmd->transport_state & CMD_T_STOP) {
+		complete_all(&cmd->t_transport_stop_comp);
+		return;
+	}
+
 	cmd->scsi_status = scsi_status;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
@@ -806,25 +844,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		break;
 	}
 
-	/*
-	 * Check for case where an explicit ABORT_TASK has been received
-	 * and transport_wait_for_tasks() will be waiting for completion..
-	 */
-	if (cmd->transport_state & CMD_T_ABORTED ||
-	    cmd->transport_state & CMD_T_STOP) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		/*
-		 * If COMPARE_AND_WRITE was stopped by __transport_wait_for_tasks(),
-		 * release se_device->caw_sem obtained by sbc_compare_and_write()
-		 * since target_complete_ok_work() or target_complete_failure_work()
-		 * won't be called to invoke the normal CAW completion callbacks.
-		 */
-		if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) {
-			up(&dev->caw_sem);
-		}
-		complete_all(&cmd->t_transport_stop_comp);
-		return;
-	} else if (!success) {
+	if (!success) {
 		INIT_WORK(&cmd->work, target_complete_failure_work);
 	} else {
 		INIT_WORK(&cmd->work, target_complete_ok_work);
@@ -834,6 +854,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
+queue_work:
 	if (cmd->se_cmd_flags & SCF_USE_CPUID)
 		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 	else
@@ -1804,12 +1825,15 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	 */
 	transport_complete_task_attr(cmd);
 
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		INIT_WORK(&cmd->work, target_abort_work);
+		queue_work(target_completion_wq, &cmd->work);
+		return;
+	}
+
 	if (cmd->transport_complete_callback)
 		cmd->transport_complete_callback(cmd, false, NULL);
 
-	if (transport_check_aborted_status(cmd, 1))
-		return;
-
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
 	case TCM_UNSUPPORTED_SCSI_OPCODE:
@@ -2014,8 +2038,6 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	return true;
 }
 
-static int __transport_check_aborted_status(struct se_cmd *, int);
-
 void target_execute_cmd(struct se_cmd *cmd)
 {
 	/*
@@ -2024,11 +2046,13 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 *
 	 * If the received CDB has already been aborted stop processing it here.
 	 */
-	spin_lock_irq(&cmd->t_state_lock);
-	if (__transport_check_aborted_status(cmd, 1)) {
-		spin_unlock_irq(&cmd->t_state_lock);
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		INIT_WORK(&cmd->work, target_abort_work);
+		queue_work(target_completion_wq, &cmd->work);
 		return;
 	}
+
+	spin_lock_irq(&cmd->t_state_lock);
 	if (cmd->transport_state & CMD_T_STOP) {
 		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
@@ -2675,7 +2699,7 @@ static void __target_put_cmd_and_wait(struct se_cmd *cmd, bool put)
  * Call target_put_sess_cmd() and wait until target_release_cmd_kref(@cmd) has
  * finished.
  */
-static void target_put_cmd_and_wait(struct se_cmd *cmd)
+void target_put_cmd_and_wait(struct se_cmd *cmd)
 {
 	__target_put_cmd_and_wait(cmd, true);
 }
@@ -2694,10 +2718,13 @@ static void target_wait_for_cmd(struct se_cmd *cmd)
  * This function is called by frontend drivers after processing of a command
  * has finished.
  *
- * The protocol for ensuring that either the regular flow or the TMF
- * code drops one reference is as follows:
+ * The protocol for ensuring that either the regular frontend command
+ * processing flow or target_handle_abort() code drops one reference is as
+ * follows:
  * - Calling .queue_data_in(), .queue_status() or queue_tm_rsp() will cause
- *   the frontend driver to drop one reference, synchronously or asynchronously.
+ *   the frontend driver to call this function synchronously or asynchronously.
+ *   Unless CMD_T_ABORTED has been set and CMD_T_TAS has not been set, that will
+ *   cause one reference to be dropped.
  * - During regular command processing the target core sets CMD_T_COMPLETE
  *   before invoking one of the .queue_*() functions.
  * - The code that aborts commands skips commands and TMFs for which
@@ -2709,7 +2736,7 @@ static void target_wait_for_cmd(struct se_cmd *cmd)
  * - For aborted commands for which CMD_T_TAS has been set .queue_status() will
  *   be called and will drop a reference.
  * - For aborted commands for which CMD_T_TAS has not been set .aborted_task()
- *   will be called. transport_cmd_finish_abort() will drop the final reference.
+ *   will be called. target_handle_abort() will drop the final reference.
  */
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
@@ -3293,6 +3320,13 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB);
+
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		target_handle_abort(cmd);
+		return 0;
+	}
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -3309,114 +3343,33 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
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
+/**
+ * transport_check_aborted_status - return 1 if the command has been aborted
+ * @cmd: SCSI command to check the status of.
+ * @send_status: Ignored.
+ *
+ * Note: if this function is called while SCSI WRITE data frames are being
+ * received, the target driver will call target_execute_cmd() after all WRITE
+ * data frames have been received. That function will check the CMD_T_ABORTED
+ * flag again and will handle the abort. At least for the iSCSI target driver
+ * it is essential that an abort is only processed after all WRITE data frames
+ * have been received.
+ */
 int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
-	int ret;
-
-	spin_lock_irq(&cmd->t_state_lock);
-	ret = __transport_check_aborted_status(cmd, send_status);
-	spin_unlock_irq(&cmd->t_state_lock);
-
-	return ret;
+	return cmd->transport_state & CMD_T_ABORTED;
 }
 EXPORT_SYMBOL(transport_check_aborted_status);
 
-void transport_send_task_abort(struct se_cmd *cmd)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->se_cmd_flags & (SCF_SENT_CHECK_CONDITION)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
-	/*
-	 * If there are still expected incoming fabric WRITEs, we wait
-	 * until until they have completed before sending a TASK_ABORTED
-	 * response.  This response with TASK_ABORTED status will be
-	 * queued back to fabric module by transport_check_aborted_status().
-	 */
-	if (cmd->data_direction = DMA_TO_DEVICE) {
-		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
-			spin_lock_irqsave(&cmd->t_state_lock, flags);
-			if (cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS) {
-				spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-				goto send_abort;
-			}
-			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
-			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-			return;
-		}
-	}
-send_abort:
-	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-
-	transport_lun_remove_cmd(cmd);
-
-	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x, ITT: 0x%08llx\n",
-		 cmd->t_task_cdb[0], cmd->tag);
-
-	trace_target_cmd_complete(cmd);
-	ret = cmd->se_tfo->queue_status(cmd);
-	if (ret)
-		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
-}
-
 static void target_tmr_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
 	struct se_device *dev = cmd->se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->transport_state & CMD_T_ABORTED) {
-		tmr->response = TMR_FUNCTION_REJECTED;
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		goto check_stop;
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	if (cmd->transport_state & CMD_T_ABORTED)
+		goto aborted;
 
 	switch (tmr->function) {
 	case TMR_ABORT_TASK:
@@ -3450,44 +3403,35 @@ static void target_tmr_work(struct work_struct *work)
 		break;
 	}
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->transport_state & CMD_T_ABORTED) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		goto check_stop;
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	if (cmd->transport_state & CMD_T_ABORTED)
+		goto aborted;
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
-check_stop:
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
+	return;
+
+aborted:
+	target_handle_abort(cmd);
 }
 
-int transport_generic_handle_tmr(
-	struct se_cmd *cmd)
+int transport_generic_handle_tmr(struct se_cmd *cmd)
 {
 	unsigned long flags;
-	bool aborted = false;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->transport_state & CMD_T_ABORTED) {
-		aborted = true;
-	} else {
-		cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
-		cmd->transport_state |= CMD_T_ACTIVE;
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
-	if (aborted) {
-		pr_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d"
-			"ref_tag: %llu tag: %llu\n", cmd->se_tmr_req->function,
-			cmd->se_tmr_req->ref_task_tag, cmd->tag);
-		transport_lun_remove_cmd(cmd);
-		transport_cmd_check_stop_to_fabric(cmd);
+		pr_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d ref_tag: %llu tag: %llu\n",
+				    cmd->se_tmr_req->function,
+				    cmd->se_tmr_req->ref_task_tag, cmd->tag);
+		target_handle_abort(cmd);
 		return 0;
 	}
 
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
+	cmd->transport_state |= CMD_T_ACTIVE;
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	INIT_WORK(&cmd->work, target_tmr_work);
 	schedule_work(&cmd->work);
 	return 0;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d93ec20710c2..833567125905 100644
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
index eb9d0923c55c..792149993859 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -149,6 +149,7 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 int	transport_handle_cdb_direct(struct se_cmd *);
 sense_reason_t	transport_generic_new_cmd(struct se_cmd *);
 
+void	target_put_cmd_and_wait(struct se_cmd *cmd);
 void	target_execute_cmd(struct se_cmd *cmd);
 
 int	transport_generic_free_cmd(struct se_cmd *, int);
-- 
2.18.0
