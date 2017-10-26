From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 26 Oct 2017 14:43:28 +0000
Subject: [PATCH] target/iscsi: Simplify timer manipulation code
Message-Id: <20171026144328.31680-1-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Move timer initialization from before add_timer() to the context
where the containing object is initialized. Use setup_timer() and
mod_timer() instead of open coding these. Use 'jiffies' instead
of get_jiffies_64() when calculating expiry times because expiry
times have type unsigned long, just like 'jiffies'.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |  3 +++
 drivers/target/iscsi/iscsi_target_erl0.c  | 10 +++-------
 drivers/target/iscsi/iscsi_target_erl0.h  |  1 +
 drivers/target/iscsi/iscsi_target_erl1.c  |  8 ++------
 drivers/target/iscsi/iscsi_target_erl1.h  |  1 +
 drivers/target/iscsi/iscsi_target_login.c | 16 ++++++++++------
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  |  8 +++-----
 drivers/target/iscsi/iscsi_target_util.c  | 26 ++++++++------------------
 drivers/target/iscsi/iscsi_target_util.h  |  2 ++
 10 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5001261f5d69..7d619160b3d3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -372,6 +372,9 @@ struct iscsi_np *iscsit_add_np(
 	init_completion(&np->np_restart_comp);
 	INIT_LIST_HEAD(&np->np_list);
 
+	setup_timer(&np->np_login_timer, iscsi_handle_login_thread_timeout,
+		    (unsigned long)np);
+
 	ret = iscsi_target_setup_login_socket(np, sockaddr);
 	if (ret != 0) {
 		kfree(np);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 7fe2aa73cff6..f164098594e9 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -749,7 +749,7 @@ int iscsit_check_post_dataout(
 	}
 }
 
-static void iscsit_handle_time2retain_timeout(unsigned long data)
+void iscsit_handle_time2retain_timeout(unsigned long data)
 {
 	struct iscsi_session *sess = (struct iscsi_session *) data;
 	struct iscsi_portal_group *tpg = sess->tpg;
@@ -809,14 +809,10 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 	pr_debug("Starting Time2Retain timer for %u seconds on"
 		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
 
-	init_timer(&sess->time2retain_timer);
-	sess->time2retain_timer.expires -		(get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
-	sess->time2retain_timer.data = (unsigned long)sess;
-	sess->time2retain_timer.function = iscsit_handle_time2retain_timeout;
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
 	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&sess->time2retain_timer);
+	mod_timer(&sess->time2retain_timer,
+		  jiffies + sess->sess_ops->DefaultTime2Retain * HZ);
 }
 
 /*
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 3822d9cd1230..97e4ae728926 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -11,6 +11,7 @@ extern void iscsit_set_dataout_sequence_values(struct iscsi_cmd *);
 extern int iscsit_check_pre_dataout(struct iscsi_cmd *, unsigned char *);
 extern int iscsit_check_post_dataout(struct iscsi_cmd *, unsigned char *, u8);
 extern void iscsit_start_time2retain_handler(struct iscsi_session *);
+extern void iscsit_handle_time2retain_timeout(unsigned long data);
 extern int iscsit_stop_time2retain_timer(struct iscsi_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsi_conn *, int);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index fe9b7f1e44ac..19b28255b687 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1148,7 +1148,7 @@ static int iscsit_set_dataout_timeout_values(
 /*
  *	NOTE: Called from interrupt (timer) context.
  */
-static void iscsit_handle_dataout_timeout(unsigned long data)
+void iscsit_handle_dataout_timeout(unsigned long data)
 {
 	u32 pdu_length = 0, pdu_offset = 0;
 	u32 r2t_length = 0, r2t_offset = 0;
@@ -1264,13 +1264,9 @@ void iscsit_start_dataout_timer(
 	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
 		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
 
-	init_timer(&cmd->dataout_timer);
-	cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
-	cmd->dataout_timer.data = (unsigned long)cmd;
-	cmd->dataout_timer.function = iscsit_handle_dataout_timeout;
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&cmd->dataout_timer);
+	mod_timer(&cmd->dataout_timer, jiffies + na->dataout_timeout * HZ);
 }
 
 void iscsit_stop_dataout_timer(struct iscsi_cmd *cmd)
diff --git a/drivers/target/iscsi/iscsi_target_erl1.h b/drivers/target/iscsi/iscsi_target_erl1.h
index 54d36bd25bea..0ff6e310ca36 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.h
+++ b/drivers/target/iscsi/iscsi_target_erl1.h
@@ -29,6 +29,7 @@ extern int iscsit_execute_ooo_cmdsns(struct iscsi_session *);
 extern int iscsit_execute_cmd(struct iscsi_cmd *, int);
 extern int iscsit_handle_ooo_cmdsn(struct iscsi_session *, struct iscsi_cmd *, u32);
 extern void iscsit_remove_ooo_cmdsn(struct iscsi_session *, struct iscsi_ooo_cmdsn *);
+extern void iscsit_handle_dataout_timeout(unsigned long data);
 extern void iscsit_mod_dataout_timer(struct iscsi_cmd *);
 extern void iscsit_start_dataout_timer(struct iscsi_cmd *, struct iscsi_conn *);
 extern void iscsit_stop_dataout_timer(struct iscsi_cmd *);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index dc13afbd4c88..8be9221b6b9d 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -333,6 +333,9 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
+	setup_timer(&sess->time2retain_timer, iscsit_handle_time2retain_timeout,
+		    (unsigned long)sess);
+
 	idr_preload(GFP_KERNEL);
 	spin_lock_bh(&sess_idr_lock);
 	ret = idr_alloc(&sess_idr, NULL, 0, 0, GFP_NOWAIT);
@@ -839,7 +842,7 @@ void iscsi_post_login_handler(
 	iscsit_dec_conn_usage_count(conn);
 }
 
-static void iscsi_handle_login_thread_timeout(unsigned long data)
+void iscsi_handle_login_thread_timeout(unsigned long data)
 {
 	struct iscsi_np *np = (struct iscsi_np *) data;
 
@@ -866,13 +869,9 @@ static void iscsi_start_login_thread_timer(struct iscsi_np *np)
 	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeout
 	 */
 	spin_lock_bh(&np->np_thread_lock);
-	init_timer(&np->np_login_timer);
-	np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	np->np_login_timer.data = (unsigned long)np;
-	np->np_login_timer.function = iscsi_handle_login_thread_timeout;
 	np->np_login_timer_flags &= ~ISCSI_TF_STOP;
 	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&np->np_login_timer);
+	mod_timer(&np->np_login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
 
 	pr_debug("Added timeout timer to iSCSI login request for"
 			" %u seconds.\n", TA_LOGIN_TIMEOUT);
@@ -1266,6 +1265,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 
+	setup_timer(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, (unsigned long)conn);
+	setup_timer(&conn->nopin_timer, iscsit_handle_nopin_timeout,
+		    (unsigned long)conn);
+
 	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
 		kfree(conn);
 		return 1;
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 0e1fd6cedd54..f77850bf3e58 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -24,5 +24,6 @@ extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8)
 extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
 				bool, bool);
 extern int iscsi_target_login_thread(void *);
+extern void iscsi_handle_login_thread_timeout(unsigned long data);
 
 #endif   /*** ISCSI_TARGET_LOGIN_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 7a6751fecd32..c851bd9f3175 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -618,11 +618,9 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	conn->login_kworker = current;
 	allow_signal(SIGINT);
 
-	init_timer(&login_timer);
-	login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	login_timer.data = (unsigned long)conn;
-	login_timer.function = iscsi_target_login_timeout;
-	add_timer(&login_timer);
+	setup_timer_on_stack(&login_timer, iscsi_target_login_timeout,
+			     (unsigned long)conn);
+	mod_timer(&login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
 	pr_debug("Starting login_timer for %s/%d\n", current->comm, current->pid);
 
 	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1e36f83b5961..505dad5dab7f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -176,6 +176,8 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 	spin_lock_init(&cmd->istate_lock);
 	spin_lock_init(&cmd->error_lock);
 	spin_lock_init(&cmd->r2t_lock);
+	setup_timer(&cmd->dataout_timer, iscsit_handle_dataout_timeout,
+		    (unsigned long)cmd);
 
 	return cmd;
 }
@@ -880,7 +882,7 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 	return 0;
 }
 
-static void iscsit_handle_nopin_response_timeout(unsigned long data)
+void iscsit_handle_nopin_response_timeout(unsigned long data)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn *) data;
 
@@ -949,14 +951,10 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 		return;
 	}
 
-	init_timer(&conn->nopin_response_timer);
-	conn->nopin_response_timer.expires -		(get_jiffies_64() + na->nopin_response_timeout * HZ);
-	conn->nopin_response_timer.data = (unsigned long)conn;
-	conn->nopin_response_timer.function = iscsit_handle_nopin_response_timeout;
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&conn->nopin_response_timer);
+	mod_timer(&conn->nopin_response_timer,
+		  jiffies + na->nopin_response_timeout * HZ);
 
 	pr_debug("Started NOPIN Response Timer on CID: %d to %u"
 		" seconds\n", conn->cid, na->nopin_response_timeout);
@@ -980,7 +978,7 @@ void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-static void iscsit_handle_nopin_timeout(unsigned long data)
+void iscsit_handle_nopin_timeout(unsigned long data)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn *) data;
 
@@ -1015,13 +1013,9 @@ void __iscsit_start_nopin_timer(struct iscsi_conn *conn)
 	if (conn->nopin_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	init_timer(&conn->nopin_timer);
-	conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
-	conn->nopin_timer.data = (unsigned long)conn;
-	conn->nopin_timer.function = iscsit_handle_nopin_timeout;
 	conn->nopin_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&conn->nopin_timer);
+	mod_timer(&conn->nopin_timer, jiffies + na->nopin_timeout * HZ);
 
 	pr_debug("Started NOPIN Timer on CID: %d at %u second"
 		" interval\n", conn->cid, na->nopin_timeout);
@@ -1043,13 +1037,9 @@ void iscsit_start_nopin_timer(struct iscsi_conn *conn)
 		return;
 	}
 
-	init_timer(&conn->nopin_timer);
-	conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
-	conn->nopin_timer.data = (unsigned long)conn;
-	conn->nopin_timer.function = iscsit_handle_nopin_timeout;
 	conn->nopin_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
-	add_timer(&conn->nopin_timer);
+	mod_timer(&conn->nopin_timer, jiffies + na->nopin_timeout * HZ);
 
 	pr_debug("Started NOPIN Timer on CID: %d at %u second"
 			" interval\n", conn->cid, na->nopin_timeout);
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 425160565d0c..78b3b9d20963 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -47,9 +47,11 @@ extern struct iscsi_conn *iscsit_get_conn_from_cid_rcfr(struct iscsi_session *,
 extern void iscsit_check_conn_usage_count(struct iscsi_conn *);
 extern void iscsit_dec_conn_usage_count(struct iscsi_conn *);
 extern void iscsit_inc_conn_usage_count(struct iscsi_conn *);
+extern void iscsit_handle_nopin_response_timeout(unsigned long data);
 extern void iscsit_mod_nopin_response_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_response_timer(struct iscsi_conn *);
 extern void iscsit_stop_nopin_response_timer(struct iscsi_conn *);
+extern void iscsit_handle_nopin_timeout(unsigned long data);
 extern void __iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_stop_nopin_timer(struct iscsi_conn *);
-- 
2.14.2

