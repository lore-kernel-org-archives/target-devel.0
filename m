Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A625FC4332F
	for <target-devel@archiver.kernel.org>; Fri, 11 Nov 2022 15:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiKKPpw (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiKKPpv (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 10:45:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518D8DE93
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 07:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668181494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MRk0335o56bHnqrxPpY5i4Mdn1amVYs9mQ0y2QBMw8U=;
        b=izLNf3xiYRn6bMeYsImZ9qMQaTmWDagDNmzsOHQxj7tCL3oKPJ3G+b66zLBy8DWGflGoFx
        enVpLoVP5ynJBkwR1zm+NwKXDhKcg95oGa5Ynvd3BchgutVUjx9MTziyUUHtT/Th4QrFJS
        FUgAb9dYwNHS04ihaR9lfyny6eapbc8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-9K5Qu2DvOxiWCnfUz_HBpQ-1; Fri, 11 Nov 2022 10:44:50 -0500
X-MC-Unique: 9K5Qu2DvOxiWCnfUz_HBpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CD15802528;
        Fri, 11 Nov 2022 15:44:50 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-192-41.brq.redhat.com [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D88940C958D;
        Fri, 11 Nov 2022 15:44:48 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Subject: [PATCH V2] target: fix a race condition between login_work and the login thread
Date:   Fri, 11 Nov 2022 16:44:48 +0100
Message-Id: <20221111154448.629862-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Also fix other potential race conditions in the error paths.

V2: remove an unnecessary call to cancel_delayed_work();
    fix a potential race condition in iscsi_start_negotiation() and
    in iscsi_target_do_login_rx()'s error paths

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..465c53b9ddb3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -645,7 +645,6 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
 	} else if (rc == 1) {
-		cancel_delayed_work(&conn->login_work);
 		iscsi_target_nego_release(conn);
 		iscsi_post_login_handler(np, conn, zero_tsih);
 		iscsit_deaccess_np(np, tpg, tpg_np);
@@ -654,7 +653,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 
 err:
 	iscsi_target_restore_sock_callbacks(conn);
-	cancel_delayed_work(&conn->login_work);
+	cancel_delayed_work_sync(&conn->login_work);
 	iscsi_target_login_drop(conn, login);
 	iscsit_deaccess_np(np, tpg, tpg_np);
 }
@@ -1058,6 +1057,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 				login->tsih = conn->sess->tsih;
 				login->login_complete = 1;
 				iscsi_target_restore_sock_callbacks(conn);
+				cancel_delayed_work_sync(&conn->login_work);
 				if (iscsi_target_do_tx_login_io(conn,
 						login) < 0)
 					return -1;
@@ -1363,8 +1363,8 @@ int iscsi_target_start_negotiation(
 		ret = -1;
 
 	if (ret < 0) {
-		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_restore_sock_callbacks(conn);
+		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_remove_failed_auth_entry(conn);
 	}
 	if (ret != 0)
-- 
2.31.1

