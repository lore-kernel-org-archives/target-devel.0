From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:04 +0000
Subject: [PATCH 17/20] target: Do not duplicate the code that marks that a command has sense data
Message-Id: <20180622215307.8758-18-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_transport.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cb48dbc2c9ba..ebbc7e321cf3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2121,9 +2121,6 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		if (cmd->scsi_status)
 			goto queue_status;
 
-		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
-		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 		translate_sense_reason(cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
 		goto queue_status;
 	}
@@ -3199,6 +3196,9 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		ascq = si->ascq;
 	}
 
+	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
+	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
 		return scsi_set_sense_information(buffer,
@@ -3225,9 +3225,6 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 	if (!from_transport) {
 		int rc;
 
-		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
-		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 		rc = translate_sense_reason(cmd, reason);
 		if (rc)
 			return rc;
-- 
2.17.1

