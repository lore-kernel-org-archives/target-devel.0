Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3324AC6FD19
	for <target-devel@archiver.kernel.org>; Mon, 13 Mar 2023 09:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjCMJJP (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 05:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCMJIy (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 05:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1BF1114A
        for <target-devel@vger.kernel.org>; Mon, 13 Mar 2023 02:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678698398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mo441N0dMdOBrLDCa83LmTp41eXN/7Hb2kUumnUoshM=;
        b=QKq/m5S+AiJBRCys48sD6lCIPur4drUdKERheERnMQgPCe2o4QmJa2tWTgRMQxL7uI6RLh
        6dhJq/n2mZLSnFiYXL+KSxWujEmz/nZiSAghZSBI8FS9cdt+c/wNLvP6mO+cjp5X+KalD7
        x7kry9qD9eJHfs4+9KVDH3fqPFXVELk=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-oOQ_J4x-MCCWVJ-9mdkSXQ-1; Mon, 13 Mar 2023 05:06:36 -0400
X-MC-Unique: oOQ_J4x-MCCWVJ-9mdkSXQ-1
Received: by mail-vs1-f71.google.com with SMTP id e28-20020a056102225c00b0041225db8896so3369243vsb.14
        for <target-devel@vger.kernel.org>; Mon, 13 Mar 2023 02:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678698396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mo441N0dMdOBrLDCa83LmTp41eXN/7Hb2kUumnUoshM=;
        b=ypQos6DN2XTt6Lg1LXUjGvLkvv0HA8Kj0GYy7Jl4GUx3fUvx3820YUT4peTX5As4Wx
         UZDToEFZJVLokd3IbMQlxpw+kDQlZcSjGY51v3C+2EsjCaUVFy8794/CgHMtDR9PYpaX
         x4in2z8yFC+V9znTCy2Z9lYFLV6Uzqmbcx7K0480LcSd9jWwxP4RI/HvQ27DJu+hcz30
         ScCGmc+ynqMnhSBN71Wm7Dp6SHHydnr3HUYYIuCeH4c3KugNDnVcBSV9fkZA9ttxYgUD
         xs5mBtE/YarC3+T9v6kiMmGcUHynVN6JIncwJ59qvKziwea1yPvPmwzxX0uJF6dWE9Qi
         9LIA==
X-Gm-Message-State: AO0yUKUbHNfNYyW3WzK0StVZExB8TU17hBZRQChtiydLQ4IAJWfSJFh2
        weH84/eYOYBCM/Xu801ShqO5ddT0MWHQopY6R80OdilFw3FlAW4i8cR9FdfPxhMTaEdmsGsJ28m
        qrEjNpL+7ByxsQIdOHmZxK2r5zCZk1IZOV9g4Otve
X-Received: by 2002:a67:f592:0:b0:422:14ea:a1f0 with SMTP id i18-20020a67f592000000b0042214eaa1f0mr11453963vso.2.1678698396092;
        Mon, 13 Mar 2023 02:06:36 -0700 (PDT)
X-Google-Smtp-Source: AK7set/00GvujQLRfJTgPuPuV2CGyUXv+tqpdqbeCWRXnnyoTs0djmY2tHbQTs2WR4DKGAsiM6zm0UObVvqN4p0o5oA=
X-Received: by 2002:a67:f592:0:b0:422:14ea:a1f0 with SMTP id
 i18-20020a67f592000000b0042214eaa1f0mr11453951vso.2.1678698395808; Mon, 13
 Mar 2023 02:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230310100423.1258256-1-mlombard@redhat.com> <20230310100423.1258256-2-mlombard@redhat.com>
 <cf7d047d-bd71-6793-802f-c1c38a7a2afa@oracle.com>
In-Reply-To: <cf7d047d-bd71-6793-802f-c1c38a7a2afa@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 13 Mar 2023 10:06:23 +0100
Message-ID: <CAFL455mhvUUCcaTzCdmpn7WfoAoeG=MGA5PkWWoLcjSpZt-1uA@mail.gmail.com>
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

p=C3=A1 10. 3. 2023 v 20:53 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> On 3/10/23 4:04 AM, Maurizio Lombardi wrote:
> > If the initiator suddenly stops sending data during a login while
> > keeping the TCP connection open, the sk_data_ready callback won't
> > schedule the login_work and the latter
> > will never timeout and release the login semaphore.
> >
> > All the other login operations will therefore get stuck waiting
> > for the semaphore to be released.
> >
>
> You mean np_login_sem right? Do you know why we have to serialize access
> to the np during login? Is it just a simple way to handle the internal
> target variables for things like MC/s, reinstatement, etc? I saw the tsih
> case, but am wondering how easy it is to remove.

Yes, I mean the np_login_sem, right now I don't know for sure how easy
is to remove it, but I agree that probably there is room for improvement he=
re
and the login code can be simplified a lot.

>
> If we need the sem why do we use the sk_callback/non-blocking type of
> approach when we can only do 1 login at a time per tpg?

Yeah, I guess that the author just wanted the login thread to go back to
kernel_accept() as fast as possible to be able to serve the next connection=
.
But yes, if the new connection is against the same tpg, the login
thread will have
to wait for the semaphore anyway.


>
> It seems like we could simplify the login code by do a blocking type of
> implementation where:
>
> 1. __iscsi_target_login_thread starts a workstruct that runs
> iscsi_target_start_negotiation.  It would then run iscsi_target_do_login_=
rx
> which just waits for a response. When we get one, it does iscsi_target_do=
_login
> and if we need more PDUs loops. We have one timer for all this.
>
> 2. We can remove the np_login_sem. It would be replaced by a workstruct
> in the np. __iscsi_target_login_thread would just flush the work to make =
sure
> we are not running a login on the same np already.
>
> 3. We can remove all the sk_callback* related code for iscsit tcp since
> recvmsg just return failure when the state changes.
>
> 4. It looks like cxgbit will work with some small changes because I think=
 it
> just kicks off iscsi_target_do_login_rx after sending a login PDU, then i=
t
> just waits in its iscsit_get_login_rx.
>
> 5. It looks like isert will also work, because it's isert_get_login_rx ca=
n
> just wait on the login_req_comp/login_comp already.
>

Ok I think I could work on this new login code.
However, I would suggest to consider taking this patchset as a
stopgap, so the Delphix guys
can keep their customers happy and I can work on this
without feeling the pressure; also, this patchset is easier and safer
to backport to
stable kernels.

Maurizio

