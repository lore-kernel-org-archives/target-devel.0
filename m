Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B5EC433EF
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 21:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E5B61027
	for <target-devel@archiver.kernel.org>; Mon, 18 Oct 2021 21:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhJRVup (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 17:50:45 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42836 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229524AbhJRVup (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 17:50:45 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5517B4130D;
        Mon, 18 Oct 2021 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634593710;
         x=1636408111; bh=uUPYMrtOJm2rHMpvzJ3m9Rdjkq3XzCCdHv6u3Ll1EGw=; b=
        rusH1TlE+UqR45HL4Ig41D8uu9trwqb54MXhsbwXIfP7CU7PyWeR4QpflqZNWIDJ
        DEMwzbBacwHjgBf2/iP1hoxofRX5V7lKpFiAFHZHcgPqn0gBT2hWh9rgjFP5n8M+
        pOQ4aifE+dAFtaUESC0hdUFw0xjnq6EITY0Apl4eF2o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CSlkzp4ZANJW; Tue, 19 Oct 2021 00:48:30 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 23BA341243;
        Tue, 19 Oct 2021 00:48:29 +0300 (MSK)
Received: from yadro.com (10.178.120.186) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 19
 Oct 2021 00:48:28 +0300
Date:   Tue, 19 Oct 2021 00:48:28 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YW3rrNjMVAbXVn4F@yadro.com>
References: <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com>
 <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
 <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
 <YW2vvr8CpBzRPRNP@yadro.com>
 <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5731ecf9-f99f-f397-aad1-fe8b142c2748@oracle.com>
X-Originating-IP: [10.178.120.186]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 03:20:40PM -0500, Mike Christie wrote:
> On 10/18/21 12:32 PM, Konstantin Shelekhin wrote:
> > On Mon, Oct 18, 2021 at 11:29:23AM -0500, Mike Christie wrote:
> >> On 10/18/21 6:56 AM, Konstantin Shelekhin wrote:
> >>> On Thu, Oct 14, 2021 at 10:18:13PM -0500, michael.christie@oracle.com wrote:
> >>>>> If I understand this aproach correctly, it fixes the deadlock, but the
> >>>>> connection reinstatement will still happen, because WRITE_10 won't be
> >>>>> aborted and the connection will go down after the timeout.> 
> >>>>> IMO it's not ideal either, since now iSCSI will have a 50% chance to
> >>>>> have the connection (meaning SCSI session) killed on arbitrary ABOR
> >>>>
> >>>> I wouldn't call this an arbitrary abort. It's indicating a problem.
> >>>> When do you see this? Why do we need to fix it per cmd? Are you hitting
> >>>> the big command short timeout issue? Driver/fw bug?
> >>>
> >>> It was triggered by ESXi. During some heavy IOPS intervals the backend
> >>> device cannot handle the load and some IOs get stuck for more than 30
> >>> seconds. I suspect that ABORT TASKSs are issued by the virtual machines.
> >>> So a series of ABORT TASK will come, and the unlucky one will hit the
> >>> issue.
> >>
> >> I didn't get this. If only the backend is backed up then we should
> >> still be transmitting the data out/R2Ts quickly and we shouldn't be
> >> hitting the issue where we got stuck waiting on them.
> > 
> > We stuck waiting on them because the initiator will not send Data-Out
> 
> We are talking about different things here. Above I'm just asking about what
> leads to the cmd timeout.
> 
> You wrote before the abort is sent the backend gets backed up, and the back
> up causes IO to take long enough for the initiator cmd timeout to fire.
> I'm asking why before the initiator side cmd timeout and before the abort is sent,
> why aren't R2T/data_outs executing quickly if only the backend is backed up?
>
> Is it the bug I mentioned where one of the iscsi threads is stuck on the
> submission to the block layer, so that thread can't handle iscsi IO?
> If so I have a patch for that.

On that I'm not sure, I haven't checked the socket contents itself.
Let's try the patch! I can test it tomorrow morning.
 
> I get that once the abort is sent we hit these other issues.
> 
> 
> > PDUs after sending ABORT TASK:
> > 
> >   1. Initiator sends WRITE CDB
> >   2. Target sends R2T
> >   3. Almost immediately Initiator decides to abort the request and sends
> 
> Are you using iscsi in the VM or in the hypervisor? For the latter is
> timeout 15 seconds for normal READs/WRITEs? What version of ESXi?

The Linux server is attach to the ESXi 6.7, both physical. The ESXi
connects the datastore over iSCSI and hosts a bunch of different VMs.
Mostly Linux VMs AFAIR. The timeouts are all defaults, but I am not sure
that ABORT TASKs are generated by the ESXi itself and not by some of the
guests.

> >      ABORT TASK without sending any further Data-Out PDUs (maybe except for
> >      the first one); I believe it happens because the initiator tries to
> >      abort a larger batch of requests, and this unlucky request is just
> >      the last in series
> >   4. Target still waits for Data-Out PDUs and times out on Data-Out timer
> > 
> > The problem is that between #3 and #4 there is no code that will
> > actually abort the task, meaning stopping the Data-Out timer, sending
> > the responses if TAS is requires and so on.
> > 
> >>>>> TASK. While I'm sure most initiators will be able to recover from this
> >>>>> event, such drastic measures will certanly cause a lot of confusion for
> >>>>> people who are not familiar with TCM internals
> >>>> How will this cause confusion vs the case where the cmd reaches the target
> >>>> and we are waiting for it on the backend? In both cases, the initiator sends
> >>>> an abort, it times out, the initiator or target drop the connection, we
> >>>> relogin. Every initiator handles this.
> >>>
> >>> Because usually (when a WRITE request is past the WRITE PENDING state)
> >>
> >> Ah I think we were talking about different things here. I thought you meant
> >> users and I was just saying they wouldn't see a difference. But for ESXi
> >> it's going to work differently than I was thinking. I thought the initiator
> >> was going to escalate to LUN RESET then we hit the issue I mention
> >> below in the FastAbort part of the mail where we end up dropping the
> >> connection waiting on the data outs.
> > 
> > Oh, I see.
> > 
> >>> the ABORT TASK does not trigger relogin. In my experience the initiator
> >>> just waits for the TMR completion and goes on.
> >>>
> >>> And from a blackbox perspective it looks suspicious:
> >>>
> >>>   1. ABORT TASK sent to WRITE_10 tag 0x1; waits for it's completion
> >>>   2. ABORT TASK sent to WRITE_10 tag 0x2; almost immediately the connection is dropped
> >>
> >>
> >> I didn't get this part where the connection is dropped almost immediately.
> >> If only the backend is backed up, what is dropping the connection right
> >> away? The data out timers shouldn't be firing right? It sounds like above
> >> the network between the initiator and target were ok so data outs and R2Ts
> >> should be executing quickly like normal right?
> > 
> > I was talking about the patch you proposed. Waiting for the Data-Out
> > timeout means that the reconnection will be triggered. And this creates
> > duality of a sort. If ABORT TASK was issued after we received all the
> > Data-Out PDUs, the target will wait for the WRITE request to complete.
> > But if we didn't receive them, the target will just wait unless the
> > Data-Out timer expires and close the session>  
> >>> The only difference between #1 and #2 is that the command 0x1 is past
> >>> the WRITE PENDING state.
> >>>
> >>>> With that said I am in favor of you fixing the code so we can cleanup
> >>>> a partially sent cmd if it can be done sanely.
> >>>>
> >>>> I personally would just leave the current behavior and fix the deadlock
> >>>> because:
> >>>>
> >>>> 1. When I see this happening it's normally the network so we have to blow
> >>>> away the group of commands and we end up dropping the connection one way
> >>>> or another. I don't see the big command short timeout case often anymore.
> >>>>
> >>>> 2. Initiators just did not implement this right. I know this for sure
> >>>> for open-iscsi at least. I started to fix my screw ups the other day but it
> >>>> ends up breaking the targets.
> >>>>
> >>>> For example,
> >>>>
> >>>> - If we've sent a R2T and the initiator has sent a LUN RESET, what are
> >>>> you going to have the target do? Send the response right away?
> >>>
> >>> AFAIR the spec says "nuke it, there will be no data after this".> 
> >>>> - If we've sent a R2T and the initiator has sent some of the data
> >>>> PDUs to full fill it but has not sent the final PDU, then it sends the
> >>>> LUN RESET, what do you do?
> >>>
> >>> The same. However, I understand the interoperability concerns. I'll
> >>> check what other targets do
> >> I think maybe you are replying about aborts, but I was asking about
> >> LUN RESET which is opposite but will also hit the same hang if the
> >> connection is dropped after one is sent.
> >>
> >> For aborts it works like you wrote above. For LUN RESET it's opposite.
> >> In 3270, it doesn't say how to handle aborts, but on the pdl lists it
> >> came up and they said equivalent of your nuke it. However, for TMFs
> >> that affect multiple tasks they clarified it in later versions of the
> >> specs.
> >>
> >> In the original it only says how to handle abort/clear task set, but in
> >>
> >> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc5048__;!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFS95VLYa$ 
> >>
> >> the behavior was clarified and in 7143 we have the original/default
> >> way:
> >>
> >> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc7143*section-4.2.3.3__;Iw!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFcgM734S$ 
> >>
> >> which says to wait for the data outs.
> >>
> >> And then we have FastAbort which is nuke it:
> >>
> >> https://urldefense.com/v3/__https://datatracker.ietf.org/doc/html/rfc7143*section-4.2.3.4__;Iw!!ACWV5N9M2RV99hQ!YiQjBP1k-nr1NNEI8Cyc2MEwcl5cd_eYzOONU5pcJMTx34q95jrx6zPUrrXfFXbAD6Jb$ 
> > 
> > For Target it says the following even for ABORT TASK:
> > 
> >   a) MUST wait for responses on currently valid Target Transfer Tags
> >      of the affected tasks from the issuing initiator. MAY wait for
> >      responses on currently valid Target Transfer Tags of the affected
> >      tasks from third-party initiators.
> 
> Where do you see "ABORT TASK" in there? That RFC chunk from 4.2.3.3;
> 
> https://datatracker.ietf.org/doc/html/rfc7143#section-4.2.3.3
> 
> lists the TMFs it covers:
> 
> The execution of ABORT TASK SET, CLEAR TASK SET, LOGICAL UNIT RESET, TARGET
> WARM RESET, and TARGET COLD RESET TMF  Requests
> 
> But in the link, the "SET" part of "ABORT TASK SET" is on the next line so
> you might have just scanned over it wrong.

I'm sorry, you are right, ABORT TASK SET.
 
> > 
> > So either ESXi violates the RFC or just not RFC7143 compliant. However
> > I'm getting hit with this even on Linux. I'll try to get some TCP dumps.
> 
> Linux is wrong for different reasons and was why I was saying initiators
> just did not do things right and you can get a crazy mix of behavior.
> I basically programed it for how targets were working and not being strict
> RFC wise.
> 
> 1. For aborts, it will send the abort then not send anything else.
> 
> 2. For LUN/target resets, it "sort of" does FastAbort. I wrote the linux
> code before FastAbort was a thing so it's all messed up. Basically, we
> send the LUN RESET, then the default is to just stop sending DataOuts
> for WRITEs.
> 
> However, we implemented that code before RFC 7143 so we don't negotiate
> for TaskReporting. It's just a iscsid.conf setting node.session.iscsi.FastAbort.

Well, that makes things clearer, thanks.
