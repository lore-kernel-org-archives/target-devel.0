Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAC429993A
	for <target-devel@vger.kernel.org>; Sat,  1 Nov 2025 07:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761982912; cv=none; b=g0a+SRSigfV//I9TbrDeuUdS65bu4h72UmOSqRUwwNybBL9zLXrF7oWzq8jnjaHq5kLuYiDO6TnVnImbzgSk1KfgDnR/QabPQ3NbIhXYCQpWY8Tz6rQ/NDCaeOYIc1HOF/7LhGqge+tUd+OE4iSXIUDxuhfuPXwgtBl3FZ2jlYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761982912; c=relaxed/simple;
	bh=oAjAkDjUtAQk6n81S60YXrOlbuP7F5bm3hxxpXuUVUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TwFN7Oa05X4xwJSpI5i8Fcg/mkPu92iYqFRiZmEqyDy6+mamsBnUJWW6OO6y/7U8WaacYvcAC1YB1jhBhlPMmFfv51wH+cqm8izu55QiIGaE77mRUb+wU1a2Ogl61MvFuL9IjNGsSdRqYqqMlPq8LW1M83hNBjUvbXwsA+NKQEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gVwGQNp8; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gVwGQNp8"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7a74b13f4f8so1995944b3a.1
        for <target-devel@vger.kernel.org>; Sat, 01 Nov 2025 00:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761982910; x=1762587710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oLshY2j1NyL4UvQi5KisxTMa4rbmEZHWDo+dRWBxLQA=;
        b=gVwGQNp8Jb8y6eqEvGuuVoO7KiztDfI5HZkZ+NlnTZlsVpfrRhUYWfTkjUgbaszy7F
         IBOpCISvNi6afr/udqrDsAO8FYgZRVTtj3VgiPQjZj7GB5pdjiunc5uUwltmFf9Pd6vx
         4wfCr0CJfBSYKq48tfmNSwOWU3VUEScp8Aehmcuu1TFAijcwX55hjI+qP3ZwTMsBBOvj
         oyf5B/ZGjE7Gm+IFJqpjmtFmL4yEwwVAsqG/hn3CWbqJqscLGA89l9IbDwyONmxzP4ia
         BFGtXnVclV0Sszv7nVvLvHIZXzHnu85qrmdQ8A8YoPrCQQk7NQ2t7igv4j1ktmKQZyIF
         h7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761982910; x=1762587710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLshY2j1NyL4UvQi5KisxTMa4rbmEZHWDo+dRWBxLQA=;
        b=mHIvsCJN4GmAEpabQnIOGNJ9gIskiu7bKVVRNGdV5CP7xNruMNV0kP/NZ6ay+RXQzJ
         rUcbUBpumwf243HVWZMSFQF3T42XoiGcPfkXjxyHvPuYkhRWDV4c5RdoKI45dOj34aCZ
         ke9ErdLh+68BApT0HyCWGnWS1dhFo5HcwFKTRKPb2oLJU0w06XN68UkXaOwIuObwlo+B
         2Tj8tIfqWQuSRHrPnNBoqW3u31mx+ye+fSPkFo3ki4Tdh8+5yaVCp8I/N0G0Cjp0dB/W
         vkx+hVUnRpHFTylCbpUWIkkbPLYXrAp0ov+BdCrwRDKfPIJpbrXoNkoEJz43hBnUj5en
         4aiw==
X-Forwarded-Encrypted: i=1; AJvYcCVTW/sWq9jiqr2M2aTjl9RNtV1JECUGyVcMEphn90B+piT0Ztzr5cplUIT3R/D4SeIj6pNeZ+HlalowEbg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyogk4yzkZljkMWSo1CWfsGXV4MUFlaqAbWoZwS6I/bWZUtPUP4
	IUOfqhubkLS1HsOoslb4/iAfoKeQv+dIR44775zkQJIpm/+wQUaijleju84MDg==
X-Gm-Gg: ASbGncusx/G4LAJ2cxaQPXpjr2aKPikDOcedi9dh2VDpNiJJlIzQV0j4DWHV1Oim5dv
	eLCB4gTX30hUIp0BY3iPwPq5i92+EV2vRTdM/JNhn/bg3l8u7x7H1mwVjoGdwmhFMYVNbyFJGUr
	7jhAVDmzwm/o/WColxOrRhzVo24js3+JZE31KhUTz8+ymxAl0G2sbo1zCnuO2u9Eq9lKVaAZSip
	lm+Kc7anMoM1K5Nl5FYRstFUbgmT8x36jGJ6G5HrriRw4Vn/a7bKyPtpY5/DnwedptOLIHHexMp
	PiUW/u3McdYAu4GIJx4lEgvQgWqZT1GVhpUvd5FLjsWVwTIxsn+Hn1LRXfIZ3qlugTVfRQsM1h+
	+CK++363o5jp3MO86Z0h/0AROGLF3fcFldcn1pNUvWPC0WQM6is89MGAWuNuj63vUio0WVugXpB
	VqLnwr8by12PWueCE=
X-Google-Smtp-Source: AGHT+IHnnhPQKfRcidYUStUKxCGSss3Zb5ESxuCsXwzEr4uHGFO1U7MahgvxQHE4zEs8CPhTVBVoBw==
X-Received: by 2002:a17:903:189:b0:27e:ef96:c153 with SMTP id d9443c01a7336-2951a3eac5amr77029145ad.19.1761982909925;
        Sat, 01 Nov 2025 00:41:49 -0700 (PDT)
Received: from fedora ([38.183.9.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295426a789asm27969305ad.111.2025.11.01.00.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 00:41:49 -0700 (PDT)
From: Shi Hao <i.shihao.999@gmail.com>
To: martin.petersen@oracle.com
Cc: inux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	i.shihao.999@gmail.com
Subject: [PATCH] target: substitute kmap() with kmap_local_page()
Date: Sat,  1 Nov 2025 13:11:37 +0530
Message-ID: <20251101074137.98988-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was a single use of kmap() which could be replaced with
kmap_local_page() for better CPU contention and cache locality.
kmap_local_page() ensures non-sleeping operation and provides
better multi-core CPU scalability compared to kmap().
Convert kmap() to kmap_local_page() following modern kernel
coding practices.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/target/target_core_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6f67cc09c2b5..d6768ea27f94 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -159,9 +159,9 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;

-			p = kmap(pg);
+			p = kmap_local_page(pg);
 			memset(p, init_payload, PAGE_SIZE);
-			kunmap(pg);
+			kunmap_local(p);
 		}

 		page_offset += sg_per_table;
--
2.51.0

