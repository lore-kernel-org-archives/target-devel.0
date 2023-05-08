Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771AEC77B7F
	for <target-devel@archiver.kernel.org>; Mon,  8 May 2023 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjEHQXR (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 8 May 2023 12:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjEHQXP (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 8 May 2023 12:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0483593
        for <target-devel@vger.kernel.org>; Mon,  8 May 2023 09:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683562949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhidUOW4bA7y2e2ETgcoqxr4iJ8kArDkcOif0PbdN+A=;
        b=Qcm5HBGw/BxwykKJlmNmDka4bb/HKRROsmKF1WK2NWVJ42mo65td42ByfzFUbNpuwwyNNQ
        cOosP+RkKQ2XqF+C0n5moCCInIwqIjFDHzbRI1Mng01FHWsTRBBp5nDk3EhqH9BqsoWzrp
        +oh5Hlgw8rVMGLAq8VAdU4Zebxj6y6E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-GcrJSZ59Nfa-msN5CI94sg-1; Mon, 08 May 2023 12:22:27 -0400
X-MC-Unique: GcrJSZ59Nfa-msN5CI94sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4775B870828;
        Mon,  8 May 2023 16:22:27 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 130382026D16;
        Mon,  8 May 2023 16:22:25 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V3 3/3] target: iscsi: prevent login threads from racing between each other
Date:   Mon,  8 May 2023 18:22:19 +0200
Message-Id: <20230508162219.1731964-4-mlombard@redhat.com>
In-Reply-To: <20230508162219.1731964-1-mlombard@redhat.com>
References: <20230508162219.1731964-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

The tpg->np_login_sem is a semaphore that is used to serialize the login
process when multiple login threads run concurrently against the same
target portal group.

The iscsi_target_locate_portal() function finds the tpg,
calls iscsit_access_np() against the np_login_sem semaphore
and saves the tpg pointer in conn->tpg;

If iscsi_target_locate_portal() fails, the caller will check for the
conn->tpg pointer and, if it's not NULL, then it will assume
that iscsi_target_locate_portal() called iscsit_access_np() on the
semaphore.

Make sure that conn->tpg gets initialized only if iscsit_access_np()
was successful, otherwise iscsit_deaccess_np() may end up
being called against a semaphore we never took, allowing more than one
thread to access the same tpg.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index e3a5644a70b3..fa3fb5f4e6bc 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1122,6 +1122,7 @@ int iscsi_target_locate_portal(
 	iscsi_target_set_sock_callbacks(conn);
 
 	login->np = np;
+	conn->tpg = NULL;
 
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
@@ -1189,7 +1190,6 @@ int iscsi_target_locate_portal(
 	 */
 	sessiontype = strncmp(s_buf, DISCOVERY, 9);
 	if (!sessiontype) {
-		conn->tpg = iscsit_global->discovery_tpg;
 		if (!login->leading_connection)
 			goto get_target;
 
@@ -1206,9 +1206,11 @@ int iscsi_target_locate_portal(
 		 * Serialize access across the discovery struct iscsi_portal_group to
 		 * process login attempt.
 		 */
+		conn->tpg = iscsit_global->discovery_tpg;
 		if (iscsit_access_np(np, conn->tpg) < 0) {
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_SVC_UNAVAILABLE);
+			conn->tpg = NULL;
 			ret = -1;
 			goto out;
 		}
-- 
2.31.1

