Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA9C2C3252
	for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 01:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391071; cv=none; b=nV06VW6Daz/0+cmBLTWnWzwMuJdb+qAgQMg9MAMa5yE8+F56yya7a6lYdkCxVuT5PHF7zjH/+3BLgwFP5lrjga+9+nFRYJujQ31kP77mIb4VLAtmuIK9OmM9ogMiqchKRIU9VU2TNU4QvBFN4t6w8d4XsBU7b2KJ0OlJaVJLU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391071; c=relaxed/simple;
	bh=fhgMAHy09LsI1L6bahd3pmbOSSyNApfMWjie8uHGN74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNtZEIJX+BsIS0H7J/nsf82epq0JU0rsr9L9toVm+0ZcDATznSaUaqqEkQygm4VUqvUY1PmmVUZ8nKR5B6FeeyCfSOmLZirTNEcUiiudP3Zz3vkIpdFLCx6KBR+rcXY7xAqOaDHuyRXFE0PmG/0HwdHCue5avCo1gt5qU4DPxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WcXV0ODh; arc=none smtp.client-ip=209.85.160.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WcXV0ODh"
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-50daba84840so37841cf.2
        for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 18:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776391061; x=1776995861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNTSjciFlX9Rr/279QUaN+sXA97OE3S8NKaAWj6D0d0=;
        b=WcXV0ODhPgZRhhFcuKI/SlGxMpU9IB9Qat1jFXkv3DIO4HdS/16t6whB1jhXzXQdJ4
         gP8Bn2lZqv7KO0XYceQPW+TRMlVLKjV7yPj/oi3npgktWRjn8Ore6pxWltWu+eQVwbgK
         6rpFIf7/a7/C+F+Thaguc9F1Jbp/MgwNbtkyGZyZ1fy8ttgzwvUOy0D6BPOR+0uowNUp
         /kA3AGSZFtX51JQir926dqj4X3O+Cb4x+W8NiU/lfYe9XIu8Uax52ye4Lo8NNLVj8kt5
         SRt+dcmT0lB0HrLYSWHHTUSdHkcp39LRKPT01jtYQ8R+reI3jp51/djtc2UEbRwTgx7u
         UqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776391061; x=1776995861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MNTSjciFlX9Rr/279QUaN+sXA97OE3S8NKaAWj6D0d0=;
        b=SZb38h9rdiqd0zGLM3uw4I+CeOvRf6aqmbRhEjCB99FIDfXw9EmyK8l0wEEtliC6Ip
         oVfOQKAn1N6Me0j3WZ3w5fiNamvla2xc4k2o26vzRnLJJ8O6Bnp8uvFEedsCI0Sj7fpM
         CUXyFzWESd47UxFqHf0RCA8GE2Xe/Pr3vsQMkLmoYE+gwyUAm/18aJ6I/qtfK9RsvvNr
         oea6fOIH3romd2knnrCRUmurhxdS5P7l9G4WQKkSWB1twiZMmcagomdKbklZcmXvzgUs
         yBFGjude1UkpreD0jU4pVWzsS79xzx6He7l0WzHtedNAx57vqnGoyMKFT2XA+d7dXvr5
         jZoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8oEvNjUAx0ciSw/RMBHN1YKUPEslzsAY/fN/6/2wZdF7NVSLEiUAjni93/qLdMwDSd24YK9N3YfmYsJ3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhgrYVZaboW7N77kzkEPIeRW2zH41zXMQUvEGH6hJqxMrn6J2k
	hhnLOPds52LU+SF4J8mAge5k2ENaGvh+cpCYKBOjaCUzUQBnrmkBR2qJATjIqbg6OxWmCVr1Ih0
	xmkroNqJxSzqlLrDygICi/WWiyAfWM/O3JlLy3+MbB9gO7+TPgMRF
X-Gm-Gg: AeBDieuH0G6YXDbGKMiZyt+JTrAkXcDS9zbXj1VWtGaCZO7oIQ2YszgReqH1jGTyd6R
	KSxyt/Ph5IAvYUnH2ZGdfwW92w1Qv9s2sRywDQXIWRDoEMHNNonq1q0R2idIuGZ1+Z2SrrFZXgh
	gri0xjh4Ho1e9uFqm2uL9kIc9/2GIahU4sB0XrrpFUi06bzWWsiCg1lewMSkxyezr6D/Adqk9pk
	XJYHvfhz7vaDejCPEIFC5gO9O/sLpk/VxcTmZrShSF0TUxM1PgVBSE7+9zRMcHL2nrfkY7/bUZ7
	ypjjM/YpJVX73D8hZFThGomthlUoAtOx7rxbg+R+Tp9KLAmTOqEdmdL6tV5CL+hABHCG01b7qIJ
	AdxKqtyKttSK6RS1D7zTcO8IAlgJc+9uBUlEyDAZiuvJ2ML7UrA==
X-Received: by 2002:a05:622a:44a:b0:509:15aa:cf03 with SMTP id d75a77b69052e-50e36c0afcdmr8556161cf.4.1776391060999;
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-50e394581ccsm55631cf.26.2026.04.16.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 18:57:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 446ED340C58;
	Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3FEBEE406BE; Thu, 16 Apr 2026 19:57:40 -0600 (MDT)
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
Subject: [PATCH v3 4/6] bio-integrity-fs: use integrity interval instead of sector as seed
Date: Thu, 16 Apr 2026 19:57:30 -0600
Message-ID: <20260417015732.2692434-5-csander@purestorage.com>
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

bip_iter.bi_sector is meant to be in units of integrity intervals rather
than 512-byte sectors. bio_integrity_verify() doesn't actually use it
currently (it uses the passed in struct bvec_iter's bi_sector instead).
But let's set it to the expected value for consistency.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 0daa42d9ead7..0ad1c5ab64e9 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -65,11 +65,11 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
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

