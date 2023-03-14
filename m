Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9201AC6FD1D
	for <target-devel@archiver.kernel.org>; Tue, 14 Mar 2023 11:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCNLLY (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 07:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCNLK7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 07:10:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D8162308
        for <target-devel@vger.kernel.org>; Tue, 14 Mar 2023 04:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678792157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/2zFAWQEuHaJfcSVzbNqnkFuw5SDf0IHA3RlQWQ330=;
        b=GwenCG0fP1Qnb8jqWtuaARhgBpHGHJhe42PRvPoxV89LicCjj+zfplCArlfzEY+rqvPfre
        5oJexm0V90DhXr5u2DTBf1Jao5gqFLHz69DMVJKlRJNOastDedXRcGFScKI475YeyYhhm0
        m9inQYx37J2j8mDPIVZpalxK9BG2wOU=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-A-9Uh6raPPSg9n2tx9q4TQ-1; Tue, 14 Mar 2023 07:09:16 -0400
X-MC-Unique: A-9Uh6raPPSg9n2tx9q4TQ-1
Received: by mail-vs1-f70.google.com with SMTP id i21-20020a05610221b500b004258d5ee8c4so1791759vsb.0
        for <target-devel@vger.kernel.org>; Tue, 14 Mar 2023 04:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678792156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z/2zFAWQEuHaJfcSVzbNqnkFuw5SDf0IHA3RlQWQ330=;
        b=Pd3wRsxq/FTgcnFJgcHvxqZUOrrLKx8iqTzOfh6wjHqJHIeRBid0KeEfGcz48MelLs
         9BIco4ynn9C8FbSAnWrWzCsWAlDzCYRhxipCFGwLWFyavO3KXEyUDjWnTjj3WRfE/NlK
         wA2RlBwZGrtG/pPYKHpqvNYb6g/Imcis3tEE9/Ist8cMI6PZGxeec2o7AwefJ/IfLa5r
         mraJQ2xXjBkt6g6si55R3zSVt5SiECrLmOetBywY1Jz1AOVOnHWpcMujDBgfQiim3UwA
         NoConSmfniorKoz/58pgMiBE5rMJwviDayAfirAv3IitmxUDx17AV5b+0PEXL39vxiAx
         QOfQ==
X-Gm-Message-State: AO0yUKUqShKOiVuwTbrr6YzFMuRl9FBNHgsJyqD9CYS1mKXTrGUnm4rn
        JQzKoKj9hBFZ3Pc9s473iFcBNwG4gqPKcD9gHEWHtBQ7w/MOPxXLGf27nfYmITatdXNVgOX1MGK
        Wic8xWo5XatwcTUOKlyUyy8OsmpRAH0nWSAPbZUyX
X-Received: by 2002:a67:cb8f:0:b0:423:e7bf:ef7 with SMTP id h15-20020a67cb8f000000b00423e7bf0ef7mr4850936vsl.7.1678792155753;
        Tue, 14 Mar 2023 04:09:15 -0700 (PDT)
X-Google-Smtp-Source: AK7set8HhxjOdbaB9gObu1UOzVOqX8DxslX83lPBDmncYZcWwUkKTJFV8YNgFUuuHPfrtBDJzkvom8diZxOSnCtDxQs=
X-Received: by 2002:a67:cb8f:0:b0:423:e7bf:ef7 with SMTP id
 h15-20020a67cb8f000000b00423e7bf0ef7mr4850921vsl.7.1678792155424; Tue, 14 Mar
 2023 04:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230310100423.1258256-1-mlombard@redhat.com> <20230310100423.1258256-2-mlombard@redhat.com>
 <f492ed26-58fd-0f4d-b1f2-b4cbd2cca233@oracle.com>
In-Reply-To: <f492ed26-58fd-0f4d-b1f2-b4cbd2cca233@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 14 Mar 2023 12:09:03 +0100
Message-ID: <CAFL455=HQ9-juB5fCqRJYmLK-jH3RuLCQM1Rk6bzG4QA-yWq4Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

=C3=BAt 14. 3. 2023 v 0:52 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> > +     case TCP_CLOSE:
> > +             pr_debug("__iscsi_target_sk_check_close: socket closing,"
> >                       "returning TRUE\n");
>
> Don't need to break up a string. We do it a lot in the lio code, but we'v=
e
> been trying not to in new code.
>
> > +             /*
> > +              * Restart the login timer to prevent the
> > +              * login process from getting stuck if the initiator
>
> I would fix up the formatting so the first line is longer.

Ok

> > @@ -1358,6 +1348,9 @@ int iscsi_target_start_negotiation(
> >               set_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
> >               write_unlock_bh(&sk->sk_callback_lock);
> >       }
> > +
> > +     iscsit_start_login_timer(conn);
>
> At this time, we have the np->np_login_timer running right?

Yes.

>
> Don't we only need to start this new timer when we know there are
> more PDUs and the connection is good (iscsi_target_do_login returns
> 0 and iscsi_target_sk_check_and_clear returns 0)?

The moment iscsi_target_sk_check_and_clear() clears the
LOGIN_FLAGS_INITIAL_PDU flag
and returns 0, the login worker may be already running.
If we start the timer after the call to
iscsi_target_sk_check_and_clear(), we could have a race condition:

1) login_work runs and reschedules itself non-stop because
LOGIN_FLAGS_INITIAL_PDU is set
2) login kthread calls  iscsi_target_sk_check_and_clear() and clears
LOGIN_FLAGS_INITIAL_PDU
3) login work runs and completes the login
4) login kthread starts the timer
5) No one stops the timer, it fires and kills the connection despite
the fact the login was successful.

I could however replace this code:

ret =3D iscsi_target_do_login(conn, login);
 if (!ret && iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU)=
)
           ret =3D -1;

with the following, if you like it more:

ret =3D iscsi_target_do_login(conn, login);
if (!ret) {
      iscsit_start_login_timer(conn);
      if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU)) {
           iscsit_stop_login_timer(conn);
           ret =3D -1;
      }
}

>
> I think you can just kill np timer and only use the login_timer for
> both cases. So I mean set the thread to kill as the login one and start
> this login_timer in __iscsi_target_login_thread where we used to call
> iscsi_start_login_thread_timer. You would then mod the timer when we
> transition from iscsi_target_start_negotiation to waiting for the next
> PDU.
>

Yes, maybe, but I would need to find a way to detect if conn->login_kworker
is pointing to the login thread or to the login_work's thread, because
the np_login_timer is supposed to clear the ISCSI_TF_RUNNING flag.

maybe something like this:

if (conn->login_kworker =3D=3D conn->tpg_np->tpg_np->np_thread) {
     spin_lock_bh(&np->np_thread_lock);
     if (!(np->np_login_timer_flags & ISCSI_TF_STOP))
           np->np_login_timer_flags &=3D ~ISCSI_TF_RUNNING;
     spin_unlock_bh(&np->np_thread_lock);
}

> For isert and cxgbit we won't have conn->sock set so I think you need som=
e
> sort of callout for those drivers, or maybe set LOGIN_FLAGS_CLOSED and qu=
eue
> the login_work. Maybe the latter will work for all drivers as well. You p=
robably
> need some extra locking and LOGIN_FLAGS checks to handle an issue similar=
 to
> below.

Hmm, that would need to be tested, because LOGIN_FLAGS_CLOSED is supposed
to be set when the socket is already in the process of getting closed
(it's state is TCP_CLOSE_WAIT or TCP_FIN_WAIT* or whatever)
So If I set LOGIN_FLAGS_CLOSED in the timer and the socket is
TCP_ESTABLISHED it means that I am trying to
do the opposite, will the socket be properly closed
by isert/cxgbit in this case?

>
> If we do need to do the kernel_sock_shutdown we might need to add some co=
de
> to not call it twice (I'm not sure it's fully supported). It looks like w=
e
> can race and do:

Correct, thanks. In that case a check like this should be sufficient.

if (!test_bit( LOGIN_FLAGS_CLOSED))
     kernel_sock_shutdown(sock, SHUT_RDWR);


Maurizio

