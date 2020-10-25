From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 25 Oct 2020 23:03:14 +0000
Subject: [PATCH 3/7] tcm qlaxx: move sess cmd list/lock to driver
Message-Id: <1603666998-8086-4-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>

Except for debug output in the shutdown path, tcm qla2xxx is the only
driver using the se_session sess_cmd_list. This moves the list to that
driver so in the next patches we can remove the sess_cmd_lock from the
main IO path for the rest of the drivers.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |  2 ++
 drivers/scsi/qla2xxx/qla_target.c  |  2 +-
 drivers/scsi/qla2xxx/qla_target.h  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 47 +++++++++++++++++++++++---------------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a165120..b6284ad 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2484,6 +2484,8 @@ enum rscn_addr_format {
 	int generation;
 
 	struct se_session *se_sess;
+	struct list_head sess_cmd_list;
+	spinlock_t sess_cmd_lock;
 	struct kref sess_kref;
 	struct qla_tgt *tgt;
 	unsigned long expires;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5c417d3..6cb4348 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4366,7 +4366,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	cmd->trc_flags |= TRC_NEW_CMD;
 
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
-	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
+	list_add_tail(&cmd->sess_cmd_list, &vha->qla_cmd_list);
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 1cff7c6..10e5e6c8 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -856,6 +856,7 @@ struct qla_tgt_cmd {
 	uint8_t cmd_type;
 	uint8_t pad[7];
 	struct se_cmd se_cmd;
+	struct list_head sess_cmd_list;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
 	uint32_t reset_count;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 4abf24c..076e0ab 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -255,6 +255,7 @@ static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	unsigned long flags;
 
 	cmd->cmd_in_wq = 0;
 
@@ -265,6 +266,10 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 	cmd->trc_flags |= TRC_CMD_FREE;
 	cmd->cmd_sent_to_fw = 0;
 
+	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
+	list_del_init(&cmd->sess_cmd_list);
+	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
+
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -451,13 +456,14 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int flags = TARGET_SCF_ACK_KREF;
+	int target_flags = TARGET_SCF_ACK_KREF, ret;
+	unsigned long flags;
 
 	if (bidi)
-		flags |= TARGET_SCF_BIDI_OP;
+		target_flags |= TARGET_SCF_BIDI_OP;
 
 	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
-		flags |= TARGET_SCF_USE_CPUID;
+		target_flags |= TARGET_SCF_USE_CPUID;
 
 	sess = cmd->sess;
 	if (!sess) {
@@ -479,11 +485,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return 0;
 	}
 #endif
-
 	cmd->qpair->tgt_counters.qla_core_sbt_cmd++;
-	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
+	ret = target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
-				data_dir, flags);
+				data_dir, target_flags);
+	if (!ret) {
+		spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+		list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
+		spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
+	}
+
+	return ret;
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
@@ -617,25 +629,20 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
     uint64_t tag)
 {
-	struct qla_tgt_cmd *cmd = NULL;
-	struct se_cmd *secmd;
+	struct qla_tgt_cmd *cmd;
 	unsigned long flags;
 
 	if (!sess->se_sess)
 		return NULL;
 
-	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, se_cmd_list) {
-		/* skip task management functions, including tmr->task_cmd */
-		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (secmd->tag = tag) {
-			cmd = container_of(secmd, struct qla_tgt_cmd, se_cmd);
-			break;
-		}
+	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
+		if (cmd->se_cmd.tag = tag)
+			goto done;
 	}
-	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
+	cmd = NULL;
+done:
+	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
 	return cmd;
 }
@@ -1426,6 +1433,8 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 	uint16_t loop_id = qlat_sess->loop_id;
 	unsigned long flags;
 
+	INIT_LIST_HEAD(&qlat_sess->sess_cmd_list);
+	spin_lock_init(&qlat_sess->sess_cmd_lock);
 	/*
 	 * And now setup se_nacl and session pointers into HW lport internal
 	 * mappings for fabric S_ID and LOOP_ID.
-- 
1.8.3.1
