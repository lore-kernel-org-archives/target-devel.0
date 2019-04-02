From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:15 +0000
Subject: [PATCH 11/11] target/iscsi: Make sure PDU processing continues if parsing a command fails
Message-Id: <20190402195815.254796-12-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Currently the iSCSI target driver sends a CHECK CONDITION code
back to the initiator if the immediate data buffer is too large
but it does not discard that immediate data buffer. The result
is that the iSCSI target driver attempts to parse the immediate
data itself as iSCSI PDUs and that all further iSCSI communication
fails. Fix this by receiving and discarding too large immediate
data buffers.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c | 39 +++++++++++++----------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f01cdae54277..59d32453b891 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1285,27 +1285,27 @@ iscsit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 			  bool dump_payload)
 {
 	int cmdsn_ret = 0, immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+	int rc;
+
 	/*
 	 * Special case for Unsupported SAM WRITE Opcodes and ImmediateData=Yes.
 	 */
-	if (dump_payload)
-		goto after_immediate_data;
-	/*
-	 * Check for underflow case where both EDTL and immediate data payload
-	 * exceeds what is presented by CDB's TRANSFER LENGTH, and what has
-	 * already been set in target_cmd_size_check() as se_cmd->data_length.
-	 *
-	 * For this special case, fail the command and dump the immediate data
-	 * payload.
-	 */
-	if (cmd->first_burst_len > cmd->se_cmd.data_length) {
-		cmd->sense_reason = TCM_INVALID_CDB_FIELD;
-		goto after_immediate_data;
+	if (dump_payload) {
+		u32 length = min(cmd->se_cmd.data_length - cmd->write_data_done,
+				 cmd->first_burst_len);
+
+		pr_debug("Dumping min(%d - %d, %d) = %d bytes of immediate data\n",
+			 cmd->se_cmd.data_length, cmd->write_data_done,
+			 cmd->first_burst_len, length);
+		rc = iscsit_dump_data_payload(cmd->conn, length, 1);
+		pr_debug("Finished dumping immediate data\n");
+		if (rc < 0)
+			immed_ret = IMMEDIATE_DATA_CANNOT_RECOVER;
+	} else {
+		immed_ret = iscsit_handle_immediate_data(cmd, hdr,
+							 cmd->first_burst_len);
 	}
 
-	immed_ret = iscsit_handle_immediate_data(cmd, hdr,
-					cmd->first_burst_len);
-after_immediate_data:
 	if (immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION) {
 		/*
 		 * A PDU/CmdSN carrying Immediate Data passed
@@ -1318,12 +1318,9 @@ iscsit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 			return -1;
 
 		if (cmd->sense_reason || cmdsn_ret = CMDSN_LOWER_THAN_EXP) {
-			int rc;
-
-			rc = iscsit_dump_data_payload(cmd->conn,
-						      cmd->first_burst_len, 1);
 			target_put_sess_cmd(&cmd->se_cmd);
-			return rc;
+
+			return 0;
 		} else if (cmd->unsolicited_data)
 			iscsit_set_unsolicited_dataout(cmd);
 
-- 
2.21.0.196.g041f5ea1cf98
