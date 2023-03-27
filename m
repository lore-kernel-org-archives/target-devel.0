Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BB9C7619A
	for <target-devel@archiver.kernel.org>; Mon, 27 Mar 2023 10:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjC0Kqc (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 27 Mar 2023 06:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjC0Kqb (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 27 Mar 2023 06:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB3730E6
        for <target-devel@vger.kernel.org>; Mon, 27 Mar 2023 03:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679913939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0HareB3g+a7+5sdQuI3iZGhUXGcGabHRtELJZ6DX2A0=;
        b=IVCjhVIL1dRUx1Kqhw6l+9C2d29n2YygmDES3a9YxjsfZUkPPmxVvhvCW30NjeOOmrRZ71
        PRCA/WtOuXpj6E+qgvN7YKa7OVaV1lIwrFEfdQHQiymRn9SxbH5PH379YQs3cppEFT6Pru
        P1Akfj+mSsPAAjVrNrOTkbTafnGQWeU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-NIsmKM1lMe-j7Ga2o8oCdw-1; Mon, 27 Mar 2023 06:45:38 -0400
X-MC-Unique: NIsmKM1lMe-j7Ga2o8oCdw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D77CB3801F53;
        Mon, 27 Mar 2023 10:45:37 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5155492C3E;
        Mon, 27 Mar 2023 10:45:36 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V2] target: iscsi: use GFP_NOIO with loopback connections
Date:   Mon, 27 Mar 2023 12:45:35 +0200
Message-Id: <20230327104535.20984-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

When an iscsi initiator is connected to a target running on the
same machine, the system may trigger a deadlock when working
under memory pressure.
This may happen, for example, when the iscsi rx thread tries to
allocate memory and a memory reclaim is performed, the rx thread may
therefore end up waiting for the initiator to complete I/O operations,
causing a deadlock.

Fix the issue by using memalloc_noio_*() to enable implicit GFP_NOIO
in the vulnerable code paths, when the connection is in loopback.


v2: Check the IFF_LOOPBACK flag in the iscsit_accept_np() callback,
    where the conn->sock pointer is initialized.

Suggested-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       | 19 ++++++++++++++++---
 drivers/target/iscsi/iscsi_target_login.c |  7 +++++++
 include/target/iscsi/iscsi_target_core.h  |  1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..4d997a049bf7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3918,9 +3918,9 @@ static int iscsit_handle_response_queue(struct iscsit_conn *conn)
 
 int iscsi_target_tx_thread(void *arg)
 {
-	int ret = 0;
+	int ret = 0, flags;
 	struct iscsit_conn *conn = arg;
-	bool conn_freed = false;
+	bool conn_freed = false, loopback;
 
 	/*
 	 * Allow ourselves to be interrupted by SIGINT so that a
@@ -3928,6 +3928,10 @@ int iscsi_target_tx_thread(void *arg)
 	 */
 	allow_signal(SIGINT);
 
+	loopback = conn->loopback;
+	if (loopback)
+		flags = memalloc_noio_save();
+
 	while (!kthread_should_stop()) {
 		/*
 		 * Ensure that both TX and RX per connection kthreads
@@ -3966,6 +3970,9 @@ int iscsi_target_tx_thread(void *arg)
 	if (conn->conn_state != TARG_CONN_STATE_IN_LOGIN)
 		iscsit_take_action_for_connection_exit(conn, &conn_freed);
 out:
+	if (loopback)
+		memalloc_noio_restore(flags);
+
 	if (!conn_freed) {
 		while (!kthread_should_stop()) {
 			msleep(100);
@@ -4166,7 +4173,7 @@ static void iscsit_get_rx_pdu(struct iscsit_conn *conn)
 
 int iscsi_target_rx_thread(void *arg)
 {
-	int rc;
+	int rc, flags;
 	struct iscsit_conn *conn = arg;
 	bool conn_freed = false;
 
@@ -4186,8 +4193,14 @@ int iscsi_target_rx_thread(void *arg)
 	if (!conn->conn_transport->iscsit_get_rx_pdu)
 		return 0;
 
+	if (conn->loopback)
+		flags = memalloc_noio_save();
+
 	conn->conn_transport->iscsit_get_rx_pdu(conn);
 
+	if (conn->loopback)
+		memalloc_noio_restore(flags);
+
 	if (!signal_pending(current))
 		atomic_set(&conn->transport_failed, 1);
 	iscsit_take_action_for_connection_exit(conn, &conn_freed);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..4a195e9e623e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -17,6 +17,7 @@
 #include <linux/tcp.h>        /* TCP_NODELAY */
 #include <net/ip.h>
 #include <net/ipv6.h>         /* ipv6_addr_v4mapped() */
+#include <net/sock.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
@@ -960,6 +961,7 @@ int iscsi_target_setup_login_socket(
 int iscsit_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 {
 	struct socket *new_sock, *sock = np->np_socket;
+	struct dst_entry *dst;
 	struct sockaddr_in sock_in;
 	struct sockaddr_in6 sock_in6;
 	int rc;
@@ -971,6 +973,11 @@ int iscsit_accept_np(struct iscsi_np *np, struct iscsit_conn *conn)
 	conn->sock = new_sock;
 	conn->login_family = np->np_sockaddr.ss_family;
 
+	dst = sk_dst_get(conn->sock->sk);
+	if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
+		conn->loopback = true;
+	dst_release(dst);
+
 	if (np->np_sockaddr.ss_family == AF_INET6) {
 		memset(&sock_in6, 0, sizeof(struct sockaddr_in6));
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..aa8d4026e32e 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -538,6 +538,7 @@ struct iscsit_conn {
 	struct sockaddr_storage local_sockaddr;
 	int			conn_usage_count;
 	int			conn_waiting_on_uc;
+	bool			loopback;
 	atomic_t		check_immediate_queue;
 	atomic_t		conn_logout_remove;
 	atomic_t		connection_exit;
-- 
2.31.1

