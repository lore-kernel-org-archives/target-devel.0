Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794366404;
	b=TJonz5xC0u4+L3jsCsjO4TYGYbNaNzvVaaoDtNxfV0JfbxmYHiQm2cj/k7u13Tuu+wF2
	 Xd2uq+VsKAYM5DpQeBGSKfLHJg9+sb4UnNsc4jmrCe36hptaJJg//QDCKMQCih5dZON6H
	 Fu0plKhWVgHYZJoXONZTf7fx8p7HuiKF0UiR7nOvEkdCDlEPGV9vln1Pl2XXb0ybNhQSE
	 T7bS3Qoatow2wo5VFmQIfVgyV7+Yit6jyx/Z3vlWYgEo1XuXRvQuNOBZOjvK9t9SZnYZg
	 41EKt/G3p+rBIPzt0RM/uqv/pG1BTwbapBct/4MWiRJqu/fZjsgrD2mWfmVQExnCm/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794366404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
	b=j37Qqt3rHWc8kj4m+a0i4d4rOTRev6kQoP29hECWHjajEbwdTD4yBqsycw+WHysD5QMn
	 dAJFadfa1XYExr8V9HK6AeVqH3HL4yyKgawRC+ymTF7UGkAfBhbDvG//h7PPcnU3niDRP
	 8cEOrvEl7IjGY2HAnby8eHcHfoSOtpwya7bGctxLZ67i+bh7CVON26ugn9Ml0lgkc2rdI
	 Mq7FDcIi2yj+kGBpBBYC3rimFyvfhSQUSHOQBjgU7opSKnDTW+ZLyyS0/bj7wPGr4hPsH
	 OOHdBP6FKrYYuiHP4y/aL0xHxrP+iMLChg6VgvJlZrXxvsWKIZ8SnL9+XcXeAB1FBrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W7W0MsWh;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C014606A31C
	for <target-devel@vger.kernel.org>; Wed, 11 Nov 2026 03:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C014606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W7W0MsWh
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so1568001a91.0
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 19:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794366404; x=1794971204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
        b=W7W0MsWhl2pdpNVYjWLOyyPFheedfMFbCq2aybaSoFL5RextMQgVc6pOy/1WqmlFDC
         K0TPARUDnzD3ilY7LHrBTMS+oRCi0LKl1GOYON41ft9nx3sGcLgCr2hfXJLs15eAaBJq
         SWv5ExgvJDJZQJwicIW/PRABJsVsET3o6my4ONLHK3o2KbKrHUkmwIOeYIxp78YSNXqN
         XPjkS5kjqi7LOivq2fbzhJNsBq3wT0SIumqqiIqk3qVDaOCMiji/Zm8lnydN2S+CK4bR
         bF5jRkco1p8NJgeeqW8Ahy6T5OlbhmIJ7n9rMUqvdKqHKozwmPyY7Zgs9QJigdXuRhoP
         4yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794366404; x=1794971204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
        b=YhFF9kEXRzbBqOmjR12meSXCCnzWzaetHPWkymVBislHDpJ4AccLCfAdhYs2ddCyDq
         8+cYYkunehLIUDPUHvoRCRfRkUsD8O3B+oVkTIBZDMRavvAYkerZP3sQ6CEzESBscI3s
         lIA1TohysBBnBJX3AFiiAAkTytPK9w6SF8l5ulCcg3qs9HCJtCy5xEfgBzHPiW/b8rwR
         sYB0t4MhMoRXLLKyo9XXToa/5OTLyVhEilO4z3QDyEbIndu4sw3kXUOt4YR5gEPzSFb8
         gDsAe5tmNN5lQyJhXZxZPI7LZDfoOfurHTJIJKdyf9vHA3Hr3+FW/RVUulfeXgL9AC4x
         Vqbw==
X-Forwarded-Encrypted: i=1; AL+hErENVw0panRAl9Prf6olMsy9LwA2lguBFRN5hmU1uL/K4S9PAakXl+jqwSV0X/izF7oLP4ZdIK+83b169N0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4OhqzyWbmTseW3Bq+gp0zWM1iDJ47fRT1ZHh3MLm4EKsK53b6
	nIJ3DZ9wJxGRvmxaO5eeAej1AqLR8/PqqEa2Fyb6Pz9ggd8qJ/M6QnMXRKgy5jbxxMMa1g==
X-Gm-Gg: AYBFou3/J7pdyE2Nj/S/qs1Mfqp/vfhYTvaGazY1Wl7sYz2hQ2uTmRpdmgvm+G2eOlA
	LmCd0pZYCFpNkFZUFAvp3jp4jk5UJhXCR271gufPGmqZ+ZXTxLjf6ghG+H7YqdyIjbHnyPdyhRE
	57eA37206sZdxw3JkcIpMbJnNDyty/uZJRDCWZG6Vi1XfnufAG9UWXJ6hX+uf1Ly0qCGEF/U+Kt
	xLgY5K+96OwHI1eMB2BSXCxoVtbqWLeJpX/joJQIeb/wx3eb1boR2gSaVXHrurSVKk4YnUxtDjx
	2+q6yjEPU5HMuphw5lUxmqHdw2WDeIeoaFzFmuZU3b6lCZgXIJQ20UYBqjAEgo2BAENYQyDOl4I
	Jtjfs4J+TVgGeRvv05knhjbJCMftzK6Fn3CTkg0KLTVBH+PwqcgVtZFv+L5WS7HwOsx26QUnMV7
	yK5Y9cCRozBe9vcYauAwhuB3ZZIn+hgwuyvLbv8vzX0DqIiVxawacXIxxpc8aYuQkYlWJ9XipUL
	BDTAhXpAWNHthoeN6TffdVJ1h2ePeNGU1ZydxnfHEcPYmEXja0rQqQlGS/hh/zbm8SbClhlQL90
	U/NzzqyxwHIWG+Y1uCchJEvjntA3c36zk4k58Tu43Q==
X-Received: by 2002:a17:90b:2584:b0:3ac:ffb8:1809 with SMTP id 98e67ed59e1d1-3b182f3eec3mr934352a91.39.1794366403744;
        Tue, 10 Nov 2026 19:06:43 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b181f9873csm667757a91.1.2026.11.10.19.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 19:06:43 -0800 (PST)
From: yong liu <pkfxxxing@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v2] scsi: target: Disable protection processing for zero-block commands
Date: Wed, 11 Nov 2026 11:05:43 +0800
Message-ID: <20261111030544.1216434-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109092744.822646-2-pkfxxxing@gmail.com>
References: <20261109092744.822646-1-pkfxxxing@gmail.com> <20261109092744.822646-2-pkfxxxing@gmail.com>
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

A READ(10) with its TRANSFER LENGTH field set to zero on a PI-enabled
LUN can select TARGET_PROT_DIN_STRIP while leaving cmd->prot_length at
zero. transport_generic_new_cmd() then allocates an empty protection
scatterlist, causing a target-side Oops, which can also lead to
use-after-free during subsequent iSCSI connection cleanup. A logged-in
iSCSI initiator can trigger this on a FILEIO LUN with protection
information enabled.

After validating PROTECT, reset the protection operation, type and
checks for zero-block commands in sbc_check_prot(). This avoids the
empty allocation and prevents backends and fabrics from selecting PI
processing without a protection payload. Preserve the existing
data-length adjustment for commands carrying PI over the wire.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: 5835812f13e5 ("target: ensure se_cmd->t_prot_sg is allocated when required")
Cc: stable@vger.kernel.org
Signed-off-by: yong liu <pkfxxxing@gmail.com>
---
Changes in v2 (addressing sashiko-bot's protection-state review):
- Replace the allocation-only guard with a zero-block protection state fix
  in sbc_check_prot(), so backends and fabrics do not select PI processing
  without a protection payload.
- Preserve PROTECT validation and the existing data-length adjustment.

Developed against f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

 drivers/target/target_core_sbc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d7..560e62cef7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -721,6 +721,12 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (sbc_set_prot_op_checks(protect, fabric_prot, pi_prot_type, is_write, cmd))
 		return TCM_INVALID_CDB_FIELD;
 
+	if (!sectors) {
+		cmd->prot_op = TARGET_PROT_NORMAL;
+		cmd->prot_checks = 0;
+		pi_prot_type = TARGET_DIF_TYPE0_PROT;
+	}
+
 	cmd->prot_type = pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
 
-- 
2.43.0

