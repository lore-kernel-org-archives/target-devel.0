Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0ECC6FD1C
	for <target-devel@archiver.kernel.org>; Fri, 10 Mar 2023 10:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCJKFP (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjCJKFN (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 05:05:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A3107D66
        for <target-devel@vger.kernel.org>; Fri, 10 Mar 2023 02:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678442671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6V/GyjYdk1WFbks9kyQJ/0b0ShGE96Vmtgxy9v2teM=;
        b=SLnaecxshts+Y0wrJjeFLDkBDg9jwYVOJJmoLah5pRVL/50hfY9KqQv5wfrSptrBXULL1b
        nX/L53ME1sFDv3vjvoaBhFUs+CVkLaDrM0iIvfyhOlhsaV+OA/zKR1aGVISIaeI9mlZ/14
        GTfJHXWct4t66bJINsVURQ7AoZfOlIw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-DLwMWlZKMWyyRS_UK1j58w-1; Fri, 10 Mar 2023 05:04:28 -0500
X-MC-Unique: DLwMWlZKMWyyRS_UK1j58w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B328D3813F3E;
        Fri, 10 Mar 2023 10:04:27 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DF75C15BA0;
        Fri, 10 Mar 2023 10:04:26 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Subject: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
Date:   Fri, 10 Mar 2023 11:04:21 +0100
Message-Id: <20230310100423.1258256-2-mlombard@redhat.com>
In-Reply-To: <20230310100423.1258256-1-mlombard@redhat.com>
References: <20230310100423.1258256-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

If the initiator suddenly stops sending data during a login while
keeping the TCP connection open, the sk_data_ready callback won't
schedule the login_work and the latter
will never timeout and release the login semaphore.

All the other login operations will therefore get stuck waiting
for the semaphore to be released.

Add a timer to check if the initiator became unresponsive, this is how it
works:

  * The timer is started in iscsi_target_start_negotiation(), before
    clearing tre LOGIN_FLAGS_INITIAL_PDU flag.
  * If iscsi_target_do_login() returned a non-zero value, this means that
    the login operation either failed or didn't require additional PDUs;
    in this case the timer is immediately stopped.
  * If iscsi_target_do_login() returned zero then the control of
    the login operation is passed to login_work that will take over the
    responsibility of releasing the login semaphore and stopping the timer.
  * If login_work gets stuck, the login timer will expire and
    will force the login to fail (by sending a SIGINT to the login kthread
    and by closing the socket).

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_login.c |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 56 ++++++++++-------------
 drivers/target/iscsi/iscsi_target_util.c  | 26 +++++++++++
 drivers/target/iscsi/iscsi_target_util.h  |  3 ++
 include/target/iscsi/iscsi_target_core.h  |  1 +
 5 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..bb7d5a596266 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1127,6 +1127,7 @@ static struct iscsit_conn *iscsit_alloc_conn(struct iscsi_np *np)
 	timer_setup(&conn->nopin_response_timer,
 		    iscsit_handle_nopin_response_timeout, 0);
 	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
+	timer_setup(&conn->login_timer, iscsit_login_timeout, 0);
 
 	if (iscsit_conn_set_transport(conn, np->np_transport) < 0)
 		goto free_conn;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 24040c118e49..f901a7231c48 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -472,12 +472,18 @@ static int iscsi_target_do_login(struct iscsit_conn *, struct iscsi_login *);
 
 static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
-	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
-		pr_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
+	switch (sk->sk_state) {
+	case TCP_FIN_WAIT1:
+	case TCP_FIN_WAIT2:
+	case TCP_CLOSE_WAIT:
+	case TCP_LAST_ACK:
+	case TCP_CLOSE:
+		pr_debug("__iscsi_target_sk_check_close: socket closing,"
 			"returning TRUE\n");
 		return true;
+	default:
+		return false;
 	}
-	return false;
 }
 
 static bool iscsi_target_sk_check_close(struct iscsit_conn *conn)
@@ -535,25 +541,6 @@ static void iscsi_target_login_drop(struct iscsit_conn *conn, struct iscsi_login
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
@@ -562,7 +549,6 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	struct iscsi_np *np = login->np;
 	struct iscsi_portal_group *tpg = conn->tpg;
 	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
-	struct conn_timeout timeout;
 	int rc, zero_tsih = login->zero_tsih;
 	bool state;
 
@@ -597,17 +583,13 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 		goto err;
 	}
 
-	conn->login_kworker = current;
 	allow_signal(SIGINT);
-
-	timeout.conn = conn;
-	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
-	mod_timer(&timeout.timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
-	pr_debug("Starting login timer for %s/%d\n", current->comm, current->pid);
+	iscsit_start_login_timer(conn);
+	conn->login_kworker = current;
 
 	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
-	del_timer_sync(&timeout.timer);
-	destroy_timer_on_stack(&timeout.timer);
+
+	iscsit_stop_login_timer(conn);
 	flush_signals(current);
 	conn->login_kworker = NULL;
 
@@ -646,6 +628,13 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 		if (iscsi_target_sk_check_and_clear(conn,
 						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
+
+		/*
+		 * Restart the login timer to prevent the
+		 * login process from getting stuck if the initiator
+		 * stops sending data.
+		 */
+		iscsit_start_login_timer(conn);
 	} else if (rc == 1) {
 		cancel_delayed_work(&conn->login_work);
 		iscsi_target_nego_release(conn);
@@ -657,6 +646,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 err:
 	iscsi_target_restore_sock_callbacks(conn);
 	cancel_delayed_work(&conn->login_work);
+	iscsit_stop_login_timer(conn);
 	iscsi_target_login_drop(conn, login);
 	iscsit_deaccess_np(np, tpg, tpg_np);
 }
@@ -1358,6 +1348,9 @@ int iscsi_target_start_negotiation(
 		set_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
+
+	iscsit_start_login_timer(conn);
+
 	/*
 	 * If iscsi_target_do_login returns zero to signal more PDU
 	 * exchanges are required to complete the login, go ahead and
@@ -1377,6 +1370,7 @@ int iscsi_target_start_negotiation(
 	}
 	if (ret != 0) {
 		cancel_delayed_work_sync(&conn->login_work);
+		iscsit_stop_login_timer(conn);
 		iscsi_target_nego_release(conn);
 	}
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..414e883c5a0d 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1040,6 +1040,32 @@ void iscsit_stop_nopin_timer(struct iscsit_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
+void iscsit_login_timeout(struct timer_list *t)
+{
+	struct iscsit_conn *conn = from_timer(conn, t, login_timer);
+
+	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
+
+	if (conn->login_kworker) {
+		pr_debug("Sending SIGINT to conn->login_kworker %s/%d\n",
+			 conn->login_kworker->comm, conn->login_kworker->pid);
+		send_sig(SIGINT, conn->login_kworker, 1);
+	}
+	kernel_sock_shutdown(conn->sock, SHUT_RDWR);
+}
+
+void iscsit_start_login_timer(struct iscsit_conn *conn)
+{
+	pr_debug("Login timer started\n");
+	mod_timer(&conn->login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
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
index 33ea799a0850..b3ffb7b204a8 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -56,6 +56,9 @@ extern void iscsit_handle_nopin_timeout(struct timer_list *t);
 extern void __iscsit_start_nopin_timer(struct iscsit_conn *);
 extern void iscsit_start_nopin_timer(struct iscsit_conn *);
 extern void iscsit_stop_nopin_timer(struct iscsit_conn *);
+extern void iscsit_login_timeout(struct timer_list *t);
+extern void iscsit_start_login_timer(struct iscsit_conn *);
+extern void iscsit_stop_login_timer(struct iscsit_conn *);
 extern int iscsit_send_tx_data(struct iscsit_cmd *, struct iscsit_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_tx_login_rsp(struct iscsit_conn *, u8, u8);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..c52022a4e93a 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -568,6 +568,7 @@ struct iscsit_conn {
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
 	struct timer_list	transport_timer;
+	struct timer_list	login_timer;
 	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
 	spinlock_t		cmd_lock;
-- 
2.31.1

