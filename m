From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Tue, 02 Jun 2020 18:33:44 +0000
Subject: [PATCH v3 2/3] target: fix NULL pointer dereference
Message-Id: <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com

NULL pointer dereference happens when the following conditions are met
1) A SCSI command is received for a non-existing LU or cdb
initialization fails in target_setup_cmd_from_cdb().
2) Tracing is enabled.

The following call sequences lead to NULL pointer dereference:

1) iscsit_setup_scsi_cmd
     transport_lookup_cmd_lun <-- lookup fails.
          or
     target_setup_cmd_from_cdb() <-- cdb initialization fails
   iscsit_process_scsi_cmd
     iscsit_sequence_cmd
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

2) target_submit_cmd_map_sgls
     transport_lookup_cmd_lun <-- lookup fails
          or
     target_setup_cmd_from_cdb() <-- cdb initialization fails
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

In the above sequence, cmd->t_task_cdb is uninitialized which when
referenced in trace_target_cmd_complete() causes NULL pointer dereference.

The fix is to use the helper, target_cmd_init_cdb() and call it after
transport_init_se_cmd() is called, so that cmd->t_task_cdb can
be initialized and hence can be referenced in trace_target_cmd_complete().

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 19 ++++++++++++-------
 drivers/target/target_core_transport.c | 28 ++++++++++++++++++++++------
 drivers/target/target_core_xcopy.c     |  3 +++
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..1110ea507b83 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1167,6 +1167,17 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.orig_fe_lun = scsilun_to_int(&hdr->lun);
+	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
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
index f2f7c5b818cc..4282fa98ff35 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1412,6 +1412,9 @@ void transport_init_se_cmd(
 sense_reason_t
 target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
+	sense_reason_t ret;
+
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1420,7 +1423,8 @@ void transport_init_se_cmd(
 		pr_err("Received SCSI CDB with command_size: %d that"
 			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
-		return TCM_INVALID_CDB_FIELD;
+		ret = TCM_INVALID_CDB_FIELD;
+		goto err;
 	}
 	/*
 	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
@@ -1435,10 +1439,10 @@ void transport_init_se_cmd(
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
 				(unsigned long)sizeof(cmd->__t_task_cdb));
-			return TCM_OUT_OF_RESOURCES;
+			ret = TCM_OUT_OF_RESOURCES;
+			goto err;
 		}
-	} else
-		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
+	}
 	/*
 	 * Copy the original CDB into cmd->
 	 */
@@ -1446,6 +1450,13 @@ void transport_init_se_cmd(
 
 	trace_target_sequencer_start(cmd);
 	return 0;
+
+err:
+	/* Copy the CDB here to allow trace_target_cmd_complete() to
+	 * print the cdb to the trace buffers.
+	 */
+	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned int)TCM_MAX_COMMAND_SIZE));
+	return ret;
 }
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
@@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 
-	target_cmd_init_cdb(cmd, cdb);
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret = TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 				data_length, data_dir, task_attr, sense);
 
+	se_cmd->orig_fe_lun = unpacked_lun;
+	rc = target_cmd_init_cdb(se_cmd, cdb);
+	if (rc) {
+		transport_send_check_condition_and_sense(se_cmd, rc, 0);
+		return 0;
+	}
+
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
 	else
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index bd3ed6ce7571..fdd8234906b6 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
 	}
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
+	if (target_cmd_init_cdb(cmd, cdb))
+		return -EINVAL;
+
 	cmd->tag = 0;
 	if (target_setup_cmd_from_cdb(cmd, cdb))
 		return -EINVAL;
-- 
1.8.3.1
