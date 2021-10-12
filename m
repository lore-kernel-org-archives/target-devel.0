Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EADBC433F5
	for <target-devel@archiver.kernel.org>; Tue, 12 Oct 2021 08:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62BD76101D
	for <target-devel@archiver.kernel.org>; Tue, 12 Oct 2021 08:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhJLI6x (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235009AbhJLI6w (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 04:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634029010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2306l8O15sU1vcu4B6Ll737E6aqM79YcUvAzT+nrE/0=;
        b=XcfvULXVq9jNbwEr7eSMzO3sLfRCdIMMs6TKl3hRRWcpJ4GxPJsA+5VzUKqDzYdRzyyjNM
        pgpMC6A4zANgMsJgE3IxCdFGi9g9lPrBcfYr3u9u4rjeKAQuzFcjqYYUv5c9Xbtfnm+2Ny
        mNCn/JsYPu4dWXqiRh2uFJJgFnvn0KA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-c8-1XlGcOUOwBNFroGWSSQ-1; Tue, 12 Oct 2021 04:56:49 -0400
X-MC-Unique: c8-1XlGcOUOwBNFroGWSSQ-1
Received: by mail-il1-f199.google.com with SMTP id x4-20020a923004000000b00258f6abf8feso11682675ile.20
        for <target-devel@vger.kernel.org>; Tue, 12 Oct 2021 01:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2306l8O15sU1vcu4B6Ll737E6aqM79YcUvAzT+nrE/0=;
        b=pUHGuaXKZe1sTK1bt4g9FAyLIf0zBcoSWrl4aalciXQEBZkS7A+dFp+0my5v2VUKYs
         2OVwKt4N4W7nlbITuDArE18DBym/bdw7mETkwN6eUsBt+3/gVFT+ZOuxT5WCbIu9D0bL
         sVgJgQLHZ66T9fgCAgK6HlqVm7SRhjxB9sQXwKHOmzDatugE17e+rueqAz0iy6X/CThk
         sNdnyObBCXdzcAb6l7aB3qVSaEovr4o4WR6Qsx5Fga0RUy5AVrhfPUPQ3RNkSEBkluOl
         GD1HyJi5KQGJhATKHQXU7sdFKXtJieGYdxWAos7iq50GvV40pADlNCepzecUeEytuqWr
         21Mg==
X-Gm-Message-State: AOAM531j3rJuoJ4LBvaRLPjAc0hnniiiXaKB6RHucYCDPKnZHoykaOxN
        k0RNqXN+9gnA5Rnf3T+OvIJOePn1PMGGzrJfGUj84FRZrw4ojRI/EOW46rFXeI6yEhqya3kNZCO
        elXSJZeu12+TEr9dPQ1YfOMM9pHX7dMHiUygDqXHP
X-Received: by 2002:a02:c7d0:: with SMTP id s16mr22392936jao.135.1634029008800;
        Tue, 12 Oct 2021 01:56:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUkRepXJb8nIg4Y5/prL0OUv2135zbuWmGtHT2J9bKutX3pXKM/gmZMmJRALFncDg4NHaIrKzMurpt7NQlWTA=
X-Received: by 2002:a02:c7d0:: with SMTP id s16mr22392901jao.135.1634029008278;
 Tue, 12 Oct 2021 01:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210927193814.79111-1-mlombard@redhat.com> <c9f869c7-9e83-6485-e256-f9e6886eb01b@oracle.com>
In-Reply-To: <c9f869c7-9e83-6485-e256-f9e6886eb01b@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 12 Oct 2021 10:56:37 +0200
Message-ID: <CAFL455=8Sv1AaPvK1tjouko5ReVgaw_6Y7iLap1ywHeRgN+_tg@mail.gmail.com>
Subject: Re: [PATCH] target: allow setting dbroot as a module parameter
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        lduncan@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Mike,

po 11. 10. 2021 v 18:50 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> On 9/27/21 2:38 PM, Maurizio Lombardi wrote:
> > The target driver prevents the users from changing
> > the database root directory if a target module like ib_srpt
> > has already been loaded during boot.
>
> Why is that not allowed if we have a fabric driver loaded?
>
> It looks like we don't start using the db_root until we have created
> a device (alua and pr metadata)

Your solution would work perfectly for me but I still have a doubt:

CC: Lee Duncan

I think that changing db_root is not allowed if we have a fabric driver loa=
ded
because the latter could have potentially used the core's dbroot
attribute to access the
directory's content.

See the description of the commit that introduced the configurable dbroot:
--------
commit a96e9783e05851d5f06da0ae7635aec55a228e3d
Author: Lee Duncan <lduncan@suse.com>
    target: make target db location configurable

    This commit adds the read-write attribute "dbroot",
    in the top-level CONFIGFS (core) target directory,
    normally /sys/kernel/config/target. This attribute
    defaults to "/var/target" but can be changed by
    writing a new pathname string to it. Changing this
    attribute is only allowed when no fabric drivers
    are loaded and the supplied value specifies an
    existing directory.

    Target modules that care about the target database
    root directory will be modified to use this
    attribute in a future commit.
--------

Maurizio

