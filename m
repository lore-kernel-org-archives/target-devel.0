Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5462EC4332F
	for <target-devel@archiver.kernel.org>; Thu, 10 Mar 2022 14:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244277AbiCJOzp (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 09:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347932AbiCJOvc (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 09:51:32 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D794263C7
        for <target-devel@vger.kernel.org>; Thu, 10 Mar 2022 06:50:16 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V6pOdr6_1646923813;
Received: from 30.225.28.175(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V6pOdr6_1646923813)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Mar 2022 22:50:14 +0800
Message-ID: <5c41b6b3-754e-4142-24ba-5ffbe0cd3e2c@linux.alibaba.com>
Date:   Thu, 10 Mar 2022 22:50:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: code question about tcmu_try_get_data_page()
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     target-devel@vger.kernel.org
References: <95823aae-28fd-f078-e358-b02e05f40935@linux.alibaba.com>
 <2a393a83-0337-d9ce-2a32-6a7eff533e5d@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <2a393a83-0337-d9ce-2a32-6a7eff533e5d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

hi Bodo,

> Hi Wang,
>
> Yes, we need the cmdr_lock in tcmu_try_get_data_page.
>
> Reason: if the unmap worker thread gets started and calls
> find_free_blocks, this function - while holding cmdr_lock - per tcmu
> device checks for pages we can release.
> If there are pages to release, it first calls unmap_mapping_range
> to deny the access from userspace to these pages. After that it loops
> over the data_pages xarray to remove the pages from the array and
> free them (tcmu_blocks_release).
>
> If tcmu_try_get_data_page wouldn't lock the cmdr_lock mutex, it
> possibly could run between the call to unmap_mapping_range and
> tcmu_blocks_release removing the page from xarray and freeing it.
> Then we would end up having a freed page mapped to userspace!
Oh, I see now, thanks.

>
> Up to now I didn't check, whether we here have the same possible
> dead lock you described. If so, we probably can solve the problem
> by first removing the pages from xarray, then unmap and finally
> free all pages. If we would do so, I think we would no longer need
> cmdr_lock in tcmu_try_get_data_page.
Agree, I'll take a deeper look at codes.

>
> But: I'm wondering what exactly you are trying to do.
> I assume you want to map the sgl-pages into tcmu data_area just while a
> cmd is in the ring, right?
Yes, I creates a new zero copy data area whose size is also 1GB, and it
has similar bitmap management to original data area, then a command that
is qualified can map this sg pages to this zero copy data area.

> If so, would you do that as a new option, or would you do that
> generally?
I'd like to add a size config item, only se_cmd->data_length is greater than
this size config item, can this command enters zero copy path. Indeed, in
order to be simple(I don't have well knowledge about scsi yet), I use bellow
cod logic in queue_cmd_ring():
     zero_copy = false;
     if (!(se_cmd->se_cmd_flags & SCF_BIDI) && se_cmd->data_length &&
             IS_ALIGNED(se_cmd->data_length, PAGE_SIZE)) {
                 struct scatterlist *data_sg = se_cmd->t_data_sg, *sg;
                 unsigned int data_nents = se_cmd->t_data_nents;
                 int i;

                 for_each_sg(data_sg, sg, data_nents, i) {
                         if (!((!sg->offset || IS_ALIGNED(sg->offset, 
PAGE_SIZE)) &&
                             IS_ALIGNED(sg->length, PAGE_SIZE)))
                                 break;
                 }
                 if (i == data_nents)
                         zero_copy = true;
         }

> I'm asking because AFAICS there are at least these problems when mapping
> sgls:
> - if a command in the cmd ring times out, tcmu sends cmd completion
>   to target core. That means, you have to unmap the sgl pages.
>   But userspace does not know about that. So it still is allowed to
>   access the data space described by cmd's iovecs --> SIGBUS
Yeah, I know, you explained it to me in previous mail, really thanks for 
your
  time: https://www.spinics.net/lists/target-devel/msg21124.html

Current this is the issue I don't know how to handle gracefully, for current
implementation, I just unmap sgl pages in timeout handler... then userpace
maybe killed.

> - if the sgl contains not completely filled pages (probably at least
>   at the end), you might map old kernel data into userspace.
>   So you have to check and write zeros.
Yes, it maybe, so currently I ensure commands whose sgl offset and
length all aligned to page size.

> - AFAICS, there is no guarantee that fabric driver completely fills
>   all pages of the sgl but the least. When mapping directly, that
>   directly translates into iovecs having a length of not a multiple of
>   PAGE_SIZE, not only in the last iovec.
>   I'm not sure all existing userspace SW can handle that correctly.
I'll have a check, thanks.

> - KEEP_BUF feature is based on tcmu owning the buffer in dataspace.
>   So it would no longer work.
Yeah, I have read how KEEP_BUF works, I'd like to disable for KEEP_BUF
for zero copy command, at least for now.

>
> To be honest I'm not sure your changes would make it into tcmu.
Really appreciate for your honest. As for why I still tries to implement a
zero copy for tcmu, there are 2 reasons:
1) I'd like to see real copy overhead compared to mmap/unmap, just curious.

2) Some of our customer need just a simple block semantics device in 
user space,
and in current linux kernel, seems tcmu is the only option.:
     https://lore.kernel.org/all/87bkyyg4jc.fsf@collabora.com/T/
The tcmu double copy in data area really impacts performance, so I spent 
some
time to do this work, and it really improve io throughput  in large io 
cases.

Regards,
Xiaoguang Wang
>
> Bodo
>
>
> On 09.03.22 09:20, Xiaoguang Wang wrote:
>> hi Bodo,
>>
>> I have implemented a zero-copy prototype for tcmu(not sent out yet), 
>> it reallys
>> improves throughput in large io size cases, and I met some code 
>> question that
>> may need you kind help, thanks in advance. In my prototype, I choose to
>> unmap pages in tcmu_irqcontrol():
>> ==> tcmu_irqcontrol, which holds cmdr_lock.
>> ====> tcmu_handle_completions
>> ======> tcmu_handle_completion
>> ========> zap_page_range, which needs to hold mm related lock.
>>
>> But in page fault procedure:
>> ==> tcmu_vma_fault, which I think its caller hold mm related lock.
>> ====> tcmu_try_get_data_page, which tries to hold cmdr_lock.
>>
>> Then dead lock may happens. In tcmu_try_get_data_page(),
>> it mainly acts like below:
>>          mutex_lock(&udev->cmdr_lock);
>>          page = xa_load(&udev->data_pages, dpi);
>>          if (likely(page)) {
>>                  mutex_unlock(&udev->cmdr_lock);
>>                  return page;
>>          }
>>
>>          /*
>>           * Userspace messed up and passed in a address not in the
>>           * data iov passed to it.
>>           */
>>          pr_err("Invalid addr to data page mapping (dpi %u) on device 
>> %s\n",
>>                 dpi, udev->name);
>>          mutex_unlock(&udev->cmdr_lock);
>>
>> I wonder do we really need to hold cmdr_lock here, seems it doesn't
>> protect any real resources. If cmdr_lock here is used to avoid 
>> concurrent
>> xa_erase(), after releasing cmdr_lock, page still can be removed.
>> So my question is that can we safely remove this cmdr_lock here? thanks.
>>
>>
>> Regards,
>> Xiaoguang Wang

