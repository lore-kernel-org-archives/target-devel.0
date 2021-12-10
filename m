Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A986CC433EF
	for <target-devel@archiver.kernel.org>; Fri, 10 Dec 2021 06:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhLJGqD (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 01:46:03 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:53514 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237048AbhLJGqD (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 01:46:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V-8.py1_1639118546;
Received: from 30.225.28.139(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V-8.py1_1639118546)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 14:42:27 +0800
Message-ID: <8022a6eb-344e-e121-2486-ddffb8e4d33a@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 14:42:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: tcmu data area double copy overhead
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
 <69dbd44d-d1ae-38a7-6617-617571796115@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <69dbd44d-d1ae-38a7-6617-617571796115@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

hi,

> On 08.12.21 13:43, Xiaoguang Wang wrote:
>> hi，
>>
>> I'm a newcomer to tcmu or iscsi subsystem, and have spent several 
>> days to learn
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
>> data pages, then user-space backstore moves mmaped data area for 
>> these data pages
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
>> sg's pages to be mmaped in data area, so we can reduce one extra 
>> copy, which I think
>> it can improve throughput. Or is there any special security issues 
>> that we can not do
>> this way? Thanks.
>
> You are right, tcmu currently copies data between the sg-pages and tcmu
> data pages.
>
> But I'm not sure the solution you suggest would really show the improved
> throughput you expect, because we would have to map all data pages of the
> sgl(s) of a new cmd into user space and unmap them again when the cmd is
> processed.
>
> To map one page means, that we store the struct page pointer in tcmu's
> data (xarray). If userspace tries to read or write that page, a page 
> fault
> will occur and kernel will call tcmu_vma_fault which returns the page
> pointer. To unmap means that tcmu has remove the page pointer and to call
> unmap_mapping_range. So I'm not sure that copying content of one page is
> more expensive than mapping and unmapping one page.
OK, I see, thanks for your detailed explanations.

>
> Additionally, if tcmu would map the sg-pages, it would have to unmap the
> pages immediately when userspace completes the cmd, because tcmu is not
> the owner of the pages. So the recently added feature "KEEP_BUF" would
> have to be removed again. But that feature was added to avoid the need 
> for
> data copy in userspace in some situations.
>
> Finally, if tcmu times out a cmd that is waiting on the ring for
> completion from userspace, tcmu sends cmd completion to tcm core. Before
> doing so, it would have to unmap the sg-pages. If userspace later 
> tries to
> access one of these pages, tcmu_vma_fault has nothing to map, instead
> returns VM_FAULT_SIGBUS and userspace receives SIGBUS.
OK, I see.

>
> I already started another attempt to avoid data copy in tcmu. The idea
> is to optionally allow backend drivers to have callbacks for sg 
> allocation
> and free. That way the pages in a sg allocated by tcm core can be pages
> from tcmu's data area. Thus, no map/unmap is needed and the fabric driver
> directly writes/reads data to/from those pages visible to userspace.
Yeah, if we can eliminate the map/unmap operation and make userpace
backstore operates sg pages directly, tcmu can give much higher throughput.

Regards,
Xiaoguang Wang

>
> In a high performance scenario the method already lowers cpu load and
> enhances throughput very well with qla2xxx fabric. Unfortunately that
> patchset works only for fabrics using target_submit_cmd or calling
> target_submit_prep without allocated sgls, which iscsi does not :(
>
> Currently I'm working on another tuning measure in tcmu. After that I'll
> go back to my no-data-copy patches. Maybe I can make them work with most
> fabric drivers including iscsi.
>
> Regards,
> Bodo

