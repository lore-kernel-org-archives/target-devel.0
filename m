Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508ADC77B76
	for <target-devel@archiver.kernel.org>; Mon, 17 Apr 2023 17:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDQRY7 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 17 Apr 2023 13:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjDQRY6 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 17 Apr 2023 13:24:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C8244B0
        for <target-devel@vger.kernel.org>; Mon, 17 Apr 2023 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681752255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMS0lwDDwar9BNmFQHTIgPvFvLABioPpvadQ3He4LdQ=;
        b=UoIj33HxEUP3tH4lj+1GtC4Bc3DLag0E8pCVO/xBTt/F/3unC0hvQCvSmlHiMYiQF9AeNA
        qgQBGOsfHLZbcmY9I4G/zvA8dJJ6ah4OvWXF5hSsE+yojHHUVKHaAMex5lg1xap54NZJ1h
        z7wn6uBkuLk0a0y8rxGGTqExCF832rE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-aAFFZTuuNMeAnmvN7Y0aDw-1; Mon, 17 Apr 2023 13:18:08 -0400
X-MC-Unique: aAFFZTuuNMeAnmvN7Y0aDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2C99899700;
        Mon, 17 Apr 2023 17:18:07 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9099C40C83AC;
        Mon, 17 Apr 2023 17:18:06 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V2 2/3] target: iscsi: remove unused transport_timer
Date:   Mon, 17 Apr 2023 19:18:00 +0200
Message-Id: <20230417171801.208122-3-mlombard@redhat.com>
In-Reply-To: <20230417171801.208122-1-mlombard@redhat.com>
References: <20230417171801.208122-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 include/target/iscsi/iscsi_target_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 082aaad8ef1b..b550056a38fd 100644
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

