Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975246;
	b=na1qsCUII7mFdpsrWyJ34UarVBZsAivANEMlA6FLFmH0LfgcOEPfe7lp1Z3SjOZZwJ2o
	 wTlQMXnSLNVXCjGseBFbrUwIZxOfWVPRMrgoejN52bt3lg+OvB5XxFAXhsPE14MGklaJf
	 GtIdnj4V605Kw2BoaI+JHUeXHISkPt3phzDyrPTAy+21QYAGrunyzS0h/asJo6CV6hYjT
	 ulVfYfEg6dD8/MU5mhVBwAT0GZa6EoMM6ZFGYfWSktO2F2lAhuKJSwbwC6QD+KPXRJN6w
	 IQ3paaI0R3G3+W+V3mdJv8RWkBJm1/QpZGIm8XcnXvgH9ZuZkwrsxfb2uj1NEOqlPow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975246;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
	b=m1HI3ENwpq4CxNxBDw0u6Hp4nh7B6JZJSAz7JsECWuLQL6EeiwaeQmKmLa/1QZlxDRfZ
	 mtQACRYZYm5Bu8oWNju4ZS7QyMV9H6v0As9Y+Ice7e0vPMci2Eed3fugOJRXT36nEbjig
	 B8QLbUgsE4odNHPO7S7/3LFYY1FkOTaVU7JLebllvg/vCJr0SEAnvpHNi4hZiny6X4GRy
	 Nefo5LjCa5ME5/8I5U92ak0Q99PbY2ey/ucSTKvR6gOELAf/u1TNDIE0JY0Pd9Ub17DsB
	 LIEmXetvGLuV07iHxU32j936zjBia3OPsZ67FoUyK1pKgLQcg8AHYDkYW9HFL0YzH3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cvqhJdEY;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03159606A32A
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03159606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cvqhJdEY
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2efd432714aso2226195ad.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975245; x=1795580045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
        b=cvqhJdEYHrsoqlj7D/dBktgjPA41xa98nkLWQlnCpYhimNzYZmBJFMqmQKSEphE5Ge
         OajrsBz2EHcvI0aTqJYEeugWVzfsHPKjzP6ERS2dpiO6MI4L1kmkUe5iL0iPFCzkAtkm
         yEcHdHG9OSja21Jd4DCZmWBOdCjXoQ7QtZBpKIKa4yZcG7K81RSmiBU81V4nWDvWW/bK
         U29KZGDF2Tr0j/F6/kGiNs5MFpHSRd3ESFeqi+noKlJK+UzYt4T7DTo8Eg1jiVVhDIKw
         GkGnnpTMtEa95ey7mU9fq6kqBtVgD/IuA8MdGvbRJyGktekFLaWBRUxotFB/1xcYZzjt
         PTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975245; x=1795580045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
        b=UpLY67+BooLD9I/ZE6iiIW0L6JuVRoNbC+LetIvY7kOvYaj3AlOo2dfsuCKG0aBvLm
         tQzc293dI2BGVLsS6Eebjwpcz7SUrcqXsq0CcnxGapyun3mItQd6xYJbRSuriMDLH13z
         8QoYgZrNttyEZ6nKatrhJLN4O0/+/HmfxtJvxLsmkayWRbTUc4N9a/bZdqc/VQywf+Rs
         5zfbQfxx9jD4SzQqyiqdLLr7t2metUMGhN25oUnG8TTikhds+6gR7ycxDmTTWPhMDdV/
         nPkj57LBW9KmsHYlgzaQFF95XDAJDkWVQjh/i62O0AmYtsT41/SlgwUpiJbDPMl393fD
         bH+g==
X-Forwarded-Encrypted: i=1; AL+hErGAnQX3Q3iwV8ud1vXIjGhhMuSaDFcJt6WujHjkKxst5IlTDnWG+iT7qvQnjAeioOewOwgoEWwAZI1tUJ4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AroQG1CcreuNiPrZlNirCiMBvf8l+ZEyLQN8A4CtE47wxhEX/
	PZplnwqPvvkYujjXzpVVRAenzfwMGmnyQtkNH2g965AZB6x9KqSKRXF0
X-Gm-Gg: AZFdTZe1dIZ/DGC1Fw739o384Iiq0k/AKBwYYETc8sO4X/1jAwWQJB6lMAra37jCuKh
	dttDEGD/0F4df3goy6tXeOwNtWk9yJ4kAJsrYUzBImGNJOt1bNOvT8bUsffine3T+Y22o7AZ/3+
	r/TXB1DSTsYZ/uGXsl9v1v1M6yN86/NRB818PhF+Cl95mHr3dV3o16mRO8RFJaX8Vj+WauA9WPT
	tUwcdTgqJRvurAxesnnDnxB4N04Ls8ZoJbOSP2zaCBXQPTEsFTmFE1KSCuNQA+6oa53VGg8eJxC
	n1B1c2TJ5ItTa1IiDk05ceZcO4KhGm5GhffaynjjuxUufYXT3VH/kooSrWHYUeYIUjokajgNYeS
	51NBpcjcT5lv9y5pwE29/P8JXE5euySUi5YHyork/ZJ42YC66HCf7aXbzAdlOMZcZnPfg4pfvbO
	moifYuoSDVPFHbx7nIOZt3yIgNO8qnBaocsYCcud/dwlzDizAYARzaSoTBq8m4ImOAOa5w3kC70
	pAfbCSmEhoPmg+82ncRvnHCHvIf3O34lUp74Kz+8H6SPW2KyNcMDX7rgOIyrmWmGIPpOaLelQia
	3MLVABV7bbZZs+yAwV9CN2Z0iMH4GM5IINYQM3C2Pyc=
X-Received: by 2002:a17:902:f70c:b0:2ef:e130:1505 with SMTP id d9443c01a7336-2eff72ea971mr12502285ad.10.1794975245258;
        Tue, 17 Nov 2026 20:14:05 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:05 -0800 (PST)
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
Subject: [PATCH v2 2/8] scsi: target: keep REPORT REFERRALS stores inside the buffer
Date: Wed, 18 Nov 2026 12:13:05 +0800
Message-Id: <20261118041311.19011-3-physicalmtea@gmail.com>
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

target_emulate_report_referrals() checks only that the start of an LBA
field is inside cmd->data_length before storing all eight bytes. A
short response buffer can therefore make the store run past its end.
For example, a nine-byte allocation reaches the LBA at buf[8].

The response builder must still visit the remaining LBA maps to compute
the reported length. Encode each LBA in a local array and copy only
the part that fits in the command buffer.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_report_referrals+0x100/0x380 [target_core_mod]
  Write of size 8

  target_emulate_report_referrals
  __target_execute_cmd
  target_execute_cmd
  transport_generic_new_cmd

Fixes: 38edd7245771 ("target_core_alua: check for buffer overflow")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c430..c110914b7b78b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -49,6 +49,19 @@ static LIST_HEAD(lu_gps_list);
 
 struct t10_alua_lu_gp *default_lu_gp;
 
+static void
+target_emulate_report_referrals_copy_lba(unsigned char *buf, u32 off,
+					 u32 data_length, u64 lba)
+{
+	unsigned char lba_buf[sizeof(lba)];
+
+	if (off >= data_length)
+		return;
+	put_unaligned_be64(lba, lba_buf);
+	memcpy(&buf[off], lba_buf,
+	       min_t(u32, sizeof(lba_buf), data_length - off));
+}
+
 /*
  * REPORT REFERRALS
  *
@@ -88,11 +101,13 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 		int pg_num;
 
 		off += 4;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_first_lba);
 		off += 8;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_last_lba);
 		off += 8;
 		rd_len += 20;
 		pg_num = 0;
