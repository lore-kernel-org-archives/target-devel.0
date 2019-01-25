From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:54 +0000
Subject: [PATCH 12/16] target/iscsi: Fix spelling of "unsolicited"
Message-Id: <20190125183458.220477-13-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Change "unsoliticed" into "unsolicited".

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c     | 2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 2 +-
 drivers/target/iscsi/iscsi_target.c         | 8 ++++----
 drivers/target/iscsi/iscsi_target.h         | 2 +-
 drivers/target/iscsi/iscsi_target_erl1.c    | 2 +-
 include/target/iscsi/iscsi_transport.h      | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e3dd13798d79..989f1ac4245c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1186,7 +1186,7 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 	rc = iscsit_sequence_cmd(conn, cmd, buf, hdr->cmdsn);
 
 	if (!rc && dump_payload = false && unsol_data)
-		iscsit_set_unsoliticed_dataout(cmd);
+		iscsit_set_unsolicited_dataout(cmd);
 	else if (dump_payload && imm_data)
 		target_put_sess_cmd(&cmd->se_cmd);
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 25eb3891e34b..29b350a0b58f 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -960,7 +960,7 @@ cxgbit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 			target_put_sess_cmd(&cmd->se_cmd);
 			return 0;
 		} else if (cmd->unsolicited_data) {
-			iscsit_set_unsoliticed_dataout(cmd);
+			iscsit_set_unsolicited_dataout(cmd);
 		}
 
 	} else if (immed_ret = IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 98984c3adfba..7059ffdb0c20 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1194,7 +1194,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 }
 EXPORT_SYMBOL(iscsit_setup_scsi_cmd);
 
-void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *cmd)
+void iscsit_set_unsolicited_dataout(struct iscsi_cmd *cmd)
 {
 	iscsit_set_dataout_sequence_values(cmd);
 
@@ -1202,7 +1202,7 @@ void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *cmd)
 	iscsit_start_dataout_timer(cmd, cmd->conn);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
-EXPORT_SYMBOL(iscsit_set_unsoliticed_dataout);
+EXPORT_SYMBOL(iscsit_set_unsolicited_dataout);
 
 int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			    struct iscsi_scsi_req *hdr)
@@ -1236,7 +1236,7 @@ int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 */
 	if (!cmd->immediate_data) {
 		if (!cmd->sense_reason && cmd->unsolicited_data)
-			iscsit_set_unsoliticed_dataout(cmd);
+			iscsit_set_unsolicited_dataout(cmd);
 		if (!cmd->sense_reason)
 			return 0;
 
@@ -1308,7 +1308,7 @@ iscsit_get_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 			target_put_sess_cmd(&cmd->se_cmd);
 			return rc;
 		} else if (cmd->unsolicited_data)
-			iscsit_set_unsoliticed_dataout(cmd);
+			iscsit_set_unsolicited_dataout(cmd);
 
 	} else if (immed_ret = IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
 		/*
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 48bac0acf8c7..c95f56a3ce31 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -31,7 +31,7 @@ extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
 				struct iscsi_portal_group *, bool);
 extern int iscsit_del_np(struct iscsi_np *);
 extern int iscsit_reject_cmd(struct iscsi_cmd *cmd, u8, unsigned char *);
-extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
+extern void iscsit_set_unsolicited_dataout(struct iscsi_cmd *);
 extern int iscsit_logout_closesession(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_logout_closeconnection(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *, struct iscsi_conn *);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 38210ab09887..c27335c29640 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -979,7 +979,7 @@ int iscsit_execute_cmd(struct iscsi_cmd *cmd, int ooo)
 			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
 				return 0;
 
-			iscsit_set_unsoliticed_dataout(cmd);
+			iscsit_set_unsolicited_dataout(cmd);
 		}
 		return transport_handle_cdb_direct(&cmd->se_cmd);
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 91948bc5b185..8b4b8ce2c1ae 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -53,7 +53,7 @@ extern void iscsit_put_transport(struct iscsit_transport *);
  */
 extern int iscsit_setup_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 				unsigned char *);
-extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
+extern void iscsit_set_unsolicited_dataout(struct iscsi_cmd *);
 extern int iscsit_process_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 				struct iscsi_scsi_req *);
 extern int
-- 
2.20.1.495.gaa96b0ce6b-goog
