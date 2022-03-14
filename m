Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CC9C433EF
	for <target-devel@archiver.kernel.org>; Mon, 14 Mar 2022 13:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiCNN7L (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 09:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiCNN7K (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 09:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FF4C17E27
        for <target-devel@vger.kernel.org>; Mon, 14 Mar 2022 06:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647266278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TDirMt6DUmLUozphOEbENIKMtwE4Z7punVtOAUrkDBM=;
        b=ADQ+d7fPWfPFPUgajX2z4db/BX++C2kTSjc55ZFoVJsKOGe/n4oMKXmqq81fqnR9YVFJcB
        E6S4HqncEafK0/qsZQ5Nc/VqJfQOgr5uliiF85nklDgDs0DflaP5l8K322xoYVD0hzDUGy
        vLzpQ6IDqWOZfLyyGUKwlXHwskJdaP4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-2_G5tj6gOYOulmaimw9kFA-1; Mon, 14 Mar 2022 09:57:57 -0400
X-MC-Unique: 2_G5tj6gOYOulmaimw9kFA-1
Received: by mail-qv1-f71.google.com with SMTP id z7-20020ad44147000000b004354c61c2a1so13926043qvp.7
        for <target-devel@vger.kernel.org>; Mon, 14 Mar 2022 06:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDirMt6DUmLUozphOEbENIKMtwE4Z7punVtOAUrkDBM=;
        b=VaavP+uew7iY5qqFeGUPQbVav6IN35o/dLUtpADWVfsGwm5aGnReEdELtBB/TDiYxb
         F452MRONTPeRBon6ZbkWQ1xeJrfi5+Mu30YiL8+xp1WjqI9Vb7f7Yn4y1CIMkg35t0UR
         U7sy04E8k886pinqUDyEoAiFmTBsP80O1mc2TBSqGg63vEUS7W22yWya1mSSX37U//4b
         VJMU48oz1utQsd66EOe/dZD0DTJ155UH3aDP6Rh+Pn2xJIX9KXt7ZAYn+j8ulwLlgHz3
         z8OU5mrozwr0P66baQ8GYhAeU1uyFNYQrlwCgC7YJbc5JOnQ5SeYa/w92Xpf60iW3fAO
         XJNQ==
X-Gm-Message-State: AOAM532gOsBao+N5MKOVpxeEiR5wlkEHTo4SYbDMm1QYIfWwOWvjd/Dh
        Yff5XYofKqJM//3kIanYQwrNfgFBB9HixM671MaIwGpS19sjTA9s507rrB566+Qy0Q1ACRUicxP
        9Wi+X/5BxSSdGd3LKPZS/py4UWFkR5DqIh5leRnai
X-Received: by 2002:ac8:5985:0:b0:2e1:deb4:b37f with SMTP id e5-20020ac85985000000b002e1deb4b37fmr102674qte.441.1647266276847;
        Mon, 14 Mar 2022 06:57:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz59glnj9I5KfdOImXPebst0mBl3mPgApMS5KPvi/5djp0Oj5uUTKTlOz3CQkTPcENc0H9verM1IeXElVVgQkA=
X-Received: by 2002:ac8:5985:0:b0:2e1:deb4:b37f with SMTP id
 e5-20020ac85985000000b002e1deb4b37fmr102658qte.441.1647266276628; Mon, 14 Mar
 2022 06:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220311175713.2344960-1-djeffery@redhat.com> <b97dd278-eedd-1324-1334-78addee204f9@nvidia.com>
In-Reply-To: <b97dd278-eedd-1324-1334-78addee204f9@nvidia.com>
From:   David Jeffery <djeffery@redhat.com>
Date:   Mon, 14 Mar 2022 09:57:45 -0400
Message-ID: <CA+-xHTFCPXe-vALE1ApWdhNOJOByGSgmn5=fF1A_P57zYQGNcQ@mail.gmail.com>
Subject: Re: [Patch 0/2] iscsit/isert deadlock prevention under heavy I/O
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>,
        Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Sun, Mar 13, 2022 at 5:59 AM Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
> Hi David,
>
> thanks for the report.
>
> Please check how we fixed that in NVMf in Sagi's commit:
>
> nvmet-rdma: fix possible bogus dereference under heavy load (commit:
> 8407879c4e0d77)
>
> Maybe this can be done in isert and will solve this problem in a simpler
> way.
>
> is it necessary to change max_cmd_sn ?
>
>

Hello,

Sure, there are alternative methods which could fix this immediate
issue. e.g. We could make the command structs for scsi commands get
allocated from a mempool. Is there a particular reason you don't want
to do anything to modify max_cmd_sn behavior?

I didn't do something like this as it seems to me to go against the
intent of the design. It makes the iscsi window mostly meaningless in
some conditions and complicates any allocation path since it now must
gracefully and sanely handle an iscsi_cmd/isert_cmd not existing. I
assume special commands like task-management, logouts, and pings would
need a separate allocation source to keep from being dropped under
memory load.

David Jeffery

