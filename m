Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B72C433F5
	for <target-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E7F613DB
	for <target-devel@archiver.kernel.org>; Thu, 18 Nov 2021 17:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhKRRRd (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 12:17:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234026AbhKRRRa (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 12:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637255670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+GQu1Km7TIUMW6gg0RDUgLn1M3xF9wXFSrXBJMhgIQ=;
        b=dUm5mDE9Qs1L1x2uyGVXtdvf3HsAAyTDOEjDNi6/G7V8RpQ+ul9rY5pjprDnJX/na+c5KT
        RtJy+oO0fHZJMWQprCcZEdsjBHNBdpthGTAAbwZh9JvqKzKpcld9qbDejl3/lyBCeIKnoc
        4Oa7nrTVGAxwBgd1lgCrlpmysQkoVgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-LT4CSjdqPiSqptnIgGcCbA-1; Thu, 18 Nov 2021 12:14:24 -0500
X-MC-Unique: LT4CSjdqPiSqptnIgGcCbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99EA987180F;
        Thu, 18 Nov 2021 17:14:23 +0000 (UTC)
Received: from raketa (unknown [10.40.192.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F78E5F4EF;
        Thu, 18 Nov 2021 17:14:21 +0000 (UTC)
Date:   Thu, 18 Nov 2021 18:14:19 +0100
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] target: Use RCU helpers for INQUIRY
 t10_alua_tg_pt_gp use
Message-ID: <20211118171419.GC144997@raketa>
References: <20211117213928.8634-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117213928.8634-1-michael.christie@oracle.com>
User-Agent: Mutt/1.14.7 (f34d0909) (2020-08-29)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 03:39:28PM -0600, Mike Christie wrote:
> This fixes the sparse warnings about t10_alua_tg_pt_gp accesses in
> target_core_spc.c from:
> 
> commit 7324f47d4293 ("scsi: target: Replace lun_tg_pt_gp_lock with rcu in
> I/O path")
> 
> That patch replaced the lun_tg_pt_gp_lock use in the IO path, but didn't
> update the INQUIRY code.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_spc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 22703a0dbd07..4c76498d3fb0 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -40,11 +40,11 @@ static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
>  	 *
>  	 * See spc4r17 section 6.4.2 Table 135
>  	 */
> -	spin_lock(&lun->lun_tg_pt_gp_lock);
> -	tg_pt_gp = lun->lun_tg_pt_gp;
> +	rcu_read_lock();
> +	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
>  	if (tg_pt_gp)
>  		buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
> -	spin_unlock(&lun->lun_tg_pt_gp_lock);
> +	rcu_read_unlock();
>  }
>  
>  static u16
> @@ -325,14 +325,14 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
>  		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
>  		 * section 7.5.1 Table 362
>  		 */
> -		spin_lock(&lun->lun_tg_pt_gp_lock);
> -		tg_pt_gp = lun->lun_tg_pt_gp;
> +		rcu_read_lock();
> +		tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
>  		if (!tg_pt_gp) {
> -			spin_unlock(&lun->lun_tg_pt_gp_lock);
> +			rcu_read_unlock();
>  			goto check_lu_gp;
>  		}
>  		tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
> -		spin_unlock(&lun->lun_tg_pt_gp_lock);
> +		rcu_read_unlock();
>  
>  		buf[off] = tpg->proto_id << 4;
>  		buf[off++] |= 0x1; /* CODE SET == Binary */
> -- 
> 2.25.1
>

Looks ok,

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

