Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB98C47082
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 12:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F2061263
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 12:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhEaMPM (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 31 May 2021 08:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231370AbhEaMPK (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 31 May 2021 08:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622463210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LNp7l26tSBH8MKGQN09IZkflKqKr6POQB9sLYTY53I0=;
        b=F0ZV3yaPKLu3Y6A9XOIwm2kJV3s0MyLNTPjWboGs/g3YgcuCbeR20/G+gizaYG7Tcv4/3P
        ySF8h6IvBgcN6Krki3eNqdesAOtq1/91CLSMpHz6cUw1ymuAnfFmIhxqd2artM28ZtFo4p
        6QS3LnlwFiuNCYFyoFpbx0v5OOKow40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-L9728ke6OtKOP41BsZyYrw-1; Mon, 31 May 2021 08:13:29 -0400
X-MC-Unique: L9728ke6OtKOP41BsZyYrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 831A0193578B;
        Mon, 31 May 2021 12:13:28 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5557360C0F;
        Mon, 31 May 2021 12:13:27 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     bvanassche@acm.org
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        martin.petersen@oracle.com
Subject: [PATCH] target: fix warning on realtime kernels
Date:   Mon, 31 May 2021 14:13:26 +0200
Message-Id: <20210531121326.3649-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On realtime kernels, spin_lock_irq*(spinlock_t) do not
disable the interrupts, a call to irqs_disabled()
will return false thus firing a warning in __transport_wait_for_tasks()

This patch removes the warning and also replaces assert_spin_locked
with lockdep_assert_held()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8fbfe75c5744..09526e6bc0bb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3121,9 +3121,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
-
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&cmd->t_state_lock);
 
 	if (fabric_stop)
 		cmd->transport_state |= CMD_T_FABRIC_STOP;
-- 
2.31.1

