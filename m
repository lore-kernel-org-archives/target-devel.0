Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C31C433EF
	for <target-devel@archiver.kernel.org>; Tue, 26 Oct 2021 10:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F8360C4A
	for <target-devel@archiver.kernel.org>; Tue, 26 Oct 2021 10:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhJZLCO (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 07:02:14 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:34806 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235284AbhJZLCN (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 07:02:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BB7F945C13;
        Tue, 26 Oct 2021 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1635245982;
         x=1637060383; bh=YpYga28SNnq2FOCuyJZAgLjf2mjMoqqvKnRMtlLt34Q=; b=
        EnBMLVoxVQIRFAAyQsdSG7JykvxPHxzRDhznPMJySMMriPn3XLRJ89zm4p7ipHsp
        R4EQiLZwYSPH/T9LORV6dRMQgw0Rob/JnXxMzISG4NyfP0qoPhwQ5x43KlfRJwnM
        hWHhKEQM/4jjoxPv6jwlX/mz8OqQHoZiTVbjdy9l40k=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9fGJ8N-W8t3j; Tue, 26 Oct 2021 13:59:42 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EA12345C3A;
        Tue, 26 Oct 2021 13:59:30 +0300 (MSK)
Received: from yadro.com (10.178.112.148) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 26
 Oct 2021 13:59:20 +0300
Date:   Tue, 26 Oct 2021 13:59:13 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YXffgScv1djx6zP/@yadro.com>
References: <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com>
 <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
 <YWi5YumbN/Zzze5h@yadro.com>
 <d5035453-f35f-0ecf-d830-18c6b3040c97@oracle.com>
 <YW1g/OFXMHq44CYo@yadro.com>
 <2318e7d3-84c1-e5b0-62ce-dd25a21d3476@oracle.com>
 <e4754a5e-9c40-993d-d21e-e566f0cb244d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e4754a5e-9c40-993d-d21e-e566f0cb244d@oracle.com>
X-Originating-IP: [10.178.112.148]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 12:08:26PM -0500, Mike Christie wrote:
> Oh wait, I just remembered the bug you might be hitting. If you
> are using iblock for example, then when the iscsi target calls
> into LIO core to submit the cmd we can end up calling into the block
> layer and blocking on a full queue (hitting the nr_requests limit).
> The iscsi layer is then not able to do its normal R2T/DataOut handling
> because one of the iscsi threads is stuck.
> 
> I'll send a patch to fix this issue.

Can you please send me a patch so I could test it?
