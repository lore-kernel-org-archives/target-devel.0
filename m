Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F7FC6FD1F
	for <target-devel@archiver.kernel.org>; Wed, 22 Mar 2023 14:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCVOAh (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCVOAg (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 10:00:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E74193
        for <target-devel@vger.kernel.org>; Wed, 22 Mar 2023 06:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679493591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEfREtnuoRn4im/BDpgIBUhnwsEs800ZPAqQZipuKHM=;
        b=Qt3zJgEqGYGc5S3NcxyS97XR9sgjd2hYpXN1zvN7if+miq3TBs/D+wG2wFZDdobj+IVjgw
        /WFffZtzfLlRiwQkBUyWU1obG0/X+i6VzEzCADJPmhpKTechlDEYFZSWlsc85o2E1pM1SH
        /a/huwGtFdtkWggRbgPB6tCYfcwaaE4=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-NOn3DtQAP0WDwWJbbZln-Q-1; Wed, 22 Mar 2023 09:59:50 -0400
X-MC-Unique: NOn3DtQAP0WDwWJbbZln-Q-1
Received: by mail-vs1-f72.google.com with SMTP id i16-20020a67c210000000b00425f051bf84so3914662vsj.13
        for <target-devel@vger.kernel.org>; Wed, 22 Mar 2023 06:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679493589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aEfREtnuoRn4im/BDpgIBUhnwsEs800ZPAqQZipuKHM=;
        b=V7rsK+UrO49wZQP6a7pIGSHoz5OxwYvkpAmW9F+OP3BWX+r5BFkT+cr9DEmy2OG8/b
         8WALtiFy4Kh1t50gM74VqN0a03SVJLXUAZWl+qgpV67feUKpUxobQfEb8vcuNF0Bar43
         YlGNTbELVLNa8zeUtpUif+/pvc0QisxXxNxF5wgSI8zeQU+V6Vg+T4COFfNQQiPnkvTe
         CpENhm0sp94SEF2FCVH7hj+i17AExE+G4S5C/s8fic87zMIuFaH0BVvwNB1VzdW6TR3r
         8UZ9A9ZR9k85SuKNv4ufpJO1IlTOKvVieJwYWDw4oFkuk6J16fFiRIdDaOiI4goB8RiW
         Yjhw==
X-Gm-Message-State: AO0yUKX4h/kNWNCWXyLntEgkN2c4OsYEyFxLQhfBkM2up1AwSqSl3qNn
        YbD7pSq54mdOQ4dHkv91f0dJFD61HYouzek34q7vd7fyJSqUVC/qmeW8U3ONjYSiNWK2XJYP4p/
        uzAHhS0XDI8GHNId66yjTu7tuNWIVSBumnMoNr4powkbkg3njC38=
X-Received: by 2002:a05:6122:2014:b0:401:7625:e9e3 with SMTP id l20-20020a056122201400b004017625e9e3mr1715133vkd.1.1679493589479;
        Wed, 22 Mar 2023 06:59:49 -0700 (PDT)
X-Google-Smtp-Source: AK7set+uhq7r8CfHdNF8Xk9sGgjZhBRbHGta4Fle3DFMhflNTVy5YrsAHewSbzRSQnTt3JKQjNAHZ3yhdLh5LDbVvmY=
X-Received: by 2002:a05:6122:2014:b0:401:7625:e9e3 with SMTP id
 l20-20020a056122201400b004017625e9e3mr1715119vkd.1.1679493589174; Wed, 22 Mar
 2023 06:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230227075735.8695-1-mlombard@redhat.com>
In-Reply-To: <20230227075735.8695-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 22 Mar 2023 14:59:37 +0100
Message-ID: <CAFL455n3w6MoWTC6sj2T_oSg38oF-zSpQFaiJshknd91OJShTg@mail.gmail.com>
Subject: Re: [PATCH] target: iscsi: use GFP_NOIO with loopback connections
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 27. 2. 2023 v 9:00 odes=C3=ADlatel Maurizio Lombardi <mlombard@redhat.co=
m> napsal:
>
> Fix the issue by using memalloc_noio_*() to enable implicit GFP_NOIO
> in the vulnerable code paths, when the connection is in loopback.
>
> @@ -1289,6 +1291,12 @@ static int __iscsi_target_login_thread(struct iscs=
i_np *np)
>                 iscsit_free_conn(conn);
>                 return 1;
>         }
> +
> +       dst =3D sk_dst_get(conn->sock->sk);
> +       if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
> +               conn->loopback =3D true;
> +       dst_release(dst);
> +

As discussed in the other thread, conn->sock is not set when
isert/cxgbit etc are used.
So we need to check it here otherwise the kernel would crash.

I think that "conn->loopback" should be set by the iscsit_accept_np() callb=
ack.

Maurizio

