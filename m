Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07647C7EE24
	for <target-devel@archiver.kernel.org>; Mon,  8 May 2023 16:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjEHQXS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 8 May 2023 12:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbjEHQXQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 8 May 2023 12:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47872738
        for <target-devel@vger.kernel.org>; Mon,  8 May 2023 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683562947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0gtUYYLVMZ2HpxtyNeBsgNL67Kf1p7OgJH/5VF8hTFg=;
        b=g5ZLwbpU8XPcBsDr1FynC3LB0jJov3M2sZsdRo8YEZiwhZoxaeWYsGxiVI/R91c3w/Sy3P
        r0RT/zjeFZUN5wJ/gB7QT8P+IbE1ohJBzJ6idsVaTDjPWTSeuFaAMwuzSnTksmGsGkxZIT
        DHVfnl0Bnct0PjwMkPnXLSAD5B3fwWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-uVhoElYlP12xrDU-0nsCiQ-1; Mon, 08 May 2023 12:22:25 -0400
X-MC-Unique: uVhoElYlP12xrDU-0nsCiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9712687082A;
        Mon,  8 May 2023 16:22:25 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69ACD2026D16;
        Mon,  8 May 2023 16:22:24 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V3 2/3] target: iscsi: remove unused transport_timer
Date:   Mon,  8 May 2023 18:22:18 +0200
Message-Id: <20230508162219.1731964-3-mlombard@redhat.com>
In-Reply-To: <20230508162219.1731964-1-mlombard@redhat.com>
References: <20230508162219.1731964-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 include/target/iscsi/iscsi_target_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 42f4a4c0c100..4c15420e8965 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -568,7 +568,6 @@ struct iscsit_conn {
 	struct iscsi_login	*login;
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
-	struct timer_list	transport_timer;
 	struct timer_list	login_timer;
 	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
-- 
2.31.1

