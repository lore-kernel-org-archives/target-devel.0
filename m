Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E2EC4332F
	for <target-devel@archiver.kernel.org>; Tue, 15 Nov 2022 12:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbiKOMx6 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 07:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbiKOMxp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 07:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF538140A1
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668516766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=70yo6sTxRChRpvt/imDjBqssgfRQ+Wwt9Um+UwrxRRs=;
        b=Qf2ygS63tnLbGOHcFmqADbnmo/sVvorrPo8DJNKN/bZabThZRU7gkzhZAavG2P1XqGkUKf
        4+pppM2LrnIXu/hVFDugJyiNYVZAqxsPjFCWIbiQYxw4ryF5/Yu6QZ47mtlMebhQ+lvake
        bQwJTgKiXn2zyAA1lFouZiN6yqtwQic=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-nxlyb4MePT-dR3CAOKyhfQ-1; Tue, 15 Nov 2022 07:52:44 -0500
X-MC-Unique: nxlyb4MePT-dR3CAOKyhfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95292858F17;
        Tue, 15 Nov 2022 12:52:44 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-193-253.brq.redhat.com [10.40.193.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8C251731B;
        Tue, 15 Nov 2022 12:52:43 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V3] target: fix a race condition between login_work and the login thread
Date:   Tue, 15 Nov 2022 13:52:42 +0100
Message-Id: <20221115125242.102344-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

In case a malicious initiator sends some random data immediately after a
login PDU; the iscsi_target_sk_data_ready() callback will
schedule the login_work and, at the same time,
the negotiation may end without clearing the LOGIN_FLAGS_INITIAL_PDU flag
(because no additional PDU exchanges are required to complete the login).

The login has been completed but the login_work function
will find the LOGIN_FLAGS_INITIAL_PDU flag set and will
never stop from rescheduling itself;
at this point, if the initiator drops the connection, the iscsit_conn
structure will be freed, login_work will dereference a released
socket structure and the kernel crashes.

BUG: kernel NULL pointer dereference, address: 0000000000000230
PF: supervisor write access in kernel mode
PF: error_code(0x0002) - not-present page
Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
RIP: 0010:_raw_read_lock_bh+0x15/0x30
Call trace:
 iscsi_target_do_login_rx+0x75/0x3f0 [iscsi_target_mod]
 process_one_work+0x1e8/0x3c0

Fix this bug by forcing login_work to stop after the login has been
completed and the socket callbacks have been restored.

Add a comment to clearify the return values of iscsi_target_do_login()

v3: cancel_delayed_work_sync() should be called by
    iscsi_target_start_negotiation(), because the latter is only executed
    in login_thread context

V2: remove an unnecessary call to cancel_delayed_work();
    fix a potential race condition in iscsi_start_negotiation() and
    in iscsi_target_do_login_rx()'s error paths

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..fab92a460623 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1018,6 +1018,13 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 }
 
+/**
+ * RETURN VALUE:
+ *
+ *  1 = Login successful
+ * -1 = Login failed
+ *  0 = More PDU exchanges required
+ */
 static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *login)
 {
 	int pdu_count = 0;
@@ -1363,12 +1370,13 @@ int iscsi_target_start_negotiation(
 		ret = -1;
 
 	if (ret < 0) {
-		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_restore_sock_callbacks(conn);
 		iscsi_remove_failed_auth_entry(conn);
 	}
-	if (ret != 0)
+	if (ret != 0) {
+		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_nego_release(conn);
+	}
 
 	return ret;
 }
-- 
2.31.1

