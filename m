Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311F9C77B7C
	for <target-devel@archiver.kernel.org>; Thu, 11 May 2023 15:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbjEKPkl (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 11 May 2023 11:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbjEKPkj (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 11 May 2023 11:40:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B577B6597
        for <target-devel@vger.kernel.org>; Thu, 11 May 2023 08:40:34 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id D24BF3425A7
        for <target-devel@vger.kernel.org>; Thu, 11 May 2023 18:40:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :content-type:content-type:date:from:from:message-id
        :mime-version:reply-to:subject:subject:to:to; s=mta-01; bh=sRacG
        69OQWb+sGdrG3zNJxdLQ9fkHOgOAR0lZodW5bA=; b=HYgdpFioG1E63iiRxneJI
        J939EpmR7/Ocylm8dcEZmoXs/KW0PS0nvELvdtZeslNqHatGcdGMHR/+M4uLzq58
        91KIeBKlv+2Z4HQcxU5YF7eyy6oGK0lqmMwfuw+yhuYC7/dtDK8438aqINm/Bsoc
        QVJcMzyxUiHnJ1IJDhCvAU=
Received: from T-EXCH-07.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id C36143425A5
        for <target-devel@vger.kernel.org>; Thu, 11 May 2023 18:40:32 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 11 May 2023 18:40:32 +0300
Received: from yadro.com (10.178.192.41) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 11 May
 2023 18:40:32 +0300
Date:   Thu, 11 May 2023 18:40:56 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     <target-devel@vger.kernel.org>
Subject: SCSI target logs
Message-ID: <ZF0MiCRW8HWm8YYj@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.178.192.41]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi,

For the last couple of days I've been thinking how to improve the target
logs. My pain points:

  1. There is no common prefix for the subsystem
  2. It's kinda hard to determine which I-T-L nexus was affected

For example:

  [Thu May 11 00:00:00 2023] Waiting for running cmds to complete.

Or something even more sinister:

  [Thu May 11 00:00:00 2023] bio error: 0xfffffffff, err 10

Only someone familiar with the kernel code can tell that this is
actually target_core_iblock discovering an I/O error.

While all of this is not a blocker per se, because a skilled enough
developer can connect all the dots, such analysis requires a lot of time
and patience on large systems with hundreds of ACLs and several TPGs.

Okay, so what the others do? PCI and USB subsystems clearly enjoy having
a unique ID:

  [Thu May 11 00:00:00 2023] iwlwifi 0000:00:14.3: WFPM_UMAC_PD_NOTIFICATION: 0x1f
  [Thu May 11 00:00:00 2023] usb 3-7: reset high-speed USB device number 2 using xhci_hcd

Quick look at the lspci/lsusb output is all it takes to understand which
device was affected.

Network interfaces enjoy having a user-friendly name:

  [Thu May 11 00:00:00 2023] wlan0: authenticate with cc:2d:e0:10:8d:b9

Same goes for file systems and block devices.

NVMe target uses pr_info(), benefiting from having neatly chosen module
names:

  [Thu May 11 00:00:00 2023] nvmet: Foo happened (NVMe core)
  [Thu May 11 00:00:00 2023] nvmet_fc: Bar happened (NVMe over FC)
  [Thu May 11 00:00:00 2023] nvmet_tcp: Foo happened (NVMe overTCP)

However, we don't get to known which NVMe Host was affected unless the
log line already contains the necessary info.

Back to the target. The simplest solution that at least gives the user
some context is to put this in each C file:

  #define pr_fmt(fmt) KBUILD_MODENAME  ": " fmt

But since target modules all named differently, one can't just

  $ dmesg | grep target_

like with NVMe target. You'll have to do this:

  $ dmesg | grep -E '_target_|tcm_|isert|cxgbit'

That's because we have target_core_mod, isert, cxgbit, iscsi_target_mod,
tcm_qla2xxx and so on. Yikes, but this is still an improvement. However,
it does not give us any clue about the affected I-T-L nexus.

So, my proposal. We should give all modules similar names:

  tcm
  tcm_iscsi
  tcm_iser
  tcm_qla2xxx
  tcm_iblock
  tcm_loop
  tcm_cxgb

I would prefer scsit_ instead of tcm_, but I guess this ship has sailed.

Next, let's introduce some macros: tcm_LEVEL(), tcm_sess_LEVEL() and
tcm_lun_LEVEL():

  tcm_err("This module blew up\n")
  [Thu May 11 00:00:00 2023] tcm_iser: This module blew up
                             ^^^^^^^^
                             |
                             Module name

  tcm_sess_err(&se_sess, "Waiting for running cmds to complete.\n")
  [Thu May 11 00:00:00 2023] tcm_iscsi [iqn.2023-01.com.example:blah-blah -> 10]: Waiting for running cmds to complete.
                             ^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^
                             |          |                                    |
                             |          |                                    RTPI
                             |          Initiator port
                             Module name

  tcm_lun_err(&se_lun, "bio error %p, err: %d\n", bio, bio_status)
  [Thu May 11 00:00:00 2023] tcm_iblock [iqn.2023-01.com.example:blah-blah -> 10/5]: bio error: 0xfffffffff, err 10
                             ^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    ^^ ^
                             |           |                                    |  |
                             |           |                                    |  MAPPED LUN
                             |           |                                    RTPI
                             |           Initiator port
                             Module name

Sorry for the long email, just needed to swap out all this. Thoughts?

