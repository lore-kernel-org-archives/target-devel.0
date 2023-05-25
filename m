Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D36C7EE2C
	for <target-devel@archiver.kernel.org>; Thu, 25 May 2023 08:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbjEYIAf (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 25 May 2023 04:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbjEYIAe (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 25 May 2023 04:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D23D122
        for <target-devel@vger.kernel.org>; Thu, 25 May 2023 00:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685001587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NwwIZJaZmyN29dYpZnR8aKcXxLup1p21dC4SUQQJNdM=;
        b=WX+QPlhBiVNtP+1XDv4NZ+Db2Trke857lOY7dsrvFBEkIKXXuop70dEeVwA7twb0OrBcbR
        e+g98jM37pXF7U6JOo8K5B3OaEZ5J8TVN1TaFoAQ+AdJ0j/TLUzab+PXF6pkiqqU6sVp8A
        +JjJTTzIHOxieLho9dhnbUXi8QflyvI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-FdPvQbDJMwmQ9_tSZ4Ce4g-1; Thu, 25 May 2023 03:59:46 -0400
X-MC-Unique: FdPvQbDJMwmQ9_tSZ4Ce4g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-62382e86f83so7320136d6.0
        for <target-devel@vger.kernel.org>; Thu, 25 May 2023 00:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685001586; x=1687593586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwwIZJaZmyN29dYpZnR8aKcXxLup1p21dC4SUQQJNdM=;
        b=eByC36iYLcgnMvnT8j0rzAdwBFRPnR+ez76yLgPOk18FlW4bmxyXmhFhNGuLTALKFr
         t9sqgQ9LsqgyJAmXFGuxlLF7lpvgLtOGrujsHtWAudvykH+fI9u7ohmy9vQgSReTpiAn
         +MzWebxHjZN1miSiLBC+SY07zVo3S0PxGgIftQ+3XEkw10uSgLmn7z4DjcytUPDxUC5m
         RObXP5zxdtif0XPQRJsAMVtM98iuQIbspGnwKa+YbHyEbFBfqFbtJrpR7pOdsXkWaLo1
         ybhgO82ozZZ77yJBIakDQxPcCIohaDdVuaXE7q6AuGpeqvlJih86LDbglF73hoQvqIan
         48Eg==
X-Gm-Message-State: AC+VfDwdv9bG0UQdGLFBJbc7I/nWIjbmBjZ57IGEUT8eeDOMfmUJkR7F
        NUJZYeLeAzB5I0Gashtj1SPCTA/+GNzBb5AETppVblbgubUHxV/WecqepTTFcvPhH7uvCC+E7AS
        VB42NRp1ZLaOIv1kDDW21wYgR
X-Received: by 2002:a05:622a:34a:b0:3f2:f35:8e6f with SMTP id r10-20020a05622a034a00b003f20f358e6fmr29397750qtw.25.1685001585834;
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6zl0dYCxYxkI+YVsbHmeWTGNczau5rHDnkpRLez3qsWsVlCM5yo3Zal8EdbIG0yQ8bNC7y6Q==
X-Received: by 2002:a05:622a:34a:b0:3f2:f35:8e6f with SMTP id r10-20020a05622a034a00b003f20f358e6fmr29397737qtw.25.1685001585600;
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
Received: from redhat.com ([191.101.160.247])
        by smtp.gmail.com with ESMTPSA id d3-20020a0cf6c3000000b00625b2f59d3fsm223966qvo.96.2023.05.25.00.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 00:59:45 -0700 (PDT)
Date:   Thu, 25 May 2023 03:59:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230525035847-mutt-send-email-mst@kernel.org>
References: <20230524233407.41432-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524233407.41432-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, May 24, 2023 at 06:34:04PM -0500, Mike Christie wrote:
> The following patches were made over Linus's tree and fix an issue
> where windows guests will send iovecs with offset/lengths that result
> in IOs that are not aligned to 512. The LIO layer will then send them
> to Linux's block layer but it requires 512 byte alignment, so depending
> on the block driver being used we will get IO errors or hung IO.
> 
> The following patches have vhost-scsi detect when windows sends these
> IOs and copy them to a bounce buffer. It then does some cleanup in
> the related code.

Normally with virtio we'd have a feature bit that allows skipping alignment
checks. Teach linux to set it. Stefan, WDYT?

-- 
MST

