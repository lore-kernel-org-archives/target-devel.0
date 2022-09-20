Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388A0C6FA82
	for <target-devel@archiver.kernel.org>; Tue, 20 Sep 2022 15:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiITPuN (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 11:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiITPuK (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 11:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBB93E76C
        for <target-devel@vger.kernel.org>; Tue, 20 Sep 2022 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663689000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iJq226dZzCVcjOWtb4HRrrXUB8OWStcKtmr9uT4l8Ks=;
        b=IQ6Lw29+gM34b7uvRfzqB36HL9x8Qz8q0cJgmjp8aZ48Vqn+LwN0PFZBT45PucbDIuxyQF
        DOaAtiXKNvrFUOPs2RbYQcXOGv6bCQe6eGXmGH7/eQqv6wK+K61sYBKFUr4WcqdpoAG/hh
        5vkK7NKSlTlpNAqlBh17r/hwLVr1USk=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-182-IL25Mu2XN2WeLRkojCO7zw-1; Tue, 20 Sep 2022 11:49:59 -0400
X-MC-Unique: IL25Mu2XN2WeLRkojCO7zw-1
Received: by mail-vk1-f197.google.com with SMTP id x3-20020a1f3103000000b003a285826de2so913418vkx.2
        for <target-devel@vger.kernel.org>; Tue, 20 Sep 2022 08:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iJq226dZzCVcjOWtb4HRrrXUB8OWStcKtmr9uT4l8Ks=;
        b=hxRBi6G2J7zN8jtwPc4AUZbSjL4qK+3rI5EqPHdWGSZu3HClC5IMzqfqfven3LtiO+
         Y9x4Uft2nlyTyk0G7GLEvBXuuKpIEeBcspTNwt14iaHFKrvwsBTdqr6ppPn93N2cDhIh
         ZYAjYg/uPh2lmkxGgu96VnFGCgjcfgjFw2g/r1nuGlENg6wOMr+D6GwRTICl1kAhWBk9
         a8N+KkTE1LvtBZXQWvsJK/m59OJYVAB/JGhLyDV2JaShVii2wlxNzOYHkXesP5I9dxRz
         elq/NIZMiWdM9+9U4l9boHUo88brhDyt6bMg91JexhOc317wfwQQ078bjrpsAmCbh1xW
         2bQg==
X-Gm-Message-State: ACrzQf2b6SbwX0oQF8w1OVyp2rNgcp7gaactHy+LbYk3f68qWg0/Rk54
        GwqAH1nfo5maobM4rQj2FbI6UB7U6LoCFddRMU+CC21Wrt9BYlr06Tr9PTXBS4a4C4frS2+M6tq
        X9nXSUO2CW8QmaCBbQp3EwhTaGw3ULy684CuwKl3u
X-Received: by 2002:ac5:cdd9:0:b0:39e:8fbf:dad4 with SMTP id u25-20020ac5cdd9000000b0039e8fbfdad4mr8979788vkn.0.1663688998391;
        Tue, 20 Sep 2022 08:49:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4srpKvR98AIDDGoFeTxPmjoOa7Kbe2bwWt+Huzcpj+zjEm9Rja9JiDbz+MGnfCGzrg3h/4GXOTSr1Hv7EieEY=
X-Received: by 2002:ac5:cdd9:0:b0:39e:8fbf:dad4 with SMTP id
 u25-20020ac5cdd9000000b0039e8fbfdad4mr8979779vkn.0.1663688998200; Tue, 20 Sep
 2022 08:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
In-Reply-To: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 20 Sep 2022 17:49:47 +0200
Message-ID: <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Paul Dagnelie <pcd@delphix.com>
Cc:     target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

st 14. 9. 2022 v 20:00 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.com> naps=
al:
> We haven't managed to reproduce it in-house or with
> debugging statements enabled yet, but if it is the root cause it seems
> to me the best fix would be to add or use an existing flag that is set
> during reconnection (before the signal is sent), and have the rx and
> tx threads check it after enabling signals to close the window for the
> race.

FYI,

we are going to test this patch:
http://bsdbackstore.eu/misc/0001-target-login-should-wait-until-tx-rx-threa=
ds-have-pr.patch

Maurizio

