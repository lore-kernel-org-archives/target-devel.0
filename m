Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB9022FE1F
	for <target-devel@vger.kernel.org>; Mon,  7 Apr 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744019320; cv=none; b=SttsriNAUUd59yfjdz0b1ZwIJCGEbI/eeP7f08om+Lk9T8IU1OFtyCJmUCRtc22nFHSdhJys8vGWJG2YsIKB+peo6UYOJH1i+Y5F7G+ldfGHgjNjcV3LU6NEBeOo/J9NKlMG3DJ4YuG+m0WwmEdX6u5RNjCTrmZ/X2jENzZLjL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744019320; c=relaxed/simple;
	bh=OCft2ZaB8KRinqm7lbd9SCxq/oufiEqpYsCrHnLjcO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J17f7hnRGnFKWZlFnEGnWSvDFB0QDGHQlzLJINz/o3asu2tdc4UOoevxH1Jr7juc6pymmdHqFf9bv7GjDfDWN/sIpxS+mOnEkvc0BoTTOixoWer2qixKPuV+BBuUvo5KLFGkGJP44o8K66i9Qd59P1YjhfccRSN8/aflIJ5baNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lC6P47RC; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lC6P47RC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744019305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FpPprgCenUzvjf8AHGUz7rTCRGVZ109X7TG++VFSnGE=;
	b=lC6P47RC7FurlK373rzl5F79jlYjNqFgf3NP27vmJFiDMVGFwYprCyW/ygI7KPE/ymp6uJ
	iaAVavwrfuUi8QhyHL5MxULHpFgVt7YsEIUb+KaEN0sDxibG13a0mArilcnl7v1uPwJ5qx
	tkvXTnjjYMD4pPmqy7OVg94O48MUD+k=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: target: Remove unnecessary strscpy() size arguments
Date: Mon,  7 Apr 2025 11:47:52 +0200
Message-ID: <20250407094751.744379-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the destination buffer has a fixed length, strscpy() automatically
determines its size using sizeof() when the argument is omitted. This
makes the explicit sizeof() calls unnecessary - remove them.

Remove some unnecessary curly braces.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/target/target_core_configfs.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 66804bf1ee32..0904ecae253a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -673,12 +673,10 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
 		return ret;
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
-	if (flag) {
+	if (flag)
 		dev_set_t10_wwn_model_alias(dev);
-	} else {
-		strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
-			sizeof(dev->t10_wwn.model));
-	}
+	else
+		strscpy(dev->t10_wwn.model, dev->transport->inquiry_prod);
 	da->emulate_model_alias = flag;
 	return count;
 }
@@ -1433,7 +1431,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	ssize_t len;
 	ssize_t ret;
 
-	len = strscpy(buf, page, sizeof(buf));
+	len = strscpy(buf, page);
 	if (len > 0) {
 		/* Strip any newline added from userspace. */
 		stripped = strstrip(buf);
@@ -1464,7 +1462,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
-	strscpy(dev->t10_wwn.vendor, stripped, sizeof(dev->t10_wwn.vendor));
+	strscpy(dev->t10_wwn.vendor, stripped);
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
 		 " %s\n", dev->t10_wwn.vendor);
@@ -1489,7 +1487,7 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	ssize_t len;
 	ssize_t ret;
 
-	len = strscpy(buf, page, sizeof(buf));
+	len = strscpy(buf, page);
 	if (len > 0) {
 		/* Strip any newline added from userspace. */
 		stripped = strstrip(buf);
@@ -1520,7 +1518,7 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
-	strscpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
+	strscpy(dev->t10_wwn.model, stripped);
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
 		 dev->t10_wwn.model);
@@ -1545,7 +1543,7 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	ssize_t len;
 	ssize_t ret;
 
-	len = strscpy(buf, page, sizeof(buf));
+	len = strscpy(buf, page);
 	if (len > 0) {
 		/* Strip any newline added from userspace. */
 		stripped = strstrip(buf);
@@ -1576,7 +1574,7 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	}
 
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
-	strscpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revision));
+	strscpy(dev->t10_wwn.revision, stripped);
 
 	pr_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
 		 dev->t10_wwn.revision);
-- 
2.49.0

