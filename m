Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D902AC636CD
	for <target-devel@archiver.kernel.org>; Tue,  7 Feb 2023 12:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjBGMbU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 07:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjBGMbT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 07:31:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5593757F
        for <target-devel@vger.kernel.org>; Tue,  7 Feb 2023 04:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675773031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLCJKcOKA/K1AJmfZdCc+B4OsA4sAvAIP1+wzmayK0A=;
        b=Zc+4g30vTzhy88yTw/fRuVhc49ayVZAvUQtaGkJxmKCQpCRg9ez7XhWHD6ZpFWupw8nPBU
        Otofn9D3GGft5FlOmah9b/Tdjt+20P3kFBJDaN8LQoJPYzBAeopzt1d21GYUEyShFvBgAi
        M9IdDjgrXlnSEcplnUbssPwLBvMs9Qc=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-iq7grc0oPKmeWuozUJKkAg-1; Tue, 07 Feb 2023 07:30:29 -0500
X-MC-Unique: iq7grc0oPKmeWuozUJKkAg-1
Received: by mail-vk1-f198.google.com with SMTP id w6-20020a1f9406000000b00388997b8d31so6537279vkd.3
        for <target-devel@vger.kernel.org>; Tue, 07 Feb 2023 04:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MLCJKcOKA/K1AJmfZdCc+B4OsA4sAvAIP1+wzmayK0A=;
        b=GNFauL7VZ3KPXE107jwt0IbJbim33BYFHNzKlKtQ6DyC3Ss6+v78jVSIu1uijMQlfi
         j7cPuHwmwkDeC6NnnT7bGqoagnkd80zpVyswt25uoHXakmKWVDWBku6lhZM+j0CIB+Vd
         9/dW09cdr5ESJ99mXJ6sL2tvSLnOCPW1AI3lq98U2+ZfNsnIl6OOAdonPX/gtOHSRiIN
         ZkGUtNvEYDDQLiCMETSZZWn/GDGABCLgvK/Hp4cz0I9DNA+sw6xiAufWRvkH2LJjfHmM
         TvBh1BgmvXcDC3+hu5Ps977TwJg5JUiYYlLNnN540lIMEzLCVwhvcMm6I/hHQIrLYBcO
         85ZQ==
X-Gm-Message-State: AO0yUKXeGGvPl9W/4GMIyOxAgG0ZR0l0sd4q/7GqeDrrrcV7qqaYc64M
        LNFQS1+6YniooFaYf0OzIUWsQned2z9XN1r9dIknE1fGwMLxFh67QHOIv6EWP1kWsuBvofC9/RI
        JtE4n4ZBPtUcQjmC5D60extH4mHWeQmhb9ymckkNM
X-Received: by 2002:ab0:3749:0:b0:669:f7f:882f with SMTP id i9-20020ab03749000000b006690f7f882fmr499077uat.54.1675773029238;
        Tue, 07 Feb 2023 04:30:29 -0800 (PST)
X-Google-Smtp-Source: AK7set8R6KFXh9W0uT3z3mcP2iIhfEyJhEH6gby0TKL7T7bfnVEIYWYiCnbnU+SpHgdSneQUbzqI0sqTV838iO97Nuk=
X-Received: by 2002:ab0:3749:0:b0:669:f7f:882f with SMTP id
 i9-20020ab03749000000b006690f7f882fmr499075uat.54.1675773028955; Tue, 07 Feb
 2023 04:30:28 -0800 (PST)
MIME-Version: 1.0
References: <CAMbhmBwe7KU8sHPLRgjGOrKPt44HMytaTbavBeFk1+uVvGzVmQ@mail.gmail.com>
In-Reply-To: <CAMbhmBwe7KU8sHPLRgjGOrKPt44HMytaTbavBeFk1+uVvGzVmQ@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 7 Feb 2023 13:30:14 +0100
Message-ID: <CAFL455kXhnzPSr5d9S1nxm3uCWVGGh=PY0R1jXvP=UxNSVHOKA@mail.gmail.com>
Subject: Re: Hang in iscsit_access_np() related to tpg->np_login_sem
To:     Serapheim Dimitropoulos <serapheim.dimitro@delphix.com>
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, Paul Dagnelie <pcd@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

p=C3=A1 3. 2. 2023 v 18:16 odes=C3=ADlatel Serapheim Dimitropoulos
<serapheim.dimitro@delphix.com> napsal:
>
> Looking through the login code it seems like there are two functions that
> are expected to call up() on that semaphore by calling iscsit_deaccess_np=
():
>
> A] __iscsi_target_login_thread(): This is the same thread that acquired
>     the semaphore (by calling iscsit_access_np()).
> B] iscsi_target_do_login_rx(): This is a delayed worker thread spawned
>     by the thread in [A]
>
> Looking at both of those codepaths it seems like there is one case for ea=
ch
> path that we never call iscsit_deaccess_np() to release the semaphore.
>
> For [A] that is if iscsi_target_start_negotiation() returns 0 towards the
> end of that function.
>
> For [B] that is if iscsi_target_do_login() returns 0 AND
> iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_WRITE_ACTIVE)
> returns 0.
>
> Since we have no expertise in this part of the kernel I wanted to ask you
> all, are the two above scenarios expected to not release the semaphore
> on purpose or is any of them a bug? If they are not bugs, where is the
> semaphore expected to be released?

It's the expected behaviour, when  iscsi_target_do_login() or
iscsi_target_start_negotiation()
return 0, it means that more PDU exchanges are needed to complete the
login process.
In case [A]: if iscsi_target_start_negotiation() returns 0, the login
thread will pass the control to the "login_work" worker;
The latter will take over the login process until either it fails or
it's successful and also takes over the responsibility of
releasing the semaphore.

For case [B]:  if iscsi_target_do_login() returns 0 it means that
login_work needs more PDU exchanges
to complete its job, so it stops and the
sk_data_ready/sk_state_change() callbacks will reschedule login_work
until the job is done, at the end of which the semaphore is released.

I'm looking at the code right now to see if I can spot a bug in the code.

Maurizio

