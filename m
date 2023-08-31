Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15E5C83F2F
	for <target-devel@archiver.kernel.org>; Thu, 31 Aug 2023 18:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbjHaSfO (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 14:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbjHaSfM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 14:35:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B46E5F
        for <target-devel@vger.kernel.org>; Thu, 31 Aug 2023 11:35:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DC4411F45F;
        Thu, 31 Aug 2023 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693506907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dPb86ZrazVKix28kU/q+MBexjFVuoHs169RJWmp67YA=;
        b=fL5LLTKBCOxOHprvUULM+0IGoXbNZPEM535STECUvhKMHzgDYw0Lwa9gxIjOU7zxQoC2AM
        HATFtu/EJfZOfC8V01PRyzEGybn4PjBgDCau71XhYLbeo2BfpDytGzlZyVSXJ7LFSn7LXu
        oWMG6WY3GEkMSg6EidnbQ5V6iztCdTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693506907;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=dPb86ZrazVKix28kU/q+MBexjFVuoHs169RJWmp67YA=;
        b=Os3OZXUR2h/mMA3EW/inI18ic2lu9Je5szvys3q0rlxQ8sDl3HxGfDCt8WI/Cvt3QVFLem
        gmb9qTuUMHvRrdAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B425513583;
        Thu, 31 Aug 2023 18:35:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4PiCKlvd8GROPAAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 31 Aug 2023 18:35:07 +0000
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, David Disseldorp <ddiss@suse.de>
Subject: [PATCH] scsi: target: fix target_cmd_counter leak
Date:   Thu, 31 Aug 2023 20:34:59 +0200
Message-Id: <20230831183459.6938-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

The target_cmd_counter struct allocated via target_alloc_cmd_counter()
is never free'd, resulting in leaks across various transport types,
e.g.:

 unreferenced object 0xffff88801f920120 (size 96):
  comm "sh", pid 102, jiffies 4294892535 (age 713.412s)
  hex dump (first 32 bytes):
    07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 38 01 92 1f 80 88 ff ff  ........8.......
  backtrace:
    [<00000000e58a6252>] kmalloc_trace+0x11/0x20
    [<0000000043af4b2f>] target_alloc_cmd_counter+0x17/0x90 [target_core_mod]
    [<000000007da2dfa7>] target_setup_session+0x2d/0x140 [target_core_mod]
    [<0000000068feef86>] tcm_loop_tpg_nexus_store+0x19b/0x350 [tcm_loop]
    [<000000006a80e021>] configfs_write_iter+0xb1/0x120
    [<00000000e9f4d860>] vfs_write+0x2e4/0x3c0
    [<000000008143433b>] ksys_write+0x80/0xb0
    [<00000000a7df29b2>] do_syscall_64+0x42/0x90
    [<0000000053f45fb8>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Free the structure alongside the corresponding iscsit_conn / se_sess
parent.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 687adc9e086c..0686882bcbda 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -264,6 +264,7 @@ void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 		percpu_ref_put(&cmd_cnt->refcnt);
 
 	percpu_ref_exit(&cmd_cnt->refcnt);
+	kfree(cmd_cnt);
 }
 EXPORT_SYMBOL_GPL(target_free_cmd_counter);
 
-- 
2.35.3

