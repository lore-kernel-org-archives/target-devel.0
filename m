Received: from mail-dy1-f227.google.com (mail-dy1-f227.google.com [74.125.82.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB71C3537FA
	for <target-devel@vger.kernel.org>; Fri,  3 Apr 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245287; cv=none; b=EuwcHFFzZj1ffeREiD/6pCXOX+7iPLwZ2B2p7Et68+JxJOkPTFq6Cs7+auapb2ib9xmlZYB0Z0LmSZhQUErQPlxO7PnIN1a7UMjGZLEP1+HVmdSc7srjxN7GCIFRLU5XTTTgve7xu9/JyrI4PNuQs5FwN+OhWxldpAfIcUVS5l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245287; c=relaxed/simple;
	bh=dXB9nsSEQr0UD6HILmUJ3dO6tL18AphRTyOEKOREPnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oECO06PqFRMXgZ7GHyjcuGE8mW8SkaGGgFL0qDes0K+30VQc2fP3bYgcL3J+RRcf63fDOivVC9sprkKwIRAWsDxiuImz+iBBQUEYEgyFFQ5SFXARzEW4DY6ZEkOK6vlfdbIN60YriNXC/Azz4UAEElquCip1EHcekXVDDNdso9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JvULn3uO; arc=none smtp.client-ip=74.125.82.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JvULn3uO"
Received: by mail-dy1-f227.google.com with SMTP id 5a478bee46e88-2c98928e4bfso206519eec.2
        for <target-devel@vger.kernel.org>; Fri, 03 Apr 2026 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7Uy8gUL8icrsg5BG6MoYGthlOT8yOCeEWU7Db5146I=;
        b=JvULn3uOwkKUaQaHqiJT+f+UAp8ILB924uzwY7yoeg21GuaTAkNMfn7WUgSTmCkyyC
         smp36/0PpdPHWDotyaAGL/JbIpK+JlJaBVTYquHkH154ucK+3pSS95gCSapl3kKo9uf4
         CwKtYFWipRUDso/ZR6Q+7MeTxbp66XDGH5FaEwhIQQf5KAHfzO4HRx5Ch2hcidmiMls7
         wASCAkOrzJBIOCxCNniqYnNrUCX2PDkSp054MqK0XYeRm+Mhy60OSUv9gYlxEKXOSt89
         AFrDjNx/epWcUHg7nLd6JKf0zEH5JSKt8eVcdbCrM6HrP6YF+DCiIQzbi/HLtM+sOnOx
         w5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i7Uy8gUL8icrsg5BG6MoYGthlOT8yOCeEWU7Db5146I=;
        b=nzgjZhvTzPG/MUSOzat/OEAFfS5LyOxpBOGXisxVS6ZLXLovrbgKI+Ruu/TDkTHYyl
         fCZE8zFdKca/6iZ/5hoydxWsjsPcTC6CCT6dO7wZFFCXothld8lhmfpck56+M9nUShiw
         ieeHMyiESCveFOEgYzfP0yrvnNj0i1DT9evbbSDNRJS9YQVf41EclavQDO7vXFviBvTc
         xBjtYhSrmUHIS/jpuR1QWRESp9tOLZGe8YAKEGO43g7R5t19iQzva8I7IyQoWuUrYVB/
         4m6eVG+tY1TuY4OB2+mgjb5Qkc2+bnYHwlM/gaj5/pW3vU+QZmhYp/esymAe4FqlYK2C
         HMCw==
X-Forwarded-Encrypted: i=1; AJvYcCV919N2aQBJEGObiK1oKU8NnXMH+pYXbxdlB5PoBvPopRR1W1QIHwlVCU1lmpyshUlJOE2G00rV1WgRlGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRGMKuF5iRg3fGN9TGaoAA7iwF5l+bJIkk9ABD9KUyk2c9OemJ
	Ynnj8Xjd0NPw5LBgdSpL2l5FHfeaQ7fLTJZb8xLDPega8WuA7ydaT5LmHT5+a1BCfOEj+xp8G/6
	4pnrggnEgI8ek7qyoMZZhYZ/s5jMcv7WUiKnV
X-Gm-Gg: AeBDiet7opoW967fXSz7ME9A45SR2gmoM+TwmxYHrJJMK814YPQ30sPoyTW1Rb5D39V
	Kis1YZidNVNyGuwbGZrTO/9GlUjsXllMEnkjTmHHbt8VLIAKkqOrflQ7bR8v9Wryts3wJm13cnz
	HdtO+CxFq8WFRTOYl6+4iH2Tg1L2PmF61s6k3tmWOHzDojRxueYk1J1M6s/lkSPKIEzziVjdnBn
	qnHDngAQuD3j7j2tJJaH/cdbIMN/ea0tyoVA8ADdfFs5y0fYPz1XbAZD2vsD7w14FBo/sR4TxBk
	LOjoP8lwuWIkHjC9WC3+y+D96401IPWic5xOOkfgJKkUt+7oTUTa6ZnKkwNZuhf1aADg2eaDLkc
	xVmDay4gO+5lkSjsTHS7WdjPgzL6gW+/5PoZZnYs9tKUqA9rawwdq5A==
X-Received: by 2002:a05:7301:6093:b0:2c0:c55c:156f with SMTP id 5a478bee46e88-2cbfbc82969mr870935eec.4.1775245282274;
        Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2cb61750eb8sm339741eec.29.2026.04.03.12.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 7623D34014E;
	Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 6CCCEE41AC2; Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 6/6] target: use bio_integrity_intervals() helper
Date: Fri,  3 Apr 2026 13:41:09 -0600
Message-ID: <20260403194109.2255933-7-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260403194109.2255933-1-csander@purestorage.com>
References: <20260403194109.2255933-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bio_integrity_intervals() to convert bio->bi_iter.bi_sector to
integrity intervals to reduce code duplication. Make the same change in
the nvmet code that appears to have been copied from the target code.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/nvme/target/io-cmd-bdev.c   | 3 +--
 drivers/target/target_core_iblock.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index f2d9e8901df4..dcf273360015 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -218,12 +218,11 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-		     (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
 	while (resid > 0 && sg_miter_next(miter)) {
 		len = min_t(size_t, miter->length, resid);
 		rc = bio_integrity_add_page(bio, miter->page, len,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1087d1d17c36..434ef2b0b120 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -706,12 +706,11 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
 	/* virtual start sector must be in integrity interval units */
-	bip_set_seed(bip, bio->bi_iter.bi_sector >>
-				  (bi->interval_exp - SECTOR_SHIFT));
+	bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bio_integrity_bytes(bi, bio_sectors(bio));
-- 
2.45.2

