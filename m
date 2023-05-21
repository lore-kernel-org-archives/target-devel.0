Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C0CC77B73
	for <target-devel@archiver.kernel.org>; Sun, 21 May 2023 09:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjEUJhR (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 21 May 2023 05:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjEUJhH (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 21 May 2023 05:37:07 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D402611F
        for <target-devel@vger.kernel.org>; Sun, 21 May 2023 02:36:46 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id D5E443421BE;
        Sun, 21 May 2023 12:36:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=UOqTjs7BhsCBRNw1War/b+3NtBWhakvucFxI0/Wcqnc=; b=
        YCNnpeVQ1nlDnvrZ0m64e5V4bbZc5uOTpUxEnDLMneMP4RzW9wivo9fKKZH5zEbh
        G2+F8WdySBWFYrBB/gRHKD+dRBu4wxsqFjBtn+GY7R1fbP/0kd9FThLjXGAubuHU
        upYSZWp5uzHoBBQ8oNCtg4lkpltbqvuvzz6bRoMupwY=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id C2F86342087;
        Sun, 21 May 2023 12:36:44 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Sun, 21 May 2023 12:36:44 +0300
Received: from yadro.com (10.178.192.41) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Sun, 21 May
 2023 12:36:42 +0300
Date:   Sun, 21 May 2023 12:36:40 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>
Subject: Re: SCSI target logs
Message-ID: <ZGnmKCzlijw9W-qt@yadro.com>
References: <ZF0MiCRW8HWm8YYj@yadro.com>
 <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
X-Originating-IP: [10.178.192.41]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Sat, May 20, 2023 at 12:56:29PM -0500, Mike Christie wrote:
> On 5/11/23 10:40 AM, Konstantin Shelekhin wrote:
> > So, my proposal. We should give all modules similar names:
> >
> >   tcm
> >   tcm_iscsi
> >   tcm_iser
> >   tcm_qla2xxx
> >   tcm_iblock
> >   tcm_loop
> >   tcm_cxgb
> 
> Do you mean you will rename the actual modules, or just have each module
> have some define with a name like "tcm_$WHATEVER" that's used in the log
> message?
> 
> I don't think we can change the actual name because scripts might do
> modprobe isert
> 
> Unless there's a way to do some sort of automatic/magic alias then it
> would be ok.

We have MODULE_ALIAS(), so it's possible to do something similar to
drivers/md/raid5.c:

  # lsmod | grep -c '^raid456'
  0
  # modprobe raid5
  # lsmod | grep '^raid456'
  raid456               204800  0
  # doas rmmod raid456
  # lsmod | grep -c '^raid456'
  0
  # doas modprobe raid6
  # lsmod | grep '^raid456'
  raid456               204800  0 
 
> > I would prefer scsit_ instead of tcm_, but I guess this ship has sailed.
> >
> > Next, let's introduce some macros: tcm_LEVEL(), tcm_sess_LEVEL() and
> 
> We've been switching new code to the "target_" prefix.

Yeah, forgot about that. target_LEVEL() and target_sess_LEVEL() then.
 
> > tcm_lun_LEVEL():
> >
> >   tcm_err("This module blew up\n")
> >   [Thu May 11 00:00:00 2023] tcm_iser: This module blew up
> >                              ^^^^^^^^
> >                              |
> >                              Module name
> >
> >   tcm_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
> >   [Thu May 11 00:00:00 2023] tcm_iscsi [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.
> >                              ^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^
> >                              |          |                                    |
> >                              |          |                                    RTPI
> >                              |          Initiator port
> >                              Module name
> >
> >   tcm_lun_err(&se_lun, "bio error %p, err: %d\n", bio, bio_status)
> >   [Thu May 11 00:00:00 2023] tcm_iblock [iqn.2023-01.com.example:blah-blah -> 10/5]: bio error: 0xfffffffff, err 10
> >                              ^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^ ^
> >                              |           |                                    |  |
> >                              |           |                                    |  MAPPED LUN
> >                              |           |                                    RTPI
> >                              |           Initiator port
> >                              Module name
> 
> Nice.

Sweet! If you approve the general idea, we'll start working on the RFC
patch series.

