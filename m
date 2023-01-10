Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3F6C54EBC
	for <target-devel@archiver.kernel.org>; Tue, 10 Jan 2023 12:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbjAJMyO (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 07:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238523AbjAJMyO (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 07:54:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6B8CE16
        for <target-devel@vger.kernel.org>; Tue, 10 Jan 2023 04:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673355204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KD5Za3EolY6HIhOj7CthxebotfqryV/69QjYC+wwjEg=;
        b=PfZfS4xJqKW1TLrL2xrCDr6lI9xrl1Bsy1dCvhMBi/5phgsr4xEmugixV0FlTW770M7TVm
        KZEGOgeyzfl3H4wJBQkDV6E9jii4HwRynZNYegl49fFuOnIbB3Ddj2gKa8Q/iwkR/60jJV
        yD6s/+AWKPGofWGvDFPRV5MRhd7SVsE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-FLp7xugPOjyd_ujww07btw-1; Tue, 10 Jan 2023 07:53:22 -0500
X-MC-Unique: FLp7xugPOjyd_ujww07btw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B501188120A;
        Tue, 10 Jan 2023 12:53:16 +0000 (UTC)
Received: from kalibr.redhat.com (ovpn-194-213.brq.redhat.com [10.40.194.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22F4A492B30;
        Tue, 10 Jan 2023 12:53:11 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, michael.christie@oracle.com,
        d.bogdanov@yadro.com
Subject: [PATCH] target: core: fix warning on RT kernels
Date:   Tue, 10 Jan 2023 13:53:10 +0100
Message-Id: <20230110125310.55884-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

calling spin_lock_irqsave() does not disable the interrupts
on realtime kernels, remove the warning and replace assert_spin_locked()
with lockdep_assert_held()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_tmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..2b95b4550a63 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -73,8 +73,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
-- 
2.31.1

