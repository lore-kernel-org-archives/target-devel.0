Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA75BC433EF
	for <target-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D8060F45
	for <target-devel@archiver.kernel.org>; Mon,  6 Sep 2021 11:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhIFLjG (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 07:39:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhIFLjF (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 07:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630928280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FF7PyqT5538j7crQb8mCsUxkH/b9hMp4ZBA+FJagV04=;
        b=dUfcdHkQZ83VE3tFI6pKPQVjTaq9GMdzudmi/fDDCYLPPErTTLRDVj1//QQHnLruGxGo04
        ivphKK98uAEEE0M+z9zCVK6hTenLQaQ5d9UwE4Rh8uFvAz9tNk+u2s9He2eHOotGksRTKt
        jkiau/2XzRLsGzKwcE2Xx3oTOVDfOhY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-IkbXRy_IPVqnpXmFjgVP8Q-1; Mon, 06 Sep 2021 07:37:59 -0400
X-MC-Unique: IkbXRy_IPVqnpXmFjgVP8Q-1
Received: by mail-io1-f71.google.com with SMTP id k6-20020a6b3c060000b0290568c2302268so4891408iob.16
        for <target-devel@vger.kernel.org>; Mon, 06 Sep 2021 04:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FF7PyqT5538j7crQb8mCsUxkH/b9hMp4ZBA+FJagV04=;
        b=bG6ZeSr1/+Bg9rxiQBu4pAtO+avd3eZFGHUlfCbAcn45v0edvMrJYPPv2U5nDliy4Q
         vQMPzXnRSvo2KDqMi8vW8t1LW9lv7AdR1Tudw3LRY+rj00b/3OWK+YbWs2OJmPYaTlN2
         AtGWt9imOAcJfwpFkOcOEC9dJFpdjEwVzz2HIrYj8qiponmnfN850/ORsI8/PhctSHIs
         /iVa5VfFFjKNpg6Hd6Qikp5RB9UwaQb2Qm1zfM7oyUkRHyfVo+ekimShCJCLdkhTe+pd
         XihFbgacSs7Bj4Ri1OHFCD3E/EiGjlqJ0m0ZPP82ymO1ORvtWyHIssK8u1mqTDcI0HhE
         GYCg==
X-Gm-Message-State: AOAM532Wy23ZQFA7Ky57dFHf6UfXQso4F0SJm78sWsiRtUfESdsHKiwI
        p+3fihtmr1XkhyGCU4QSv+XFkan8IsXKtQVrbVPN8Kc20zYbLtH/K8+N3v0vdeuDNeJboP0IHmT
        NKBpyV7mgUtYiTA0BjGgrIEs68nTqy1R7SOoxntp/
X-Received: by 2002:a05:6638:339b:: with SMTP id h27mr7708198jav.118.1630928278823;
        Mon, 06 Sep 2021 04:37:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzw6QL93K+b3wTldfFdspLjxR7+RKQ40oO5eLkX9pqWPffkxGv72NWhIxfmPPhh8Eu9N/duXaW0Cnmvl/Ttq+8=
X-Received: by 2002:a05:6638:339b:: with SMTP id h27mr7708180jav.118.1630928278567;
 Mon, 06 Sep 2021 04:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210903124800.30525-1-mlombard@redhat.com> <e3c5d767-6d31-3496-b2c3-d843a9e2d80f@oracle.com>
In-Reply-To: <e3c5d767-6d31-3496-b2c3-d843a9e2d80f@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 6 Sep 2021 13:37:47 +0200
Message-ID: <CAFL455m1+OjFROHov6trw-Wu788X3hO9qq3uADBP5hBcg1e+fA@mail.gmail.com>
Subject: Re: [PATCH] target: fix the pgr/alua_support_store functions
To:     michael.christie@oracle.com
Cc:     martin.petersen@oracle.com, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

so 4. 9. 2021 v 22:05 odes=C3=ADlatel <michael.christie@oracle.com> napsal:
>
> Maybe you want to use -ENOSYS. Other lio sysfs files return that when the
> operation is not supported. You could then handle all the warnings with
> the same check.
>

Ok, better to be consistent with other LIO sysfs functions.
I will submit a V2 later today.

Thanks,
Maurizio

