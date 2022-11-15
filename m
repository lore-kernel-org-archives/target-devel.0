Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE135C433FE
	for <target-devel@archiver.kernel.org>; Tue, 15 Nov 2022 13:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKON7n (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 08:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiKON7l (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 08:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD211A17
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 05:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668520724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5cuYW4bNAYgIP83rvtc9DAqA3XaMfMen8KzeCUC5rQ=;
        b=c5VCp6dH3VG1Iri/udh69NOGW56Z9Ebk8oHyvQ5BXCvu6NyMnqLWreUSzAl0VP+bfH42gp
        aRYpzg+39YFI97PzSIUgP9ng+byIcsuiTLrw6Sp0RAUT2a6b6CD9GW4PtG/vawIyrFHIiR
        Bf+BGnffSeqoIs2flnWZLZIQtYbE2II=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-xnLCTMhWOkON78x56NnrYQ-1; Tue, 15 Nov 2022 08:58:43 -0500
X-MC-Unique: xnLCTMhWOkON78x56NnrYQ-1
Received: by mail-vk1-f197.google.com with SMTP id s21-20020a1fa915000000b003bbddc2fb8fso2141080vke.17
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 05:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5cuYW4bNAYgIP83rvtc9DAqA3XaMfMen8KzeCUC5rQ=;
        b=Qfu1flbM0QZQ7VDcgACI9vDqvNW0cxsA3Ten52CQhzmBbQx/PY4HBipXHDMaO1dfH5
         5Z2F32u6mNH4TeO/VFWTnfTAzff/E4800TJTZkYps4z7oPoR7AF6Z2/nOC0+geSWRge+
         E/rkOFinLdi3GBbtno4Td8pmnbSw+HAgLaiUimK/H1btXSbGbXd+FjF7Ah8T/gB1Zzya
         gHHbsHbVvgk8VlgjEYyPcFKM8xakpduWKRTULc+9tjNhnumOYW3xcMiOraS79JivHGdh
         Rqe/SRj18ib/J30wiE7emch4gYPWJA6EUuHRAxhPxImzQdKTEti28y1xkFC93K/62LKn
         fUCw==
X-Gm-Message-State: ANoB5pmwL7iATwatmb4ygvgQO5/2qFfaOW60Y9JRKdApgrySgSnTec4Z
        S160eyHFzpilBnY1yd0P1kWOy90WZMZtmAFpzXwHVxcN6GiBz0edgO0QAwf84h9WuXAP36bxt8D
        3TMELTHlo0V3BccYnWJlASKupvQq3hSGjeXEAAx/6
X-Received: by 2002:a1f:41c7:0:b0:3b7:6a89:4530 with SMTP id o190-20020a1f41c7000000b003b76a894530mr9072543vka.37.1668520722333;
        Tue, 15 Nov 2022 05:58:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7o4TXgqjimpzbATQo01PvDy0m5FCfUIGmYtmt5tudhFN6qGxRyfBK8OmqOrXGH85tngwhER7OC5jQFWSuCgGA=
X-Received: by 2002:a1f:41c7:0:b0:3b7:6a89:4530 with SMTP id
 o190-20020a1f41c7000000b003b76a894530mr9072519vka.37.1668520722016; Tue, 15
 Nov 2022 05:58:42 -0800 (PST)
MIME-Version: 1.0
References: <20221115125242.102344-1-mlombard@redhat.com>
In-Reply-To: <20221115125242.102344-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 15 Nov 2022 14:58:30 +0100
Message-ID: <CAFL455n=2qZjASYEvFpg+AGc5wynBMYLNga2qt_zjVudwOGYmw@mail.gmail.com>
Subject: Re: [PATCH V3] target: fix a race condition between login_work and
 the login thread
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

=C3=BAt 15. 11. 2022 v 13:56 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
>
> +/**
> + * RETURN VALUE:
> + *
> + *  1 =3D Login successful
> + * -1 =3D Login failed
> + *  0 =3D More PDU exchanges required
> + */
>  static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_=
login *login)
>  {
>         int pdu_count =3D 0;
> @@ -1363,12 +1370,13 @@ int iscsi_target_start_negotiation(
>                 ret =3D -1;
>
>         if (ret < 0) {
> -               cancel_delayed_work_sync(&conn->login_work);
>                 iscsi_target_restore_sock_callbacks(conn);
>                 iscsi_remove_failed_auth_entry(conn);
>         }
> -       if (ret !=3D 0)
> +       if (ret !=3D 0) {
> +               cancel_delayed_work_sync(&conn->login_work);
>                 iscsi_target_nego_release(conn);
> +       }
>
>         return ret;
>  }
>

If ret =3D=3D 1 the login was successful, the socket callbacks have been
restored by iscsi_target_do_login()
so we just have to call  cancel_delayed_work_sync() against login_work
to fix the race condition.

if ret =3D=3D -1 the login was unsuccessful, I moved the
cancel_delayed_work_sync() call from the (ret < 0) block
to the (ret !=3D 0) to close a potential race condition (we must restore
the socket callbacks first).

if ret =3D=3D 0 then iscsi_target_do_login() clears
LOGIN_FLAGS_INITIAL_PDU and passes the control to login_work.

With this version of the patch, nothing has been changed in the
login_work context so it should work exactly as before.
iscsi_target_start_negotiation() is executed only in the login_thread conte=
xt.


Maurizio

