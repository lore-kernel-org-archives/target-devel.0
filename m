Received: from mail-oa1-f100.google.com (mail-oa1-f100.google.com [209.85.160.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5093D6491
	for <target-devel@vger.kernel.org>; Fri,  3 Apr 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245285; cv=none; b=NRL7tfJMasr+GCq1RXCA4XuBkmIceTJ+vgN4lahsmr96H3Y5t86TY+1+glt2HnzFzEcijUeM2Nj9xbhPQ2KB8yD1Z6HSGZ6/a+rnUFvUm7ahgU2xCUTV05PPoOHle6Bj34NYRV+QD6CXI3W57WKHZHcqK987FOrSIUYdlD8xyx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245285; c=relaxed/simple;
	bh=YYGrwQRz4CUpiS0HafIif2tS+tWh36dIqKCheejEgg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIRXbkF20GuyplWuRqs1+aB7hU97YWTyT382jLWwrLcBOVtwl2W2jiA2pvpj9S8uTlInBBvYeRIcb9JquQ0hMwh9rXOmXudylnmiWQ7wlvNwjwLuWAb/9GX3np02weApLmG4RWKKlLA0gFSeQhIL54QpswawjnEUzcf5QAajq/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=edYt1hND; arc=none smtp.client-ip=209.85.160.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="edYt1hND"
Received: by mail-oa1-f100.google.com with SMTP id 586e51a60fabf-415d7461fa5so130866fac.2
        for <target-devel@vger.kernel.org>; Fri, 03 Apr 2026 12:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775245282; x=1775850082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otX1Hqc0T9DvgqLYhcqiRNaRpAdPxblh5+E7UixGoPQ=;
        b=edYt1hNDxW0OYL+t0VGIvgcz9lgtpWhSdGkrNqD6MAGIbJlLEV2Zkj96at8Pq8uzJS
         OGWTPrIO+MmuobdFI++4h7RrDnFKtAW20d++l1nyyGwywqipRDIkeektWcyC4PA+X69L
         TUHYXuqomlQWPDRYYgZ3XoOYG/cHQLxZ1WcLgTpMglKqI2raIdmHSMVptMWq8dH7WBoC
         ZrI+G/isek5bv0yB1pbwzgMMbNx2qdteumh9lnEYBouU/V5WdhH75JXJ06XHAeZD8GiL
         5xeJwt/x0CbzM6xV60SrbfuhammflPrR2wU/TQDon4Dy1g5Ws9pBTSDZyTxtGTr7wRuK
         8f/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775245282; x=1775850082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otX1Hqc0T9DvgqLYhcqiRNaRpAdPxblh5+E7UixGoPQ=;
        b=MeY7szjxwTHSIMZbKbgOoyn7C0IsKE/uBFh4xOySmNabVp0aLRZWE+FrCOIspibo1J
         FBE9ZxmoqX9FJ0lIQOynNIxMmOCOYjdJ93vqo1T/v1bmV3Dk3ldpsfl5oKO1mIY0TYhk
         Erv6YPzHCDirTTkBGe8Xh6PaxBqrYiQfuGt1xMmHmGIaa9OAb2rwqekg5PejgeKfMHW9
         Hc2DJCLDwakMVEnl8i9F6hwFUnq+AOHcivsIrGuSFZIO1b4ooCB12/sL/o/1I43ZCDuj
         eF7FBgX7jjp/i91UispA12q1XQih/0LsTRWqCbcxu1f0rkLX+If2V5xAo+4k4as/NDSm
         r8fQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2EnqBzD8V7taj0AVWEWzwh+zgvhjHIE2/FOOif6T556htTAoc4NjnuUErl9ywSaF+YWyuymEF14J8VIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZUHQfbTp6+jcSS1hU0u+gZa1x+URyFg2IQZk7mHaMF/vACr4
	0iwc/Y4yomVn5BPYAH+4gaIG0ySYAzmFTAy7LmQVRtMFL8BL/lObSfXj8s1At2zHL3KyXfgZiMI
	QmBaxSnLx3t4IQSlwU39XbSrxvH7mCwJiXfxE
X-Gm-Gg: ATEYQzyG7hoI05Ib+lovWIyQwI1ISUqH1JJ/YhJX4lUtZI2Gy8vKreiYXrwp3fl1+jw
	jAtlnHGUrIVdFlHrlAR3eiM8JPraIPRPHP8VCOFkF83r2BnWDr1KH+mdY6LhcGjfGCmUx4nGLL1
	2E01ymxoRQWEHaGCiCzhwzJJj9S/A3xrfm+73cCnvbu+k3aCiCShiDlgGg9cur7sUa3m7nmNVfd
	2Y0EJFVzg2u7oN1pzMw3NZR14CSStq3crIf/r0+FQCfRJUuMXaHd3s/OinQJZFn5arHQVTg9A1z
	AFYQ9B7ZzfSiftO2VAG8S6bD5t6XkMv/LKxDEZQb9a7kGMAwOlNuHEd2EZc6siUoSBYeJSulUUP
	MiEPR4Vk6AeE1IAGFg8ySbI0pZj+aCewGFtQCJbdQBOxLl+HqZvMYVg==
X-Received: by 2002:a05:6830:25cc:b0:7d7:ce56:b93 with SMTP id 46e09a7af769-7dbb72f247cmr1794595a34.1.1775245281603;
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7dba72d7182sm505129a34.7.2026.04.03.12.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 12:41:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 31F7C3422E1;
	Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 27E8FE41AC2; Fri,  3 Apr 2026 13:41:21 -0600 (MDT)
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
Subject: [PATCH 4/6] bio-integrity-fs: use integrity interval instead of sector as seed
Date: Fri,  3 Apr 2026 13:41:07 -0600
Message-ID: <20260403194109.2255933-5-csander@purestorage.com>
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

bip_iter.bi_sector is meant to be in units of integrity intervals rather
than 512-byte sectors. bio_integrity_verify() doesn't actually use it
currently (it uses the passed in struct bvec_iter's bi_sector instead).
But let's set it to the expected value for consistency.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 block/bio-integrity-fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 389372803b38..5d1b0e33fc5f 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -62,11 +62,11 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 	 *
 	 * This is for use in the submitter after the driver is done with the
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
-	bip->bip_iter.bi_sector = sector;
+	bip->bip_iter.bi_sector = bio_integrity_intervals(bi, sector);
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
 	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
-- 
2.45.2

