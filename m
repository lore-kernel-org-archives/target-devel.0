Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494F8C636D3
	for <target-devel@archiver.kernel.org>; Mon,  6 Feb 2023 15:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBFPTN (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 10:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFPTM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 10:19:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF1510EF
        for <target-devel@vger.kernel.org>; Mon,  6 Feb 2023 07:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675696708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFvsw7pkW2w5/fLVU0BcZIRVvokdsMd3OEavZ5Dv8o0=;
        b=DlPPvLtGDYozPcko8g9G+wEK0UUptKatI739eAUYbxXuSo0eVm/bzKxpYtIIhy+r329hAi
        nqQo9ND1hHoM9n3b15xaUs/MiVu77JPHl9dZrHOwN7mi7BT7C1qPFn4C9cZ25aeJt79UWH
        bKqgYWipG13qo5sMdYLxCl8jWN+xDso=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-180-3jMzTX7NNka8Ki6zbfBF6w-1; Mon, 06 Feb 2023 10:18:24 -0500
X-MC-Unique: 3jMzTX7NNka8Ki6zbfBF6w-1
Received: by mail-vs1-f72.google.com with SMTP id dc27-20020a056102559b00b0040d6aba02cfso421416vsb.11
        for <target-devel@vger.kernel.org>; Mon, 06 Feb 2023 07:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFvsw7pkW2w5/fLVU0BcZIRVvokdsMd3OEavZ5Dv8o0=;
        b=ooUf/wWTLg8ZrUd8R5VN6ivgC89C6nz5MAOXP9VX/pr8x7tgaqBbuAb7V0oYuszVYm
         l6icWkGBr1KiVpQlROzNjcCGp1Gac/Dkn/Aw7KGBugas8olG0pibaue9JU6cfGYZiMuC
         s37mideFiqQrJb2BWLs/GVVs76npTtAaoYMPVp4pH1WVMJ4Qb9XBlWRKv7SJ1asGNM30
         krGKOxADTLG8OUuJLRtbEMiapHlMyOlM9PQGbqcQnZckznXIZyC74ntNqHD+X57bHJn3
         upbSnJMZxBQzjyn50JQorlisJE652+jSHie74lMuVEyZNUc0pgMRqofNvqjsNis+mYdj
         Ey0w==
X-Gm-Message-State: AO0yUKXSHD8ed0OktBymPqYqgKKOpSbfLOPYbssdWsWYBn+NvwaRLPCk
        en2jfDm0dlLvpOj3kdsvU41e9LsGvheWR5HGHWUOboa9nhP6LdwK2OrbvX5SvzphjpesX0A3ALe
        psPl1AVrebDdPwHTmVfGOH2uUUjms9jH+70N91Q6T
X-Received: by 2002:ab0:739a:0:b0:683:9d1b:e950 with SMTP id l26-20020ab0739a000000b006839d1be950mr955555uap.37.1675696703921;
        Mon, 06 Feb 2023 07:18:23 -0800 (PST)
X-Google-Smtp-Source: AK7set/uskG63CugZTG3unQRDkXHF78edndfDvNgRmJ8RzJ/6XON5a/Hv6+IqRsSFRRiWZTwfyXqOvdoeqpd/K33FuM=
X-Received: by 2002:ab0:739a:0:b0:683:9d1b:e950 with SMTP id
 l26-20020ab0739a000000b006839d1be950mr955549uap.37.1675696703687; Mon, 06 Feb
 2023 07:18:23 -0800 (PST)
MIME-Version: 1.0
References: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
 <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
In-Reply-To: <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 6 Feb 2023 16:18:12 +0100
Message-ID: <CAFL455k8m70cZHEOJML8HgeKotM=PsnswUtMJkLjocXxWY6_7w@mail.gmail.com>
Subject: Re: deadlocks when the target server runs as initiator to itself
To:     Mike Christie <michael.christie@oracle.com>
Cc:     d.bogdanov@yadro.com, target-devel@vger.kernel.org,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 30. 1. 2023 v 1:09 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> I don't think that's the best option because it's a rare use case and it
> will affect other users. Why can't the user just use tcm loop for the loc=
al
> use case?
>

Hi Mike,
our customer is still interested in getting iscsi in loopback work and I ha=
ve
also been informed that  this use case isn't rare among our users.
One of my colleagues suggested using the IFF_LOOPBACK flag to restrict
the memalloc_noio_*()
usage to only those connections that are in loopback, so other use
cases would be left unaffected.

I copy-paste his patch here, our customer confirmed that it works.

--- a/drivers/target/iscsi/iscsi_target.c 2023-01-30 13:48:43.310455860 -05=
00
+++ b/drivers/target/iscsi/iscsi_target.c 2023-01-30 17:10:08.171410784 -05=
00
@@ -24,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/idr.h>
 #include <linux/delay.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <asm/unaligned.h>
 #include <linux/inet.h>
@@ -4043,7 +4044,10 @@ int iscsi_target_rx_thread(void *arg)
 {
  int rc;
  struct iscsi_conn *conn =3D arg;
+ struct dst_entry *dst;
  bool conn_freed =3D false;
+ bool local =3D false;
+ unsigned int flags;

  /*
  * Allow ourselves to be interrupted by SIGINT so that a
@@ -4061,7 +4065,17 @@ int iscsi_target_rx_thread(void *arg)
  if (!conn->conn_transport->iscsit_get_rx_pdu)
  return 0;

+ rcu_read_lock();
+ dst =3D rcu_dereference(conn->sock->sk->sk_dst_cache);
+ if (dst && dst->dev && dst->dev->flags & IFF_LOOPBACK)
+         local =3D true;
+ rcu_read_unlock();
+
+ if (local)
+         flags =3D memalloc_noio_save();
  conn->conn_transport->iscsit_get_rx_pdu(conn);
+ if (local)
+         memalloc_noio_restore(flags);

