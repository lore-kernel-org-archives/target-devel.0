Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FBA44AB8A
	for <target-devel@vger.kernel.org>; Thu,  8 Oct 2026 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499044; cv=none; b=oxaTlgx1stz1JqqpF0gyvhkReboi7e7AiDBrSVvvaO9k/hPVqwH97oGafxB2NhbmZXH+/CmDwW1wXfwb58LyOWEk1/apQh6yGtx2beSylU1Zz4+glQRQadk6noEICTkujrgFzLK6F1OKGpEJGY6JjfanNj3iDaaLTEwo7gTv2xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499044; c=relaxed/simple;
	bh=lJ6AYpHjGOkimMExUHB9UOtA234mEYMud8tyoTmPLRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlXEWWDR3Ilk1T/rkudv0csW+rrYwpgRIov1wIim+CEOFWY9GsexVWPACpumppRSemOP2HqsQ09Zsn7XiyzEvcNdpN+mSPx44XpFv4ez5BjPBltqxDzMaKion+NRuM+E9S6gbkiN8RwiH3j1Rk7f9YmWQdsrLjMYakyooQ1YCZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nmt0FaTo; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nmt0FaTo"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5e8e8228183so25622e0c.0
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 15:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791499042; x=1792103842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nOpeyuGCRMACRp8m9ibObWPSIPWBOuQMlxgdPx+TYS8=;
        b=Nmt0FaToi/KWZq4wJ6LAgSt5oog2cBkOZ7xFgMILhDfY6pyURVMrYFF3iN55TFlYXR
         yNRtC60uD93YmFuVl+BadJpHyUDO7luvaqtpBcadB6QXaFGjf8yVGtSYZKFKwJX9yMWy
         SEtY6CHcHlbQVHH0ByjXH7XWU9OJNSxJxFrtFmEd3wKeDnXGqRcHtSkynK30qaheHRU0
         fmxtV75GEEN6wZJ12c8DJrN/6DAjXujMc6knKaBEkzjzZyTAOMkO832f2b7TJpVp5Qhm
         oSU42jc9YsfIVCjTmsKPdKGjJ1bPyqjJaLGmF5LhZIhKimQd4VjKfWY+h6xFoU0RZaQR
         3tvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791499042; x=1792103842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nOpeyuGCRMACRp8m9ibObWPSIPWBOuQMlxgdPx+TYS8=;
        b=NyhREUYeKKE+3+rqxLN2JW9Uwa0deZ+Uutl9Lsz9054z/t6oL7NHwCQ3t83mTiw56G
         0NjiEjzyGyDTKafzQQlJj3RvpUayhkLKH7i4ezFNHwdrZFxoXA+U3RPHFoAR6RbtFRAk
         ynNVtFHZ/KKb1bNb7Jcras/VpBQACbFIF2O3IPJn1FjLFwK5q/bb4Q8hLOE9mAVLRfGs
         b1p7WO2k+CqoF5rlrXDPddCvChWfpUuBnvRSlSsrBRPgmbtV00GfqKOpUFsNuiLAFs3g
         ebbzTr7dw1bvmEzL3WqorqYLBRGDhjcLP5XZ5vPu97pVilmQLEulaoI3ap6+UDXyxpS2
         MLiA==
X-Forwarded-Encrypted: i=1; AKwUvBxGuojTwwzKpM+ci6j+66JHqm8Amq13qZwIvpYtDVWvTlNWe0raeiRI005PUY79msnN4I2SV1lOzvtoMBk=@vger.kernel.org
X-Gm-Message-State: AFq9FYIXvCuQMmX0eIGJV9xLGyYBE1cSOPszJZJgVqNsT/0QFnEal9hP
	h5NMICXzbAhAmWmTKmKplOiadf/cquEs3CSTCzIi3wPX/r0q2ISzlBeo
X-Gm-Gg: AYBFou2hh7zgBnS8HdEK3KB2prbp46Al/GbbW2I3Jkogd2pRQHNuvcJK7EtR9PmibX3
	zJnhP6Oh9QMabjgajl9ocjmtnbdc0Tq+Tu+XNS5jzcQAZBo+m7/fs3nwLJhbOLK83D0wUsGLxgD
	L64g7y1RsUebHoMWDkE9DCOL3ROLt5xMmJoCaFbZ5mlAHU3FcnGl0Q3+K9KjnDvkdo09iKfLYxq
	mMlA4EQEKbrx3dvPijCzHUKmhmbBhX6J00qjPin1aXVT78lyc0VCNMIks2NioKep9SzmLW3BQQV
	ueFNPYpg/yqxgMSe4s5bnq4+YOXySMYgxqv5dd6GRnxjuVhAWB1it1bXvAE9/DJCWRxmaP1ifk1
	nUKk/nitzgzPqdEH3ZxhlR9R/TwhEDlte5n4YJzRYVn7v2v/o2JztfQcFAtYGdQrdRq4glhn9gJ
	BmSGe2c0pyWyHDSt9UaT6OuF5LikDHG9iROAkn4qHEDdPpxHxOruGHgStpnvdgvt922ai3H95gb
	gafpHkLtVMKziHTINDKn+EmlAv+NjKcc8Xzht+5gcxv/ZT2YdN9t+vJjkK4NqdcZL4XWH4rjCmE
	zv6nt1kqaRFSwUpZJEc=
X-Received: by 2002:a05:6122:14a:b0:5cf:ad27:3a67 with SMTP id 71dfb90a1353d-5e91f58265emr4623e0c.5.1791499042370;
        Thu, 08 Oct 2026 15:37:22 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab8c40sm393284e0c.3.2026.10.08.15.37.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 15:37:21 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 18:37:10 -0400
Message-ID: <20261008223712.49827-3-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008223712.49827-1-sanan.hasanou@gmail.com>
References: <20261008223712.49827-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

rd_allocate_sgl_table() allocates the ramdisk's backing memory one page
at a time with GFP_KERNEL. When the requested ramdisk is larger than the
memory that can be freed, these allocations do not fail but invoke the
OOM killer instead. The pages are not charged to any task, so the OOM
killer keeps killing unrelated processes, and may panic the system once
nothing is left to kill, while the configfs write continues allocating.

Use __GFP_RETRY_MAYFAIL so that the allocation fails once reclaim can
make no more progress. rd_allocate_sgl_table() already handles failure
by returning -ENOMEM, and the caller then releases the pages allocated
so far. Add __GFP_NOWARN since the driver logs its own error.

Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 97c63b122..46698300e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+					 __GFP_NOWARN, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.48.1

