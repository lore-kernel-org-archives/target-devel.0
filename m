From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 13 Mar 2020 17:06:54 +0000
Subject: [PATCH RESEND 1/3] target: remove boilerplate code
Message-Id: <20200313170656.9716-2-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200313170656.9716-1-mlombard@redhat.com>
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de, mcoleman@datto.com, linux-scsi@vger.kernel.org

iscsit_free_session() is equivalent to iscsit_stop_session()
followed by a call to iscsit_close_session()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 46 ++---------------------------
 drivers/target/iscsi/iscsi_target.h |  1 -
 2 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59d32453b891..a955ab73eaae 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4577,49 +4577,6 @@ void iscsit_fail_session(struct iscsi_session *sess)
 	sess->session_state = TARG_SESS_STATE_FAILED;
 }
 
-int iscsit_free_session(struct iscsi_session *sess)
-{
-	u16 conn_count = atomic_read(&sess->nconn);
-	struct iscsi_conn *conn, *conn_tmp = NULL;
-	int is_last;
-
-	spin_lock_bh(&sess->conn_lock);
-	atomic_set(&sess->sleep_on_sess_wait_comp, 1);
-
-	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
-			conn_list) {
-		if (conn_count == 0)
-			break;
-
-		if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
-			is_last = 1;
-		} else {
-			iscsit_inc_conn_usage_count(conn_tmp);
-			is_last = 0;
-		}
-		iscsit_inc_conn_usage_count(conn);
-
-		spin_unlock_bh(&sess->conn_lock);
-		iscsit_cause_connection_reinstatement(conn, 1);
-		spin_lock_bh(&sess->conn_lock);
-
-		iscsit_dec_conn_usage_count(conn);
-		if (is_last == 0)
-			iscsit_dec_conn_usage_count(conn_tmp);
-
-		conn_count--;
-	}
-
-	if (atomic_read(&sess->nconn)) {
-		spin_unlock_bh(&sess->conn_lock);
-		wait_for_completion(&sess->session_wait_comp);
-	} else
-		spin_unlock_bh(&sess->conn_lock);
-
-	iscsit_close_session(sess);
-	return 0;
-}
-
 void iscsit_stop_session(
 	struct iscsi_session *sess,
 	int session_sleep,
@@ -4704,7 +4661,8 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
 
-		iscsit_free_session(sess);
+		iscsit_stop_session(sess, 1, 1);
+		iscsit_close_session(sess);
 		session_count++;
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index c95f56a3ce31..7409ce2a6607 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -43,7 +43,6 @@ extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsi_conn *);
 extern int iscsit_close_session(struct iscsi_session *);
 extern void iscsit_fail_session(struct iscsi_session *);
-extern int iscsit_free_session(struct iscsi_session *);
 extern void iscsit_stop_session(struct iscsi_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
 
-- 
2.21.0
