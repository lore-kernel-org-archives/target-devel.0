Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB230C433EF
	for <target-devel@archiver.kernel.org>; Thu, 14 Jul 2022 01:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiGNBry (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGNBrx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 21:47:53 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D36F22BD6
        for <target-devel@vger.kernel.org>; Wed, 13 Jul 2022 18:47:52 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id q26so234937vsp.11
        for <target-devel@vger.kernel.org>; Wed, 13 Jul 2022 18:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB9EJJXFlS6ua56i4XNPBAcTXyTla/NSVeZ48IIQhio=;
        b=YLiwWnSDB+rD/9EdplbQcXBbJjICZTfNjAzicbErk2grLpdnv5X+xgBkxZL2IYkFD6
         Jckm62JHakwfaSELSMl2BYb9egxdUSjZbZ94UGDh9TySMa+Etsx2kdjnIps+F0bJQpHT
         YMXG9mBvZ7cTK5ZEcSOnfK7SnN3a9gluHMc7JiSZJdXgiZwnw79NLGj4DmKXpv/qS9DO
         +8IAYQ7mdS+cOlkN9iEV2yuJTaxamKgn5VuVhRGT0j+BIsb2+1EvQQ/ZlTj3lIvJYlnQ
         +y5YU1pXPUdH3Kt1sl26KFCFzyrCTj68dPpV/tMcirQV66IIX/y3J/nkbAkyA2mmU5Tu
         xtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB9EJJXFlS6ua56i4XNPBAcTXyTla/NSVeZ48IIQhio=;
        b=uNJf2if83NcqW1qfyvdkqAafRYDDpPLDyrZlyGr8TpCqkbNbRbaA2cTa5kp1321wtJ
         j1CrjiQojV47M4Yo17XDWKyopwcbklPLghozBvT1avvMg/36CI4RMcArP9f4Dowcj9c4
         gidCRYocrXdmDp7YJfOqYZu06VmE4C7m+P1fifeYPwOM4CXXW1p4Nx9bIcYktcP8WS9b
         PmxDEi76MgrY8GSLzk8Q2dp38Pibake4KAv58Pmhq0Hg4ypJ/wFzJsj3IkbLlXda4eTP
         QZOhyUgYSA2amUZCFlN2X+/oQ7MRhAplZXPGliHyCY0zoceFLQyD9fLSDSK5PGA2nqao
         cXqQ==
X-Gm-Message-State: AJIora82aLHoQLRZuMlQhERLO4FvyirMcmKo7kduWVmA2Rrz3xKc0gTc
        CQVo+vSM+tq1KTFP1hEw7J0MBi6CdDs1Y2YPy6F9mN+f
X-Google-Smtp-Source: AGRyM1t3cklBUODOPaAMQEWr5EoaE5Gl+XLOrev9rkUwOhmmQZNGSvOON0NNyh+zBOFQnTxY3kVpu/jPpLd7T+RvGw4=
X-Received: by 2002:a05:6102:3e23:b0:357:4974:e07e with SMTP id
 j35-20020a0561023e2300b003574974e07emr2690900vsv.31.1657763270989; Wed, 13
 Jul 2022 18:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAFjj603YVVF8jK9RS_Pe5d0YTEUkCWZ5EwdXsVGgjSQWNfU_Lw@mail.gmail.com>
 <20220713204005.GA6045@yadro.com>
In-Reply-To: <20220713204005.GA6045@yadro.com>
From:   Nick Couchman <nick.e.couchman@gmail.com>
Date:   Wed, 13 Jul 2022 21:47:40 -0400
Message-ID: <CAFjj603out9ac8Za3BDfJ5WZYGtzvcMewBPsvvp+gH5D5PyunA@mail.gmail.com>
Subject: Re: Unable to recover from DataOut timeout while in ERL=0
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Jul 13, 2022 at 4:40 PM Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
>
> Hi Nick,
>
> On Wed, Jul 13, 2022 at 03:04:12PM -0400, Nick Couchman wrote:
> >
> > (Apologies if this ends up as a double-post, re-sending in Plain Text Mode)
> >
> > Hello, everyone,
> > Hopefully this is the correct place to ask a general
> > usage/troubleshooting question regarding the Linux Target iSCSI
> > system.
> >
> > I'm using the Linux iSCSI target on a pair of CentOS 8 Stream VMs that
> > are configured with DRBD to synchronize data between two ESXi hosts,
> > and then present that disk back to the ESXi hosts via iSCSI. Basically
> > I'm attempting to achieve a vSAN-like configuration, where I have
> > "shared storage" backed by the underlying physical storage of the
> > individual hosts.
> >
> > It's worth noting that, at present, I'm not using an Active/Active
> > configuration (DRBD dual-primary), but each of the VMs has the DRBD
> > configuration and iSCSI configuration, and I can fail the primary and
> > iSCSI service back and forth between the nodes.
> >
> > I'm running into a situation where, once I get the system under
> > moderate I/O load (installing Linux in another VM, for example), I
> > start seeing the following errors in dmesg and/or journalctl on the
> > active node:
> >
> > Unable to recover from DataOut timeout while in ERL=0, closing iSCSI
> > connection for I_T Nexus
> > iqn.1998-01.com.vmware:esx01-18f91cf9,i,0x00023d000001,iqn.1902-01.com.example.site:drbd1,t,0x01
> >
> > This gets repeated a couple of dozen or so times, and then I/O to the
> > iSCSI LUN from the ESXi host halts, the path to the LUN shows as
> > "Dead", and I have to reboot the active node and fail over to the
> > other node, at which point VMware picks back up and continues.
> >
> > I've searched around the web to try to find assistance with this
> > error, but it doesn't seem all that common - in one case it appears to
> > be a bug from several years ago that was patched, and beyond that not
> > much relevant has turned up. Based on the error message, it almost
> > seems as if the target system is trying to say that it couldn't write
> > its data out to the disk in a timely fashion (which might be because
> > DRBD can't sync as quickly as is expected?), but it isn't all that
> > clear from the error.
> We have been encountering the same issue with ESXi. For some reasons it
> may not send an IO data for the already sent SCSI WRITE command - iSCSI
> DataOUT PDUs. Instead, it send an ABORT for that command. Linux Target
> Core does not abort a SCSI command when it has not yet full IO data
> collected. iSCSI DataOut timer times out and triggers connection
> reinstatement.
> But during that reinstatement iSCSI hangs waiting for that aborted WRITE
> command got completed. A not finished logout prevents a new login from
> the same initiator.
> That condition solves only by a target reboot.

Is this a bug that needs to be raised with VMware? Or is patching the
Linux Target driver really the way to go? I'm happy to put in a case
with VMware if that's desirable.

>
> >
> > I'm wondering if anyone can provide tips as to how to best mitigate
> > this - any tuning that can be done to change the time out, or throttle
> > the iSCSI traffic, or is it indicative of a lack of available RAM for
> > buffering (I'm not seeing a lot of RAM pressure, but possible I'm just
> > not catching it)?
> >
> I may just send you a patch for a target that fixes the hanging. ESXi
> will reconnect to the target and will continue work with it without a
> reboot.
>

I got the patch - I had to tweak it a bit for the CentOS Stream 8
kernel I'm running against, but I've added it to the RPM and am
rebuilding the packages, now. Hopefully will get it tested in the next
couple of days.

Thanks - NIck
