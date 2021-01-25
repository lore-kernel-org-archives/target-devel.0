Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8EFC433DB
	for <target-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BA7E22CE3
	for <target-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbhAZF6x (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbhAYQAT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 11:00:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EC1C0617AA
        for <target-devel@vger.kernel.org>; Mon, 25 Jan 2021 07:58:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx1so3296767pjb.1
        for <target-devel@vger.kernel.org>; Mon, 25 Jan 2021 07:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ydjA7lxNDcY9m5HH4n1Isbc66o3HKVgUPIygbXwoUMM=;
        b=bI02x67oVJOucPOxKOB9n3X6KcNxCqIpxk5n0fxC4X/uFlQaaUy+xP+qcDK0qgJA7t
         mWFK2tKkiqtuWxZJvB44mpmemEF/S+YGxTW9vjz8KWnzcutGYJEs+vjezSfpdlvaat30
         NrMsLYnxAPDb/60yNPxEjnOGe2XeZLZa2qteFs3BDDpQq8v+NYEA0j27JKKvD8Jo9hGB
         m1FubjB+dKRDuIvGoJ5Krq3haj3y4rnOv+TQTyR+lsKZVtOzTkhokVPN9B3vqb9Kf/tF
         OgnBEzoTN7wXg3qcCOF4/ajnPQb9aZOpN8ShjkT8r+GX28FyVyVD2Nsgv5WX9h7sZf9A
         iVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ydjA7lxNDcY9m5HH4n1Isbc66o3HKVgUPIygbXwoUMM=;
        b=qde4Vm4H3a7X6GWoC84OFJi2gkeHhqTKrTaDktg16fd+sKW6WMqRlU2ftvWHdX73As
         ebQEwuUQC8efrXkvNG870Ce2do1LVywMfeTnlHL17MEoBKum6HAh0cRjHRHaHBM6tqtC
         mwuslZARDGKgz47NCtRkdmU9CPPQaolO9PeHi/5iJ7Q0LMgL9TztOEMTx4JbJpPhK9K9
         kkxwGH9P5O8qz1Rszx0uptDEybSkRBYASJvBKaXC8E5bjV4QqId7QHMBh1bQRxiMZlvr
         3qaQ+hfARttbY1quGJmiwn59tFWy8W3dRhrDValpUC/wg6xSdp6w4M5fyjLMwuoTRgBm
         qfOw==
X-Gm-Message-State: AOAM5309K6X00C2zpaz8EKRcVMbGQCP88NRyLyz5ejMlOys38rkF22/L
        sNNKXwL/x1QZqu8CuCDCsWL5Ug==
X-Google-Smtp-Source: ABdhPJxvYFudM0/t7uvN4OEM1XLPVgOQbMzfZischKww36TwjmQpcH3dkzLr1QJ1pvzT7oKrjCpfaw==
X-Received: by 2002:a17:90a:6f05:: with SMTP id d5mr843071pjk.145.1611590322691;
        Mon, 25 Jan 2021 07:58:42 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i25sm16942011pgb.33.2021.01.25.07.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 07:58:41 -0800 (PST)
Subject: Re: [PATCH v3 0/7] no-copy bvec
To:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1610170479.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1d0ae2a-a4ca-2b41-b8df-4c8036afe781@kernel.dk>
Date:   Mon, 25 Jan 2021 08:58:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/9/21 9:02 AM, Pavel Begunkov wrote:
> Currently, when iomap and block direct IO gets a bvec based iterator
> the bvec will be copied, with all other accounting that takes much
> CPU time and causes additional allocation for larger bvecs. The
> patchset makes it to reuse the passed in iter bvec.

Applied, thanks.

-- 
Jens Axboe

