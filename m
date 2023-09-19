Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC51CD54A4
	for <target-devel@archiver.kernel.org>; Tue, 19 Sep 2023 08:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjISIHs (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjISIHr (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 04:07:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931CC115
        for <target-devel@vger.kernel.org>; Tue, 19 Sep 2023 01:07:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 51E931FE39;
        Tue, 19 Sep 2023 08:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695110860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iw0TodAPclkHRRb/nnmG1iFVh47o4wBhs0/lnZ94r1M=;
        b=k6Fy2RemZ64tLi3NuR+eZhmUaUNMJWE4lkZIzAaJ9RYVQDc4zDJlHCMibDzdmJm8fiRA6j
        XGI+2flvpPqDWWznaGGJvwG0ofqGUaiTKI+nis1AXZgP8Hs5+qpXLmrHF6OTS+LYfKuy8k
        a4CYLQzVStgK65J7wM9hFoN3aqWW2Uo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695110860;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iw0TodAPclkHRRb/nnmG1iFVh47o4wBhs0/lnZ94r1M=;
        b=ZJByENWj0tZZLyQlucpnpt4VxQOoHrRZ8umBAj//vGEIbZZZDtwIsCq7G8BZDgvjc/vbyo
        RXIADH1WaTThqOAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EDA0513458;
        Tue, 19 Sep 2023 08:07:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yAWLM8tWCWVKAwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Sep 2023 08:07:39 +0000
Message-ID: <8556f29b-5994-4f5c-8e46-ca4d340d5f57@suse.de>
Date:   Tue, 19 Sep 2023 10:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: target: Remove linux-iscsi.org copyright
 statements
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org
References: <20230918215941.2053109-1-bvanassche@acm.org>
 <20230918215941.2053109-3-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230918215941.2053109-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 9/18/23 23:59, Bart Van Assche wrote:
> According to https://www.copyright.gov/what-is-copyright/, copyright can
> be owned by companies, organizations or people. A website cannot own
> copyright. Remove the linux-iscsi.org copyright statements since these
> duplicate the Rising Tide copyright statements.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/target/tcm_fc/tfc_conf.c | 2 --
>   drivers/target/tcm_fc/tfc_io.c   | 1 -
>   2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
> index 6ac3fc1a7d39..a7cb98d8eaa1 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -7,8 +7,6 @@
>    *
>    * Copyright (c) 2010 Cisco Systems, Inc.
>    * Copyright (c) 2009,2010 Rising Tide, Inc.
> - * Copyright (c) 2009,2010 Linux-iSCSI.org
> - *
>    * Copyright (c) 2009,2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
>    *
>    ****************************************************************************/
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index bbe2e29612fa..153bb0194c87 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -8,7 +8,6 @@
>    * Copyright (c) 2008 Red Hat, Inc.  All rights reserved.
>    * Copyright (c) 2008 Mike Christie
>    * Copyright (c) 2009 Rising Tide, Inc.
> - * Copyright (c) 2009 Linux-iSCSI.org
>    * Copyright (c) 2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
>    */
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

