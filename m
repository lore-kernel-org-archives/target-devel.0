Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A109A1C2324
	for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298971; cv=none; b=omCWzY+O6yqXrzStmcakBMDpu/bM8EGsfDHG7SrJnPbIPY5e9tmdyJym9A5FRwhreCga4L1ANd48hC64vzESb8Y8Jt4QAop2qvlDUR7ZznTODbXGOVwFiSg9CRVRPg5JK9sfC31/Lq5tvjfiCk31aMGVL7ClhcTzFrw1LdQgml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298971; c=relaxed/simple;
	bh=FVwKbgioBZ+VO2vvdiCyvzfplqZuonuE42jMiRh7ulc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikIc9mKWlboKLBhbdIJqwqdjehWkB2GiCj+sdUrXaG8bBbZZxQyVR3FrLyuBM+HjOJ2CF/TxC7TSD13h77pHDzyzJbrMLaHUfO/kqkcIVItadFa6QBh/uL5+7ng9fQl8nGwcdALg8GyMn6NL0KCQwlNSp8eotgqOiiO1MbGyGkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=A/n/Ah/B; arc=none smtp.client-ip=209.85.222.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="A/n/Ah/B"
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-8d5e1ca50ddso142643485a.3
        for <target-devel@vger.kernel.org>; Wed, 15 Apr 2026 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTb4WYVL+QtfOgfKxr2rwJdF5OfB66I75dlU3VTdI6c=;
        b=A/n/Ah/BZ7Zj8v9yQwgw9Cu4aQ6WfKwC+hRGVwA4AHyKZa2Nbs9i+ELQuUPwQlnuTZ
         eyCuB3IlKTQXCmeRPe/c6C3rqeKkEHAmm1QLyjMu8s26OXW6ASdD+bj6Z/uansAf6sKX
         wOGV+Xh+ZJzHBxISK95ydcIkN+kof+IybXgBtRAXXUlZIh7+mRLpzQvAGewvkQkOFqQu
         tciz32ruqZAecMZi6npaY2c1Rh3DgOsk2cJ2sZow/FfkRJwRhcHnRgrBo4FYqekGg/ef
         WtHzecD5pENS5wkST1IwrjYpg/dUTsClHvSGFq+4nFPFEgbu3DFxqhw0wdzrJp+6k9zR
         Ac7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTb4WYVL+QtfOgfKxr2rwJdF5OfB66I75dlU3VTdI6c=;
        b=MxxoyndP3229T9L3O6ev+mmcah5msiw+SjwHyEvyL7SPzH17KGwPIjhlhTi+zfYfwr
         tluN/WpnOb9JuARv0Oy1zM2afQvxA7vgHG84z3AeBEdZimrDC2EAIC3qs4wpXYCo12Mb
         NCg/fKtxDwe9+JLQZGxyrdFlQA9atwKZvuBcUedS03z19/m1HqqlOaK7kwIkMb1hkLk4
         VSn4c4MqptqRFMSV/M7h1i6K2ZH+Lt+85Etxi6BTTj4zk4lYrUZTgnRwiMGE8CHCSVEg
         OF036RhAYfWGR0zi32PHFlw5fLH3o/f9OGU9qZMuvulH8L2m7SMwp85yvQW4YaBlUExv
         HrnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xheMeZ8qnuQaiWM9bw0QPs1LijNPkAxlazLoNKVzBQcV+lL+qRIiqQ9sxcupWFyCFi/ZD450SuM/PefA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQj3Gg+SItGkGUBVXFhx1bf6FRBoN6GpOaA/c9+LzfnWNjaEVc
	+01Nhris+wgXYEXEaApz9mINT5QFzdO5mJqNfWyOTIpzvjUqHjhAlG5Vax2XeXt80TYLXpXSc00
	to5CgbYHKi3W8KwHVcqeSzoaVSiC5FMOz+00z
X-Gm-Gg: AeBDiesOckaZlTtw2oISHk5qgeAgxcVWNzfWwSOYC9blUZC0j/TItDo5cwN8Rlw8bqf
	Yk+H5TsEY/cgYWkWVOgnwvb53AJQuIj4uOrCwwdYwqoZzyPeWCiyinST/CStx2ErRY3nt2P7zLH
	uVGHqK/hnLSgZ8kdsA8wUeqOizyQkAiCcgKcvpsC5Ju1dakRdSE/wMbgc3CC1yi+uzqgKmfIrK2
	32n4T5/p2aLVjXW1Oq3J8oprYxuYWbu5hpcqyukYmCiab2YVrxiYXSC1WOvYbc7qb3U+yDHxXPm
	N8BLJGMLkDh0bgjMR85lUbXWWuLe0b5CIiJz05tVkLX6G6lRuCg2wI2AYtU5xf+ANXskLI15d+p
	UiWniikEstIBz9eaMthlapjWfUlqvzAjQsTISSigwKpRdtZxwIn1tHvcoQmdfhNoL
X-Received: by 2002:a05:620a:4614:b0:8d2:394a:d3f3 with SMTP id af79cd13be357-8e6321e7da5mr60618285a.2.1776298968296;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8ae6c93d2b9sm2589456d6.4.2026.04.15.17.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 07F4F3422D5;
	Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id F1B94E41B93; Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
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
Subject: [PATCH v2 4/6] bio-integrity-fs: use integrity interval instead of sector as seed
Date: Wed, 15 Apr 2026 18:22:12 -0600
Message-ID: <20260416002214.2048150-5-csander@purestorage.com>
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

