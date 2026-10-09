Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9864A2C08CF
	for <target-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506151; cv=none; b=M/mk65vUlyqrNXgiV0aUOLFgXIap3/gfx028e+2gmT45TyhiPzCcv/tOHkxiNy9/ivcBlfc0WtYP8XFwwqhtES3jOVq3RF/u8giqSfnKwaT1NNaNBRg811kcTSbWfWR9soVcOdA3MBhthmpzvJfFyJGsREnqJySmMONEzTeemRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506151; c=relaxed/simple;
	bh=7vusdRQEb6vDC8yGOo24l6z2uwSQJ6x9dmLh9qkibmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlNIvFqJxTblEiDE6c2Kv+TyTKyfcjCa7Db8ST+g90yLCqJVXE1wcLzI27MyilNoUXAA0+SSkoPiAnPQvMDl/aQ9FiAnZl4GtHXDinZvM02+FZX1ejaD9LG8YVYmows3tqBQhg+2GcjV2RMbT+PTTvWcwedSa/8hitwsqKRufMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5e+kmIc; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5e+kmIc"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7c0466d653fso87610137.3
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506145; x=1792110945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nKFs0zmwAT1C3qeL9nzhFgqO9VFk35yv2YzEHZzzsa8=;
        b=V5e+kmIcz8tvSmZ2YUSDGwLaTyW7OUPUuHXXutMqP876lImSvDOW31EOw1M/DMwvBR
         IwKGLKflzACW/2H2B3Z57s7t++SsxQbFUMy553BEwnlPwcf4j5hOGXlfw03tM2Z6WcT+
         +m8p+ZkjGjjIg+/2M/ekJ7uwv2WEgzZUCHUG85vtuG4Mv+/HYBAQMZKL/dxPoFD+Myvv
         1u3btbavH2jAlAOfF2vA+3gwyq5ChEnA+pwEiCQIrtSvqvCN6mbXQTTZ6MDLPSO0HMHv
         SdlmIG2WDHAGNmouizQE5g2bYHwdy9kZAQcWv1ZMHGK6Hll3GZ5mCsv/Ni2rKd5KNPzI
         rlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506145; x=1792110945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nKFs0zmwAT1C3qeL9nzhFgqO9VFk35yv2YzEHZzzsa8=;
        b=Xh2GpY/HGaSgBedSCCc5Sj7Eox5h/3trR3ssVAZ7vG/lXiv7rQIqeOcqGpqF9jeamX
         rV/aWVtGh5n1ORLLsB680OkbUuv6QcNeGwwEN16qFyaaiNlyakAA3+G4D34hX6OvqJfi
         xG+cuJ2SwWL7Jic6CbCbTWfmhSuaJkdYmc8ApFHvOLDoURPopnYS9MQzrZKzRDwIacSe
         eiU3FxB0ydlLtKi0c5jlHSNusxV1JQ2GMEtey0a0EHvjK3IX8icOstPNRZyuuyLD/ztb
         kwGsTqBhS4Hp+OVvqrV0NfdtwA2HbecAFHuGiQsfkSvbOJCjVF4GPZQPxVYt2/bbU082
         hJHw==
X-Forwarded-Encrypted: i=1; AKwUvBw9DDYGxmiteNaq8u8rAvMljLwW+lI/kKfwm0g+xiukTdNURBv2wTpGHcXjN8JMTWfGiu2B5Poo7jTxmvY=@vger.kernel.org
X-Gm-Message-State: AFq9FYLD3A67/kUinvV0yUyWvLBdmwiBeq4LgCK95o7EZluh/R3+5s45
	U09GSgbItc5SX2x3MptiOayqE0fkC59tjQ2oZLGOK77xjc3P2ZOy+Ae+
X-Gm-Gg: AYBFou1pevyw+h154oFCZadjlQwBEw8he3tj3d1UJlzSbRkEDTUv2qCHCXS+yV0d5jp
	27LG5uw8MkycOhovCrOXA5LwF2XCuzCatIdUTqr4Lvjahd0+ctBaG0SfIbWEgLhbo/irPOB/SKo
	0Pk1jW2LFhaBBhAbsSkcSVOvuh2Z+Qjq4Vwwl1XADazm5mOUPwLQJtwKLxLbpVG16C6m2kMaXQc
	Zu21GTkfU5T46VynmaRgke5z++s4eF/rUxcn/sWB623ufG9XgaoxqaRX3dQUab2A36Yoe/Y/+Pk
	DaFlgBVOgbpZJOQpYNI/NLo0YjzjkKrL6B7tSjsckF92Ry2yeLkFJsEOqIdIy3plPwkyHyPd+7E
	bQOTFvnGUJ2IzO+/1005J8bH4/fmXyAXTVwp8KEVnXAleAbelIwR8OCxeRQLAHDIVIb0WqMO3EP
	/i5cq6MDtxewVtjEG9TKFSxH29vsJAWVAyAXrR7hxVeIVnQAZZ6FXIBWdRVJ124gzN4M/5cdNZN
	dpCQZMVLMDFk1bEAGgxtw6QnJbmS6/gxj1jEL26bQNsfG0mb3cqGifi1cvT2KUxtjR1rbzd8wfc
	WOJZtIbAXJPbOiMb0gY=
X-Received: by 2002:a05:6102:149c:b0:7ae:544d:b36c with SMTP id ada2fe7eead31-7cb3728af21mr112122137.3.1791506145560;
        Thu, 08 Oct 2026 17:35:45 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:45 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 3/4] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 20:35:33 -0400
Message-ID: <20261009003537.62265-4-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
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
index b52d703d2..2613342be 100644
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

