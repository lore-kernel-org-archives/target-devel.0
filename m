Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2083C433F5
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 21:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA67660E78
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 21:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhJRVwi (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 17:52:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42910 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229524AbhJRVwi (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 17:52:38 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9BD1641306;
        Mon, 18 Oct 2021 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634593824;
         x=1636408225; bh=g8+kR4WSHKU/wdT7lHZNd9Htu6PWqIrxDUGN7yXhGCw=; b=
        IvmodH7BcKy7dXJPQB5mZDri2PjoK+sxc1VevKEadcK6nz7E2S8Zt2hUnQ3iqGCt
        WVI7rFUKFbzpc8OQ9C7EY26s9TgvxuMicR0c5ogfRZCJoE5VanhobK1wPkg9wNOV
        ge7DxoJMe2Ez8sZVVXc1/UHfziOMm6w9QFnJC9VSqIg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c-PaUthsJmnV; Tue, 19 Oct 2021 00:50:24 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6281A41243;
        Tue, 19 Oct 2021 00:50:23 +0300 (MSK)
Received: from yadro.com (10.178.120.186) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 19
 Oct 2021 00:50:23 +0300
Date:   Tue, 19 Oct 2021 00:50:22 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YW3sHlx6P+B6Jqjy@yadro.com>
References: <YWcsWKIn5RyN+UbD@yadro.com>
 <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
 <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
 <YW2vvr8CpBzRPRNP@yadro.com>
 <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
 <1858f7c3-4874-6931-da3a-12518aa36719@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1858f7c3-4874-6931-da3a-12518aa36719@oracle.com>
X-Originating-IP: [10.178.120.186]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 03:34:44PM -0500, Mike Christie wrote:
> On 10/18/21 3:20 PM, Mike Christie wrote:
> > On 10/18/21 12:32 PM, Konstantin Shelekhin wrote:
> >> On Mon, Oct 18, 2021 at 11:29:23AM -0500, Mike Christie wrote:
> >>> On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
> >>>> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
> >>>>>> If I understand this aproach correctly, it fixes the deadlock, but the
> >>>>>> connection reinstatement will still happen, because WRITE_10 won't be
> >>>>>> aborted and the connection will go down after the timeout.> 
> >>>>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
> >>>>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
> >>>>>
> >>>>> I wouldn't call this an arbitrary abort. It's indicating a problem.
> >>>>> When do you see this? Why do we need to fix it per cmd? Are you hitting
> >>>>> the big command short timeout issue? Driver/fw bug?
> >>>>
> >>>> It was triggered by ESXi. During some heavy IOPS intervals the backend
> >>>> device cannot handle the load and some IOs get stuck for more than 30
> >>>> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
> >>>> So a series of ABORT TASK will come, and the unlucky one will hit the
> >>>> issue.
> >>>
> >>> I didn't get this. If only the backend is backed up then we should
> >>> still be transmitting the data out/R2Ts quickly and we shouldn't be
> >>> hitting the issue where we got stuck waiting on them.
> >>
> >> We stuck waiting on them because the initiator will not send Data-Out
> > 
> > We are talking about different things here. Above I'm just asking about what
> > leads to the cmd timeout.
> 
> Oh wait, I miss understood the "almost immediately" part in your #3.
> 
> Just tell me if you are running iscsi in the guest or hypervisor and if
> the latter what version of ESXi,

ESXi 6.7 is connected over iSCSI. It uses the block device for
datastore.
 
> > 
> > You wrote before the abort is sent the backend gets backed up, and the back
> > up causes IO to take long enough for the initiator cmd timeout to fire.
> > I'm asking why before the initiator side cmd timeout and before the abort is sent,
> > why aren't R2T/data_outs executing quickly if only the backend is backed up?
> > 
> > Is it the bug I mentioned where one of the iscsi threads is stuck on the
> > submission to the block layer, so that thread can't handle iscsi IO?
> > If so I have a patch for that.
> > 
> > I get that once the abort is sent we hit these other issues.
> > 
> > 
> >> PDUs after sending ABORT TASK:
> >>
> >>   1. Initiator sends WRITE CDB
> >>   2. Target sends R2T
> >>   3. Almost immediately Initiator decides to abort the request and sends
> > 
> > Are you using iscsi in the VM or in the hypervisor? For the latter is
> > timeout 15 seconds for normal READs/WRITEs? What version of ESXi?
> > 
> >>      ABORT TASK without sending any further Data-Out PDUs (maybe except for
> >>      the first one); I believe it happens because the initiator tries to
> >>      abort a larger batch of requests, and this unlucky request is just
> >>      the last in series
> >>   4. Target still waits for Data-Out PDUs and times out on Data-Out timer
> >
