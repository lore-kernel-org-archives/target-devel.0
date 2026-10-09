Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB1242D89
	for <target-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506151; cv=none; b=ZKPIWJ7vOjnvEozgEQT7ORGZWnJAXg7+Mo+4WYOmXNSD+F/qD3X4vdOl8m8xz54S3y+s/OUO9gsr5kqk6l6BMJDf0xU333HLovB440asR44kHyhCbdZwZvq/nNzTaEFdJx+Z9ibLhLIdK4MYe77y5Ap5KjdGP9PQIXVUn9Q8rcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506151; c=relaxed/simple;
	bh=3pzmoegqDuSliAkTdeqycBq5aa62YqQO38QkmiiEiTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDsNG5URzwaimSWhcAw0ggDfvss9VA+jXnRWxAeCZzIaLNqnJTpFBv9uyKv7d4F12N2Mx/TdXDC7cMptKciPY6WCdQyImxnnB8HY0fqfZzB92OUhNhU8y8oFscq91d5k+qLfbcO5NSpt07RAtceG1CZf5PgbQKPO9byjr6PGeAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HgvBlffs; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgvBlffs"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-988d8aea5dcso31795241.1
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 17:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506147; x=1792110947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uDiCydjZ9y2SRlO9gdJts9J1fvejuYVS4OsVz5QeIVg=;
        b=HgvBlffsiavrVkl2PlcLpjXVZcuTdi02bX6PwF6uEG8mqC4+8FN2b0J1XisV+EyjNn
         8XGsf6z46VAfvFFTg35NvhhmwWLQIf8uiGPcZ5k73JcwMk2A84+ermOEDkyy+GwPfbSU
         pzddC/q71vaWOP3KEOd5uy8ZqDptiKSpTYcY+iayopZiakFgP6CDTr+JgLQXIVckx9w/
         9+f90XB5lz/Ol8FlbUddz/v7OlqgRrxQDBzijxT3WMv2irYce+Rn6pT04R/OWEdFuviK
         wV13SLQEzvtEFkKsy7YFLOwb5Ls3EUtabhiu8EJ4vKi2msKmXZuQm5Mn8JZyjqYF0H+c
         QWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506147; x=1792110947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uDiCydjZ9y2SRlO9gdJts9J1fvejuYVS4OsVz5QeIVg=;
        b=ya2u+jcrDmlv9b0cNPRi32958oNkfL1WrDWW8Kw2RdmL41xc/lmtvrDocWchVVfMR4
         bFkR6MPInzTNME1hZIiM42HvYlyz1gZMQsbaLFtaOTytbzK2lDPmkreW9kMti+30Um9U
         wzGD4omakVNmTJ9iYw7L5Cm+YN74I019T03XlgAYUkIu/VaGcPOdJeMnGWTnffr5xKWU
         Qp19rZANtjnQ/mlGN6+1QX9iZjQN8fmOtbzoPpRdFnkYeg1KdpORFQnbnSgkVG6do1n6
         mRSr6iqA7ap0C3mk1AvPeVE1IT91W85DF2/XEew2OD9cpBD2kyl4idDBhiuWECx6iH0y
         4mrA==
X-Forwarded-Encrypted: i=1; AKwUvBxxd9XEfBrDSNM1dEQsnb2UxJ+GOUkhhcsp4d/qBuLn/nok0ckd4zTA72XqLxHH7Nd8prZjcgoNufByqgE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLLPxDmzwN7hf7uTSWWGDx5M9UNp3V+4pfQtNpgj1dQ9UoiQ6Kx
	5xZElxElfLntk0y5i5KaxPo3h8FcrUtMA8e4ltAuVhFqDXbu5rGSj3+3
X-Gm-Gg: AYBFou32Hf8pwKBsL2fvb9sQO1PODZ3izlSqTY8Y6BkL/wDSG2gkwW0YvOSW6a1RkTn
	8EvNY5zrZqqdHYtEDAAJftRfI5D+2xxvdyLtRdrrFqYaNKZ1Pugee1a5s3k5IypnV+DPw7Epcq+
	TaKlPII3sQxGwJpMkGUmOwipL7frja01urUlD4RmUKTZmtISfTaVDxgZQ869mKspIgTPij9wlJE
	H8jiFKb9RIWpeUA7CETAZelRdnbh/bZoD/BovYQ6QM2z2lix+r5VcjxPoSi0YVBAuVlXeeYIzKy
	2zm80z6XT0xKX8aOBbEZnFfvmyTLmoUtcBBQWC0ed0ix2NrzRfz4QMgQbQhD1sQutX7is7ydcLR
	jbQZcd19Gp2Yf2L0aIyoRn7TS4kPDoAOlLcqdnireeSuJnu6lDLTmu6785pJNkJrRq1DbDnK8nC
	SCpfbq6AzuThKxq2E50shhxhPNt1FEQedvguXLgRa7gD+AKwQvaYzeyboBjD2FV1x5QjozO/GDr
	6HNwR64FiOyViRsUmz/oNTdmu9ISaAqgydc6Kki0mkwCIwrHRLejXSHkW+gMxyJTowH2YEN3ZmJ
	X8MyyfLViVez9Bbr/+0=
X-Received: by 2002:a05:6102:a4f:b0:7c3:83a9:edb2 with SMTP id ada2fe7eead31-7cb367883bdmr130748137.1.1791506146842;
        Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 4/4] scsi: target: rd: Avoid 32-bit overflow in protection space size
Date: Thu,  8 Oct 2026 20:35:34 -0400
Message-ID: <20261009003537.62265-5-sanan.hasanou@gmail.com>
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

rd_build_prot_space() computes the number of protection pages as
rd_page_count * prot_length / block_size. rd_page_count is a u32 and
prot_length an int, so the multiplication is done in 32 bits and wraps
once rd_page_count reaches 2^29 with 8-byte protection information,
that is for a 2 TiB ramdisk. The protection sg tables are then
allocated much smaller than the device needs. A command whose
protection data starts inside the allocated range but extends past its
end makes sbc_dif_copy_prot() walk off the last scatterlist and
dereference the NULL returned by sg_next().

Do the multiplication in 64 bits. The quotient still fits in a u32
because prot_length is smaller than block_size.

Fixes: d7e8eb5d9216 ("target/rd: Add support for protection SGL setup + release")
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 2613342be..d7752fd34 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -253,7 +253,8 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	 * 		   (prot_length/block_size) + pad
 	 * PGSZ canceled each other.
 	 */
-	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
+	total_sg_needed = div_u64((u64)rd_dev->rd_page_count * prot_length,
+				  block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 	sg_table = kvzalloc_objs(*sg_table, sg_tables);
-- 
2.48.1

