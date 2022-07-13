Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B4EC43334
	for <target-devel@archiver.kernel.org>; Wed, 13 Jul 2022 19:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiGMTE0 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 15:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiGMTEZ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 15:04:25 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAFA12097
        for <target-devel@vger.kernel.org>; Wed, 13 Jul 2022 12:04:24 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id r184so5591880vkg.9
        for <target-devel@vger.kernel.org>; Wed, 13 Jul 2022 12:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=YhuJs1NHz8Tg2/H2+KgkPEhAzbghoAvrXlNFDhsi2hc=;
        b=opFQ32vFz4vK/Yke8z2Uf0J6JhP1iecMCxs8xXMIQOV2aECucZYXjt7KTQxCC+0WsC
         FyePqDjkn4ESqNfoX4vEPuYmeUEKAKtR3oUiSPnFs1S+Z+dMmgLo33BhwqvvMERjTeLG
         XxSrDXNaHvfPT6MZyu6fD9GpsyervOK2CyRJjZjoQpd8d4vLQ8XmzdzVo/2uguM4ri1h
         UOsi1IVvEDfEF3/F82W30OmORtKcScjUCON46Vx0aes9CcDwC9g2XJ4HGE4Y0N6GwO6p
         cM+fJkMPv88oegJ99cbHlfAtmMRByslOE8ctNB7RPv6kf6jXzyzyf4CtL2wgNyrunAoF
         hm6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YhuJs1NHz8Tg2/H2+KgkPEhAzbghoAvrXlNFDhsi2hc=;
        b=qvw2fEsLlK9hsgZuAEdDDA5hbmLzaOHzxP5WD2oVzZX1wzErUUDkGbmj7P3H+ipQt8
         oy2FQxiScYh6PjMZCH99JNzNGFRFWRlyjdFGmprBRZEs7TL7QFqpbVsEO8wsZHWVVVak
         QteaLhStEb6Kg+iBxxNzISvezi96rSsGQQ2t6iN6ok9HtS7uv9lk/If3dWXNAzsMaepO
         SfyOq0w5KON/tJX+gyGxZri8YGuO/2aZKI6rW9ZDlDr6ZrqJ2zhOZDUetck++Pe1/8+7
         QY2U+D75zG6IF+7XfgGZfGqvR+6ZNgQrH5+QLMvNYIgSEBSQpeDoiHUT3JpaJ0LxA5OT
         mWUw==
X-Gm-Message-State: AJIora95ZaoGZEbRilLndCBQaPxuVip3Gu0WQpXVXHcoiMf2+Zx7GaNO
        PlCikhZyOlsytNFzluCOTAXuoBg2eSjgNGLWb/r37WTic4A=
X-Google-Smtp-Source: AGRyM1tufx5BBTwhUBCrbpjm98ouSXVQEgVNLkS7475LEk+lRtr5uHoFbJ6PT4ONFac0Ox2heuEJ+7Wz87if5mtYRj4=
X-Received: by 2002:a05:6122:e56:b0:374:a74b:a09 with SMTP id
 bj22-20020a0561220e5600b00374a74b0a09mr2197375vkb.5.1657739063380; Wed, 13
 Jul 2022 12:04:23 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Couchman <nick.e.couchman@gmail.com>
Date:   Wed, 13 Jul 2022 15:04:12 -0400
Message-ID: <CAFjj603YVVF8jK9RS_Pe5d0YTEUkCWZ5EwdXsVGgjSQWNfU_Lw@mail.gmail.com>
Subject: Unable to recover from DataOut timeout while in ERL=0
To:     target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

(Apologies if this ends up as a double-post, re-sending in Plain Text Mode)

Hello, everyone,
Hopefully this is the correct place to ask a general
usage/troubleshooting question regarding the Linux Target iSCSI
system.

I'm using the Linux iSCSI target on a pair of CentOS 8 Stream VMs that
are configured with DRBD to synchronize data between two ESXi hosts,
and then present that disk back to the ESXi hosts via iSCSI. Basically
I'm attempting to achieve a vSAN-like configuration, where I have
"shared storage" backed by the underlying physical storage of the
individual hosts.

It's worth noting that, at present, I'm not using an Active/Active
configuration (DRBD dual-primary), but each of the VMs has the DRBD
configuration and iSCSI configuration, and I can fail the primary and
iSCSI service back and forth between the nodes.

I'm running into a situation where, once I get the system under
moderate I/O load (installing Linux in another VM, for example), I
start seeing the following errors in dmesg and/or journalctl on the
active node:

Unable to recover from DataOut timeout while in ERL=0, closing iSCSI
connection for I_T Nexus
iqn.1998-01.com.vmware:esx01-18f91cf9,i,0x00023d000001,iqn.1902-01.com.example.site:drbd1,t,0x01

This gets repeated a couple of dozen or so times, and then I/O to the
iSCSI LUN from the ESXi host halts, the path to the LUN shows as
"Dead", and I have to reboot the active node and fail over to the
other node, at which point VMware picks back up and continues.

I've searched around the web to try to find assistance with this
error, but it doesn't seem all that common - in one case it appears to
be a bug from several years ago that was patched, and beyond that not
much relevant has turned up. Based on the error message, it almost
seems as if the target system is trying to say that it couldn't write
its data out to the disk in a timely fashion (which might be because
DRBD can't sync as quickly as is expected?), but it isn't all that
clear from the error.

I'm wondering if anyone can provide tips as to how to best mitigate
this - any tuning that can be done to change the time out, or throttle
the iSCSI traffic, or is it indicative of a lack of available RAM for
buffering (I'm not seeing a lot of RAM pressure, but possible I'm just
not catching it)?

Environment:
* CentOS 8 Stream
* Kernel: 4.18.0-394.el8.x86_64
* DRBD: 9.1.7
* 2 CPU, 4GB of RAM per VM
* Shared block devices is 1 TB

Thanks - Nick
