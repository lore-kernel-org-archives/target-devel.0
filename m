Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA11C433F5
	for <target-devel@archiver.kernel.org>; Wed, 16 Mar 2022 15:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbiCPP1W (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 11:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiCPP1W (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 11:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE02314005
        for <target-devel@vger.kernel.org>; Wed, 16 Mar 2022 08:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647444367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fiyi0AzB53E81OTo2YZCLg9th3nDyr7cwTlg8VafXOo=;
        b=iT1zn706wWkQR5mJSJmwXlQprwOWFgK2uqMBU6xJ6jq3LFlOf1oG7B1uxwoDTkgC1BNSVI
        869XzZhPYftq46iqoI8qlbS3k2IOWyr0qTybeTJ3Maz3tBlMFO/QWdEf2RWwhfi/PP1Moi
        fNvXhrynkPb46XlkYESoPpB50tuJaRk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-D7piYzEqOJuAQccQuU0FZw-1; Wed, 16 Mar 2022 11:26:05 -0400
X-MC-Unique: D7piYzEqOJuAQccQuU0FZw-1
Received: by mail-oo1-f72.google.com with SMTP id o68-20020a4a4447000000b003210ddc07a2so1584940ooa.6
        for <target-devel@vger.kernel.org>; Wed, 16 Mar 2022 08:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fiyi0AzB53E81OTo2YZCLg9th3nDyr7cwTlg8VafXOo=;
        b=qVFTroUM+xcj1fuyPIydO05TOIkqXR0DsaqrmgPyIEh8BtA77V/9gF2KGMrUM7H8cI
         Ol1YlcgvYnaaRjcctT2Wfn0zQ+VtIAU/bY7fSubT7h+KMmJNkU38UFPQZEKkc+moOGoc
         zkTdp5zsotOMvXK2vhiagubAE053aysitWsv0taxfnuCT9f0V+UsnykGmwUY1dBUB7dh
         YAwU9FS3CZgGbiOxYsRk2RvSfDkTeyxHq8V3jHIB9ptAij6BQpBxMINtvY2P2diP1162
         b2u1aHyB8NeFbSwR3c+x96QTOPBCpuEHpk9QtVHcz6XENeWhalIIwK7mzlocHhW86zX0
         RKbQ==
X-Gm-Message-State: AOAM530ldYZZ0ynVrHqaUOkIva+mODGiO/kNkZvMgniGAFK+wuRiGPhv
        EPlieydvp/3mHxCU/zm+666NQZzlYFmJ3Ab8yYE/l9MBmQdVAq2gEKkJnKh71o5PDBNd4CyWxQD
        Q5/Pie6guMfS5Ss0waHbbkAuS
X-Received: by 2002:a05:6870:e3c1:b0:d7:2dc8:7fd0 with SMTP id y1-20020a056870e3c100b000d72dc87fd0mr114715oad.104.1647444365075;
        Wed, 16 Mar 2022 08:26:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd5CO1nlVAFAAJNB90SULBwx2B6wh4kD1JZowYmjPzUhrIR+VsY+TYRoYNtuFzS4AbCfRi2Q==
X-Received: by 2002:a05:6870:e3c1:b0:d7:2dc8:7fd0 with SMTP id y1-20020a056870e3c100b000d72dc87fd0mr114708oad.104.1647444364838;
        Wed, 16 Mar 2022 08:26:04 -0700 (PDT)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id c6-20020a056830314600b005ca1bb396dfsm991322ots.32.2022.03.16.08.26.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Mar 2022 08:26:04 -0700 (PDT)
Message-ID: <a540823d6f3732903080f42a855d2e7cdfc64ade.camel@redhat.com>
Subject: Re: [Patch 0/2] iscsit/isert deadlock prevention under heavy I/O
From:   Laurence Oberman <loberman@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        David Jeffery <djeffery@redhat.com>
Cc:     linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Date:   Wed, 16 Mar 2022 11:26:03 -0400
In-Reply-To: <165698e9-9ccd-c840-b926-48f2ee7c6dcb@grimberg.me>
References: <20220311175713.2344960-1-djeffery@redhat.com>
         <b97dd278-eedd-1324-1334-78addee204f9@nvidia.com>
         <CA+-xHTFCPXe-vALE1ApWdhNOJOByGSgmn5=fF1A_P57zYQGNcQ@mail.gmail.com>
         <e39a032f-9e95-a038-c29c-30bb58e45fc0@nvidia.com>
         <CA+-xHTHK1y7JFAeBN=NVq=vaRBXfRNPbF5ZxmdQ2trhhU+E0tQ@mail.gmail.com>
         <f18f7a350bf5b0f0651083d9a592d35d0d5a68f4.camel@redhat.com>
         <a1cc6842-1429-eea5-aa0d-47b3f2bab843@nvidia.com>
         <720ebd1f98ab3c709443176011f51d6e3ed37272.camel@redhat.com>
         <165698e9-9ccd-c840-b926-48f2ee7c6dcb@grimberg.me>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, 2022-03-16 at 16:39 +0200, Sagi Grimberg wrote:
> Is there any measure-able performance implication?

From our testing and customers it prevented the deadlock, but did not
seem to incur any additional latency. I was reaching similar IOPS/sec
amd GB/sec prior to deadlock.
The benefit seems to be just no more stalls and hung tasks

Thanks for the replies

Kind Regards
Laurence

