Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8D7C433FE
	for <target-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbiKWN4i (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiKWN4O (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 08:56:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBABC72108
        for <target-devel@vger.kernel.org>; Wed, 23 Nov 2022 05:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669211375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=La/v9+oJaVNdAZXbAjqruy0SPqsCrDyJEfv4waHlR9g=;
        b=UVbtowZD/904AbkH8qA2cHehfMhWDonVbyzO0xsJ0QpHKj2eGq4XONGJFDMnSI4cmTK0Wx
        JDr20RIcbNyeuifja/+hbysSIbXEX0qqHbjyZE4rc22Ouu5NNhmJ44jB4j+QxAparg+fVS
        HFB1vPf9qqP4lR/GcMh/BycB58tU6UE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-QS9C8ltTML-cjhujIm8N1A-1; Wed, 23 Nov 2022 08:49:34 -0500
X-MC-Unique: QS9C8ltTML-cjhujIm8N1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7688E800B23;
        Wed, 23 Nov 2022 13:49:34 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-193-4.brq.redhat.com [10.40.193.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE912C2C8C5;
        Wed, 23 Nov 2022 13:49:33 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH] target: iscsi: remove redundant assignment
Date:   Wed, 23 Nov 2022 14:49:32 +0100
Message-Id: <20221123134932.428695-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

login_req has been already initialized at the beginning of the
cxgbit_rx_login_pdu() and iscsit_get_login_rx() functions.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 1 -
 drivers/target/iscsi/iscsi_target_login.c   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index acfc39683c87..d67a5be25e7c 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1338,7 +1338,6 @@ static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
 	 * login request PDU.
 	 */
 	if (login->first_request) {
-		login_req = (struct iscsi_login_req *)login->req;
 		login->leading_connection = (!login_req->tsih) ? 1 : 0;
 		login->current_stage	= ISCSI_LOGIN_CURRENT_STAGE(
 				login_req->flags);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..d9d2c48aad81 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1039,7 +1039,6 @@ int iscsit_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
 	 * login request PDU.
 	 */
 	if (login->first_request) {
-		login_req = (struct iscsi_login_req *)login->req;
 		login->leading_connection = (!login_req->tsih) ? 1 : 0;
 		login->current_stage	= ISCSI_LOGIN_CURRENT_STAGE(login_req->flags);
 		login->version_min	= login_req->min_version;
-- 
2.31.1

