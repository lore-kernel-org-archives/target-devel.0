Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_05,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE778C433E0
	for <target-devel@archiver.kernel.org>; Wed, 10 Mar 2021 07:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820A764FED
	for <target-devel@archiver.kernel.org>; Wed, 10 Mar 2021 07:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCJHNw (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 02:13:52 -0500
Received: from mail177-27.suw61.mandrillapp.com ([198.2.177.27]:43880 "EHLO
        mail177-27.suw61.mandrillapp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhCJHN1 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 02:13:27 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2021 02:13:27 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mandrill; d=nexedi.com;
 h=From:Subject:To:Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding; i=vincent@nexedi.com;
 bh=clByO+YyjeNz5x5NMjsaqhUb+yntq/+4EVnS+9KNQUc=;
 b=OIdLUXMt3J6V+Nsz/DMfmA4cKU7f0CenExK0f362ymGDfs6SCDqYUsZu3+6hZk1F856lrIFR9HOz
   s6EXmmm/kRvp6cmJPhEXJODF/7iaxYhucjByEDLNg2ltOvSmc1AO6cLirnUKDOWNexXs+mrmfApN
   ESvVLjjEL1+9EQBKjNk=
Received: from pmta06.mandrill.prod.suw01.rsglab.com (127.0.0.1) by mail177-27.suw61.mandrillapp.com id h91ope22rtk4 for <target-devel@vger.kernel.org>; Wed, 10 Mar 2021 06:58:22 +0000 (envelope-from <bounce-md_31050260.60486e0e.v1-d90cbedd86df4bd4b60cef165ba0f632@mandrillapp.com>)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com; 
 i=@mandrillapp.com; q=dns/txt; s=mandrill; t=1615359502; h=From : 
 Subject : To : Message-Id : Date : MIME-Version : Content-Type : 
 Content-Transfer-Encoding : From : Subject : Date : X-Mandrill-User : 
 List-Unsubscribe; bh=clByO+YyjeNz5x5NMjsaqhUb+yntq/+4EVnS+9KNQUc=; 
 b=gUXaddkgQ84Ea6pEMD21IN7VuUCXSySFuw7jIdFRqG8eN3FT5Rh8T/U+Pv3zLF52UB91fp
 CmCmXhaUQyqleOfPlnq1TPg3OoV6R2YpZYuu4or3PSCD1FXELVKkL0N5QKvP9vB29cG2WZiy
 mAlXgE/h76ai0IoTPUrymEsqdJZjA=
From:   Vincent Pelletier <vincent@nexedi.com>
Subject: Is vHost reversible ?
Received: from [87.98.221.171] by mandrillapp.com id d90cbedd86df4bd4b60cef165ba0f632; Wed, 10 Mar 2021 06:58:22 +0000
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
To:     target-devel@vger.kernel.org
Message-Id: <20210310155813.7bef9aca@vincent-tkpad>
X-Report-Abuse: Please forward a copy of this message, including all headers, to abuse@mandrill.com
X-Report-Abuse: You can also report abuse here: http://mandrillapp.com/contact/abuse?id=31050260.d90cbedd86df4bd4b60cef165ba0f632
X-Mandrill-User: md_31050260
Date:   Wed, 10 Mar 2021 06:58:22 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

(please keep me CC'ed, I'm not subscribed)

I have a NVMe-like high-performance storage device which requires a
proprietary module to work. Because it is not upstream, I tend to
distrust by default its quality, and I want to isolate it from the rest
of the machine.
I did this by using PCI virtualisation, so now I have a qemu-kvm
running a kernel with the proprietary module, and containing the block
device, and I want to expose this block device back to the host (where
the databases desiring to access this block device will run).

If I ignore the hypervisor/VM relationship, I would be tempted to setup
an iSCSI target over the network, but I am worried about the overhead.

But with this special relationship in mind, I would like to use
vHost-like, just in the exact opposite way (VM has the backstore, host
is the initiator and gets a block device), and likely get a lower
overhead.

Is this possible ?

I am quite new to the whole virtio family, so please forgive me if the
answer is blindingly obvious.
-- 
Vincent Pelletier
ERP5 - open source ERP/CRM for flexible enterprises


