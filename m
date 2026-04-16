Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB571A6839
	for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298970; cv=none; b=HrGwN0uAq5LeuCTRSd3UhG11R9ta5HM8JUSDDU05sLUxDqomFnilODcotRYx9vdbWSuDHPSNv+vyXchKim/BL/nWfbFiUGDo6suw1KSRliyiq3cUj5OpUNI1HNDobw7WsV0ITw/Src1KZHgJAhqRtblH1r0WRqCZfw7QzgcOpsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298970; c=relaxed/simple;
	bh=OqvmwxPUynjDh5Tn3iMgPFDXoA/L2INxvr56NUjgkIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEER53VWPuPz8vX8nHmz4a9hnmYYbvO7ScuDDk3czxpseUtODnm1Yptx9UWWJhASl/M+UMXS7TGlhTGvtXfKZgImEC+8MN0E54s/sc9/dKtEfzyqs7uqVIXH6+kQyJ3Fq+g7eIhqy/cRQ5pD9QVDdwKgzgzdEsWyplYkKhlWwcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=UNsHozT1; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="UNsHozT1"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-35d9b4f93f0so1313250a91.3
        for <target-devel@vger.kernel.org>; Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyCXVkuEBYx6RuPx/hECYTdCdsu/oyGta5lJzqSGfU8=;
        b=UNsHozT1KlO2DwnCIh6jPeQ+TDp/CiNCzfZl4OGWY1NAbw0Qqf1tC8hL/KuwIpud22
         lhCBocSoB219FHkQMJKmua65/xMRnhuJch+ZH50amgT2p6FErj3sai1dKPujjfj7jcJo
         Y3wU6Mp19/assUTplr4q+6CSD+Abqodhu+Ytn1TKP1DcxI8JuQia+9IxfG35w4mY8hnZ
         rYgbV5MUZHpsDqRXNW8whyI7Yt7y1YwBpN0YiiM/ZhytMQ0JcgB/C9zBVS+AW+wo+SDO
         Og0rmfAgN+1+VWDUfD1eUs+H/5D5D5+8AeYFqfumi3cpgP3FvA0LFOoP8Vy5Gww2ruWj
         Th1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eyCXVkuEBYx6RuPx/hECYTdCdsu/oyGta5lJzqSGfU8=;
        b=qVO6Gz3+B8//URg2xe3Bs4Wbv4TNais8sqNRexzvqWekIP+WKRxVgR0WFlW1bU+cmP
         eJWHb6wsQVVdaV/wmGP06IggUoJLL1Q7GL1xDaVRT/HL+KwxWTlDNDq6tJa97+L97qjB
         AQmgVWJ2SjJUdWl35yXVwgkItHZyd65YGvK4QADTbcF9SWl4icgCUPhHeSQkW3xJIWYN
         MGcAC2vrqkQUI4V7QZpUFsBppJaGg8aqIlw5uLqTo0dRNV0w5Ev0f09i++Ktu8kDYwjW
         +5XqJHo+dvYz6y1/eCjTwir0BfJtNzaVsPAwJUrLf1BxZ0NiuddoSzfd01l0j6CiAD0l
         g7hg==
X-Forwarded-Encrypted: i=1; AFNElJ9JqALDEXQNrGf5nF0hAqF/CrEjc6Ut+ujbVcWX45ooiypc+8vgi6bQFTD/+/E3b6a4XO9w1Kn9lu+WsPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVjt5gnFIGRXSmit8qgVlYyJPcEY7p2iER4baeHaank9aaB0sB
	lMc5gtlZGAmQdfkYnvL6+UCfEeDNiyQRyrd18keE3DOv5pbLtxte4FYuuWVSpxIBnAZcxtdbpjJ
	N8gHpIfOsorF/XH5ifmbTjLoO65pqWdY/Xb/Q
X-Gm-Gg: AeBDieuvtdseZ+6V+aVgZRImxERbmpLdQZm729QjusMvhygL/Lfm7VKanUzFRCULYDn
	0Nc78KsbV0FA/qrfuOR+qImqVqOnrocPm5J4Qih8XSMJT8v4Oonuq3QLGkj1vkWmA3YDpjP7wp8
	KA/z2r8D5m4w+3cDvL+wwXaAibATH84IMSOck4w6v+0ZPUwQysJ+Zy8k+DvnV/xagdEhnmNWWpj
	u9hKyREdfw+YQ8C/tcYeVWjzlGxRLsBX2HF6tSVmILlhdKU6z4wIOoEUUUZDzT/nG37pQCpk1ni
	LGS6aMZ6opXfFXqNZkk93OVjnTpZJDZetl3qpCOsuIqN+cWR7250R7zQ839Jh9trDXg7kiXck7B
	CEr0013EtUwCqYitdNUFCIgYb5SPxQRHTQ7QhMMNxnE2VpS2QR3APZBWsQM/W0yM6
X-Received: by 2002:a17:902:d58c:b0:2b0:7041:63fc with SMTP id d9443c01a7336-2b5eda8b366mr2383085ad.7.1776298968060;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b4781301b8sm2399375ad.18.2026.04.15.17.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id AEDE23422C8;
	Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id A3C50E41B93; Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
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
Subject: [PATCH v2 3/6] blk-integrity: take u64 in bio_integrity_intervals()
Date: Wed, 15 Apr 2026 18:22:11 -0600
Message-ID: <20260416002214.2048150-4-csander@purestorage.com>
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

To allow bio_integrity_intervals() to convert an absolute sector to an
absolute integrity interval, use u64 for its argument and return types.
Also use SECTOR_SHIFT instead of the magic constant 9.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
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
2.45.2

