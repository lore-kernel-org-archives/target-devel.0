Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1B7C04FF7
	for <target-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjITUDQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjITUDP (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:03:15 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5659AB
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:03:09 -0700 (PDT)
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-57b2e23de65so149682eaf.1
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240188; x=1695844988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5vtzd110SJokQkU40OeXlXOJPPWgg/vRi+62V9FJLow=;
        b=UUmaRi9dj99Z2+oxTdGrimtTzrc28OpuzG0DYQuCsQJXhbhITQoTGWCGZVKSNnVYyU
         od3ie0U+GH0QhHojgoaW2E9+urjSYs6PqocQzb7J6+pzOH/B4cdbwiBsxkQApIF0YgHP
         Hv841pnPwP1uw7v6sHGwxg/jNrZdXjt2kamND+9zTUhz00aIrvcWSHd/bma2hvnMBSoW
         l0B9O3GrfvTOgH1vYZ4ftVKTCQ2W0P6C8IKxU3ixXXv085n3+eG8NILqSDkT8e8ASuNv
         Y6oSx2T1w1ebHr4bIETUYL7itzCYW/EeGAtAiu10XGUT0MUvV+Y4EzIgegGPL6Ww8dk4
         +0rw==
X-Gm-Message-State: AOJu0YzXHCjM8rCfy+KgCSn9hsMuEBshCPstStbbRBvG8eBCERMgVf2P
        j8yAHRqrE4DVrGoRXHMAOtE=
X-Google-Smtp-Source: AGHT+IGJhMcivFdGPvWATPwvcjq+a80e8sIigKGbfsr/yuWgM8FCYAY4GXJJUJDBQ1kc5aNK7Dzsag==
X-Received: by 2002:a05:6870:4411:b0:1c0:c42f:6db2 with SMTP id u17-20020a056870441100b001c0c42f6db2mr3826612oah.37.1695240188567;
        Wed, 20 Sep 2023 13:03:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b0c6:e5b6:49ef:e0bd])
        by smtp.gmail.com with ESMTPSA id c70-20020a633549000000b0054fe7736ac1sm10035341pga.76.2023.09.20.13.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 13:03:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 2/3] scsi: target: Remove linux-iscsi.org copyright statements
Date:   Wed, 20 Sep 2023 13:00:20 -0700
Message-ID: <20230920200232.3721784-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230920200232.3721784-1-bvanassche@acm.org>
References: <20230920200232.3721784-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Remove the linux-iscsi.org copyright statements since these copyright
statements duplicate the Rising Tide copyright statements. Note: according
to https://www.copyright.gov/what-is-copyright/, copyright can be owned by
companies, organizations or people. A website cannot own copyright.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/tcm_fc/tfc_conf.c | 2 --
 drivers/target/tcm_fc/tfc_io.c   | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 6ac3fc1a7d39..a7cb98d8eaa1 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -7,8 +7,6 @@
  *
  * Copyright (c) 2010 Cisco Systems, Inc.
  * Copyright (c) 2009,2010 Rising Tide, Inc.
- * Copyright (c) 2009,2010 Linux-iSCSI.org
- *
  * Copyright (c) 2009,2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
  ****************************************************************************/
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index bbe2e29612fa..153bb0194c87 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -8,7 +8,6 @@
  * Copyright (c) 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2008 Mike Christie
  * Copyright (c) 2009 Rising Tide, Inc.
- * Copyright (c) 2009 Linux-iSCSI.org
  * Copyright (c) 2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
  */
 
