Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6560C46CA1
	for <target-devel@archiver.kernel.org>; Mon, 18 Sep 2023 22:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjIRWAU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjIRWAT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 18:00:19 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C06F8E
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:14 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68fb85afef4so4617904b3a.1
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695074413; x=1695679213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQifIvgUX0RxtJhdkzDQnfxGVU/5lZO6sAISIZ7OW70=;
        b=ZHwTAGcLjxKGikiwFzMVbXH6oj5e0TTwFFKePJ76TN+v2zgzW63oFy8CLQ3kpk+EE0
         QqzW06BZPxIJXFz3GrMQItj2/Ai4Ryj9IJoHqJ2tFoUbPino3bWlQi++evwxKhDWo8ev
         qZexkgnvXenFsvcDIR3v/xL71dDvy+hlQ7m/0/f1EE7OLyFeKCdSaicMUKs4+dhdnxDZ
         V1fmio6Tb94llk8hxNR6sI5Y9HwHWEvwxzliBz1xpA9t9HfUJztErUqL91JwtVq38mHx
         QkWZfZzEeCNW0cQC36Awi9bXdTvbad1z2oT+bfnXK6UbKhQ+IjPlXZP4VzJ5ZrfoMLJh
         couw==
X-Gm-Message-State: AOJu0Ywh0t4f9Ooso6wIWnYP/bZ0YUpHqT55UjI1aSAgKHusDDo/pDnj
        SbzfHyuXWgonetsGtW8EnKQ=
X-Google-Smtp-Source: AGHT+IHDkjIYF6oCo5oNeaFahCE5peme8c2mdtkuRnkKAVxRTt9HKHNtY/lJ/F/Rg/VzYxaDKLC41Q==
X-Received: by 2002:a05:6a20:1584:b0:14d:29f6:18c3 with SMTP id h4-20020a056a20158400b0014d29f618c3mr10411992pzj.20.1695074413508;
        Mon, 18 Sep 2023 15:00:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id fe20-20020a056a002f1400b00687dde8ae5dsm7514850pfb.154.2023.09.18.15.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 15:00:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] scsi: target: Remove the references to http://www.linux-iscsi.org/
Date:   Mon, 18 Sep 2023 14:59:39 -0700
Message-ID: <20230918215941.2053109-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918215941.2053109-1-bvanassche@acm.org>
References: <20230918215941.2053109-1-bvanassche@acm.org>
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
