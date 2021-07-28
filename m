Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72558C4320A
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A9460EB2
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhG1Lyc (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:54:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43216 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbhG1Ly1 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 07:54:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D78F5222E8;
        Wed, 28 Jul 2021 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627473264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0ExwGoeFsmj+ZMp1uimKf9zFwxjH6beiJzv8UZ3/zk=;
        b=oobg2Bbu3aA+4JI24AtqjcixMtZcg2z2aZPKAmnrs+ruXweHHbZZ6vbarphHCNfUl8/1gk
        96fZGHdIGi2LVyto8JJlEeY32phbFaJniGA6R8022CTwC44blsl5N2F/oo2MtlKe4m9fdJ
        uL2CWD3jrH7lXD3hHRXPO905pIagJMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627473264;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0ExwGoeFsmj+ZMp1uimKf9zFwxjH6beiJzv8UZ3/zk=;
        b=FBt8hg1i5VBUmXzva8k+Nlbe5NhmjMM3UFdjjQbWQfQGYWe83tb2tj2zBsOu/M9yDar54b
        gZtFanl3wfWiJYAw==
Received: from echidna.suse.de (unknown [10.163.26.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id ADCF0A3B83;
        Wed, 28 Jul 2021 11:54:24 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        David Disseldorp <ddiss@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: target: avoid using lun_tg_pt_gp after unlock
Date:   Wed, 28 Jul 2021 13:53:52 +0200
Message-Id: <20210728115353.2396-2-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210728115353.2396-1-ddiss@suse.de>
References: <20210728115353.2396-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

core_alua_state_lba_dependent() currently uses lun->lun_tg_pt_gp without
holding the lun_tg_pt_gp_lock. The lock is taken in the caller, so
obtain the needed tg_pt_gp_id there instead.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 3bb921345bce..e0036e72b351 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -460,7 +460,7 @@ static inline void core_alua_state_nonoptimized(
 
 static inline int core_alua_state_lba_dependent(
 	struct se_cmd *cmd,
-	struct t10_alua_tg_pt_gp *tg_pt_gp)
+	u16 tg_pt_gp_id)
 {
 	struct se_device *dev = cmd->se_dev;
 	u64 segment_size, segment_mult, sectors, lba;
@@ -511,8 +511,7 @@ static inline int core_alua_state_lba_dependent(
 		}
 		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
 				    lba_map_mem_list) {
-			if (map_mem->lba_map_mem_alua_pg_id !=
-			    tg_pt_gp->tg_pt_gp_id)
+			if (map_mem->lba_map_mem_alua_pg_id != tg_pt_gp_id)
 				continue;
 			switch(map_mem->lba_map_mem_alua_state) {
 			case ALUA_ACCESS_STATE_STANDBY:
@@ -674,6 +673,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	struct se_lun *lun = cmd->se_lun;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int out_alua_state, nonop_delay_msecs;
+	u16 tg_pt_gp_id;
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
@@ -698,8 +698,8 @@ target_alua_state_check(struct se_cmd *cmd)
 	tg_pt_gp = lun->lun_tg_pt_gp;
 	out_alua_state = tg_pt_gp->tg_pt_gp_alua_access_state;
 	nonop_delay_msecs = tg_pt_gp->tg_pt_gp_nonop_delay_msecs;
+	tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
 
-	// XXX: keeps using tg_pt_gp witout reference after unlock
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	/*
 	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED in a separate conditional
@@ -727,7 +727,7 @@ target_alua_state_check(struct se_cmd *cmd)
 			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
-		if (core_alua_state_lba_dependent(cmd, tg_pt_gp))
+		if (core_alua_state_lba_dependent(cmd, tg_pt_gp_id))
 			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	/*
-- 
2.26.2

