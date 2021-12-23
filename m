Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA74C433F5
	for <target-devel@archiver.kernel.org>; Thu, 23 Dec 2021 12:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348102AbhLWMFd (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Thu, 23 Dec 2021 07:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243347AbhLWMF3 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 23 Dec 2021 07:05:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45339C061401
        for <target-devel@vger.kernel.org>; Thu, 23 Dec 2021 04:05:29 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id j18so11054471wrd.2
        for <target-devel@vger.kernel.org>; Thu, 23 Dec 2021 04:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4hOS+EulnpPlF4ImJR2T2gjnQyC+IHHvrLHNkR1bXtc=;
        b=d0mBrzRGXETgedfyIr1SdYwoW0oAQ72kJGMJ8O+x7IZT0ibssxpZ1D6eqHz5RqC9Uu
         MFXl4wX9A/WoToYWHKvlt93AG0anMkKe9uiolimX9jse5Pw3S/ZWVXv+OEawO33NUZOF
         wljpg/Woa7KVDiA1Y6nHAiNRUmQWZPL5jaPO3WCKzf27u2iR/CdxmJ6chOVUzcl1ceNQ
         h43TvsLS2Zd/Iv+IGlMfNWn1Fg4kxFRgxP/kTxkexY7ArTe0Y++/08JaCkpNciM6qyCF
         veZfMktGkIpdzfZtm15n5HVHDhGg4WUSvpMMRLrrzeWjLytrLGn6IGWoA4GGPGhYM+kK
         JT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4hOS+EulnpPlF4ImJR2T2gjnQyC+IHHvrLHNkR1bXtc=;
        b=LnND9S+bpddLPF6hcJzFLmTBq+SlFji0gOWC4noMsTh9fGcfLAxq+3q0lBhSERNVGR
         zqETYn4jLtHO8yarYrDDCYC4SsUgU3/dhUjUlUQAU23V/NJSXqx5Ylsjnhnp4i4x5+nZ
         0EJL8LwQXPQCtGPUaGZXhSGGL1qz59QSuFu1HYFNY0IZ8zis1aWRP7/juE6Ir9l4qgeU
         t3HwCLFKboDf0pSi1UKGKkfnAcUq/gH2/GagpGQn8W76NXfcNFXg8WTjEXts0pb5Qzel
         ZR5PrKrjiNrq0NW9cIfTh+7GLsS2Bwqb+hZXgOiltKWBVoQxMroblD1OZeZNLjLi+54h
         55Sw==
X-Gm-Message-State: AOAM532wSC9WGyesVd5gHxGPRw4+H4+nilm+//qO6bQ+xjUUfL8XMoki
        yLTFqMOND4MXV05jvApLBkZjGGJDDgY=
X-Google-Smtp-Source: ABdhPJw35PYnJCjGaezTDY6f1SrzLCUuA2b0Wn/6+5pbx5grAME4IMJDT4A3k+McLklpCLDmFi9E3g==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr1502823wri.336.1640261127483;
        Thu, 23 Dec 2021 04:05:27 -0800 (PST)
Received: from [192.168.178.40] (ipbcc1fa42.dynamic.kabel-deutschland.de. [188.193.250.66])
        by smtp.gmail.com with ESMTPSA id b19sm8750352wmb.38.2021.12.23.04.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 04:05:27 -0800 (PST)
Subject: Re: tcmu data area double copy overhead
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
 <69dbd44d-d1ae-38a7-6617-617571796115@gmail.com>
 <8f3bd879-e8f8-bcb8-489f-b922f05639ea@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <bc8d597b-34cc-a1a7-83ef-7a7a41757745@gmail.com>
Date:   Thu, 23 Dec 2021 13:05:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8f3bd879-e8f8-bcb8-489f-b922f05639ea@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 21.12.21 14:26, Xiaoguang Wang wrote:
> hi,
> 
>> On 08.12.21 13:43, Xiaoguang Wang wrote:
>>> hi，
>>>
>>> I'm a newcomer to tcmu or iscsi subsystem, and have spent several 
>>> days to learn
>>> iSCSI and tcmu, so if my question looks fool, forgive me :)
>>>
>>> One of our customers is using tcmu to visit remote distributed 
>>> filesystem and finds
>>> that there's obvious copy overhead in tcmu while doing read 
>>> operations, so I spent
>>> time to find the reason and see whether can optimize a bit. Now 
>>> according to my
>>> understanding about tcmu kernel codes, tcmu allocates internal data 
>>> pages for data
>>> area, use these data pages as temporary storage between user-space 
>>> backstore and
>>> tcmu. For iSCSI initiator's write request, tcmu first copy sg page's 
>>> content to internal
>>> data pages, then user-space backstore moves mmaped data area for 
>>> these data pages
>>> to backstore; for iSCSI initiator's read request, tcmu also allocates 
>>> internal data pages,
>>> backstore copies distributed filesystem's data to these data pages, 
>>> later tcmu copy
>>> data pages' content to sg's pages. That means for both read and write 
>>> requests, it
>>> exists one extra data copy.
>>>
>>> So my question is that whether we don't allocate internal data pages 
>>> in tcmu, just make
>>> sg's pages to be mmaped in data area, so we can reduce one extra 
>>> copy, which I think
>>> it can improve throughput. Or is there any special security issues 
>>> that we can not do
>>> this way? Thanks.
>>
>> You are right, tcmu currently copies data between the sg-pages and tcmu
>> data pages.
>>
>> But I'm not sure the solution you suggest would really show the improved
>> throughput you expect, because we would have to map all data pages of the
>> sgl(s) of a new cmd into user space and unmap them again when the cmd is
>> processed.
>>
>> To map one page means, that we store the struct page pointer in tcmu's
>> data (xarray). If userspace tries to read or write that page, a page 
>> fault
>> will occur and kernel will call tcmu_vma_fault which returns the page
>> pointer. To unmap means that tcmu has remove the page pointer and to call
>> unmap_mapping_range. So I'm not sure that copying content of one page is
>> more expensive than mapping and unmapping one page.
>>
>> Additionally, if tcmu would map the sg-pages, it would have to unmap the
>> pages immediately when userspace completes the cmd, because tcmu is not
>> the owner of the pages. So the recently added feature "KEEP_BUF" would
>> have to be removed again. But that feature was added to avoid the need 
>> for
>> data copy in userspace in some situations.
>>
>> Finally, if tcmu times out a cmd that is waiting on the ring for
>> completion from userspace, tcmu sends cmd completion to tcm core. Before
>> doing so, it would have to unmap the sg-pages. If userspace later 
>> tries to
>> access one of these pages, tcmu_vma_fault has nothing to map, instead
>> returns VM_FAULT_SIGBUS and userspace receives SIGBUS.
>>
>> I already started another attempt to avoid data copy in tcmu. The idea
>> is to optionally allow backend drivers to have callbacks for sg 
>> allocation
>> and free. 
> Does  the "backend drivers" here mean user-space tcmu backstore? If yes,
> seems that lio uses target_alloc_sgl() to allocates sg pages, so how we 
> pass
> this info to user-space tcmu backstore? Thanks.

I just added a new optional backend callback that was called by
transport_generic_new_cmd. Only tcmu implemented that callback.

> 
> One of our customers use LIO to export a local scsi device using 
> tcm_loop and
> tcmu userspace back store, for this usage, because
> ==> tcm_loop_target_queue_cmd
> ====> target_submit_prep
> tcm_loop_target_queue_cmd() is called with valid sg, so your 
> optimization won't
> work here, right? Thanks.

Yes. The way I implemented my first attempt didn't work for drivers
setting SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC. Of course for a final
solution it would be great to speed up _all_ fabrics. Unfortunately
I fear it will not be possible. E.g. for tcmloop I see no chance,
because sgls in that case directly come from the initiator side.

I don't know yet, whether for iscsi we can find a solution. If you
have suggestions, please let me know.

> 
> Regards,
> Xiaoguang Wang
> 
>> That way the pages in a sg allocated by tcm core can be pages
>> from tcmu's data area. Thus, no map/unmap is needed and the fabric driver
>> directly writes/reads data to/from those pages visible to userspace.
>>
>> In a high performance scenario the method already lowers cpu load and
>> enhances throughput very well with qla2xxx fabric. Unfortunately that
>> patchset works only for fabrics using target_submit_cmd or calling
>> target_submit_prep without allocated sgls, which iscsi does not :(
>> Currently I'm working on another tuning measure in tcmu. After that I'll
>> go back to my no-data-copy patches. Maybe I can make them work with most
>> fabric drivers including iscsi.
>>
>> Regards,
>> Bodo
> 
