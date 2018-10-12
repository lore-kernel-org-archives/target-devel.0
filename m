From: David Disseldorp <ddiss@suse.de>
Date: Fri, 12 Oct 2018 10:01:19 +0000
Subject: [PATCH v2 4/5] target: split out helper for cxn timeout error stashing
Message-Id: <20181012100120.2365-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Replace existing nested code blocks with helper function calls.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 15 +-------------
 drivers/target/iscsi/iscsi_target_util.c | 35 +++++++++++++++++---------------
 drivers/target/iscsi/iscsi_target_util.h |  1 +
 3 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 718fe9a1b709..1193cf884a28 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -770,21 +770,8 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 
 	pr_err("Time2Retain timer expired for SID: %u, cleaning up"
 			" iSCSI session.\n", sess->sid);
-	{
-	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
-
-	if (tiqn) {
-		spin_lock(&tiqn->sess_err_stats.lock);
-		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
-			(void *)sess->sess_ops->InitiatorName);
-		tiqn->sess_err_stats.last_sess_failure_type -				ISCSI_SESS_ERR_CXN_TIMEOUT;
-		tiqn->sess_err_stats.cxn_timeout_errors++;
-		atomic_long_inc(&sess->conn_timeout_errors);
-		spin_unlock(&tiqn->sess_err_stats.lock);
-	}
-	}
 
+	iscsit_fill_cxn_timeout_err_stats(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 	iscsit_close_session(sess);
 }
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 931c51f56435..eacc9d5f78b7 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -933,22 +933,7 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
 	spin_unlock_bh(&conn->nopin_timer_lock);
 
-	{
-	struct iscsi_portal_group *tpg = conn->sess->tpg;
-	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
-
-	if (tiqn) {
-		spin_lock_bh(&tiqn->sess_err_stats.lock);
-		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
-				conn->sess->sess_ops->InitiatorName);
-		tiqn->sess_err_stats.last_sess_failure_type -				ISCSI_SESS_ERR_CXN_TIMEOUT;
-		tiqn->sess_err_stats.cxn_timeout_errors++;
-		atomic_long_inc(&conn->sess->conn_timeout_errors);
-		spin_unlock_bh(&tiqn->sess_err_stats.lock);
-	}
-	}
-
+	iscsit_fill_cxn_timeout_err_stats(sess);
 	iscsit_cause_connection_reinstatement(conn, 0);
 	iscsit_dec_conn_usage_count(conn);
 }
@@ -1407,3 +1392,21 @@ struct iscsi_tiqn *iscsit_snmp_get_tiqn(struct iscsi_conn *conn)
 
 	return tpg->tpg_tiqn;
 }
+
+void iscsit_fill_cxn_timeout_err_stats(struct iscsi_session *sess)
+{
+	struct iscsi_portal_group *tpg = sess->tpg;
+	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
+
+	if (!tiqn)
+		return;
+
+	spin_lock_bh(&tiqn->sess_err_stats.lock);
+	strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+			sess->sess_ops->InitiatorName);
+	tiqn->sess_err_stats.last_sess_failure_type +			ISCSI_SESS_ERR_CXN_TIMEOUT;
+	tiqn->sess_err_stats.cxn_timeout_errors++;
+	atomic_long_inc(&sess->conn_timeout_errors);
+	spin_unlock_bh(&tiqn->sess_err_stats.lock);
+}
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index d66dfc212624..68e84803b0a1 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -67,5 +67,6 @@ extern int rx_data(struct iscsi_conn *, struct kvec *, int, int);
 extern int tx_data(struct iscsi_conn *, struct kvec *, int, int);
 extern void iscsit_collect_login_stats(struct iscsi_conn *, u8, u8);
 extern struct iscsi_tiqn *iscsit_snmp_get_tiqn(struct iscsi_conn *);
+extern void iscsit_fill_cxn_timeout_err_stats(struct iscsi_session *);
 
 #endif /*** ISCSI_TARGET_UTIL_H ***/
-- 
2.13.7
