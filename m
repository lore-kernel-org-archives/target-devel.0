Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975257;
	b=5t7S78EqXwSYo4XLtKUnwh/Wsn0uK9+e/x0uoDc9MntgTtyjZEcOKCfMy3zkg05vzbib
	 Jn3wQp37vjpxISY9ZGpeASMwI3SMHmK2a+DqH60yYfiMlBnbjmwG4vqMrhOeYCK3T8ofw
	 u0+peXgPW+mwfWfyuQirBBEtfA4yJDM2Y+ERP67gaHh1nBSYXX1zxkzU2szKD6KQ4jtvg
	 U4YA/wKM9Ae+wgv0qhcf3akmwL67Lm7ndJhKRYiVAfWQlFIvE0k4oK74IyT+v5Olg4yVD
	 KYNYWC7Ct+QmAd6hsEcLr4rW6hA21QltXp5GcPLVQh8sEPVsB2UfVZjDNjSejWOh3AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
	b=Ms3SWni23u4FxboXxI+LSLqdmKv4IGoefTXfAYnjK9zztbsaOPyTkLA7yP4mDA3Z2vmJ
	 AMax+PTEJkqm64xumVGFJxqJa1snEyBx1eHN+X42ke9SIJrH/BCflSgOreRDz0iax4nXJ
	 bLwMB9eDvkuYXOkeU90CIkJd34jStjxDbaoksUMmdlK9o2BCLniClwOBcOdLgAGrqcBo1
	 9AIKA84HK1wx3UWEHT/oK1hckA4IjsWMs0U+nOH50ZmhArRFeKgTOzK3d798j6ji0xThB
	 IuC6JeO15AkIZ9IuotKNQHIWRt8md4qiV/3URE+d+Hrmxf8Zm6lfHh2LXcZjDqme6Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDRbmZmF;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0CA606A33D
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE0CA606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDRbmZmF
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso3695015ad.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975256; x=1795580056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
        b=IDRbmZmFpODZX2t0AiqXHjmXH+UuD44aleFs8mw8Rgrspkue5Xq6jAAQhVPB6TJRvM
         BJ9/4TU7RckWxXeLIbETYdFw2NsOGoxJSxlaydVDd3tcrRMIoEOrbZ/bOYE5eyc+4fhK
         g91sSiBZ48odmrz55yPQovvLiGKkw3LrjX4nh1W/X11lI5htjPuvFqk3ZBD8ln7Qrwwg
         qzfHm+TjG2oXfiXDciZkFxK5exEUrRqRgGO+8zeaTdTOyQhOpjeqW5n0KtDLFI5G/Nfu
         sKQk+c/KpQVjPL0rRM/WwRRteGa4RAiPREgDUdMmww2OraRlCutzjS1DvQweLo7K4CzW
         XIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975256; x=1795580056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iArswCvl2LjsC7ZL9+rF2SjrTBAncR4rm+LB5wFBbbM=;
        b=psq9FgIFBGWYbhBttsuJDTpchAAyNBKrxrkiAygWaDug0/3A77J8C0jx2fcicY3WYV
         PCaO2ITbdeyk5zkxHRGausczAviEwE6O1ApWjh5Zf9zVfAtnGM4DCvZ9EMfZWXWfPB7t
         Hxnnh0E5/7HGUnke17mArryeTi4ZXrH9V7V3ZTmh7s9zgBJgNk3MjBdn4EPdDKGfHPem
         3uha5wDZ3CAVI5Ge9WulOQbcjsxShLPfBO7MYntEdPDr5FLK76gm1Z+iQgIW49K7ZC1x
         IrNxItyHFzNR1dqDd6fnjS4b+ApFBj1RoStiIDbHnGKVsnpk4cOZxC7hMLBDanKrtuLF
         SacQ==
X-Forwarded-Encrypted: i=1; AL+hErFH2T8zVzpT2RjdNyz+v53Z55wGv9EySfXa/8uTbJAdP2Z/H7fGjyJX7PqbglAHwDiGO6jUTyPmPv9zkzU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8hgaSXjE/KmXcpTKf/r78qbv2RoVMl99AxndJHzZpusgmDZSoT
	iZCd4hP4Ea92w/gfqaGVtF8uy8vbqtCC1S+gdnIGqXXR3uvAlAm+HSsY
X-Gm-Gg: AZFdTZfGGwuuakaHQ24O73z1xugX3WDGeNgJdWA9zxkDzeWdDL0iriCllL1HSuoOkKq
	GZdSCIRNxKn7SoICHmDWtO51VAMiEEyttlcgGadC6SaCCQPy7y7nAL5GwBCRc9phi1H/T4i2dQu
	HeG8NTC1poiaed/gUnb22GvrqSdajZTfq7UxFW3lxADyHwQSrDCY1eEq+5ofj3wspA5MBU6AOVl
	7INsR5mZCEenaer09xjFDeH8Y0GqJC2fU6XpTO5JDt6dgKrfhN3eSmWBpRtIfvxSnTqerMqxayv
	70zkX/SwUIcHPiEzdTd8/eRRLiBhK2KStUbphsjZSMiaVmc93lpmr/Nz1tgzbleWVT938ft/Yta
	c76tzwDlfFFzw+mBZjaD+hUg2YfS536JfTpdFk6YutVFSOCQrnXGbn7YlrnIFjOpI9MkWIQdFba
	7eNBqs22fUpKPaMCa+fF5m3rxZfe+mZLtrzaEUB9FHKQLrJisDtGedG3oRWIuyB1CDoqTQ4fUjf
	idVhiIf2HWjJWMZMnWqC4HD0FUA/cHB6nAbkD6FGEhfhw44EZVsl9qgOXC+jZ5sm5RdJ3MRNXT8
	m47XGBD3wfGgHKyot4Fg6w==
X-Received: by 2002:a17:902:e54b:b0:2dd:ad74:ac28 with SMTP id d9443c01a7336-2eff73f8febmr13805005ad.26.1794975256187;
        Tue, 17 Nov 2026 20:14:16 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:15 -0800 (PST)
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
Subject: [PATCH v2 5/8] scsi: target: copy a DIF verify tuple across prot sgs
Date: Wed, 18 Nov 2026 12:13:08 +0800
Message-Id: <20261118041311.19011-6-physicalmtea@gmail.com>
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

sbc_dif_verify() enters its loop when any byte remains in a protection
sg, then accesses a complete eight-byte t10_pi_tuple. A tuple split
across entries can therefore be read past the end of the current sg.

Use the tuple-copy helper to assemble a complete tuple before checking
it. If the protection list ends partway through a tuple, return a
guard-check failure. Keep the data-cursor adjustment ahead of the
escape check so consecutive escaped blocks still advance the cursor.

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_verify+0x5ab/0x790 [target_core_mod]
  Read of size 4

  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd

Fixes: 41861fa831af ("target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 112 ++++++++++++++++---------------
 1 file changed, 58 insertions(+), 54 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 780f526c4d931..360a9af0cf66f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1491,81 +1491,85 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	       unsigned int ei_lba, struct scatterlist *psg, int psg_off)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
 	struct scatterlist *dsg = cmd->t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
-	int i;
 	sense_reason_t rc;
+	unsigned int poff = psg_off;
 	int dsg_off = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	if (!psg || !dsg)
+		return 0;
 
-		for (i = psg_off; i < psg->length &&
-				sector < start + sectors;
-				i += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
+	paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+	daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
-			if (dsg_off >= dsg->length) {
-				dsg_off -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	while (sector < start + sectors) {
+		struct t10_pi_tuple sdt;
+		__u16 crc;
+		unsigned int avail;
 
-			sdt = paddr + i;
+		if (poff >= psg->length && !sg_next(psg))
+			break;
 
-			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (unsigned long long)sector, sdt->guard_tag,
-				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, dsg, &daddr,
+				       &sdt, false)) {
+			cmd->sense_info = sector;
+			return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+		}
 
-			if (sdt->app_tag == T10_PI_APP_ESCAPE) {
-				dsg_off += block_size;
-				goto next;
+		if (dsg_off >= dsg->length) {
+			dsg_off -= dsg->length;
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_atomic(paddr - psg->offset);
+				return 0;
 			}
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		}
 
-			avail = min(block_size, dsg->length - dsg_off);
-			crc = crc_t10dif(daddr + dsg_off, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				dsg_off = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, dsg_off);
-			} else {
-				dsg_off += block_size;
-			}
+		pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
+			 " app_tag: 0x%04x ref_tag: %u\n",
+			 (unsigned long long)sector, sdt.guard_tag,
+			 sdt.app_tag, be32_to_cpu(sdt.ref_tag));
 
-			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
-			if (rc) {
-				kunmap_atomic(daddr - dsg->offset);
+		if (sdt.app_tag == T10_PI_APP_ESCAPE) {
+			dsg_off += block_size;
+			goto next;
+		}
+
+		avail = min(block_size, dsg->length - dsg_off);
+		crc = crc_t10dif(daddr + dsg_off, avail);
+		if (avail < block_size) {
+			kunmap_atomic(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
 				kunmap_atomic(paddr - psg->offset);
-				cmd->sense_info = sector;
-				return rc;
+				return 0;
 			}
-next:
-			sector++;
-			ei_lba++;
+			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+			dsg_off = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, dsg_off);
+		} else {
+			dsg_off += block_size;
 		}
 
-		psg_off = 0;
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		rc = sbc_dif_v1_verify(cmd, &sdt, crc, sector, ei_lba);
+		if (rc) {
+			kunmap_atomic(daddr - dsg->offset);
+			kunmap_atomic(paddr - psg->offset);
+			cmd->sense_info = sector;
+			return rc;
+		}
+next:
+		sector++;
+		ei_lba++;
 	}
 
+	kunmap_atomic(daddr - dsg->offset);
+	kunmap_atomic(paddr - psg->offset);
 	return 0;
 }
 EXPORT_SYMBOL(sbc_dif_verify);
