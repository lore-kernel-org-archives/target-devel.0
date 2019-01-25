From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:47 +0000
Subject: [PATCH 05/16] target/core: Add target_send_busy()
Message-Id: <20190125183458.220477-6-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Introduce a function that sends the SCSI status "BUSY" back to the
initiator. The next patch will add a call to this function in the
srpt target driver.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 16 ++++++++++++++++
 include/target/target_core_fabric.h    |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6471ede00336..e3f7e21e6614 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3246,6 +3246,22 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
+/**
+ * target_send_busy - Send SCSI BUSY status back to the initiator
+ * @cmd: SCSI command for which to send a BUSY reply.
+ *
+ * Note: Only call this function if target_submit_cmd*() failed.
+ */
+int target_send_busy(struct se_cmd *cmd)
+{
+	WARN_ON_ONCE(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB);
+
+	cmd->scsi_status = SAM_STAT_BUSY;
+	trace_target_cmd_complete(cmd);
+	return cmd->se_tfo->queue_status(cmd);
+}
+EXPORT_SYMBOL(target_send_busy);
+
 static void target_tmr_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 691c6b5e6520..8ed90407f062 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -173,6 +173,7 @@ int	transport_generic_free_cmd(struct se_cmd *, int);
 bool	transport_wait_for_tasks(struct se_cmd *);
 int	transport_send_check_condition_and_sense(struct se_cmd *,
 		sense_reason_t, int);
+int	target_send_busy(struct se_cmd *cmd);
 int	target_get_sess_cmd(struct se_cmd *, bool);
 int	target_put_sess_cmd(struct se_cmd *);
 void	target_sess_cmd_list_set_waiting(struct se_session *);
-- 
2.20.1.495.gaa96b0ce6b-goog
