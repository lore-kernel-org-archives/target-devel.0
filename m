Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BEDC433E6
	for <target-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20B564E79
	for <target-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhBJO06 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 09:26:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231694AbhBJO04 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 09:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612967129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjqdGl9gBCtzXZ4MgSNybS3a2eF3BdoT/sWONctal1Y=;
        b=OAlJnIcQZRxdf2X7LLAhTVFSAl6P9N1Ab8epz0HFSHPr0M9BV/V/+lndahqyjnhrG5TV95
        6k9vkix99TNWUQJU15A/18XMT5SdHavb7tiJL47rGIb2yVbMHfgV/YncerVAq2AnYTqOyz
        d7fkfx8Z8nsS0rt34VxlZM1r/cnd8+0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-kREAgK5SOpO4HAXiujffWQ-1; Wed, 10 Feb 2021 09:25:28 -0500
X-MC-Unique: kREAgK5SOpO4HAXiujffWQ-1
Received: by mail-qk1-f198.google.com with SMTP id p185so1653412qkc.9
        for <target-devel@vger.kernel.org>; Wed, 10 Feb 2021 06:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AjqdGl9gBCtzXZ4MgSNybS3a2eF3BdoT/sWONctal1Y=;
        b=l8aReHntrmgVyHJ408rJ3IgZFFDqVQYzbS+gamC0JQSmKEiBGjocd6mW2n323xh2eD
         iCsX354KFUAne7/oe38rZHS64ydGMh49S96sug7AwaNNDUFeeJo6GcBfFAtM1iIl89Zh
         cNRd3f5awYfymaTVx/zPlx3Vz+ov+gyauCbbbvXdnT73a3pwdvy628OiMMhWmW1FvTfz
         MH/0r+5Fdm1c68pF0r50mGant2epY9V46Mvmz/HbOeyLwygnNVEWAHy5ZnEmh/SHvoCn
         L+BC4sf784h3pvzpJv5O4utaGePzXyVWW1h3xKpmUsqO0sKncUbsnV+XyBU6XVmGmk0C
         gopQ==
X-Gm-Message-State: AOAM530ilZJnIL/mo0U5DlVPfHo+QEatoXz6XKeFUG+awum+w5DA8B9n
        sfpTdok5fjpwxa1O0UUIGBjgchDCCugywgxSEA2qAXpu22hVwAJvwHHP9TEVABz9dCdhy49I3eD
        p3OBmltbxKe8aTGSnVScQ0bpt
X-Received: by 2002:a05:620a:9cf:: with SMTP id y15mr3510302qky.44.1612967126192;
        Wed, 10 Feb 2021 06:25:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7JkAwZ6eyRiwDMr8CAX5LfuNBYjtuaKgz+zlOU/JKZLXd+KP3cqaHVb8JoNaeNXiG07pxJw==
X-Received: by 2002:a05:620a:9cf:: with SMTP id y15mr3510272qky.44.1612967125918;
        Wed, 10 Feb 2021 06:25:25 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id p188sm1520751qkf.89.2021.02.10.06.25.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:25:25 -0800 (PST)
Message-ID: <f11dbbf675281cacd80044cb8600bd3ba6684dc2.camel@redhat.com>
Subject: Re: [PATCH 13/13] target: flush submission work during TMR
 processing
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Date:   Wed, 10 Feb 2021 09:25:23 -0500
In-Reply-To: <679c61cf1dad2848edac6f7d6490ad6587f0ada3.camel@redhat.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
         <20210209123845.4856-14-michael.christie@oracle.com>
         <679c61cf1dad2848edac6f7d6490ad6587f0ada3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, 2021-02-09 at 09:31 -0500, Laurence Oberman wrote:
> On Tue, 2021-02-09 at 06:38 -0600, Mike Christie wrote:
> > If a cmd is on the submission workqueue then the TMR code will
> > miss it, and end up returning task not found or success for
> > lun resets. The fabric driver might then tell the initiator that
> > the running cmds have been handled when they are about to run.
> > 
> > This adds a cancel when we are processing TMRs.
> > 
> > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > ---
> >  drivers/target/target_core_tmr.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/target/target_core_tmr.c
> > b/drivers/target/target_core_tmr.c
> > index 7347285471fa..9b7f159f9341 100644
> > --- a/drivers/target/target_core_tmr.c
> > +++ b/drivers/target/target_core_tmr.c
> > @@ -124,6 +124,8 @@ void core_tmr_abort_task(
> >  	int i;
> >  
> >  	for (i = 0; i < dev->queue_cnt; i++) {
> > +		cancel_work_sync(&dev->queues[i].sq.work);
> > +
> >  		spin_lock_irqsave(&dev->queues[i].lock, flags);
> >  		list_for_each_entry_safe(se_cmd, next, &dev-
> > > queues[i].state_list,
> > 
> >  					 state_list) {
> > @@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
> >  	 * in the Control Mode Page.
> >  	 */
> >  	for (i = 0; i < dev->queue_cnt; i++) {
> > +		cancel_work_sync(&dev->queues[i].sq.work);
> > +
> >  		spin_lock_irqsave(&dev->queues[i].lock, flags);
> >  		list_for_each_entry_safe(cmd, next, &dev-
> > > queues[i].state_list,
> > 
> >  	
> 
> 
> > 				 state_list) {
> 
> Hello Mike
> Thanks for these
> This one in particular is the one that I think will help our case. I
> will pull all of these and test later this week as a bundle.
> 
> Many Thanks
> Laurence Oberman
> 

I pulled v2 and built a test kernel to start the testing but I see
Christoph has also suggested changes as well to your v3 submission.

I will wait until we are finalized and then do a full test.

Thanks
Laurence

