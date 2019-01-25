From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:55 +0000
Subject: [PATCH 13/16] target/iscsi: Rename a function and a function pointer
Message-Id: <20190125183458.220477-14-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Having both a function and a function pointer member with the same
name (iscsit_release_cmd) is confusing. Hence rename the function
pointer member.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/cxgbit/cxgbit.h      | 2 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c  | 2 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c | 2 +-
 drivers/target/iscsi/iscsi_target_util.c  | 4 ++--
 include/target/iscsi/iscsi_transport.h    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit.h b/drivers/target/iscsi/cxgbit/cxgbit.h
index 417b9e66b0cd..3cca22e19964 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit.h
+++ b/drivers/target/iscsi/cxgbit/cxgbit.h
@@ -345,7 +345,7 @@ struct cxgbit_device *cxgbit_find_device(struct net_device *, u8 *);
 int cxgbit_ddp_init(struct cxgbit_device *);
 int cxgbit_setup_conn_pgidx(struct cxgbit_sock *, u32);
 int cxgbit_reserve_ttt(struct cxgbit_sock *, struct iscsi_cmd *);
-void cxgbit_release_cmd(struct iscsi_conn *, struct iscsi_cmd *);
+void cxgbit_unmap_cmd(struct iscsi_conn *, struct iscsi_cmd *);
 
 static inline
 struct cxgbi_ppm *cdev2ppm(struct cxgbit_device *cdev)
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 76a262674c8d..d57fd3ed3fa5 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -263,7 +263,7 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	r2t->targ_xfer_tag = ttinfo->tag;
 }
 
-void cxgbit_release_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
+void cxgbit_unmap_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index c011c826fc26..4a7bb0b49d17 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -678,7 +678,7 @@ static struct iscsit_transport cxgbit_transport = {
 	.iscsit_get_r2t_ttt	= cxgbit_get_r2t_ttt,
 	.iscsit_get_rx_pdu	= cxgbit_get_rx_pdu,
 	.iscsit_validate_params	= cxgbit_validate_params,
-	.iscsit_release_cmd	= cxgbit_release_cmd,
+	.iscsit_unmap_cmd	= cxgbit_unmap_cmd,
 	.iscsit_aborted_task	= iscsit_aborted_task,
 	.iscsit_get_sup_prot_ops = cxgbit_get_sup_prot_ops,
 };
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 58886d4b33cb..3ac494f63a0b 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -760,8 +760,8 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 		iscsit_remove_cmd_from_response_queue(cmd, conn);
 	}
 
-	if (conn && conn->conn_transport->iscsit_release_cmd)
-		conn->conn_transport->iscsit_release_cmd(conn, cmd);
+	if (conn && conn->conn_transport->iscsit_unmap_cmd)
+		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
 }
 
 void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 8b4b8ce2c1ae..75bee29fd7dd 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -26,7 +26,7 @@ struct iscsit_transport {
 	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
 	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
 			       struct iscsi_datain_req *, const void *, u32);
-	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
+	void (*iscsit_unmap_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
 	int (*iscsit_validate_params)(struct iscsi_conn *);
 	void (*iscsit_get_r2t_ttt)(struct iscsi_conn *, struct iscsi_cmd *,
-- 
2.20.1.495.gaa96b0ce6b-goog
