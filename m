Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B84C433E0
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 21:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B849A64F2C
	for <target-devel@archiver.kernel.org>; Thu, 25 Feb 2021 21:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhBYVsZ convert rfc822-to-8bit (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:48:25 -0500
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:25718 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhBYVsY (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 16:48:24 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2021 16:48:23 EST
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 508B83F40A
        for <target-devel@vger.kernel.org>; Thu, 25 Feb 2021 22:36:30 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QsSGiwEhyPtH for <target-devel@vger.kernel.org>;
        Thu, 25 Feb 2021 22:36:29 +0100 (CET)
Received: by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id C82E83F3AE
        for <target-devel@vger.kernel.org>; Thu, 25 Feb 2021 22:36:29 +0100 (CET)
Received: from [192.168.0.126] (port=51160)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.93.0.4)
        (envelope-from <forza@tnonline.net>)
        id 1lFOJB-0005rC-6B
        for target-devel@vger.kernel.org; Thu, 25 Feb 2021 22:36:29 +0100
Date:   Thu, 25 Feb 2021 22:36:27 +0100 (GMT+01:00)
From:   Forza <forza@tnonline.net>
To:     target-devel@vger.kernel.org
Message-ID: <af031d3.b2327dec.177db1f2641@tnonline.net>
Subject: Stability of FILEIO as backing store?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi,

I have a weird issue with using a file as backing store with a Win2016 server as initiator. 

Very often if I reboot the Linux server the disk image becomes corrupt so that Windows cannot even detect the gpt partition table on it. It can happen even if I shut down the Windows machine before I reboot the Linux server.

Initially I thought I would be write cache. But I've disabled that with no benefit to this problem. 

There are no errors in dmesg except initially when loading the target. Perhaps I'm doing wrong when rebooting? 


[   71.583665] dev[0000000064b6f5d8]: Unable to change SE Device alua_support: alua_support has fixed value
[   71.583676] dev[0000000064b6f5d8]: Unable to change SE Device alua_support: alua_support has fixed value
[   71.583837] ignoring deprecated emulate_dpo attribute
[   71.583874] ignoring deprecated emulate_fua_read attribute
[   71.584553] dev[0000000064b6f5d8]: Unable to change SE Device pgr_support: pgr_support has fixed value
[   71.584561] dev[0000000064b6f5d8]: Unable to change SE Device pgr_support: pgr_support has fixed value


The LIO target is running Fedora 33 Server with two Seagate Exos 10TB in Btrfs RAID-1 mode.

Are there any debugging options that would help?

Thanks for any advice.

~Forza
