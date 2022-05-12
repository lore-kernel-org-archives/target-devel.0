Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE086C433F5
	for <target-devel@archiver.kernel.org>; Thu, 12 May 2022 19:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357902AbiELTLR (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Thu, 12 May 2022 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiELTLQ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 12 May 2022 15:11:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240D539168
        for <target-devel@vger.kernel.org>; Thu, 12 May 2022 12:11:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id m20so12056432ejj.10
        for <target-devel@vger.kernel.org>; Thu, 12 May 2022 12:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SLT11SGZSlspM3ztqa+Z4xJFeyllWtbNbH4XI/ki7KQ=;
        b=Akos8r1uW3mKq93eO2Gh+RThomTvKQVXEIPNJLgU4e/OsWiyliXUyDvXM1KCZowBG5
         iB8r5GxgdwJONwg8JLTbxiugmdxYSNQ3UZHr+t/+uKRqH4lkyjc4uv95+s+5+nQlfzSG
         6pdmK4AOO1sJl6dZGjA/eOhr2a7EqbPThcB8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SLT11SGZSlspM3ztqa+Z4xJFeyllWtbNbH4XI/ki7KQ=;
        b=kBuF95O6IbVOrmmYCRZAXKKsdtUla4UpSvl+FBDo/kxkp0mlzwy6wosapDdOoQ+uJ0
         RZR6D5x1YAPgKALNOpt/Lrb3MbvtfB6hP4f8Wcru/p46K5eQXD5HbmmdtkxfKY/uFdgQ
         GiO3bpZy5Lp5ZD3m1wAVykeHPRMdhvV7BFXyav7xADUmmLEYYP0jvmGwkaqFlYLqhdva
         Ddi0lJ9+K9dHqoCcT2lddyRskCnwWl8nVotlbRLgSjcU8Uz7E5KZ+/NmTIx0L0O+4/dq
         y5ZA5Xn5u+vwfznT1dqeFjiXZpg5vSX9ajE+fM8jB5AsmCtlNIv5Yrxcu7YAtppdzYKX
         uJAw==
X-Gm-Message-State: AOAM530IpRDG+lRgwlL+m32p1Cdjnzd3jH/uDmrmz3+qdMlvYjwVzs2W
        RHQ8cH8xeFd6WRJROwpuiw+P0CNQsVnKrtmGX6s=
X-Google-Smtp-Source: ABdhPJwIYFT84PElxZnx9ya8iYFRVTIlhbLlgPrQkOSWmabr04Wo3TbTUyUQ7yvAmT+61CqibF6dcw==
X-Received: by 2002:a17:906:730e:b0:6f4:e9e7:4f4 with SMTP id di14-20020a170906730e00b006f4e9e704f4mr1124392ejc.509.1652382673444;
        Thu, 12 May 2022 12:11:13 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id hy20-20020a1709068a7400b006f3ef214e05sm40937ejc.107.2022.05.12.12.11.12
        for <target-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 12:11:12 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so3080939wma.4
        for <target-devel@vger.kernel.org>; Thu, 12 May 2022 12:11:12 -0700 (PDT)
X-Received: by 2002:a1c:4c06:0:b0:394:65c4:bd03 with SMTP id
 z6-20020a1c4c06000000b0039465c4bd03mr1229662wmf.8.1652382672075; Thu, 12 May
 2022 12:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
In-Reply-To: <CAOFRbGmGr2Z_sbYmE0SZT48CFkNAWVABnC_4V6x9PzZw-LJO4w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 May 2022 12:10:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5E-xdc5P6SfN-ey6zvVri43rTj0g8kjUBWD3hhE-jiw@mail.gmail.com>
Message-ID: <CAHk-=wh5E-xdc5P6SfN-ey6zvVri43rTj0g8kjUBWD3hhE-jiw@mail.gmail.com>
Subject: Re: ERROR: drivers: iscsi: iscsi_target.c
To:     Test Bot <zgrieee@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Thu, May 12, 2022 at 11:42 AM Test Bot <zgrieee@gmail.com> wrote:
>
> void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
> {
>         int ord, cpu;
>         cpumask_t conn_allowed_cpumask;

Yeah, that's not how you are supposed to use 'cpumask_t'

This is why we have CONFIG_CPUMASK_OFFSTACK and 'cpumask_var_t', so
that the pattern is

        cpumask_var_t mask;

        if (!alloc_cpumask_var(&mask, GFP_KERNEL))
                return -ENOMEM;
        ... use 'mask' here as a  ...
        free_cpumask_var(mask);

and if the cpumask is small, it's allocated on the stack (and that
'alloc_cpumask_var()' becomes a no-op) and if it's huge, it has a real
allocation so that the stack frame doesn't grow too big.

The problem seems to have been introduced in this merge window by
commit d72d827f2f26 ("scsi: target: Add iscsi/cpus_allowed_list in
configfs"), but I didn't really look any closer than a plain "git
blame", so it might have happened before that too.

I also didn't check whether there was some explicit reason why the
code couldn't allocate the cpumask this way.

Btw, it's worth noting that 'cpumask_t' is always the full static
compile-time NR_CPUS bits in size, but a dynamically allocated
'cpumask_var_t' is only nr_cpumask_bits in size (ie the actual maximum
on that machine, as opposed to the theoretical maximum size). So they
are *not* exactly the same kind of 'cpumask_t' pointer in the end, but
no sane code should care (ie you have to do something else wrong for
the alloc_cpumask_var() pattern to not work).

           Linus
