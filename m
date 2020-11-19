Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B40C63697
	for <target-devel@archiver.kernel.org>; Thu, 19 Nov 2020 14:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AB122253
	for <target-devel@archiver.kernel.org>; Thu, 19 Nov 2020 14:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHuiH1Sc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKSOqj (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 09:46:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728136AbgKSOqi (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 09:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605797196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nBU9vCty/xUTtvWiRTKM3SNaAnXZsWQI+V6F25yzTt8=;
        b=HHuiH1Scv3UBL9+E32Ir9/c4HGjesuLFONctPpegf5X6X+V15E4WtC5YWn8Wz7MxABCy9+
        tVGwfQtY7yTqqzcT6nfoL6Gz5I6ok4NVUdtckTOSECyJs2hWh7SlUW5z+3/MaRhmgTAVOg
        IpsATjdLtfW7dqh6/CFESUPQLhRv0rw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-gfaEEslhPBWaLhYgyRmpbA-1; Thu, 19 Nov 2020 09:46:34 -0500
X-MC-Unique: gfaEEslhPBWaLhYgyRmpbA-1
Received: by mail-wm1-f70.google.com with SMTP id y26so2425922wmj.7
        for <target-devel@vger.kernel.org>; Thu, 19 Nov 2020 06:46:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nBU9vCty/xUTtvWiRTKM3SNaAnXZsWQI+V6F25yzTt8=;
        b=uiIn9HWL8mm0W3QkLew8Oly7ZwIpoawJ92mrwGcyj2MpDuamqvvJvVtEYK+g3xXYlF
         Ogx8Vl3YtZXay3QRPHJSbyGN9uHSVnhcRGW1SN40X9pZCzo6ONUs/HvWh45fdpD1uD8l
         /HtE6pwnUW8iVcyRFrSfaNmoV1hzcMutEmd2Jvu9luC3ibkHw3YaIUywqHwMWQ1TAeTu
         plHlVj1Kf9qff9ZzzxNQ6hLlrj8A0Nx8kqYABYhlx682KpUKmB+SZxu90pys1RedP/AI
         12gkHqG4lLsCSTeguvN5lg3RG0Kmo7SAKNUPN9st6eP/lb5DQyYMCrwb506P03VmP8pY
         BZOg==
X-Gm-Message-State: AOAM531cNlZDv+W4G8Og5E+StDAwuR8jYhP1IkfUMGb7PKH/h+qB8xJX
        0bNHN7gsOf5BXlvbuywQrtHt/f3D343wxPL9VLlplfWrZsoxy5+7293L2rvehs5zCFpRj4aN+Ot
        FL1zQDz27+bZZ1KJPAi6iXyj5
X-Received: by 2002:a1c:e0c3:: with SMTP id x186mr4948925wmg.21.1605797193263;
        Thu, 19 Nov 2020 06:46:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvmGgl1ENR3sYN4BkxpKKT1u0hPsLZxxmf1t2xm1+WIEcjQ7FNbjFySAZs3x19GfjQiwVI5Q==
X-Received: by 2002:a1c:e0c3:: with SMTP id x186mr4948910wmg.21.1605797193047;
        Thu, 19 Nov 2020 06:46:33 -0800 (PST)
Received: from redhat.com (bzq-109-64-91-49.red.bezeqint.net. [109.64.91.49])
        by smtp.gmail.com with ESMTPSA id l13sm41378138wrm.24.2020.11.19.06.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:46:31 -0800 (PST)
Date:   Thu, 19 Nov 2020 09:46:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>, qemu-devel@nongnu.org,
        fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201119094315-mutt-send-email-mst@kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <20201117164043.GS131917@stefanha-x1.localdomain>
 <b3343762-bb11-b750-46ec-43b5556f2b8e@oracle.com>
 <20201118113117.GF182763@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118113117.GF182763@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Nov 18, 2020 at 11:31:17AM +0000, Stefan Hajnoczi wrote:
> > My preference has been:
> > 
> > 1. If we were to ditch cgroups, then add a new interface that would allow
> > us to bind threads to a specific CPU, so that it lines up with the guest's
> > mq to CPU mapping.
> 
> A 1:1 vCPU/vq->CPU mapping isn't desirable in all cases.
> 
> The CPU affinity is a userspace policy decision. The host kernel should
> provide a mechanism but not the policy. That way userspace can decide
> which workers are shared by multiple vqs and on which physical CPUs they
> should run.

So if we let userspace dictate the threading policy then I think binding
vqs to userspace threads and running there makes the most sense,
no need to create the threads.

-- 
MST

