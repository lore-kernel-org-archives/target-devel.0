Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8957FC77B73
	for <target-devel@archiver.kernel.org>; Wed, 24 May 2023 08:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjEXIzC (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 24 May 2023 04:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbjEXIyz (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 24 May 2023 04:54:55 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF3018B
        for <target-devel@vger.kernel.org>; Wed, 24 May 2023 01:54:53 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 8DBF4342452;
        Wed, 24 May 2023 11:54:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=RuCQbDOxGDIx3vIHljI1e/xLIOloyI9CYVah9YlAT0k=; b=
        IlrzvSGQgPFQf8PFFswUDsEXqTv+zkl0KWmysC3vi6cY/+P7tnhxt5UcCEHfPF+X
        RhUgNe8/Z9xh3Ein4Ms/W9DC0p+vc4RBguDgcHKLy89KXfsrAi1b88CFm2vnXrWt
        dbatZ2dZT8Ba/5ILsdHTXkm7lCjFYpoFVU1Oq+zVv1Y=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 82E8034242D;
        Wed, 24 May 2023 11:54:49 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 24 May 2023 11:54:49 +0300
Received: from yadro.com (10.178.192.41) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 24 May
 2023 11:54:48 +0300
Date:   Wed, 24 May 2023 11:54:45 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>
Subject: Re: SCSI target logs
Message-ID: <ZG3Q1eHXwnQCFbYL@yadro.com>
References: <ZF0MiCRW8HWm8YYj@yadro.com>
 <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
 <ZGnmKCzlijw9W-qt@yadro.com>
 <91f502dc-6d31-2d09-bec4-276851221b56@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <91f502dc-6d31-2d09-bec4-276851221b56@oracle.com>
X-Originating-IP: [10.178.192.41]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, May 23, 2023 at 10:40:25AM -0500, Mike Christie wrote:
> > We have MODULE_ALIAS(), so it's possible to do something similar to
> > drivers/md/raid5.c:
> 
> Ah ok, nice.
> 
> What is the target_core_fabric_ops->fabric_name going to be?
> 
> I think that can't change or it will break userspace tools like rtslib/targetlci
> right? It would change the /sys/kernel/config/target/$fabric_name path?

Yeah, we surely can't do that.
 
> Do you want the module level error message to match to the fabric_name
> or the module name? I think the fabric_name is nicer, because it's what
> the users normally use to interact with the tools/kernel.
> 
> Other than that, I think it's ok.

Actually the whole module renaming idea came to me after studying the
NVMe target code, because of how neatly the module names reflect the
code units. As for the SCSI target, maybe instead of using module names
we can do something similar to what device mapper does with DM_PREFIX
and get away with simply stating this in core modules:

  TARGET_PREFIX core

This in fabric modules:

  TARGET_PREFIX <fabric-name>

And this in backstore modules:

  TARGET_PREFIX <bs-name>

So the resulting messages would be something like this:

  target_err("This module blew up\n")
  [Thu May 11 00:00:00 2023] target iser: This module blew up

  target_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
  [Thu May 11 00:00:00 2023] target iscsi [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.

We can do the very same thing with this:

  pr_fmt(fmt) "target <fabric-name>": fmt

but then we will have one extra ":" here:

  target_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
  [Thu May 11 00:00:00 2023] target iscsi: [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.

Dunno how much of an OCD issue this is :D

