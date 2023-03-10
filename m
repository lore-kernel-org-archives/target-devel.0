Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07733C6FD19
	for <target-devel@archiver.kernel.org>; Fri, 10 Mar 2023 10:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCJKF3 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCJKFU (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 05:05:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68AA108680
        for <target-devel@vger.kernel.org>; Fri, 10 Mar 2023 02:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678442674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khaCB77DSLIw4MIecLM6Rb74bfzmWuu5hEc3yWBAfc4=;
        b=PND2sCScs4wHwhSATaJeAFeoazE7rYKLkHd0tuOT7EMTDNeUZfq0Lf8Sy6W4KriCDe4VXT
        dT3vEoFC0eFb7nLxLcU1fO+CEYb/TpKvqTijQwQ/lE3JkMGQ6XNu6a8lu8OJKYskEGWaG0
        1UXcgpAsPpWvnIP/Sj+j0fDJqeA66z4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-fdiItagwOCe_lpu0pQH2SQ-1; Fri, 10 Mar 2023 05:04:31 -0500
X-MC-Unique: fdiItagwOCe_lpu0pQH2SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 734391C0897B;
        Fri, 10 Mar 2023 10:04:31 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F1E9C15BA0;
        Fri, 10 Mar 2023 10:04:29 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Subject: [PATCH 3/3] target: iscsi: prevent login threads from racing between each other
Date:   Fri, 10 Mar 2023 11:04:23 +0100
Message-Id: <20230310100423.1258256-4-mlombard@redhat.com>
In-Reply-To: <20230310100423.1258256-1-mlombard@redhat.com>
References: <20230310100423.1258256-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index f901a7231c48..8461cb27b3b3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1120,6 +1120,7 @@ int iscsi_target_locate_portal(
 	iscsi_target_set_sock_callbacks(conn);
 
 	login->np = np;
+	conn->tpg = NULL;
 
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
@@ -1187,7 +1188,6 @@ int iscsi_target_locate_portal(
 	 */
 	sessiontype = strncmp(s_buf, DISCOVERY, 9);
 	if (!sessiontype) {
-		conn->tpg = iscsit_global->discovery_tpg;
 		if (!login->leading_connection)
 			goto get_target;
 
@@ -1204,9 +1204,11 @@ int iscsi_target_locate_portal(
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

