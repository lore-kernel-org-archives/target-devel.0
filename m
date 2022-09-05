Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89ACECAAD5
	for <target-devel@archiver.kernel.org>; Mon,  5 Sep 2022 06:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiIEGsG convert rfc822-to-8bit (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 5 Sep 2022 02:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbiIEGsC (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 5 Sep 2022 02:48:02 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0AE3845C
        for <target-devel@vger.kernel.org>; Sun,  4 Sep 2022 23:48:00 -0700 (PDT)
Received: from opme11oxm20nd1.pom.fr.intraorange ([10.110.57.20])
        by smtp.orange.fr with ESMTP
        id V5tmo0wiCu8plV5tmoeeOv; Mon, 05 Sep 2022 08:47:58 +0200
X-ME-Helo: opme11oxm20nd1.pom.fr.intraorange
X-ME-Auth: ZnJhbmNpcy5zb3V5cmlAb3JhbmdlLmZy
X-ME-Date: Mon, 05 Sep 2022 08:47:58 +0200
X-ME-IP: 77.193.136.141
Date:   Mon, 5 Sep 2022 08:47:58 +0200 (CEST)
From:   Francis SOUYRI <francis.souyri@orange.fr>
Reply-To: Francis SOUYRI <francis.souyri@orange.fr>
To:     target-devel@vger.kernel.org
Message-ID: <795111402.4983783.1662360478569.JavaMail.open-xchange@opme11oxm20nd1.pom.fr.intraorange>
Subject: LIO no memory buffer/cache used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.3-Rev64
X-Originating-IP: 77.193.136.141
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

For a test environment with an old server I created a storage bay using CentOS
7.9 and LIO.

I have some RAID5 Logical Volume exported using ISCSI LIO to some VMWare
servers.

The storage server have 32Go memory but no memory are used for the buffer/cache
I have more than 30Go free.

On the storage server when I start io's (dd) on a logical volume, I see the use
of the memory buffer/cache (buffer) increase.

On a LIO client (VM on a VMWare server) when I do io's, on the storage server no
memory buffer/cache are used.

This is not a problem with VMWare I have the same issue with a CentOS iSCSI
client.

This is like LIO bypass the buffer/cache, on the storage server I “loaded” a
Logical Volume in the buffer/cache (dd if=/dev/vg/lv of=/dev/null) and from the
LIO client when I read de Logical Volume (dd if=/dev/sdx of=/dev/null) all the
read io's come from the disk.

PS: I have and OpenMediaVault server with TGT for the iSCSI and Logical Volume
exported the buffer/cache (vmstat buff) is used.

Best regards.

Francis
