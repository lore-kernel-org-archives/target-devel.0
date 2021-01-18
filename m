Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68A6C433E0
	for <target-devel@archiver.kernel.org>; Mon, 18 Jan 2021 20:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6018522C9D
	for <target-devel@archiver.kernel.org>; Mon, 18 Jan 2021 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437840AbhARUZZ (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437917AbhARUZT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Jan 2021 15:25:19 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71969C0613D6
        for <target-devel@vger.kernel.org>; Mon, 18 Jan 2021 12:24:33 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id w79so19858814qkb.5
        for <target-devel@vger.kernel.org>; Mon, 18 Jan 2021 12:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fMGAcyIUDonqC5vZX69em4dMaV0h+aNyMhhqjLVgSNo=;
        b=X30e563Uk9Cma5YsX+T0s86EdcxvWZwgWtXA/TZZOF1Jd5jusebodDLu6075LgiI0j
         kOC62o8jQ3Zp2PAVFQjlANcfZL50+khhiGW2aI03D6Nf/7SAJm54aH0AXQ/X6FcScWDk
         g3s9YJa7RIs+cWeibt9s7OK05D7xN9d9QM7WEhW9nEPeYdMlR+KMrxKCLWM+zD69aL6d
         SHVjlWo8U3xyPJu95ZFHVQ1PUawj/szSOji3jeRN9YmZ4zGEe1WAxupTcFtLtie9OJ47
         ASdmoeVRDNULjbmtRJdDyc3pWJRh3ZF+2H3bJA5m9S/4RgKCuS27o2WM65Igz/9p/i/f
         r/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fMGAcyIUDonqC5vZX69em4dMaV0h+aNyMhhqjLVgSNo=;
        b=oHYJjMb6l6ElttAj7lgCt51U/5usOkn0VUgM3kKqdHNQZb9dWFwIm2EEV1Ih55NdEY
         8JqAWFLzLWHui/wq04VLqFRWYp40P3FM0RjVGbbVZK6OFzU3t5wu+z9bXKlxkgG1r8iU
         i4ugC1pxVTzplzyLWGe5+/bUBBC51O236s7ON30oH5fHGLX5+qQms8wu3mztgYU530nJ
         fqCs+suKzhbSiIE8uma0A5kXn1luVnZOLp0tMXAzX1KHYxlvtSU0JTTZqzstC42StNE0
         AvNJNrmo4RtIfBmS4qwnDG2k0HcWbsNv0Ug2PMBVfxSz8bvucWbX+f4weLxEHUM3995Z
         bC0w==
X-Gm-Message-State: AOAM533jY/b65V2j1Ksc3OXpcIQwS6nB1aWeaYIoaNSarfIgPsMwLoS9
        icU+JX9RmaOTpxwNIUagc763oA==
X-Google-Smtp-Source: ABdhPJxc2E3L8aTmtUgQMfQq+Vt6ZEqRDoOS7jM0GndhlpxFniYLv2gxPPWM2uS+0jTBvknhSEn3ww==
X-Received: by 2002:a05:620a:14a:: with SMTP id e10mr1271604qkn.103.1611001472585;
        Mon, 18 Jan 2021 12:24:32 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id k19sm11091498qkh.6.2021.01.18.12.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:24:32 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l1b4h-003Hn6-Hd; Mon, 18 Jan 2021 16:24:31 -0400
Date:   Mon, 18 Jan 2021 16:24:31 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        target-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, bostroesser@gmail.com, ddiss@suse.de,
        bvanassche@acm.org
Subject: Re: [PATCH v6 1/4] sgl_alloc_order: remove 4 GiB limit, sgl_free()
 warning
Message-ID: <20210118202431.GO4605@ziepe.ca>
References: <20210118163006.61659-1-dgilbert@interlog.com>
 <20210118163006.61659-2-dgilbert@interlog.com>
 <20210118182854.GJ4605@ziepe.ca>
 <59707b66-0b6c-b397-82fe-5ad6a6f99ba1@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59707b66-0b6c-b397-82fe-5ad6a6f99ba1@interlog.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Jan 18, 2021 at 03:08:51PM -0500, Douglas Gilbert wrote:
> On 2021-01-18 1:28 p.m., Jason Gunthorpe wrote:
> > On Mon, Jan 18, 2021 at 11:30:03AM -0500, Douglas Gilbert wrote:
> > 
> > > After several flawed attempts to detect overflow, take the fastest
> > > route by stating as a pre-condition that the 'order' function argument
> > > cannot exceed 16 (2^16 * 4k = 256 MiB).
> > 
> > That doesn't help, the point of the overflow check is similar to
> > overflow checks in kcalloc: to prevent the routine from allocating
> > less memory than the caller might assume.
> > 
> > For instance ipr_store_update_fw() uses request_firmware() (which is
> > controlled by userspace) to drive the length argument to
> > sgl_alloc_order(). If userpace gives too large a value this will
> > corrupt kernel memory.
> > 
> > So this math:
> > 
> >    	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
> 
> But that check itself overflows if order is too large (e.g. 65).

I don't reall care about order. It is always controlled by the kernel
and it is fine to just require it be low enough to not
overflow. length is the data under userspace control so math on it
must be checked for overflow.

> Also note there is another pre-condition statement in that function's
> definition, namely that length cannot be 0.

I don't see callers checking for that either, if it is true length 0
can't be allowed it should be blocked in the function

Jason
