Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B642DC789
	for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 01:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391069; cv=none; b=piOZdV8FnrP9lfHPh75K6sSR+Dd7+uKfERpkVrIwPONevL5Py8qj15x09D/H6AJk85fnZtHP/3qGnaVs6I9U6L3P/pzxbJhoFyWkLPKhhV/6xbewTPv9BsNwzVQ9KX0so+9AO8XCuGamygwC6b2mLAXQ3B00cjrqVkckpX/7Fx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391069; c=relaxed/simple;
	bh=fQjdv8zJMdZXPE3+o9HQjjjAYJQi9CMWVL/qH8XIuzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rv6LFiOpSBySmLT3c+F856iwB0E8P6suhoIgRgJlh35v2QRZgHnMLJyUzNJiSbvrD9g2A2UQPt57l2Jbp6bF5s4OBIcvRbjdhEmfj7KINtie8a13LD8ffsLZ5HFmi2dgnq+U5zP2cdMc7D4CLdhW4s14+iiUlnFlUNBuDfd7S3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZJZi3M08; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZJZi3M08"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-35e57611113so23111a91.0
        for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391061; x=1776995861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zj1lF3dU8n4YC5fdjZZVtRHMdHV4skYCpsqVKv3fQsI=;
        b=ZJZi3M08LetAVLNfc6qawM3q4dOy/laMdDch3I4DjL5dIjHTKFRadeu7F6qyJFYWbd
         aneZewcM1s+pCeJHWwskiTfXVwWsO5pfna9DU26vlIvVkmEXH/2UcuaBHwzrNphm6AsE
         Q1g/XjnXbnOKPAEQbCrEBP39MkaXprf+T7g87ie5VCutlfYLINmCfnBCgx9me79ZRMIa
         OlRHn46Q4+Jz9n8wBkCSdZlVv8GuZNRIDSb4NAgAU1eimCaJzkUkeTp2Ounkqjh4olxa
         Mot5BQ8BpM1H6FB1VW7pocA/Cnm4Z8GSq2n/mhKPlNobPgO7LwmDmLmDJNluJrLYDAMr
         B59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391061; x=1776995861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zj1lF3dU8n4YC5fdjZZVtRHMdHV4skYCpsqVKv3fQsI=;
        b=Hty1nlD9Z6nbNm3POON37Py5mXHTlMhza+BCldiIClYyH1bcFOT7imnHu9VzkiYkkh
         vrlHpQJHlWy1gQnKN1WZyazPSiBu1UdK9tYojSpxmMS26ynmtnskLkAmQTiPkHXlT1NA
         87vu0ui8NkYCpXhfIRLXD4L9o15U0ipZouzKBCM9k4lFCa3o1dRvU8xoEZX85KkqTV2n
         uUtqhJV7rEhA6m0pWMasH2NY1cyZ/DKR+aL6NFu3n0XKiKZBagBNJP/iuNM6AhaXXvvk
         fMFHYcgq2Z/p3jltofUyaoiQy4jOtyZ+b4H60vHaFhnOWxz/mn9+k5vo6GnxtOn6O2P4
         VU5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/4Prulw4RmNOhKBiEst4WirS5RdD7x6nM5309QlIY8Lz5XaMUOstUG10GXK5BqauI09Me/tesn8i1rJAY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqwf+8O5YzyQ1kXcVpL+R7KoI5N0AX/6/MnzzR7hncAW3SCkA4
	W6Mbdp5svut9JsHxwbWSa/Grp7UebWfLeyXHf4rO6OEsgwqNgRoF7kLry7F4MmYxY+CdpUK0R2n
	bKtF9bBJTNDPZX51RqQNbTDA13FUMcm+cc6ssa20JrpvwMiQSyvxZ
X-Gm-Gg: AeBDietvPjBdt8cE76OhIoCduPBYW+IKxSPi+2vYGv86UaUEsdHzsUwDbXzVJehJXMw
	5KZ3juMuDcnEupgWzXI1RioNN3MGN3RumhVTeq7b0JiN6lFz633svFcSF6yW4pYrDIKS5+8MOLY
	hIyIJxmfS5L6gdWr50Z6rZREX3mjSLIN8d8+Qxiyda1hiIq2nyPWguRdFDgWhiAz+PmlZDT4qXF
	n0uj/5JktSKIOjt6UI4FGgDv6+8PSa/1UtYTVmIpCu+sf4eYStJk15TFNaUe9CTNzzYrIfKx5aI
	rURqnWwTW2NwJElnogWj/m1P6Zfdd6+dFnvpB2PHQyBHXiqPHJxVK8teUbJ75cYSTnpq5Yw1AX7
	uPqkVHHzZB/YMQyAGFzHnm/LIV4+EKLdbZpLmkvDh5S3H59SI3g==
X-Received: by 2002:a17:903:3dd2:b0:2b2:57a0:9c08 with SMTP id d9443c01a7336-2b5f9f7bc49mr2795455ad.4.1776391060723;
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b5faae2378sm215195ad.25.2026.04.16.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 0333F340B52;
	Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id F3652E406BE; Thu, 16 Apr 2026 19:57:39 -0600 (MDT)
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
Subject: [PATCH v3 2/6] bio-integrity-fs: pass data iter to bio_integrity_verify()
Date: Thu, 16 Apr 2026 19:57:28 -0600
Message-ID: <20260417015732.2692434-3-csander@purestorage.com>
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

bio_integrity_verify() expects the passed struct bvec_iter to be an
iterator over bio data, not integrity. So construct a separate data
bvec_iter without the bio_integrity_bytes() conversion and pass it to
bio_integrity_verify() instead of bip_iter.

Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index acb1e5f270d2..0daa42d9ead7 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -53,21 +53,25 @@ EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
 
 int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct bvec_iter data_iter = {
+		.bi_sector	= sector,
+		.bi_size	= size,
+	};
 
 	/*
 	 * Reinitialize bip->bip_iter.
 	 *
 	 * This is for use in the submitter after the driver is done with the
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
 	bip->bip_iter.bi_sector = sector;
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
-	return blk_status_to_errno(bio_integrity_verify(bio, &bip->bip_iter));
+	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
 {
 	fs_bio_integrity_cache = kmem_cache_create("fs_bio_integrity",
-- 
2.45.2

