Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734F1C6FD19
	for <target-devel@archiver.kernel.org>; Fri, 10 Mar 2023 10:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCJKFX (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjCJKFQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 05:05:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A2E107D5D
        for <target-devel@vger.kernel.org>; Fri, 10 Mar 2023 02:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678442670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4vxG4VPi8LjJcDtLr4vkiU8LYgX7WzLLvWRjyY1Ea4=;
        b=iI+n5oahd9aeMcO31+nHVpQtfoG+C8U91TN3ZwCpUlKO+lYVYnhtxwrW0Fk4Jh+MVGkIaB
        QcpiH4pXm0/42w8iuJ6L175ssDt3XE0zwie6xtpwZeqTQQH9B4ZEQmvKqr8+vAW/vPSrn6
        lduX1C5sWQl6xe+hiKwFm4Nl0OL1fI4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-E57rgZsGOZO8p-aHZHWjyQ-1; Fri, 10 Mar 2023 05:04:29 -0500
X-MC-Unique: E57rgZsGOZO8p-aHZHWjyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93A173C0E463;
        Fri, 10 Mar 2023 10:04:29 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9ACC15BAD;
        Fri, 10 Mar 2023 10:04:27 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Subject: [PATCH 2/3] target: iscsi: remove unused transport_timer
Date:   Fri, 10 Mar 2023 11:04:22 +0100
Message-Id: <20230310100423.1258256-3-mlombard@redhat.com>
In-Reply-To: <20230310100423.1258256-1-mlombard@redhat.com>
References: <20230310100423.1258256-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 include/target/iscsi/iscsi_target_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index c52022a4e93a..491a6abf0efa 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -567,7 +567,6 @@ struct iscsit_conn {
 	struct iscsi_login	*login;
 	struct timer_list	nopin_timer;
 	struct timer_list	nopin_response_timer;
-	struct timer_list	transport_timer;
 	struct timer_list	login_timer;
 	struct task_struct	*login_kworker;
 	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
-- 
2.31.1

