Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F379C433F5
	for <target-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiCJMG7 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiCJMG7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:06:59 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFAC145ADF
        for <target-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:05:58 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bi12so11622117ejb.3
        for <target-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S3He5YNuBzP2ER1ZF40XfHrtQrL0nnc2/QS0Nvbgggk=;
        b=cRLo20qw40v7dpBPb62hRrsZlSuR0TwlfBDQIE+jXciVao+daPHOvOBkfeYEWQCIFc
         cvgtABCJR7iy6KCxOluYxQYOw6xOzmZ9pWBGHijD2J/poZL0IYhg37mICHQv3OpwhMDb
         t1XXIIV+qv+kZL7oOmyAlwAN2zPzZRAJTW9hVnsvenr2hbzucIJnlAbq7W1ac16NL5jM
         OFBY1063TMHDTfDq6mNja7wMakCR+Qz9Bsw9AVyJhfb3hFFylr70/mQ9jnUOZH8hcWE1
         Y/ftjT3MWaCZpfvJ9mDNC9I7t7wc3NYu3r5PJcxivEpsTsxc6GJ+8KD80oJl9ATCQceD
         Y0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S3He5YNuBzP2ER1ZF40XfHrtQrL0nnc2/QS0Nvbgggk=;
        b=7eA5ACvHx1vqk5y+bCQUYZcZJ7r3wF9LshM7deOCJR7diyZ1uFZ+hK5+6LGxJlx3eP
         QdoOcY0OIwtr0sfYTOC02inUDIa1PHUsNzimnyvMLpTGgq1OeEzKsjAcBIrN01eFwcgy
         J94YLvJkybF4NHY68P/6JSR9+8jVp8vJBI9YccK6N/CLd5I+yctQUB7sVQd6DDcrlvzp
         YIWQuj6k74L+RvEDaB21F5saRbAdkc+LvELqMtK4aLD2LQX2Ii0lbF5Xh7cLgdHkV8+m
         /a7K7a9SviNXUWfgUdrT/X/1CfGbj9D3mVIAE+FuivUT5x+0RPUAResjLrHp1sgX/z3X
         f+Pg==
X-Gm-Message-State: AOAM532aC6U6450niDf5FlPCFpPUXoipiKOmqvD3IXwKD8/Rri3wtFxV
        eIp5lCsbl0gqzVgqnglx706M5cWuqQw=
X-Google-Smtp-Source: ABdhPJwgrEYAqkPB1RF8OkOyHnt4p8D8/3rFbbOSadUvIMUDb5ffL9amZ4nEhsglOQ+PFmVON+tTow==
X-Received: by 2002:a17:907:d16:b0:6d6:e3b6:9cd8 with SMTP id gn22-20020a1709070d1600b006d6e3b69cd8mr3968636ejc.94.1646913956838;
        Thu, 10 Mar 2022 04:05:56 -0800 (PST)
Received: from [192.168.178.40] (ipbcc1fa42.dynamic.kabel-deutschland.de. [188.193.250.66])
        by smtp.gmail.com with ESMTPSA id c26-20020aa7d61a000000b00416c75bdd88sm14044edr.56.2022.03.10.04.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 04:05:56 -0800 (PST)
Message-ID: <2a393a83-0337-d9ce-2a32-6a7eff533e5d@gmail.com>
Date:   Thu, 10 Mar 2022 13:05:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: code question about tcmu_try_get_data_page()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     target-devel@vger.kernel.org
References: <95823aae-28fd-f078-e358-b02e05f40935@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <95823aae-28fd-f078-e358-b02e05f40935@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Wang,

Yes, we need the cmdr_lock in tcmu_try_get_data_page.

Reason: if the unmap worker thread gets started and calls
find_free_blocks, this function - while holding cmdr_lock - per tcmu
device checks for pages we can release.
If there are pages to release, it first calls unmap_mapping_range
to deny the access from userspace to these pages. After that it loops
over the data_pages xarray to remove the pages from the array and
free them (tcmu_blocks_release).

If tcmu_try_get_data_page wouldn't lock the cmdr_lock mutex, it
possibly could run between the call to unmap_mapping_range and
tcmu_blocks_release removing the page from xarray and freeing it.
Then we would end up having a freed page mapped to userspace!

Up to now I didn't check, whether we here have the same possible
dead lock you described. If so, we probably can solve the problem
by first removing the pages from xarray, then unmap and finally
free all pages. If we would do so, I think we would no longer need
cmdr_lock in tcmu_try_get_data_page.

But: I'm wondering what exactly you are trying to do.
I assume you want to map the sgl-pages into tcmu data_area just while a
cmd is in the ring, right?
If so, would you do that as a new option, or would you do that
generally?
I'm asking because AFAICS there are at least these problems when mapping
sgls:
- if a command in the cmd ring times out, tcmu sends cmd completion
   to target core. That means, you have to unmap the sgl pages.
   But userspace does not know about that. So it still is allowed to
   access the data space described by cmd's iovecs --> SIGBUS
- if the sgl contains not completely filled pages (probably at least
   at the end), you might map old kernel data into userspace.
   So you have to check and write zeros.
- AFAICS, there is no guarantee that fabric driver completely fills
   all pages of the sgl but the least. When mapping directly, that
   directly translates into iovecs having a length of not a multiple of
   PAGE_SIZE, not only in the last iovec.
   I'm not sure all existing userspace SW can handle that correctly.
- KEEP_BUF feature is based on tcmu owning the buffer in dataspace.
   So it would no longer work.

To be honest I'm not sure your changes would make it into tcmu.

Bodo


On 09.03.22 09:20, Xiaoguang Wang wrote:
> hi Bodo,
> 
> I have implemented a zero-copy prototype for tcmu(not sent out yet), it 
> reallys
> improves throughput in large io size cases, and I met some code question 
> that
> may need you kind help, thanks in advance. In my prototype, I choose to
> unmap pages in tcmu_irqcontrol():
> ==> tcmu_irqcontrol, which holds cmdr_lock.
> ====> tcmu_handle_completions
> ======> tcmu_handle_completion
> ========> zap_page_range, which needs to hold mm related lock.
> 
> But in page fault procedure:
> ==> tcmu_vma_fault, which I think its caller hold mm related lock.
> ====> tcmu_try_get_data_page, which tries to hold cmdr_lock.
> 
> Then dead lock may happens. In tcmu_try_get_data_page(),
> it mainly acts like below:
>          mutex_lock(&udev->cmdr_lock);
>          page = xa_load(&udev->data_pages, dpi);
>          if (likely(page)) {
>                  mutex_unlock(&udev->cmdr_lock);
>                  return page;
>          }
> 
>          /*
>           * Userspace messed up and passed in a address not in the
>           * data iov passed to it.
>           */
>          pr_err("Invalid addr to data page mapping (dpi %u) on device 
> %s\n",
>                 dpi, udev->name);
>          mutex_unlock(&udev->cmdr_lock);
> 
> I wonder do we really need to hold cmdr_lock here, seems it doesn't
> protect any real resources. If cmdr_lock here is used to avoid concurrent
> xa_erase(), after releasing cmdr_lock, page still can be removed.
> So my question is that can we safely remove this cmdr_lock here? thanks.
> 
> 
> Regards,
> Xiaoguang Wang
