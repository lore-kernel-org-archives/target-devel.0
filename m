Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAF5C636CC
	for <target-devel@archiver.kernel.org>; Mon, 13 Feb 2023 12:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBMMAA (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 13 Feb 2023 07:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBML77 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 13 Feb 2023 06:59:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C67E144BF
        for <target-devel@vger.kernel.org>; Mon, 13 Feb 2023 03:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676289560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P69Z5ADefECQaVigK14re30Iy1qGGLvGB0eZAssHA6w=;
        b=fbJAKZolKsm/i2ju9GUBLldxi34yiwhwb8PHyfFfcaIBzFuvdB3ufkvZtremiDahOP6n5l
        f9TxXG7hfEVafHi+OfoAOkEZPfSM+zBRjGJmJ7mH1FHOrh7+otNiNLBG7Cx0E9wrr2+quj
        CIHxm2XePUpvF/RV/Lz1HfoRaSLInNA=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-402-X4xKR6sFNsKfvbLxrP2ttA-1; Mon, 13 Feb 2023 06:59:19 -0500
X-MC-Unique: X4xKR6sFNsKfvbLxrP2ttA-1
Received: by mail-vs1-f72.google.com with SMTP id i23-20020a05610221b700b0041225db8896so383860vsb.14
        for <target-devel@vger.kernel.org>; Mon, 13 Feb 2023 03:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P69Z5ADefECQaVigK14re30Iy1qGGLvGB0eZAssHA6w=;
        b=7udjlMaao/6rXElHzqP8ESPH7ni+ViDAsFy6VWRax6Tf52WhILh7mhEdDqftNv5GX3
         8Fx+6mfXA+4mgFzAbVfsg0jWbkFG9hOnD+AapmFj2K+jASvJu4DpwoLzoYj7eDTItH/i
         boWOUUf2U3fpU6044x3i8RFvJyWL91pxPHNU1kEM2l/Yw5GJmyzb39EJX9hRyvyvHULc
         vh1gfBlN0z6FMLtF4KRrEdCxf0l6WeJFWcqC4TbWywR/RgNu/iSgdKWhO8AEMiYgJFfh
         lgrAl5Z7mxEIFGmG3wkjek22xRKUE6ojmOwcBRY43SHn9WzkGBMDYoTL0VLK7J0oT8dD
         AKYg==
X-Gm-Message-State: AO0yUKVBiJ4lAjFZPwNdlBggYGh5hJ70eoXeNgpmDJVY8Y6FcyGJDg0Z
        VVC8EHmLwnrJ15rhVywIZbAa7/t+AMkl9xThNfzPI1HLb1KRFaQ8MmtNBM9Ib/HWgVJTGm5OYS4
        MWvgk9DT60nZreJln3Q3rnZhSqCOXpGVE6+l7iYZz
X-Received: by 2002:a1f:28d8:0:b0:401:5dc0:439f with SMTP id o207-20020a1f28d8000000b004015dc0439fmr697214vko.33.1676289558737;
        Mon, 13 Feb 2023 03:59:18 -0800 (PST)
X-Google-Smtp-Source: AK7set+4tZju16RoVCDo6v7tREO+1gsmeF9WlTEqa4Y+ytbbaPJ48q9hz3PS1XBNBosBmPEHLhdd7V1g3WqzGmaoly4=
X-Received: by 2002:a1f:28d8:0:b0:401:5dc0:439f with SMTP id
 o207-20020a1f28d8000000b004015dc0439fmr697208vko.33.1676289558502; Mon, 13
 Feb 2023 03:59:18 -0800 (PST)
MIME-Version: 1.0
References: <20230208200957.14073-1-djeffery@redhat.com>
In-Reply-To: <20230208200957.14073-1-djeffery@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 13 Feb 2023 12:59:07 +0100
Message-ID: <CAFL455kEoLQF+vc2MGmtLdrQ-=U+HJzqgknZmM54iCPJD1p_mA@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: set memalloc_noio with loopback
 network connections
To:     David Jeffery <djeffery@redhat.com>
Cc:     target-devel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Laurence Oberman <loberman@redhat.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

st 8. 2. 2023 v 21:10 odes=C3=ADlatel David Jeffery <djeffery@redhat.com> n=
apsal:
>
>
> +       /*
> +        * If the iscsi connection is over a loopback device from using
> +        * iscsi and iscsit on the same system, we need to set memalloc_n=
oio to
> +        * prevent memory allocation deadlocks between target and initiat=
or.
> +        */
> +       rcu_read_lock();
> +       dst =3D rcu_dereference(conn->sock->sk->sk_dst_cache);
> +       if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
> +               loopback =3D true;
> +       rcu_read_unlock();

Hi Mike,
I tested it, it works. The customer also confirmed that it fixes the
deadlock on his setup.

Maurizio

