Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59835C433FE
	for <target-devel@archiver.kernel.org>; Wed,  8 Dec 2021 04:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhLHE2D (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 23:28:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244251AbhLHE1s (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 23:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638937456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnkeec58MbvU+mMJ3s+6/jmIYG3nDgFfteK0w/klgc8=;
        b=I8ShHuJWecM0T6/Z6SckjNoXc8Rr6tA6QRdVUFGRQG6dHDbnXBNNAv26mvoxEjs117pIRT
        KOF+wy86BCS1LzM6ocQJQ9+0QurSbdrw9sg6eO+7ErS76vk/1HaqdMEbDbGH+UoWO3bh+h
        dSX1yuMSt5Bk80TzTwk0NUpi6UOVRwE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-476-UpnGIdlbOf2mr78ZfRj0jA-1; Tue, 07 Dec 2021 23:24:15 -0500
X-MC-Unique: UpnGIdlbOf2mr78ZfRj0jA-1
Received: by mail-lj1-f197.google.com with SMTP id i14-20020a2e864e000000b00218a2c57df8so359016ljj.20
        for <target-devel@vger.kernel.org>; Tue, 07 Dec 2021 20:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnkeec58MbvU+mMJ3s+6/jmIYG3nDgFfteK0w/klgc8=;
        b=6O/3IqhCPOaffF/UJqoZdi9FyviVqs3YQ65D6kjs3TfJzC9fDA9xkvYtzSZ56ZpuD4
         g0KiLIwC9vZ+vOmr8tlejVA+3d6EdVpf49oVEqiuNwvXGphKLSJLfvLFWNF7/MJRfsDw
         t8RdvcGrqrdlIvzv9SVc/4rO0uO04AItZnUiLW0kV9WWUGt0grcBifThQmquI7B3C8zH
         pU9z+wCMAHW1UOJEGc9QDW7u8dbSnng6IrICEmHNsV+9a9WnaMhivmnmcFiSkzt8qL49
         0JWqYfmd2gwOBNQ6I6JWgs40tMoiq8n6159hzLs4tPxyuuWO/9ha30yqMZ8lvlCw2jQK
         RUlw==
X-Gm-Message-State: AOAM53027NBEopmgaaaYMf8+3iZGlr8BTTvg15VdtHLIBd/yS3/M7trs
        Uk+XD/JYgW8xqV4IYKGgY2x+kxAGTox2Top4AmcUqeFg93GjV42extdyMTzvN/FSm5wfRnKYVgl
        YVu8Z8cCtZ/gM2vvLxAKkQCria727COmNxY6bTABT
X-Received: by 2002:a2e:b742:: with SMTP id k2mr47716996ljo.107.1638937453442;
        Tue, 07 Dec 2021 20:24:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXBQhZIWJ2mKjBeEXvEJ+Z6rREz17GcGHg85bnccKQVzrnxg0n0UvNDUoskUxyeTOvEpr4ldqQWQWb+dL+jYg=
X-Received: by 2002:a2e:b742:: with SMTP id k2mr47716983ljo.107.1638937453292;
 Tue, 07 Dec 2021 20:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20211207025117.23551-1-michael.christie@oracle.com>
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Dec 2021 12:24:02 +0800
Message-ID: <CACGkMEtHm-6pBAdc=ZuXggMwdZ9X1ysnZjUxQFzyBaWtyP5SHg@mail.gmail.com>
Subject: Re: [PATCH V5 00/12] vhost: multiple worker support
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, mst <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, Dec 7, 2021 at 10:51 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> The following patches apply over linus's tree and the user_worker
> patchset here:
>
> https://lore.kernel.org/virtualization/20211129194707.5863-1-michael.christie@oracle.com/T/#t

It looks to me it gets some acks, maybe we need to nudge the
maintainer to merge that? This may simplify the review.

Thanks

