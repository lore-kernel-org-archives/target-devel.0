Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EA3C433F5
	for <target-devel@archiver.kernel.org>; Wed, 27 Apr 2022 19:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiD0TbW (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiD0TbF (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 15:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8D5C4B850
        for <target-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651087622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WAoChBSaZGQGR5mebDk3D5BL8qd1xvhTMspSlXtCQc=;
        b=KPUDzGPWYuBjha2YzHnHXTINO+2Hp1wDEkagH91KF764icnu4O+WnKzx/Z0ApkdEFeM5wZ
        jxsWLPnarR4ex1gib3QWGJbC3orl2AggZOSbML2MeqQIuhk94xnMSUchREauRh1v/mykzo
        CmpTGYF0f/tvu+IGl3wZYTd8jsAaszs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-LZxMVwr-NFiZSKF3yY9PFg-1; Wed, 27 Apr 2022 15:27:00 -0400
X-MC-Unique: LZxMVwr-NFiZSKF3yY9PFg-1
Received: by mail-qv1-f70.google.com with SMTP id bu6-20020ad455e6000000b004563a74e3f9so1993793qvb.9
        for <target-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8WAoChBSaZGQGR5mebDk3D5BL8qd1xvhTMspSlXtCQc=;
        b=GFTu6WmsoNOMWqvBOFzxypqZ/s9Q+QcsT2Qz7MH1ET8zLyUdKjCiRUNWkKcQYwhRlS
         V6fhZB++nptDbwppuDJ3rtmcLwySvYjI3WjUNDr8lNWdFdAC3amne5vMRrurq0eubNvn
         vWKAP4ZZ8ryCYRGcDSaCs7PhZP9Hm7RA3pozOYLbSgBFyXlIrwuvmPFagBNSq4+SB25T
         +z50G1rwtYKxPihldYl0jvg5urciozCyVvjN96v/iO6yVEku5UOay+cwmGjald9nHGh+
         /umeZZl8ijwR+dRzOBgfVFjkj4icqodim8r9E06pkkFa05dwNFgidWfu6mxmpKe5YNQ5
         XEEA==
X-Gm-Message-State: AOAM5328yjUfn7w17lCHzwmFA1Po0qy2f/k7Gnvh4xgf16BPiTnLv2RR
        ENRbP0edHctX6xtr7wo+PzZAwlPHsEo7oxcJKA1njHns1XP3WxvK51/r9jFl+g0JclSC/0g3Yhf
        /iHzzzMN8YNYXA9cigjI/5Dhb
X-Received: by 2002:a05:6214:252b:b0:456:3c2b:c910 with SMTP id gg11-20020a056214252b00b004563c2bc910mr10202034qvb.85.1651087619326;
        Wed, 27 Apr 2022 12:26:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc0xyQRHQQrYPbhNmmirFuUuwf6riBgvsumaJBrw8wUc7zsVs+fk7NOTdY3m0UHwkXgfeC4g==
X-Received: by 2002:a05:6214:252b:b0:456:3c2b:c910 with SMTP id gg11-20020a056214252b00b004563c2bc910mr10202007qvb.85.1651087618937;
        Wed, 27 Apr 2022 12:26:58 -0700 (PDT)
Received: from loberman.users.ipa.redhat.com ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id 9-20020a05620a070900b0069e60da45aasm8188993qkc.60.2022.04.27.12.26.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Apr 2022 12:26:58 -0700 (PDT)
Message-ID: <ae63bff76f384ad7d28aa0833beba6860171aea9.camel@redhat.com>
Subject: Re: [PATCH] target: pscsi: set SCF_TREAT_READ_AS_NORMAL flag only
 if there is valid data
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Apr 2022 15:26:56 -0400
In-Reply-To: <20220427183250.291881-1-djeffery@redhat.com>
References: <20220427183250.291881-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, 2022-04-27 at 14:32 -0400, David Jeffery wrote:
> With tape devices, the SCF_TREAT_READ_AS_NORMAL flag is used by the
> target
> subsystem to mark commands which have both data to return as well as
> sense data. But with pscsi, SCF_TREAT_READ_AS_NORMAL can be set even
> if
> there is no data to return. The SCF_TREAT_READ_AS_NORMAL flag causes
> the
> target core to call iscsit datain callbacks even if there is no data,
> which
> iscsit does not support. This results in iscsit going into an error
> state
> requiring recovery and being unable to complete the command to the
> initiator.
> 
> This issue can be resolved by fixing pscsi to only set
> SCF_TREAT_READ_AS_NORMAL if there is valid data to return along side
> the
> sense data.
> 
> Fixes: bd81372065fa ("scsi: target: transport should handle st
> FM/EOM/ILI reads")
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/target/target_core_pscsi.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c
> b/drivers/target/target_core_pscsi.c
> index ff292b75e23f..60dafe4c581b 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -588,7 +588,7 @@ static void pscsi_destroy_device(struct se_device
> *dev)
>  }
>  
>  static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
> -			       unsigned char *req_sense)
> +			       unsigned char *req_sense, int
> valid_data)
>  {
>  	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
>  	struct scsi_device *sd = pdv->pdv_sd;
> @@ -681,7 +681,7 @@ static void pscsi_complete_cmd(struct se_cmd
> *cmd, u8 scsi_status,
>  		 * back despite framework assumption that a
>  		 * check condition means there is no data
>  		 */
> -		if (sd->type == TYPE_TAPE &&
> +		if (sd->type == TYPE_TAPE && valid_data &&
>  		    cmd->data_direction == DMA_FROM_DEVICE) {
>  			/*
>  			 * is sense data valid, fixed format,
> @@ -1032,6 +1032,7 @@ static void pscsi_req_done(struct request *req,
> blk_status_t status)
>  	struct se_cmd *cmd = req->end_io_data;
>  	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>  	enum sam_status scsi_status = scmd->result & 0xff;
> +	int valid_data = cmd->data_length - scmd->resid_len;
>  	u8 *cdb = cmd->priv;
>  
>  	if (scsi_status != SAM_STAT_GOOD) {
> @@ -1039,12 +1040,11 @@ static void pscsi_req_done(struct request
> *req, blk_status_t status)
>  			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd-
> >result);
>  	}
>  
> -	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer);
> +	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer,
> valid_data);
>  
>  	switch (host_byte(scmd->result)) {
>  	case DID_OK:
> -		target_complete_cmd_with_length(cmd, scsi_status,
> -			cmd->data_length - scmd->resid_len);
> +		target_complete_cmd_with_length(cmd, scsi_status,
> valid_data);
>  		break;
>  	default:
>  		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"

We added a bucnh of debug to track this down, and the fix is solid and
makes perfect sense.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

