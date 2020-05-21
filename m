From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Thu, 21 May 2020 17:42:27 +0000
Subject: [PATCH 2/3] target: fix NULL pointer dereference
Message-Id: <1590082947-993-1-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com, ssudhakarp@gmail.com

NULL pointer dereference happens when a SCSI command is received for a
non-existing LU and tracing is enabled. The following call sequences
lead to NULL pointer dereference:

1) iscsit_setup_scsi_cmd
     transport_lookup_cmd_lun <-- lookup fails.
   iscsit_process_scsi_cmd
     iscsit_sequence_cmd
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

2) target_submit_cmd_map_sgls
     transport_lookup_cmd_lun <-- lookup fails
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

In the above sequence, cmd->t_task_cdb is uninitialized which when
referenced in trace_target_cmd_complete() causes NULL pointer dereference.

The fix is to use the helper, target_init_cmd_from_cdb() and call it
before transport_lookup_cmd_lun() is called, so that cmd->t_task_cdb can
be initialized and hence can be referenced in
trace_target_cmd_complete().

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 19 ++++++++++++-------
 drivers/target/target_core_transport.c | 11 +++++++++--
 drivers/target/target_core_xcopy.c     |  3 +++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..a90b80aee9d8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1167,6 +1167,17 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.orig_fe_lun = scsilun_to_int(&hdr->lun);
+	cmd->sense_reason = target_init_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	if (cmd->sense_reason) {
+		if (cmd->sense_reason = TCM_OUT_OF_RESOURCES) {
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
+		}
+
+		goto attach_cmd;
+	}
+
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
 	if (cmd->sense_reason)
@@ -1175,14 +1186,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
-	if (cmd->sense_reason) {
-		if (cmd->sense_reason = TCM_OUT_OF_RESOURCES) {
-			return iscsit_add_reject_cmd(cmd,
-					ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
-		}
-
+	if (cmd->sense_reason)
 		goto attach_cmd;
-	}
 
 	if (iscsit_build_pdu_and_seq_lists(cmd, payload_length) < 0) {
 		return iscsit_add_reject_cmd(cmd,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f93e25baa664..2e878188dff7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1455,8 +1455,6 @@ void transport_init_se_cmd(
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 
-	target_init_cmd_from_cdb(cmd, cdb);
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret = TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1619,6 +1617,15 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	if (flags & TARGET_SCF_BIDI_OP)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
+
+	se_cmd->orig_fe_lun = unpacked_lun;
+	rc = target_init_cmd_from_cdb(se_cmd, cdb);
+	if (rc) {
+		transport_send_check_condition_and_sense(se_cmd, rc, 0);
+		target_put_sess_cmd(se_cmd);
+		return 0;
+	}
+
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index bd3ed6ce7571..b20c25343cf1 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
 	}
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
+	if (target_init_cmd_from_cdb(cmd, cdb))
+		return -EINVAL;
+
 	cmd->tag = 0;
 	if (target_setup_cmd_from_cdb(cmd, cdb))
 		return -EINVAL;
-- 
1.8.3.1
