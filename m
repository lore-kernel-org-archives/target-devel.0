Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6D8C4332F
	for <target-devel@archiver.kernel.org>; Mon, 21 Nov 2022 13:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiKUNg2 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 08:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiKUNgU (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 08:36:20 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7929DC2853
        for <target-devel@vger.kernel.org>; Mon, 21 Nov 2022 05:36:18 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 00C5E403CB;
        Mon, 21 Nov 2022 13:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1669037774; x=1670852175; bh=Y1ayMf0SKeR2t+8fZ4Ks/D/1xVFM0JFhVny
        0ox1SLX0=; b=EoB5L6je6i0x5B5EwTbD7li4Bhm8dwIiiogHgG+5hFIslN4zlys
        OFXR4CITBIDnLuqXfg1KECSH1Bq7DtEFOgqoBohvmwVjPvaOty//XwPJP4FoLAEb
        AjRu9oZSmavUCUZLVnjjUAmoeaeCPYohlwjyIkBdUezNL5Bq0BaGYYEU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DjYd4TSHIzsB; Mon, 21 Nov 2022 16:36:14 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8458F40354;
        Mon, 21 Nov 2022 16:36:13 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 21 Nov 2022 16:36:13 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 21 Nov
 2022 16:36:12 +0300
Date:   Mon, 21 Nov 2022 16:35:50 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Bodo Stroesser <bostroesser@gmail.com>
CC:     Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        <target-devel@vger.kernel.org>
Subject: Re: tcm_loop and aborted TMRs
Message-ID: <20221121133550.GB5248@yadro.com>
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


Hi Bodo,

On Sat, Nov 12, 2022 at 02:59:48PM +0100, Bodo Stroesser wrote:
> 
> Hello Mike, Maurizio,
> 
> Even if we couldn't yet find a method to fix handling of aborted
> TMRs in the core or in all fabric drivers, I still think that keeping
> the parallel handling of TMRs would be fine.
> 
> Tcmu offers a TMR notification mechanism to make userspace aware
> of ABORT or RESET_LUN. So userspace can try to break cmd handling
> and thus speed up TMR response. If we serialize TMR handling, then
> the notifications are also serialized and thus lose some of their
> power.
> 
> But maybe I have a new (?) idea of how to fix handling of aborted
> TMRs in fabric drivers:
> 1) Modify core to not call target_put_sess_cmd, no matter whether
>    SCF_ACK_REF is set.
> 2) Modify fabric drivers to handle an aborted TMR just like a
>    normal TMR response. This means, e.g. qla2xxx would send a
>    normal response for the Abort. This exactly is what happens
>    when serializing TMRs, because in that case despite of the
>    RESET_LUN the core always calls queue_tm_rsp callback instead
>    of aborted_task callback.
I am not sure for all initiators, but usually it sends LUN_RESET only
after ABORT has been timed out. There is no reason to send a response on
the ABORT that was actually aborted already internally on the initiator
side.
 
> So to initiators we would show the 'old' behavior, while internally
> keeping the parallel processing of TMRs.
> 
> If fabric driver maintainers don't like that approach, they can
> change their drivers to correctly kill aborted TMRs.
> 
> What do you think?
> 
I will vote to your old patch. qla2xxx was fixed long time ago. Other
fabric drivers have not that issue too. Only tcm_loop and xen still do
not adapted for parallel TMRs.

I think it's a not good idea to revert 2 years old patch. It was a
reason for some other patches (that fixes issues thanks to parallel TMR
handling).

> 
> On 11.11.22 22:18, Mike Christie wrote:
> > On 11/11/22 10:20 AM, Maurizio Lombardi wrote:
> > > Hello Bodo, Mike,
> > > 
> > > Some of our customers reported that the tcm_loop module is unable
> > > to handle aborted TMRs, resulting in kernel hangs.
> > > 
> > > I noticed that Bodo submitted a patch some time ago (our customers
> > > confirm it works),
> > > Mike instead proposed to revert
> > > commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".
> > > 
> > > The discussion unfortunately died out without reaching a conclusion.
> > > 
> > > Personally, I think that if the handling of aborted TMRs was working
> > > before the "Use system workqueues" commit then this should be
> > > considered as a regression and the commit should be reverted.
> > > 
> > 
> > I'm fine with reverting it because multiple drivers are affected. I had
> > talked to Bart offlist back then and he was also ok since we couldn't
> > fix up the drivers.
> > 
> > I think Bodo and I tried to convert qla, but it was difficult without
> > marvell's help (we both pinged them but didn't hear back) because from
> > what I could tell we needed to send some hw/fw commands to perform cleanup
> > to fully handle that case.
