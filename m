Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70ECAC4338F
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5192660EB2
	for <target-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhG1Lya (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:54:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43208 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbhG1LyW (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 07:54:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DD76A222E8;
        Wed, 28 Jul 2021 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627473259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Pf7SCFSRLv8RVXVHE2hq++xOKG5qxIe8frzxVWZ8JyY=;
        b=HqEXBJ2JjtMEEqdR179uznRttFSGuyPZo7oe0H+80+xFsAqNKGaLWWXs9gdIIQtUijXwQY
        9e/Z7/Rb1RFup+8iahA95iKGwz6gZdE+UEYgZ1es11zR4of81zpJbDlXldE31TqongIy/A
        ReDlbe9XdA6w/yFGxZU/lCbGN1Pu4fU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627473259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Pf7SCFSRLv8RVXVHE2hq++xOKG5qxIe8frzxVWZ8JyY=;
        b=0gfXi4I0RiK0b8z6iPTyrUI5UMeQEALTh20Cs2r+5bgTz9VXDu+B1h7guVMu0KwsNSu9V9
        +Ojd2LXI79OipWBw==
Received: from echidna.suse.de (unknown [10.163.26.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9CB55A3B84;
        Wed, 28 Jul 2021 11:54:19 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, michael.christie@oracle.com
Subject: [PATCH 0/3] scsi: target: se_cmd cleanups and race fix
Date:   Wed, 28 Jul 2021 13:53:51 +0200
Message-Id: <20210728115353.2396-1-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

While looking into XCOPY sense propagation issues (see Sergey's
patchset), I came across some se_cmd members which are unneeded. This
series also carries a fix for a theoretical lun_tg_pt_gp race condition.

Cheers, David


 drivers/target/sbp/sbp_target.c        |  4 +-
 drivers/target/target_core_alua.c      | 94 ++++++++++----------------
 drivers/target/target_core_transport.c | 33 ++++++---
 include/target/target_core_base.h      |  8 ++-
 4 files changed, 66 insertions(+), 73 deletions(-)

