Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4F6C433FE
	for <target-devel@archiver.kernel.org>; Mon,  7 Nov 2022 16:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKGQMX (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 11:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiKGQMW (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 11:12:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0143A1C93D
        for <target-devel@vger.kernel.org>; Mon,  7 Nov 2022 08:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667837486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jh+EXDcJkAahHMoMULmbM5Xs/CgtdVrEAp+coMCUVIk=;
        b=OGY8feCA+S4nCz9yUfW+eABtv7BdwAtOzn8MUggg/DaZO0/yjy9mUi6MwRUsWn84qhlpsv
        kMOXAK6iYnQm1VfyX3GLyQY9YJth4DaziJviXw8CGrYVGEpJWkYaWc+bb0d8sMn7z9WG/z
        AoEk9tLb1CFsc7by/rXmYc9HU5bDSfM=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-3yvIqHriMr65YjC_b5DddQ-1; Mon, 07 Nov 2022 11:11:25 -0500
X-MC-Unique: 3yvIqHriMr65YjC_b5DddQ-1
Received: by mail-ua1-f71.google.com with SMTP id a43-20020a9f376e000000b003eac6b97cf1so5380556uae.11
        for <target-devel@vger.kernel.org>; Mon, 07 Nov 2022 08:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jh+EXDcJkAahHMoMULmbM5Xs/CgtdVrEAp+coMCUVIk=;
        b=5sNkpY/OFRFPZ2mOJvPfF5xDq6Nltbu5w32M8hj5IDJZDvL8qJo1pTnDFwxo2KtPKZ
         BUTmL1KpbpxMmpCPdhhpR0bo4u1aNnYSwTvHSbXYaB84p9lhQULNTO1IU1y7Vt7HWLLV
         Z5D+tfgJJxSLtGjU+R0gUMcND5aRLtY2bJucg+bCTPMuMMcaxPTHBCpKE63mdqAYRmVh
         fAKCu5w/M2CStWKVBL0LEo0ADoCsvHyY1m1JFS16LcHNknwfOouyPq0SaYgJ6/zyMA3Z
         fVe4md9jUT+pMu5Du8T5pHb9d2gBw8TeacM7aEOZjsjKzOtGTSnU3LApZ6Ti/SeLkmpN
         LIxA==
X-Gm-Message-State: ACrzQf1JBL2tHfnkQaadNJpzkbBEpgqO6XzObOc6tfYPjppk9/TDR/6T
        o2YGpldXQcyZGuk7a0EO6K+YtgXwumDnEY+VS39KRmudGXGRR0K7tijJc55+2cRlSbq96WGIqjN
        EHwpe6U6NfsFeOQc0PDcVNgutbsN4y4+VYICeOvOe
X-Received: by 2002:a67:ea91:0:b0:3aa:19bc:16a3 with SMTP id f17-20020a67ea91000000b003aa19bc16a3mr27476328vso.22.1667837484192;
        Mon, 07 Nov 2022 08:11:24 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7yHZHazQPWQ9AfPQanDfBIE7+ycUjfOmax4iir+4XMFUL/mbonMCU3NbveTR/e14IcHTu9OH4d6CQ0QUwMjDo=
X-Received: by 2002:a67:ea91:0:b0:3aa:19bc:16a3 with SMTP id
 f17-20020a67ea91000000b003aa19bc16a3mr27476309vso.22.1667837483965; Mon, 07
 Nov 2022 08:11:23 -0800 (PST)
MIME-Version: 1.0
References: <20221104095041.289643-1-mlombard@redhat.com> <9b226985-f6d8-2fd7-6134-83255354e5bf@oracle.com>
In-Reply-To: <9b226985-f6d8-2fd7-6134-83255354e5bf@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 7 Nov 2022 17:11:12 +0100
Message-ID: <CAFL455kS4-QfRQMW---XyY8PhPt2O1YvQY=vaUkxF7bRRQi4VQ@mail.gmail.com>
Subject: Re: [PATCH] target: fix a race condition between login_work and the
 login thread
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

ne 6. 11. 2022 v 1:13 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> You can remove the cancel_delayed_work in iscsi_target_do_login_rx
> in the chunk that checks for 1 being returned since you do it here
> now.

Correct, I missed this one

>
> For the error path, I think you could also move the cancel_delayed_work_s=
ync
> from them and put it in here.
>
> If we leave it to the callers, in iscsi_target_do_login_rx in the "goto e=
rr"
> handling should this be reversed and do you want to use the _sync call li=
ke above?
>
>         iscsi_target_restore_sock_callbacks(conn);
>         cancel_delayed_work(&conn->login_work);

Yes, I noticed it too and I was already preparing a follow-up patch to fix =
this.
There is also another issue in iscsi_target_start_negotiation():

        if (ret < 0) {
                cancel_delayed_work_sync(&conn->login_work);
                iscsi_target_restore_sock_callbacks(conn);

This is obviously wrong because it leaves a small window open to race condi=
tions
I will submit a V2.

Maurizio

