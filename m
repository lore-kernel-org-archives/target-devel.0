Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F0FC64ED6
	for <target-devel@archiver.kernel.org>; Wed,  1 Mar 2023 11:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCAL63 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 06:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCAL60 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 06:58:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800062F7B7
        for <target-devel@vger.kernel.org>; Wed,  1 Mar 2023 03:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677671855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mHl5KQjEc4/d6SgEY0TdUVaYr+bU97RLVBw2BBUuA38=;
        b=IzK5Tj+b9zVUvuXav6xbVx3HcaHafSD8i/DCv+uVd1UyPER/PlKnjHST2RupKkXCh4lPrq
        Igimw2KVaWUlXsV8DC/cLGO3WdRsR79iWomj6BcTFctoSRZWDtoF+Qkoqzi6beDOR3rhKU
        nHp7xkoaplu2eLPpW/bKvPGj6Zk1ncM=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-dGb70gUMMQOHU4pmlWpYfQ-1; Wed, 01 Mar 2023 06:57:34 -0500
X-MC-Unique: dGb70gUMMQOHU4pmlWpYfQ-1
Received: by mail-ua1-f72.google.com with SMTP id j21-20020a9f3095000000b006901584fb3aso2201342uab.7
        for <target-devel@vger.kernel.org>; Wed, 01 Mar 2023 03:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677671853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mHl5KQjEc4/d6SgEY0TdUVaYr+bU97RLVBw2BBUuA38=;
        b=aLJ0rjj6LBpm6SoPvOGxWOG1XEyoqM2zSa6bRSCKBssLwQEkkAwf6Jt1l6SS+o+krW
         FC2wEgBz/6rAVLe9AL9ALkDkQasXHKgocgdBJGmomRo6sQ8h5EsP1H4xoyMGeeWrPjtF
         jIxzjDMv5KCc/JxK/j4tBUSmbSYcWFvd6abBAh+R4bQWTKtMtiRGIAKtsel4DdjusRkF
         w/vFwitWp/QpMpssZP43U2dxQkoKLF9danHPkhy2iamnwjdExY21szYROCfUY5pKXQUS
         W73vuhoPWFIzCJwQXgY7xt+gBsZF9+Nh71NgCc1c/ZbwmZ4qsrSDf/uefLQgFnDqI84W
         s5/w==
X-Gm-Message-State: AO0yUKUpmTmprDmUyM0EQSZyz3huxx4lCwLelVAesgjSRIjXCFDTssp1
        xwMU8SSH1hkPENbP2O0zA7OyVNAXbELRavLKgrFlDSK06C4kueF5nVkO33ygiDGJxFiyZ4ZMpp6
        QHqQ2hI+fSFv/afJDAh0zsWyjMSnRlRlG/WfXWUQZ58xsuQ==
X-Received: by 2002:a05:6122:656:b0:401:8898:ea44 with SMTP id h22-20020a056122065600b004018898ea44mr3351179vkp.3.1677671853359;
        Wed, 01 Mar 2023 03:57:33 -0800 (PST)
X-Google-Smtp-Source: AK7set9l846Pjlw2nULxarUi1PRFBt3nBG6v0YrgnYC4ddQ7sWQ5MmNP5msaiDYvAL+l07xHgrEbEXqOCSsuiMJsbhs=
X-Received: by 2002:a05:6122:656:b0:401:8898:ea44 with SMTP id
 h22-20020a056122065600b004018898ea44mr3351172vkp.3.1677671853105; Wed, 01 Mar
 2023 03:57:33 -0800 (PST)
MIME-Version: 1.0
References: <20230129234441.116310-1-michael.christie@oracle.com> <20230129234441.116310-6-michael.christie@oracle.com>
In-Reply-To: <20230129234441.116310-6-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 1 Mar 2023 12:57:21 +0100
Message-ID: <CAFL455=QjP9TutSh0e5KS0R07PK3Pvcv+6xNkP6i6ExGv+gCpg@mail.gmail.com>
Subject: Re: [PATCH v3 05/14] scsi: target: iscsit: stop/wait on cmds during
 conn close
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, mgurtovoy@nvidia.com, sagi@grimberg.me,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 30. 1. 2023 v 0:45 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> This fixes a bug added in:
>
> commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
> race")
>
> If we have multiple sessions to the same se_device we can hit a race wher=
e
> a LUN_RESET on one session cleans up the se_cmds from under another
> session which is being closed. This results in the closing session freein=
g
> its conn/session structs while they are still in use.
>
> The bug is:
>
> 1. Session1 has IO se_cmd1.
> 2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
> but then gets a LUN_RESET.
> 3. The LUN_RESET on session2 sees the se_cmds on session1 and during
> the drain stages marks them all with CMD_T_ABORTED.
> 4. session1 is now closed so iscsit_release_commands_from_conn only sees
> se_cmds with the CMD_T_ABORTED bit set and returns immediately even
> though we have outstanding commands.
> 5. session1's connection and session are freed.
> 6. The backend request for se_cmd1 completes and it accesses the freed
> connection/session.
>
> This hooks the iscsit layer into the cmd counter code, so we can wait for
> all outstanding se_cmds before freeing the connection.
>
> Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race=
")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 11115c207844..83b007141229 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4245,6 +4245,16 @@ static void iscsit_release_commands_from_conn(stru=
ct iscsit_conn *conn)
>                 iscsit_free_cmd(cmd, true);
>
>         }
> +
> +       /*
> +        * Wait on commands that were cleaned up via the aborted_task pat=
h.
> +        * LLDs that implement iscsit_wait_conn will already have waited =
for
> +        * commands.
> +        */
> +       if (!conn->conn_transport->iscsit_wait_conn) {
> +               target_stop_cmd_counter(conn->cmd_cnt);
> +               target_wait_for_cmds(conn->cmd_cnt);
> +       }
>  }
>
>  static void iscsit_stop_timers_for_cmds(
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

