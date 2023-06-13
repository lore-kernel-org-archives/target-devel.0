Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45FBC77B7A
	for <target-devel@archiver.kernel.org>; Tue, 13 Jun 2023 04:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbjFMEho (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 13 Jun 2023 00:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbjFMEhk (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 13 Jun 2023 00:37:40 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Jun 2023 21:37:38 PDT
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A372992
        for <target-devel@vger.kernel.org>; Mon, 12 Jun 2023 21:37:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com EFD47C002A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1686628876; bh=hYGehE7r0HhDytRHf6zPyx5C9S2nk+Q2I/xRg8qXwGg=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
        b=F+nmwkSN/kZ4YeuZU3eFJSHQAgtGNz1j0besBJFBBlG6USanrPzbxKpyp7w5Smons
         aYzlYXcKscesobR0ihSaWUhIoI4n8hVJB2wIKWrBcOrKJ+AHbG8effFlv0BAgNrftE
         +4sszgfZ7gzaxAaniUHKTcy3sVSA3utYaul2wyGq9PhsleX0Eajldyj9lbsEmv05i/
         w/BzwpTp86tHHGWHxsbY0hvD8l80SKwha3Hkp45V5EMBby0v+dNfjTTo56AzLqH6p1
         cV+ydvxV1xmY0Bphpy94aEtsaeZ0nEqKkRUfDRN8jJgQpvVm4Qsth1yWbGpriNTpy2
         rVwjNZtytciYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1686628876; bh=hYGehE7r0HhDytRHf6zPyx5C9S2nk+Q2I/xRg8qXwGg=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
        b=FndQIiYXMryMf/74RQSyKwaYVv0P5ta6504JcMlSABrpteMR9vyqkAvPQlFUA5s0W
         TXztXK2aYQVeh+9tOjngFezUL+090HLfRxvGJXr1w0hSjAK2YKHk0OuxfcKX1ch7eA
         cCRZ1GV2orcworpPdHsZ18IiLxutwuNeB0rjy0ssO5lCfupuoWtKt0k//gdBJ8+FZl
         ouXuha57RQlgxtALFfQo7o0Fbatbo/c6AjU+1fNNOCYtYsRt5oroayjCZMmc726plO
         m0umgcF6zxhzNJW6l0ZE5k/FAHWyIXhnpeGUZdfbp9JTuJ9Pj8YApCO/zGHogjSIZv
         Ttdh3mcrGhYGA==
Date:   Tue, 13 Jun 2023 07:01:15 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     Lu Hongfei <luhongfei@vivo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:SCSI TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
Subject: Re: [PATCH] drivers: target: Fix the conversion to bool in
 iblock_execute_pr_out
Message-ID: <ZIfqC6xXn6uWvTPd@yadro.com>
References: <20230612081006.40821-1-luhongfei@vivo.com>
 <53382bf3-69eb-b297-70ea-22571b877a2f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53382bf3-69eb-b297-70ea-22571b877a2f@nvidia.com>
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Jun 12, 2023 at 10:04:28AM +0000, Chaitanya Kulkarni wrote:
> On 6/12/23 01:10, Lu Hongfei wrote:
> > The return value of the '==' or '!=' operator are bool, so there's
> > no need to convert it to bool again in iblock_execute_pr_out.
> >
> > Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
> > ---
> >   drivers/target/target_core_iblock.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> > index 254c33c9788e..ea42cb5d06d4
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -889,7 +889,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
> >
> >               ret = ops->pr_preempt(bdev, key, sa_key,
> >                                     scsi_pr_type_to_block(type),
> > -                                   sa == PRO_PREEMPT ? false : true);
> > +                                   sa != PRO_PREEMPT);
> >               break;
> >       case PRO_RELEASE:
> >               if (!ops->pr_clear) {
> 
> this not a fix as current code is not broken ..

It looks much better though. And it's easier to understand.
