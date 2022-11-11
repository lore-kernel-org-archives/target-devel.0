Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B2DC433FE
	for <target-devel@archiver.kernel.org>; Fri, 11 Nov 2022 16:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiKKQXC (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 11:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiKKQW7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 11:22:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B24BDE0
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668183730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uc6WnYQw0arI6wwV9s5VE3vKycezDWJOE2ZOaZ+zHhs=;
        b=ISliFvEgNZo63+x+jD/tk1KMmMEssbU6LVLJt0AGOx6RCC3TFI9kZMCHFcz0Xv/PSoicai
        SH976aZQT1mZDFh1zvxV0s5WwZ5ks1O+9Ta0G7uRF/MXwPGXqpWL9sFTDkRH/X1MbnIaDZ
        m3xeneZHOCA570vDoljF/R1qMiTpx18=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-JjEAmEDcPnSDri1Wtrbz3A-1; Fri, 11 Nov 2022 11:22:08 -0500
X-MC-Unique: JjEAmEDcPnSDri1Wtrbz3A-1
Received: by mail-vs1-f70.google.com with SMTP id 65-20020a670344000000b0039b3020da1bso1120378vsd.3
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:22:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uc6WnYQw0arI6wwV9s5VE3vKycezDWJOE2ZOaZ+zHhs=;
        b=ggDk07kibLtnLLcdn0x3+iWffYGPVm81Q6s+R1DZQEpK/08BUVrfh4Cw8GPej4jekY
         GIj8jITrsobh94QfIu5t+1LARdR1bPbIrXNIzdRR0fOoB+pLAeiHyTXP6A67dVbxWlLq
         GPR7/c7Q4S0uth4o/jDqYPxcZ7AS5S7LBQFc2DruG+Siu0iVf13bwO0RrwB9Ra6nhBGJ
         gWDtrHiK3H3a5cOKiuIs7lTTzqQf2p19hKgDQSEoBvCFtLcf+Q4AsDabvj65y1rcEQrJ
         6NE7imvJBdk/1ld8vIZnvdWY3ZElMTY7psA5f4rntSzGaXDM0zx2B+jIgtqgKW7w4d21
         9sZA==
X-Gm-Message-State: ANoB5pkzVtVywmMXClyhhCPOqEkg34bF2pQvdVF4G1sZqBpNtQ8sJv33
        WilDOqT8pOMP+BDM8hURQQ+TfLyxtY7WtCGVnP57DFrJeEEXggVy4CxMDDKhzAGVawcW9T8y4w9
        +WlyjZE3XO9sEqHmjDtnvW4n+TbRZ7exWIy4eR2yM
X-Received: by 2002:ab0:264a:0:b0:414:43b5:56c3 with SMTP id q10-20020ab0264a000000b0041443b556c3mr1189477uao.111.1668183728468;
        Fri, 11 Nov 2022 08:22:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7k4CbRIulM3/QZqnuB3AynnWEShxdFTMQmbtEjFFmqeGm769jkKK/uaTKHYHhBm+fSLSp9CxJOQ+0Sxf/35mY=
X-Received: by 2002:ab0:264a:0:b0:414:43b5:56c3 with SMTP id
 q10-20020ab0264a000000b0041443b556c3mr1189469uao.111.1668183728266; Fri, 11
 Nov 2022 08:22:08 -0800 (PST)
MIME-Version: 1.0
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
In-Reply-To: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 11 Nov 2022 17:21:56 +0100
Message-ID: <CAFL455k0QOaUOtP22N6eHbude1vdrGDU-6fiFHepice-2OiLnQ@mail.gmail.com>
Subject: Re: tcm_loop and aborted TMRs
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

p=C3=A1 11. 11. 2022 v 17:20 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
> I noticed that Bodo submitted a patch some time ago (our customers
> confirm it works),
> Mike instead proposed to revert
> commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TM=
F".
>

Link to the patch submitted by Bodo:
https://patchwork.kernel.org/project/target-devel/patch/20200715160403.1257=
8-1-bstroesser@ts.fujitsu.com/#23512015

Thanks,
Maurizio

