Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356CFC433F5
	for <target-devel@archiver.kernel.org>; Mon, 14 Mar 2022 15:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiCNP4Z (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 11:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242775AbiCNP4Z (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 11:56:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F9483CA6B
        for <target-devel@vger.kernel.org>; Mon, 14 Mar 2022 08:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647273314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RzlVr8nTB6KvO+WtUtiClWxQqgcaQRo7aS998hISKJQ=;
        b=RzZcLXORZebBNyDj0YVTtZe3jOPvm+1VEQ6ZunyC5wyr6+6oQheRzDOqlrAFtjDmbxhbZs
        THWEuG/ij4Oz/i8tilEa3+qeP04mSeBlc/2vtOa5uSxPVXASjWwQ70TteZPdibfk8oIBc2
        KigyHYoxpSI1/ujVLuLNp4G+V1d1zi8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-qy2cCcnzPse68vkaWpxOJA-1; Mon, 14 Mar 2022 11:55:12 -0400
X-MC-Unique: qy2cCcnzPse68vkaWpxOJA-1
Received: by mail-qt1-f199.google.com with SMTP id bb15-20020a05622a1b0f00b002e06ae2f56cso11898176qtb.12
        for <target-devel@vger.kernel.org>; Mon, 14 Mar 2022 08:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzlVr8nTB6KvO+WtUtiClWxQqgcaQRo7aS998hISKJQ=;
        b=AmT8k+KW/VXgil4obWqPHy28mpFsOdQkQty0cI9+gZNBynN8cCwrJCup9eKwerrtaL
         yyj1IYjSnNSMRwRbNgpvShtYdArSW5pw/IUc0PnNcBZB3zRSvv5G08GAg+/KLfFLDD2O
         bcy29y3ht9/vii+2ahdz9KOfxUn6BRKaJi09+Y7iDxzv8qmT14mS3tJWHDb90kGMzZ01
         JX0AStfPp0l2Po/fCAhjd87vbtWlJ1OkcW0J3LDtcogtTAVd3lhFfOygMgsx8pnabVM2
         2XwIvp8H04WXolcObG3roCeyy3zB6qCPdKcRbhDHKlMwxq9nIrZhBTGROPpltP4gvhVw
         WjrQ==
X-Gm-Message-State: AOAM531qE0G6aJMIX8j8wrkdIuR7uJZ9cajVKlFEiJvI09J/JWuNdGWX
        oobr15cQVHaNdpFPjUJXotxwd2Vtd2NdETZY0wj0QEQIIf/DGikWG6InklLBeiEcoQlkrsbImnH
        0XjiYko1+9jBKoOfXekB6u2o9aY3yJQ/mzVdL6lqh
X-Received: by 2002:ac8:57c7:0:b0:2e0:b946:e954 with SMTP id w7-20020ac857c7000000b002e0b946e954mr19314564qta.387.1647273312181;
        Mon, 14 Mar 2022 08:55:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqNwdU70I1Cs5a923rFjpBiaQdxXjI4zu8450Y84lcLtpqWxrHMugLQteOoQ7MsnqNVHU5yQ3K9heboUSPMOQ=
X-Received: by 2002:ac8:57c7:0:b0:2e0:b946:e954 with SMTP id
 w7-20020ac857c7000000b002e0b946e954mr19314544qta.387.1647273311925; Mon, 14
 Mar 2022 08:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220311175713.2344960-1-djeffery@redhat.com> <b97dd278-eedd-1324-1334-78addee204f9@nvidia.com>
 <CA+-xHTFCPXe-vALE1ApWdhNOJOByGSgmn5=fF1A_P57zYQGNcQ@mail.gmail.com> <e39a032f-9e95-a038-c29c-30bb58e45fc0@nvidia.com>
In-Reply-To: <e39a032f-9e95-a038-c29c-30bb58e45fc0@nvidia.com>
From:   David Jeffery <djeffery@redhat.com>
Date:   Mon, 14 Mar 2022 11:55:00 -0400
Message-ID: <CA+-xHTHK1y7JFAeBN=NVq=vaRBXfRNPbF5ZxmdQ2trhhU+E0tQ@mail.gmail.com>
Subject: Re: [Patch 0/2] iscsit/isert deadlock prevention under heavy I/O
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>,
        Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52 AM Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>
> On 3/14/2022 3:57 PM, David Jeffery wrote:
> > On Sun, Mar 13, 2022 at 5:59 AM Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >> Hi David,
> >>
> >> thanks for the report.
> >>
> >> Please check how we fixed that in NVMf in Sagi's commit:
> >>
> >> nvmet-rdma: fix possible bogus dereference under heavy load (commit:
> >> 8407879c4e0d77)
> >>
> >> Maybe this can be done in isert and will solve this problem in a simpler
> >> way.
> >>
> >> is it necessary to change max_cmd_sn ?
> >>
> >>
> > Hello,
> >
> > Sure, there are alternative methods which could fix this immediate
> > issue. e.g. We could make the command structs for scsi commands get
> > allocated from a mempool. Is there a particular reason you don't want
> > to do anything to modify max_cmd_sn behavior?
>
> according to the description the command was parsed successful and sent
> to the initiator.
>

Yes.

> Why do we need to change the window ? it's just a race of putting the
> context back to the pool.
>
> And this race is rare.
>

Sure, it's going to be rare. Systems using isert targets with
infiniband are going to be naturally rare. It's part of why I left the
max_cmd_sn behavior untouched for non-isert iscsit since they seem to
be fine as is. But it's easily and regularly triggered by some systems
which use isert, so worth fixing.

> >
> > I didn't do something like this as it seems to me to go against the
> > intent of the design. It makes the iscsi window mostly meaningless in
> > some conditions and complicates any allocation path since it now must
> > gracefully and sanely handle an iscsi_cmd/isert_cmd not existing. I
> > assume special commands like task-management, logouts, and pings would
> > need a separate allocation source to keep from being dropped under
> > memory load.
>
> it won't be dropped. It would be allocated dynamically and freed
> (instead of putting it back to the pool).
>

If it waits indefinitely for an allocation it ends up with a variation
of the original problem under memory pressure. If it waits for
allocation on isert receive, then receive stalls under memory pressure
and won't process the completions which would have released the other
iscsi_cmd structs just needing final acknowledgement.

David Jeffery

