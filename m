From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Tue, 02 Jun 2020 18:33:45 +0000
Subject: [PATCH v3 3/3] target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
Message-Id: <1591122825-2652-4-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com

This commit also removes the unused argument, cdb that was passed
to this function.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 2 +-
 drivers/target/target_core_transport.c | 6 +++---
 drivers/target/target_core_xcopy.c     | 2 +-
 include/target/target_core_fabric.h    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1110ea507b83..c0966dd4937c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4282fa98ff35..a55a8aaae6b3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1461,7 +1461,7 @@ void transport_init_se_cmd(
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_parse_cdb(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1483,7 +1483,7 @@ void transport_init_se_cmd(
 	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
-EXPORT_SYMBOL(target_setup_cmd_from_cdb);
+EXPORT_SYMBOL(target_cmd_parse_cdb);
 
 /*
  * Used by fabric module frontends to queue tasks directly.
@@ -1645,7 +1645,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	rc = target_cmd_parse_cdb(se_cmd);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
 		return 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index fdd8234906b6..842563ba10f6 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
 		return -EINVAL;
 
 	cmd->tag = 0;
-	if (target_setup_cmd_from_cdb(cmd, cdb))
+	if (target_cmd_parse_cdb(cmd))
 		return -EINVAL;
 
 	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6a2bfcca0c98..1e7ea57d0463 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
-sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
-- 
1.8.3.1
