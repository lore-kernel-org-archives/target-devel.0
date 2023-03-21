Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C973C6FD1D
	for <target-devel@archiver.kernel.org>; Tue, 21 Mar 2023 07:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCUHNq (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 21 Mar 2023 03:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUHNp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 21 Mar 2023 03:13:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34D32ED68
        for <target-devel@vger.kernel.org>; Tue, 21 Mar 2023 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679382766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p8ugM/ytesWqF34fV4HlXU0YWGvC9AcHqKjsu6is6SE=;
        b=OYNxgqNVm8Fthd71MLq6Qq0gthP6cL2c8CV0FZNODj2pT2ogtpf0MfQC1FrdMhwfGtbNU0
        Ti+I0sPKlwklogKFxZhl6vnIpk4GO40aPf4es/LV8ujHr5bfy1GjAredzvey3CWzfmGmbT
        6mmpLXfsADt22DSqrK5YyFY6xEZs6mc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-mZGf7LliN9mh51eoMb1JMQ-1; Tue, 21 Mar 2023 03:12:45 -0400
X-MC-Unique: mZGf7LliN9mh51eoMb1JMQ-1
Received: by mail-wm1-f71.google.com with SMTP id n38-20020a05600c3ba600b003ed29a0b729so6603289wms.9
        for <target-devel@vger.kernel.org>; Tue, 21 Mar 2023 00:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679382764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8ugM/ytesWqF34fV4HlXU0YWGvC9AcHqKjsu6is6SE=;
        b=A+M62qEd5CrNHq3TdbqoiVgPkZ7Voczsr3C3CufwdcUCCpQKJ1M/DiGuOHDwEGbpGk
         8rv9453KiGdHjPddk4vZ5OgT4LTVIxNGWby2l1K8p6KDLxc6d7BSNMrvNeSNegG9WhE0
         X6ykKySjk1ujVrtb1FCmynuwxs5LMmKG2SmSQWh+56tXuIGPJPrrO/L6Crr6FhayUPJb
         q0xD874UXmQJpvQAC9eB2vgS6he449m+xEHO6s5zdPoQh7GiexdO3gr8HiDE73lxdzCJ
         AIB2dMqdYGoCwwkZgaabCV8Hdwgago8qUka1ncIopJBfc9hyN6Xyja4C4lltwlde/qih
         xFGQ==
X-Gm-Message-State: AO0yUKXW6j5eGwfnScFLqrpqwvMpLEgoJXIQ9U0vtsEZJyews4yPbGeh
        JWhi1WBtUeTUO4m6lakOQR57EAyYhjkKOCWQTQVCd7jecgFDFSUXJPu2Mc9/vW2eEqlY9rQb4C6
        f56rO5/GBsbb92XWjUivzwKB/
X-Received: by 2002:a5d:5686:0:b0:2cf:ee25:18ce with SMTP id f6-20020a5d5686000000b002cfee2518cemr1688022wrv.27.1679382764458;
        Tue, 21 Mar 2023 00:12:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set/dVewTSOqdyJmq47xput657YXM3zFLzlzIaRrCvNgpUkq9OkJ2e35jg3xMjhBxDWtcYlageg==
X-Received: by 2002:a5d:5686:0:b0:2cf:ee25:18ce with SMTP id f6-20020a5d5686000000b002cfee2518cemr1688010wrv.27.1679382764180;
        Tue, 21 Mar 2023 00:12:44 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm10510774wrw.99.2023.03.21.00.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 00:12:43 -0700 (PDT)
Date:   Tue, 21 Mar 2023 03:12:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     michael.christie@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/7] vhost-scsi: Fix crashes and management op hangs
Message-ID: <20230321031147-mutt-send-email-mst@kernel.org>
References: <20230321020624.13323-1-michael.christie@oracle.com>
 <e1a96cd4-e520-caf5-7d5f-1de270c4fecb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1a96cd4-e520-caf5-7d5f-1de270c4fecb@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Mar 20, 2023 at 09:29:50PM -0500, michael.christie@oracle.com wrote:
> On 3/20/23 9:06 PM, Mike Christie wrote:
> > The following patches were made over Linus tree.
> 
> Hi Michael, I see you merged my first version of the patchset in your
> vhost branch.
> 
> Do you want me to just send a followup patchset?
> 
> The major diff between the 2 versions:
> 
> 1. I added the first 2 patches which fix some bugs in the existing code
> I found while doing some code review and testing another LIO patchset
> plus v1.
> 
> Note: The other day I posted that I thought the 3rd patch in v1 caused
> the bugs but they were already in the code.
> 
> 2. In v2 I made one of the patches not need the vhost device lock when
> unmapping/mapping LUNs, so you can add new LUNs even if one LUN on the same
> vhost_scsi device was hung.
> 
> Since it's not regressions with the existing patches, I can just send those
> as a followup patchset if that's preferred.

It's ok, I will drop v1 and replace it with v2.
Do you feel any of this is needed in this release?

-- 
MST

