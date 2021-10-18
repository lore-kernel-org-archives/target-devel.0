Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF92C433F5
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 11:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1CB61260
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 11:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhJRL67 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:58:59 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:37832 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229519AbhJRL67 (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 07:58:59 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 287524122E;
        Mon, 18 Oct 2021 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634558205;
         x=1636372606; bh=WMTTmHFdoCvJfsxHGM1lPU2azpZOBYCuUU/NIve/zus=; b=
        Q6b+e1oCXau/xAc/tHI4F35q7i5NJCt/G1W8ogAiqRVMEzxCUKiWtozWFhYeOc3h
        niXWKRwBtTPbCZbJJiUSQxxzBtWhn0fK1Dn3qX9fqwUHgTCw6sVvl5KivgmGTKhw
        trS9S6iIj4hlRN7ofJ/dE7jrm97B6230ylMyWyXc8S0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xRdGIauuoh0Y; Mon, 18 Oct 2021 14:56:45 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DDD0A41209;
        Mon, 18 Oct 2021 14:56:45 +0300 (MSK)
Received: from yadro.com (10.178.112.148) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 18
 Oct 2021 14:56:44 +0300
Date:   Mon, 18 Oct 2021 14:56:44 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YW1g/OFXMHq44CYo@yadro.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com>
 <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
X-Originating-IP: [10.178.112.148]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
> > If I understand this aproach correctly, it fixes the deadlock, but the
> > connection reinstatement will still happen, because WRITE_10 won't be
> > aborted and the connection will go down after the timeout.> 
> > IMO it's not ideal either, since now iSCSI will have a 50% chance to
> > have the connection (meaning SCSI session) killed on arbitrary ABOR
> 
> I wouldn't call this an arbitrary abort. It's indicating a problem.
> When do you see this? Why do we need to fix it per cmd? Are you hitting
> the big command short timeout issue? Driver/fw bug?

It was triggered by ESXi. During some heavy IOPS intervals the backend
device cannot handle the load and some IOs get stuck for more than 30
seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
So a series of ABORT TASK will come, and the unlucky one will hit the
issue.
 
> > TASK. While I'm sure most initiators will be able to recover from this
> > event, such drastic measures will certanly cause a lot of confusion for
> > people who are not familiar with TCM internals
> How will this cause confusion vs the case where the cmd reaches the target
> and we are waiting for it on the backend? In both cases, the initiator sends
> an abort, it times out, the initiator or target drop the connection, we
> relogin. Every initiator handles this.

Because usually (when a WRITE request is past the WRITE PENDING state)
the ABORT TASK does not trigger relogin. In my experience the initiator
just waits for the TMR completion and goes on.

And from a blackbox perspective it looks suspicious:

  1. ABORT TASK sent to WRITE_10 tag 0x1; waits for it's completion
  2. ABORT TASK sent to WRITE_10 tag 0x2; almost immediately the connection is dropped

The only difference between #1 and #2 is that the command 0x1 is past
the WRITE PENDING state.

> With that said I am in favor of you fixing the code so we can cleanup
> a partially sent cmd if it can be done sanely.
> 
> I personally would just leave the current behavior and fix the deadlock
> because:
> 
> 1. When I see this happening it's normally the network so we have to blow
> away the group of commands and we end up dropping the connection one way
> or another. I don't see the big command short timeout case often anymore.
> 
> 2. Initiators just did not implement this right. I know this for sure
> for open-iscsi at least. I started to fix my screw ups the other day but it
> ends up breaking the targets.
> 
> For example,
> 
> - If we've sent a R2T and the initiator has sent a LUN RESET, what are
> you going to have the target do? Send the response right away?

AFAIR the spec says "nuke it, there will be no data after this".

> - If we've sent a R2T and the initiator has sent some of the data
> PDUs to full fill it but has not sent the final PDU, then it sends the
> LUN RESET, what do you do?

The same. However, I understand the interoperability concerns. I'll
check what other targets do.
 
> - You also have the immediate data case and the InitialR2T case.

True.
 
> The updated specs clarify how to handle this, and even have a FastAbort
> key to specify which behavior we are going to do. But we don't support
> it and I don't think many people implemented it.
> 
> So you are going to get a mix of behavior. Some initiators will send the
> RESET and still send the data out PDUs and some will just stop sending
> data outs after the RESET. To be safe do you wait for the initiator to
> complete the sequence of data out PDUs? If so then you probably just hit
> the same issue where we don't get the needed PDUs and the one side drops
> the connection. If we send the ABORT response while the initiator is
> still sending data outs, then we risk breaking them.
> 
> If you want to do it then go for it, but to answer you original email's
> question the only easy way out is to just let it time out :)

Sounds reasonable. I'll test your solution.
