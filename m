Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06D6C64ED6
	for <target-devel@archiver.kernel.org>; Mon, 27 Feb 2023 15:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjB0PLu (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjB0PLt (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 27 Feb 2023 10:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7532200F
        for <target-devel@vger.kernel.org>; Mon, 27 Feb 2023 07:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677510667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93nzI5VnS3FZUGJix7w74et7HW6LaS2A8Nk/xRLCbqc=;
        b=dCpkw4VDkT3pCm+FRm1S2CWNzSZupFT+QgQrgLuP3EuygoCYtPXCG/28tIOuCqVAu87CnQ
        9wP4iWJnhQEoarnDdxKuGbKkbn5GisRNbUT5fpzmKNuFGBnn3NOywVEt7uZsLlPM8ljFTS
        b5M2v+sYlhwmcYtBGQCdOVm+HFHQrzs=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-372-ffy1wUVJNOy7mJWWwQ43rA-1; Mon, 27 Feb 2023 10:11:05 -0500
X-MC-Unique: ffy1wUVJNOy7mJWWwQ43rA-1
Received: by mail-vs1-f70.google.com with SMTP id y12-20020a67d20c000000b0041ecbf3defcso5827111vsi.16
        for <target-devel@vger.kernel.org>; Mon, 27 Feb 2023 07:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93nzI5VnS3FZUGJix7w74et7HW6LaS2A8Nk/xRLCbqc=;
        b=SZNUZ1rYDKPmcqxhT6KS6RDxe2d10cUdCamN3fTjUa5c7J9SB7prTGMeOoNj/XGM/r
         zd201Vm0JnxiYKf1Es8+87wCNQBulx74FJFLLp73g452o5evdEOeNIV/wAh6Z+Jyhste
         MSbnx2imlzjTu6Akkq1980ydTCRL6kMBJEqYcp5lkCqv7YCtAMYxGMhNktTZji9aV8BX
         EpgShKbi2O1Im/QMFp4b+6nQ+uOXP4WY86z763SpgVYqsBxJ/Gogi3BbR21cjx+wHJ0p
         HzfvYahUxJfXUGlUDJ2tMJkArjgFRKp29B2/Cy6fn3bK7xU0mQOEQN4K9TctDLpfkSXF
         b2Bw==
X-Gm-Message-State: AO0yUKUmA6XOyvYfL6ipF/QVwd4dDccVRPy+R/g0ph0kchTrq6eqzdfV
        ldEGd+s7HfJ25LwEvDGQy4FYecJ6jdS4aIA1h0DqocjbXdoz1Lh3sQ2QkmlMi8AGHPEOly+hPGO
        iiWP+5DorgVOTWlgY7818QrbHK0Bywtby0eV/UMtQ
X-Received: by 2002:a67:d893:0:b0:40d:68b8:6577 with SMTP id f19-20020a67d893000000b0040d68b86577mr7883562vsj.2.1677510665350;
        Mon, 27 Feb 2023 07:11:05 -0800 (PST)
X-Google-Smtp-Source: AK7set9t15+0uCcKFQB4zu0FoKnt6TfqFnOGP539F4N7uLVsP+nAvLZL+XQbB2XMkpt/KpcaUL+MVZ7Z7ppKGdXz+mY=
X-Received: by 2002:a67:d893:0:b0:40d:68b8:6577 with SMTP id
 f19-20020a67d893000000b0040d68b86577mr7883546vsj.2.1677510665023; Mon, 27 Feb
 2023 07:11:05 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-14-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-14-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 27 Feb 2023 16:10:53 +0100
Message-ID: <CAFL455=ys=qFhG5tXV203ah_e+F4=2UK7GPQgsRnqJd1S41sDw@mail.gmail.com>
Subject: Re: [PATCH v3 13/14] IB/isert: Fix use after free during conn cleanup
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> We can end up freeing a command too early during conn cleanup by doing:
>
> 1. Send iserts N 1MB writes.
> 2. Pull cable or down the port isert is using.
> 3. isert_wait_conn's call to isert_put_unsol_pending_cmds races
> with a running isert_send_done -> isert_completion_put -> isert_put_cmd
> where isert_put_unsol_pending_cmds sees the cmd on the conn_cmd_list
> and it does a isert_put_cmd which will free the cmd. Then isert_send_done
> is run and will access the freed command while doing it's normal command
> completion:
> isert_completion_put -> isert_put_cmd -> transport_generic_free_cmd
>
> This patch has us increment write_data_done, so
> isert_put_unsol_pending_cmds can correctly detect commands which will we
> will not be calling isert_send_done for.
>
> Fixes: 38a2d0d429f1 ("IB/isert: convert to the generic RDMA READ/WRITE
> API")
> [code written and suggested by]
> Suggested-by: Sagi Grimberg <sagi@grimberg.me>
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index 516fa37494e1..a44da60352f6 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -1636,7 +1636,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc=
 *wc)
>         if (isert_prot_cmd(isert_conn, se_cmd))
>                 ret =3D isert_check_pi_status(se_cmd, isert_cmd->rw.reg->=
mr);
>         isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
> -       cmd->write_data_done =3D 0;
> +       cmd->write_data_done =3D se_cmd->data_length; /* done fetching da=
ta */
>
>         isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_c=
md);
>         spin_lock_bh(&cmd->istate_lock);
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

