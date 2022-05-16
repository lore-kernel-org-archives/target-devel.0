Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C6FC433F5
	for <target-devel@archiver.kernel.org>; Mon, 16 May 2022 18:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbiEPSFS (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 16 May 2022 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbiEPSFM (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 16 May 2022 14:05:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E95037038
        for <target-devel@vger.kernel.org>; Mon, 16 May 2022 11:05:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id kq17so30218456ejb.4
        for <target-devel@vger.kernel.org>; Mon, 16 May 2022 11:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBfJCGFmnmHFyZCsMK3wiFpbhBcHWLVoHbOFzHKjGMQ=;
        b=OHPDgsoJ9Bun/JRtnlaDF+u3/KFPL+fwQx/BSD+2OcqFjFx/QGXobcm1CRZy7TMtVP
         0LuUnPFijF5+ItJrprEGEPSFe1bpieia/XbLg9lqUOCLhUNssSdIi1+lTGNznxxZwaBL
         2P03KdZI/jfFFNnuJgTizzalP59ckfHmlB4ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBfJCGFmnmHFyZCsMK3wiFpbhBcHWLVoHbOFzHKjGMQ=;
        b=wxkiz7RJbTxIE58MjyqFqrsfw5ONBAwOMbCyyI6IPWhzrxOo+8D+YgBPR2s4gfsqNB
         lRyGgsaodTQGqDN/iaTeI2q9oJUfKiO0UPDWH5GVeUDm9BBCdpokEUVjnVl+fxQ6Vmpi
         ZPB+gmHZ/ZBTUqPKuK9kczrNhOvnEZ0W0P53ZQtEQwiW+mUdkWnzhPYesgiw3nykxqfP
         psflqRWCbx7pf74aI0lchZwxcz/KN4jG+mJRhDaWtvAgt5Z3goXwwAniGYAS6WgWhf0G
         zSFOc8pKppv7emY1ETjRsERMmxAXM9dg4zlNPMpMq6pp6HXCkbIeCgHbcvxCvuIxckOR
         pb/w==
X-Gm-Message-State: AOAM530DYM1cTH96Ana+WcZvAPGx5QaBeuIA8JS8OqKgvjmZIypMsOkq
        6Xfnrd05nTjvmR64H0bKWQHbicWPAapISfHx
X-Google-Smtp-Source: ABdhPJwU1s1tRy43UNAmnuYmNNWKI/h2sOwAqsKvcxSQ7loj7mJDcQO225giqs7PIXy/JsWISjh3Fg==
X-Received: by 2002:a17:907:961b:b0:6f8:8b28:f2e8 with SMTP id gb27-20020a170907961b00b006f88b28f2e8mr16215263ejc.76.1652724309163;
        Mon, 16 May 2022 11:05:09 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id q17-20020aa7cc11000000b0042aab566ed2sm2772492edt.37.2022.05.16.11.05.08
        for <target-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:05:08 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id m62so9176971wme.5
        for <target-devel@vger.kernel.org>; Mon, 16 May 2022 11:05:08 -0700 (PDT)
X-Received: by 2002:a7b:c8d6:0:b0:394:25ff:2de with SMTP id
 f22-20020a7bc8d6000000b0039425ff02demr27938988wml.154.1652724307865; Mon, 16
 May 2022 11:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
 <0db186ce-f789-f306-46ed-74ba75dec028@prevas.dk>
In-Reply-To: <0db186ce-f789-f306-46ed-74ba75dec028@prevas.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 May 2022 08:04:51 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi4ARjYWqoStREpT9EEGWEVsEknRJX5z2OGoSDcKor8ZA@mail.gmail.com>
Message-ID: <CAHk-=wi4ARjYWqoStREpT9EEGWEVsEknRJX5z2OGoSDcKor8ZA@mail.gmail.com>
Subject: Re: ERROR: drivers: iscsi: iscsi_target.c
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Test Bot <zgrieee@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Sun, May 15, 2022 at 10:48 PM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> Hm, looks like cpumask.h should also expose a wrapper for
> bitmap_ord_to_pos ...

I'd rather delete bitmap_ord_to_pos() entirely. We have something like
two uses of it, and both are illegible.

There's a comment about a possible third use, but that one says that
it's not using it because doing it differently is more efficient.

And honestly, that more efficient non-ord_to_pos implementation is
actually a lot more legible to any sane person too.

I think it's a huge mistake to create these kinds of obscure "helper"
functions that have odd semantics that almost nobody needs. It only
results in code that is completely obscure, because nobody is used to
those very unusual functions, so to understand the user you almost
have to go look at what the heck the helper function does.

That "bitmap_onto()" function (another crazy helper) is a great
example. Not only doesn't it use that ord_to_pos helper, the "helpful"
comments that describes the algorithm in terms of it is just much
harder to understand than the actual code.

NONE of those functions should exist at all, imho. That
"bitmap_onto()" function is some really specialized stuff that is used
in *one* single place, where it implements *another* really
specialized helper function, and that *other* helper function also has
exactly use use.

That should have clued people in.

I really think those functions should go away, and just be folded into
mpol_relative_nodemask(), where the semantics for it can actually be
explained.

Helper functions with one single use-case shouldn't be helper
fucntions. They should be inlines in the one single file that uses
them. Trying to make up abstraction layers is not "helping", it's just
making code harder to read, and trying to convince people to use
specialized helpers just causes more cognitive load.

                   Linus
