Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3001C47089
	for <target-devel@archiver.kernel.org>; Thu, 27 May 2021 13:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1FA613EB
	for <target-devel@archiver.kernel.org>; Thu, 27 May 2021 13:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhE0NYd (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 27 May 2021 09:24:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236377AbhE0NYc (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 27 May 2021 09:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622121779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aUqMjQnFHowCIpxoqGdHLFgcHkZJl9a5H4mk4+yVXTw=;
        b=ITz/wwMxWd8bm7WmSg5TgQSqRKxbP/BbpaUq3fn5MM7C7khwoTHNUjpTpNbEflSaA5MkUQ
        CFlder349MfXRbeH7cXO4ROFO6ylTXUU4nZBHMQ2rr0cr/Q5EFK8qAz/yO1dPyPkmlfz+r
        7DNwkrbUu5VMFZpeWuVlNHN9Sx8Ygq4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-GRt6vyU8NNezQLWTWcR3tg-1; Thu, 27 May 2021 09:22:57 -0400
X-MC-Unique: GRt6vyU8NNezQLWTWcR3tg-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso12424ejc.7
        for <target-devel@vger.kernel.org>; Thu, 27 May 2021 06:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aUqMjQnFHowCIpxoqGdHLFgcHkZJl9a5H4mk4+yVXTw=;
        b=qgQOfKkEGJI4KATnQIveQoawDyoPcy05BshlWgRmhWjYGbzymrpfH20DlMWd+LYNB/
         7ClKN6727EfLeAM5yac+cDOThHTV9wanZgb6SVK2xkivawrSCxRmayxlHMbsxxEVfBYx
         4G4sPLeK/1yHZE9WVngJMTKFaTQR1NN6C2JNRRrDLV3A+tm6YUWy8AlV6b1MwWDr0OPs
         NbZiBYNC9FyKVSjeywNIMsM1cFvUMZHjzpNbGwUPRE//L18QK4+q8tIdxsiPtb8flmpQ
         d4nGWwl13wAypJcY8T4IIgtzzdlRNFicvUugFGmeVlrGudQVDqcP+U2SvtgqJ8fHtmYT
         1a0w==
X-Gm-Message-State: AOAM533eFYNldvS9ommmxejwonZElov91YnMT8OnIRKIrvW/Q8T2LHd3
        AbfyofooILxLecO6lG3Ye1EMELZf5SK4xzG8iuGJUP3kL2/v84+J+1FgWNFPWXEiBTSA3IMP0cD
        DM2j/Wy8pQBgxkRzKiGVUZY75
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr4160697edt.194.1622121776508;
        Thu, 27 May 2021 06:22:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTLpW23FL3nEka+3tyXPIXrAkuMHRFepLMTuuCuBIggWGutKrctUmLwXk2eoGHvNtAVLDGiA==
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr4160671edt.194.1622121776310;
        Thu, 27 May 2021 06:22:56 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id t9sm1146544edf.70.2021.05.27.06.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 06:22:55 -0700 (PDT)
Date:   Thu, 27 May 2021 15:22:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH 1/5] vhost: remove work arg from vhost_work_flush
Message-ID: <20210527132253.icav3xnbg46cwawv@steredhat>
References: <20210525174733.6212-1-michael.christie@oracle.com>
 <20210525174733.6212-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210525174733.6212-2-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, May 25, 2021 at 12:47:29PM -0500, Mike Christie wrote:
>vhost_work_flush doesn't do anything with the work arg. This patch drops
>it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
>that the function flushes all the works in the dev and not just a
>specific queue or work item.
>
>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>Acked-by: Jason Wang <jasowang@redhat.com>
>Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>---
> drivers/vhost/scsi.c  | 4 ++--
> drivers/vhost/vhost.c | 8 ++++----
> drivers/vhost/vhost.h | 2 +-
> drivers/vhost/vsock.c | 2 +-
> 4 files changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

