Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4549C433DB
	for <target-devel@archiver.kernel.org>; Mon,  8 Feb 2021 12:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD9764E87
	for <target-devel@archiver.kernel.org>; Mon,  8 Feb 2021 12:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhBHMEV (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:04:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233571AbhBHMC5 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 07:02:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612785690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTlcoT+IigUWQzE/5Lb/sZFJTttDVxoCx4ggLUb2mzc=;
        b=Blw9yFoEvaa3Sdy1kZOkx1K2QQN7KMNj77LTZUztX8xI3IgtZ0tj3v9p9CF6Tr7+Cus/Iy
        MUhnoAfGPqDv8cpKdlOvzPLfsdpPsQ9eT+u2tSvUUhVXLWuDZmg53uvJehGaZC6tYDkAx4
        5DcRT/pL4/bPU2e0o10yX0szbDeSaJM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-4ZVwj7G6PR60tINq4KJK-A-1; Mon, 08 Feb 2021 07:01:28 -0500
X-MC-Unique: 4ZVwj7G6PR60tINq4KJK-A-1
Received: by mail-ed1-f72.google.com with SMTP id w14so13058668edv.6
        for <target-devel@vger.kernel.org>; Mon, 08 Feb 2021 04:01:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTlcoT+IigUWQzE/5Lb/sZFJTttDVxoCx4ggLUb2mzc=;
        b=Fx4F4QmkCMfBHsjZfcDqnj6dwmg3C5ucEC1BUGO9grjsSoj41yVAKlQ6RydLsOmma0
         PtQVTcHZdJWWCUB0BNHSEjwTdA9Wl+yE7zJv9LsZStK/HULIQYLWXhvcvTqKsgvGJ4pR
         vyVVNr/zWJRsNxtOjvMjMwhyydBCXESHKeK51zkEfYwmffMIoBtGhWnrRG9G0Cfr5m8O
         e+KyNQH6klZYztzDY5zqkNpk9adZSj/CF85+F1TGguW4XLNq/v56/J5QWpH9ZV/CdUWx
         buJV1viNsHEtxvKaMTAE/0o8NAtmcZxGpR42ZzcnQAoji9OsD7tRL3S/YZfKJ1b1jJIc
         gl5g==
X-Gm-Message-State: AOAM5322m+vVeA016Gm4RJBQhngOGPoW2L0//MEI6hsRA8cJ83s5Ox9p
        AVrXpfn3366Njlv8nRJSMl90Wkmp+l16xjfzBDZsY1U/RreBuxpxCZL3DmS9REFUeIjU+cXeJPc
        cRXd6cbnSQmEiWNctcqJOhAIE
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr16757914edz.89.1612785687673;
        Mon, 08 Feb 2021 04:01:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6KUrSSLZ/WJvZD7GSCwfBw66PX8V89QFLyOzcHizAKpcWVSLgUjhtBHtAVbQuSaC5ixXRIw==
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr16757890edz.89.1612785687468;
        Mon, 08 Feb 2021 04:01:27 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id h25sm8481385ejy.7.2021.02.08.04.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 04:01:26 -0800 (PST)
Date:   Mon, 8 Feb 2021 07:01:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/11] target: fix cmd plugging and completion
Message-ID: <20210208070050-mutt-send-email-mst@kernel.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, Feb 04, 2021 at 05:35:02AM -0600, Mike Christie wrote:
> The following patches made over Martin's 5.12 branches fix two
> issues:
> 
> 1. target_core_iblock plugs and unplugs the queue for every
> command. To handle this issue and handle an issue that
> vhost-scsi and loop were avoiding by adding their own workqueue,
> I added a new submission workqueue to LIO. Drivers can pass cmds
> to it, and we can then submit batches of cmds.
> 
> 2. vhost-scsi and loop on the submission side were doing a work
> per cmd and on the lio completion side it was doing a work per
> cmd. The cap on running works is 512 (max_active) and so we can
> end up end up using a lot of threads when submissions start blocking
> because they hit the block tag limit or the completion side blocks
> trying to send the cmd. In this patchset I just use a cmd list
> per session to avoid abusing the workueue layer.
> 
> The combined patchset fixes a major perf issue we've been hitting
> where IOPs is stuck at 230K when running:
> 
>     fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
>     --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
>     --group_reporting --runtime=60
> 
> The patches in this set get me to 350K when using devices that
> have native IOPs of around 400-500K.
> 
> Note that 5.12 has some interrupt changes that my patches
> collide with. Martin's 5.12 branches had the changes so I
> based my patches on that.
> 

OK so feel free to merge through that branch.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

-- 
MST

