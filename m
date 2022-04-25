Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B82C433F5
	for <target-devel@archiver.kernel.org>; Mon, 25 Apr 2022 06:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiDYGdi (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 02:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiDYGdi (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 02:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 870855C670
        for <target-devel@vger.kernel.org>; Sun, 24 Apr 2022 23:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650868231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAOYuvjf2Z99uDXXSQv74Ccz3QD2873YQUreZ0ql7qg=;
        b=VF0+LiPaAhOjuFxuPDKht6VM3uSrrX+DbVpHcYatUS7wtO7jUkp/G51HPNdcbyrIg1oHFK
        cysQjG4C9EAwFctcF13I1YDruo3hSW1frHlpZhOuM4sNULzFTkbRZgHbxpZEWx4W0kj6ed
        LyrKyswRSMa76NlcoYpTceoh60Bi99s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-6GQqpsZjN0aEZmyIH_D_5A-1; Mon, 25 Apr 2022 02:30:28 -0400
X-MC-Unique: 6GQqpsZjN0aEZmyIH_D_5A-1
Received: by mail-wm1-f69.google.com with SMTP id m125-20020a1c2683000000b00391893a2febso6350981wmm.4
        for <target-devel@vger.kernel.org>; Sun, 24 Apr 2022 23:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aAOYuvjf2Z99uDXXSQv74Ccz3QD2873YQUreZ0ql7qg=;
        b=wmb57M3SFfKGBsHMf+2z1KGyENTq6cH3IsMRncyWTozWVvb8pLsT5LkXhiAV4GH1gp
         C+/b3csWsumujmPnJ92Y8eN+eBQ6nQpdygKQqJOZ96mnD37J9ZFHan+AtsVEYpyXOpt/
         aJo/N84i+YL3lSdl2s6hRnVXr680SOCNpHXcZPKbqcNTIWLnlqOxdWfaE26Sb2B/XzPC
         y9Z3PpV8C6JVmylY+dTPZiFQABXta43ewi5bJ5GYHxn8iPbqfWFyvkOAsAXD6yiz2APD
         9wnZXGyxMT0fYyCV2Uz8Uc1NEcEh5oWkHrUXL91WY8hLwROeLnlvTJPMj3EhOzYeR2co
         KLog==
X-Gm-Message-State: AOAM5333OYMZ8pCzf7bFWpKqt8wBzRTUNOhKMJkYDrsF/BCfZhOqem2c
        XRYLd5GNL0bfVA4HkkgzAYD6XjN90KmCibt2hPRCIplXxOTVCJHcLO7TLxUHzG4igt4PD3oEM4P
        iKbSLTQIlDkYG6AUiLJFVzL85ArEnrie8QzsD/BDw
X-Received: by 2002:a05:600c:9:b0:393:ea67:1c68 with SMTP id g9-20020a05600c000900b00393ea671c68mr5025001wmc.92.1650868226844;
        Sun, 24 Apr 2022 23:30:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAoDTDAKFjxim6H5YkAIkiTcgJdHJuZ/7yrd6jlXj5gjsXYS0x2kfi3vCAVupOziM5SgpoxAFaiez+KFVqRhA=
X-Received: by 2002:a05:600c:9:b0:393:ea67:1c68 with SMTP id
 g9-20020a05600c000900b00393ea671c68mr5024988wmc.92.1650868226606; Sun, 24 Apr
 2022 23:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com> <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
In-Reply-To: <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 25 Apr 2022 08:30:15 +0200
Message-ID: <CAFL455=6+XqBLXC54UNHkdWW8xqpp3oOmU5HFPOQX+PfOHA8Cw@mail.gmail.com>
Subject: Re: Problems removing ramdisk backed luns
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        mingzhe.zou@easystack.cn, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

=C4=8Dt 14. 4. 2022 v 23:14 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> Zou fixed this in the current rtslib tree:
>
> https://github.com/open-iscsi/rtslib-fb/commit/8d2543c4da62e962661011fea5=
b19252b9660822
>
> If you grab that patch and are running the upstream kernel you
> probably also want:
>
> https://github.com/open-iscsi/rtslib-fb/pull/184
>
> which should fix a warning you might see after you apply Zou's fix

I will release a new version of rtslib tomorrow, so the distros can
update their packages.

Maurizio

