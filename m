From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:30 +0000
Subject: [PATCH 14/15] iscsi target: add test_session callout
Message-Id: <1531696591-8558-15-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Send a iscsi nop as a ping for the test_session callout.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          |  8 ++--
 drivers/target/iscsi/iscsi_target_configfs.c | 47 ++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.c     | 60 +++++++++++++++++++++++++---
 drivers/target/iscsi/iscsi_target_util.h     |  3 +-
 include/target/iscsi/iscsi_target_core.h     |  2 +
 5 files changed, 111 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 793ee98..9338f9b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1795,11 +1795,13 @@ int iscsit_process_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 * This was a response to a unsolicited NOPIN ping.
 	 */
 	if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
-		cmd_p = iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
+		u32 ttt = be32_to_cpu(hdr->ttt);
+
+		cmd_p = iscsit_find_cmd_from_ttt(conn, ttt);
 		if (!cmd_p)
 			return -EINVAL;
 
-		iscsit_stop_nopin_response_timer(conn);
+		iscsit_stop_nopin_response_timer(conn, ttt);
 
 		cmd_p->i_state = ISTATE_REMOVE;
 		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, cmd_p->i_state);
@@ -4107,7 +4109,7 @@ int iscsit_close_connection(
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
-	iscsit_stop_nopin_response_timer(conn);
+	iscsit_stop_nopin_response_timer(conn, conn->test_nop_ttt);
 	iscsit_stop_nopin_timer(conn);
 
 	if (conn->conn_transport->iscsit_wait_conn)
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index d58a6f9..cedbe29 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1510,6 +1510,52 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	iscsit_close_session(sess);
 }
 
+static int lio_test_session(struct se_session *se_sess, u8 timeout)
+{
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	struct iscsi_conn *conn;
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(nop_done);
+
+	spin_lock_bh(&sess->conn_lock);
+	if (sess->session_state != TARG_SESS_STATE_LOGGED_IN) {
+		ret = -ENOTCONN;
+		goto unlock;
+	}
+
+	/*
+	 * If the session state is still logged in, but all the
+	 * connections are in the process of going up/down then
+	 * tell caller to retry later.
+	 */
+	ret = -EAGAIN;
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+		if (conn->conn_state = TARG_CONN_STATE_LOGGED_IN) {
+			ret = 0;
+			break;
+		}
+	}
+	if (ret)
+		goto unlock;
+
+	iscsit_inc_conn_usage_count(conn);
+	spin_unlock_bh(&sess->conn_lock);
+
+	ret = iscsit_sync_nopin(conn, timeout);
+	spin_lock_bh(&sess->conn_lock);
+	if (sess->session_state != TARG_SESS_STATE_LOGGED_IN ||
+	    conn->conn_state != TARG_CONN_STATE_LOGGED_IN)
+		ret = -ENOTCONN;
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsit_dec_conn_usage_count(conn);
+	return ret;
+
+unlock:
+	spin_unlock_bh(&sess->conn_lock);
+	return ret;
+}
+
 static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
 {
 	return iscsi_tpg(se_tpg)->tpg_tiqn->tiqn_index;
@@ -1560,6 +1606,7 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.check_stop_free		= lio_check_stop_free,
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
+	.test_session			= lio_test_session,
 	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.write_pending_status		= lio_write_pending_status,
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index c51c14e..549ad74 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -884,14 +884,15 @@ void iscsit_inc_conn_usage_count(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
 
-static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
+static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response,
+			    bool for_test)
 {
 	u8 state;
 	struct iscsi_cmd *cmd;
 
 	cmd = iscsit_allocate_cmd(conn, TASK_RUNNING);
 	if (!cmd)
-		return -1;
+		return -ENOMEM;
 
 	cmd->iscsi_opcode = ISCSI_OP_NOOP_IN;
 	state = (want_response) ? ISTATE_SEND_NOPIN_WANT_RESPONSE :
@@ -899,6 +900,11 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 	cmd->init_task_tag = RESERVED_ITT;
 	cmd->targ_xfer_tag = (want_response) ?
 			     session_get_next_ttt(conn->sess) : 0xFFFFFFFF;
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (for_test)
+		conn->test_nop_ttt = cmd->targ_xfer_tag;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
 	spin_lock_bh(&conn->cmd_lock);
 	list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
 	spin_unlock_bh(&conn->cmd_lock);
@@ -991,9 +997,12 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn)
+void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn, u32 ttt)
 {
 	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->test_nop_done && conn->test_nop_ttt = ttt)
+		complete(conn->test_nop_done);
+
 	if (!(conn->nopin_response_timer_flags & ISCSI_TF_RUNNING)) {
 		spin_unlock_bh(&conn->nopin_timer_lock);
 		return;
@@ -1008,6 +1017,42 @@ void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
+int iscsit_sync_nopin(struct iscsi_conn *conn, u8 timeout)
+{
+	DECLARE_COMPLETION_ONSTACK(nop_done);
+	int ret;
+
+	spin_lock_bh(&conn->nopin_timer_lock);
+	if (conn->test_nop_done) {
+		spin_unlock_bh(&conn->nopin_timer_lock);
+		return -EBUSY;
+	}
+	conn->test_nop_done = &nop_done;
+	conn->test_nop_ttt = 0xFFFFFFFF;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	ret = iscsit_add_nopin(conn, 1, true);
+	if (ret)
+		goto clear_compl;
+
+	ret = wait_for_completion_timeout(&nop_done,
+					  msecs_to_jiffies(timeout * 1000));
+	if (ret) {
+		ret = 0;
+		goto clear_compl;
+	}
+
+	ret = -ETIMEDOUT;
+
+clear_compl:
+	spin_lock_bh(&conn->nopin_timer_lock);
+	conn->test_nop_ttt = 0xFFFFFFFF;
+	conn->test_nop_done = NULL;
+	spin_unlock_bh(&conn->nopin_timer_lock);
+
+	return ret;
+}
+
 void iscsit_handle_nopin_timeout(struct timer_list *t)
 {
 	struct iscsi_conn *conn = from_timer(conn, t, nopin_timer);
@@ -1015,7 +1060,12 @@ void iscsit_handle_nopin_timeout(struct timer_list *t)
 	iscsit_inc_conn_usage_count(conn);
 
 	spin_lock_bh(&conn->nopin_timer_lock);
-	if (conn->nopin_timer_flags & ISCSI_TF_STOP) {
+	/*
+	 * If a userspace test nop is in progress and started the
+	 * nopin_response_timer then we can skip our test.
+	 */
+	if (conn->nopin_timer_flags & ISCSI_TF_STOP ||
+	    conn->nopin_response_timer_flags & ISCSI_TF_RUNNING) {
 		spin_unlock_bh(&conn->nopin_timer_lock);
 		iscsit_dec_conn_usage_count(conn);
 		return;
@@ -1023,7 +1073,7 @@ void iscsit_handle_nopin_timeout(struct timer_list *t)
 	conn->nopin_timer_flags &= ~ISCSI_TF_RUNNING;
 	spin_unlock_bh(&conn->nopin_timer_lock);
 
-	iscsit_add_nopin(conn, 1);
+	iscsit_add_nopin(conn, 1, false);
 	iscsit_dec_conn_usage_count(conn);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index d66dfc2..3a7fa25 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -51,11 +51,12 @@ extern void iscsit_inc_conn_usage_count(struct iscsi_conn *);
 extern void iscsit_handle_nopin_response_timeout(struct timer_list *t);
 extern void iscsit_mod_nopin_response_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_response_timer(struct iscsi_conn *);
-extern void iscsit_stop_nopin_response_timer(struct iscsi_conn *);
+extern void iscsit_stop_nopin_response_timer(struct iscsi_conn *, u32);
 extern void iscsit_handle_nopin_timeout(struct timer_list *t);
 extern void __iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_stop_nopin_timer(struct iscsi_conn *);
+extern int iscsit_sync_nopin(struct iscsi_conn *conn, u8 timeout);
 extern int iscsit_send_tx_data(struct iscsi_cmd *, struct iscsi_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsi_cmd *, struct iscsi_conn *);
 extern int iscsit_tx_login_rsp(struct iscsi_conn *, u8, u8);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 10031dc..9d06873 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -575,6 +575,8 @@ struct iscsi_conn {
 	struct timer_list	nopin_response_timer;
 	struct timer_list	transport_timer;
 	struct task_struct	*login_kworker;
+	struct completion	*test_nop_done;
+	u32			test_nop_ttt;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
 	spinlock_t		cmd_lock;
 	spinlock_t		conn_usage_lock;
-- 
2.7.2

