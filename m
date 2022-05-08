Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58D8C433F5
	for <target-devel@archiver.kernel.org>; Sun,  8 May 2022 19:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiEHTRa (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 8 May 2022 15:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiEHSHI (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 8 May 2022 14:07:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4F3AE6F
        for <target-devel@vger.kernel.org>; Sun,  8 May 2022 11:03:17 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ba17so13910682edb.5
        for <target-devel@vger.kernel.org>; Sun, 08 May 2022 11:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Bu+4u3eJ+kcWWQWi+uMIPIyziTNFNSNLgnhS5bIv3ho=;
        b=DBjGygyVrgt+LIajRbxE51/NTKLv8KmlAJDPbzgUzgO/FNxk+YuGPIlb+0MPp1y/JR
         rOYrg+buTM8pHgiUYvehfc5xjuYJiy5C6/P5kWXvtcQy90IyiOe4uEfae/IjsXYjOtag
         1R2LT3nq8rXeDQhySF7HgFnT3++FQ1cfreeepl6Fgt1/vhD0jnliyiqOiYAHT2fbcKHj
         yipkMdeojXLv+6cqojVbUFtQt86U15/cGhF3IhHysN2RPA0a5BlAxPvVtQBDuKFy1KFW
         cUY3uqBioZHOybSOjs87fT2EMi8X2q0dclRIPtJXFKtnN0AUHl7UR3kEaxfhiVwvE30/
         3upg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bu+4u3eJ+kcWWQWi+uMIPIyziTNFNSNLgnhS5bIv3ho=;
        b=SH03iqbQ1Su8pTMicqlaWA/GtCvOQUBzHfxrqKXDUiee0ycMNMKR4/fe/YKKEKz7v4
         gNJfqXC8cg4ueiOVrT/qvrLXeS7hQB11WbMxjFPT6+O5uzANxBCEi7knmc9hHYUTiAlA
         sMWMNWsvngHkelby1mChk1+BInzW7NXH46ONm8Yjh2LwOqRwiy7wuGDYBNLNSjwYhmgQ
         EyJfT05OIucw+rUCYIPENf53/K2bqp8jxhgOefNmAi+UjQl4273NYJr7piHWSHBdh+87
         +i+gJ2NlRc5Z9nItqr/BWxFSCnujhsfM6cUuPmd/HHBcLJp4C0Cf4qJTpHOA7Bnu4Kzd
         +KKg==
X-Gm-Message-State: AOAM533GuC26cPfc7uAYSPyixvPoXmEgM/+bjovaELIkiU0hG04InpwZ
        QOHKl03dh5zurfYk9NSthfMuq8l0byo=
X-Google-Smtp-Source: ABdhPJycQnYUeCohSKJW6EorF8yDwWxhopm62H4W2xTiW/gBFgP3sgIZt+7Re7xpCutcg8C6TH+rPg==
X-Received: by 2002:a05:6402:1d51:b0:41f:cf6c:35a5 with SMTP id dz17-20020a0564021d5100b0041fcf6c35a5mr13942974edb.25.1652032995976;
        Sun, 08 May 2022 11:03:15 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id w6-20020aa7dcc6000000b0042617ba63d7sm5106900edu.97.2022.05.08.11.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 11:03:15 -0700 (PDT)
Message-ID: <748a23d4-6036-c62d-8e1f-4856d6c75439@gmail.com>
Date:   Sun, 8 May 2022 20:03:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [bug report] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        xiaoguang.wang@linux.alibaba.com
Cc:     target-devel@vger.kernel.org
References: <YnKX+i4XeOJV1njK@kili>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <YnKX+i4XeOJV1njK@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Dan,

Thank you for the report.

I'm quite sure that our code does not cause any problems, because
in tcmu we explicitly or implicitly take the xarray's lock only while
holding the so called cmdr_lock mutex. Also, we take the lock without
disabling irq or bh. So I think there is no problem if lock_page sleeps
while we hold the xarray's lock.

Of course, we wouldn't need the xarray lock at all, but xarray code
forces us to take it to avoid warnings.

In tcmu_blocks_release we use the advanced xarray API to keep the
overhead small. It allows us to lock/unlock before and after the loop
only. If there is no other way to avoid the Smatch warning, we could
easily put additional xas_unlock() and xas_lock() around the
lock_page/unlock_page block.

But if there is a way to avoid the warning without imposing overhead,
I would of course prefer it.

Regards,
Bodo


On 04.05.22 17:12, Dan Carpenter wrote:
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
>      1661 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>      1662                                 unsigned long last)
>      1663 {
>      1664         XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
>      1665         struct page *page;
>      1666         u32 pages_freed = 0;
>      1667
>      1668         xas_lock(&xas);
>                   ^^^^^^^^^^^^^^
> We take a spinlock here.
> 
> 
>      1669         xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>      1670                 xas_store(&xas, NULL);
>      1671                 /*
>      1672                  * While reaching here there may be page faults occurring on
>      1673                  * the to-be-released pages. A race condition may occur if
>      1674                  * unmap_mapping_range() is called before page faults on these
>      1675                  * pages have completed; a valid but stale map is created.
>      1676                  *
>      1677                  * If another command subsequently runs and needs to extend
>      1678                  * dbi_thresh, it may reuse the slot corresponding to the
>      1679                  * previous page in data_bitmap. Though we will allocate a new
>      1680                  * page for the slot in data_area, no page fault will happen
>      1681                  * because we have a valid map. Therefore the command's data
>      1682                  * will be lost.
>      1683                  *
>      1684                  * We lock and unlock pages that are to be released to ensure
>      1685                  * all page faults have completed. This way
>      1686                  * unmap_mapping_range() can ensure stale maps are cleanly
>      1687                  * removed.
>      1688                  */
> --> 1689                 lock_page(page);
>                           ^^^^^^^^^^^^^^^
> The lock_page() function calls might_sleep() (inside the declaration
> block).
> 
>      1690                 unlock_page(page);
>      1691                 __free_page(page);
>      1692                 pages_freed++;
>      1693         }
>      1694         xas_unlock(&xas);
>                   ^^^^^^^^^^^^^^^^^
> Unlock
> 
>      1695
>      1696         atomic_sub(pages_freed, &global_page_count);
>      1697
>      1698         return pages_freed;
>      1699 }
> 
> regards,
> dan carpenter
