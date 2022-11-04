Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAE1C4332F
	for <target-devel@archiver.kernel.org>; Fri,  4 Nov 2022 10:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiKDKgC (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 4 Nov 2022 06:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKDKgB (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 4 Nov 2022 06:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DBD26139
        for <target-devel@vger.kernel.org>; Fri,  4 Nov 2022 03:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667558106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2VgDi2GpVKn8OQoFfTvoSmz+Epx/SkIYdUKdUUW3HQ=;
        b=LEbiQKdxhNiZn5vHW06R80TiqFXKD61DkPAUGhqqnWM3QaeUzqMfHrA+EGbRNABnbPaRq2
        1rbs5Cxhosbk82URGBYJ5O5Cr1oLSIfWBXoHoFzW04jnQpnGEuuBH+S/HmGstf9kJpB/ba
        uTpk7fBFIs45DDzKxipkehHkuVe0SXM=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-449-jsKJEgpqMwmPWR7OJUC7nw-1; Fri, 04 Nov 2022 06:35:05 -0400
X-MC-Unique: jsKJEgpqMwmPWR7OJUC7nw-1
Received: by mail-vs1-f69.google.com with SMTP id 64-20020a670743000000b003a630e65824so1541803vsh.15
        for <target-devel@vger.kernel.org>; Fri, 04 Nov 2022 03:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2VgDi2GpVKn8OQoFfTvoSmz+Epx/SkIYdUKdUUW3HQ=;
        b=vnLEezz546aXmNhUXUp+b4Umw0DvcniVH7rXAW5u6WCmNwBbxqovvao5hjQSXwJyE3
         pU3RBkF8fTdIFX3BfoipzkQ2eq9bRH3ViKACKiFWD1h/LBv/Q3eGoZW8mXYwqdUou3Ll
         TYsay4xvw3HB2SjZBZg+7jTGm+z4Kcy62E2VOk85xiLctoSuI/Y1p/BqP9OmABPAOeVn
         CJxWbPLGG6JNEOOAuwlrhfcO64o6Kq8+mT7JprMvSrRqR/VV7UQ9vPK77VLqtPRvJYI2
         5urHi9LKoEoEhES1P+2wX9Stb01Wp2M2XsAlgSHCdhCWIJj+pji2iO7sxnnPNyGdeOS8
         XCPA==
X-Gm-Message-State: ACrzQf0eQSHBJdnV8r4PaFaoFwJJJnh2668BVlXOkCuR0CSveBGfalo8
        5TRWI1yykERaKv1rU0WdaHP4HLKjiZwtJZB/o7XyOIq/+YDTlEQrw9UPyaXaCmXtmMItVW2d5un
        8nHl/NqnUn79FCWwTCscx5yzqewAHkL4dW48EJYIN
X-Received: by 2002:a67:ea90:0:b0:3ab:e987:e4bd with SMTP id f16-20020a67ea90000000b003abe987e4bdmr20766048vso.25.1667558103951;
        Fri, 04 Nov 2022 03:35:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6iEYH+g2VXjehgD5W67kMbqElpjqtDMbM4p7staWf6qRfgI5rDr+ffxnakiZB2hMQCAaE79cuuQ/rdCTu3Kac=
X-Received: by 2002:a67:ea90:0:b0:3ab:e987:e4bd with SMTP id
 f16-20020a67ea90000000b003abe987e4bdmr20766041vso.25.1667558103702; Fri, 04
 Nov 2022 03:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
 <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com>
 <CAJ-UWOeFDrL83akdz70LWYROjD_RboPQrP7kT1vwPvGnu_MyGw@mail.gmail.com>
 <CAFL455kcxPSLrJ8R2k-2dTr6f6Eg5W-7M2bUioC=P++W0YC=PA@mail.gmail.com>
 <CAEU3=8GPcCagm_VW3p9miw1ALr-y7=SvONLxLBBeWft-R2o3YA@mail.gmail.com> <CAJ-UWOcFDo4OPKEs0JwztX+vgm=Kizpqo-eCucUgLjKKqQgzxA@mail.gmail.com>
In-Reply-To: <CAJ-UWOcFDo4OPKEs0JwztX+vgm=Kizpqo-eCucUgLjKKqQgzxA@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 4 Nov 2022 11:34:52 +0100
Message-ID: <CAFL455mp3fKycwEGufWt6zsPLTM8P+A=de26-+abMgZP7usD3A@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Paul Dagnelie <pcd@delphix.com>
Cc:     Sumedh Bala <sumedh.bala@delphix.com>,
        target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Paul,

po 31. 10. 2022 v 22:13 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.com> nap=
sal:
>
> Hey Maurizio,
>
> So far no luck here on reproducing the issue. Do you have any updates
> on this issue?

Sorry but no luck so far. Actually I did some experiments to try to
reproduce it but I have been
slowed down by another bug:
https://marc.info/?l=3Dtarget-devel&m=3D166755512117326&w=3D2

Maurizio

