Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5733FC7EE2C
	for <target-devel@archiver.kernel.org>; Mon,  8 May 2023 16:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjEHQXS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 8 May 2023 12:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjEHQXQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 8 May 2023 12:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426705270
        for <target-devel@vger.kernel.org>; Mon,  8 May 2023 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683562947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cv2+acRB6iO6NrN/g6c5lz9w9kd5uk9+qi0AdJ4YA88=;
        b=I7lHatHCFe8eMe33stkwIzl2lbg9M3W/eWH8mq4XX9Ev7PEXC68uzUmf7flq44xm4jbkIt
        Qpfv3ecMN2Pu16pZa2iYKR1yEBcmwxdGsN06wBxRFF7Kv9XzZ9KOa3pl+bE+utbCGIptUH
        JTIZeOGDDw2171BdXiJ4iNqNiQjWXdk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-v3RY8iwINsWp_hHXpK_drg-1; Mon, 08 May 2023 12:22:24 -0400
X-MC-Unique: v3RY8iwINsWp_hHXpK_drg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDE2587082A;
        Mon,  8 May 2023 16:22:23 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B54412026D16;
        Mon,  8 May 2023 16:22:22 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V3 1/3] target: iscsi: fix hang in the iSCSI login code
Date:   Mon,  8 May 2023 18:22:17 +0200
Message-Id: <20230508162219.1731964-2-mlombard@redhat.com>
In-Reply-To: <20230508162219.1731964-1-mlombard@redhat.com>
References: <20230508162219.1731964-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

If the initiator suddenly stops sending data during a login while
keeping the TCP connection open, the login_work won't be scheduled
and will never release the login semaphore;
concurrent login operations will therefore get stuck and fail.

The bug is due to the inability of the login timeout code to properly
handle this particular case.

Fix the problem by replacing the old per-NP login timer
with a new per-connection timer.

The timer is started when an initiator connects to the target;
if it expires, it sends a SIGINT signal to the thread
pointed at by the conn->login_kworker pointer.

conn->login_kworker is set by calling the iscsit_set_login_timer_kworker()
helper, initially it will point to the np thread;
When the login operation's control is in the process
of being passed from the NP-thread to login_work, the conn->login_worker
pointer is set to NULL.
Finally, login_kworker will be changed to point to the worker thread
executing the login_work job.

If conn->login_kworker is NULL when the timer expires, it means that
the login operation hasn't been completed yet but login_work isn't running,
in this case the timer will mark the login process as failed
and will schedule login_work so the latter will be
forced to free the resources it holds.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |  2 -
 drivers/target/iscsi/iscsi_target_login.c | 63 ++------------------
 drivers/target/iscsi/iscsi_target_nego.c  | 70 +++++++++++++----------
 drivers/target/iscsi/iscsi_target_util.c  | 51 +++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h  |  4 ++
 include/target/iscsi/iscsi_target_core.h  |  6 +-
 6 files changed, 103 insertions(+), 93 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 834cce50f9b0..b516c2893420 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -364,8 +364,6 @@ struct iscsi_np *iscsit_add_np(
 	init_completion(&np->np_restart_comp);
 	INIT_LIST_HEAD(&np->np_list);
 
-	timer_setup(&np->np_login_timer, iscsi_handle_login_thread_timeout, 0);
-
 	ret = iscsi_target_setup_login_socket(np, sockaddr);
 	if (ret != 0) {
 		kfree(np);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 274bdd7845ca..90b870f234f0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -811,59 +811,6 @@ void iscsi_post_login_handler(
 	iscsit_dec_conn_usage_count(conn);
 }
 
-void iscsi_handle_login_thread_timeout(struct timer_list *t)
-{
-	struct iscsi_np *np = from_timer(np, t, np_login_timer);
-
-	spin_lock_bh(&np->np_thread_lock);
-	pr_err("iSCSI Login timeout on Network Portal %pISpc\n",
-			&np->np_sockaddr);
-
-	if (np->np_login_timer_flags & ISCSI_TF_STOP) {
-		spin_unlock_bh(&np->np_thread_lock);
-		return;
-	}
-
-	if (np->np_thread)
-		send_sig(SIGINT, np->np_thread, 1);
-
-	np->np_login_timer_flags &= ~ISCSI_TF_RUNNING;
-	spin_unlock_bh(&np->np_thread_lock);
-}
-
-static void iscsi_start_login_thread_timer(struct iscsi_np *np)
-{
-	/*
-	 * This used the TA_LOGIN_TIMEOUT constant because at this
-	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeout
-	 */
-	spin_lock_bh(&np->np_thread_lock);
-	np->np_login_timer_flags &= ~ISCSI_TF_STOP;
-	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
-	mod_timer(&np->np_login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
-
-	pr_debug("Added timeout timer to iSCSI login request for"
-			" %u seconds.\n", TA_LOGIN_TIMEOUT);
-	spin_unlock_bh(&np->np_thread_lock);
-}
-
-static void iscsi_stop_login_thread_timer(struct iscsi_np *np)
-{
-	spin_lock_bh(&np->np_thread_lock);
-	if (!(np->np_login_timer_flags & ISCSI_TF_RUNNING)) {
-		spin_unlock_bh(&np->np_thread_lock);
-		return;
-	}
-	np->np_login_timer_flags |= ISCSI_TF_STOP;
-	spin_unlock_bh(&np->np_thread_lock);
-
-	del_timer_sync(&np->np_login_timer);
-
-	spin_lock_bh(&np->np_thread_lock);
-	np->np_login_timer_flags &= ~ISCSI_TF_RUNNING;
-	spin_unlock_bh(&np->np_thread_lock);
-}
-
 int iscsit_setup_np(
 	struct iscsi_np *np,
 	struct sockaddr_storage *sockaddr)
@@ -1123,10 +1070,13 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 	spin_lock_init(&conn->nopin_timer_lock);
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
+	spin_lock_init(&conn->login_worker_lock);
+	spin_lock_init(&conn->login_timer_lock);
 
 	timer_setup(&conn->nopin_response_timer,
 		    iscsit_handle_nopin_response_timeout, 0);
 	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
+	timer_setup(&conn->login_timer, iscsit_login_timeout, 0);
 
 	if (iscsit_conn_set_transport(conn, np->np_transport) < 0)
 		goto free_conn;
@@ -1304,7 +1254,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		goto new_sess_out;
 	}
 
-	iscsi_start_login_thread_timer(np);
+	iscsit_start_login_timer(conn, current);
 
 	pr_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
 	conn->conn_state = TARG_CONN_STATE_XPT_UP;
@@ -1417,8 +1367,6 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (ret < 0)
 		goto new_sess_out;
 
-	iscsi_stop_login_thread_timer(np);
-
 	if (ret == 1) {
 		tpg_np = conn->tpg_np;
 
@@ -1434,7 +1382,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 new_sess_out:
 	new_sess = true;
 old_sess_out:
-	iscsi_stop_login_thread_timer(np);
+	iscsit_stop_login_timer(conn);
 	tpg_np = conn->tpg_np;
 	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
 	new_sess = false;
@@ -1448,7 +1396,6 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	return 1;
 
 exit:
-	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_thread_state = ISCSI_NP_THREAD_EXIT;
 	spin_unlock_bh(&np->np_thread_lock);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 24040c118e49..e3a5644a70b3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -535,25 +535,6 @@ static void iscsi_target_login_drop(struct iscsit_conn *conn, struct iscsi_login
 	iscsi_target_login_sess_out(conn, zero_tsih, true);
 }
 
-struct conn_timeout {
-	struct timer_list timer;
-	struct iscsit_conn *conn;
-};
-
-static void iscsi_target_login_timeout(struct timer_list *t)
-{
-	struct conn_timeout *timeout = from_timer(timeout, t, timer);
-	struct iscsit_conn *conn = timeout->conn;
-
-	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
-
-	if (conn->login_kworker) {
-		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
-			 conn->login_kworker->comm, conn->login_kworker->pid);
-		send_sig(SIGINT, conn->login_kworker, 1);
-	}
-}
-
 static void iscsi_target_do_login_rx(struct work_struct *work)
 {
 	struct iscsit_conn *conn = container_of(work,
@@ -562,12 +543,15 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	struct iscsi_np *np = login->np;
 	struct iscsi_portal_group *tpg = conn->tpg;
 	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
-	struct conn_timeout timeout;
 	int rc, zero_tsih = login->zero_tsih;
 	bool state;
 
 	pr_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n",
 			conn, current->comm, current->pid);
+
+	spin_lock(&conn->login_worker_lock);
+	set_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags);
+	spin_unlock(&conn->login_worker_lock);
 	/*
 	 * If iscsi_target_do_login_rx() has been invoked by ->sk_data_ready()
 	 * before initial PDU processing in iscsi_target_start_negotiation()
@@ -597,19 +581,16 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 		goto err;
 	}
 
-	conn->login_kworker = current;
 	allow_signal(SIGINT);
-
-	timeout.conn = conn;
-	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
-	mod_timer(&timeout.timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
-	pr_debug("Starting login timer for %s/%d\n", current->comm, current->pid);
+	rc = iscsit_set_login_timer_kworker(conn, current);
+	if (rc < 0) {
+		/* The login timer has already expired */
+		pr_debug("iscsi_target_do_login_rx, login failed\n");
+		goto err;
+	}
 
 	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
-	del_timer_sync(&timeout.timer);
-	destroy_timer_on_stack(&timeout.timer);
 	flush_signals(current);
-	conn->login_kworker = NULL;
 
 	if (rc < 0)
 		goto err;
@@ -646,7 +627,17 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 		if (iscsi_target_sk_check_and_clear(conn,
 						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
+
+		/*
+		 * Set the login timer thread pointer to NULL to prevent the
+		 * login process from getting stuck if the initiator
+		 * stops sending data.
+		 */
+		rc = iscsit_set_login_timer_kworker(conn, NULL);
+		if (rc < 0)
+			goto err;
 	} else if (rc == 1) {
+		iscsit_stop_login_timer(conn);
 		cancel_delayed_work(&conn->login_work);
 		iscsi_target_nego_release(conn);
 		iscsi_post_login_handler(np, conn, zero_tsih);
@@ -656,6 +647,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 
 err:
 	iscsi_target_restore_sock_callbacks(conn);
+	iscsit_stop_login_timer(conn);
 	cancel_delayed_work(&conn->login_work);
 	iscsi_target_login_drop(conn, login);
 	iscsit_deaccess_np(np, tpg, tpg_np);
@@ -1368,14 +1360,30 @@ int iscsi_target_start_negotiation(
 	 * and perform connection cleanup now.
 	 */
 	ret = iscsi_target_do_login(conn, login);
-	if (!ret && iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
-		ret = -1;
+	if (!ret) {
+		spin_lock(&conn->login_worker_lock);
+
+		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU))
+			ret = -1;
+		else if (!test_bit(LOGIN_FLAGS_WORKER_RUNNING, &conn->login_flags)) {
+			if (iscsit_set_login_timer_kworker(conn, NULL) < 0) {
+				/*
+				 * The timeout has expired already.
+				 * Schedule login_work to perform the cleanup.
+				 */
+				schedule_delayed_work(&conn->login_work, 0);
+			}
+		}
+
+		spin_unlock(&conn->login_worker_lock);
+	}
 
 	if (ret < 0) {
 		iscsi_target_restore_sock_callbacks(conn);
 		iscsi_remove_failed_auth_entry(conn);
 	}
 	if (ret != 0) {
+		iscsit_stop_login_timer(conn);
 		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_nego_release(conn);
 	}
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..b14835fcb033 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1040,6 +1040,57 @@ void iscsit_stop_nopin_timer(struct iscsit_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
+void iscsit_login_timeout(struct timer_list *t)
+{
+	struct iscsit_conn *conn = from_timer(conn, t, login_timer);
+	struct iscsi_login *login = conn->login;
+
+	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
+
+	spin_lock_bh(&conn->login_timer_lock);
+	login->login_failed = 1;
+
+	if (conn->login_kworker) {
+		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
+			 conn->login_kworker->comm, conn->login_kworker->pid);
+		send_sig(SIGINT, conn->login_kworker, 1);
+	} else {
+		schedule_delayed_work(&conn->login_work, 0);
+	}
+	spin_unlock_bh(&conn->login_timer_lock);
+}
+
+void iscsit_start_login_timer(struct iscsit_conn *conn, struct task_struct *kthr)
+{
+	pr_debug("Login timer started\n");
+
+	conn->login_kworker = kthr;
+	mod_timer(&conn->login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
+}
+
+int iscsit_set_login_timer_kworker(struct iscsit_conn *conn, struct task_struct *kthr)
+{
+	struct iscsi_login *login = conn->login;
+	int ret = 0;
+
+	spin_lock_bh(&conn->login_timer_lock);
+	if (login->login_failed) {
+		/* The timer has already expired */
+		ret = -1;
+	} else {
+		conn->login_kworker = kthr;
+	}
+	spin_unlock_bh(&conn->login_timer_lock);
+
+	return ret;
+}
+
+void iscsit_stop_login_timer(struct iscsit_conn *conn)
+{
+	pr_debug("Login timer stopped\n");
+	timer_delete_sync(&conn->login_timer);
+}
+
 int iscsit_send_tx_data(
 	struct iscsit_cmd *cmd,
 	struct iscsit_conn *conn,
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 33ea799a0850..24b8e577575a 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -56,6 +56,10 @@ extern void iscsit_handle_nopin_timeout(struct timer_list *t);
 extern void __iscsit_start_nopin_timer(struct iscsit_conn *);
 extern void iscsit_start_nopin_timer(struct iscsit_conn *);
 extern void iscsit_stop_nopin_timer(struct iscsit_conn *);
+extern void iscsit_login_timeout(struct timer_list *t);
+extern void iscsit_start_login_timer(struct iscsit_conn *, struct task_struct *kthr);
+extern void iscsit_stop_login_timer(struct iscsit_conn *);
+extern int iscsit_set_login_timer_kworker(struct iscsit_conn *, struct task_struct *kthr);
 extern int iscsit_send_tx_data(struct iscsit_cmd *, struct iscsit_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_tx_login_rsp(struct iscsit_conn *, u8, u8);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 229118156a1f..42f4a4c0c100 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -562,12 +562,14 @@ struct iscsit_conn {
 #define LOGIN_FLAGS_READ_ACTIVE		2
 #define LOGIN_FLAGS_WRITE_ACTIVE	3
 #define LOGIN_FLAGS_CLOSED		4
+#define LOGIN_FLAGS_WORKER_RUNNING	5
 	unsigned long		login_flags;
 	struct delayed_work	login_work;
 	struct iscsi_login	*login;
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
 	struct timer_list	transport_timer;
+	struct timer_list	login_timer;
 	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
 	spinlock_t		cmd_lock;
@@ -576,6 +578,8 @@ struct iscsit_conn {
 	spinlock_t		nopin_timer_lock;
 	spinlock_t		response_queue_lock;
 	spinlock_t		state_lock;
+	spinlock_t		login_timer_lock;
+	spinlock_t		login_worker_lock;
 	/* libcrypto RX and TX contexts for crc32c */
 	struct ahash_request	*conn_rx_hash;
 	struct ahash_request	*conn_tx_hash;
@@ -792,7 +796,6 @@ struct iscsi_np {
 	enum np_thread_state_table np_thread_state;
 	bool                    enabled;
 	atomic_t		np_reset_count;
-	enum iscsi_timer_flags_table np_login_timer_flags;
 	u32			np_exports;
 	enum np_flags_table	np_flags;
 	spinlock_t		np_thread_lock;
@@ -800,7 +803,6 @@ struct iscsi_np {
 	struct socket		*np_socket;
 	struct sockaddr_storage np_sockaddr;
 	struct task_struct	*np_thread;
-	struct timer_list	np_login_timer;
 	void			*np_context;
 	struct iscsit_transport *np_transport;
 	struct list_head	np_list;
-- 
2.31.1

