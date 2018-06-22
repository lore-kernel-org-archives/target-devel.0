From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:05 +0000
Subject: [PATCH 18/20] target: Send unit attention condition even if the sense buffer is too small
Message-Id: <20180622215307.8758-19-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_transport.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ebbc7e321cf3..a71cfae46805 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -64,7 +64,7 @@ struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
 static void transport_complete_task_attr(struct se_cmd *cmd);
-static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
+static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev, int err, bool write_pending);
 static void target_complete_ok_work(struct work_struct *work);
@@ -3170,7 +3170,7 @@ static const struct sense_info sense_info_table[] = {
 	},
 };
 
-static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
+static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
 	const struct sense_info *si;
 	u8 *buffer = cmd->sense_buffer;
@@ -3201,11 +3201,9 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
-		return scsi_set_sense_information(buffer,
-						  cmd->scsi_sense_length,
-						  cmd->bad_sector);
-
-	return 0;
+		WARN_ON_ONCE(scsi_set_sense_information(buffer,
+							cmd->scsi_sense_length,
+							cmd->bad_sector) < 0);
 }
 
 int
@@ -3222,13 +3220,8 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 	cmd->se_cmd_flags |= SCF_SENT_CHECK_CONDITION;
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	if (!from_transport) {
-		int rc;
-
-		rc = translate_sense_reason(cmd, reason);
-		if (rc)
-			return rc;
-	}
+	if (!from_transport)
+		translate_sense_reason(cmd, reason);
 
 	trace_target_cmd_complete(cmd);
 	return cmd->se_tfo->queue_status(cmd);
-- 
2.17.1

