Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31021C433DB
	for <target-devel@archiver.kernel.org>; Mon, 25 Jan 2021 01:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EB121D94
	for <target-devel@archiver.kernel.org>; Mon, 25 Jan 2021 01:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbhAYBZs (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Sun, 24 Jan 2021 20:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbhAYBZm (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 24 Jan 2021 20:25:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DABC0613ED
        for <target-devel@vger.kernel.org>; Sun, 24 Jan 2021 17:24:10 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id v19so7829499pgj.12
        for <target-devel@vger.kernel.org>; Sun, 24 Jan 2021 17:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MSpVHwkCX6jn2zmjsM3ERb1RCWT/CaWYVTGYkGxLPMQ=;
        b=cANH8e1JsQWWCA6K7c2yEeTbdiEO1GVf52BOvOvHMuuzuOwLMbDpTIG8lwpolK0icK
         0L3S/ocwk1bn0K4m4mezLZfUoMQFkPMVdzF0swABRaRDvhjPdS//d4rYF/hhSVlIj0e5
         GCTjUL4+USqxWngHHgmkMMISuZnFlCQ/DjAcXqZTPP+gCqtwV9N6H5Us2R2RTf4/Wm3l
         v9dC6xJ3eOcxO2kdzsIP9/VK8pDSh3vIrWiQigEURvRp6ZKeNDds2ga8oMas6khTZbUU
         bAXCXf9s6wkbPhLdiUZZx1F3c1+XzZivD4vAPVU1i93DCZ5GpPiHbaFqNE9Ar2HplqEB
         J7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MSpVHwkCX6jn2zmjsM3ERb1RCWT/CaWYVTGYkGxLPMQ=;
        b=rMzSqsA1NcL8A0UZJDukH8bfmyRpfdvd/ma0wtVupesXgBxzjLOKucYhqvJRn058PU
         J8i5Nhro/e/8VJStfoPsjlyIvvaYwYck8fQFNSCrcf9MBE7m1uz2kjMFGKJi+wa2n70h
         4VP1GAGxK0idRX6cyRH0x5+dybChE5Y2LUp/dQSQHxZhxoxaIOeWzax38MucvvmRME14
         pF7SnKAqWRNgcaAEGEACHtxx1ZpZ1/rz79e86dO2Vcxly9+GQvuDgWvXZu86vXhLLKQt
         ZFMReGKoyT6g80U4uaBBkUdJlVno++2Y34tKR2toA1xD45Ps1hxzh5cu0WqPLl/Eg6kV
         aR+Q==
X-Gm-Message-State: AOAM531JwZATsmvoa92vCCpxzyrKvfZ0X4bRbyJGbg0aVEjza7SbfaCQ
        kHbn93Y3tfpX+/vm1/O/p1EULQ==
X-Google-Smtp-Source: ABdhPJwGmmoJHjWbM4oOrfmGt+RyPavosTLmBxchZDys8SFvm/6ZSwmX7zSbzb/FwCp9pNaqXVDW9g==
X-Received: by 2002:a63:e30d:: with SMTP id f13mr8331115pgh.39.1611537849731;
        Sun, 24 Jan 2021 17:24:09 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b18sm15216556pfi.173.2021.01.24.17.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 17:24:08 -0800 (PST)
Subject: Re: [PATCH V2 0/2] remove unused argument from blk_execute_rq_nowait
 and blk_execute_rq
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-block@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
        hch@infradead.org
References: <20210122092824.20971-1-guoqing.jiang@cloud.ionos.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <683e16be-1146-e60c-cfea-e4606844f080@kernel.dk>
Date:   Sun, 24 Jan 2021 18:24:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210122092824.20971-1-guoqing.jiang@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/22/21 2:28 AM, Guoqing Jiang wrote:
> V2 changes:
> 1. update commit header per Christoph's comment.
> 
> Hi Jens,
> 
> This series remove unused 'q' from blk_execute_rq_nowait and blk_execute_rq.
> Also update the comment for blk_execute_rq_nowait.

What's this against? The lightnvm patch doesn't apply.

-- 
Jens Axboe

