Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD83C433E0
	for <target-devel@archiver.kernel.org>; Mon, 18 Jan 2021 18:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0FE22CA2
	for <target-devel@archiver.kernel.org>; Mon, 18 Jan 2021 18:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407605AbhARS3o (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Jan 2021 13:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436757AbhARS3h (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Jan 2021 13:29:37 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59687C061574
        for <target-devel@vger.kernel.org>; Mon, 18 Jan 2021 10:28:56 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 19so19529923qkm.8
        for <target-devel@vger.kernel.org>; Mon, 18 Jan 2021 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6OfwHc1CUnuze+sIKYDwiSSMcP1Mnt94yrNdzONXMc=;
        b=I70gxMCGa6VXFTdCUVqIrxDoriChErMWEhWVmnDCztvFEV9K/n3ElBkgmgrtpg1BjL
         JCXkgxdsL9K9xEv/0cEKuSXqiuiK5Zk061N68H4RaQ/56J+SpmBKSe2uRjtgWjwu3Ec2
         NX5qA1+NkpWXw70tjWcvipfP7S9DA4dn6/H9GgFqdazctTtrzJX/fPCeqUHTo0gTwJrl
         82xJGfkL9mF0QqRezQdtrPfNLCQiTjrXcwyRcZ80pnlFank7cK6kcJoxYmfKzIbst7lK
         bXFmYGu0MlcKlzYwaIe7d3MvE0MsWb4ucMN22I1k2+G6PbJMn+J79JLr8bQ/Z26005lm
         dhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6OfwHc1CUnuze+sIKYDwiSSMcP1Mnt94yrNdzONXMc=;
        b=obHct+p63dMWTfzYZSpjxQ8iWwDkAD+e6yFTL6DKfY3iWH9d7sa2yL0i+VgHUj3RpU
         LsoP+zsWl/boSb4QBw9yRuGgk0tiPlpSLVMnNqKOzsbLJrfm/orcbywE0647jxxJdK4k
         Ck0Og2J9/1s4B7DO813omerIE6xkK11XTnfZmmQQ4S8hxVCKVYn3/Ncd5XJZlrILdR1k
         qAvSyaADUZ+Sihx3SxlZtudnhY1gSQVWrBXgj21+3hdcl5j+HtbnuiKtRKL1DdNRE7xR
         tijDsmYIx/1KTQ8c5r6u+Ne1ArnJ+2qS59fbLitE1B3jhzsdRmvuclNgyNG224balJjn
         bgVw==
X-Gm-Message-State: AOAM531zds4LJU4D7FYG2CbirFDkPdcEBTt1jmvLXjBZ8UFrvKettqYr
        mgdJkv35LFuQMlkaNq0HO6Wozg==
X-Google-Smtp-Source: ABdhPJyoVuq3nY/icnfkE0mrabkzzFBuuTfwE9NxFbO6a8QayKjQV5IZB1bxXI2yG/S0i+cPYI2Vfw==
X-Received: by 2002:a37:6846:: with SMTP id d67mr840329qkc.219.1610994535549;
        Mon, 18 Jan 2021 10:28:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id u5sm11368459qka.86.2021.01.18.10.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 10:28:54 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l1ZGo-0031bp-7D; Mon, 18 Jan 2021 14:28:54 -0400
Date:   Mon, 18 Jan 2021 14:28:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        target-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, bostroesser@gmail.com, ddiss@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH v6 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
Message-ID: <20210118182854.GJ4605@ziepe.ca>
References: <20210118163006.61659-1-dgilbert@interlog.com>
 <20210118163006.61659-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118163006.61659-2-dgilbert@interlog.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Jan 18, 2021 at 11:30:03AM -0500, Douglas Gilbert wrote:

> After several flawed attempts to detect overflow, take the fastest
> route by stating as a pre-condition that the 'order' function argument
> cannot exceed 16 (2^16 * 4k = 256 MiB).

That doesn't help, the point of the overflow check is similar to
overflow checks in kcalloc: to prevent the routine from allocating
less memory than the caller might assume.

For instance ipr_store_update_fw() uses request_firmware() (which is
controlled by userspace) to drive the length argument to
sgl_alloc_order(). If userpace gives too large a value this will
corrupt kernel memory.

So this math:

  	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);

Needs to be checked, add a precondition to order does not help. I
already proposed a straightforward algorithm you can use.

Jason
