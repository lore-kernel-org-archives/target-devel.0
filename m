From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:54 +0000
Subject: [PATCH 07/20] target: Document when CMD_T_STOP and CMD_T_COMPLETE are set
Message-Id: <20180622215307.8758-8-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Document those aspects of transport_cmd_check_stop_to_fabric() and
transport_generic_free_cmd() of which it is nontrivial to derive
these from their implementation.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 34 +++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 087dddfc5c35..47318f64296d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -632,6 +632,13 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }
 
+/*
+ * This function is called by the target core after the target core has
+ * finished processing a SCSI command or SCSI TMF. Both the regular command
+ * processing code and the code for aborting commands can call this
+ * function. CMD_T_STOP is set if and only if another thread is waiting
+ * inside transport_wait_for_tasks() for t_transport_stop_comp.
+ */
 static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 {
 	unsigned long flags;
@@ -2624,6 +2631,27 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
+/*
+ * This function is called by frontend drivers after processing of a command
+ * has finished.
+ *
+ * The protocol for ensuring that either the regular flow or the TMF
+ * code drops one reference is as follows:
+ * - Calling .queue_data_in(), .queue_status() or queue_tm_rsp() will cause
+ *   the frontend driver to drop one reference, synchronously or asynchronously.
+ * - During regular command processing the target core sets CMD_T_COMPLETE
+ *   before invoking one of the .queue_*() functions.
+ * - The code that aborts commands skips commands and TMFs for which
+ *   CMD_T_COMPLETE has been set.
+ * - CMD_T_ABORTED is set atomically after the CMD_T_COMPLETE check for
+ *   commands that will be aborted.
+ * - If the CMD_T_ABORTED flag is set but CMD_T_TAS has not been set
+ *   transport_generic_free_cmd() skips its call to target_put_sess_cmd().
+ * - For aborted commands for which CMD_T_TAS has been set .queue_status() will
+ *   be called and will drop a reference.
+ * - For aborted commands for which CMD_T_TAS has not been set .aborted_task()
+ *   will be called. transport_cmd_finish_abort() will drop the final reference.
+ */
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	int ret = 0;
@@ -2652,12 +2680,6 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (!aborted || tas)
 			ret = target_put_sess_cmd(cmd);
 	}
-	/*
-	 * If the task has been internally aborted due to TMR ABORT_TASK
-	 * or LUN_RESET, target_core_tmr.c is responsible for performing
-	 * the remaining calls to target_put_sess_cmd(), and not the
-	 * callers of this function.
-	 */
 	if (aborted) {
 		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		wait_for_completion(&cmd->cmd_wait_comp);
-- 
2.17.1

