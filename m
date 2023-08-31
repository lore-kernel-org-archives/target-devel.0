Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8FEC83F2F
	for <target-devel@archiver.kernel.org>; Thu, 31 Aug 2023 19:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjHaTUt (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 15:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjHaTUs (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 15:20:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBF1E65
        for <target-devel@vger.kernel.org>; Thu, 31 Aug 2023 12:20:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C853F1F45F;
        Thu, 31 Aug 2023 19:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693509644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+UXZAltNyiTy0KB491Lfmj4c0V0EGr7D6aiiKoMwE0U=;
        b=ONQ1cFy3GP8twjsIdLiCPH82xfOUOO218LRtfvJsWo6ky9uDnWM2jP2dIzSVv6STXID6hn
        YUVBmk1yO4Tvmd8cMd50369Yx7x+yRsPRqChCjXp9jdnnGfLypDIX7tTjeKzp0wV+cPkC/
        dkhGHHlDAp8/MV6VGr2TGF+xE9ddd3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693509644;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+UXZAltNyiTy0KB491Lfmj4c0V0EGr7D6aiiKoMwE0U=;
        b=9ON1py342LPKmylru7DnkKpKK/DWzrXN/8LFoTSDblVc8XjvVXBol0seU4Pc2k2lWUgRge
        lSNoHbYtknYCxBAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A50CE13587;
        Thu, 31 Aug 2023 19:20:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zE7dJgzo8GReUAAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 31 Aug 2023 19:20:44 +0000
Date:   Thu, 31 Aug 2023 21:20:43 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: target: fix target_cmd_counter leak
Message-ID: <20230831212043.19a2809a@echidna.fritz.box>
In-Reply-To: <20230831183459.6938-1-ddiss@suse.de>
References: <20230831183459.6938-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, 31 Aug 2023 20:34:59 +0200, David Disseldorp wrote:

> The target_cmd_counter struct allocated via target_alloc_cmd_counter()
> is never free'd, resulting in leaks across various transport types,
> e.g.:
> 
>  unreferenced object 0xffff88801f920120 (size 96):
>   comm "sh", pid 102, jiffies 4294892535 (age 713.412s)
>   hex dump (first 32 bytes):
>     07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 38 01 92 1f 80 88 ff ff  ........8.......
>   backtrace:
>     [<00000000e58a6252>] kmalloc_trace+0x11/0x20
>     [<0000000043af4b2f>] target_alloc_cmd_counter+0x17/0x90 [target_core_mod]
>     [<000000007da2dfa7>] target_setup_session+0x2d/0x140 [target_core_mod]
>     [<0000000068feef86>] tcm_loop_tpg_nexus_store+0x19b/0x350 [tcm_loop]
>     [<000000006a80e021>] configfs_write_iter+0xb1/0x120
>     [<00000000e9f4d860>] vfs_write+0x2e4/0x3c0
>     [<000000008143433b>] ksys_write+0x80/0xb0
>     [<00000000a7df29b2>] do_syscall_64+0x42/0x90
>     [<0000000053f45fb8>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> Free the structure alongside the corresponding iscsit_conn / se_sess
> parent.

I forgot to add...
Fixes: becd9be6069e ("scsi: target: Move sess cmd counter to new struct")
