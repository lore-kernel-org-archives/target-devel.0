Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D347C433EF
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8227261139
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhJMSNe (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 14:13:34 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:46334 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233925AbhJMSNa (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 14:13:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 28F974135C;
        Wed, 13 Oct 2021 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634148685;
         x=1635963086; bh=IvuyokS5gmdcBzy/vTtZrU2GcocAjtLj0BY4cpICoKQ=; b=
        NWmt1fBY4p50zuzugFFK7Uz4oKXPeLbQhcjUjCzw3DO/v07jfUfkcK4IxCjU2BQr
        bZPTPeDMRPWItfRtj1EwWM9KfdglLU7VPMeLhqEcrpzIER5kC/tvsqDf9odRwYff
        BffSMQGRbsKuDZk6fkQNzQlIk8tZREi+xnPkptm9m18=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vIso1g3b_L6P; Wed, 13 Oct 2021 21:11:25 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 46BF741333;
        Wed, 13 Oct 2021 21:11:24 +0300 (MSK)
Received: from yadro.com (10.199.12.215) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 13
 Oct 2021 21:11:24 +0300
Date:   Wed, 13 Oct 2021 21:11:23 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YWchS0EpcqYjf7Oe@yadro.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <b49d2f3b-4762-832f-55ff-7543e08f387b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b49d2f3b-4762-832f-55ff-7543e08f387b@oracle.com>
X-Originating-IP: [10.199.12.215]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 01:05:26PM -0500, Mike Christie wrote:
> On 10/13/21 12:51 PM, Mike Christie wrote:
> Another alternative would be to have iscsi check if it was waiting on
> data before sending a TMR to LIO core. If it is, then it would just cleanup
> internally and complete the TMR with success/failed depending on the TMR or
> drop it and let the initiator escalate.

I was thinking about that, but there is some TAS code that requires the
proper response from the aborted command. Also the ABORT TASK execution
path kinda allows ABORT TASK to be aborted itself. I'm not sure if
that's code has any meaning now, but if it does, then clearing WRITE_10
early may not be a valid action from the SCSI protocol point of view.
