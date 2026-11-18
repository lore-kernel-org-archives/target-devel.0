Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975253;
	b=F6MVwx/B42PBuc/Uh4zVRjum3Aqa0ETD9rRqtB9qR2pH1yfavRsXWscWdMUAtZRa/VoV
	 vK/pUcgV8q0eOUISqE0fI3xRvUXDmy0uS6x6CWlzcTbjLmWExktBsJ2Xn6h2hqTGgms8U
	 BQDY2vqBHExhuTcJY4xWILcmIOd3yS+B8QFUMq3I4Gx0S4Mi2BUfw7WJrGd3IsUbgEG7U
	 98cbOXyqdJZ2YLaJavRz8e2T3JP8TwVoaqZjPnup6xQdygswToDhgKIaAknQi+tvYocBE
	 /ea2ZndJZ4OnvlazrxCin1Ml7tsaVMvoYXuHOiqJA59itepVPMvI6N9qFrnMFxjlmKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
	b=etP/L6s7YoyjAmP3hb8h44A2lAcsAP8u40i5WnLduk4YwqdwLC+Pvr9dO1flwpH+xo3O
	 Y46r3F85cFTGcjE+og7grmsi9lBzxzMNvLibRy7qW7MMW9YZ7c84Aiu9dfAyexECFXbcU
	 wjzeDYtycPBCLdn5tHHSlUVIPAy/clFPxv/j4Y7B5rMp11BA7iOwoy0UbqQYAYyTpEdsh
	 D3iQLXdn1jnk9DeYViYcIAzK0JeV7y9ZWjzXBpSyTGgiywONkDNY953FqyaNfTInfRqSY
	 A5qQoGT7nuvSxQmlxa45xR5qN3l4ngL7Tl/ijfI3xrIuL91SX6e95q8+HO/NIW8djDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=btBomLH7;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C13D606A333
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C13D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=btBomLH7
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e9e53d011eso4001395ad.1
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975252; x=1795580052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
        b=btBomLH7/q5gdlk3VKgt4rjNfgc/iVqTspfJjdXjGJqKUMuDZ7snDYlVZ6ciVtTsR6
         U3Bf1z4DVXGqkKcHS9u3k3kqEWToe5gNSnJKF7NKIoEgxIG4NUE9f4vZIi2t//lo+euy
         D2HXiP8Z5Qk1WxsO0nSUl8TIUOrh+59FkRMhj2PB3ooNraE8z6Rq4wGEu6MUDgA+1Jxc
         Kat4BFMjkcLmvYyJbuOz6pVd5smw7fzOWOaY/b143FPJzJmtEqNSH8JaCkxQUq3SYm3W
         co9e1lg6wOviCfkr/SvJUKkMSJWiz68JITAFzsIOkzE+X7FA4c6xNjsbWGGvoso5G8VP
         8EMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975253; x=1795580053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eH3ClhP3K/6K4ti1IS/bnRGkykU5Vjlc6CVNj4XDITs=;
        b=Oin7tHd3ql2+9dBL7/RbCZSBSHtaPQtsNS8qj6RkOb1mGbSvy/YApzmzyl2ftuqQVL
         9KYraWUGdxrr0PgxhiOVvOFuZulmbbxhhVAzleArc9fBcqcfSOz6Yzk3QblBSvlqulMQ
         mfx3TEWAMGj+DjzlxOlhM5Tn7cLwqOmJAq4RL7RHBt5IrXq1gUGOA5O4xHUdatrfCnYb
         H/VilNXpGlaGqrzjeK4NWIeg787LMJHtxXBptkjEBUXUXP4thvLI7Wk3VRFhZfdTJILc
         USo3RJlUYXSEkR4WFiWxz59QfHAmNqJrcLvMm/qw0zmScXgGyg77ae8tuhTlxDj20gSE
         BDhQ==
X-Forwarded-Encrypted: i=1; AL+hErE1cKZfpTlfAqyLU1sGql0x/J5fo7031YWAxjrvMpYJ54drrcKIMp298Lb3nuYKp79CvNVd2fnsgu1/Yl0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9jEkvwr0fd5JMUMuL7jlSFaDbyZAAt7AXfJzKyN34I7HghrBwv
	fHNPMVNa/4HQK4GQrN+ZitUAEWZHFKQlsEzvi7uJqzCUaUsIwSqANQ5/
X-Gm-Gg: AZFdTZcBew+mYRZkXzVRMpDXt4o+yznxHsIpll9vxZ7txVOq5biB1ZebbYDVMh0bWGn
	WXPStFog84rkG50b1ITHslX1zJS0cFk4D+30gLhOSmoquilRvB4JRLCpV7uolmak346zTTTdmU7
	YNMHJALyYLqFfbr8ec2LJ8kIZzCXpv3CrVPzcSO/GodWNnnt5LMRx8O/2PhaPNyWmd4sqfQ+bqT
	rqDnyKbKx4MWctmDeMNf3O++QspafoMzjV7Q+DhR6Z7wmaJPZHlZMFraKBy0cu988bHC7aGXEnP
	ups7CU+997ZpHbp9DYsp/spbR00B4ikzhcupVnVl8JG/2759GMPJWiBJVLH3jLcVb1mr2jXEAhi
	otPPwlZR4NebXzlvwUkIiQ9AIVkILBCnpv4eTiQZHmUiExbm5plgnvJrdgJ8LV9WwzF0jc03MJU
	roHeAfDju0NDxj6qVpFcy5cdDJV1HPJiwsCpwJJdkW/i0g5aaTWQqKLPSV6x/sMqWlxyPHhc2Z2
	w8M5/rz9tolXu3evhPPE5sIEAjjtrvxAkmriBcAoVzLLyEdbJW36XCEJe/qS8vDY/Dxm5NKrcZ7
	8rs6oBTE7R8TVn0Tmr6jIg==
X-Received: by 2002:a17:902:f687:b0:2ef:d032:66fa with SMTP id d9443c01a7336-2eff73f1f15mr13070605ad.10.1794975252511;
        Tue, 17 Nov 2026 20:14:12 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:12 -0800 (PST)
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
Subject: [PATCH v2 4/8] scsi: target: copy a DIF insert tuple across prot sgs
Date: Wed, 18 Nov 2026 12:13:07 +0800
Message-Id: <20261118041311.19011-5-physicalmtea@gmail.com>
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

sbc_dif_generate() writes a complete eight-byte t10_pi_tuple whenever
any bytes remain in a protection sg. A tuple split across entries can
therefore be written past the end of the first entry.

Copy each tuple through a stack object, walking the protection sgs as
needed. Read the existing tuple before updating it to preserve ref_tag
for protection types other than Type 1. This also checks that the full
tuple is available before writing any of it.

Stop generation on a truncated final tuple without changing the
caller's completion status.

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_generate+0x20c/0x640 [target_core_mod]
  Write of size 4

  sbc_dif_generate
  target_complete_ok_work

Fixes: 66a3d5bc47d2 ("target/sbc: Add sbc_dif_generate software emulation")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 180 ++++++++++++++++++++++---------
 1 file changed, 131 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index adef903652ac2..780f526c4d931 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1250,72 +1250,154 @@ err:
 	return ret;
 }
 
+/*
+ * Copy one 8 byte PI tuple to or from the prot sg.  The data page sits
+ * above the prot map, so a prot sg change drops and restores it.  A
+ * short tail releases both maps and returns false.
+ */
+static bool
+sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
+		  unsigned int *poffp, struct scatterlist *dsg,
+		  void **daddrp, void *buf, bool to_prot)
+{
+	struct scatterlist *psg = *psgp;
+	void *paddr = *paddrp;
+	void *daddr = *daddrp;
+	unsigned int poff = *poffp;
+	unsigned int len = sizeof(struct t10_pi_tuple);
+	u8 *p = buf;
+
+	while (len) {
+		unsigned int take;
+
+		if (!psg || poff >= psg->length) {
+			if (daddr)
+				kunmap_atomic(daddr - dsg->offset);
+			if (paddr)
+				kunmap_atomic(paddr - psg->offset);
+			daddr = NULL;
+			paddr = NULL;
+			psg = psg ? sg_next(psg) : NULL;
+			if (!psg) {
+				*psgp = NULL;
+				*paddrp = NULL;
+				*daddrp = NULL;
+				return false;
+			}
+			poff = 0;
+			if (!psg->length)
+				continue;
+			paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
+
+		take = min_t(unsigned int, len, psg->length - poff);
+		if (to_prot)
+			memcpy(paddr + poff, p, take);
+		else
+			memcpy(p, paddr + poff, take);
+		p += take;
+		poff += take;
+		len -= take;
+	}
+
+	*psgp = psg;
+	*paddrp = paddr;
+	*poffp = poff;
+	*daddrp = daddr;
+	return true;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_data_sg, *psg;
+	struct scatterlist *dsg = cmd->t_data_sg;
+	struct scatterlist *psg = cmd->t_prot_sg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
-	int i, j, offset = 0;
+	unsigned int poff = 0;
+	int offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	if (!psg || !dsg)
+		return;
 
-		for (j = 0; j < psg->length;
-				j += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
+	paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+	daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-			if (offset >= dsg->length) {
-				offset -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	for (;;) {
+		struct t10_pi_tuple sdt;
+		struct scatterlist *mark_psg;
+		unsigned int mark_off;
+		__u16 crc;
+		unsigned int avail;
 
-			sdt = paddr + j;
-			avail = min(block_size, dsg->length - offset);
-			crc = crc_t10dif(daddr + offset, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				offset = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, offset);
-			} else {
-				offset += block_size;
-			}
+		if (poff >= psg->length && !sg_next(psg))
+			break;
 
-			sdt->guard_tag = cpu_to_be16(crc);
-			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
-				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
-			sdt->app_tag = 0;
+		mark_psg = psg;
+		mark_off = poff;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, false))
+			return;
+
+		if (offset >= dsg->length) {
+			offset -= dsg->length;
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
 
-			pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (cmd->data_direction == DMA_TO_DEVICE) ?
-				 "WRITE" : "READ", (unsigned long long)sector,
-				 sdt->guard_tag, sdt->app_tag,
-				 be32_to_cpu(sdt->ref_tag));
+		avail = min(block_size, dsg->length - offset);
+		crc = crc_t10dif(daddr + offset, avail);
+		if (avail < block_size) {
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+			offset = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, offset);
+		} else {
+			offset += block_size;
+		}
 
-			sector++;
+		sdt.guard_tag = cpu_to_be16(crc);
+		if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
+			sdt.ref_tag = cpu_to_be32(sector & 0xffffffff);
+		sdt.app_tag = 0;
+
+		pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
+			 " app_tag: 0x%04x ref_tag: %u\n",
+			 (cmd->data_direction == DMA_TO_DEVICE) ?
+			 "WRITE" : "READ", (unsigned long long)sector,
+			 sdt.guard_tag, sdt.app_tag,
+			 be32_to_cpu(sdt.ref_tag));
+
+		if (psg != mark_psg) {
+			kunmap_atomic(daddr - dsg->offset);
+			kunmap_atomic(paddr - psg->offset);
+			psg = mark_psg;
+			paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 		}
+		poff = mark_off;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, true))
+			return;
 
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		sector++;
 	}
+
+	kunmap_atomic(daddr - dsg->offset);
+	kunmap_atomic(paddr - psg->offset);
 }
 
 static sense_reason_t
