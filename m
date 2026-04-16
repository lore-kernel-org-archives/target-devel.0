Received: from mail-dl1-f100.google.com (mail-dl1-f100.google.com [74.125.82.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8031B1AA1D2
	for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298971; cv=none; b=FCgFJH8zZBSPwEtR0QLniCKvDraVE905Cg+LrXhLIZGi+n6mm334TghR3dkqCgl8YVyTSLn95aaRC6IG5yHYxuk9ZryaHcT+upU97Ncsbna+eweCR8vY8q1XfnU7v3j1h5zx6xUfaXjjrZ6ZD/sv3bV7KQDDfkTCXLdcyPwoOlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298971; c=relaxed/simple;
	bh=D1sF5rCpyJ8v1Q/Gw4hLl9PjXnZwN2O7sQ73iHxyGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3xO2yergKKEkwApChX0SFQjFhMn9rmdBAOy16hA6fjzLtf7LuWiXHgdYNgsc119X5IM93vDeSqKbiVTu0YTgiUuuYniJ7uYMAKZ7o12ZOdpgz13icg8s88JGjWq7FBC1EsLDzNP+MA6txFig9KvTmHhDLkI7/XHDW+epZfvt2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z4gt3sjs; arc=none smtp.client-ip=74.125.82.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z4gt3sjs"
Received: by mail-dl1-f100.google.com with SMTP id a92af1059eb24-12736a0147cso568646c88.1
        for <target-devel@vger.kernel.org>; Wed, 15 Apr 2026 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=Z4gt3sjs7HJOg5E1Rhbzz43BV0kwY8dMsAmzdD/tuifVtfLydTShtX2/qQmkGD3T30
         9Nnejmw1T9pK1E5ePw9Cj15I1zEzIiHzYpKTzMII6xi5ndDVrX/DruADAvAizl+iWQaQ
         ciaZEKelqJn9pWp3JyMSyDQvBAC18BdebOUSEB1ULtYpfJcXVxxvnxtEUWoLEjmYOpbR
         L0WDu0VGPzQp3zVukilu42+UvgbPmy2qu7pverMeEWb3Cz7zvxGrhuYoesL8TltK6EjF
         yWcHkQLPInhgMqX9I3o5OGltw2TWgrzLOv+7RUcZufkaVJxHoxpzg6FeQiJJnSBEJOfb
         DwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ePLDDsMaoT6WX22t4kx7uDAhAvj4BaoTe7M9oy5w3tM=;
        b=iSZt7hiaEeYf2vAK59ExQa15mmx7QrHGn3Tc63Kp/yeo3lyuNH+oBXjz58+r0U0hzP
         N4Z3GXJUM3UvCPwy4aItfH1bNN/0Lt2aLrONIyDiOooH0UdLE4VnKJirneJJUjzRTBug
         C0RDZkE8smnS/qeE/C5shW6goRQNl03YecqKMuT9n7p9T3DFjhy07VlScyx7ZIlDAcQd
         UHXZBz9YUXtCe6sgQlZLn7y2nhVQHyDKerf1fR0Hd3XFQxsJkaWJ6wI7a9aJfiKbuzMw
         M85fok3yH54axysPTT94qd1AycTotQlE5TXB/nD5OxE6tyUDK+QQYl2vFqdXH0s3YxXi
         1tKw==
X-Forwarded-Encrypted: i=1; AFNElJ9pDg9kZ0k43IMOevrABM0cy/k/2H+QN9CQmc4LqIhZDs5c1mQLYl9X69uxUAtyzFHYD4ER5kOR1ibvFts=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAvL663er/QNXDiPw/11McrcXWCCz9P07sLMFLX/ENvN9s0JV4
	GkXK8yEFskZfJuFCDkzznQrDr3dcxslCEDfD6us/F+HZbuQVpnbrUOXr/+MjC2PP1mOLsT5fY4A
	6C8Hq4Yx+9Phuz6gley1tkfc0vdDtI/Jmyg1lSVeN/uGcZnaylzNx
X-Gm-Gg: AeBDievVJLnvHg9YerHiJ+wPDmz2C7MadiqbaLyL/jYl9mzLUjvN4Stl3zJF5RFnBgC
	FCiAJolmlKru0W3a4N+PfeTxSvlMk0IZRaKlkogD62hOuHIF09BQ0PztSA53SPqwkKlCdz0rmFp
	u0A9B+ha6GWRmANgznBQxatjc+4c5C0V2Nis2npK1bsHHbdH9qdDQvL0ZlIaEHqJkbnjs+Bf6so
	zKhrfKFeJSbY5xSnyXVdG+m7rFVK09n8Ptr8fAGyIVZfi7C7vcOA/kwuYLUoLeMw+Ba4wJIWfrp
	bPTtx1vZ3HVdPxwsfGxAHu4g/hl+MQbKARHtqe34UlFZzwpJWr4TF77T3VyO7W4p7ezgHE23Gd5
	wFEjm8Rc85a71B4KlkKm82eeURYFr9uk4egqDWPJmcBX2GQZWaA==
X-Received: by 2002:a05:7300:ac81:b0:2d5:9438:2a02 with SMTP id 5a478bee46e88-2e17d815b51mr60486eec.1.1776298968089;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2de8ea899b9sm240344eec.18.2026.04.15.17.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 49AC33405AE;
	Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3F4A0E41B93; Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
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
Subject: [PATCH v2 5/6] t10-pi: use bio_integrity_intervals() helper
Date: Wed, 15 Apr 2026 18:22:13 -0600
Message-ID: <20260416002214.2048150-6-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260416002214.2048150-1-csander@purestorage.com>
References: <20260416002214.2048150-1-csander@purestorage.com>
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
2.45.2

