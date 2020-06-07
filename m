From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Sun, 07 Jun 2020 19:58:30 +0000
Subject: [PATCH v4 1/4] target: factor out a new helper, target_cmd_init_cdb()
Message-Id: <1591559913-8388-2-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com

target_setup_cmd_from_cdb() is called after a successful call to
transport_lookup_cmd_lun(). The new helper factors out the code that can
be called before the call to transport_lookup_cmd_lun(). This helper
will be used in an upcoming commit to address NULL pointer dereference.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/target_core_transport.c | 16 ++++++++++++----
 include/target/target_core_fabric.h    |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e6b448f43071..f2f7c5b818cc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1410,11 +1410,8 @@ void transport_init_se_cmd(
 }
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
-	struct se_device *dev = cmd->se_dev;
-	sense_reason_t ret;
-
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1448,6 +1445,17 @@ void transport_init_se_cmd(
 	memcpy(cmd->t_task_cdb, cdb, scsi_command_size(cdb));
 
 	trace_target_sequencer_start(cmd);
+	return 0;
+}
+EXPORT_SYMBOL(target_cmd_init_cdb);
+
+sense_reason_t
+target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+{
+	struct se_device *dev = cmd->se_dev;
+	sense_reason_t ret;
+
+	target_cmd_init_cdb(cmd, cdb);
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret = TCM_UNSUPPORTED_SCSI_OPCODE)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 063f133e47c2..6a2bfcca0c98 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -152,6 +152,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
+sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
-- 
1.8.3.1
