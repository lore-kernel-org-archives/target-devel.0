Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1CBC433DB
	for <target-devel@archiver.kernel.org>; Mon, 15 Feb 2021 16:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775FA64DA3
	for <target-devel@archiver.kernel.org>; Mon, 15 Feb 2021 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhBOQga (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 15 Feb 2021 11:36:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231394AbhBOQeX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 15 Feb 2021 11:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613406762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nsu0NYWpkITZ0mX1F4Fx9TaG3DZpEqtAizAdVndPsGU=;
        b=a18rbywoW18sIXooymbiRYcM1vIDm5RxgbePDP/nNrJ8z/7j55qFqDMYVWRD8n2C6jdOMD
        1N3NObh/SRVs8A4FFL2VNTKUl0RFAi4tH8hwFrag/aC7G/OtPAemwaXB2iJWNTrh/nFOIP
        Hl3mcOhHSvECUUQCN19T4Z8EmQb83xA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-NrVkac9KOpWyLe1Hh5twjg-1; Mon, 15 Feb 2021 11:32:40 -0500
X-MC-Unique: NrVkac9KOpWyLe1Hh5twjg-1
Received: by mail-qk1-f198.google.com with SMTP id c63so5840063qkd.1
        for <target-devel@vger.kernel.org>; Mon, 15 Feb 2021 08:32:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nsu0NYWpkITZ0mX1F4Fx9TaG3DZpEqtAizAdVndPsGU=;
        b=Hx335v7QHcm+eVdecWK+JquxTY+W96DERMZpKnznPUMHN7dyCa39AY5zgNeyOKLkGd
         jAB2G3PwamShywHMpMVY1HFUViiHic5VRfRkSMWacEyqEDclg94hMggJuaE2S/0CWWiD
         Ydb2GWuHsPbsF0EyYOEU9lkrO1WU2FRgGdPsAqOJ39cYoL3OeTz3/JKtUTx3qmmCJo11
         o4JXLowOlnYoeu3MiDKN1FTqkagTxNWeiD31NkPrChGKI0NcAemzzokoA31epNPTF5i7
         tPPbp7M5Qb+1XuYaNHizHc5z4AuD4Sy3TxRqS70BHpK5bKkennWQuE808QgBARJ/6+nn
         Q/Sg==
X-Gm-Message-State: AOAM531X9KxvvkAQ8h2J1JLZMtIhCHELU/sGTwj0m6zGb3TBg/ZhMl4R
        9ZiRsa8jqo557KRieiNW4IJ8ik2HCLDFWp/eZpN86wbFEBgy1pSrwGp7B+GRkDM/jIrUtGfQg3r
        wvkt83cREnEIWyHoZzLIlIrGO
X-Received: by 2002:ac8:5a96:: with SMTP id c22mr14701088qtc.303.1613406759927;
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPO+Vyn4WpwxEWv+KOmiND7zS5wjzEqyCbDe2ayTRCcVWkJbUnKFLfGMB1WrJJU7FL5bPg4A==
X-Received: by 2002:ac8:5a96:: with SMTP id c22mr14701067qtc.303.1613406759625;
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id 18sm10984888qtw.70.2021.02.15.08.32.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Feb 2021 08:32:39 -0800 (PST)
Message-ID: <9b418dff52ac32a2b092e5596506ba7f5a2ad614.camel@redhat.com>
Subject: Re: PATCH 00/25 V4] target: fix cmd plugging and submission
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Date:   Mon, 15 Feb 2021 11:32:37 -0500
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, 2021-02-12 at 01:26 -0600, Mike Christie wrote:
> The following patches were made over Martin's 5.12 branches
> to handle conflicts with the in_interrupt changes.
> 
> The patches fix the following issues:
> 
> 1. target_core_iblock plugs and unplugs the queue for every
> command. To handle this issue and handle an issue that
> vhost-scsi and loop were avoiding by adding their own workqueue,
> I added a new submission workqueue to LIO. Drivers can pass cmds
> to it, and we can then submit batches of cmds.
> 
> 2. vhost-scsi and loop on the submission side were doing a work
> per cmd but because we can block in the block layer on resources
> like tags we can end up creating lots of threads that will fight
> each other. In this patchset I just use a cmd list per device to
> avoid abusing the workueue layer and to better batch the cmds
> to the lower layers.
> 
> The combined patchset fixes a major perf issue we've been hitting
> with vhost-scsi where IOPs were stuck at 230K when running:
> 
>     fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
>     --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
>     --group_reporting --runtime=60
> 
> The patches in this set get me to 350K when using devices that
> have native IOPs of around 400-500K. 
> 
> 3. Fix target_submit* error handling. While handling Christoph's
> comment to kill target_submit_cmd_map_sgls I hit several bugs that
> are now also fixed up.
> 
> V4:
> - Fixed the target_submit error handling.
> - Dropped get_cdb callback.
> - Fixed kernel robot errors for incorrect return values and unused
> variables.
> - Used flush instead of cancel to fix bug in tmr code.
> - Fixed race in tcmu.
> - Made completion affinity handling a configfs setting
> - Dropped patch that added the per device work lists. It really
> helped
> a lot for higher perf initiators and tcm loop but only gave around a
> 5%
> boost to other drivers. So I dropped it for now to see if there is
> something more generic we can do.
> 
> V3:
> - Fix rc type in target_submit so its a sense_reason_t
> - Add BUG_ON if caller uses target_queue_cmd_submit but hasn't
> implemented get_cdb.
> - Drop unused variables in loop.
> - Fix race in tcmu plug check
> - Add comment about how plug check works in iblock
> - Do a flush when handling TMRs instead of cancel
> 
> V2:
> - Fix up container_of use coding style
> - Handle offlist review comment from Laurence where with the
> original code and my patches we can hit a bug where the cmd
> times out, LIO starts up the TMR code, but it misses the cmd
> because it's on the workqueue.
> - Made the work per device work instead of session to handle
> the previous issue and so if one dev hits some issue it sleeps on,
> it won't block other devices.
> 
> 
> 

Hello Mike
Against linux-next with some manual fixups (as expected) 

The original issue I reported for tcm_loop seems to be resolved with
this series of patches as well as the stall if memory became low.
I also rans some additional tcm_core tests on a target server with
tcm_qla2xxx as it uses some of the tcm_core changes.
Its not exhaustive
for all changes but covers most.

Tested-by:Laurence Oberman <loberman@redhat.com>


