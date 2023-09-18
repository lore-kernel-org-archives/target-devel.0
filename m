Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC80ACD13D2
	for <target-devel@archiver.kernel.org>; Mon, 18 Sep 2023 22:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjIRWAV (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjIRWAV (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 18:00:21 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57FE83
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:15 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-690bccb0d8aso402622b3a.0
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695074415; x=1695679215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z90JPBUWGoZxkbMl+fIwchc9k0z1WvfExKiTDsySHxU=;
        b=hiADQrXOwVhsqL5uyaTYV4vHUys2aJrWZAiEwf9mAvyPgl+dUsEQ+pJr5UP301n+Xb
         EzgIXKnkNH2cnG+OzT+MXK1pZzMrqXoNxS0hup0PAShXuv8enBiVuDvOlZ0In7hv3VA9
         IlFEQgUE5FNVZQvMgi3R5OKhzHyFZnPn930NK8uyitufIqy9BDxl5q+O+IlvdSIwM8lI
         s54Sewd6Vk+hIyNd2RpEk6yiFxyEdPf5M8JAmAqkLyMewjtaDCZLbS81P00jDOjq0TF8
         rbb5giSPwJlTXRzOKkMHDUhCiiIikDS/9WckcU4/ilOWT2Mws2AULA2Mcyql7d4FuuZ7
         BC5Q==
X-Gm-Message-State: AOJu0Yy2JLKMPfMs2c/dXcP+yX5ffOMzJgL81WSWaCmnJH57SVupXcGU
        4GB+IKkRJXkRyxW7RSIkPwQ=
X-Google-Smtp-Source: AGHT+IHibteeNpdU5x3R+CyL3LbEnBcJ5A/Z2yl29fUetN0hJKf9X0qJ7oh2o2fWfUm1sImryFSMjg==
X-Received: by 2002:a05:6a21:47c6:b0:14d:8dbd:482 with SMTP id as6-20020a056a2147c600b0014d8dbd0482mr7685499pzc.35.1695074415130;
        Mon, 18 Sep 2023 15:00:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id fe20-20020a056a002f1400b00687dde8ae5dsm7514850pfb.154.2023.09.18.15.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 15:00:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] scsi: target: Remove linux-iscsi.org copyright statements
Date:   Mon, 18 Sep 2023 14:59:40 -0700
Message-ID: <20230918215941.2053109-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918215941.2053109-1-bvanassche@acm.org>
References: <20230918215941.2053109-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

According to https://www.copyright.gov/what-is-copyright/, copyright can
be owned by companies, organizations or people. A website cannot own
copyright. Remove the linux-iscsi.org copyright statements since these
duplicate the Rising Tide copyright statements.

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
 
