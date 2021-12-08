Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A7BC433EF
	for <target-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhLHNhU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:37:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232496AbhLHNhU (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638970427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPxv+iXUX5Wwc9azRulKHWbOCZaavMgpbC92uthTnD0=;
        b=O3wO5thVAg6S19++gKHOR0TbloTFOuXG8dAEEAYIAAHM5F5hSbyI5jppNNO5HqWEKjA543
        AD69Bh7NO0P0un8lZR0/lCJOdo0mQogb22EeH1FaUWc4xAvqm6kCIeqWeOd1zGgwo7cGGO
        htHepSzX+ngHwEvFvhha3r2/v7OE+84=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-kZlniVRsPrKC1j6YV46ocA-1; Wed, 08 Dec 2021 08:33:46 -0500
X-MC-Unique: kZlniVRsPrKC1j6YV46ocA-1
Received: by mail-pj1-f70.google.com with SMTP id mn13-20020a17090b188d00b001a64f277c1eso3735196pjb.2
        for <target-devel@vger.kernel.org>; Wed, 08 Dec 2021 05:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JPxv+iXUX5Wwc9azRulKHWbOCZaavMgpbC92uthTnD0=;
        b=hd1NbwRWl3KLa372rEffrXz4Nmpdy4zYdvh4GLp7b275rC+fvJUdGPmjmTmhyJQ0Nj
         HHZKVH5d3OSRLhxmbO8/Q+GRSxyStx43UnQdhXVyHsEOo6v3mYvra7HGORlpmPDsEy+a
         ke+EaVHOajZnXfPDMo/J1gNI1tfNQV1wl+PxHoPqjox3QIkfo2QjDaE/dANaUZmIMqWs
         YC22jFzgdFa2P6Dd78qQKNXLVvyUEVniCgW7FQDpzceEuId2QE+3kMHKxjCi217FxPo/
         AIN0pchMZas5MyYrW4NKWSpwiuXcPm8iNUpMoNJ98aAaNaYCevbBg4rV6tACmbiKybZ2
         haZw==
X-Gm-Message-State: AOAM5324NNHs3KkdXxhZCeHbVY7NEOCC/vLlHRhbcCzg2G0tjf+IgfR+
        1K/nIQnT4xo6KDmHtVfuZt310Jg5N0yKk4p68InKrfyg/5le9yynwZM3cXZp1pr4wwazvRYNmhZ
        ngiCRW/wB5qr3zvE3FMzx8tMT
X-Received: by 2002:a62:b418:0:b0:4a0:3696:dec0 with SMTP id h24-20020a62b418000000b004a03696dec0mr5696995pfn.73.1638970425251;
        Wed, 08 Dec 2021 05:33:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwJtEJrVID+YtnOUhUXZmpMeNQ6HIx/+2qXnOnhhnx4L2OSx2gpxR9sEI4h5HX8rA8tQz5Vw==
X-Received: by 2002:a62:b418:0:b0:4a0:3696:dec0 with SMTP id h24-20020a62b418000000b004a03696dec0mr5696966pfn.73.1638970424973;
        Wed, 08 Dec 2021 05:33:44 -0800 (PST)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o7sm2883455pjf.33.2021.12.08.05.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 05:33:21 -0800 (PST)
Subject: Re: tcmu data area double copy overhead
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5428b65d-07d7-bb61-0409-b57955b89395@redhat.com>
Date:   Wed, 8 Dec 2021 21:32:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


On 12/8/21 8:43 PM, Xiaoguang Wang wrote:
> hi，
>
> I'm a newcomer to tcmu or iscsi subsystem, and have spent several days 
> to learn
> iSCSI and tcmu, so if my question looks fool, forgive me :)
>
> One of our customers is using tcmu to visit remote distributed 
> filesystem and finds
> that there's obvious copy overhead in tcmu while doing read 
> operations, so I spent
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
> So my question is that whether we don't allocate internal data pages 
> in tcmu, just make
> sg's pages to be mmaped in data area, so we can reduce one extra copy, 
> which I think
> it can improve throughput. Or is there any special security issues 
> that we can not do
> this way? Thanks.
>
Yeah, this is a good start to improve this. Currently the tcmu-runner 
could benifit from the mapped temporary data pages and won't do the 
extra copy in userspace.

I think you can do the dynamic map/unmap for the data pages for each 
SCSI cmd in the LIO's ringbuffer, but this should be opaque to the user 
space daemons. And at the same time the LIO needs to tell tcmu-runner 
the offset from/to where should it read/write the data contents in the 
mapped ringbuffer via each tcmu cmd entry. Currently the tcmu cmd entry 
will be followed by its data contents.

But I didn't investigate whether could we make the sg's pages, not sure 
whether will they have any limitation to do this.


BRs

Xiubo



>
> Regards,
> Xiaoguang Wang
>

