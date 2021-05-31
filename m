Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AF2C47083
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 12:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB5761003
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 12:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhEaMdi (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 31 May 2021 08:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbhEaMdX (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 31 May 2021 08:33:23 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D196C06138A
        for <target-devel@vger.kernel.org>; Mon, 31 May 2021 05:31:43 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k7so6895395ejv.12
        for <target-devel@vger.kernel.org>; Mon, 31 May 2021 05:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXQLdS59fbL30bBnmeToTKfV0UTTgBIP/vkt1KK2HWU=;
        b=eecje7j2KEpcaIgG+PC2ha1DEA/syXdWn5fKjqb/S2z6kQbYmj2NELTU0hHAAkNxMi
         5cKKgWdR59wozkmUUyN/0m9qEwtIF7Nv6v202rgLqAtCQ9HKX2ifUwRsatWBz1O/z+oH
         SzwX5nt4tGumea+VBRhzEG3BOG9Kfns7rOReNbsNWw7d6LAGMJV/tJVLuXmTR6OmaDNa
         7Yd8+RvfRoXcDNj9NR4ZTf6UP8PUrYFnIFLEsAo3QMzfDKTdmKTGRlQGtOxSRPS8xkUM
         gZyebpW9Ejgtt9byTv0jup2ppPAxw+HG9o/NqecuNtYvJ02maumNvmQ5yulVfU+x9MRX
         z9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXQLdS59fbL30bBnmeToTKfV0UTTgBIP/vkt1KK2HWU=;
        b=BWlFO8MXn9Q5VLofC0l2gdfPZ86zoOGAPOlI97RJtM1oUASrfmlVachdqfwqsOGM86
         0Em8OisGy8PkSA6XYeXu3WZ43Qiyc3uw5G58gS2i2PK/t5b3K/qle4xy8BXlFUWNzA/0
         MSjaVtJ45X3OCLNDBgx2MUpjbfVxzyZ9CWHlkMUXbS5uzyQ8N5WX9XzfOHx9eb00OoSP
         QG0v3+E+3NybyUwJgUHhmJiZUo2bDIbwjBrWn92yaUf/tXwIKZbYgProeF+CIId+z+87
         tqVpC4BpZekuP+ek5xm9pQGu4CxXnK2gZsgGgEKp/CKRmJYNchi6Bj+kAi9DxMyIAt0U
         y6gw==
X-Gm-Message-State: AOAM530mkWs5Bfpk7wvzwYPaHQAijb9UNZRKtPxTmoPKor2pRMTKeKl0
        AbcYXEvFiTW85Fxi5nMp+9N4WUezG6yL5Q8IJ97ljQ==
X-Google-Smtp-Source: ABdhPJzPbGT4vXgPK/rMHikumyH/h0cvDwDVbvng5Ylt7L2/uY+5yxtdCFykHjeUH2a9KX7GblQvHOmrsHPgBBETsog=
X-Received: by 2002:a17:906:b794:: with SMTP id dt20mr22443077ejb.521.1622464301861;
 Mon, 31 May 2021 05:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <635def71048cbffe76e2dd324cf420d8a465ee9d.1622460676.git.leonro@nvidia.com>
In-Reply-To: <635def71048cbffe76e2dd324cf420d8a465ee9d.1622460676.git.leonro@nvidia.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 31 May 2021 14:31:31 +0200
Message-ID: <CAMGffEkNKcpKz_YL6CCrGfRpOh8m9G8ir6p=AkY_UgBd-5Bbpw@mail.gmail.com>
Subject: Re: [PATCH rdma-next] RDMA: Fix kernel-doc warnings about wrong comment
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Faisal Latif <faisal.latif@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Mon, May 31, 2021 at 2:03 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Compilation with W=1 produces warnings similar to the below.
>
>   drivers/infiniband/ulp/ipoib/ipoib_main.c:320: warning: This comment
>         starts with '/**', but isn't a kernel-doc comment. Refer
>         Documentation/doc-guide/kernel-doc.rst
>
> All such occurrences were found with the following one line
>  git grep -A 1 "\/\*\*" drivers/infiniband/
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  * Straightforward change to make our CI happy.
> ---
>  drivers/infiniband/core/iwpm_util.h       |  2 +-
>  drivers/infiniband/core/roce_gid_mgmt.c   |  5 +++--
>  drivers/infiniband/hw/hfi1/chip.c         |  4 ++--
>  drivers/infiniband/hw/hfi1/file_ops.c     |  6 +++---
>  drivers/infiniband/hw/hfi1/hfi.h          |  2 +-
>  drivers/infiniband/hw/hfi1/init.c         |  4 ++--
>  drivers/infiniband/hw/hfi1/pio.c          |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw.h       |  3 ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c    | 10 +++++-----
>  drivers/infiniband/hw/i40iw/i40iw_hmc.c   |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c |  2 +-
>  drivers/infiniband/sw/rdmavt/mr.c         |  4 ++--
>  drivers/infiniband/sw/rdmavt/qp.c         |  3 ++-
>  drivers/infiniband/sw/rdmavt/vt.c         |  4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  7 ++++---
>  drivers/infiniband/ulp/iser/iser_verbs.c  |  2 +-
>  drivers/infiniband/ulp/isert/ib_isert.c   |  4 ++--
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c    |  4 ++--
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c    |  2 +-
for rtrs, looks good to me, thx!
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
