Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682F1C433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Apr 2022 17:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiDMRGv (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 13:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiDMRGu (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 13:06:50 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4517B2FE46
        for <target-devel@vger.kernel.org>; Wed, 13 Apr 2022 10:04:28 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id z16so1819235qtq.6
        for <target-devel@vger.kernel.org>; Wed, 13 Apr 2022 10:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1gkKYNxAVgG9gQQX5FWE9T2WbQK+aJhhHh5HXzZzRl0=;
        b=MSbN0wXt8JXvBHHOliMKKBc5UHiDjY/9T6UQwgK+oMSTncqn/kKAKV9tJ9F3oD/51+
         THYfL8Lgh7V4xeyVoIYXzNopxSy2l0l8sJdW5X6pLY24O6UQEJWpAiph3BNNz9PDkaao
         bGv/mBGaA9dTPjZ9iOOGCyMF9pn+mGL/tcvQ1rUHxvxalqxKkzRLIXoDRkRoYXW2Cjl/
         Dvnx0dVosoX6vRZoJhakOvlVcKRdOdt0MPmdyXJV50UH6PzSH6a2Y8ZV/MgiN+su8XgI
         u+GRSbA4pncjCcWFclIon0tBc6Kd4iN8Q8OLfeiL8xhJAL4xiTcGggX4BGhn/HJlaSei
         0bOg==
X-Gm-Message-State: AOAM5324Km/ArlnixLI/Yy1jbKkS9GWJbwqZ8BKStDFCDsGC6eRHKa8j
        IvC3CYofXI5/0oyG+TMdRQqr
X-Google-Smtp-Source: ABdhPJzk8Hsy6b4fFdojSz0Z/fwMjicI2vghSEfVW7+AE/QcDDdQw502GSidyJJNTGoVWuUmwvp37w==
X-Received: by 2002:ac8:5e4e:0:b0:2e2:2bad:47b1 with SMTP id i14-20020ac85e4e000000b002e22bad47b1mr7781053qtx.493.1649869467355;
        Wed, 13 Apr 2022 10:04:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id a23-20020a05620a103700b00699d49c511dsm16089900qkk.104.2022.04.13.10.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:04:26 -0700 (PDT)
Date:   Wed, 13 Apr 2022 13:04:25 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] block: turn bio_kmalloc into a simple kmalloc wrapper
Message-ID: <YlcCmW0CLAFXB8UQ@redhat.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061228.410163-5-hch@lst.de>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Apr 06 2022 at  2:12P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
> 
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@kernel.org>
