From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 17:17:15 +0000
Subject: [PATCH 07/10] target/core: Simplify the code for aborting SCSI commands
Message-Id: <20181106171718.89594-8-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of allowing the code that aborts a SCSI command to finish
before all iSCSI data frames have been received, make that code wait
until all iSCSI data frames have been received. Introduce a new
member variable in the target driver template to communicate that
information from the iSCSI target driver to the target core. This
change allows to leave out the check whether or not it is already
safe to send the TASK_ABORTED reply from transport_send_task_abort().

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |  2 ++
 drivers/target/target_core_transport.c       | 22 ++------------------
 include/target/target_core_fabric.h          |  7 +++++++
 3 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 95d0a22b2ad6..1a81386dd7f7 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1596,4 +1596,6 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.tfc_tpg_nacl_attrib_attrs	= lio_target_nacl_attrib_attrs,
 	.tfc_tpg_nacl_auth_attrs	= lio_target_nacl_auth_attrs,
 	.tfc_tpg_nacl_param_attrs	= lio_target_nacl_param_attrs,
+
+	.write_pending_must_be_called	= true,
 };
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7b77520a2b35..34cfd6a83505 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2583,7 +2583,8 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (cmd->transport_state & CMD_T_STOP) {
+	if (cmd->transport_state & CMD_T_STOP &&
+	    !cmd->se_tfo->write_pending_must_be_called) {
 		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
 			 __func__, __LINE__, cmd->tag);
 
@@ -3296,25 +3297,6 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
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
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 
 	transport_lun_remove_cmd(cmd);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index eb9d0923c55c..6859277fc409 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -101,6 +101,13 @@ struct target_core_fabric_ops {
 	struct configfs_attribute **tfc_tpg_nacl_attrib_attrs;
 	struct configfs_attribute **tfc_tpg_nacl_auth_attrs;
 	struct configfs_attribute **tfc_tpg_nacl_param_attrs;
+
+	/*
+	 * Set this member variable to true if the SCSI transport protocol
+	 * (e.g. iSCSI) requires that the Data-Out buffer is transferred in
+	 * its entirety before a command is aborted.
+	 */
+	bool write_pending_must_be_called;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.19.1.930.g4563a0d9d0-goog
