Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB9DC433DB
	for <target-devel@archiver.kernel.org>; Mon, 28 Dec 2020 17:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8247622A84
	for <target-devel@archiver.kernel.org>; Mon, 28 Dec 2020 17:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgL1RlK convert rfc822-to-8bit (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 28 Dec 2020 12:41:10 -0500
Received: from lx18.cmks.de ([212.48.108.218]:40944 "EHLO lx18.cmks.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbgL1RlK (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 28 Dec 2020 12:41:10 -0500
Received: from lx18.cmks.de (localhost [127.0.0.1])
        by lx18.cmks.de (Postfix) with ESMTP id 8FCFA6BE003
        for <target-devel@vger.kernel.org>; Mon, 28 Dec 2020 18:40:28 +0100 (CET)
Received: from lx18.cmks.de (localhost [127.0.0.1])
        by lx18.cmks.de (Postfix) with ESMTP id 79C7A6BE001
        for <target-devel@vger.kernel.org>; Mon, 28 Dec 2020 18:40:23 +0100 (CET)
Subject: LinuxIO (LIO) target @ Debian 10 and VMware 6.7 Initiator: Detected
 WRITE_PROTECTED LUN Access for 0x00000000
From:   =?utf-8?Q?Bj=C3=B6rn_Wiggert_=28wiggert=2Eit=29?= <b@wiggert.it>
To:     =?utf-8?Q?target-devel=40vger=2Ekernel=2Eorg?= 
        <target-devel@vger.kernel.org>
Date:   Mon, 28 Dec 2020 18:40:23 +0100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-Mailer: Zarafa 7.1.4-41394
Message-Id: <zarafa.5fea1887.7399.7358001426d7aa4b@lx18.cmks.de>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi, we are running
*	QNAP NAS
*	Debian 10
*	Host VMware 6.7U3 Hypervisor

a) Exporting an iSCSI-LUN-target with the QNAP, what is using LIO therfor, and accessing it from VMware (read/write) works fine.
b) Exporting an iSCSI-LUN-target with a fresh Debian 10 using LIO and accessing it with a Windows 7 iSCSI initiator (read/write) works fine.

Using the target b) (Debian 10 / LIO) and the initiator a) (VMware v6.7) works as far as
*	VMware sees the target host
*	VMware can login and sees the target
*	VMware can READ the data on the LUN (sees partition table, size of it, partition types, etc)
 
As soon as we try to write anything VMware reports

> 2020-12-28T14:36:00.775Z info hostd[2098690] [Originator@6876 sub=Partitionsvc opID=esxui-2f96-fbd9 user=root] Status : 255 Output: gpt 0 0 0 0
>
> Error : Error: Read-only file system during write on /dev/disks/naa.60014054b666e78a1c443ee941c60e3e SetPtableGpt: Unable to commit to disk


and the Debian 10 box reports:

> kernel: [ 80.210044] TARGET_CORE[iSCSI]: Detected WRITE_PROTECTED LUN Access for 0x00000000

I don't recognize why VMware mounts the iSCSI LUN read-only but Windows 7 mounts it read-write and VMware mount the QNAP-iSCSI-LUN also read-write.

I appreciate any hint - thank you therfor in advance.

Jan 

 
