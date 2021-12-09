Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5837CC433F5
	for <target-devel@archiver.kernel.org>; Thu,  9 Dec 2021 19:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhLITXm (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 14:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhLITXb (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 14:23:31 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A636C0698DE
        for <target-devel@vger.kernel.org>; Thu,  9 Dec 2021 11:19:54 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso7345062wms.3
        for <target-devel@vger.kernel.org>; Thu, 09 Dec 2021 11:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kckblDJpb5KwXZDLX97K1YU3lAVjYSpMjovZnq/4F8M=;
        b=ONOEfWQlK1tpvf0N9qyXOyggMH3kfNLe0zG/mfK6yCopbXa8qKk//FF7jxgfUbqLrz
         v/IEqhw290z7BgPnlLrQsOj92zdNDL+8fKWDfxjlvVymjJUHVEWDSdjlvrWI1pCbO7CN
         IxQq+MisIiUz/UYNtSOvJhYLB48QJO5OIn5FSVGNm6c1R4UVy89XVn8CGigNPaC/17te
         yuFwUdog8nmG74NJSV6tKXQ1yCuGEodEKWBG04JliR645f2hMdNUjiXRbyvY5BNaHNUq
         48XGjPb4ZY0jz+0s8rAka6gDCcFzNBzEZv0NzK8Cj+IFxBYn/5tdHi1O0ydvb+wgh6CF
         ckvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kckblDJpb5KwXZDLX97K1YU3lAVjYSpMjovZnq/4F8M=;
        b=JdYFCBxjoqfSDuHDeC8+zsjIoEyZeD6+s82LDpnbo9Jt9xDqDzIRAqREUnwQ9X83/Q
         d8b4PA4lvTGUjUlrYGKi7HMj3MQPNSVsnqzn4WspLujujjMl4Hq5pxpzGDOrZzJvQKf7
         1qXDe3R+H+tW7C6hkMi4WzBYo6852/DwOVA8p/QojPcZ1G9X/mZsrxHi6uMA4UroBryM
         l+U2oygPV3j6DWX6dtoD0RYIpRJhzz710rgVJBQeLHs60sIfYyVAroLleGjx28KPnS6j
         DqJXmaI2qrja7SF7nuhvTTSJBSF04rMIRHTZYfXIT0n0hBbkaUuewxfxxMzDQZ8Agqky
         77nw==
X-Gm-Message-State: AOAM531QGQL/P11wiSTy5mpmmiKR/pj37XceMAcBQ2uRZlhjSqUVLLP9
        jbyxyKxa2WhMUneZpghf3U0DtkprpNQ=
X-Google-Smtp-Source: ABdhPJyr4bpHfS8JDjqW+lyyI5V3tgH3V7PJ/7F+IuFNgYitJBEmOwCx1Cy1Mv96ME2HmDdoaHvN3g==
X-Received: by 2002:a1c:4d3:: with SMTP id 202mr9748358wme.174.1639077593178;
        Thu, 09 Dec 2021 11:19:53 -0800 (PST)
Received: from [192.168.178.40] (ipbcc08d44.dynamic.kabel-deutschland.de. [188.192.141.68])
        by smtp.gmail.com with ESMTPSA id bg34sm10216143wmb.47.2021.12.09.11.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 11:19:52 -0800 (PST)
Subject: Re: tcmu data area double copy overhead
To:     Xiubo Li <xiubli@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
 <5428b65d-07d7-bb61-0409-b57955b89395@redhat.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <a8d219ef-857a-ec86-8424-9653647f64c8@gmail.com>
Date:   Thu, 9 Dec 2021 20:19:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5428b65d-07d7-bb61-0409-b57955b89395@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 08.12.21 14:32, Xiubo Li wrote:
> 
> On 12/8/21 8:43 PM, Xiaoguang Wang wrote:
>> hi，
>>
>> I'm a newcomer to tcmu or iscsi subsystem, and have spent several days 
>> to learn
>> iSCSI and tcmu, so if my question looks fool, forgive me :)
>>
>> One of our customers is using tcmu to visit remote distributed 
>> filesystem and finds
>> that there's obvious copy overhead in tcmu while doing read 
>> operations, so I spent
>> time to find the reason and see whether can optimize a bit. Now 
>> according to my
>> understanding about tcmu kernel codes, tcmu allocates internal data 
>> pages for data
>> area, use these data pages as temporary storage between user-space 
>> backstore and
>> tcmu. For iSCSI initiator's write request, tcmu first copy sg page's 
>> content to internal
>> data pages, then user-space backstore moves mmaped data area for these 
>> data pages
>> to backstore; for iSCSI initiator's read request, tcmu also allocates 
>> internal data pages,
>> backstore copies distributed filesystem's data to these data pages, 
>> later tcmu copy
>> data pages' content to sg's pages. That means for both read and write 
>> requests, it
>> exists one extra data copy.
>>
>> So my question is that whether we don't allocate internal data pages 
>> in tcmu, just make
>> sg's pages to be mmaped in data area, so we can reduce one extra copy, 
>> which I think
>> it can improve throughput. Or is there any special security issues 
>> that we can not do
>> this way? Thanks.
>>
> Yeah, this is a good start to improve this. Currently the tcmu-runner 
> could benifit from the mapped temporary data pages and won't do the 
> extra copy in userspace.

I think the idea is to avoid data copy in tcmu, not userspace.
What extra copy in userspace are you talking about?

> 
> I think you can do the dynamic map/unmap for the data pages for each 
> SCSI cmd in the LIO's ringbuffer, but this should be opaque to the user 
> space daemons. And at the same time the LIO needs to tell tcmu-runner 
> the offset from/to where should it read/write the data contents in the 
> mapped ringbuffer via each tcmu cmd entry. Currently the tcmu cmd entry 
> will be followed by its data contents.

Unfortunately that's not true. tcmu does not store data in the cmd ring.
Data area is behind the cmd ring in tcmu's uio dev mapping.
So cmd entry in cmd ring already contains an array of struct iovec to
specify the pieces of the data area used for the cmd's in or out data.

> 
> But I didn't investigate whether could we make the sg's pages, not sure 
> whether will they have any limitation to do this.
> 
> 
> BRs
> 
> Xiubo
> 
> 
> 
>>
>> Regards,
>> Xiaoguang Wang
>>
> 
