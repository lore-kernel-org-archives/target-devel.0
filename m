Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60E7C433F5
	for <target-devel@archiver.kernel.org>; Mon,  9 May 2022 19:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbiEIT0s (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 9 May 2022 15:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240526AbiEIT0q (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 9 May 2022 15:26:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C3C2D76D8
        for <target-devel@vger.kernel.org>; Mon,  9 May 2022 12:22:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gh6so28791798ejb.0
        for <target-devel@vger.kernel.org>; Mon, 09 May 2022 12:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qRhnT7+plGeXlqYLVaVOAQlYEThzprHF5L8jC0/ULwc=;
        b=aSBYiALFoaXRaudqbLiGYTfXq7fwJxE1ltpGfteHJ/J/ec67yB7PHGEI8eGpp+pHEH
         Ru0Uf+QfOEz/T09YOQ+luogUBUZS/PTD1jYKPQcaRrnVbxIEOIKpyvItSIFWtzp1LClq
         Eu3UtXEYlOb/Y2z1mhqKoGqPaPQejSNpiawjpAsbHAfgfKJUZPOYc9vewhZBpC6jLJwn
         ujighEuMYwlVpyvHcFUlII/yH7SH5uLq0uT78e7IjlWmhloCvYi12xk6FjGVJqJekWNH
         0cEloFYhvKz+OpvsbTBw2RzEDynbE9HT0dNo4hRAMv91qmLCHC5AqO+AtKnGXZvkas+M
         OWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qRhnT7+plGeXlqYLVaVOAQlYEThzprHF5L8jC0/ULwc=;
        b=D7oo7h5Yd60JINH008gmbkgI2qt5Ex3fMnfpuISLfAkgW2RjqykdQeSxh02ysUbggi
         Bg2fEwR42SPmRsCvr9teiUICqHXUYsZVtFM+2eBjMARD+rjIlu5nCuZ5JgB1/OZM0Bv5
         xQbQMEyER4I8kh92ampwQCjhjEXecQ/+y6YMe8j4BqvSjOz2ZF6IcqJRXzEqkIh1I/dP
         A7aXIrCqVPGAEJCmHb+UxR81lP+cs4bpdMLwi4yOCCL2QfFY/v3MfXaOO1tOzJKT/q9W
         YY4+zcUHuHYTZfqNlmhSLBzUdg2OKrve7Si5fVAYDoKtOvQlii981+Te/uRDsC1cjxFL
         YxpA==
X-Gm-Message-State: AOAM533qQpDeDCg8/emsGKAUpS+9/x9okkCQW4DSr8fUgQ10CStvs/E9
        FugC+9eVJLgGtJDIl2tyYxM=
X-Google-Smtp-Source: ABdhPJziF4C3viEy0o80KYb0AUNetf4iIuXDFZK1jn+8RD04yeBo7YYhIl66tuI6nseYtBNruj1/9Q==
X-Received: by 2002:a17:906:7751:b0:6ce:e3c:81a6 with SMTP id o17-20020a170906775100b006ce0e3c81a6mr15368832ejn.278.1652124168721;
        Mon, 09 May 2022 12:22:48 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090651cc00b006f3ef214e41sm3403868ejk.167.2022.05.09.12.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 12:22:48 -0700 (PDT)
Message-ID: <6aad6f3e-4aed-8308-bf7e-c660c9d8d854@gmail.com>
Date:   Mon, 9 May 2022 21:22:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     xiaoguang.wang@linux.alibaba.com, target-devel@vger.kernel.org
References: <YnKX+i4XeOJV1njK@kili>
 <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
 <20220509060545.GI4031@kadam> <YnlZcUTU2SzYi5/N@casper.infradead.org>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <YnlZcUTU2SzYi5/N@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 09.05.22 20:12, Matthew Wilcox wrote:
> On Mon, May 09, 2022 at 09:05:45AM +0300, Dan Carpenter wrote:
>>> If there is no other way to avoid the Smatch warning,
>>
>> The Smatch warning is not the issue.  If we're holding a spinlock and
>> we call might_sleep() then that generates a stack trace at runtime if
>> you have CONFIG_DEBUG_ATOMIC_SLEEP enabled.  Probably enabling
>> CONFIG_DEBUG_ATOMIC_SLEEP should just be a standard part of the QC
>> process.
>>
>> Anyway, it sounds you're just doing the locking to silence a warning in
>> xarray.  Let's ask Matthew if he has a hint.
> 
> I suspect that the tcmu code is doing something horrible & wrong again.
> It keeps poking at VM internals without understanding of what's going
> on or why.  Anyway ...

If we really are doing something wrong, the long comment in the new
code in tcmu_blocks_release probably is wrong. Can you please give us
a hint what our misunderstanding is?

> 
>> On Sun, May 08, 2022 at 08:03:14PM +0200, Bodo Stroesser wrote:
>>> I'm quite sure that our code does not cause any problems, because
>>> in tcmu we explicitly or implicitly take the xarray's lock only while
>>> holding the so called cmdr_lock mutex. Also, we take the lock without
>>> disabling irq or bh. So I think there is no problem if lock_page sleeps
>>> while we hold the xarray's lock.
>>>
>>> Of course, we wouldn't need the xarray lock at all, but xarray code
>>> forces us to take it to avoid warnings.
> 
> You mean "The XArray warns us when we break its locking rules".
> 

Yes.
The point is, that tcmu does not use spin_locks, but mutex. So we
unfortunately cannot use the XArray lock alone, but always have to take
tcmu's mutex and while holding it, we additionally (implicitly or
explicitly) take XArray's lock.

>>> In tcmu_blocks_release we use the advanced xarray API to keep the
>>> overhead small. It allows us to lock/unlock before and after the loop
>>> only. If there is no other way to avoid the Smatch warning, we could
>>> easily put additional xas_unlock() and xas_lock() around the
>>> lock_page/unlock_page block.
> 
> ... then you'd have to call xas_reset(), and you might as well use
> xa_for_each().

Yes.
I wrote a mail few minutes ago that we should switch to
xa_for_each_range().

> 
>>>>       1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>>>>       1662                                 unsigned long last)
>>>>       1663 {
>>>>       1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>>>>       1665         struct page *page;
>>>>       1666         u32 pages_freed = 0;
>>>>       1667
>>>>       1668         xas_lock(&xas);
>>>>                    ^^^^^^^^^^^^^^
>>>> We take a spinlock here.
>>>>
>>>>
>>>>       1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>>>>       1670                 xas_store(&xas, NULL);
>>>>       1671                 /*
>>>>       1672                  * While reaching here there may be page faults occurring on
>>>>       1673                  * the to-be-released pages. A race condition may occur if
>>>>       1674                  * unmap_mapping_range() is called before page faults on these
>>>>       1675                  * pages have completed; a valid but stale map is created.
>>>>       1676                  *
>>>>       1677                  * If another command subsequently runs and needs to extend
>>>>       1678                  * dbi_thresh, it may reuse the slot corresponding to the
>>>>       1679                  * previous page in data_bitmap. Though we will allocate a new
>>>>       1680                  * page for the slot in data_area, no page fault will happen
>>>>       1681                  * because we have a valid map. Therefore the command's data
>>>>       1682                  * will be lost.
>>>>       1683                  *
>>>>       1684                  * We lock and unlock pages that are to be released to ensure
>>>>       1685                  * all page faults have completed. This way
>>>>       1686                  * unmap_mapping_range() can ensure stale maps are cleanly
>>>>       1687                  * removed.
>>>>       1688                  */
>>>> --> 1689                 lock_page(page);
>>>>                            ^^^^^^^^^^^^^^^
>>>> The lock_page() function calls might_sleep() (inside the declaration
>>>> block).
>>>>
>>>>       1690                 unlock_page(page);
>>>>       1691                 __free_page(page);
>>>>       1692                 pages_freed++;
>>>>       1693         }
>>>>       1694         xas_unlock(&xas);
> 
> There are a number of things you can do.  One is to remove pages into
> a pagevec until it is full, then xas_unlock(); xas_reset(); lock and
> unlock each page and pass the pagevec to __pagevec_release().  Then
> xas_lock() and continue the loop.
> 
> Another possibility is to trylock each page; if it fails, put it into
> the pagevec (and do the above dance if the pagevec is now full), but
> if it succeeds, you can now unlock it and __free_page().

Thank you for that hint.
The probability, that trylock_page fails is _very_ low. In future we
might call tcmu_blocks_release more often. Then we can speed it up
again by using the method you described, even without a need for
batching.

> 
> The key to going fast is batching.  And that goes for __free_page()
> vs __pagevec_release() as much as for walking the XArray.
