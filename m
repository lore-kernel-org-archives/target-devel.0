Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E233C433FE
	for <target-devel@archiver.kernel.org>; Tue, 15 Nov 2022 08:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiKOIwS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbiKOIwC (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 03:52:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABCAF5B6
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 00:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668502260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Co/r874jLyPXeykzrTFAHHtuyR6BjwemEJqklIv5a8I=;
        b=GX4jXrVXdwJzEFwIXBtsnCGvLsjrib1vAEOeCnvTOfMpyiBLfKmukyJf/OR8kx7cPMGWPk
        vadUFSsL/HplLYRDw2E7QsdZO3bCkGa7wQdjOolJ/ALs00B5sSQHV5aE6tYCV6UpYu/cu1
        vQssQ2HY/qH2gagBanORNQnOnZajZ0E=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-58DzXa2rOAqDTz7AG_kkgw-1; Tue, 15 Nov 2022 03:50:59 -0500
X-MC-Unique: 58DzXa2rOAqDTz7AG_kkgw-1
Received: by mail-vk1-f197.google.com with SMTP id s187-20020a1ff4c4000000b003b8128789cfso2845374vkh.1
        for <target-devel@vger.kernel.org>; Tue, 15 Nov 2022 00:50:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Co/r874jLyPXeykzrTFAHHtuyR6BjwemEJqklIv5a8I=;
        b=Au5ITBx3+Ki49GZt3Yzthm/SN4dJRyGHTodEVQz4mHSkJ6Xbn3EQ616EDbPgkwoZjM
         SEkf/qO99k1DNI58BEoLSzL0URrLDuDDr8V4dhxFFGImLp8CK84Q/pa0q7/9oq8I5pgm
         bBhQVQzEl+IMfAlVZ2zIfQIjF368aM/r/2T8wqE2XmnR4xrcl1SnIldXPqMMUaWqU8JQ
         uDz8lE0yq2aBL5mA2kLonOaxRiq9GTjPUxPMiDyoOtgYrPhk75lg978OlxYGcXDZX2j5
         DcAcMSmybn7wxSc6vJK9vRQS3RqS4g4jx955unBRkVmje+gebEbWnVHlPETSKBlOnwkg
         2oGw==
X-Gm-Message-State: ANoB5pm77ImFK9cupgsDbMKymr5va26vFdhzZ0k1z3MFAL6IBgWXiQ46
        c42WvZorDkcXGusLTMwhYvbXw6oV92JxGT5n/QaQl5UhIrPlxcfPjGAUjbFBdbpj0fGHvLZa256
        JudXVJlPFdDAalJ4PrUx1MKx0eEjTn1eogmfYPXyQ
X-Received: by 2002:a05:6102:330e:b0:3aa:3916:d0ec with SMTP id v14-20020a056102330e00b003aa3916d0ecmr6935693vsc.43.1668502258344;
        Tue, 15 Nov 2022 00:50:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Ok0oAyB+LFw8I/ZTktwQ+ql9oqfQSVCD6ELwJa8s7cQeB7huX/ukQYxupzFrlryGNhMJd/YUCwybzZKgEWgU=
X-Received: by 2002:a05:6102:330e:b0:3aa:3916:d0ec with SMTP id
 v14-20020a056102330e00b003aa3916d0ecmr6935687vsc.43.1668502258145; Tue, 15
 Nov 2022 00:50:58 -0800 (PST)
MIME-Version: 1.0
References: <20221111154448.629862-1-mlombard@redhat.com> <CAFL455nJrRemuyy7HR-N0QW26Bv1fAWTs4EJGA9oJfM=eK_K5Q@mail.gmail.com>
In-Reply-To: <CAFL455nJrRemuyy7HR-N0QW26Bv1fAWTs4EJGA9oJfM=eK_K5Q@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 15 Nov 2022 09:50:46 +0100
Message-ID: <CAFL455=Q4fZbhYjJT6Xz6Wwky1ir=xRZn38Rs891Fo1GTOhT_w@mail.gmail.com>
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

=C3=BAt 15. 11. 2022 v 9:33 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
> p=C3=A1 11. 11. 2022 v 16:47 odes=C3=ADlatel Maurizio Lombardi
> <mlombard@redhat.com> napsal:
> >
> >
> > Fix this bug by forcing login_work to stop after the login has been
> > completed and the socket callbacks have been restored.
> > Also fix other potential race conditions in the error paths.
>
> Self-NACK
>
> I can't call cancel_delayed_work_sync() in iscsi_target_do_login()
> because the latter could be called from the login_work context
> and this will cause a deadlock.
>
> Will submit a V3 when ready

The correct place where to call cancel_delayed_work_sync() is in
iscsi_target_start_negotiation(), because the latter is only called
in the login_thread context.

I'm going to test the following:

diff --git a/drivers/target/iscsi/iscsi_target_nego.c
b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..b9bd77f41c8d 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1363,12 +1363,14 @@ int iscsi_target_start_negotiation(
                ret =3D -1;

        if (ret < 0) {
-               cancel_delayed_work_sync(&conn->login_work);
                iscsi_target_restore_sock_callbacks(conn);
+               cancel_delayed_work_sync(&conn->login_work);
                iscsi_remove_failed_auth_entry(conn);
        }
-       if (ret !=3D 0)
+       if (ret !=3D 0) {
+               cancel_delayed_work_sync(&conn->login_work);
                iscsi_target_nego_release(conn);
+       }

        return ret;
 }



Maurizio

