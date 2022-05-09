Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C33C433F5
	for <target-devel@archiver.kernel.org>; Mon,  9 May 2022 18:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiEISc4 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 9 May 2022 14:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiEIScx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 9 May 2022 14:32:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD324B584
        for <target-devel@vger.kernel.org>; Mon,  9 May 2022 11:28:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y21so17310827edo.2
        for <target-devel@vger.kernel.org>; Mon, 09 May 2022 11:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BL1QH7SI7hwn5CQdv0wC4nQf4yQFRUMH4y9dGRMoCDk=;
        b=e77P2YpGSpfPFonemJfArGiWussMR5+vb6jFvmqIgin+JraPOz1lTh1eqV/v/D1Ak9
         /NoSuCHxc1Ecxurex3QtuBoW2bN4E5G7LubccPjkJriHjOk+CmxvC1kdivknDB0gn9gG
         ogcJVrx+SHpZBoCTu1ZL97kdyLR+Gf1GB8momQDijUW/ZQ7DkK90JruO1huTkbqASaKU
         6/x8u4s+KVJWgUXzoGAfAWGStHls+SIgnSE2cXuks28/VKyyVSJ5WFP3HiF+mlW0aUgm
         4KCTL9XMd+09QuD/LeG49gOugTEZm6Sb9lBGUW88XExPbdWRbfjgF+SIypzJtlaVmolG
         oOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BL1QH7SI7hwn5CQdv0wC4nQf4yQFRUMH4y9dGRMoCDk=;
        b=VpSCrJ9dx3I95qsSB8gNMJ7RKT8n1oU3Ad8qeemtlvI/eNWZenUU+ynUs7O/C4K448
         l2NMY2rY3Y16IznSh8i5wWHbZsyfqRmIcyhO8T3MTDHmK3aWtFXChRZU1ItRCQLFOH1b
         Vs4wcBj6pCndPc5rFLTk/H+IzGkOS2v3ep81YszG2RewEMKBM0oLO/NDqsuNzs9P0C1z
         nPjs2z8GxKeHH13lKBn+dv0Ro1s9hzipQmmF38Se6aA5JSe2K503V7DuGhOoNlFbOw15
         Ag6LZRayJUT3rP8GVa2aitYtuHV9E46pTnT3yiBc3rze4BZKwsWaFqwYfnJ60VALPBbA
         AopQ==
X-Gm-Message-State: AOAM530J91yfwssaBDV/n56DQbkaTWA2qkdyudDeFTUphjeBtNewEwCI
        +OfZjrRlbX2bTBn/Tbeu/9k=
X-Google-Smtp-Source: ABdhPJw6gvjbE2gbbZSmYq9I3tuseRsLBICZaehWKA7FP3VYV4LR+ZvyPY4PXJhM+KhAyfTJgU2znA==
X-Received: by 2002:a05:6402:520c:b0:428:25e3:a1e4 with SMTP id s12-20020a056402520c00b0042825e3a1e4mr18357299edd.198.1652120935943;
        Mon, 09 May 2022 11:28:55 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id qs24-20020a170906459800b006f3ef214e1bsm5239668ejc.129.2022.05.09.11.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 11:28:55 -0700 (PDT)
Message-ID: <1a0ebda5-bc96-1f29-9611-91bce407d7eb@gmail.com>
Date:   Mon, 9 May 2022 20:28:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        xiaoguang.wang@linux.alibaba.com
Cc:     target-devel@vger.kernel.org
References: <YnKX+i4XeOJV1njK@kili>
 <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
 <20220509060545.GI4031@kadam>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220509060545.GI4031@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

To be honest, tcmu_blocks_release is not relevant for tcmu performance.
Therefore I think we should try to keep the code simple and easy to
understand.

So, it probably is the simplest and also best solution to switch to
xarray normal API. That would make tcmu_blocks_release look like
the following (untested) code:

static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
                                unsigned long last)
{
	struct page *page;
	unsigned long dpi;
	u32 pages_freed = 0;

	first = first * udev->data_pages_per_blk;
	last = (last + 1) * udev->data_pages_per_blk - 1;
	xa_for_each_range(&udev->data_pages, dpi, page, first, last) {
		xa_erase(&udev->data_pages, dpi);
		lock_page(page);
		unlock_page(page);
		__free_page(page);
		pages_freed++;
	}

	atomic_sub(pages_freed, &global_page_count);

	return pages_freed;
}

Regards,
Bodo


On 09.05.22 08:05, Dan Carpenter wrote:
>> If there is no other way to avoid the Smatch warning,
> 
> The Smatch warning is not the issue.  If we're holding a spinlock and
> we call might_sleep() then that generates a stack trace at runtime if
> you have CONFIG_DEBUG_ATOMIC_SLEEP enabled.  Probably enabling
> CONFIG_DEBUG_ATOMIC_SLEEP should just be a standard part of the QC
> process.
> 
> Anyway, it sounds you're just doing the locking to silence a warning in
> xarray.  Let's ask Matthew if he has a hint.
> 
> regards,
> dan carpenter
> 
> On Sun, May 08, 2022 at 08:03:14PM +0200, Bodo Stroesser wrote:
>> Hi Dan,
>>
>> Thank you for the report.
>>
>> I'm quite sure that our code does not cause any problems, because
>> in tcmu we explicitly or implicitly take the xarray's lock only while
>> holding the so called cmdr_lock mutex. Also, we take the lock without
>> disabling irq or bh. So I think there is no problem if lock_page sleeps
>> while we hold the xarray's lock.
>>
>> Of course, we wouldn't need the xarray lock at all, but xarray code
>> forces us to take it to avoid warnings.
>>
>> In tcmu_blocks_release we use the advanced xarray API to keep the
>> overhead small. It allows us to lock/unlock before and after the loop
>> only. If there is no other way to avoid the Smatch warning, we could
>> easily put additional xas_unlock() and xas_lock() around the
>> lock_page/unlock_page block.
>>
>> But if there is a way to avoid the warning without imposing overhead,
>> I would of course prefer it.
>>
>> Regards,
>> Bodo
>>
>>
>> On 04.05.22 17:12, Dan Carpenter wrote:
>>> Hello Xiaoguang Wang,
>>>
>>> The patch bb9b9eb0ae2e: "scsi: target: tcmu: Fix possible data
>>> corruption" from Apr 21, 2022, leads to the following Smatch static
>>> checker warning:
>>>
>>> 	drivers/target/target_core_user.c:1689 tcmu_blocks_release()
>>> 	warn: sleeping in atomic context
>>>
>>> drivers/target/target_core_user.c
>>>       1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>>>       1662                                 unsigned long last)
>>>       1663 {
>>>       1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>>>       1665         struct page *page;
>>>       1666         u32 pages_freed = 0;
>>>       1667
>>>       1668         xas_lock(&xas);
>>>                    ^^^^^^^^^^^^^^
>>> We take a spinlock here.
>>>
>>>
>>>       1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>>>       1670                 xas_store(&xas, NULL);
>>>       1671                 /*
>>>       1672                  * While reaching here there may be page faults occurring on
>>>       1673                  * the to-be-released pages. A race condition may occur if
>>>       1674                  * unmap_mapping_range() is called before page faults on these
>>>       1675                  * pages have completed; a valid but stale map is created.
>>>       1676                  *
>>>       1677                  * If another command subsequently runs and needs to extend
>>>       1678                  * dbi_thresh, it may reuse the slot corresponding to the
>>>       1679                  * previous page in data_bitmap. Though we will allocate a new
>>>       1680                  * page for the slot in data_area, no page fault will happen
>>>       1681                  * because we have a valid map. Therefore the command's data
>>>       1682                  * will be lost.
>>>       1683                  *
>>>       1684                  * We lock and unlock pages that are to be released to ensure
>>>       1685                  * all page faults have completed. This way
>>>       1686                  * unmap_mapping_range() can ensure stale maps are cleanly
>>>       1687                  * removed.
>>>       1688                  */
>>> --> 1689                 lock_page(page);
>>>                            ^^^^^^^^^^^^^^^
>>> The lock_page() function calls might_sleep() (inside the declaration
>>> block).
>>>
>>>       1690                 unlock_page(page);
>>>       1691                 __free_page(page);
>>>       1692                 pages_freed++;
>>>       1693         }
>>>       1694         xas_unlock(&xas);
>>>                    ^^^^^^^^^^^^^^^^^
>>> Unlock
>>>
>>>       1695
>>>       1696         atomic_sub(pages_freed, &global_page_count);
>>>       1697
>>>       1698         return pages_freed;
>>>       1699 }
>>>
>>> regards,
>>> dan carpenter
