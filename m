Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2B930C601
	for <target-devel@vger.kernel.org>; Fri,  3 Apr 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245284; cv=none; b=oAs0hEIRJBk58EbT51lNHxr0oTNRlGFtH+CGb0PW/GrZMuIdF9xUiXM5VxiCRK8Qg2wS2C2Bht9+BZcMO1BF5d9udbVOUXBuxaeb18RWM70bobIKEvrxt7NgHk2TctM6tIH4XutJlxL0J7l5YmKSWtnYvSLSgL9THW5QQo5/Bvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245284; c=relaxed/simple;
	bh=g5gsp0l2vOBOchC0OWlOg46KrJqq0NoVOVwDQTLaxVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR/gYKMNhJYmyibFJ1jaPI5Cw2DJDHQRDwREGeyQwWhVCfamaTaOUaOtycAP7EHc6n/8HVdU3tQumuJYdcuw+01sFqjoMgSPUFF0VfJb+PnxnrIoGNOgmAlZzKmdJr4/gzDkYuAs/ewQZRXbeRX7KHQ3MQYHzHzuDTv+68Lc2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FZ+HHEZm; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FZ+HHEZm"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-35d9986da48so363036a91.1
        for <target-devel@vger.kernel.org>; Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNpmXbw2grXDnIgg2ghLS/nTKNFvNfDaTGEvndg19+Q=;
        b=FZ+HHEZmKe39CxZXBdvhZjZZvmyhiwKr4sqy/hy2yNPxpJNrXZTtjEgbD8weSn/kQT
         +ba6GVCYxWJ0RCOtdKmm2TRnRxNJkyphLE6a2B5m1DANV/qrOV3jvIrLztgc3bN1BtS9
         KvTICym7qTWCE3RejXMYS+LhUkx+P0hjXmPq4M8NVWVKVxiNzvxyY4GdAdme6TQ8lcGb
         Xso/qNWc6/bM1sOhgCDcc8ta/QplEHO47FBQerY1gE16afCMBpRhAA5Da6b0KX34Eb1z
         HFTakOBDa2SrW9vqEQUUzbKA9BMaqKY3IOSh57jUrvVLedaT8kTi+XGZve817e1lf+UX
         IOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YNpmXbw2grXDnIgg2ghLS/nTKNFvNfDaTGEvndg19+Q=;
        b=EPF22B7gXAi11w0Wh6LKwpbPm8ZexfXkbMdXdxstGQgQizyQUxYIyzaUFxiCnap1Vg
         Mws1Gx08ufpqJ2Zi4mbUhWBCD/XlLG/ThrydspYgYMmFpPcP92ZN3Ph2xXRNqa0LEqV1
         8KXhtsJof9vUHtCLdkQpzxovVH7bDE3zjiIrMSLmF+m7IKHQRuR1S/JFuEuC0/iXUbie
         7LAXVqIkgTf8xl7533+ZwLf6Pp3Ptso8epCbBeu9jCWOI+eUnOYT3vxcRNJgLWV2jzF0
         c0nEIlzLY8FDhYFUuVrbBXZuhnKZpOsY795pNESUPloDczdfMIeHHDm2XMubEg/PXBLU
         uPfg==
X-Forwarded-Encrypted: i=1; AJvYcCWWw1tLNIKPJqjpvZO/WfPxiMMbwpq4nHAQbruprsBcGS+u2KEJuOzaWHGU8hGXnFA+3HW8NJi9yYsOQgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNT7GWC0cdJDtXHDvUrkHImUPtiNuojMtO3kZ8Q5iuAFaJwNEc
	3hI3uao1KafwXWZDggLnzW/4MiNXPb5tOhTE+ep+3RqNqzz4o6Amgl2x7ThJiKI1ddi+IjdSlxT
	APD3VPPYHE+5DEqtzRh0bd7lkhVmH8p08kRlmQZYuvajKuSikZZcz
X-Gm-Gg: AeBDieukGtStgfWouotgWSu9oRK7xDwT7NzXaPVM4T9qh1HIpWG30Gmk/WUPmRqXeZJ
	iI+pTvGeTPFGyYTFNt45AMGuNn4tBtZAXplN4c46eXudz6i28alz5Tw4dbWg/UFDc1cQiNJaMUe
	dHa4DvpPSoPxW7n9Ni2SOa/p73pWyto7ZzhEGVdsuzz+CrWSAZjc83pvYybczhLofED9skLtZeZ
	5rW7y6BcDD/ka0/CyuwV3hNa7Jqdbr23v7fBDcoxfmGaenmxFdvwKpxU0dLgUxyMJtROMBUVuip
	o3fs4o2vd7FhbzLoteHDl1SgoTW7kTAOtkwy4g0PCJM1enO2Gz+dG7FBa8NX9+F9esX1jvXhcuH
	jWWQLjaG7YfT2TnjHUcxXpqVrlWFRZizQpRHmHjQ=
X-Received: by 2002:a17:902:f70e:b0:2b0:ba60:7210 with SMTP id d9443c01a7336-2b28173d1f4mr25910015ad.1.1775245281579;
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b27493545fsm4944455ad.54.2026.04.03.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D7FEE34084D;
	Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id CE528E41AC2; Fri,  3 Apr 2026 13:41:20 -0600 (MDT)
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
Subject: [PATCH 2/6] block: use integrity interval instead of sector as seed
Date: Fri,  3 Apr 2026 13:41:05 -0600
Message-ID: <20260403194109.2255933-3-csander@purestorage.com>
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

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 3be91c4a3d09 ("block: Deprecate the use of the term sector in the context of block integrity")
Fixes: 63573e359d05 ("bio-integrity: Restore original iterator on verify stage")
---
 block/bio-integrity.c | 2 +-
 block/t10-pi.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index e79eaf047794..4be2cf649e54 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -104,11 +104,11 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 void bio_integrity_setup_default(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sector));
 
 	if (bi->csum_type) {
 		bip->bip_flags |= BIP_CHECK_GUARD;
 		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 			bip->bip_flags |= BIP_IP_CHECKSUM;
diff --git a/block/t10-pi.c b/block/t10-pi.c
index a19b4e102a83..36475369cd16 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -315,11 +315,11 @@ static blk_status_t blk_integrity_iterate(struct bio *bio,
 		.bip = bip,
 		.bi = bi,
 		.data_iter = *data_iter,
 		.prot_iter = bip->bip_iter,
 		.interval_remaining = 1 << bi->interval_exp,
-		.seed = data_iter->bi_sector,
+		.seed = bio_integrity_intervals(bi, data_iter->bi_sector),
 		.csum = 0,
 	};
 	blk_status_t ret = BLK_STS_OK;
 
 	while (iter.data_iter.bi_size && ret == BLK_STS_OK) {
-- 
2.45.2

