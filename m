Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182F3C433FE
	for <target-devel@archiver.kernel.org>; Fri,  4 Nov 2022 09:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiKDJ5c (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 4 Nov 2022 05:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDJ5a (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 4 Nov 2022 05:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EE328702
        for <target-devel@vger.kernel.org>; Fri,  4 Nov 2022 02:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667555783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcUNwzeEDQqOmdkpFNQoBnYTmgv4Ga+RoXGdtGzEfnM=;
        b=X6p3uAZJIqngGDHVbfcEgAbSEezfyo5D1iXdmUGiRVAN7Jx2s1MFoHmhgGV1p1epXFDyAs
        Y2qG1qGsmueYKhVr9Ufly+x92BS+eYWBKwL8OT61ANoz3Juzns5CApE22r6domKoFxp8Qw
        fRwwc0zAMwrw1ny2tN+Ux5TuvEswUrk=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509-7rdzUY6HPkCEFAHqsr_sYw-1; Fri, 04 Nov 2022 05:56:21 -0400
X-MC-Unique: 7rdzUY6HPkCEFAHqsr_sYw-1
Received: by mail-ua1-f69.google.com with SMTP id n38-20020ab05929000000b004114e54ab88so2391858uad.2
        for <target-devel@vger.kernel.org>; Fri, 04 Nov 2022 02:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xcUNwzeEDQqOmdkpFNQoBnYTmgv4Ga+RoXGdtGzEfnM=;
        b=09hzArAIHm0ZtAG9E2ugxXoL1GWtASupCfEd7woncwHBCm+q/RROJXq9ji6GLSc2tG
         jfh8oTpR/BfsfV8Dgm0Ixn6ymp2gyVfVgflo1BtLb8bz3c9k2n2dDRzYFV5zYNejHGYq
         mEWDOcCQ1gZYs1YbEm/wFk9WoKOMux9Nx/+aUKpZrvi3PsAL69nh9AK1ubwrE55iib93
         hYdjPDYTMZ5a++9P2AKhcSUhGqRQqBluAh3oHKdp0urj5PW33rhUi6s783AJ9X8bNMSq
         YYHO7VPaBzAZW7onjQ1EwecOh65Pzt38+xqUgiinw93Mfiwnw0bH/QezzXiramGz5BBH
         oFeg==
X-Gm-Message-State: ACrzQf0l1+1p8uyWqWVNMRd0whbCWOoI0WcWg0vGu3lX7aM5m1GjNuda
        GCF2Kcd1UV4WeXaRg5Ok/KWwRSPw1zTAYTzDrKogD/qyCcfZbSg3mQ+Nftsl5JnzWZOeY1riAQd
        EhSEaL2zQz7+tBJ2HLIMSrDy87IWyXSMOo6XSlPay
X-Received: by 2002:a1f:2c51:0:b0:3b6:cf06:18cf with SMTP id s78-20020a1f2c51000000b003b6cf0618cfmr18355003vks.17.1667555780572;
        Fri, 04 Nov 2022 02:56:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4aLfGLlYj8K1pyCgvLUwrs9iFb8KLwGXYbnhRV0Rp1S0tCbIr5DhuJbnSqnFw7HKpFfoMkwTy+x4HmsnjqUq0=
X-Received: by 2002:a1f:2c51:0:b0:3b6:cf06:18cf with SMTP id
 s78-20020a1f2c51000000b003b6cf0618cfmr18354998vks.17.1667555780348; Fri, 04
 Nov 2022 02:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221104095041.289643-1-mlombard@redhat.com>
In-Reply-To: <20221104095041.289643-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 4 Nov 2022 10:56:08 +0100
Message-ID: <CAFL455=aosDfBmbj8PBUpBUBSe_1DG+-roYs2t4d9d7EryOGrA@mail.gmail.com>
Subject: Re: [PATCH] target: fix a race condition between login_work and the
 login thread
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

p=C3=A1 4. 11. 2022 v 10:53 odes=C3=ADlatel Maurizio Lombardi
<mlombard@redhat.com> napsal:
>
> The login has been completed but the login_work function
> will find the LOGIN_FLAGS_INITIAL_PDU flag set and will
> never stop from rescheduling itself;
> at this point, if the initiator drops the connection, the iscsit_conn
> structure will be freed, login_work will dereference a released
> socket structure and the kernel crashes.
>

A reproducer is available here:

http://bsdbackstore.eu/misc/target_kill/iscsitgtkiller.c

Maurizio

