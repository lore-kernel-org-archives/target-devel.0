Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7EDC433E9
	for <target-devel@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6AF64F3C
	for <target-devel@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCQJN2 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhCQJNR (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 05:13:17 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FBEC06175F
        for <target-devel@vger.kernel.org>; Wed, 17 Mar 2021 02:13:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so1013804wrd.1
        for <target-devel@vger.kernel.org>; Wed, 17 Mar 2021 02:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vbchzHiCvuybExCdVEvNdwmkJDXghXDN62HPrZ8RY5o=;
        b=c+MHb1JQmfOXLDV+3WNH4O28BETw2lg0J/MTZ4AxVEqcxNEkyvb1/0GvTJoY9jbaHQ
         mGRlki8xCC2lbvr7VJK3gfJfAzG11KyjxUQS/d8wv5Y6k/hYiorMwF7zIEXdykm7Yiq9
         IOLE/HHhZXw8zg/3K34Abk9Girs63O3H8tobZKe1jaj6aDfbXJQ7VIbdasc1wYgP/qEb
         bkqwZeFQMQ2Wl8xXFAWrZ1yymbORIzjB35OfgA3DBQkFtOQXT+3DyRFLPmUS4Bt99rzw
         LvMVAyNK2pdPCb5gIjmoTo+ytglgomWYrPt75ZgQiugft2u6eu5INCug6q0fP+ipTmyO
         KaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vbchzHiCvuybExCdVEvNdwmkJDXghXDN62HPrZ8RY5o=;
        b=gSTHkCsvSiCA7HeQ6kMQq/5s3xKf2lY5P9ZCJXP1EgEAhfZ/pk0zb2dHtW+JvHneH+
         Wk9ZWYb9NQwwi1l8pjSXffa59Tgi2oZ3nIBzH3k/Apzo8v0UQxHZvJncccKUwjyUA2o3
         URj2ssoSHcTmEPkLZ6CEyb93H9R48T4VqTVMkl9kfI8ymXul5IVKMYKk7DRpTCJTKu6X
         i0zx2YLUWfoWzfQnONmLtW/3k3SQKHWaTmL3JNaE8Sa4PBUHOJH4NsIaHVkva0iGz/tW
         RwKyezQGa+JvcLLtcYl5tF9er1AWSF/9MTSJYaD2bLApoW2o3N01R3ZketF2USiFh5IZ
         hUhg==
X-Gm-Message-State: AOAM532ER/vOex9JzhKnzT0oAwTR0uRHDCrPt91WxsD0bkEUEhIkeVmL
        5yybuGrbBKqJYROerQEAwk2tug==
X-Google-Smtp-Source: ABdhPJwDbrsb4UQMLL0mRYdouDzxdsekpPMAQLftKnrUTc6dcOZm4Ge7DdcbnNX5ybF2uM2jUh4thw==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr3452780wrs.98.1615972395408;
        Wed, 17 Mar 2021 02:13:15 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dave Boutcher <boutcher@us.ibm.com>,
        Santiago Leon <santil@us.ibm.com>, Linda Xie <lxie@us.ibm.com>,
        FUJITA Tomonori <tomof@acm.org>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 35/36] scsi: ibmvscsi_tgt: ibmvscsi_tgt: Remove duplicate section 'NOTE'
Date:   Wed, 17 Mar 2021 09:12:29 +0000
Message-Id: <20210317091230.2912389-36-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:136: warning: duplicate section name 'NOTE'

Cc: Michael Cyr <mikecyr@linux.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dave Boutcher <boutcher@us.ibm.com>
Cc: Santiago Leon <santil@us.ibm.com>
Cc: Linda Xie <lxie@us.ibm.com>
Cc: FUJITA Tomonori <tomof@acm.org>
Cc: "Nicholas A. Bellinger" <nab@kernel.org>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index b65d50d03428a..41ac9477df7ad 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -128,10 +128,10 @@ static bool connection_broken(struct scsi_info *vscsi)
  * This function calls h_free_q then frees the interrupt bit etc.
  * It must release the lock before doing so because of the time it can take
  * for h_free_crq in PHYP
- * NOTE: the caller must make sure that state and or flags will prevent
- *	 interrupt handler from scheduling work.
- * NOTE: anyone calling this function may need to set the CRQ_CLOSED flag
- *	 we can't do it here, because we don't have the lock
+ * NOTE: * the caller must make sure that state and or flags will prevent
+ *	   interrupt handler from scheduling work.
+ *       * anyone calling this function may need to set the CRQ_CLOSED flag
+ *	   we can't do it here, because we don't have the lock
  *
  * EXECUTION ENVIRONMENT:
  *	Process level
-- 
2.27.0

