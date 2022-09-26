Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3B6C07E9D
	for <target-devel@archiver.kernel.org>; Mon, 26 Sep 2022 17:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIZRjf (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIZRjR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 26 Sep 2022 13:39:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE49C640E
        for <target-devel@vger.kernel.org>; Mon, 26 Sep 2022 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664211833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pP4D3IWZYLPHQLVPqzOQV66fTplAYsusRjndK0V+u1A=;
        b=R4adMA3lPCfp4Dj0JHodoVI5kkhmSRHtkr7jW240I1NV4jpMWuunfbW67zWx+O28BZ8mId
        g3NWYLHZ/xLWVMVBSMWUz1iXWLuPRKnKi+FDYURGHibicSzjlrVy1iLRXhC829Py1ugDcJ
        BCmasK+pCY+2bymhXZh00h6uosPLA7Q=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-onuTFzRcNdyjzibUvltJMg-1; Mon, 26 Sep 2022 13:03:51 -0400
X-MC-Unique: onuTFzRcNdyjzibUvltJMg-1
Received: by mail-ua1-f72.google.com with SMTP id l37-20020ab01668000000b003c644c12130so1206184uae.11
        for <target-devel@vger.kernel.org>; Mon, 26 Sep 2022 10:03:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pP4D3IWZYLPHQLVPqzOQV66fTplAYsusRjndK0V+u1A=;
        b=nWRyRsONLTBLfdrZgbkpxlQ28FxKH37Io4tDeJVA3ypQXSbL/Uml4wqlkQ0txgEvuO
         44+mQODkJnXWq2mYjJKU3wjOhTj6m61xwS6e5xRPSLOcaP2kBahL5UFilCazVJs1tL/d
         o/+eVmPK+LjWoqjnEzDyjfeW/tA7AYxoNNTNPQ5mguZirDCyXjRJV4M4EcL7pbkhar8c
         V5Mw/tXHmHagZfVG6T12GvBjIO721BC02kCp+8xrmFbLMQL9GEL0ZvXKfD3gJue/2Go0
         uvIss2CW7x3gLdfrjWRsp5Lh24+fP6ZdmKaQAwrYqjsa2FF2sU3X+fZKThswVPIhoDIo
         YJng==
X-Gm-Message-State: ACrzQf2ug+sZLtJhQzlNATPZpvFdCbx8QX02yNa76SaGxXabIzSKRzvd
        QS3+ntdC1HW72YWFUviaUDbpPiHGnDz9Sf2QVUwLG0qsvBSNEDcI69SDJiAnaCXTdabU6UAGhk8
        7qCQGvzbTG3LlIBYVbwgugnhBL6Ok+jCFt2rNaB+j
X-Received: by 2002:a05:6102:2f6:b0:398:5094:f748 with SMTP id j22-20020a05610202f600b003985094f748mr8542868vsj.50.1664211830412;
        Mon, 26 Sep 2022 10:03:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7peEXHZpHEYDjtuAKMC8yue852cKqBTUZy3Og87CHM5j0+ig12hkIt8NJSTr0oiejeJs3UlOL+WvXGal4xBRw=
X-Received: by 2002:a05:6102:2f6:b0:398:5094:f748 with SMTP id
 j22-20020a05610202f600b003985094f748mr8542847vsj.50.1664211830224; Mon, 26
 Sep 2022 10:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
 <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com> <CAJ-UWOeFDrL83akdz70LWYROjD_RboPQrP7kT1vwPvGnu_MyGw@mail.gmail.com>
In-Reply-To: <CAJ-UWOeFDrL83akdz70LWYROjD_RboPQrP7kT1vwPvGnu_MyGw@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 26 Sep 2022 19:03:38 +0200
Message-ID: <CAFL455kcxPSLrJ8R2k-2dTr6f6Eg5W-7M2bUioC=P++W0YC=PA@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Paul Dagnelie <pcd@delphix.com>
Cc:     target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

=C3=BAt 20. 9. 2022 v 19:51 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.com>=
 napsal:
>
> That looks like a promising fix, thanks for getting on this so
> quickly! If I can ask, what was the workload/test that you used that
> reproduced it internally so quickly?

Sorry maybe I didn't explain myself clearly enough.
I wanted to say that some months ago our QA submitted some
crash reports that look very similar to the problem you described here.
They have a reproducer (I will ask for details about how it works and
I'll let you know)
but unfortunately the system crashes quite rarely; in other words,
it's not quick at all.

Right now they are trying to reproduce the crash with a recent kernel
so I can look at the crash dump again.

In the meanwhile, did you have any luck with reproducing it?

Maurizio

