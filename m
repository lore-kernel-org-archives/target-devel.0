Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DA7C6FD1D
	for <target-devel@archiver.kernel.org>; Tue, 21 Mar 2023 17:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCURQn (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 21 Mar 2023 13:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCURQm (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 21 Mar 2023 13:16:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A202884A
        for <target-devel@vger.kernel.org>; Tue, 21 Mar 2023 10:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679418837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grrcwJy9UFuSiQUQwbGxu1stZ3qDAPwMLxCO0BBLN+U=;
        b=QzOlUo6WQVgsr3R8tf1O2xMe2SdkvbtYiMd3AYMD+28a51kxtOv8Tu9ENp6sePMkoHyiKg
        A/DnrlAQJ+tlG5eymDLn4UitubqP9sBUb9YTx0eexqKRpfnQFz6/fD7TEphvgWGQ/zYNFm
        8zTN9QM6xCrv0RyW2jpCJgZZo43f0p8=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-ChrFhPOjOHKjVmYvoDciGg-1; Tue, 21 Mar 2023 13:13:55 -0400
X-MC-Unique: ChrFhPOjOHKjVmYvoDciGg-1
Received: by mail-ua1-f69.google.com with SMTP id 93-20020a9f2066000000b00743dc8a5085so8211598uam.7
        for <target-devel@vger.kernel.org>; Tue, 21 Mar 2023 10:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grrcwJy9UFuSiQUQwbGxu1stZ3qDAPwMLxCO0BBLN+U=;
        b=mzBj7R8H0Y8/OzJn5uxXJL5Fj2ygnVF0+tAdAVHLLxAVLCJg+96R3W5ZEI/U6Vkuwd
         0b+hcOxM1wCZ1pysE4o/9IE+EAEBpFCRVEKD5FMDDSpNrkTmbFu2OEzXp523aLZhLLMH
         Q0MORG+fX9Wck2dIMVwK4ETPUvo1+qeL4v2BlaAgUcgytYLWBLyAi4q21yNKaCeq/ijb
         7/bYr2CyMw883EaI44LG9r7vqy8PbDjsiIsYwbJGQMiWUq/6Xjt/8RW+RfdpmzlNfXTJ
         1CrCiEOhCksgOombNZw9nsG/97VdWaXs/802fuOK63fPszC9Sk352Jw/lO1qncjwOMX3
         Vnjg==
X-Gm-Message-State: AAQBX9dJtgSufSz9UPXeBfRJEWaUFs2mBMx+Nu9MsABHo7GC1aRSBIWU
        PGEcJynETDTHatiX3SjrvOdWI71ezaOYWBU+XErepIEbolIAxlA1vx7A/im4MvKV9OrizD33H3M
        hLnS0+cAJI449T4y3ARtgGX+wEknliSCYbzwqsqOI
X-Received: by 2002:a67:d891:0:b0:425:b38b:650 with SMTP id f17-20020a67d891000000b00425b38b0650mr2129144vsj.7.1679418835290;
        Tue, 21 Mar 2023 10:13:55 -0700 (PDT)
X-Google-Smtp-Source: AK7set/xgJRVtSYbj/+eXHX5dtBSgLnzs0I/WtFvAsvuQ1XnR5ZIPTcwvHjo6nUaMsfxkJRuGePVHLExwV2BkQ7EcXI=
X-Received: by 2002:a67:d891:0:b0:425:b38b:650 with SMTP id
 f17-20020a67d891000000b00425b38b0650mr2129129vsj.7.1679418834949; Tue, 21 Mar
 2023 10:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230310100423.1258256-1-mlombard@redhat.com> <20230310100423.1258256-2-mlombard@redhat.com>
 <f492ed26-58fd-0f4d-b1f2-b4cbd2cca233@oracle.com> <CAFL455=HQ9-juB5fCqRJYmLK-jH3RuLCQM1Rk6bzG4QA-yWq4Q@mail.gmail.com>
 <afb25e86-3b1a-3b19-f257-e748d0900005@oracle.com>
In-Reply-To: <afb25e86-3b1a-3b19-f257-e748d0900005@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 21 Mar 2023 18:13:42 +0100
Message-ID: <CAFL455m+Kt9fsojo5sYTt8wMmDQRr2TRvOO=+_0BXMeOK3X_Rw@mail.gmail.com>
Subject: Re: [PATCH 1/3] target: iscsi: fix hang in the iSCSI login code
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

=C3=BAt 14. 3. 2023 v 22:23 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> On 3/14/23 6:09 AM, Maurizio Lombardi wrote:
> > =C3=BAt 14. 3. 2023 v 0:52 odes=C3=ADlatel Mike Christie
> > <michael.christie@oracle.com> napsal:
> >>
> >>> +     case TCP_CLOSE:
> >>> +             pr_debug("__iscsi_target_sk_check_close: socket closing=
,"
> >>>                       "returning TRUE\n");
> >>
> >> Don't need to break up a string. We do it a lot in the lio code, but w=
e've
> >> been trying not to in new code.
> >>
> >>> +             /*
> >>> +              * Restart the login timer to prevent the
> >>> +              * login process from getting stuck if the initiator
> >>
> >> I would fix up the formatting so the first line is longer.
> >
> > Ok
> >
> >>> @@ -1358,6 +1348,9 @@ int iscsi_target_start_negotiation(
> >>>               set_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
> >>>               write_unlock_bh(&sk->sk_callback_lock);
> >>>       }
> >>> +
> >>> +     iscsit_start_login_timer(conn);
> >>
> >> At this time, we have the np->np_login_timer running right?
> >
> > Yes.
> >
> >>
> >> Don't we only need to start this new timer when we know there are
> >> more PDUs and the connection is good (iscsi_target_do_login returns
> >> 0 and iscsi_target_sk_check_and_clear returns 0)?
> >
> > The moment iscsi_target_sk_check_and_clear() clears the
> > LOGIN_FLAGS_INITIAL_PDU flag
> > and returns 0, the login worker may be already running.
> > If we start the timer after the call to
> > iscsi_target_sk_check_and_clear(), we could have a race condition:
> >
> > 1) login_work runs and reschedules itself non-stop because
> > LOGIN_FLAGS_INITIAL_PDU is set
> > 2) login kthread calls  iscsi_target_sk_check_and_clear() and clears
> > LOGIN_FLAGS_INITIAL_PDU
> > 3) login work runs and completes the login
> > 4) login kthread starts the timer
> > 5) No one stops the timer, it fires and kills the connection despite
> > the fact the login was successful.
> >
> > I could however replace this code:
> >
> > ret =3D iscsi_target_do_login(conn, login);
> >  if (!ret && iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_=
PDU))
> >            ret =3D -1;
> >
> > with the following, if you like it more:
> >
> > ret =3D iscsi_target_do_login(conn, login);
> > if (!ret) {
> >       iscsit_start_login_timer(conn);
> >       if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_INITIAL_PDU=
)) {
> >            iscsit_stop_login_timer(conn);
> >            ret =3D -1;
> >       }
> > }
>
> Ah yeah, I wasn't thinking specifically about this race when I wrote the
> above comment. With the combined timer below, I was thinking this is hand=
led
> when you set/check the login_kworker thread.
>
> >
> >>
> >> I think you can just kill np timer and only use the login_timer for
> >> both cases. So I mean set the thread to kill as the login one and star=
t
> >> this login_timer in __iscsi_target_login_thread where we used to call
> >> iscsi_start_login_thread_timer. You would then mod the timer when we
> >> transition from iscsi_target_start_negotiation to waiting for the next
> >> PDU.
> >>
> >
> > Yes, maybe, but I would need to find a way to detect if conn->login_kwo=
rker
> > is pointing to the login thread or to the login_work's thread, because
> > the np_login_timer is supposed to clear the ISCSI_TF_RUNNING flag.
> >
> > maybe something like this:
> >
> > if (conn->login_kworker =3D=3D conn->tpg_np->tpg_np->np_thread) {
> >      spin_lock_bh(&np->np_thread_lock);
> >      if (!(np->np_login_timer_flags & ISCSI_TF_STOP))
> >            np->np_login_timer_flags &=3D ~ISCSI_TF_RUNNING;
> >      spin_unlock_bh(&np->np_thread_lock);
> > }
>
> We don't need any of the np_login_timer_flags code if we are using your p=
er
> conn login_timer do we?

Ah yes you're right, I was just confused by all those
"ISCSI_TF_RUNNING/STOP" flags used all
over the place, then I realized that every timer has its own flags.

>
> For the new timer:
> - We are adding one per conn timer.
> - We use that for both the initial pdu and later ones.
> - The timeout function, sends a signal if there is a thread set or does w=
hatever
> we figure out below for the case where there is no thread (we don't do an=
y
> np_login_timer_flags stuff).
> - We probably don't need to do both the signal and whatever we decide bel=
ow.
> Or, we need to check some of the LOGIN_FLAGS since for example we don't
> need to queue the login_work and set LOGIN_FLAGS_CLOSED if LOGIN_FLAGS_IN=
ITIAL_PDU
> is set.
> - The iscsi_start_login_timer function handles setting the login_kworker =
thread.

Ok I have a V2 almost ready, I'm testing it right now.

Maurizio

