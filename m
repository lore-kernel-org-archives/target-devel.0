Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEC8C433FE
	for <target-devel@archiver.kernel.org>; Fri,  4 Nov 2022 09:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKDJvz (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 4 Nov 2022 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKDJvk (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 4 Nov 2022 05:51:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9D112A
        for <target-devel@vger.kernel.org>; Fri,  4 Nov 2022 02:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667555445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lj1whPyjzC+BTBFhYGIaFkqtskcNmMJe5+mcfIXoPgQ=;
        b=UHpXFNp2DuB39Z8dnTWWSQYFmH2XLVscTdcbhigFZo/6Wep/U/Ym1pU/7hwOZNTfX0MNez
        iiEHPQHdE+qMK+Dmw/fkgO9LjvVSaSMHuTveKYQTY+LppyetgOwrVBcjd3mW50XaZWhnAH
        wuPND+nokCBj2nRCEiwLjGKrILw4pCM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-dR8ao2kmP3qcIewqSIbZIQ-1; Fri, 04 Nov 2022 05:50:44 -0400
X-MC-Unique: dR8ao2kmP3qcIewqSIbZIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E571C06915;
        Fri,  4 Nov 2022 09:50:43 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-192-211.brq.redhat.com [10.40.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A85E940C955A;
        Fri,  4 Nov 2022 09:50:42 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Subject: [PATCH] target: fix a race condition between login_work and the login thread
Date:   Fri,  4 Nov 2022 10:50:41 +0100
Message-Id: <20221104095041.289643-1-mlombard@redhat.com>
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

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..e58bdffe2931 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1058,6 +1058,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 				login->tsih = conn->sess->tsih;
 				login->login_complete = 1;
 				iscsi_target_restore_sock_callbacks(conn);
+				cancel_delayed_work_sync(&conn->login_work);
 				if (iscsi_target_do_tx_login_io(conn,
 						login) < 0)
 					return -1;
-- 
2.31.1

