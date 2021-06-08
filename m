Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27103C47082
	for <target-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE6861278
	for <target-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhFHQmq (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231792AbhFHQmq (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 12:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623170452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ige1Ayr8pQcLg719XmjiJ/igjdEUJBxlfkO/QScD/iA=;
        b=Lk67LTdWES/xhbpu+YzQvnARnxxzIR7fTSrYV3o+WrRsWAqY8zaJinYXDHO5R857KJMf9O
        mKCupn0hr79myHDANq4/azEGH/b0gDNnCKNYkskztWrE88BZYqu5b2Vd8p/xYydlgyuc5D
        9pYgj6KUBnlrA0owMDKbCgBReOlKUC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-miYeT-ThMkyQsenQKT3JIA-1; Tue, 08 Jun 2021 12:40:51 -0400
X-MC-Unique: miYeT-ThMkyQsenQKT3JIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2FE7180FD62;
        Tue,  8 Jun 2021 16:40:49 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.40.193.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6A7F620DE;
        Tue,  8 Jun 2021 16:40:48 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org
Subject: [PATCH] target: remove the auth_type field from iscsi_session
Date:   Tue,  8 Jun 2021 18:40:47 +0200
Message-Id: <20210608164047.128763-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

This field is not used anymore so we can remove it.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 5 -----
 include/target/iscsi/iscsi_target_core.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 151e2949bb75..36341ffaffbf 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -144,11 +144,6 @@ static u32 iscsi_handle_authentication(
 		auth = &iscsit_global->discovery_acl.node_auth;
 	}
 
-	if (strstr("CHAP", authtype))
-		strcpy(conn->sess->auth_type, "CHAP");
-	else
-		strcpy(conn->sess->auth_type, NONE);
-
 	if (strstr("None", authtype))
 		return 1;
 	else if (strstr("CHAP", authtype))
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 1eccb2ac7d02..f0495515ca6a 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -647,7 +647,6 @@ struct iscsi_session {
 
 	/* LIO specific session ID */
 	u32			sid;
-	char			auth_type[8];
 	/* unique within the target */
 	int			session_index;
 	/* Used for session reference counting */
-- 
Maurizio Lombardi

