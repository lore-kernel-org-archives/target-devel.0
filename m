Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF2FC04FF8
	for <target-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjITUDC (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjITUDB (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:03:01 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231FFA1
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:02:55 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-690bf8fdd1aso156132b3a.2
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240174; x=1695844974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OX1tib1cS0K1FoemoJ5tS6C5q3knAUcT+dmyvZ5ftg8=;
        b=GMnF2a+DnUsAWF4uFEZEmnXIW7YNWC65lz2mA2DHp+i8uGKzzmsTq5NqVgVjkKqvny
         mveFnBG9dGMqYewA70QeSICnwl5I7S3n64UUTicMZY5JbXpjPeWjA/I5E2mWCuoUSEcw
         9HtPctn8KMOK3aLwIiqEfs1HZ494qUEIwlYxqNyJDUNjPtAKpMHBwOKRCu++6G0515i7
         7hJUX5TkidsK1ZZ31R9d6/6LDTcHzWgU8jp3E3K5gDDrlLyCOOKOYJuLMVJT7HnaYSZm
         gtXt9O4mfMf3eynJq7fHLEid4ptUjXnmHhcvZBKwBAYSvT6g7mTorJebgKREqgDt35JC
         n8Sg==
X-Gm-Message-State: AOJu0YxJ0eYYE2V4s4zEbBjSIRSWSLFCLXHEufloVxpiMmncaobzKPAs
        JCfOGS7VWWq7aWF25VkoLAc=
X-Google-Smtp-Source: AGHT+IHu5PJJtqMUmWtN9EKiB/m1CdCvlu9OwEEsNFPEnYWBK/dw/doVqk9anlv94j/sSa/prQEJBg==
X-Received: by 2002:a05:6a00:18a9:b0:68f:f0bb:7de1 with SMTP id x41-20020a056a0018a900b0068ff0bb7de1mr3806576pfh.11.1695240174414;
        Wed, 20 Sep 2023 13:02:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b0c6:e5b6:49ef:e0bd])
        by smtp.gmail.com with ESMTPSA id c70-20020a633549000000b0054fe7736ac1sm10035341pga.76.2023.09.20.13.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 13:02:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 1/3] scsi: target: Remove the references to http://www.linux-iscsi.org/
Date:   Wed, 20 Sep 2023 13:00:19 -0700
Message-ID: <20230920200232.3721784-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230920200232.3721784-1-bvanassche@acm.org>
References: <20230920200232.3721784-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

The website http://www.linux-iscsi.org/ disappeared more than a year ago.
DNS records have been removed for linux-iscsi.org. The company that
sponsored this website (Datera; formerly called Rising Tide) has been
liquidated in early 2021 according to
https://blocksandfiles.com/2021/03/19/datera-is-being-liquidated/.
Since it is unlikely that the website http://www.linux-iscsi.org/ will be
restored, remove the references to that website.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 MAINTAINERS                  | 2 --
 drivers/target/iscsi/Kconfig | 9 ++++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90f13281d297..10a2d6af910b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11144,7 +11144,6 @@ M:	Sagi Grimberg <sagi@grimberg.me>
 L:	linux-rdma@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
-W:	http://www.linux-iscsi.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
 F:	drivers/infiniband/ulp/isert
 
@@ -19162,7 +19161,6 @@ M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
-W:	http://www.linux-iscsi.org
 Q:	https://patchwork.kernel.org/project/target-devel/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
 F:	Documentation/target/
diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index 922484ea4e30..922b207bc69d 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -1,12 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config ISCSI_TARGET
-	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	tristate "SCSI Target Mode Stack"
 	depends on INET
 	select CRYPTO
 	select CRYPTO_CRC32C
 	select CRYPTO_CRC32C_INTEL if X86
 	help
-	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
-	Target Mode Stack.
+	Say M to enable the SCSI target mode stack. A SCSI target mode stack
+	is software that makes local storage available over a storage network
+	to a SCSI initiator system. The supported storage network technologies
+	include iSCSI, Fibre Channel and the SCSI RDMA Protocol (SRP).
+	Configuration of the SCSI target mode stack happens through configfs.
 
 source	"drivers/target/iscsi/cxgbit/Kconfig"
