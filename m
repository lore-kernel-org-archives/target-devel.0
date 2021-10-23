Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4576AC433F5
	for <target-devel@archiver.kernel.org>; Sat, 23 Oct 2021 20:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201E160F4B
	for <target-devel@archiver.kernel.org>; Sat, 23 Oct 2021 20:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhJWUOa (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 23 Oct 2021 16:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhJWUOa (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 23 Oct 2021 16:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635019930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VgEQduzNB4dlnuAxIBgUOHmPrSg6yBY89F+vEdYiO0s=;
        b=EgM9BolkK82hBmmpoG+zArdAwCoWs9HbtYXMjiFg/C5Xq1V951cUkw56iqfUS+0eXRJcxy
        CoaYk4wSTzLA1ZLJ/Ia3Pg+bkfhS6IvQWnfm9UavjWfFRET5g+tAQ7dNxgzxcYlKlIONmT
        dSXQQX84aPHtneWywbppkwqFZAoZqtM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-s0D1h_kcM66EE17eop6TIQ-1; Sat, 23 Oct 2021 16:12:09 -0400
X-MC-Unique: s0D1h_kcM66EE17eop6TIQ-1
Received: by mail-wm1-f72.google.com with SMTP id f20-20020a05600c155400b0030db7b29174so2582529wmg.2
        for <target-devel@vger.kernel.org>; Sat, 23 Oct 2021 13:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VgEQduzNB4dlnuAxIBgUOHmPrSg6yBY89F+vEdYiO0s=;
        b=DdEztjblLPFdrNypcn0CD3LSlnOoIx/aze63Wxx1hwrMyON8BR3MvdL6LIeZuhTaM3
         Dod9khyICMT8JWSxcbjOKtsVchcrCLiS5pN32/OMNFNSoVhm8WOMB1MXffAUeplKY1Dt
         ZDrH8gKWFMsXeBcUkDbDg42gbw0+SDHv+8oeVj8dUmWV+S5PTMC8Ektu/DQQT9ilhnzW
         x1W0nS0xeFQcgPwxo0r6twThCnuJjgWDVjdQplC9ZOAF2hNTkI7yvCBpocEokLNyOjSJ
         lwOoEgmCKVrBh2PijIS4eVXb0SaD+RFqWPQuZeri8XbPQEK7x3BubRvJsQZSBc1eabFX
         Qalw==
X-Gm-Message-State: AOAM53186qgt+tRbTh5YsRcTmNClmD+dnF60n6vjw7hEO7i+vo3JO7c9
        kib4bjnMGyI6JsXUHGqgOl7x8Cw0Led2yidLzB5epkB/KAS/iS+3xLthPgZcsQSLXqfwC7SDzAN
        sPOivIPqIyNzA8V82LxuFlUiS
X-Received: by 2002:a5d:64c5:: with SMTP id f5mr9830535wri.321.1635019928250;
        Sat, 23 Oct 2021 13:12:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZSCekXchQrLARUvA9cAdSdoDJ4a1ncqtfFS7+1L0KYU9GVCUAFucIoVw/MkbTUcvAk9wadA==
X-Received: by 2002:a5d:64c5:: with SMTP id f5mr9830506wri.321.1635019928047;
        Sat, 23 Oct 2021 13:12:08 -0700 (PDT)
Received: from redhat.com ([2.55.9.147])
        by smtp.gmail.com with ESMTPSA id k6sm11901376wri.83.2021.10.23.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 13:12:07 -0700 (PDT)
Date:   Sat, 23 Oct 2021 16:12:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     michael.christie@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH V3 00/11] vhost: multiple worker support
Message-ID: <20211023161135-mutt-send-email-mst@kernel.org>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022054625-mutt-send-email-mst@kernel.org>
 <2f8a975a-e01a-5671-7c3a-3b19c8564cb3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f8a975a-e01a-5671-7c3a-3b19c8564cb3@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, Oct 22, 2021 at 10:54:24AM -0500, michael.christie@oracle.com wrote:
> Ccing Christian for the kernel worker API merging stuff.
> 
> On 10/22/21 4:48 AM, Michael S. Tsirkin wrote:
> > On Fri, Oct 22, 2021 at 12:18:59AM -0500, Mike Christie wrote:
> >> The following patches apply over linus's tree and this patchset
> >>
> >> https://urldefense.com/v3/__https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/__;!!ACWV5N9M2RV99hQ!aqbE06mycEW-AMIj5avlBMDSvg2FONlNdYHr8PcNKdvl5FeO4QLCxCOyaVg8g8C2_Kp5$ 
> >>
> >> which allows us to check the vhost owner thread's RLIMITs:
> > 
> > 
> > Unfortunately that patchset in turn triggers kbuild warnings.
> 
> Yeah, that's the Jens/Paul issue I mentioned. I have to remove the
> old create_io_thread code and resolve issues with their trees. Paul's
> tree has a conflict with Jens and then my patch has a issue with Paul's
> patches.
> 
> So Christian and I thought we would re-push the patchset through
> Christian after that has settled in 5.16-rc1 and then shoot for 5.17
> so it has time to bake in next.
> 

Sounds good to me.

> > I was hoping you would address them, I don't think
> > merging that patchset before kbuild issues are addressed
> > is possible.
> > 
> > It also doesn't have lots of acks, I'm a bit apprehensive
> > of merging core changes like this through the vhost tree.
> 
> Ok. Just to make sure we are on the same page. Christian was going to
> push the kernel worker API changes.

Fine.

> > Try to CC more widely/ping people?

