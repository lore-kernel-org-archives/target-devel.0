Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC28DC77B7A
	for <target-devel@archiver.kernel.org>; Wed, 24 May 2023 13:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbjEXN56 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 24 May 2023 09:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjEXN56 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 24 May 2023 09:57:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40492122
        for <target-devel@vger.kernel.org>; Wed, 24 May 2023 06:57:54 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 7D2CC342617;
        Wed, 24 May 2023 16:57:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=LsnRHZad9YUPdse7iH5nPiOlNq8oowMMQ8yfDIfZIio=; b=
        EtYsA+sszQ1+mJH7DXBIwectCEOBn36llmyBNLTw47bSpyWkBJG7doNd3N0xq6Vv
        LsQY6ztN22hsI9ijQZf5hK7LbGU9zm9MICKvvHlpMl+xvpMmzj7ssSf3wStzRCva
        kOXEqehme5L01W8ELjUrih7FJjl4Q5og5hCxt9ev0Ec=
Received: from T-EXCH-07.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 74A7B341F25;
        Wed, 24 May 2023 16:57:52 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 24 May 2023 16:57:51 +0300
Received: from yadro.com (10.178.192.41) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 24 May
 2023 16:57:50 +0300
Date:   Wed, 24 May 2023 16:57:49 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>
Subject: Re: SCSI target logs
Message-ID: <ZG4X3ayUbTERxaef@yadro.com>
References: <ZF0MiCRW8HWm8YYj@yadro.com>
 <3b0540bc-28f8-70d2-d6e5-755f15005cb8@oracle.com>
 <ZGnmKCzlijw9W-qt@yadro.com>
 <91f502dc-6d31-2d09-bec4-276851221b56@oracle.com>
 <ZG3Q1eHXwnQCFbYL@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG3Q1eHXwnQCFbYL@yadro.com>
X-Originating-IP: [10.178.192.41]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, May 24, 2023 at 11:54:45AM +0300, Konstantin Shelekhin wrote:
> We can do the very same thing with this:
> 
>   pr_fmt(fmt) "target <fabric-name>": fmt
> 
> but then we will have one extra ":" here:
> 
>   target_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
>   [Thu May 11 00:00:00 2023] target iscsi: [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.
> 
> Dunno how much of an OCD issue this is :D

Disregard this, we can't do this with pr_fmt() because theree is no way
to hook in between "target <fabric-name" and fmt.

