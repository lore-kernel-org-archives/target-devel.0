Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3A0C433EF
	for <target-devel@archiver.kernel.org>; Fri,  8 Jul 2022 23:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiGHXlU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiGHXlR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 19:41:17 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771FD9965F
        for <target-devel@vger.kernel.org>; Fri,  8 Jul 2022 16:41:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d12so125350lfq.12
        for <target-devel@vger.kernel.org>; Fri, 08 Jul 2022 16:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5eU4Pn+QfTubmNmsGNshAIHOz3MlAVSj+62C5s2QQP0=;
        b=YPfCC534/rpUeeQu1ADA77pUJyQmCCHALh/h1R+1Q51Gz57+L7IhzKcg47WrIA8wym
         L7+bevHAwkW9YksRTXPl4tK1B52C/Rlb0eEqa4CJdNxgBhhFkYY8DI0zXksxckpvRRWD
         D0hUiOpqBXjb6tuh1sMs9ABJt0SIHMJt5UeYua9Dxx6FFF6MSxywqe2O+dk70ueYyHyI
         PZgPQTvR8xuUJUQ4DOXQ3AY20QCOfX56fRUCHNX9C/Iys3P6ib+i3lKN3yvJTbcUXNEi
         5KQJ209dZm0hD4QrfetKIHEX/uSrXdiq+316wXVyXimUShvHpmsyDjvx2eI7XtigNicJ
         RDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5eU4Pn+QfTubmNmsGNshAIHOz3MlAVSj+62C5s2QQP0=;
        b=azMjg1YnmloSq5kuFvsNnE9RZ+H8cqiuRUeeibC7PfMU94EKdJH4s8hfPtJFlZUe10
         pLfDjD/7uhYPB34m7BwJxl5LcA+CwVDWcLCKT2t+2mtu3tfGWZZX/Ws6hWcr0SXC0XlF
         Z5ayCDf/o3YM1SJAuoTMYojPBSH0KioDDjKp7mjtwFb2zAvPYtezSAzp7C138rCQ4zam
         BFbCdRgWaaCFc+yopMdX61toZvfAksN5ouTuY6WvcEgsAGDF3REuXa42r+18hrvoFzoJ
         jC6CY9Y1wwMhxHfo5OWQsPIoijK8G7k01dbJozKFkXhyVRo/3qTkxZ079FOgvAMicZa0
         3IYQ==
X-Gm-Message-State: AJIora9nmysCzPe3CwHePD+oTSyOG4eUEnRl+NFrJ4bIcDeeJ6ZyQrka
        PW4prCowjz8yb4Oo51YhrslLldrbKRa5EQIuojotKQ==
X-Google-Smtp-Source: AGRyM1uP9YifLrRKvafA7w1uy6h0ZJ7JTDYw1RTJw5mjCkRfNXTOUn69pM/MdgvhyJoN6Q41bZb5XuusaOL3IL9Nv7Y=
X-Received: by 2002:a05:6512:e9a:b0:489:c681:da2b with SMTP id
 bi26-20020a0565120e9a00b00489c681da2bmr2113455lfb.626.1657323672384; Fri, 08
 Jul 2022 16:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220708221314.466294-1-justinstitt@google.com>
In-Reply-To: <20220708221314.466294-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 Jul 2022 16:41:01 -0700
Message-ID: <CAKwvOd=uOrDe5DWnXn7fx8+kTCF6gQVYhgqpnDFbaKunfBBVVg@mail.gmail.com>
Subject: Re: [PATCH] iscsi: iscsi_target: fix clang -Wformat warning
To:     Justin Stitt <justinstitt@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, Jul 8, 2022 at 3:14 PM Justin Stitt <justinstitt@google.com> wrote:
>
> When building with Clang we encounter this warning:
> | drivers/target/iscsi/iscsi_target.c:4365:12: error: format specifies
> | type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
> | " %s\n", atomic_read(&sess->nconn)
>
> The format specifier used is `%hu` which describes an unsigned short.
> However, atomic_read returns an int which means the format specifier
> should be `%d`.

Thanks for the patches!

Please fold this into:
https://lore.kernel.org/llvm/20220708221314.466294-1-justinstitt@google.com/
and send a v2 of that.

>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index e368f038ff5c..bfb717065344 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4361,7 +4361,7 @@ int iscsit_close_connection(
>
>         spin_lock_bh(&sess->conn_lock);
>         atomic_dec(&sess->nconn);
> -       pr_debug("Decremented iSCSI connection count to %hu from node:"
> +       pr_debug("Decremented iSCSI connection count to %d from node:"
>                 " %s\n", atomic_read(&sess->nconn),
>                 sess->sess_ops->InitiatorName);
>         /*
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>


-- 
Thanks,
~Nick Desaulniers
