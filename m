Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03C1ECAAA1
	for <target-devel@archiver.kernel.org>; Mon, 31 Oct 2022 21:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJaVNt (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 17:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJaVNr (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 17:13:47 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E24E23
        for <target-devel@vger.kernel.org>; Mon, 31 Oct 2022 14:13:47 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso7478939otb.6
        for <target-devel@vger.kernel.org>; Mon, 31 Oct 2022 14:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQ7VKuLH0Z7v5sQmlRSrBWft+mSayr3IbUSyQLYU4Eo=;
        b=P6ta7AE3mVd37IxO3sCfIdP0aKBuCVrtWp65H/tVCjYNexyt0TQ0T7eFdmbbDe47vc
         UbLf264mn4hsLoRHSLzfyBLLO0RSJoGyq/BFBVMqQhr5LUwIxhpxsFzqofWyJolb1hMn
         mvZ0o+ehmek3sjqIUJ4cSMIAq4UwBpX3glCQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aQ7VKuLH0Z7v5sQmlRSrBWft+mSayr3IbUSyQLYU4Eo=;
        b=10Ge0AgKuD88Y5+romL33nljJhALOVoB78LV+FIzHBFNdmFif63D3hjk9YKgkKsxKt
         uY9akkEGpXEHMAzwfsZ12rwGuBIVmNeqZUkBt3mMq+lXY9lnFqZ+4y8pmWFvk9gtrCHr
         oe0/sErZAfJOe4nd/VPOSA0Z0MkpoYvWRysY7P96dACnpz7U9NA60x9mFRqkonBLhbfG
         x8Ec0IL2VXXzFmEEyZ4/bBgTvZj6QwZMzmWwft7RJgbqAIZTPnrGNmrA+92KNR021Te8
         eaMNAzEkU/G4o+PUnrwc9pWvkKEN4Cu9Bb2Ajs6DQQrE0mJAuEhwjG8bgsAOmuP5cKym
         w9mA==
X-Gm-Message-State: ACrzQf270SsU3XwPC3bXhbfsE5JbhpnLMnJvETDAY6nC17bgOMWsEmlp
        CTDwQVgd3Yj3sfJ2zfdNIoP1K63oX8qpjfoFNjWz0A==
X-Google-Smtp-Source: AMsMyM5wa+mp53rR16DdgKr+AZ5PIL4ljak7THO6zKyUOkgRdXqWmzq9K4wedmCjiIxEg7WmjM5eqFVVSSyKxH4aiwY=
X-Received: by 2002:a05:6830:2692:b0:661:c5a3:bdb4 with SMTP id
 l18-20020a056830269200b00661c5a3bdb4mr7442913otu.196.1667250826510; Mon, 31
 Oct 2022 14:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
 <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com>
 <CAJ-UWOeFDrL83akdz70LWYROjD_RboPQrP7kT1vwPvGnu_MyGw@mail.gmail.com>
 <CAFL455kcxPSLrJ8R2k-2dTr6f6Eg5W-7M2bUioC=P++W0YC=PA@mail.gmail.com> <CAEU3=8GPcCagm_VW3p9miw1ALr-y7=SvONLxLBBeWft-R2o3YA@mail.gmail.com>
In-Reply-To: <CAEU3=8GPcCagm_VW3p9miw1ALr-y7=SvONLxLBBeWft-R2o3YA@mail.gmail.com>
From:   Paul Dagnelie <pcd@delphix.com>
Date:   Mon, 31 Oct 2022 14:13:20 -0700
Message-ID: <CAJ-UWOcFDo4OPKEs0JwztX+vgm=Kizpqo-eCucUgLjKKqQgzxA@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Sumedh Bala <sumedh.bala@delphix.com>
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hey Maurizio,

So far no luck here on reproducing the issue. Do you have any updates
on this issue?

On Tue, Oct 11, 2022 at 10:23 AM Sumedh Bala <sumedh.bala@delphix.com> wrot=
e:
>
> We have seen this a few times but have not been able to reproduce it at w=
ill.
>
> -Sumedh
>
> On Mon, Sep 26, 2022 at 10:03 AM Maurizio Lombardi <mlombard@redhat.com> =
wrote:
>>
>> Hello,
>>
>> =C3=BAt 20. 9. 2022 v 19:51 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.c=
om> napsal:
>> >
>> > That looks like a promising fix, thanks for getting on this so
>> > quickly! If I can ask, what was the workload/test that you used that
>> > reproduced it internally so quickly?
>>
>> Sorry maybe I didn't explain myself clearly enough.
>> I wanted to say that some months ago our QA submitted some
>> crash reports that look very similar to the problem you described here.
>> They have a reproducer (I will ask for details about how it works and
>> I'll let you know)
>> but unfortunately the system crashes quite rarely; in other words,
>> it's not quick at all.
>>
>> Right now they are trying to reproduce the crash with a recent kernel
>> so I can look at the crash dump again.
>>
>> In the meanwhile, did you have any luck with reproducing it?
>>
>> Maurizio
>>


--=20
Paul Dagnelie
