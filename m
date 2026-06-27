Received: from mail-lf1-f97.google.com (mail-lf1-f97.google.com [209.85.167.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFA38E5C4
	for <target-devel@vger.kernel.org>; Sat, 27 Jun 2026 05:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538972; cv=none; b=TR7AOXMu4ZlxOmhpptSFmJFAFIPEzHDNdDpMQFcG/hyiSb6ytt48QHv+feSOTnWLByPNm+tn5OUL1dvIWoFUowMMmePiJist83TRNRN0Ys/vTXkwVhntqbWGJ2uVdJpYSz0k5FwCaNPzk7EU31lfMLn6DT5ELJZHQVm7WJMMcLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538972; c=relaxed/simple;
	bh=DpRzB5nNneV2e7fuNOjzFT7N1hOW9bUMAuLBZOKGdKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVZ4NqIlLKVNPwSneX5lqZ1nc8MpfrMd6z65RjkwBruvrzKA/oaloINaMxs2S90V5lO8Ah/guzQ7Z4m2am3l5hfYL2NLhrghTLVKN7vRqJa1qYkLfOGrmER54e7gAnIqT8ZeEe1JMGvYgubYAELCVvXhFatIC5XCLRXg/UX8nLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Vp10ZeVx; arc=none smtp.client-ip=209.85.167.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Vp10ZeVx"
Received: by mail-lf1-f97.google.com with SMTP id 2adb3069b0e04-5aea9ee2611so33852e87.2
        for <target-devel@vger.kernel.org>; Fri, 26 Jun 2026 22:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538969; x=1783143769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hKeiCzbPRbTnzm/AI4vnqpxf3f5IT13bPWCisZ89M54=;
        b=Vp10ZeVx7XVjmbAa4vox2w1K6GM4lUTjADwmeyN+4UqJx+MZPzugyreZPc8U2Ctgio
         v5tpw7rg6Zx/CDa6Iv38SOVaCZF/OJlmr4I/TGiJ9YsSXvs5y6GM0NNxav49kVhFF6Bn
         uhpdI0oTu5vsSUey8FxUnpZE3CqiVDNop/ld1Oh6kh3tVO4FDD/fE1rXr5xHlIxzCsMD
         YXKwRRE5uBgk2CEzP2hCmg1R12sFaJiOs7pOzUZN3nCQ3t+1UwZSJeqdMttqSpyYfnPJ
         ceEUjhPFGaECYeyKPKIB4iA+v/+TwzmT+/Gg8J16fbQfnRlyTPs5XI5I4jO0BG54T40o
         yO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538969; x=1783143769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hKeiCzbPRbTnzm/AI4vnqpxf3f5IT13bPWCisZ89M54=;
        b=T/o0VUNVKebIb6NWTocx/rrt//wYfraZS840Y8cQdTMp68CsyMBgJNMDik+EaLK2X3
         T4PSei3BcPXDqkwmzEgT6GoQ5UTa/VjAx9pTI6DufL2jxLobQmLxity7wq17M+TCRZNl
         epzOl0OVcxQCczlKP/wb22pMf7wJwqB2cqAgYYTzFYBT/j0+L4wGqU+orIWTeS6L9qVG
         M57iV5si4N9i9YN3cnWRymBp5cowzLr+HFPdHh4QXKXUvkknohUsp7aJa0oOyWJSbUgU
         hxjY0u4GgdwdmVXdyacsv7aRG42MbbqdTEzbwR3sv8iXE8lZfijx3S2XMS3Y6Z/TCe4T
         eGjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqcv5CFdxMngkOM7lEMqZDTP5yy4EOlurst87hgrC9Q3tjMuP01aFtS4ewWt/nXGAHDiFVR7QR6J9o5CPw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQgFzF7D4BLc195+CXNYsCTPawHp7Mtem9K6WTpiEua9yUl/Z7
	qzt726lohWRmPVHhzVlxsgRx5xeGBW0+1QnjrpznmrSKcf4NgE1L9eT4ZyrrzWhrQSoJjNGhG9D
	xjI9qNOfp3eGTnktOJhnpQHsc3OG7lUcCMiuB
X-Gm-Gg: AfdE7ckiu8EsslkoD228vyV2akzUrTBQXmUZ/WZcx5cph/E62pp3uNoWPmgAYITz5os
	JbHyG0BVhOLwBIs6usSmT27RfTJVhLRFOmhc52tVjCeKLWipdsTFjIkSkThIfQgnEYDXT+RFzGA
	KHteeb7iJK+fZINRg8km7OsIfshsr2pGeMpY+0evYs2fhmx3FcIy3HimCdv35st4oufPNt+h9d7
	bBC7Z22vZHfVb61W6dKE6el29BzPjxmKEf7KS+jwepu3FRJQrD6N5rPBDzj5s7xiZdeOwJw7FSn
	SsRD07VAKl5UAdPOGDj+KGwMrmQ+JHBqUZNeJbEyo7d59wueRn5r7fjnVpPH5F++4XyMn8mJV8D
	P1jDpIWWYsyqxjm6/iCiRihvu1X5JW0WeVad8Ii3O4B0=
X-Received: by 2002:a05:651c:2224:b0:396:8491:3135 with SMTP id 38308e7fff4ca-39acb54fe16mr10822271fa.1.1782538969173;
        Fri, 26 Jun 2026 22:42:49 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 38308e7fff4ca-3999b1cf17bsm15732331fa.13.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:49 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (bond0.slc5-n17m28-k8s.dev.purestorage.com [IPv6:2620:125:9025:20::a31:41f])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id 73DC4402B3;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7161FE40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 2/5] blk-integrity: take u64 in bio_integrity_intervals()
Date: Fri, 26 Jun 2026 23:42:17 -0600
Message-ID: <20260627054220.2174166-3-csander@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260627054220.2174166-1-csander@purestorage.com>
References: <20260627054220.2174166-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To allow bio_integrity_intervals() to convert an absolute sector to an
absolute integrity interval, use u64 for its argument and return types.
Also use SECTOR_SHIFT instead of the magic constant 9.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blk-integrity.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index b1b530613c34..825d777c078b 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -64,23 +64,23 @@ queue_max_integrity_segments(const struct request_queue *q)
 {
 	return q->limits.max_integrity_segments;
 }
 
 /**
- * bio_integrity_intervals - Return number of integrity intervals for a bio
+ * bio_integrity_intervals - Convert sectors to integrity intervals
  * @bi:		blk_integrity profile for device
- * @sectors:	Size of the bio in 512-byte sectors
+ * @sectors:	Number of 512-byte sectors
  *
  * Description: The block layer calculates everything in 512 byte
  * sectors but integrity metadata is done in terms of the data integrity
  * interval size of the storage device.  Convert the block layer sectors
  * to the appropriate number of integrity intervals.
  */
-static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
-						   unsigned int sectors)
+static inline u64 bio_integrity_intervals(const struct blk_integrity *bi,
+					  u64 sectors)
 {
-	return sectors >> (bi->interval_exp - 9);
+	return sectors >> (bi->interval_exp - SECTOR_SHIFT);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
 					       unsigned int sectors)
 {
@@ -151,12 +151,12 @@ static inline unsigned short
 queue_max_integrity_segments(const struct request_queue *q)
 {
 	return 0;
 }
 
-static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
-						   unsigned int sectors)
+static inline u64 bio_integrity_intervals(const struct blk_integrity *bi,
+					  u64 sectors)
 {
 	return 0;
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
-- 
2.54.0

