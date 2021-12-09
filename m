Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76381C433EF
	for <target-devel@archiver.kernel.org>; Thu,  9 Dec 2021 19:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhLITPP (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 14:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhLITPP (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 14:15:15 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46953C061746
        for <target-devel@vger.kernel.org>; Thu,  9 Dec 2021 11:11:41 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a9so11398312wrr.8
        for <target-devel@vger.kernel.org>; Thu, 09 Dec 2021 11:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XHCVfFRVT34TUQNKXv1ZA4thxJznO6VPbeFLEtsm2mM=;
        b=qZ1ZKa0M7Ihjo180mNBWSrS4oDsEFVWTcl7FS5qAEyLg1mt8o+vkpfMGtDKfYfBc71
         dklDyy4VFJj2KVmchmWSLk7YS/rbUET3o+z1Z5wLOqIHp3Y4kG7bOVrTZEnMykYB+sgw
         ydZiT7lm9N2hOqptX2cV7Y0M8S6qXttNHQ7gnNdkglDI03AuuOxjql4tuIfETCEQMKky
         bEJe4PVF05aVvoy+3aT2Fxz6FqDpkKftM75fw+9pa1qCdlptzlg5k7mPKDQ8eohM10+H
         EfdOD6UEoFfZ9M6zDdo/22VMZjOkRSEH5FtefBzNBX5vWS9kDy4pv3KweJQNzn3Ruv12
         7yUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XHCVfFRVT34TUQNKXv1ZA4thxJznO6VPbeFLEtsm2mM=;
        b=evpOjmVqFdNvJozjiRpKLH2zVTBXEY8Qwu76T4C+Ad225aOF33gAjTjr8BhJqmYrRO
         ZOEnBUTv5EACpEsN6gcbTELzyGYQa5MFUbYNE2scKOnIhUP/7c4dyRyNMEAobPhOBVe+
         iFl/1XgRTlTRxJ6g50mTEwYTD5xh2woZuRUgqe+OArmiQbq/Jf3G3ZwiIxzjImcCEnph
         h2AMndazj70ctAGm+JN2eKAsKL70HYplemRjMccHHeSJ2mWD2gwtVeRxZ0/0UnA4DSuC
         m6uoBbJVVKMO8YJuoOX3MYpQc9MrABaqivPUupmWYYZz7ll+Ikg7uqIcAeoSN8B6Y725
         bEzw==
X-Gm-Message-State: AOAM530yxhzAtwYOVIHdCaKb2riIulPriqzBTBA/ye2fTbtQivpfNIsd
        B73bleEqziokRdQ7Zt1OX74WPCD7Xms=
X-Google-Smtp-Source: ABdhPJwEqGuDZOltW0y6B3PVzTr9dxD26IQUtPJCCHDoHUv4Rgo511+6oj/DPPVjSr4qURqAjp2aWA==
X-Received: by 2002:a05:6000:1a86:: with SMTP id f6mr8512042wry.230.1639077099754;
        Thu, 09 Dec 2021 11:11:39 -0800 (PST)
Received: from [192.168.178.40] (ipbcc08d44.dynamic.kabel-deutschland.de. [188.192.141.68])
        by smtp.gmail.com with ESMTPSA id f13sm672125wmq.29.2021.12.09.11.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 11:11:39 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: tcmu data area double copy overhead
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
Message-ID: <69dbd44d-d1ae-38a7-6617-617571796115@gmail.com>
Date:   Thu, 9 Dec 2021 20:11:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 08.12.21 13:43, Xiaoguang Wang wrote:
> hi，
> 
> I'm a newcomer to tcmu or iscsi subsystem, and have spent several days 
> to learn
> iSCSI and tcmu, so if my question looks fool, forgive me :)
> 
> One of our customers is using tcmu to visit remote distributed 
> filesystem and finds
> that there's obvious copy overhead in tcmu while doing read operations, 
> so I spent
> time to find the reason and see whether can optimize a bit. Now 
> according to my
> understanding about tcmu kernel codes, tcmu allocates internal data 
> pages for data
> area, use these data pages as temporary storage between user-space 
> backstore and
> tcmu. For iSCSI initiator's write request, tcmu first copy sg page's 
> content to internal
> data pages, then user-space backstore moves mmaped data area for these 
> data pages
> to backstore; for iSCSI initiator's read request, tcmu also allocates 
> internal data pages,
> backstore copies distributed filesystem's data to these data pages, 
> later tcmu copy
> data pages' content to sg's pages. That means for both read and write 
> requests, it
> exists one extra data copy.
> 
> So my question is that whether we don't allocate internal data pages in 
> tcmu, just make
> sg's pages to be mmaped in data area, so we can reduce one extra copy, 
> which I think
> it can improve throughput. Or is there any special security issues that 
> we can not do
> this way? Thanks.

You are right, tcmu currently copies data between the sg-pages and tcmu
data pages.

But I'm not sure the solution you suggest would really show the improved
throughput you expect, because we would have to map all data pages of the
sgl(s) of a new cmd into user space and unmap them again when the cmd is
processed.

To map one page means, that we store the struct page pointer in tcmu's
data (xarray). If userspace tries to read or write that page, a page fault
will occur and kernel will call tcmu_vma_fault which returns the page
pointer. To unmap means that tcmu has remove the page pointer and to call
unmap_mapping_range. So I'm not sure that copying content of one page is
more expensive than mapping and unmapping one page.

Additionally, if tcmu would map the sg-pages, it would have to unmap the
pages immediately when userspace completes the cmd, because tcmu is not
the owner of the pages. So the recently added feature "KEEP_BUF" would
have to be removed again. But that feature was added to avoid the need for
data copy in userspace in some situations.

Finally, if tcmu times out a cmd that is waiting on the ring for
completion from userspace, tcmu sends cmd completion to tcm core. Before
doing so, it would have to unmap the sg-pages. If userspace later tries to
access one of these pages, tcmu_vma_fault has nothing to map, instead
returns VM_FAULT_SIGBUS and userspace receives SIGBUS.

I already started another attempt to avoid data copy in tcmu. The idea
is to optionally allow backend drivers to have callbacks for sg allocation
and free. That way the pages in a sg allocated by tcm core can be pages
from tcmu's data area. Thus, no map/unmap is needed and the fabric driver
directly writes/reads data to/from those pages visible to userspace.

In a high performance scenario the method already lowers cpu load and
enhances throughput very well with qla2xxx fabric. Unfortunately that
patchset works only for fabrics using target_submit_cmd or calling
target_submit_prep without allocated sgls, which iscsi does not :(

Currently I'm working on another tuning measure in tcmu. After that I'll
go back to my no-data-copy patches. Maybe I can make them work with most
fabric drivers including iscsi.

Regards,
Bodo
