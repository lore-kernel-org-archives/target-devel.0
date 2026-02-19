Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164612D3733
	for <target-devel@vger.kernel.org>; Thu, 19 Feb 2026 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771491813; cv=none; b=RHGRPWogP5SejXmVjnkI+O8zY31+8tltL2qtjht7yyodkfbvHcHmGtEP07xf1cezux71Skk0WzcMXBBrbaqkeM+rdfx+gCvg6rUcDORE3zJpaC6fN896CmS+M1ZVVBF0x0/PK8o+rqP1SFC1OuE0SKY/8HFxO1ZWF+UFpHsMzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771491813; c=relaxed/simple;
	bh=928OAOahZdG4Xfvx2DerQUpFBhMcEhz7CAZj5Aci8zc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jZka6QU5ZPOFhV8t4xhM3mvni4xTn2n4MZHLxLmWWHMMXyFBHgkfteN7E8WnF/RcZXirIYYf4vCAXy4WVqJn6bcyV8YSA7l0rKZzlklEgCkos6JBDe+DWhRz1aF9LeSFM2fUbNN1hnWX7DQziln4rkuHr04uKZs/W71ZOPCZ+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b=nbIuT/vJ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b="nbIuT/vJ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-823075fed75so346732b3a.1
        for <target-devel@vger.kernel.org>; Thu, 19 Feb 2026 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20230601.gappssmtp.com; s=20230601; t=1771491810; x=1772096610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=woTan9VVYvyV1yh7C/L083Hx/xNDYsj+r3LiM0PqHJ0=;
        b=nbIuT/vJLyA/crDZWYVFRKLI3FTPEXAHc8Mf2hbGWljvGArPteYGEoZ93nrZ7pC5VT
         xYl4QaTr0HdNuFfEOrwYQ/zpnCOQ/ek7K2LkkQvHLdcz85HtbQxuJFNs1DQxOwkSycRe
         7TmBOfCMu9fThGRPrLZoSeanu0F0DaOdov2mPFIwj7Vlero/NgscxD998oBVOXncyAbX
         RvAyH16SKdsPbD6BdJfckVjXnwzoHOtj8krJDVV65vWnvsCEdcq/KPA5GsbAVAxWzaTG
         Kewb1qboIpzT1vubRfa+xihM8o5ax/Mc6uLL+/S5RV2fv9oiL1joMpQvANPVJ/g4HnDt
         K6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771491810; x=1772096610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woTan9VVYvyV1yh7C/L083Hx/xNDYsj+r3LiM0PqHJ0=;
        b=WsUGtQB6F5Cd8whevQTWSWnEKdMxSdEjjXMlK7UPOzxOVr54nVGlDai4t6QibkyeG6
         wIcCY+hC7kgVV/fSLSP9mMpxgk5eQobI8327CVXppxVzNlTdKtO/gTzDc21+iaLjnYq7
         /ih43+Z/u/cRrxyUaacY55n+LOW/PrNpHmPv9YG2VEwa6rZ9iM0cErwUytUW4W3s3ttr
         cbQSvODUQawbPlQ+stWCEL3fRFHWyhMXnCCCJGUzKLzAeIpmVuxxrU2cffeQBIyvbGCl
         kEiSaeDTxHeEEUTa4xEHvaaCscwpMXzm6DRFqjg/sXTFF5QKhGweAEbIPvs4wge2Rtb5
         Hi+g==
X-Forwarded-Encrypted: i=1; AJvYcCUbg3pN6Ploxg3an/K1kbHPW7XLHJj+ynIcpx1Ql+dMsx7NHmNe/J+Z+RywX17EPFGjz8ohBTnHnXqEpKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr3IDgeyp1b80kaDXIgV8FTyysTeCDB2eTh99hyuATx369hOhE
	z3078ZyAIC7PqgZ6J3Hrcx3VzUnwy5y6Zjo2YAfyf2Xl7dRX5L48D1oUIvf51ImoO6aN0dE/eDC
	KZXVb
X-Gm-Gg: AZuq6aJ9VbuP1s8ZyO4/0Dn+ALd5pv4Fcok43NGYDrzfJVo9T3+ovyA2S+Pdzwdmbq9
	vEbZH4+PRka1c/1CIf6SE/735enVzmXyZUbm8IXuPDAz2IdCsWd/qfMROnR+4vmyOyIkUSQuYZj
	ze6te3YBNB/4VEDLX1EIteFAWhUYf9W1cUAzN2ATUxDWYmgiBhemv7XvcHpbZnTuxhDuzlKmbeP
	EJ2ODBtrRnUToGA8iqBasaBtwr6XKkYa6/NwcrJzanJS1bWPx/l690nRGiZ16uR1dvLo2+RM20w
	P9E4NtHeI2RltXdTiOWZSY9lAYfin8Luu3iadK4NopbxIjwHHxrqV7hYXuMy8RkXQvlh8BHqA/W
	s6VIrQ4cNOEdDJW2TPEglZM7TDrTwfMdfWpuUKh0hwLFrTYu+/MGxFg3dyYsCJL+LCPoBaU/F0a
	XCYi+F3B5tEn9RonqUbvE/IrbjTnYOdKQYDqsfBvF8ooVVhwm8H618NzlfbbzDT+FsspUD5maDv
	QEOyUzd4Rfm8kf+c3IeBwFZYyN3kjaqfrgRDubtDdCSHBbb97h1L2ox7Q==
X-Received: by 2002:a05:6a00:1d83:b0:81e:b93a:ab09 with SMTP id d2e1a72fcca58-826bab56b60mr1002475b3a.1.1771491810251;
        Thu, 19 Feb 2026 01:03:30 -0800 (PST)
Received: from localhost.localdomain ([103.158.43.38])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-824c6bb3549sm19985248b3a.59.2026.02.19.01.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:03:29 -0800 (PST)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: ram.vegesna@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsmart2021@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: efct: Fix potential memory leak in efct_io_pool_free()
Date: Thu, 19 Feb 2026 14:31:31 +0530
Message-ID: <20260219090136.108938-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for struct efct_io in efct_io_pool_create(), is
not freed by it's corresponding free function efct_io_pool_free().
Fix that by adding a kfree().

Fixes: e2cf422ba833 ("scsi: elx: efct: Hardware queues processing")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Found using static analysis.

 drivers/scsi/elx/efct/efct_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
index c612f0a48839..bdafecca7573 100644
--- a/drivers/scsi/elx/efct/efct_io.c
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -92,6 +92,7 @@ efct_io_pool_free(struct efct_io_pool *io_pool)
 					  io->rspbuf.size, io->rspbuf.virt,
 					  io->rspbuf.phys);
 			memset(&io->rspbuf, 0, sizeof(struct efc_dma));
+			kfree(io);
 		}
 
 		kfree(io_pool);
-- 
2.43.0

