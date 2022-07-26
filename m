Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6255C433EF
	for <target-devel@archiver.kernel.org>; Tue, 26 Jul 2022 11:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiGZLWK (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiGZLWJ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 07:22:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DCF15729
        for <target-devel@vger.kernel.org>; Tue, 26 Jul 2022 04:22:08 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id i4so6649599oif.2
        for <target-devel@vger.kernel.org>; Tue, 26 Jul 2022 04:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3OP293rBJvegPtDT0Nmvy58hZyyNfTDOVQp+/w/OWs=;
        b=nBvPAHvO4vRBQK+y6fo2VjoxcJb3+HpJriIFMpgmd7uLoafV5YCvlyb6Lxphv4L8MY
         cwbX62fjxzT4duXDnIZZoNLbB9Nvzvx+1wWzYWLEL2XDr3jyuJR7OMwXDm0BUadso6J8
         YAtLuxI34zVCfvI0zemb/grnVTgqzLMgaQWjbkOk7B/4ZqehdDR1Q6l8W5Gt7u/G88sB
         gPyx4VoACa2NAT6lRadmzqF3y3GLdckO/f+iu+Gucu8mBwJ1KOqMo7cT5IZwVORyVPwr
         ybYmL/rGa3cnX+Iq7lyk5ELjHpwQqXtVtUb9Uwg9Qh/wIlgax/ZzK5GGyTFFxVElCtUZ
         noTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3OP293rBJvegPtDT0Nmvy58hZyyNfTDOVQp+/w/OWs=;
        b=ug5LlYWIzyWz69t5vQTQE+GoSQj8ZwDoIzypKwhZ37X4okS2nyigBPF1LQYitvNjna
         8/5x05iJE++jSNAfzKZRRXZ8qpQwGWId4Ihuw9Ab5QrT20fboQdpGxtHNImnrO9a2UOj
         tbyH8vv5YzJLTytTyAVPLo9RDNEjCL/LRXdcBKn3GY1m+UsyVamNSZom5B6WP47nhnYU
         axTVPFq5KCx1h+2LCHAgEDcftl5gFDaux23EPWh+XlwbwzDpvIUU4rOh7TTN3bt1XQhL
         jzr+so/eBf+0fpsLot2005VPc5YBdRoBYvItgA5Z4Fotyhyu676lTReTepMsNaWe+NzC
         Bvaw==
X-Gm-Message-State: AJIora/bIU3UK5s2UMMFG0soqHGRO+PdFbs7Gm8b42bx1ETP4GQfyrkK
        dMhOOjp6h30wc0cCbKNVUnmVXdEU1NJIpltsTnIRW9PM
X-Google-Smtp-Source: AGRyM1uVgJChgPdE/IggpO5C6OD/2vG1hR0/oXsB2/fCs3+AUtpIfon6FzG8KNr66MIPMGc0hc+E7UU8+67w871ntFA=
X-Received: by 2002:a54:4788:0:b0:33a:6311:a734 with SMTP id
 o8-20020a544788000000b0033a6311a734mr15526751oic.156.1658834527309; Tue, 26
 Jul 2022 04:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAFjj603YVVF8jK9RS_Pe5d0YTEUkCWZ5EwdXsVGgjSQWNfU_Lw@mail.gmail.com>
 <20220713204005.GA6045@yadro.com> <CAFjj603out9ac8Za3BDfJ5WZYGtzvcMewBPsvvp+gH5D5PyunA@mail.gmail.com>
 <20220726111258.GA31648@yadro.com>
In-Reply-To: <20220726111258.GA31648@yadro.com>
From:   Nick Couchman <nick.e.couchman@gmail.com>
Date:   Tue, 26 Jul 2022 07:21:56 -0400
Message-ID: <CAFjj602YWoXeCsbB4X=KmtvLVgo53K7HxZNGebkqDsXxB7Zx-w@mail.gmail.com>
Subject: Re: Unable to recover from DataOut timeout while in ERL=0
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, Jul 26, 2022 at 7:13 AM Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
>
> >
> > Is this a bug that needs to be raised with VMware? Or is patching the
> > Linux Target driver really the way to go? I'm happy to put in a case
> > with VMware if that's desirable.
>
> Most likely such behavior of ESXi is allowed by RFC. Even linux
> iSCSI initiator side does the same - stops sending DataOut PDUs for the
> aborted command.

Ah, okay, makes sense.

>
> > > > I'm wondering if anyone can provide tips as to how to best mitigate
> > > > this - any tuning that can be done to change the time out, or throttle
> > > > the iSCSI traffic, or is it indicative of a lack of available RAM for
> > > > buffering (I'm not seeing a lot of RAM pressure, but possible I'm just
> > > > not catching it)?
> > > >
> > > I may just send you a patch for a target that fixes the hanging. ESXi
> > > will reconnect to the target and will continue work with it without a
> > > reboot.
> > >
> >
> > I got the patch - I had to tweak it a bit for the CentOS Stream 8
> > kernel I'm running against, but I've added it to the RPM and am
> > rebuilding the packages, now. Hopefully will get it tested in the next
> > couple of days.
>
> Did you managed to test the patch? Could you please give some feedback?

Not, yet - I have Secure Boot enabled on most of the systems where I'm
currently running it, so it makes compiling a custom kernel a bit more
difficult. I'll try turning secure boot off on one of those systems
and give it a shot, again. Hopefully have some news for you, soon.

-Nick
