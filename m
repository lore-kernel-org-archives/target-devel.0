Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE13C433E6
	for <target-devel@archiver.kernel.org>; Fri, 15 Jan 2021 07:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA3322C7D
	for <target-devel@archiver.kernel.org>; Fri, 15 Jan 2021 07:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbhAOHHr (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 02:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbhAOHHq (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 02:07:46 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E230C0613CF
        for <target-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:07:06 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id h4so10856313qkk.4
        for <target-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:mime-version:date:message-id;
        bh=2yp92apWwNwhqVIGDyCRpqeoy4gnE0AB9xvUO98T5mk=;
        b=BIxqVI049uHGbzyunwrPKe0PzxPGwk/fBMH19/pC7a9KlAOEQlEIPnzopKeKjpe1rQ
         lqH+uF5qytPn+NB5lXoO53oncIVCeUVoY5eq+FqvC+Gnh1am7jMvqxaB7yD6VarKytG1
         wFOb2pY8Wa465VxjL0L9mr0IVezFrTzQWLSEejVsqcnHD6zYSm5FySoz96LwMU2Uw5Rr
         fEqm2nMIKUUyWQahQgZWMkjS1DXpN5xRuNGn0RgVSaPQoLPIzSJOFHT/NRVkn49dSVTb
         ceJJPaoh/CuS1r7nSH+iYBoW15VbZyJwJtPleHNpn9cW+ZiXcw8WwtZWYzPKUJQGZlv0
         lM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=2yp92apWwNwhqVIGDyCRpqeoy4gnE0AB9xvUO98T5mk=;
        b=pPfJSjojl9thRzrCsMMtk1YItchj3aDEOvUMvppGxoRs6O6+vlJHCbfSUIjeeuZ643
         RAzbOTWPfxydu5lb/Ksy1g4UKnKI8KkbdNYqF0dtVXz3c31J49BukfHLEZCOsfEpxdWL
         1V3GginBdtcgMMWbApGOa8tEWdeeCUMXC94LiwI2rVNL11TltX9sPAvsro5OwDqwhkuN
         jP1NNnMaz+GxqUiZUjZEgp7vuAD5KK4maSiX4mi4klE3qXuPCmZE223vI5gSyLg3k3XT
         anFHgWDBA8MF74E6eORbOZM6Y7/L0IdmV1qHOMVpENJvXsTpaoWNRU2+LGH7FH1etVEW
         KltQ==
X-Gm-Message-State: AOAM530rRybIkux/npfAj1BO8WIxEr/+oyhgQ5Fuy90HaoOGd3XK0swm
        LJg0T1BE2H4ATeWe3g5y59oF+q4zHMW+pA==
X-Google-Smtp-Source: ABdhPJzzJ4RBkK8vsiRPylqJAoa/22MXprhzfu0zr1DV0iaG1dbNUTvNpIxDICSUvjO3rI4z16bieQ==
X-Received: by 2002:a37:b404:: with SMTP id d4mr10762522qkf.183.1610694425523;
        Thu, 14 Jan 2021 23:07:05 -0800 (PST)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id h25sm4156195qtp.80.2021.01.14.23.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 23:07:04 -0800 (PST)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: Fix typo in comment
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Fri, 15 Jan 2021 02:07:03 -0500
Message-ID: <2921.1610694423@turing-police>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Correct the spelling of Nagle's name in a comment.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 893d1b406c29..1a9c50401bdb 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -896,7 +896,7 @@ int iscsit_setup_np(
 	else
 		len = sizeof(struct sockaddr_in);
 	/*
-	 * Set SO_REUSEADDR, and disable Nagel Algorithm with TCP_NODELAY.
+	 * Set SO_REUSEADDR, and disable Nagle Algorithm with TCP_NODELAY.
 	 */
 	if (np->np_network_transport == ISCSI_TCP)
 		tcp_sock_set_nodelay(sock->sk);

