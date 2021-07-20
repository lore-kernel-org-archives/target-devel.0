Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DE9C07E9B
	for <target-devel@archiver.kernel.org>; Tue, 20 Jul 2021 22:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791D46101E
	for <target-devel@archiver.kernel.org>; Tue, 20 Jul 2021 22:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhGTWPb (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:15:31 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34574 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhGTWPM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 18:15:12 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8453622409;
        Tue, 20 Jul 2021 22:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626821743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Op7JjIAkK8Rsrk3km2UAjmknDX7E47rGGxHkQtUmgjs=;
        b=rED9LJ7Eh0WITPKbXaVgGpjRURZ3p6y1BgQbIO62xxZBISxpUwzqGAJ92Iva1xn1AqX8t6
        ngafCq90qa8cl+op9nWhQ24gN8+rSlOWJqFam9w/B7pB15KMSsF8tA3k3z2NK7A/dn2ocL
        BAQfDr7xlItOB2tIFhY+40ECgk7y0nQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626821743;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Op7JjIAkK8Rsrk3km2UAjmknDX7E47rGGxHkQtUmgjs=;
        b=4WvKgiovwU0U6vBd/wRpDeBLLUe9ftOEbL+ZCVT72w1Bc+zaNh9VyOZXW8yVcDbILLt+u/
        y8k4oOkjl93aE0CA==
Received: from echidna.suse.de (unknown [10.163.26.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 58BDBA3B81;
        Tue, 20 Jul 2021 22:55:43 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, David Disseldorp <ddiss@suse.de>,
        Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: target: fix NULL dereference on XCOPY completion
Date:   Wed, 21 Jul 2021 00:55:22 +0200
Message-Id: <20210720225522.26291-1-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

CPU affinity control added with 39ae3edda325 makes target_complete_cmd()
queue work on a CPU based on se_tpg->se_tpg_wwn->cmd_compl_affinity
state.

LIO's EXTENDED COPY worker is a special case in that read/write cmds
are dispatched using the global xcopy_pt_tpg, which carries a NULL
se_tpg_wwn pointer following initialization in target_xcopy_setup_pt().

The NULL xcopy_pt_tpg->se_tpg_wwn pointer is dereferenced on completion
of any EXTENDED COPY initiated read/write cmds. E.g using the libiscsi
SCSI.ExtendedCopy.Simple test:
  BUG: kernel NULL pointer dereference, address: 00000000000001a8
  RIP: 0010:target_complete_cmd+0x9d/0x130 [target_core_mod]
  Call Trace:
   fd_execute_rw+0x148/0x42a [target_core_file]
   ? __dynamic_pr_debug+0xa7/0xe0
   ? target_check_reservation+0x5b/0x940 [target_core_mod]
   __target_execute_cmd+0x1e/0x90 [target_core_mod]
   transport_generic_new_cmd+0x17c/0x330 [target_core_mod]
   target_xcopy_issue_pt_cmd+0x9/0x60 [target_core_mod]
   target_xcopy_read_source.isra.7+0x10b/0x1b0 [target_core_mod]
   ? target_check_fua+0x40/0x40 [target_core_mod]
   ? transport_complete_task_attr+0x130/0x130 [target_core_mod]
   target_xcopy_do_work+0x61f/0xc00 [target_core_mod]

This fix makes target_complete_cmd() queue work on se_cmd->cpuid if
se_tpg_wwn is NULL.

Fixes: 39ae3edda325 ("scsi: target: core: Make completion affinity configurable")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7e35eddd9eb7..26ceabe34de5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -886,7 +886,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
 
-	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+	if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
 		cpu = cmd->cpuid;
 	else
 		cpu = wwn->cmd_compl_affinity;
-- 
2.26.2

