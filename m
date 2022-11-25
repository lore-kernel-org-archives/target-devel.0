Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E21C433FE
	for <target-devel@archiver.kernel.org>; Fri, 25 Nov 2022 08:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiKYIIB (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 03:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKYIIB (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 03:08:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9A218B8
        for <target-devel@vger.kernel.org>; Fri, 25 Nov 2022 00:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669363623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKQdTNPvgD/Alsaw10kR8h6Q5yEnbkLUsazn3r2G1aI=;
        b=gNuxkWkGfPiFN/vHqQq1nWzeMR8NMaW5nb6FNUao4DlNpxxGzEiJoPttDEuHySGHZLRpOm
        bX0AThWFU0U+Nq2MK9A1tyovpvbWGxN/gn+tWAFEC49yo1bjcxHyESGz2LE4fIz31qhHIi
        gvlrTzFCx9C6CKDY767ijGK7nOSzVzc=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-417-e4gznGvYO1mtApUvmllf4g-1; Fri, 25 Nov 2022 03:07:02 -0500
X-MC-Unique: e4gznGvYO1mtApUvmllf4g-1
Received: by mail-vk1-f200.google.com with SMTP id a191-20020a1f98c8000000b003bc486cb97eso1066767vke.23
        for <target-devel@vger.kernel.org>; Fri, 25 Nov 2022 00:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKQdTNPvgD/Alsaw10kR8h6Q5yEnbkLUsazn3r2G1aI=;
        b=Cmu0r+tPRe7/Ol7FtQUj34WpBDZrU8JZLtCJ3F31+AZGfbg9/lMONCSgL4XcL9kfrn
         w+8S8XVH7wuSZkOZTkuAACtJqVZEMerq5QZnBX1++nif17XMAnLQCb4D33ZYuyfoYAe8
         DC8L59bxh+MUzpTJsI8puFho80PH1w8IX0V9ZYNXffkwj57/fLKzRVe0Mvd7Q8Kp6Oks
         79+higaElZhMNdypeG042BCb9mBCkwaZl+k1JLf1/Ak1beWPnME/XmQE/ZE7yzBluiI5
         B2vrd0Hqt/TBEc7tRuRYp2Nv0l/OrtNZtr0IIJzoyl9/K0Fq07JQ/5UBksHctUVa8Zt9
         qywA==
X-Gm-Message-State: ANoB5pnAmw+EBc+woykN+Gzk4YeFVKa9FFLaXF/76Dbmkeok+QNWRiYD
        Sb9sW+S1NV8YITKr0fOCqyKr9qnl/7kJK/4bLvHFTtflFAD7OLijXO6uge19/8zpsz25gd1JmK7
        qO4iUeLDLypC5KSl3kztdFWpx+iOUHLc+bYGO1j7B
X-Received: by 2002:ab0:59ed:0:b0:414:43b5:56c3 with SMTP id k42-20020ab059ed000000b0041443b556c3mr10604211uad.111.1669363619892;
        Fri, 25 Nov 2022 00:06:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Z7lrE0Pjmfgu4/GSyvGf2s5wJ/Mk0djrobCGmoJWqA50PCwZBeVEoYpUn3O91hR7Ei7VBNgszudemEFZt/FE=
X-Received: by 2002:ab0:59ed:0:b0:414:43b5:56c3 with SMTP id
 k42-20020ab059ed000000b0041443b556c3mr10604165uad.111.1669363618132; Fri, 25
 Nov 2022 00:06:58 -0800 (PST)
MIME-Version: 1.0
References: <08aa01d8febc$74f61260$5ee23720$@lunadesign.net>
 <b7511c59-7a25-cf22-71e7-9333a2f332c1@grimberg.me> <0d2801d9004b$de9da1c0$9bd8e540$@lunadesign.net>
In-Reply-To: <0d2801d9004b$de9da1c0$9bd8e540$@lunadesign.net>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 25 Nov 2022 09:06:46 +0100
Message-ID: <CAFL455=0TqOxeUMCOW2QWzvVAP0Vk=YFkA-T+dT5OJCS0jtyjw@mail.gmail.com>
Subject: Re: targetcli fabric modules
To:     Luis Navarro <ln@lunadesign.net>
Cc:     Sagi Grimberg <sagi@grimberg.me>, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

=C4=8Dt 24. 11. 2022 v 22:31 odes=C3=ADlatel Luis Navarro <ln@lunadesign.ne=
t> napsal:
>
> Thank you very much!  I'm seeing exactly what you're seeing.  But when yo=
u first start targetcli, do you see lines like the following?
>
> Using ib_srpt fabric module.
> Using qla2xxx fabric module.
> Using iscsi fabric module.
> Using iser fabric module.
> Using loopback fabric module.

I quickly looked at the targetcli git history and I think that those
debug messages have been removed
since version v2.0rc1.fb7 (10 years ago)

Maurizio

