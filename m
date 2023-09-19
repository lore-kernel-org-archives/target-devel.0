Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A197ACD54A7
	for <target-devel@archiver.kernel.org>; Tue, 19 Sep 2023 08:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjISIHK (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjISIHH (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 04:07:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BB7FB
        for <target-devel@vger.kernel.org>; Tue, 19 Sep 2023 01:07:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D159F1FDBE;
        Tue, 19 Sep 2023 08:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695110820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bajHuJFnXEjEblVsgVBJ0nIjlZJgoPK4xdSxcXEX8JA=;
        b=HWUqZ0+kwtZYct6Q4iYaJ9FBrDahtps9LHr1p/YcA85xdOJnZAIyDbeB4Bu3IxFbiGoK0C
        oApBLi6nXgGJRoQtlK4BD6fVXa1KCKfiIN+3aGG3cFr7+U+M/+P7MCJ1wFtQYyCQDfzMyB
        h4kI/lWRIAHFd4Oo5JO7D0tntx3OdlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695110820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bajHuJFnXEjEblVsgVBJ0nIjlZJgoPK4xdSxcXEX8JA=;
        b=KEWvQOMKbeoAP5qDexkME819/BBYkUWRUjwwWautvN1a4AaqNEKfOCQRWQmL4Y827RzLgj
        JosakgcVuwuX39Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7652913458;
        Tue, 19 Sep 2023 08:07:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E8yOGaRWCWVKAwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Sep 2023 08:07:00 +0000
Message-ID: <0a9d39ee-afc3-4aeb-a3af-5e195789bcc8@suse.de>
Date:   Tue, 19 Sep 2023 10:06:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: target: Remove the references to
 http://www.linux-iscsi.org/
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org
References: <20230918215941.2053109-1-bvanassche@acm.org>
 <20230918215941.2053109-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230918215941.2053109-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 9/18/23 23:59, Bart Van Assche wrote:
> The website http://www.linux-iscsi.org/ disappeared more than a year ago.
> DNS records have been removed for linux-iscsi.org. The company that
> sponsored this website (Datera; formerly called Rising Tide) has been
> liquidated in early 2021 according to
> https://blocksandfiles.com/2021/03/19/datera-is-being-liquidated/.
> Since it is unlikely that the website http://www.linux-iscsi.org/ will be
> restored, remove the references to that website.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   MAINTAINERS                  | 2 --
>   drivers/target/iscsi/Kconfig | 9 ++++++---
>   2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90f13281d297..10a2d6af910b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11144,7 +11144,6 @@ M:	Sagi Grimberg <sagi@grimberg.me>
>   L:	linux-rdma@vger.kernel.org
>   L:	target-devel@vger.kernel.org
>   S:	Supported
> -W:	http://www.linux-iscsi.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
>   F:	drivers/infiniband/ulp/isert
>   
> @@ -19162,7 +19161,6 @@ M:	"Martin K. Petersen" <martin.petersen@oracle.com>
>   L:	linux-scsi@vger.kernel.org
>   L:	target-devel@vger.kernel.org
>   S:	Supported
> -W:	http://www.linux-iscsi.org
>   Q:	https://patchwork.kernel.org/project/target-devel/list/
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   F:	Documentation/target/
> diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> index 922484ea4e30..922b207bc69d 100644
> --- a/drivers/target/iscsi/Kconfig
> +++ b/drivers/target/iscsi/Kconfig
> @@ -1,12 +1,15 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   config ISCSI_TARGET
> -	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	tristate "SCSI Target Mode Stack"
>   	depends on INET
>   	select CRYPTO
>   	select CRYPTO_CRC32C
>   	select CRYPTO_CRC32C_INTEL if X86
>   	help
> -	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
> -	Target Mode Stack.
> +	Say M to enable the SCSI target mode stack. A SCSI target mode stack
> +	is software that makes local storage available over a storage network
> +	to a SCSI initiator system. The supported storage network technologies
> +	include iSCSI, Fibre Channel and the SCSI RDMA Protocol (SRP).
> +	Configuration of the SCSI target mode stack happens through configfs.
>   
>   source	"drivers/target/iscsi/cxgbit/Kconfig"

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

