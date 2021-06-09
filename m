Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A6BC48BCD
	for <target-devel@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7F761181
	for <target-devel@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhFIKYo (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 06:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235969AbhFIKYo (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 06:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAlpcwXxfMSgkhywa6PEh6W4QsyHwiWPznIrBqXf590=;
        b=bsPdjZiE5f1MhpyH+ysu0QA+szksOPPX9Bg4cahUw4dm7ZYl/mzN6YJfSSqyhBGaNL3uw4
        xUjwMBy2ZXD8wuLQuSn4jR8WxCvelJqgAyY9F41FwPViG2lgkUxnlU0xRCOXy8VGs29cV+
        GMWkT1CY9RiMMZta3ZU6hdUdvKF06MA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-cHfbgBPXN4yFXlF93y7FkA-1; Wed, 09 Jun 2021 06:22:48 -0400
X-MC-Unique: cHfbgBPXN4yFXlF93y7FkA-1
Received: by mail-il1-f199.google.com with SMTP id g12-20020a056e021a2cb02901dfc46878d8so18444617ile.4
        for <target-devel@vger.kernel.org>; Wed, 09 Jun 2021 03:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PAlpcwXxfMSgkhywa6PEh6W4QsyHwiWPznIrBqXf590=;
        b=RsRM7Bn3eUEWBZ74qI1UpdufvGTevieLbGnx17aZ3EvPvizymbaC1lpe0I6Z7G0woB
         VizDZbQ5HfTGgbMfUA4b08xZ5F9ST6L8dQ2Isyfv3PP3dq1AAtkkEm2j7IOkGa3FQwFl
         dMABPqIojlqPZvyGBej5hFLvhyTHv5049dItWmWoQWEFgHjrVhmro3l8eGM7A9eNZbW6
         gmeV2wZG7FsEoGvKY53YmSmrFDHIhwod3y4JAvoBSFPem9hBXomsp0B4vMLoFLfhqyas
         kzOqoBSv39AR1XkhF4d0oGKt8488aoJzPEPNfmYQ/uqh2hEpDprd/ii5g6jcLZUox9Dl
         c7cg==
X-Gm-Message-State: AOAM532ptE2XdAd7IEPndTJcYJin3n4bgyP/29F529XoQPvi8Tgu9Mi0
        D/jT4rH48QO81hDD5W6thXyUbnlw0lQXurVNN9nFucQvs7XAu5XMRAD9NX9AjD68AEZ2LrWG6vc
        gCxcO58aC0s7PTym1A/TNnwDQvoBG8nr8uzmbxMYB
X-Received: by 2002:a05:6e02:1a4a:: with SMTP id u10mr12562588ilv.226.1623234167726;
        Wed, 09 Jun 2021 03:22:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQggx4ywFSEQ/DXU0sAUCaE6WuawiBJRstfZYeh0e2ljeuqT7Sez92ISwAZN5UKTeFGlUPLvYdJyp8Kbftn/s=
X-Received: by 2002:a05:6e02:1a4a:: with SMTP id u10mr12562579ilv.226.1623234167516;
 Wed, 09 Jun 2021 03:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210608164047.128763-1-mlombard@redhat.com> <YL/5074knGDS2Ska@SPB-NB-133.local>
In-Reply-To: <YL/5074knGDS2Ska@SPB-NB-133.local>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 9 Jun 2021 12:22:36 +0200
Message-ID: <CAFL455=Bi5aAfJtjpM0xzWdb4xoKW+JfnNO_2NJ2tvBQGfM6-g@mail.gmail.com>
Subject: Re: [PATCH] target: remove the auth_type field from iscsi_session
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

st 9. 6. 2021 v 1:14 odes=C3=ADlatel Roman Bolshakov <r.bolshakov@yadro.com=
> napsal:
>
> Hi Maurizio,
>
> It might still be useful to carry the meaning of "effective auth_type"
> in case of complex auth configuration. Otherwise there's no way to check
> what auth settings took effect for a particular session/I_T nexus.
>
> I think we should rather print auth_type value someplace in configfs
> than delete the field altogether.

Ok I see what you mean.

If acls are used, identifying the CHAP-protected sessions is
trivial... you just have
to look under configfs /tptg_1/acls/.../auth and tptg_1/acls/.../info

If dynamic sessions are allowed and the tgt parameter AuthMethod  is
"CHAP,None",
you could end up having some initiators using CHAP and some not...
AFAIK, in this case, there is currently no way to find out if a
particular session used CHAP or not.

If it could really be useful to know that, then one possible solution
is to add this
information to the "dynamic_sessions" list in configfs,
but I'm not really sure this is acceptable because it could break the
user applications
that rely on this list.

Another solution that comes to my mind is to create a new configfs
node "sessions_info"
that contains a list of all connected initiators, their iqns,
authentication method etc.
but if the list is too long it could be truncated (attribute's max
size is PAGE_SIZE).

Or we could create a new configfs directory "sessions" and each
session would have it's own
entry there.

Maurizio



>
> Regards,
> Roman
>
> >       if (strstr("None", authtype))
> >               return 1;
> >       else if (strstr("CHAP", authtype))
> > diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/=
iscsi/iscsi_target_core.h
> > index 1eccb2ac7d02..f0495515ca6a 100644
> > --- a/include/target/iscsi/iscsi_target_core.h
> > +++ b/include/target/iscsi/iscsi_target_core.h
> > @@ -647,7 +647,6 @@ struct iscsi_session {
> >
> >       /* LIO specific session ID */
> >       u32                     sid;
> > -     char                    auth_type[8];
> >       /* unique within the target */
> >       int                     session_index;
> >       /* Used for session reference counting */
> > --
> > Maurizio Lombardi
> >
>

