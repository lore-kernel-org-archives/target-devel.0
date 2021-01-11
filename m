Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3740C433E0
	for <target-devel@archiver.kernel.org>; Mon, 11 Jan 2021 06:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B311225A9
	for <target-devel@archiver.kernel.org>; Mon, 11 Jan 2021 06:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAKGxu (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 11 Jan 2021 01:53:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:33348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbhAKGxu (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 11 Jan 2021 01:53:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5B9E3AB7A;
        Mon, 11 Jan 2021 06:53:08 +0000 (UTC)
Subject: Re: [PATCH] Remove the tcm_fc driver
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        target-devel@vger.kernel.org, Kiran Patil <kiran.patil@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>
References: <20210111004740.1786-1-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <94f1af10-11e4-9f21-c0ad-a2df60cbf521@suse.de>
Date:   Mon, 11 Jan 2021 07:53:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210111004740.1786-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/11/21 1:47 AM, Bart Van Assche wrote:
> Since its introduction in 2011, the tcm_fc driver processes SCSI read
> commands as follows if the number of remaining bytes is a multiple of four:
> - Queue data by calling fc_seq_send(). The FCoE driver translates that
>    call into a dev_queue_xmit(skb) call which sends the data asynchronously.
> - After having queued the data for sending, free the data buffer
>    synchronously from inside ft_queue_status().
> 
> This race condition can be triggered by running fio --verify against the
> FCoE initiator driver. Since this bug causes data corruption and since
> nobody has reported this bug since the tcm_fc driver went upstream, this
> is a strong indication that the tcm_fc driver is not being used. Hence
> remove this driver from the kernel tree.
> 
> Cc: Kiran Patil <kiran.patil@intel.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/target/Kconfig           |   1 -
>   drivers/target/Makefile          |   1 -
>   drivers/target/tcm_fc/Kconfig    |   6 -
>   drivers/target/tcm_fc/Makefile   |   7 -
>   drivers/target/tcm_fc/tcm_fc.h   | 169 ----------
>   drivers/target/tcm_fc/tfc_cmd.c  | 561 -------------------------------
>   drivers/target/tcm_fc/tfc_conf.c | 491 ---------------------------
>   drivers/target/tcm_fc/tfc_io.c   | 359 --------------------
>   drivers/target/tcm_fc/tfc_sess.c | 503 ---------------------------
>   9 files changed, 2098 deletions(-)
>   delete mode 100644 drivers/target/tcm_fc/Kconfig
>   delete mode 100644 drivers/target/tcm_fc/Makefile
>   delete mode 100644 drivers/target/tcm_fc/tcm_fc.h
>   delete mode 100644 drivers/target/tcm_fc/tfc_cmd.c
>   delete mode 100644 drivers/target/tcm_fc/tfc_conf.c
>   delete mode 100644 drivers/target/tcm_fc/tfc_io.c
>   delete mode 100644 drivers/target/tcm_fc/tfc_sess.c
> 
Please, no. I'd rather keep it; having the tcm_fc driver in allows one 
to have a simple virtualized FCoE testbed. We're using it quite heavily 
for QA and validation.

I'd be happy to fix the race condition instead.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
