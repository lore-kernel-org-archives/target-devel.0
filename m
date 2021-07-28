Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3EBC4320E
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AD560EB2
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhG1Lye (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:54:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33378 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbhG1Ly3 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 07:54:29 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 18FED1FF89;
        Wed, 28 Jul 2021 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627473265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPMToXdun4KxhYuJCEanYz1AvANrmTOly8i7j10xNH0=;
        b=AfsHk3zm40aC6dkoJAowGcaf17VaAQxoGBo6y5Cvd2yBkzKOmsFIxJKn0qjP6Ts11uvWoU
        QjDUVQxiOQTxGHduqfDdass3mDgkS3o17CWo0Jm0n6iyew07RKBh1Ml/5V91Vf5jy8tjzs
        N2ao41+czYBz0ncMjRbJLfPHe4GGULc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627473265;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPMToXdun4KxhYuJCEanYz1AvANrmTOly8i7j10xNH0=;
        b=ptVHD9LfbaNj1juaTVHS/tS9h49XBRLEN41rhzY4u703zkYgkZ4FiHJZpt91vj/xxDh2kv
        r4IHUKOTvJUmr8AQ==
Received: from echidna.suse.de (unknown [10.163.26.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DE031A3B85;
        Wed, 28 Jul 2021 11:54:24 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        David Disseldorp <ddiss@suse.de>, Chris Boot <bootc@bootc.net>
Subject: [PATCH 2/3] scsi: target: sbp: drop incorrect asc/ascq usage
Date:   Wed, 28 Jul 2021 13:53:53 +0200
Message-Id: <20210728115353.2396-3-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de>
References: <20210728115353.2396-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

The se_cmd scsi_asc and scsi_ascq members are only used for tracking
ALUA SCSI sense detail between target_core_alua and
translate_sense_reason(), so they're effectively always zero here.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Cc: Chris Boot <bootc@bootc.net>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 4d3ceee23622..b9f9fb5d7e63 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1389,8 +1389,8 @@ static void sbp_sense_mangle(struct sbp_target_request *req)
 		(sense[0] & 0x80) |		/* valid */
 		((sense[2] & 0xe0) >> 1) |	/* mark, eom, ili */
 		(sense[2] & 0x0f);		/* sense_key */
-	status[2] = se_cmd->scsi_asc;		/* sense_code */
-	status[3] = se_cmd->scsi_ascq;		/* sense_qualifier */
+	status[2] = 0;				/* XXX sense_code */
+	status[3] = 0;				/* XXX sense_qualifier */
 
 	/* information */
 	status[4] = sense[3];
-- 
2.26.2

