Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E489C4167B
	for <target-devel@archiver.kernel.org>; Fri, 25 Nov 2022 09:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKYJeQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYJeQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 04:34:16 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F113B1F9C4
        for <target-devel@vger.kernel.org>; Fri, 25 Nov 2022 01:34:14 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4DAC84120A;
        Fri, 25 Nov 2022 09:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1669368852; x=1671183253; bh=7/qeemYYYm7xv4mOri41YsRo5YKmZL0L/+x
        X7iLDz7g=; b=TI86ZHHPVbcnHe0bdgA7HSyeyYoP3Q7x9C+mQT3TyiGCHY4uNuS
        r6mfSEIAZoBUTo5i4mpGng6tenpV3hA6umlGb6ZTFFxNQlTlbu5DILEp0LvlK+tu
        LGif7Plo0KR8imb2+hCLBghWy5SQFa0lqOzKSMNcESlEvT3OrDwoI7EI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0uoa1C7NiwDV; Fri, 25 Nov 2022 12:34:12 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E8B2341207;
        Fri, 25 Nov 2022 12:34:11 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 25 Nov 2022 12:34:11 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 25 Nov
 2022 12:34:10 +0300
Date:   Fri, 25 Nov 2022 12:34:10 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Bodo Stroesser <bostroesser@gmail.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        <target-devel@vger.kernel.org>
Subject: Re: tcm_loop and aborted TMRs
Message-ID: <20221125084920.GC5248@yadro.com>
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Nov 21, 2022 at 01:25:55PM -0600, Mike Christie wrote:
> 
> On 11/21/22 7:35 AM, Dmitry Bogdanov wrote:
> >>
> > I will vote to your old patch. qla2xxx was fixed long time ago.
> 
> What is the qla fix? I think we still leak. In commit
> 
> commit 605e74025f953b995a3a241ead43bde71c1c99b5
> Author: Mike Christie <michael.christie@oracle.com>
> Date:   Sun Nov 1 12:59:31 2020 -0600
> 
>     scsi: qla2xxx: Move sess cmd list/lock to driver
> 
> when I changed the locking I had added the check:
> 
> static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
> {
>         struct qla_tgt_cmd *cmd;
>         unsigned long flags;
> 
>         if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
>                 return;
> 
Yes, I was thinking about that commit.
> because tmrs are not on the sess_cmd_list that's accessed the
> next line down. We don't crash as a result, but I think we need
> to add code to send the cleanup command to the FW. Bodo and I
> were working on that part, but someone with more qla experience
> needed to work on it so it could be properly tested. We didn't
> hear back from the qla engineers so progress had stalled.
> 
Yes, you are right, FW expects some response on every ABORT IOCB
to clear its resources.

I can prepare the patch for qla2xxx.

But still, I do not see a sense of new Bodo's solution.
Calling target_put_sess_cmd due to SCF_ACK_REF forbids any async long
term work in fabric drivers in aborted_task callback. It is
intentionally. qla2xxx does not require to wait for the completion of
all requests to FW. All terminate exchange requests are such.

SAM-5 states that an aborted(due to LUN_RESET) TMR should not be
responded to initiator:

7.11 Task management function lifetime
 The task management function shall exist until:
  a) the task manager sends a service response for the task management function;
  b) an I_T nexus loss (see 6.3.4);
* c) a logical unit reset (see 6.3.3);
  d) a hard reset (see 6.3.2);
  e) power loss expected (see 6.3.5); or
  f) a power on condition (see 6.3.1)


BR,
 Dmitry

