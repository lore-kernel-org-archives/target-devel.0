Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BD1C636CC
	for <target-devel@archiver.kernel.org>; Mon, 30 Jan 2023 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjA3JmU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 30 Jan 2023 04:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbjA3JmS (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 30 Jan 2023 04:42:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F82759FA
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 01:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675071681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZB3ppRWoE2VbNlBDORO+tXo0Zd7ms2jJgTuI65/l/4=;
        b=abi6XcNibZlJRfMuJ7WfuDwfBdwiayjnYNMuKR8dDJyJSWCSf0KuTpbib6ytIXWG66ms6B
        GeN6ep0Eala0Cpt3mEEODHhX7tEtLFhMX/HsqNw95XNFbRamsnpJDTSIS9Uz9Hf4AVsigB
        9WWSUAja0vlHC1FUUIEzen+k1ifXTW0=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-byk7aji1P7yKfo2goIpl0w-1; Mon, 30 Jan 2023 04:41:19 -0500
X-MC-Unique: byk7aji1P7yKfo2goIpl0w-1
Received: by mail-vs1-f69.google.com with SMTP id b65-20020a676744000000b003cedad0ea4bso2038573vsc.9
        for <target-devel@vger.kernel.org>; Mon, 30 Jan 2023 01:41:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZB3ppRWoE2VbNlBDORO+tXo0Zd7ms2jJgTuI65/l/4=;
        b=Wt5rwZtg11qtbM8kEJqgGcpT1rTcKWEyHiuNp/Url/cYpOvejJGmB5Czgrv+LxMbKa
         YSDAgmXnWY4sR4xDG492Dqf6uNp5YJKlFW1eh9RkzKqR3wYUSRkARBq/7GF2SCZIhXeF
         U+ZWZyVRYKOvsL+CiuW3y5bE/av6ejUifxcpbih+d5opKIaFRyifC23HtyAHKZ/CkbJa
         aS1LW3FYzgYjIoo9dkwcETCuS6DrqSOluyNhZ/zTN2V/pQQdGzqIx/QQYfVqmjIhIbUi
         112Guc5MrZnVTFhpV6YQhuu2jpn1kSPnTquKFIk43nKXuLWJ+T5NmQd7YVjduJKDeI+z
         KgXQ==
X-Gm-Message-State: AFqh2kpYb7fChLSq5PxQTlf1+J14s7BuOOHaELlgBiw0CK8HJFNPmZKK
        NCxDaS8dUA8/4StC4ssOZuDzBxA4jjeusA8t45oD7pT23OmEzFNE3sBsVkDC05eRqxZUq0wf2ql
        u85UZ30z9165NF4Y32KC1BB0z2qdgSGMRw9i67vZM
X-Received: by 2002:a67:17c7:0:b0:3d3:ef73:b726 with SMTP id 190-20020a6717c7000000b003d3ef73b726mr8030092vsx.22.1675071678742;
        Mon, 30 Jan 2023 01:41:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsZPbGIkKZ3JkyE4PPSEtdATs4cyeWI2bHYwKj1pHG9Xv5GR1TFcLYB7oDPze+TpK8lg+/5MkDt7dN9K44BisI=
X-Received: by 2002:a67:17c7:0:b0:3d3:ef73:b726 with SMTP id
 190-20020a6717c7000000b003d3ef73b726mr8030087vsx.22.1675071678470; Mon, 30
 Jan 2023 01:41:18 -0800 (PST)
MIME-Version: 1.0
References: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
 <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
In-Reply-To: <f9f4057b-5711-e83d-aea1-20f79737f27c@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 30 Jan 2023 10:41:07 +0100
Message-ID: <CAFL455=hk+9NN9HjyjVQQAkKtqhBFDp9iG=7WOuL57G98-QdYQ@mail.gmail.com>
Subject: Re: deadlocks when the target server runs as initiator to itself
To:     Mike Christie <michael.christie@oracle.com>
Cc:     d.bogdanov@yadro.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

po 30. 1. 2023 v 1:09 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> > Sounds correct to you?
>
> Yeah, I think nbd and rbd have similar issues. I think they just say don'=
t
> do that.

Ok. So iscsi initiator and target on the same host must be considered
unsupported.

>
> >
> > What do you think about using memalloc_noio_*() in the iscsi_rx thread
> > to prevent the memory reclaim code from starting I/O operations? Any
> > alternative ideas?
>
> I don't think that's the best option because it's a rare use case and it
> will affect other users.

Yeah, too overkill for such a corner case.

>Why can't the user just use tcm loop for the local
> use case?

This is indeed what we are going to suggest to them, to reconfigure
their target setup to
avoid using iscsi in loop and use tcm_loop instead.

Thanks,
Maurizio

