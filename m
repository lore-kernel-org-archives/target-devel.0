From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 23:52:03 +0000
Subject: [PATCH v2 09/10] target/core: Make ABORT and LUN RESET handling synchronous
Message-Id: <20181127235204.186731-10-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of invoking target driver callback functions from the
context that handles an abort or LUN RESET task management function,
only set the abort flag from that context and perform the actual
abort handling from the context of the regular command processing
flow. This approach has the advantage that the task management code
becomes much easier to read and to verify since the number of
potential race conditions against the command processing flow is
strongly reduced.

This patch has been tested by running the following two shell commands
concurrently for about ten minutes for both the iSCSI and the SRP
target drivers ($dev is an initiator device node connected with storage
provided by the target driver under test):
* fio with data verification enabled on a filesystem mounted on top of $dev.
* while true; do sg_reset -d $dev; echo -n .; sleep .1; done

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_internal.h  |   2 -
 drivers/target/target_core_tmr.c       |  49 +++---
 drivers/target/target_core_transport.c | 230 +++++++++++++------------
 include/target/target_core_fabric.h    |   1 +
 4 files changed, 148 insertions(+), 134 deletions(-)

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
index bca0f8a25f92..a89b34587005 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -171,11 +171,15 @@ void core_tmr_abort_task(
 
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
@@ -269,14 +273,28 @@ static void core_tmr_drain_tmr_list(
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
@@ -351,18 +369,7 @@ static void core_tmr_drain_state_list(
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
index 24eafaceffba..8ae787044eef 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -707,32 +707,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
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
@@ -782,12 +756,88 @@ void transport_copy_sense_to_cmd(struct se_cmd *cmd, unsigned char *sense)
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
+static bool target_cmd_interrupted(struct se_cmd *cmd)
+{
+	int post_ret;
+
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		if (cmd->transport_complete_callback)
+			cmd->transport_complete_callback(cmd, false, &post_ret);
+		INIT_WORK(&cmd->work, target_abort_work);
+		queue_work(target_completion_wq, &cmd->work);
+		return true;
+	} else if (cmd->transport_state & CMD_T_STOP) {
+		if (cmd->transport_complete_callback)
+			cmd->transport_complete_callback(cmd, false, &post_ret);
+		complete_all(&cmd->t_transport_stop_comp);
+		return true;
+	}
+
+	return false;
+}
+
+/* May be called from interrupt context so must not sleep. */
 void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 {
-	struct se_device *dev = cmd->se_dev;
 	int success;
 	unsigned long flags;
 
+	if (target_cmd_interrupted(cmd))
+		return;
+
 	cmd->scsi_status = scsi_status;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
@@ -803,25 +853,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
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
@@ -1805,8 +1837,11 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	if (cmd->transport_complete_callback)
 		cmd->transport_complete_callback(cmd, false, &post_ret);
 
-	if (cmd->transport_state & CMD_T_ABORTED)
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		INIT_WORK(&cmd->work, target_abort_work);
+		queue_work(target_completion_wq, &cmd->work);
 		return;
+	}
 
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
@@ -2020,20 +2055,10 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 *
 	 * If the received CDB has already been aborted stop processing it here.
 	 */
-	spin_lock_irq(&cmd->t_state_lock);
-	if (cmd->transport_state & CMD_T_ABORTED) {
-		spin_unlock_irq(&cmd->t_state_lock);
-		return;
-	}
-	if (cmd->transport_state & CMD_T_STOP) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
-			__func__, __LINE__, cmd->tag);
-
-		spin_unlock_irq(&cmd->t_state_lock);
-		complete_all(&cmd->t_transport_stop_comp);
+	if (target_cmd_interrupted(cmd))
 		return;
-	}
 
+	spin_lock_irq(&cmd->t_state_lock);
 	cmd->t_state = TRANSPORT_PROCESSING;
 	cmd->transport_state &= ~CMD_T_PRE_EXECUTE;
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
@@ -2646,14 +2671,30 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
+/*
+ * Call target_put_sess_cmd() and wait until target_release_cmd_kref(@cmd) has
+ * finished.
+ */
+void target_put_cmd_and_wait(struct se_cmd *cmd)
+{
+	DECLARE_COMPLETION_ONSTACK(compl);
+
+	WARN_ON_ONCE(cmd->abrt_compl);
+	cmd->abrt_compl = &compl;
+	target_put_sess_cmd(cmd);
+	wait_for_completion(&compl);
+}
+
 /*
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
+ *   That will cause one reference to be dropped.
  * - During regular command processing the target core sets CMD_T_COMPLETE
  *   before invoking one of the .queue_*() functions.
  * - The code that aborts commands skips commands and TMFs for which
@@ -2665,7 +2706,7 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
  * - For aborted commands for which CMD_T_TAS has been set .queue_status() will
  *   be called and will drop a reference.
  * - For aborted commands for which CMD_T_TAS has not been set .aborted_task()
- *   will be called. transport_cmd_finish_abort() will drop the final reference.
+ *   will be called. target_handle_abort() will drop the final reference.
  */
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
@@ -2690,8 +2731,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 	}
 	if (aborted)
 		cmd->free_compl = &compl;
-	if (!aborted || tas)
-		ret = target_put_sess_cmd(cmd);
+	ret = target_put_sess_cmd(cmd);
 	if (aborted) {
 		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		wait_for_completion(&compl);
@@ -3219,6 +3259,8 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB);
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -3235,46 +3277,15 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
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
@@ -3308,18 +3319,16 @@ static void target_tmr_work(struct work_struct *work)
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
 
 int transport_generic_handle_tmr(
@@ -3338,11 +3347,10 @@ int transport_generic_handle_tmr(
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (aborted) {
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
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 3c100c1f3173..c6d6bfdcd41a 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -156,6 +156,7 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 int	transport_handle_cdb_direct(struct se_cmd *);
 sense_reason_t	transport_generic_new_cmd(struct se_cmd *);
 
+void	target_put_cmd_and_wait(struct se_cmd *cmd);
 void	target_execute_cmd(struct se_cmd *cmd);
 
 int	transport_generic_free_cmd(struct se_cmd *, int);
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
