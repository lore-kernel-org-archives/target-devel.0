Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D35ECAAD3
	for <target-devel@archiver.kernel.org>; Mon, 19 Sep 2022 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiISRDs (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 19 Sep 2022 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiISRDS (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 19 Sep 2022 13:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C2E40E3D
        for <target-devel@vger.kernel.org>; Mon, 19 Sep 2022 10:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663606916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sn7FAhO5xUQ/F1h2KqD0bESfO2xuD9cWK+cf0cktMFc=;
        b=eO+5C3eyQvZWwa5e4Dyln1WYy1fbTWdyEvA+CprOxhk8KZXq+bI5b3UOXeAhQ/t1XjQrv3
        o1Ag0owZ60HYZgKexbezgwCUlMSDn1IB2TvDexBOnMAgxhztCrJ9LKN9FdlmQbc/xauNS5
        CeeDZ5T/kR7F4DwgG7F5ECI+RGLC5FA=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-EgDj-OpPNS6fYPsPz1_GXg-1; Mon, 19 Sep 2022 13:01:54 -0400
X-MC-Unique: EgDj-OpPNS6fYPsPz1_GXg-1
Received: by mail-vk1-f200.google.com with SMTP id d21-20020a1f9b15000000b003790f223621so11816vke.14
        for <target-devel@vger.kernel.org>; Mon, 19 Sep 2022 10:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sn7FAhO5xUQ/F1h2KqD0bESfO2xuD9cWK+cf0cktMFc=;
        b=IEdNPS7zmhkcS0K/57jE9fZWPYLUETP5m1nLU/e6ljnjk1LOywDUnEzB99x9BRjI1v
         A7pOH3D9CiBfz6aDr98Xqy1YMG8rlih46h6ZMjNVzwWEMXs+QdwNxD1RiFukEse5KVzl
         wur9gmSW0xLFOlzIvXg8JkJJCVLVNKaqUoPAgHaYk7JgojxtA1fz08Xf6y94xCZIE3zf
         UkO9eDGLJR8NEfpr75HMQslaYqn8xkuZaiANFb+WV5HYxG8mmfn8jZMO8iF142kHC9mR
         kovqomUIni39//QT8Ir1Obj+dNyqVCFiZos2EuLgwFUza1k9Yf/wNBMwaSFlVxRCGVXJ
         77Jg==
X-Gm-Message-State: ACrzQf2+XR5KeaLRZNN5VneMKFRt36KqR6TXPRMo5/s+Gm/0hok7Mk8d
        9jVHEpugCYy4DawChgxBnn1/W/9reMvJNzaOoRyUlCB7CkutMfOfS+Rm6frKj5OjccYz3k5lxL6
        MmdzbTQC2YmzfBbjUdPYXnpGrMzhsoKIP7mefuoOU
X-Received: by 2002:a67:fd69:0:b0:398:79a3:db6e with SMTP id h9-20020a67fd69000000b0039879a3db6emr6915886vsa.68.1663606913723;
        Mon, 19 Sep 2022 10:01:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4gJi53wNc6el9V6r/XoGBsH0opIr8QwZrTRIgxMm6eYiGhwGG//s/tFDsvQ+rUtGU2FYUDGp8nyXOM3XQhZew=
X-Received: by 2002:a67:fd69:0:b0:398:79a3:db6e with SMTP id
 h9-20020a67fd69000000b0039879a3db6emr6915855vsa.68.1663606913437; Mon, 19 Sep
 2022 10:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
In-Reply-To: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 19 Sep 2022 19:01:42 +0200
Message-ID: <CAFL455nJWMV31xVzpnZ4PCdmnWZ11fnKwnzegW_sNfuqoZDjJw@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Paul Dagnelie <pcd@delphix.com>
Cc:     target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

st 14. 9. 2022 v 20:00 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.com> naps=
al:
>
> iscsit_cause_connection_reinstatement signals the rx and tx threads,
> and then waits for the conn_wait_comp completion, which is signalled
> in iscsit_close_connection. That appears to be called by the tx and rx
> threads when they exit.  After puzzling through the core for a bit, I
> found the kernel threads in question, and they appear to be calmly
> waiting in the normal blocking path waiting for IOs to come in for
> them to respond to. I would think that if they were in that state when
> the SIGINT came in they would have exited properly.

I received a few bug reports and crash dumps during the past months that
appear to be about  the same problem.
Our QA is able to reproduce it so I will test if it's really the same issue
and if your hypothesis is correct, I am going to try to come up with a patc=
h.

Thanks,
Maurizio

