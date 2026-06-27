Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB48373BF2
	for <target-devel@vger.kernel.org>; Sat, 27 Jun 2026 05:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782538969; cv=none; b=IpaYpPK1iWXRCjfYKiuPAwbla8WGI1V6r1gx5kiGgaEQvnf8zFBPA7MlZLfZvcKnMtluWGUnsdupwPou+nCMepiG3NSG7+AjJhbRurN9DiV0PCu9tjcrgGKhfRUr1irYForQNyRDcJudFHm9qq56B0crzPLcIcJUPl2QMSKu5N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782538969; c=relaxed/simple;
	bh=9h7ZEz78Y6ScMBC88C8RHAAfRQ3ckL8zd/zOxP8SyRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3jJqrMp7evBgL157yn2TY/KPnORUgc4hd78U1Wmojz0V5rD/plcNLtoJyy307eAbgTyjlWdvGoik57XJH1LvZIFhbQEvmeSSQdUoZf1AMrnVxMYI2P2nb7cJPTjdmkm1T2GW1nGJRi6ZhUgAAEuH91Ctb61mLIp6EOg1A7QNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KHBEvlsj; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KHBEvlsj"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-37c9d82cd8bso130294a91.1
        for <target-devel@vger.kernel.org>; Fri, 26 Jun 2026 22:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782538968; x=1783143768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hJetzVCmipfxkIYaKGKmSSwqDl0tCRIuzU++fp89zak=;
        b=KHBEvlsj0AlvZ3tbCDrQwsZVc7TatkU9GOkSwpfGbO6ZlT7v47ERnBptLAwtNjVMkC
         FloXWLYQ5bZYXN4gT0GojAmmpnsCSj1JoagXyfDPT3NWx7yq5Yp+T7UARxJqe/PL5ZqK
         5cQEjxpvCo5ny9jhyMTfTGmLyUQwsgEeL7w8EYXIIYRt/FA0E2K1n46ZcqGqoqBJXZRI
         PebI0CRJQ0f7JXr7s2ZF9lUnsQkhhY+x2gmBaJ/HcQf0Z1CO54ldWHHxzeJs0SrQ5Ype
         LHXchCqaeS2w+gCrrYDXFmfDK+IeAjBKVUnJtPm0fJ3qD3LTgFSiEjIVJhYvJWDnAP/g
         esXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782538968; x=1783143768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hJetzVCmipfxkIYaKGKmSSwqDl0tCRIuzU++fp89zak=;
        b=YCrzmsNstzyVB4cv+UEPTwOdaFB1xaXBzP9Fj4nhvHDbL0pqBGCbR4kLxKTXBwl8jY
         byMUYxB3Bg5tReiOuubvXRH3NrU4rxzUngR3DdaFSycte1lTLa2aFD8HQQ3Vv71hh+7k
         a3aH8ZCT8/hZkrI6k1jX86SwdYUEzYzvvlQpIdjKWDyPeJMOhFk+pxWKKsP7mKve+NvU
         TlBQAHD8CsMGv5+vcMtJQOSKkh8k9xSIlm2dl5rQTb+m1mk469Ql+N5wQi1faJh591ml
         pU/JqZRRA9ffV4HMoAwP6eBYO3+WKme+rtSK4aGqgFyu3dTbJtpdOPONN+q+c3m/Ru/b
         v3gw==
X-Forwarded-Encrypted: i=1; AHgh+Rq5chqHW/cNtNrrNMev6ino8df2Av5lwttow1CyDpMP0wJUfwSTb1sn0ehTlswH5CxYIMls3gheX182eV8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9tjtaQnlq02ZcalNHmwN2FJZ7El51NKKbb/MZPYpX61zV9PP8
	KMRXbhOfQcXRz4DB4SpJNP6cyKVnl0YEL0laW9sIyGkVHDsJp+375EGrWEJPbhIvOuM/VkYGo6m
	r0ZihCuTg7BL9+KmA1I32MJg7Zr9XrUoPuHkav83TPqoRD/rVp34n
X-Gm-Gg: AfdE7cmmBmXYYomiKcY+UsnP2YtVdsCZ4JO712QaI7C66Niuc6QwKgpJvTRXuGtpkoP
	IqvldtuzjaKdjQl02ZRXSHJlnrvGspJshTxm/ObUrbHIx6K7ZErf0UFyyEIm6jzQsgYIwQDTYhj
	oulgPMqfNdCs5DybGzG2+wRabXnW3Psl427w9xba+fA1Fr9nNYJW2V19L43nEcOv5eAlPSG3cym
	pantcWIG0z87Hnx8vh7ryXe0YLHcFrQVa6bEoNMUCWbw56glYfX3I/Rik3R7SMPgz0o+CLzG0dO
	LR2/xugXsWEZIUAAGo+CinJgrJDoEIwRzSa69PdLGuh11ZX/UCrKLAfVC9Atw8B/2r9V1Ijn0bv
	16XUYrGdAoIbEPQkzOdr6XNybCxRH
X-Received: by 2002:a17:90b:53c3:b0:36b:9231:9718 with SMTP id 98e67ed59e1d1-37dfa2c9951mr5148619a91.6.1782538967568;
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([2620:125:9017:12:36:3:6:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-37df39562besm848289a91.1.2026.06.26.22.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 22:42:47 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.12.104])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id E8FAD402B5;
	Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E6AE6E40712; Fri, 26 Jun 2026 23:42:46 -0600 (MDT)
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
Subject: [PATCH v4 4/5] t10-pi: use bio_integrity_intervals() helper
Date: Fri, 26 Jun 2026 23:42:19 -0600
Message-ID: <20260627054220.2174166-5-csander@purestorage.com>
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

Use bio_integrity_intervals() to convert blk_rq_pos(rq) to integrity
intervals to reduce code duplication.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/t10-pi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/t10-pi.c b/block/t10-pi.c
index e58d5eb6cefb..787950dec50a 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -541,11 +541,11 @@ static void __blk_reftag_remap(struct bio *bio, struct blk_integrity *bi,
 
 static void blk_integrity_remap(struct request *rq, unsigned int nr_bytes,
 				bool prep)
 {
 	struct blk_integrity *bi = &rq->q->limits.integrity;
-	u64 ref = blk_rq_pos(rq) >> (bi->interval_exp - SECTOR_SHIFT);
+	u64 ref = bio_integrity_intervals(bi, blk_rq_pos(rq));
 	unsigned intervals = nr_bytes >> bi->interval_exp;
 	struct bio *bio;
 
 	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
 		return;
-- 
2.54.0

