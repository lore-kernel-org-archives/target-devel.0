Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4D7C433FE
	for <target-devel@archiver.kernel.org>; Tue, 15 Nov 2022 08:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiKOIe5 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiKOIe4 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 03:34:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA5F616B
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 00:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668501240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8Vx7/hfrTT2fT7V4DdiRWBJ8MHsFsD5795b2zuCqdQ=;
        b=anF1AtInBG3R9Mt77iZLR/dV8WJKCP+24slXgGIYKCl6HiwF21hIXs+W89/cAKLHTy0WZD
        /CyUEuFcKqGoCnT9uPKw58/EHo/H1pRg0VQlV+whaVPDxSI/WrGIeiZsCPzcL1vtvzEzOn
        5V4aLfj1IGdxb69i8q70YStPjSpsy4M=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-iz0Aqe3FMdSXiGo7E3glSw-1; Tue, 15 Nov 2022 03:33:59 -0500
X-MC-Unique: iz0Aqe3FMdSXiGo7E3glSw-1
Received: by mail-ua1-f71.google.com with SMTP id h14-20020a9f300e000000b0041878808d9dso2559356uab.2
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 00:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8Vx7/hfrTT2fT7V4DdiRWBJ8MHsFsD5795b2zuCqdQ=;
        b=tPvWk/LA6aLVJnQ+1aRq+Iv36NWW2rV0OIMoliliuv5GIifbmeXguPHgfTm8tIg3dg
         oqm5Cw8KJdwKz/mxYFVjBt9ws2iab6ssB+GYpWeYF7YyVB+MGJD083ymTHQ8anEa/EQr
         SMm7gc+8nLrxxrnMovi+iQfvdbPg9gszKvF/vf3Fc9eH2zeX1xf6xow6VCGsDLP/e/fA
         VrPOkkDKJkdp+WuOyMpw+eHXhCulNsVTwch9ZR19MvLFrXlSaLzqh8xxCgAFesBH0+Mw
         Tn5XmmIdT+EIFn5Sn4GhtJUgeBmAbyyz5akeAgQoXRzmOnn/j/3domJkKtxyHQiX9VGc
         dh5A==
X-Gm-Message-State: ANoB5pn4tqhCfZ4zCMaRxTvnrgA0mpt997av7Niyj1KVKhPVbxsJHVbl
        PdZcDrl7l6np6OddnjZyfqOp7XScH278mq7WZSIIIjg8aTW0XGQj9jzD6zSHjQUwKnMC4FaLYHO
        fiiLDx2aTgPp2QzGGAylxKhrNhdcmMdRyhT2uPedw
X-Received: by 2002:a1f:41c7:0:b0:3b7:6a89:4530 with SMTP id o190-20020a1f41c7000000b003b76a894530mr8417248vka.37.1668501238212;
        Tue, 15 Nov 2022 00:33:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5jO8OR5bGIK/DoUbMNVgf2b8SuEq+EoVoxxr3WHvY42fYteCESdZ9VZQXyb7yTfpb16ZlEbv+LI33sourzF2s=
X-Received: by 2002:a1f:41c7:0:b0:3b7:6a89:4530 with SMTP id
 o190-20020a1f41c7000000b003b76a894530mr8417240vka.37.1668501237965; Tue, 15
 Nov 2022 00:33:57 -0800 (PST)
MIME-Version: 1.0
References: <20221111154448.629862-1-mlombard@redhat.com>
In-Reply-To: <20221111154448.629862-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 15 Nov 2022 09:33:46 +0100
Message-ID: <CAFL455nJrRemuyy7HR-N0QW26Bv1fAWTs4EJGA9oJfM=eK_K5Q@mail.gmail.com>
Subject: Re: [PATCH V2] target: fix a race condition between login_work and
 the login thread
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

p=C3=A1 11. 11. 2022 v 16:47 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
>
> Fix this bug by forcing login_work to stop after the login has been
> completed and the socket callbacks have been restored.
> Also fix other potential race conditions in the error paths.

Self-NACK

I can't call cancel_delayed_work_sync() in iscsi_target_do_login()
because the latter could be called from the login_work context
and this will cause a deadlock.

Will submit a V3 when ready



>
> V2: remove an unnecessary call to cancel_delayed_work();
>     fix a potential race condition in iscsi_start_negotiation() and
>     in iscsi_target_do_login_rx()'s error paths
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/is=
csi/iscsi_target_nego.c
> index f2919319ad38..465c53b9ddb3 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -645,7 +645,6 @@ static void iscsi_target_do_login_rx(struct work_stru=
ct *work)
>                                                     LOGIN_FLAGS_WRITE_ACT=
IVE))
>                         goto err;
>         } else if (rc =3D=3D 1) {
> -               cancel_delayed_work(&conn->login_work);
>                 iscsi_target_nego_release(conn);
>                 iscsi_post_login_handler(np, conn, zero_tsih);
>                 iscsit_deaccess_np(np, tpg, tpg_np);
> @@ -654,7 +653,7 @@ static void iscsi_target_do_login_rx(struct work_stru=
ct *work)
>
>  err:
>         iscsi_target_restore_sock_callbacks(conn);
> -       cancel_delayed_work(&conn->login_work);
> +       cancel_delayed_work_sync(&conn->login_work);
>         iscsi_target_login_drop(conn, login);
>         iscsit_deaccess_np(np, tpg, tpg_np);
>  }
> @@ -1058,6 +1057,7 @@ static int iscsi_target_do_login(struct iscsit_conn=
 *conn, struct iscsi_login *l
>                                 login->tsih =3D conn->sess->tsih;
>                                 login->login_complete =3D 1;
>                                 iscsi_target_restore_sock_callbacks(conn)=
;
> +                               cancel_delayed_work_sync(&conn->login_wor=
k);
>                                 if (iscsi_target_do_tx_login_io(conn,
>                                                 login) < 0)
>                                         return -1;
> @@ -1363,8 +1363,8 @@ int iscsi_target_start_negotiation(
>                 ret =3D -1;
>
>         if (ret < 0) {
> -               cancel_delayed_work_sync(&conn->login_work);
>                 iscsi_target_restore_sock_callbacks(conn);
> +               cancel_delayed_work_sync(&conn->login_work);
>                 iscsi_remove_failed_auth_entry(conn);
>         }
>         if (ret !=3D 0)
> --
> 2.31.1
>

