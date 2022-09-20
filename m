Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9988C54EE9
	for <target-devel@archiver.kernel.org>; Tue, 20 Sep 2022 17:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiITRvk (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 13:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiITRvh (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 13:51:37 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A128710B9
        for <target-devel@vger.kernel.org>; Tue, 20 Sep 2022 10:51:35 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1225219ee46so5380681fac.2
        for <target-devel@vger.kernel.org>; Tue, 20 Sep 2022 10:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=rZjCwV8KqPsx4elGU5KQwf0E3xzsqybhdEFriFBYyrY=;
        b=PTOXaJvucr752fIMiK/lmRvDRJV/K6B8rFZYZXFxa57KWD9a/AW2CPqPl7DHJosSwk
         ZlvdtOA9JqeJ3GdWqIgsIeaFoMV9qsg3Eq9t3IM7Ixhl3SBDurDgGiJwM7Oquw4KU5Ty
         h905B5S9XKsM2OvD3zC7PIcLO4kRhpSrR5tKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rZjCwV8KqPsx4elGU5KQwf0E3xzsqybhdEFriFBYyrY=;
        b=cNOEx41GDlFrHNgy4avw2yKcLw+eu4S//fiR0gCWo2w+sYQLhJ3f1Vu2iSPK2Ey6C0
         9iHLCfxjon/2a0yqRGXBL6rgF/ddEsP4Emlr0TrNHxN/6hIuMABnRRc/VVGD9krPtF5W
         /COrCVKk67+PQX8vU5oBXLrvNhdajexwpUv6kWZXWrOyykpugnElIYG80KTaFFuyY95u
         fOSa6H8pBMu56izJtffHZlhMlQJX1IPYgZxGf79W4/J9xjMCRJYsDNQscVSbVfBVzUCL
         8hrXU2xUS9fOIiaf0e30wf/srL1BJYOihntGffdJRY8xNaz+e47jUNcW0fwJlFMV1uYx
         pWDQ==
X-Gm-Message-State: ACrzQf0dkJFDGbFu9E0l0UUQOvX7J/VOxRKkfMfCWN+unw5k0UWZgXm9
        7d+j3sm+KnJj2UAMBnCwhlXcuqogsI86PFRiVAghoA==
X-Google-Smtp-Source: AMsMyM47G26FenMfncFXPDudwq5hVMgFnG80kelSYPsj/kSiSg1wCUNyRBQA7BiGAy0cK2OVkKx1qMmsPNTm+HNA/Yo=
X-Received: by 2002:a05:6870:6028:b0:12b:c621:b843 with SMTP id
 t40-20020a056870602800b0012bc621b843mr2686631oaa.288.1663696294966; Tue, 20
 Sep 2022 10:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
 <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com>
In-Reply-To: <CAFL455=Yn6JWY8=7AjXkqH4Yf1_k=PsHDLANeQ5WdJtZO1Dg1Q@mail.gmail.com>
From:   Paul Dagnelie <pcd@delphix.com>
Date:   Tue, 20 Sep 2022 10:51:08 -0700
Message-ID: <CAJ-UWOeFDrL83akdz70LWYROjD_RboPQrP7kT1vwPvGnu_MyGw@mail.gmail.com>
Subject: Re: [BUG] iscsi hangs during login attempt
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     target-devel@vger.kernel.org, Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

That looks like a promising fix, thanks for getting on this so
quickly! If I can ask, what was the workload/test that you used that
reproduced it internally so quickly?

On Tue, Sep 20, 2022 at 8:50 AM Maurizio Lombardi <mlombard@redhat.com> wro=
te:
>
> st 14. 9. 2022 v 20:00 odes=C3=ADlatel Paul Dagnelie <pcd@delphix.com> na=
psal:
> > We haven't managed to reproduce it in-house or with
> > debugging statements enabled yet, but if it is the root cause it seems
> > to me the best fix would be to add or use an existing flag that is set
> > during reconnection (before the signal is sent), and have the rx and
> > tx threads check it after enabling signals to close the window for the
> > race.
>
> FYI,
>
> we are going to test this patch:
> http://bsdbackstore.eu/misc/0001-target-login-should-wait-until-tx-rx-thr=
eads-have-pr.patch
>
> Maurizio
>


--=20
Paul Dagnelie
