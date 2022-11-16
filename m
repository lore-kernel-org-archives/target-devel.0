Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FC5C433FE
	for <target-devel@archiver.kernel.org>; Wed, 16 Nov 2022 09:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiKPJqj (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 04:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiKPJqg (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 04:46:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E45E0A3
        for <target-devel@vger.kernel.org>; Wed, 16 Nov 2022 01:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668591942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4EAqsQwxyeW5W1Mia2wWmnvRUmqjVlYjuvgN/Efzygc=;
        b=dvDniH5cFSHBJ1DvzitWKVT4gcgxvI624GSS2RkqqFb81Wb01Mjc9vQWoHyaTQ3txytXvR
        RWvJDoqNP0S4jP48ZSP8qbZ3SxSfZ6JkpSSIN3FsbP1HIx9RojyuUhVtQRdbCT4+IiaQXT
        DIiF+rnHhd1C3FbfBdXqMkN50yuXCJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-S63VYrPBOAOxkQqM0-0EfA-1; Wed, 16 Nov 2022 04:45:37 -0500
X-MC-Unique: S63VYrPBOAOxkQqM0-0EfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9E5B185A7AC;
        Wed, 16 Nov 2022 09:45:36 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-193-253.brq.redhat.com [10.40.193.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04AA040C6EC3;
        Wed, 16 Nov 2022 09:45:35 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     sagi@grimberg.me
Cc:     jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH] infiniband: use the ISCSI_LOGIN_CURRENT_STAGE macro
Date:   Wed, 16 Nov 2022 10:45:35 +0100
Message-Id: <20221116094535.138298-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Use the proper macro to get the current_stage value.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b360a1527cd1..75404885cf98 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -993,9 +993,8 @@ isert_rx_login_req(struct isert_conn *isert_conn)
 		 * login request PDU.
 		 */
 		login->leading_connection = (!login_req->tsih) ? 1 : 0;
-		login->current_stage =
-			(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK)
-			 >> 2;
+		login->current_stage = ISCSI_LOGIN_CURRENT_STAGE(
+				login_req->flags);
 		login->version_min	= login_req->min_version;
 		login->version_max	= login_req->max_version;
 		memcpy(login->isid, login_req->isid, 6);
-- 
2.31.1

