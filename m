Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38763C43334
	for <target-devel@archiver.kernel.org>; Tue, 26 Jul 2022 11:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiGZLNF (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLNF (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 07:13:05 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5CC3122A
        for <target-devel@vger.kernel.org>; Tue, 26 Jul 2022 04:13:03 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B1945412DD;
        Tue, 26 Jul 2022 11:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1658833979; x=1660648380; bh=57AKculJaoiSfDJ45e83SFfwoV4wgXSyZ5G
        0TVQKodQ=; b=gvUnrR0Zye/BEySs5JVeSYSargowrMDopQ+Xk4/xakKt11C71T5
        OBDllmAjpzK7oTyQCxAJLypyuzYxWuH6HAzOweYLd+LqTVq39HQQUr54k6jH3DFp
        Vo+1zo8Ctwr5ABtluJVbyWD3A8hqPLaHo0EfgU55m+Yq3qMJDPpnyw5M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O3B_A4iR7dIZ; Tue, 26 Jul 2022 14:12:59 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 356E4404CF;
        Tue, 26 Jul 2022 14:12:59 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 26 Jul 2022 14:12:59 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 26 Jul
 2022 14:12:58 +0300
Date:   Tue, 26 Jul 2022 14:12:58 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Nick Couchman <nick.e.couchman@gmail.com>
CC:     <target-devel@vger.kernel.org>
Subject: Re: Unable to recover from DataOut timeout while in ERL=0
Message-ID: <20220726111258.GA31648@yadro.com>
References: <CAFjj603YVVF8jK9RS_Pe5d0YTEUkCWZ5EwdXsVGgjSQWNfU_Lw@mail.gmail.com>
 <20220713204005.GA6045@yadro.com>
 <CAFjj603out9ac8Za3BDfJ5WZYGtzvcMewBPsvvp+gH5D5PyunA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFjj603out9ac8Za3BDfJ5WZYGtzvcMewBPsvvp+gH5D5PyunA@mail.gmail.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Nick,

On Wed, Jul 13, 2022 at 09:47:40PM -0400, Nick Couchman wrote:
> 
> On Wed, Jul 13, 2022 at 4:40 PM Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
> >
> > Hi Nick,
> >
> > On Wed, Jul 13, 2022 at 03:04:12PM -0400, Nick Couchman wrote:
> > >
> > > (Apologies if this ends up as a double-post, re-sending in Plain Text Mode)
> > >
> > > Hello, everyone,
> > > Hopefully this is the correct place to ask a general
> > > usage/troubleshooting question regarding the Linux Target iSCSI
> > > system.
> > >
> > > I'm using the Linux iSCSI target on a pair of CentOS 8 Stream VMs that
> > > are configured with DRBD to synchronize data between two ESXi hosts,
> > > and then present that disk back to the ESXi hosts via iSCSI. Basically
> > > I'm attempting to achieve a vSAN-like configuration, where I have
> > > "shared storage" backed by the underlying physical storage of the
> > > individual hosts.
> > >
> > > It's worth noting that, at present, I'm not using an Active/Active
> > > configuration (DRBD dual-primary), but each of the VMs has the DRBD
> > > configuration and iSCSI configuration, and I can fail the primary and
> > > iSCSI service back and forth between the nodes.
> > >
> > > I'm running into a situation where, once I get the system under
> > > moderate I/O load (installing Linux in another VM, for example), I
> > > start seeing the following errors in dmesg and/or journalctl on the
> > > active node:
> > >
> > > Unable to recover from DataOut timeout while in ERL=0, closing iSCSI
> > > connection for I_T Nexus
> > > iqn.1998-01.com.vmware:esx01-18f91cf9,i,0x00023d000001,iqn.1902-01.com.example.site:drbd1,t,0x01
> > >
> > > This gets repeated a couple of dozen or so times, and then I/O to the
> > > iSCSI LUN from the ESXi host halts, the path to the LUN shows as
> > > "Dead", and I have to reboot the active node and fail over to the
> > > other node, at which point VMware picks back up and continues.
> > >
> > > I've searched around the web to try to find assistance with this
> > > error, but it doesn't seem all that common - in one case it appears to
> > > be a bug from several years ago that was patched, and beyond that not
> > > much relevant has turned up. Based on the error message, it almost
> > > seems as if the target system is trying to say that it couldn't write
> > > its data out to the disk in a timely fashion (which might be because
> > > DRBD can't sync as quickly as is expected?), but it isn't all that
> > > clear from the error.
> > We have been encountering the same issue with ESXi. For some reasons it
> > may not send an IO data for the already sent SCSI WRITE command - iSCSI
> > DataOUT PDUs. Instead, it send an ABORT for that command. Linux Target
> > Core does not abort a SCSI command when it has not yet full IO data
> > collected. iSCSI DataOut timer times out and triggers connection
> > reinstatement.
> > But during that reinstatement iSCSI hangs waiting for that aborted WRITE
> > command got completed. A not finished logout prevents a new login from
> > the same initiator.
> > That condition solves only by a target reboot.
> 
> Is this a bug that needs to be raised with VMware? Or is patching the
> Linux Target driver really the way to go? I'm happy to put in a case
> with VMware if that's desirable.

Most likely such behavior of ESXi is allowed by RFC. Even linux
iSCSI initiator side does the same - stops sending DataOut PDUs for the
aborted command.

> > > I'm wondering if anyone can provide tips as to how to best mitigate
> > > this - any tuning that can be done to change the time out, or throttle
> > > the iSCSI traffic, or is it indicative of a lack of available RAM for
> > > buffering (I'm not seeing a lot of RAM pressure, but possible I'm just
> > > not catching it)?
> > >
> > I may just send you a patch for a target that fixes the hanging. ESXi
> > will reconnect to the target and will continue work with it without a
> > reboot.
> >
> 
> I got the patch - I had to tweak it a bit for the CentOS Stream 8
> kernel I'm running against, but I've added it to the RPM and am
> rebuilding the packages, now. Hopefully will get it tested in the next
> couple of days.

Did you managed to test the patch? Could you please give some feedback?

BR,
 Dmitry
