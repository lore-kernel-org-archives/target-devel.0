From: Mike Christie <mchristi@redhat.com>
Date: Fri, 24 Aug 2018 18:37:13 +0000
Subject: [PATCH 3/3] iscsi target: fix conn_ops double free
Message-Id: <1535135833-7454-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If iscsi_login_init_conn fails it can free conn_ops.
__iscsi_target_login_thread will then call iscsi_target_login_sess_out
which will also free it.

This fixes the problem by organizing conn allocation/setup into parts
that are needed through the life of the conn and parts that are only
needed for the login. The free functions then release what was allocated
in the alloc functions.

With this patch we have:

iscsit_alloc_conn/iscsit_free_conn - allocs/frees the conn we need
for the entire life of the conn.

iscsi_login_init_conn/iscsi_target_nego_release - allocs/frees the parts
of the conn that are only needed during login.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |   9 +-
 drivers/target/iscsi/iscsi_target_login.c | 141 ++++++++++++++++--------------
 drivers/target/iscsi/iscsi_target_login.h |   2 +-
 3 files changed, 77 insertions(+), 75 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8e22379..a4ecc9d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4211,22 +4211,15 @@ int iscsit_close_connection(
 		crypto_free_ahash(tfm);
 	}
 
-	free_cpumask_var(conn->conn_cpumask);
-
-	kfree(conn->conn_ops);
-	conn->conn_ops = NULL;
-
 	if (conn->sock)
 		sock_release(conn->sock);
 
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-	iscsit_put_transport(conn->conn_transport);
-
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
-	kfree(conn);
+	iscsit_free_conn(conn);
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index f6b382d..590c39b 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -67,45 +67,10 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 		goto out_req_buf;
 	}
 
-	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
-	if (!conn->conn_ops) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_ops.\n");
-		goto out_rsp_buf;
-	}
-
-	init_waitqueue_head(&conn->queues_wq);
-	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_cmd_list);
-	INIT_LIST_HEAD(&conn->immed_queue_list);
-	INIT_LIST_HEAD(&conn->response_queue_list);
-	init_completion(&conn->conn_post_wait_comp);
-	init_completion(&conn->conn_wait_comp);
-	init_completion(&conn->conn_wait_rcfr_comp);
-	init_completion(&conn->conn_waiting_on_uc_comp);
-	init_completion(&conn->conn_logout_comp);
-	init_completion(&conn->rx_half_close_comp);
-	init_completion(&conn->tx_half_close_comp);
-	init_completion(&conn->rx_login_comp);
-	spin_lock_init(&conn->cmd_lock);
-	spin_lock_init(&conn->conn_usage_lock);
-	spin_lock_init(&conn->immed_queue_lock);
-	spin_lock_init(&conn->nopin_timer_lock);
-	spin_lock_init(&conn->response_queue_lock);
-	spin_lock_init(&conn->state_lock);
-
-	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
-		pr_err("Unable to allocate conn->conn_cpumask\n");
-		goto out_conn_ops;
-	}
 	conn->conn_login = login;
 
 	return login;
 
-out_conn_ops:
-	kfree(conn->conn_ops);
-out_rsp_buf:
-	kfree(login->rsp_buf);
 out_req_buf:
 	kfree(login->req_buf);
 out_login:
@@ -1157,6 +1122,75 @@ int iscsit_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	return 0;
 }
 
+static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
+{
+	struct iscsi_conn *conn;
+
+	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
+	if (!conn) {
+		pr_err("Could not allocate memory for new connection\n");
+		return NULL;
+	}
+	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state = TARG_CONN_STATE_FREE;
+
+	init_waitqueue_head(&conn->queues_wq);
+	INIT_LIST_HEAD(&conn->conn_list);
+	INIT_LIST_HEAD(&conn->conn_cmd_list);
+	INIT_LIST_HEAD(&conn->immed_queue_list);
+	INIT_LIST_HEAD(&conn->response_queue_list);
+	init_completion(&conn->conn_post_wait_comp);
+	init_completion(&conn->conn_wait_comp);
+	init_completion(&conn->conn_wait_rcfr_comp);
+	init_completion(&conn->conn_waiting_on_uc_comp);
+	init_completion(&conn->conn_logout_comp);
+	init_completion(&conn->rx_half_close_comp);
+	init_completion(&conn->tx_half_close_comp);
+	init_completion(&conn->rx_login_comp);
+	spin_lock_init(&conn->cmd_lock);
+	spin_lock_init(&conn->conn_usage_lock);
+	spin_lock_init(&conn->immed_queue_lock);
+	spin_lock_init(&conn->nopin_timer_lock);
+	spin_lock_init(&conn->response_queue_lock);
+	spin_lock_init(&conn->state_lock);
+
+	timer_setup(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, 0);
+	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
+
+	if (iscsit_conn_set_transport(conn, np->np_transport) < 0)
+		goto free_conn;
+
+	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
+	if (!conn->conn_ops) {
+		pr_err("Unable to allocate memory for struct iscsi_conn_ops.\n");
+		goto put_transport;
+	}
+
+	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
+		pr_err("Unable to allocate conn->conn_cpumask\n");
+		goto free_mask;
+	}
+
+	return conn;
+
+free_mask:
+	free_cpumask_var(conn->conn_cpumask);
+put_transport:
+	iscsit_put_transport(conn->conn_transport);
+free_conn:
+	kfree(conn);
+	return NULL;
+}
+
+void iscsit_free_conn(struct iscsi_conn *conn)
+{
+	free_cpumask_var(conn->conn_cpumask);
+	kfree(conn->conn_ops);
+	iscsit_put_transport(conn->conn_transport);
+	kfree(conn);
+}
+
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		struct iscsi_np *np, bool zero_tsih, bool new_sess)
 {
@@ -1210,10 +1244,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		crypto_free_ahash(tfm);
 	}
 
-	free_cpumask_var(conn->conn_cpumask);
-
-	kfree(conn->conn_ops);
-
 	if (conn->param_list) {
 		iscsi_release_param_list(conn->param_list);
 		conn->param_list = NULL;
@@ -1231,8 +1261,7 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-	iscsit_put_transport(conn->conn_transport);
-	kfree(conn);
+	iscsit_free_conn(conn);
 }
 
 static int __iscsi_target_login_thread(struct iscsi_np *np)
@@ -1262,31 +1291,16 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
-	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
+	conn = iscsit_alloc_conn(np);
 	if (!conn) {
-		pr_err("Could not allocate memory for"
-			" new connection\n");
 		/* Get another socket */
 		return 1;
 	}
-	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
-	conn->conn_state = TARG_CONN_STATE_FREE;
-
-	timer_setup(&conn->nopin_response_timer,
-		    iscsit_handle_nopin_response_timeout, 0);
-	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
-
-	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
-		kfree(conn);
-		return 1;
-	}
 
 	rc = np->np_transport->iscsit_accept_np(np, conn);
 	if (rc = -ENOSYS) {
 		complete(&np->np_restart_comp);
-		iscsit_put_transport(conn->conn_transport);
-		kfree(conn);
-		conn = NULL;
+		iscsit_free_conn(conn);
 		goto exit;
 	} else if (rc < 0) {
 		spin_lock_bh(&np->np_thread_lock);
@@ -1294,17 +1308,13 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 			spin_unlock_bh(&np->np_thread_lock);
 			complete(&np->np_restart_comp);
-			iscsit_put_transport(conn->conn_transport);
-			kfree(conn);
-			conn = NULL;
+			iscsit_free_conn(conn);
 			/* Get another socket */
 			return 1;
 		}
 		spin_unlock_bh(&np->np_thread_lock);
-		iscsit_put_transport(conn->conn_transport);
-		kfree(conn);
-		conn = NULL;
-		goto out;
+		iscsit_free_conn(conn);
+		return 1;
 	}
 	/*
 	 * Perform the remaining iSCSI connection initialization items..
@@ -1454,7 +1464,6 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		tpg_np = NULL;
 	}
 
-out:
 	return 1;
 
 exit:
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 74ac3ab..3b8e363 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -19,7 +19,7 @@ extern int iscsi_target_setup_login_socket(struct iscsi_np *,
 extern int iscsit_accept_np(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
-extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
+extern void iscsit_free_conn(struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-- 
1.8.3.1
