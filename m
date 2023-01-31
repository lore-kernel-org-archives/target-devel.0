Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A363C61DA4
	for <target-devel@archiver.kernel.org>; Tue, 31 Jan 2023 02:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjAaCf2 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAaCfA (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 30 Jan 2023 21:35:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29B03756A
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 18:34:27 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 88so12904457pjo.3
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 18:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A9VhNAncouGPghsLCtxdhrn+26s29dRN0H0czKp2bTE=;
        b=ADZjED2w0momUtfafOuSNuN7ZxxrP0KeUDW1RTHuQc80r3inyDTwQ1MXq8KQQCJPA1
         2IjPoFNw6EOC1H2jGbZ0sNPpCmiE0a1bmED2KiD/tXvqcCixj5NIzO02aStn2z3ovwP6
         3Z5APDKQvCBsotmTrQZGzddlPRda1HIIj6Rto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A9VhNAncouGPghsLCtxdhrn+26s29dRN0H0czKp2bTE=;
        b=DFizC3OQRHlMH6+uTAzGY73IVnpJVwCKVwNGE4ITmTexkmHVJ308bdXElFEXu1xVHI
         86S16TUmRda2c24cgiF/iLhvmkA9/gI5eBJ5HWOw6oM6kT289JG2x7/NuAMYFF4LehSf
         C/Uf1fW+Ijcmm5qwoMRNGr6IGhn2+mllLeBlLHVLAPxzBaRrnhYkhK8j8BZDCHhZ3UfM
         a5r8HUZzad6qoIKtPbCU6BrFu7JBgl6AiEw7wghPzc7/RaAXzaJCaVnJs00fm8AAAc7I
         rs3SZ0e/RRAlAh0lrpi+T1Oz0MK1itnHBkyGDM1TFj3/pGX5HLu3eB9r3L2Ryhak8Eb/
         5Dpw==
X-Gm-Message-State: AFqh2kqKP1cUnZGo+5C0v621KDcrG2a/TYxUElPpY6zzzxwAfniI3BEb
        gbOUdnvSvl3zu8DWc+6JtODWKw==
X-Google-Smtp-Source: AMrXdXsnmC1gw3eG1rPepfp90wWItWSXAPyy0WFX0PxqmtkL6j5e8V5dnOtluVb8V5qnNkoyExcM+g==
X-Received: by 2002:a17:902:ba85:b0:194:828d:62b0 with SMTP id k5-20020a170902ba8500b00194828d62b0mr38778219pls.48.1675132459197;
        Mon, 30 Jan 2023 18:34:19 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id y20-20020a1709027c9400b00186c5e8a8d7sm3404428pll.171.2023.01.30.18.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 18:34:18 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:34:08 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 10/23] zram: use bvec_set_page to initialize bvecs
Message-ID: <Y9h+ILaGkNOhYJC5@google.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130092157.1759539-11-hch@lst.de>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On (23/01/30 10:21), Christoph Hellwig wrote:
> Use the bvec_set_page helper to initialize bvecs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
