Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8782EC4332B
	for <target-devel@archiver.kernel.org>; Fri,  5 Feb 2021 22:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBEC64FE2
	for <target-devel@archiver.kernel.org>; Fri,  5 Feb 2021 22:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhBEWNH (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:13:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232784AbhBEOkd (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 09:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612541862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khNEiGi3gSDvPl4eGhmwPqK2s3UCa52HPIkP8Eu2Bsc=;
        b=f1AvbxEA+aRL3pgsPvGVDU5UIAX2MQI/TiF66W6iNeCgDiZ0JTl1OnAs2ayd+JbWdlzAvz
        yEAtThwzp+5oV92q7huQp6voZr3rZmHx4hxzBpmHxC2AJszshkVKOcRXb9ADsgdLE7iIAt
        GLHaJuJ9xeiXqheWXBQgL3LwjuTkRNw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-PJh25U_cNWqAwsa0qLpCAA-1; Fri, 05 Feb 2021 11:17:24 -0500
X-MC-Unique: PJh25U_cNWqAwsa0qLpCAA-1
Received: by mail-ej1-f72.google.com with SMTP id p1so6928439ejo.4
        for <target-devel@vger.kernel.org>; Fri, 05 Feb 2021 08:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khNEiGi3gSDvPl4eGhmwPqK2s3UCa52HPIkP8Eu2Bsc=;
        b=dv/4cQlcpPrjQU16QPJxSlTYuzbnPG7zLok6D0yfMJhtbcQm9d2ck5ThFpsU3pXyXR
         O2c9fDtVju0F3ZKXPPN0BGWE/IId51urhOLeztJGJZY7+Wv0gTTXz9Wijq9VfiIrBbpV
         lmRlIvX4jfJWqrnUVfC4NzJcejT67wz+Wm21gknXqjIlYX6WHtswXcmfxErHAN0/kOJ0
         R7pEED59vE0UcDCFnKaTTPMhrUjpRuymXxqppv0PCXY2TGCQyzrXhMV33EBO1oXOdV1Y
         DE0vLKDK0PnSGydDTrYNcclVGLJ2hEqvewtJUaqeWjg1icvLy4BfV6AU8HzHGD/pETcy
         6iTQ==
X-Gm-Message-State: AOAM5332V9jjYj04B64Douind/873fZHQnECSSYP9CGtxfTq4v5yybjV
        9+VyVU3DyYoUa3o+Rtpzy3eLzVT/PlaE3Q6sSUmrrlwd/8Gbsr/O1hdB+hkg9URxr+TIlbOYoDg
        bwp7IpCGU5rsxcsKCjEEGlqQb
X-Received: by 2002:a17:906:169b:: with SMTP id s27mr343274ejd.396.1612541842913;
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxASMO+xswfNgpQwV8wyefPe1EMyJevJ53IOHaWEyDD08C7S3RPlbtBmcuhKVYuF8c/fBWAdQ==
X-Received: by 2002:a17:906:169b:: with SMTP id s27mr343257ejd.396.1612541842771;
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id 94sm2442486edq.91.2021.02.05.08.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
Date:   Fri, 5 Feb 2021 11:17:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/11] vhost scsi: use lio wq cmd submission helper
Message-ID: <20210205111638-mutt-send-email-mst@kernel.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204113513.93204-6-michael.christie@oracle.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, Feb 04, 2021 at 05:35:07AM -0600, Mike Christie wrote:
> @@ -1132,14 +1127,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
>  		 */
>  		cmd->tvc_vq_desc = vc.head;
> -		/*
> -		 * Dispatch cmd descriptor for cmwq execution in process
> -		 * context provided by vhost_scsi_workqueue.  This also ensures
> -		 * cmd is executed on the same kworker CPU as this vhost
> -		 * thread to gain positive L2 cache locality effects.
> -		 */
> -		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
> -		queue_work(vhost_scsi_workqueue, &cmd->work);
> +		target_queue_cmd_submit(tpg->tpg_nexus->tvn_se_sess,
> +					&cmd->tvc_se_cmd);
>  		ret = 0;
>  err:
>  		/*

What about this aspect? Will things still stay on the same CPU?

-- 
MST

