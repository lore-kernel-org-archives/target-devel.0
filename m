Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F655C433FE
	for <target-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32B622582
	for <target-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgLDQIY (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:08:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgLDQIY (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 11:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607098017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9eAbWgXkbv2eDi+txBHbhzeU9UsROTvRNfv5Pgs5m+M=;
        b=fxVQ7oJtBADuZolPKwcGemA9dq5Yk0KaQe94HiQzVU+N25InimNB+GE4SKAjKDWyrYjbVt
        en8KFDtRt97GyeCykgSG7OwFScZqQyRZAvcSDzzObCkQRiCfObam5/UaHQfv+3js9FJ6ym
        a9Z8S869pnJF4zBQRpuUNIYlRvg3xoA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-t6FEVaNsNbeSCNQ52gRZyg-1; Fri, 04 Dec 2020 11:06:56 -0500
X-MC-Unique: t6FEVaNsNbeSCNQ52gRZyg-1
Received: by mail-wr1-f70.google.com with SMTP id v1so2673155wri.16
        for <target-devel@vger.kernel.org>; Fri, 04 Dec 2020 08:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9eAbWgXkbv2eDi+txBHbhzeU9UsROTvRNfv5Pgs5m+M=;
        b=Bi6xm5WzKdKehiPQ5jiGsWjJk7vmIKPuxa8Un4RwoUK5FJvcuEJbMeIEk216B5Lxrh
         AnNkRFe2h/oOyD7gYkLO/hHgZK4Ntrw2/FaeKpSx4vFtRRiQnzxI/PGVe+2RX1T9glSo
         ifYtMZDdVy9PebObFWlTHgR7sqtv3ePt+t00sWBOITZNElxwX+Lx+murEyzIHmjywXWk
         KKZmSelhLdv5irwWR1fP8+yISA/eSv3DofctjbpCGe5YP9q9aPOmQTLj1cLw/jur/uzl
         oNF1N84o+U7eVQlt/rMk0E2y2HGOu9Anqp7D18M8pnEBh63+h03UFF8hZMiDP+t/fleN
         V8rA==
X-Gm-Message-State: AOAM531fvfQRkrjqXAnyk8qaLvwd8bgo8VX4M+BgORIpfmMkTfNSoneT
        63BscyxXxQK24iXiXrO9N8KtfTXWdKRyJa/XZDQcRSzk1gcxoAolMhf/3OPQAaP6vtWAWgHtZmF
        CsRJhvUtrVunMHJsufLSLWDlY
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr5697085wrp.339.1607098014702;
        Fri, 04 Dec 2020 08:06:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyh1gDOi04oyZ2v1FusnkNbGm/lSr5qmo45s0i41AvRQyKg5Lky0V7syJMDHqbbPfTgzo71XQ==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr5697059wrp.339.1607098014454;
        Fri, 04 Dec 2020 08:06:54 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id b83sm3766348wmd.48.2020.12.04.08.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 08:06:53 -0800 (PST)
Date:   Fri, 4 Dec 2020 17:06:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] vhost: allow userspace to control vq cpu affinity
Message-ID: <20201204160651.7wlselx4jm6k66mb@steredhat>
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Mike,

On Fri, Dec 04, 2020 at 01:56:25AM -0600, Mike Christie wrote:
>These patches were made over mst's vhost branch.
>
>The following patches, made over mst's vhost branch, allow userspace
>to set each vq's cpu affinity. Currently, with cgroups the worker thread
>inherits the affinity settings, but we are at the mercy of the CPU
>scheduler for where the vq's IO will be executed on. This can result in
>the scheduler sometimes hammering a couple queues on the host instead of
>spreading it out like how the guest's app might have intended if it was
>mq aware.
>
>This version of the patches is not what you guys were talking about
>initially like with the interface that was similar to nbd's old
>(3.x kernel days) NBD_DO_IT ioctl where userspace calls down to the
>kernel and we run from that context. These patches instead just
>allow userspace to tell the kernel which CPU a vq should run on.
>We then use the kernel's workqueue code to handle the thread
>management.

I agree that reusing kernel's workqueue code would be a good strategy.

One concern is how easy it is to implement an adaptive polling strategy 
using workqueues. From what I've seen, adding some polling of both 
backend and virtqueue helps to eliminate interrupts and reduce latency.

Anyway, I'll take a closer look at your patches next week. :-)

Thanks,
Stefano

>
>I wanted to post this version first, because it is flexible
>in that userspace can set things up so devs/vqs share threads/CPUs
>and we don't have to worry about replicating a bunch of features
>that the workqueue code already has like dynamic thread creation,
>blocked work detection, idle thread detection and thread reaping,
>and it also has an interface to control how many threads can be
>created and which CPUs work can run on if we want to further restrict
>that from userspace.
>
>Note that these patches have been lightly tested. I more wanted
>to get comments on the overall approach, because I know it's
>not really what you were thinking about. But while I worked
>on being able to share threads with multiple devices, I kept
>coming back to the existing workqueue code and thinking I'll
>just copy and paste that.
>
>

