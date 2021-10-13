Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F7FC433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62A9610E6
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhJMOzS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:55:18 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36590 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230015AbhJMOzQ (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 10:55:16 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B7B4A43F3F;
        Wed, 13 Oct 2021 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634136789;
         x=1635951190; bh=Ggh/GXC5uPjyZz7uetrppb3iP7gE6G353x+cWaWtFj4=; b=
        OF9NuEI8o8sSC8+6Hn09w4Zq6wGx3mf+ugpJ0MaOdtXmCZFaEC6qxUWM1RDv1g+7
        sYMuwmuKS80vT9cJrPWM/klN/H3fLus6IVhYwVooKPREG226LbF8eSpkjv6eld6w
        HFZAEtNkP2+3WoiV8yrr/M+7XLy2UOyl0g2KPJIE9hc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GLPN7l-aUMHd; Wed, 13 Oct 2021 17:53:09 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A6BE14131C;
        Wed, 13 Oct 2021 17:53:09 +0300 (MSK)
Received: from yadro.com (10.199.12.215) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 13
 Oct 2021 17:53:09 +0300
Date:   Wed, 13 Oct 2021 17:53:08 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YWby1FD69Sz4W8eX@yadro.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <2a819e5d-c77a-94e8-1fe2-0ba81e7c9fa3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2a819e5d-c77a-94e8-1fe2-0ba81e7c9fa3@suse.de>
X-Originating-IP: [10.199.12.215]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 04:22:41PM +0200, Hannes Reinecke wrote:
> On 10/13/21 3:21 PM, Konstantin Shelekhin wrote:
> Short answer: you can't.
> 
> There is no feasible path in the I/O stack to abort running I/O; the
> only chance you have here is to wait for it to time-out.
>
> We have run into similar issues, and found that the only sane solution
> was to wait for the I/O to come back and then retry.
> As this would take some time (30 seconds if you are unlucky) most
> initiators will get unhappy and try to reset.
> Which won't work, either, as the I/O is still stuck.
> So we finally delayed relogin until all I/O was cleared.
> 
> Not the best solution, but the only thing we can do in the absense of a
> proper I/O abort mechanism.

I'm not sure we are talking about the same bug. In this case the relogin
is not possible, because new connections are rejected by the target and
the existing one is not going anywhere, because it's deadlocked on ABORT
TASK. The only solution is to reset the server.
