Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E92C64E8A
	for <target-devel@archiver.kernel.org>; Wed,  2 Dec 2020 10:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A16B20679
	for <target-devel@archiver.kernel.org>; Wed,  2 Dec 2020 10:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388373AbgLBKAh (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:00:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388247AbgLBKAh (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 05:00:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606903151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z8AQZAgl1UdsrqF/icNEETV75RA2NfX+ehHLJ3NCqqw=;
        b=fM7wTosM4MG64lJtNyid2k2x8LvuXkUp9pNkILa3lcdW4R/yxifvR5G0Hzol1169y9fxtI
        gGMTVGKemlnlmwMlzgEbllCZY9nAMbDqgD8P1sTl9vFOrnonxEZ4Rrqmq3Fit2bXouX0eG
        J7z28dXCKyMM09ljFy5hinQVIYBWblc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-BEF8MH0_PLGVFivOLtBggw-1; Wed, 02 Dec 2020 04:59:07 -0500
X-MC-Unique: BEF8MH0_PLGVFivOLtBggw-1
Received: by mail-wr1-f70.google.com with SMTP id z6so2696485wrl.7
        for <target-devel@vger.kernel.org>; Wed, 02 Dec 2020 01:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z8AQZAgl1UdsrqF/icNEETV75RA2NfX+ehHLJ3NCqqw=;
        b=DvH5udJc+ZhFecWHVYDYTDbjKN/+GD31UcYX16RgBK2rhgJm+bbzu3gNYXVxrdNhgs
         l7E0eXf7OZZnGKE8YuXoLspeoJt3WuUtPXXlSSp7c8gh8byar04t7ZYnoboGMvzK1Nqg
         VPptXo/nheBkU9LJt3rRsQELp58DsIil/P3qW1ep5Tgprto5XM4IfB1/A61DLev89w8P
         xJ5DcvsOrWqWvFk9hjJwj3arhXW5toQgKCOhPppDCFAO1N58R+HuUj6kdKEhepN6bXct
         QKM1qnNCu8nu478IiqGSZD/VvB0ksVtrWAjtL0xnpaOtOvzhFgPwTB1PPNyYT2PFXsGb
         3+tg==
X-Gm-Message-State: AOAM531TKGY4NrzWputoenM9zaNE9ZGIJGGvm78MfO/4et/0qJpdPrCX
        5FYIjXPYA56T3X3Dxot8mrKYcKD7GUtyEWc4spKGZBnn/M9qbcCym09w00vhrAJfmL5ZnkQlNPr
        0DzL9DfpEur5oiAFdblgjsFX7
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr2177304wmg.145.1606903146601;
        Wed, 02 Dec 2020 01:59:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlyOpsA5OFT6XaiG7rTTB0hoZWxmFeJV5oLJmK4wvaw9/zUbY1bAYBODC22GlGVObe124jzQ==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr2177290wmg.145.1606903146488;
        Wed, 02 Dec 2020 01:59:06 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id z11sm1418191wmc.39.2020.12.02.01.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:59:05 -0800 (PST)
Date:   Wed, 2 Dec 2020 04:59:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] qemu vhost scsi: add VHOST_SET_VRING_ENABLE support
Message-ID: <20201202045807-mutt-send-email-mst@kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, Nov 12, 2020 at 05:19:00PM -0600, Mike Christie wrote:
> diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
> index 7523218..98dd919 100644
> --- a/linux-headers/linux/vhost.h
> +++ b/linux-headers/linux/vhost.h
> @@ -70,6 +70,7 @@
>  #define VHOST_VRING_BIG_ENDIAN 1
>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)

OK so first we need the kernel patches, then update the header, then
we can apply the qemu patch.

>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */
> -- 
> 1.8.3.1

