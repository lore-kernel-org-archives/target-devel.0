Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5B2D7DF8
	for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 01:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391069; cv=none; b=SxJPaDb09D7nBUjHKvb//JRRRONpLufZonVUf0EqNNy+G0Sg+mmFLMem/1sLsNUI+KMEWuEbUigjtw6+Cc/rZwFIya3T3oKKc8HKUQrIi0tjRRmM2rk+Dp7YY7u0Ss6PUnexboYj0Dv366TXtdxvPnD4wjhqRgHUcsqlyox2mcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391069; c=relaxed/simple;
	bh=ohy1wVq/S70Vz7N/CvoXP+q1xaLNMz098vhZKOg7jwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tShgzooW4YG3+0DBKh3sh6fI4jNMsBXjJrTWzy4KVFd+p3T6J2BwfUlUeWufy0KXvoYLDCoQq0ehh8IKAOzG1Ys0kGWtPl63CP1UtLt6dMBLKn9IFQZ9Qxef3uGVZUvQWvBnn2/HrsNTG8iQm0DxCAHOp4uZSqz38UyyQ91se5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JiCEr8me; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JiCEr8me"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-823be54d49cso22452b3a.3
        for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391060; x=1776995860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9pyvtNYah5iCr5GskErP9n/SMj5zNsqkI2O6P5JyAY=;
        b=JiCEr8meVletjSYNPVhWU0BNb5lHci4nAGEo1unYXQZakhLH8zwfuRyZy1DhKj1Xpg
         TD9ZoLvoSZ3sSgBWLTw3sDFJ2OCrudYfBwo7leWFDh4T6tTjDzE+GrWFCfVc5d6uEwVq
         0F/VtbZF9PT/+KY+t84yCR8O+QdvR5umPX8GPMhOOMvYu6yYE+YL6cS9I1OutNfk53Qf
         e1qz8QmFuWjxwubDjbaZHstzUZo6vcwdG5fF/XYx+YsUiXBHwSQ9NYyN3r7D6sBvV9X+
         0O9smbqZx1mFRdQIYRMrq7eV/U7yketg9Mvlx8VQZrV+YVKZKTi0mcxt+Lqa8+xwN33V
         dpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391060; x=1776995860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i9pyvtNYah5iCr5GskErP9n/SMj5zNsqkI2O6P5JyAY=;
        b=CVdhOUQ7Tli3lE5bf3fz0kyuNMun52KH1SKPiJ+3o1uLxK2m2gVOCRQDkwlrokN1k8
         lcyPqg83KqcuESoL1Kb935mxmIv4JJIU788vVtHh9uHvqLdZoOoB1Z9QeZ6FEk1TR4w8
         rhdNg7ktGl+ofoqeia5lqd+zvgTAWnJAh++Wo1qwzihoTuHtUgnk4o4jJ1zSk6mjkQvh
         VvldU7/JLA0mfYybXbjodkcvy3T8ocrDuJprwd/86kvYkc4bTyX0i2lEu2gmw0+YUaYa
         e8NMHt70M7uzfS6N4zS0F5lwTX8lbc/qOkUODGKVdzQxSEYmvkitBHjZACgL40g4ipXq
         nvag==
X-Forwarded-Encrypted: i=1; AFNElJ8Y1P0wRtjVfL+9T0b2IwjHv7VsXz/Mnns5r7V7dYuck3AyDatl1xe0ZcvfCGpfldS5Z3Bbz/1PsCp2Tjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ4eOqzYoReAolnL0rgv+EZKWyA8T+Ii4jkqQebsBUbBbqPk09
	8PHjdrnuedcBCTKcb/hULFaKXxOpXMwhQQL1agBRkuPHfnapzBVNTrxmceKPjLt0suJxYmjnRP4
	LF5ZsllOfJnBBzL2SkWdTxBJSwsZz3nlGdiV2ckX6ksysz+F+qx+u
X-Gm-Gg: AeBDieumA85FLF7wYJVgEaKty/v1BIdoATYaJR6y7tXA0hNAiDQ9kr3SByJfFlSA7zM
	gNygzISWxYM6IrMTLlJbHzCi+9kBNhVoWgycjbYP1HpbKXvh0e/OVEvsFZViYsvJGDS+T9U7KOS
	8eOScfZxvwfkt+7BVRQl/4sbChozVqeAB7PAqtm2S+7+DG5Hl/6kbCehQxSY1BJqlkta9QevXtt
	Kb5A7dX3G4Eyb+Xwodh/ig/GAm/BQcyfPzSLAfhUJ355rPj65qmZ3xT5EuAlWcvRb2LjRgHdmGj
	Xo6hXw5fq/Pr9qQfaeu/RxQvBoU5qt9pj6TaFITW0DKgNNw+z+UI0FaiODRe2c1795PYhlmzweF
	2FQUNtk/GEMYCCyEEwmi9oId8mKRz2Y9+d+7g/zG46qZ899bqRA==
X-Received: by 2002:a17:903:3b88:b0:2b2:ac6f:104b with SMTP id d9443c01a7336-2b5f9e79f5bmr4284705ad.1.1776391060519;
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b5faaf81b5sm203705ad.40.2026.04.16.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D6079340796;
	Thu, 16 Apr 2026 19:57:39 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id D2633E406BE; Thu, 16 Apr 2026 19:57:39 -0600 (MDT)
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
Subject: [PATCH v3 1/6] block: use integrity interval instead of sector as seed
Date: Thu, 16 Apr 2026 19:57:27 -0600
Message-ID: <20260417015732.2692434-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260417015732.2692434-1-csander@purestorage.com>
References: <20260417015732.2692434-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_integrity_setup_default() and blk_integrity_iterate() set the
integrity seed (initial reference tag) to the absolute address in the
block device in units of 512-byte sectors. The seed is correctly
incremented/decremented in units of integrity intervals in
bio_integrity_map_iter(), bio_integrity_advance(), and
blk_integrity_interval(). As a result, the ref tag written or read to a
particular integrity interval on a block device with integrity interval
size > 512 bytes varies with the starting offset of the read/write.

Convert the initial seed to units of integrity intervals so a consistent
ref tag is used for each integrity interval.

Fixes: 3be91c4a3d09 ("block: Deprecate the use of the term sector in the context of block integrity")
Fixes: 63573e359d05 ("bio-integrity: Restore original iterator on verify stage")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 3 ++-
 block/t10-pi.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e79eaf047794..3ad6a6799f17 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -103,12 +103,13 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 
 void bio_integrity_setup_default(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	u64 seed = bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR_SHIFT);
 
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	bip_set_seed(bip, seed);
 
 	if (bi->csum_type) {
 		bip->bip_flags |= BIP_CHECK_GUARD;
 		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 			bip->bip_flags |= BIP_IP_CHECKSUM;
diff --git a/block/t10-pi.c b/block/t10-pi.c
index a19b4e102a83..e58d5eb6cefb 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -308,18 +308,19 @@ static blk_status_t blk_integrity_iterate(struct bio *bio,
 					  struct bvec_iter *data_iter,
 					  bool verify)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	u64 seed = data_iter->bi_sector >> (bi->interval_exp - SECTOR_SHIFT);
 	struct blk_integrity_iter iter = {
 		.bio = bio,
 		.bip = bip,
 		.bi = bi,
 		.data_iter = *data_iter,
 		.prot_iter = bip->bip_iter,
 		.interval_remaining = 1 << bi->interval_exp,
-		.seed = data_iter->bi_sector,
+		.seed = seed,
 		.csum = 0,
 	};
 	blk_status_t ret = BLK_STS_OK;
 
 	while (iter.data_iter.bi_size && ret == BLK_STS_OK) {
-- 
2.45.2

