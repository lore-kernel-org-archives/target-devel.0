Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F61C433EF
	for <target-devel@archiver.kernel.org>; Mon, 25 Oct 2021 09:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C96860E0B
	for <target-devel@archiver.kernel.org>; Mon, 25 Oct 2021 09:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhJYJLU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:11:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232479AbhJYJLT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 05:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635152937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeGNSOcAvBmLSqJs1UuImaAZO/HaSB8DxKn5L+5tDB0=;
        b=Wenb+UaHfY3BHKOnKiwF83ErdkoY1odxDOqTCXnb7zC32aIE/guoxbRf3CrqDepdifjDfv
        phg4IeTW5CnaYLdMZSWidB3oaupd4vOMk3RXnIh1JHCBldeRc3nvWcPBPOJKwzVuUmXh6r
        /cRSim0EDiQEtJydB17UC759jZHdebA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-6ONRnRQIMa6YVEb-ypbmWQ-1; Mon, 25 Oct 2021 05:08:56 -0400
X-MC-Unique: 6ONRnRQIMa6YVEb-ypbmWQ-1
Received: by mail-ed1-f70.google.com with SMTP id o22-20020a056402439600b003dd4f228451so2762190edc.16
        for <target-devel@vger.kernel.org>; Mon, 25 Oct 2021 02:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XeGNSOcAvBmLSqJs1UuImaAZO/HaSB8DxKn5L+5tDB0=;
        b=nO3MS4E//k8TT4S6+sFWXtdOBxoc0epxmQO7UavrQHQxjPWXgVAfJeJOpzLciqlO/k
         mRH1dM5cmE64JdeUrdpFEeAw7d8FIw8L+Lf++sf+lK4z50nNJhqP7XKeeiTuAVyT3dQD
         MhaBgS6+OKIHLB2YtcwI0cQqLRxnYJz2tKFdVBVSiMC9L8YDNnJtMI+KhtNP7DBHjYlZ
         J4hT+ausxB/iolAu0CPiEG7h63xaZiYMZv/0QzdiTWAx9xOZnSpi62C2ed9sekP6SFnX
         lkkAx07PLKXfM05aZlKTEbRqG6JiZ5XctuQfxIU8kWlEoSCPJUAcrbUZd1SSRCi/eIVw
         U2Iw==
X-Gm-Message-State: AOAM530gFqctaf1fITWXTckOGWkTcJGeCUbrrBN1cBYAIbJ5RrqSJq57
        E9zjLE14zgzovNI7siVu3wRheb/K5LqU0KZIKCslienz9TNWeo7HRmafiZAOu3AwlD4r47CMkxX
        /HioEDUqb2mL17chgXWLi9uvA
X-Received: by 2002:a17:907:3f9c:: with SMTP id hr28mr21157755ejc.246.1635152934825;
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/sV83vvSJXd/ysEd58WtGrMeInWgBZZGAKoZJQ3ewcqc/wys+wOPgIfJKAvE2jCVNIiBILg==
X-Received: by 2002:a17:907:3f9c:: with SMTP id hr28mr21157730ejc.246.1635152934633;
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
Received: from steredhat (host-79-30-88-77.retail.telecomitalia.it. [79.30.88.77])
        by smtp.gmail.com with ESMTPSA id hb9sm3019913ejc.80.2021.10.25.02.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
Date:   Mon, 25 Oct 2021 11:08:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 06/11] vhost-sock: convert to vq helpers
Message-ID: <20211025090852.4kbqf3gieednw6ie@steredhat>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-8-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, Oct 22, 2021 at 12:19:06AM -0500, Mike Christie wrote:
>Convert from vhost dev based helpers to vq ones.
>
>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>---
> drivers/vhost/vsock.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 938aefbc75ec..c50c60d0955e 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -300,7 +300,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> 	list_add_tail(&pkt->list, &vsock->send_pkt_list);
> 	spin_unlock_bh(&vsock->send_pkt_list_lock);
>
>-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
>+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_TX], &vsock->send_pkt_work);

I think we should use VSOCK_VQ_RX. I know, the nomenclature is weird, 
but it's from the guest's point of view, so the host when sending 
packets uses the VSOCK_VQ_RX, see vhost_transport_send_pkt_work().


>
> 	rcu_read_unlock();
> 	return len;
>@@ -612,7 +612,7 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
> 	/* Some packets may have been queued before the device was started,
> 	 * let's kick the send worker to send them.
> 	 */
>-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
>+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_TX], 
>&vsock->send_pkt_work);

Ditto.

Thanks,
Stefano

