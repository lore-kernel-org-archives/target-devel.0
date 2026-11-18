Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975268;
	b=UC9IE/Hasm1eWnyVUT1Ax8bHi4kqgclCAKmCtZOUoPYw6LwzPrmLkq4rci4tOJJju0fS
	 tmdkCYbRhm0t1gkBtgHjGf3VHUTvmLzJhkC+MK7kUMANwJbYOf9y8DpHyuMBnTlK1PDKp
	 RLaPJojy/bNt4DT/jFYOt1/QkTXHqEG4uldsvkakBRedpeBbjuLesDST5tiniHQh/5TY7
	 e2Skf2jeAGY1i9u9ViQSR2vkR/BII3AY20WWmh+T8kc1E+O4GoUik17j7xcFRAbjqdEt4
	 SVaB+X98u2Bd69Zmmct+TxlxLBDkNVa4+5QhnANxNMkFrLT+WQlVOnZpjS0wj97un/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
	b=Weyft6nZcJWbG3JTHamz0kPWj+tLxVaqRqDyLazIzpXI2MxFJfeBfg0mGi3NRYtAaOWU
	 VYJCFh64L6CAn5enrkTWZWlV/Bd5uHe8W5phlwso02Xk2f8wwTpdD6GxWnxwyIeVexvUV
	 942Pu0R3S05uNl53g7k148USUsFoHrIa0+agTyTDRj6z0Z8V5o9CvqMTSkBDAeI7PGZkz
	 xXM2dr8RR5UI6ddqdX8i5GijUo7ZRlXaTh3FjEG6C1cQVKg+aVi0EO3W12JbyD/1kwMy6
	 YE9+aI5pG3uGx+ACHYN/KXT+ap7GWOVtMZ0SRrw+2B6/4g6OlmB+3+Faw8tFCl6Qg1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iMYVw0pn;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08318606A333
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08318606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iMYVw0pn
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2efe8f50697so2117895ad.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975267; x=1795580067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
        b=iMYVw0pnpSGisBf9wt5mkp6dAmIfmEHqMVV3f2qKfO2D1MSkKjpCBpziCF7r7QU5dl
         R6IGkbU7HL3qgXhVAUilaShupESFUptektESp60qwiClRhPYZPoyu/cPs5/6gLnbOeRN
         lwCUrhXC2LAf4GSgyqUrdtJAT9spLBT15FupYCkmE9z6PAwK99T3qswWJjiWErHdeD+n
         IMCExIlvORPXX+IenIgKFlXQCnv0pBzncAXrcQu9RD8Jy7xScTWKmdviJ+IQy/5VEUkJ
         M2+UGv5eadFh7WZG/oWWg7XDQqgUKER5qu53eHzppuv9kMuHyKnH6yu6dao3SIHDApEr
         r3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975267; x=1795580067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S7V7zZ843cUu9IT4B0WCibyEP2k6ABel5P+47hk3Njc=;
        b=PVTu5byLPecy/gdBZ2JJHKbmotpCQyUip0/NQgi00IQVbcTUp60yy6vHLAm1QRZjM7
         QcbWow4MLFTHdCgfUaDNQuFuHb6hR7TJYAJCt4w0iRFp/VWgeFFJ1xPnMv59A55+RRys
         /3Z22RVoUS3tSbQ02J0OBQ8xwVDnagHpg/OOAvfI+GyQsnc3a+7/EEo/kQGDiAKqtQL/
         F9Sf5OJqPOUqyMSpZtBAK5V8jhjMQ7hoG87ks8br9DIzFOQksVnYY/vUZ1GmqxdAfiZK
         eCZY+dSl3kMlRqZbiZGFYj/L9Ckl/VIym4aiMjjpkHSbyyVvmPweIqpN2MPOU27RmPyA
         p1oQ==
X-Forwarded-Encrypted: i=1; AL+hErHInhuEn+Iii+TUn8lMKEPRJHXnEY4P37ND+w1efkNcVdyyN/Rb2sZipx03y3h/Vh4p9qUcogz+P4jpxC0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+CuqKoeT7bdDPe5L//k5dGGVGDQq3SX0AZ2kch+ZJ82XYbV3EN
	ii9VF+t+mAEMhqoRJMqf9fM4drQTxukEAiLMCvfCi+wURr4+C8i7DAMp
X-Gm-Gg: AZFdTZd79JXESU+KX0EaBfkkwesa/U4x+XBqNWUzvdExZNRZ73djvk9Mx7000GgQStu
	d1y5DzJakc1hujhu6Ct3bH5RyHCYLAbOVVheI8GmEQarhlvfoH77YuAUKqoOd+geNXavc44qj7s
	zWXXj7rPJQoiCNVZM//dRybAvq3tsnCkH5ZyyUUoQkSTHJox7KGp08zFwAw6qy0wjgcMs1Rux/E
	T0Hx6mE7VO8D7z43uAVSMjIXJJ3x6gkBJUVlCqEphWJSiYdT9ko6eChMJEV/Rn48xhcQlBOKV85
	tufmZnSefLvAR8CCJHoeSUDT/pCjZUNUTfSyK2U/K2Vo8wraHM2MyUYiwEnfrEwyAZ8XORqkww/
	nQNC1L905xoHKy0WZhNMY0FVj9rEX2gYjx4gMI8nTMcHSNbZUYpxOX8tRanmC4QHnMPJC2lw0Gs
	jmXoLXllBnZ3vq+21PJ/lQ4o8zF1VfkqX6Qtv8VgHgXrhVrOxwgDd5SvBf47Dl+w50f2baErK58
	dVybzCzgLV6IiqQ5p5IUt8CYFI9y1H22Jvdp1t3W/3WJUULfAb4wUbHpyos7oBT6dnZXX3drEv7
	QlyArDPvvvbVX1dUqEwGyxARTR78S0ugNwYm3ZSv4eg=
X-Received: by 2002:a17:902:c952:b0:2e8:1c7b:3b6e with SMTP id d9443c01a7336-2eff7403b8dmr13500835ad.26.1794975267252;
        Tue, 17 Nov 2026 20:14:27 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:26 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 8/8] scsi: target: advance past escaped DIF blocks across data sgs
Date: Wed, 18 Nov 2026 12:13:11 +0800
Message-Id: <20261118041311.19011-9-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An escaped protection tuple advances dsg_off by one logical block.
sbc_dif_verify() adjusts the cursor across only one data sg on the next
iteration. When the skipped block spans several short entries, the
offset can still exceed the next sg's length and the following CRC
reads beyond that entry.

Advance through data sgs until the offset is within the current entry
before checking the next block.

KASAN reports:

  BUG: KASAN: use-after-free in crc_t10dif_update+0x91/0xf0
  Read of size 1

  crc_t10dif_update
  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: 18213afbd8ce ("target: handle odd SG mapping for data transfer memory")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e752b23b1bef7..671427d9ae74a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1553,7 +1553,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		}
 
-		if (dsg_off >= dsg->length) {
+		while (dsg_off >= dsg->length) {
 			dsg_off -= dsg->length;
 			kunmap_atomic(daddr - dsg->offset);
 			dsg = sg_next(dsg);
