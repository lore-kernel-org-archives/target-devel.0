Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B47C4332F
	for <target-devel@archiver.kernel.org>; Fri, 11 Nov 2022 16:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiKKQWA (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 11:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiKKQV7 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 11:21:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937D4DE0
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668183663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mgrmt+vkwrWYuO/XfU8v/kNOaYXdZwiyzihQARvMP64=;
        b=CaOXMBaMUG9zeKbqqyR8TWREbA6x5UWsUd1o5o0No165pXzhUdv3mtQ9+pyjtvKgjTi5Hi
        9MxNWy2Rhi5fL24QO/a9N8v49+Yh9Cd+XZqoMECwNpJXHBc0OduSzh6NQj9zLjXCElD4R4
        i2mYU/GuOTDi3JKybh4SDNiK2Q3z2mw=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-282-8QDeoneONAK98FFZXmYJhA-1; Fri, 11 Nov 2022 11:21:02 -0500
X-MC-Unique: 8QDeoneONAK98FFZXmYJhA-1
Received: by mail-ua1-f69.google.com with SMTP id y10-20020ab0560a000000b003af33bfa8c4so2195897uaa.21
        for <target-devel@vger.kernel.org>; Fri, 11 Nov 2022 08:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mgrmt+vkwrWYuO/XfU8v/kNOaYXdZwiyzihQARvMP64=;
        b=lQAzNUeWcqcaNwCifDaTzQgq9C0Cmfg909QLYNraZGbKx6UIAUrSyKQfWCyO4/iU6s
         QpsxM8kdNUuaKX6uIJRYozNg+nW8GMefNQ/3f0XTTrXSP0Gu5qdGG/EUZuoNEuzddNpu
         vPsw6G+HNMbKpGhh6kDlERRq/Tm9Sk2OebSR2eB8iGd6/JzPNY1I8EM9ksEcAaF8IMT8
         NtjPxxU1tvYwO0TAPpeKN2eu6ez680q5BTBnXgUGLDoagO+l42iVPGP5c8PJz3oQA6Jv
         dF1iwNxJqObPUFGEvu7ddGzrhMCkZvXM0S/iXPvfio1xeZAKuLostKvfkkp4h+JNIQf/
         8GzA==
X-Gm-Message-State: ANoB5pmTUh1BwaJvqrCROHWsUw05xOqNpzZr43kqbXpOY2jXxppFu6CN
        rr2hSv2nmEHhVRUlsx4ORZuq4rTBUB/Dc4N4YxSWQxRGVeyf8PtNrhV75eQbaRFtxwQmxNc+dlM
        MmexirCSyWe8lcQy0YYQew4aVsZqrMfl3frWNeqqa
X-Received: by 2002:a1f:4512:0:b0:3ae:beb7:c880 with SMTP id s18-20020a1f4512000000b003aebeb7c880mr1339126vka.38.1668183660962;
        Fri, 11 Nov 2022 08:21:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4er9+KhET27+PjBmFUYAbQzrj9X6O6bb1H74sYojnzoe7wCDRWreDO7UJJm1vjLP34oJr7wHCFamx398ij6sg=
X-Received: by 2002:a1f:4512:0:b0:3ae:beb7:c880 with SMTP id
 s18-20020a1f4512000000b003aebeb7c880mr1339114vka.38.1668183660712; Fri, 11
 Nov 2022 08:21:00 -0800 (PST)
MIME-Version: 1.0
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 11 Nov 2022 17:20:49 +0100
Message-ID: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
Subject: tcm_loop and aborted TMRs
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Bodo, Mike,

Some of our customers reported that the tcm_loop module is unable
to handle aborted TMRs, resulting in kernel hangs.

I noticed that Bodo submitted a patch some time ago (our customers
confirm it works),
Mike instead proposed to revert
commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".

The discussion unfortunately died out without reaching a conclusion.

Personally, I think that if the handling of aborted TMRs was working
before the "Use system workqueues" commit then this should be
considered as a regression and the commit should be reverted.

Maurizio

