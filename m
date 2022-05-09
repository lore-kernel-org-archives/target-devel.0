Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E69C433EF
	for <target-devel@archiver.kernel.org>; Mon,  9 May 2022 03:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiEIDWx (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 8 May 2022 23:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiEIDRv (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 8 May 2022 23:17:51 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC439135E
        for <target-devel@vger.kernel.org>; Sun,  8 May 2022 20:13:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VCchUAj_1652066029;
Received: from 30.30.115.163(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VCchUAj_1652066029)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 May 2022 11:13:50 +0800
Message-ID: <6bcf7de3-acf8-9c26-b4ca-197480dfd0cb@linux.alibaba.com>
Date:   Mon, 9 May 2022 11:13:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     target-devel@vger.kernel.org
References: <YnKX+i4XeOJV1njK@kili>
 <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

hi,

> Hi Dan,
>
> Thank you for the report.
>
> I'm quite sure that our code does not cause any problems, because
> in tcmu we explicitly or implicitly take the xarray's lock only while
> holding the so called cmdr_lock mutex. Also, we take the lock without
> disabling irq or bh. So I think there is no problem if lock_page sleeps
> while we hold the xarray's lock.
>
> Of course, we wouldn't need the xarray lock at all, but xarray code
> forces us to take it to avoid warnings.
I also see it now, thanks.
Indeed I was going to prepare patch which removes this xarry lock calls.

Regards,
Xiaoguang Wang

>
> In tcmu_blocks_release we use the advanced xarray API to keep the
> overhead small. It allows us to lock/unlock before and after the loop
> only. If there is no other way to avoid the Smatch warning, we could
> easily put additional xas_unlock() and xas_lock() around the
> lock_page/unlock_page block.
>
> But if there is a way to avoid the warning without imposing overhead,
> I would of course prefer it.
>
> Regards,
> Bodo
>
>
> On 04.05.22 17:12, Dan Carpenter wrote:
>> Hello Xiaoguang Wang,
>>
>> The patch bb9b9eb0ae2e: "scsi: target: tcmu: Fix possible data
>> corruption" from Apr 21, 2022, leads to the following Smatch static
>> checker warning:
>>
>>     drivers/target/target_core_user.c:1689 tcmu_blocks_release()
>>     warn: sleeping in atomic context
>>
>> drivers/target/target_core_user.c
>>      1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>>      1662                                 unsigned long last)
>>      1663 {
>>      1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>>      1665         struct page *page;
>>      1666         u32 pages_freed = 0;
>>      1667
>>      1668         xas_lock(&xas);
>>                   ^^^^^^^^^^^^^^
>> We take a spinlock here.
>>
>>
>>      1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>>      1670                 xas_store(&xas, NULL);
>>      1671                 /*
>>      1672                  * While reaching here there may be page faults occurring on
>>      1673                  * the to-be-released pages. A race condition may occur if
>>      1674                  * unmap_mapping_range() is called before page faults on these
>>      1675                  * pages have completed; a valid but stale map is created.
>>      1676                  *
>>      1677                  * If another command subsequently runs and needs to extend
>>      1678                  * dbi_thresh, it may reuse the slot corresponding to the
>>      1679                  * previous page in data_bitmap. Though we will allocate a new
>>      1680                  * page for the slot in data_area, no page fault will happen
>>      1681                  * because we have a valid map. Therefore the command's data
>>      1682                  * will be lost.
>>      1683                  *
>>      1684                  * We lock and unlock pages that are to be released to ensure
>>      1685                  * all page faults have completed. This way
>>      1686                  * unmap_mapping_range() can ensure stale maps are cleanly
>>      1687                  * removed.
>>      1688                  */
>> --> 1689                 lock_page(page);
>>                           ^^^^^^^^^^^^^^^
>> The lock_page() function calls might_sleep() (inside the declaration
>> block).
>>
>>      1690                 unlock_page(page);
>>      1691                 __free_page(page);
>>      1692                 pages_freed++;
>>      1693         }
>>      1694         xas_unlock(&xas);
>>                   ^^^^^^^^^^^^^^^^^
>> Unlock
>>
>>      1695
>>      1696         atomic_sub(pages_freed, &global_page_count);
>>      1697
>>      1698         return pages_freed;
>>      1699 }
>>
>> regards,
>> dan carpenter

