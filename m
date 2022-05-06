Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A61C433EF
	for <target-devel@archiver.kernel.org>; Fri,  6 May 2022 08:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390266AbiEFIuy (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 6 May 2022 04:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiEFIuy (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 6 May 2022 04:50:54 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC995711F
        for <target-devel@vger.kernel.org>; Fri,  6 May 2022 01:47:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VCR6IuL_1651826828;
Received: from 30.82.254.105(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VCR6IuL_1651826828)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 16:47:09 +0800
Message-ID: <c7ca157c-fa58-a1cc-9cd6-c8117f74e26f@linux.alibaba.com>
Date:   Fri, 6 May 2022 16:47:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     target-devel@vger.kernel.org
References: <YnKX+i4XeOJV1njK@kili>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <YnKX+i4XeOJV1njK@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

hi,

Sorry for late response, I missed this mail.
Thanks for this report.

Regards,
Xiaoguang Wang
> Hello Xiaoguang Wang,
>
> The patch bb9b9eb0ae2e: "scsi: target: tcmu: Fix possible data
> corruption" from Apr 21, 2022, leads to the following Smatch static
> checker warning:
>
> 	drivers/target/target_core_user.c:1689 tcmu_blocks_release()
> 	warn: sleeping in atomic context
>
> drivers/target/target_core_user.c
>     1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>     1662                                 unsigned long last)
>     1663 {
>     1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>     1665         struct page *page;
>     1666         u32 pages_freed = 0;
>     1667 
>     1668         xas_lock(&xas);
>                  ^^^^^^^^^^^^^^
> We take a spinlock here.
>
>
>     1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>     1670                 xas_store(&xas, NULL);
>     1671                 /*
>     1672                  * While reaching here there may be page faults occurring on
>     1673                  * the to-be-released pages. A race condition may occur if
>     1674                  * unmap_mapping_range() is called before page faults on these
>     1675                  * pages have completed; a valid but stale map is created.
>     1676                  *
>     1677                  * If another command subsequently runs and needs to extend
>     1678                  * dbi_thresh, it may reuse the slot corresponding to the
>     1679                  * previous page in data_bitmap. Though we will allocate a new
>     1680                  * page for the slot in data_area, no page fault will happen
>     1681                  * because we have a valid map. Therefore the command's data
>     1682                  * will be lost.
>     1683                  *
>     1684                  * We lock and unlock pages that are to be released to ensure
>     1685                  * all page faults have completed. This way
>     1686                  * unmap_mapping_range() can ensure stale maps are cleanly
>     1687                  * removed.
>     1688                  */
> --> 1689                 lock_page(page);
>                          ^^^^^^^^^^^^^^^
> The lock_page() function calls might_sleep() (inside the declaration
> block).
>
>     1690                 unlock_page(page);
>     1691                 __free_page(page);
>     1692                 pages_freed++;
>     1693         }
>     1694         xas_unlock(&xas);
>                  ^^^^^^^^^^^^^^^^^
> Unlock
>
>     1695 
>     1696         atomic_sub(pages_freed, &global_page_count);
>     1697 
>     1698         return pages_freed;
>     1699 }
>
> regards,
> dan carpenter

