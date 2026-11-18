Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975261;
	b=qms2VeKmXL/3JFGLLyysCcJRy1hwmsNLvy199WgalMkrImChXNNnwMq01Uqb/sJiJVqQ
	 3SuXSyLJDyJimNc2E38Da0t5ENsmG62whVbqEPtfeUkIn1nANwIdRkipXW75xwFQ5xYjB
	 quUAaQ69PgR17Kh16WDFHnLx1v9kIXTj4dncy60Jp1TBHqlXVHxSgO239swCsVLE/uyNo
	 9TAZ8bLRaOeRdLYdY+ZUh3yGgKgXJQYG5BbBgFRQnEaWEjefdlLB0/2myOklozR3GtdEZ
	 P0ddYaY2hEJL2n/+6wuIKdhKUTL+kHw2QgNPRUVmzYyHQuK+2T9OzdSJpfd96CnSbSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975261;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4EPtXfXi+2EbPL16b2IolFOUUw0gw3opbpAteqokiIQ=;
	b=RrJHXhWsp9ugvxdIP0VqyyuoY8f7WYlS3DYt8oL/ybLaGlBmVh41Dxqcin2TY0qVgSq8
	 GsMXvfg6Z/RC8Jeumbk14u3ZfdmEqqU//ZiqpArTWEXDzey69XkZs36ZK8w5VsXqWLcFN
	 Mr3qdh5rqyJv7Z+nTCN8McnApG4YmpJdLDY7ol1T2w0lD48ox4mrgmBYoDnpcS7Dl4DKv
	 4wtEx2sBe6eJ84OqjK5BmQi8cLZLugNl1UQjZv95XMVkaXMEtL8b2rB8xmNvOVlydni1x
	 4meAPDDUt0b1vpAElZug/SugrFL7YtduoVgDmSNfm37FMXFCEgwkybKkAD1nXR0IxcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="e68VGI/l";
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8FC606A332
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E8FC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e68VGI/l
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e9e53d011eso4002065ad.1
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975260; x=1795580060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EPtXfXi+2EbPL16b2IolFOUUw0gw3opbpAteqokiIQ=;
        b=e68VGI/lF+mX+6ewyRYZZQF70PyW4ZTGPd6XyBNHGF5UfNFCGzWvxhf7T0AlarGiwa
         KmACcHZ2Uv5E5Ss0LZ9uF4/ZeW5aH2EAt48TxDICUuWf9S2/6jud248EXY3ISnoa9Bs8
         LJzaC/64g5E1yEq421kRJ0gbG2rt5qizNgLo3ZSxRDuxFYUiyJcUQOeMWBeMGDg8ytZf
         yr3fb0JN6FmC6nq8SohupXIwPoTDbvkELqr5saOl63KKsPNHvO7XE6uaAwlDp+sLtnzJ
         DGcBCRpq7hawIBThhAKqpxoa2E8tU+XxFG1Xx0w09pjR7RRv7jwCY89/jQ1idijPWmRh
         Nl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975260; x=1795580060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EPtXfXi+2EbPL16b2IolFOUUw0gw3opbpAteqokiIQ=;
        b=iQL7msuRTBYNwUpLung20fhXnhKNiFvbsP4n+Q1FiD4EtNe9lHzVJuLEGalXi4tZmX
         PtMIZfbiMtplQTzeeAyKs4+QFAoLxUw1dHTfxPze3vDn3Hv7SZ4vPfUEexdw1Sv4hB0U
         tR3Peff2Z/vxqrsuvG8CWeq547dJcFjepDBn+1CCMFuN4gEd3VxCM4ihP0PYv6tO4rHr
         6Oq21J2sXKg6tQGo87REmJFroM1rECEHh4F2jJ8Q8ye5tFVSPN4HY5dbbdGOrF4vWteC
         Pzn11J1nTyjCxb7MLVjsZ8S1LyX8PJ1837qzeNlWeO4BZichoJWWFQWt+nQqdUKUlBFz
         gwOQ==
X-Forwarded-Encrypted: i=1; AL+hErHtFO3Lim6lKG89fmaweosE+10ky6Q9hSZIJxtnidPAj3dKSO/9wwG127M2+ie+iwdb7nUOheQeJjBQrOU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+cLYnXQy3LXb5h67rmyaK3aPL4MKEs+kThDO6OO6tfqq+3wD4m
	GoS7MppMXx0uwfaP458WbnS+xBHzZs2gy9ASrWTaRI/zWeR892TkCs6r
X-Gm-Gg: AZFdTZdkuyeY/Fz+dvQfQSisOx1rsgQSkylI4A8/fg7MaOigoSV6EY10bj/EMV6tdNl
	6sXAcnF1cvS/yERhnMGkU5JoQ4nChfPvrKifQw4RgmQPlS2YAQEQAZemoeTRFVhwytoNQyTEj+7
	dzLoN45KNFJg8Cc0o7vDpE4eplblof7fXZbnn+KeRSA9Htb6MdfcSG7S789YUkEprApFZ+aMNlH
	4rQ+nOYryiWtPLFwf6YHN9Hd4qCpis6quoHEwmq506gHPib/PBsy+8Fumu4nuyr9ymAsnCUO+m4
	g9wHWy2XVcoyH0zA/oi12RZGItIQ6Jw8i0vCsz9KtWGQeyp0vjOJzU2aZyzSsQLDnI02Oi+AT5S
	gOQDfkx4tNi4h2GxVGa79kkHCkSq3bIlxzlYyhBvEIMWC6ekwqEiTiLoTb17okQLqhMAZvukBVI
	qd0VGOugHotfkgkzdqa0F8BrLSrr3okj72wLZNS1vcQUffKu1xoEs+s6/rDPQrPg2oX7Z/ORHWq
	+YZBe9C9wWPrJbg9MnitgrvZ4c9KrKHC+vD6xOU73DAZ0Yc2Kq0MPTopSjBS+KVoVfNSW+J/7xB
	qYj7zTFdl9jFOpSZTQ3+7w==
X-Received: by 2002:a17:903:b90:b0:2e6:1c21:158d with SMTP id d9443c01a7336-2eff756cb48mr15064795ad.50.1794975259936;
        Tue, 17 Nov 2026 20:14:19 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:19 -0800 (PST)
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
Subject: [PATCH v2 6/8] scsi: target: limit DIF block CRC to each data sg
Date: Wed, 18 Nov 2026 12:13:09 +0800
Message-Id: <20261118041311.19011-7-physicalmtea@gmail.com>
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

sbc_dif_generate() and sbc_dif_verify() start a CRC from the current
data sg and handle one transition to the following entry. They pass
all remaining block bytes to crc_t10dif_update(), even if the next sg
is shorter than that remainder.

A 512-byte block split into 256, 100 and 156 bytes makes the CRC read
256 bytes from the 100-byte entry. Walk the remaining entries and
limit each CRC update to the bytes that entry holds. Share the walk
between the generation and verification paths.

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
 drivers/target/target_core_sbc.c | 54 +++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 360a9af0cf66f..e752b23b1bef7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1308,6 +1308,44 @@ sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
 	return true;
 }
 
+/*
+ * CRC the rest of one logical block.  @need is the byte count still
+ * unread.  Take only what each following data sg holds.
+ */
+static bool
+sbc_dif_crc_rest(struct scatterlist **dsgp, void **daddrp, int *offp,
+		 unsigned int need, __u16 *crc)
+{
+	struct scatterlist *dsg = *dsgp;
+	void *daddr = *daddrp;
+
+	kunmap_atomic(daddr - dsg->offset);
+	while (need) {
+		unsigned int take;
+
+		dsg = sg_next(dsg);
+		if (!dsg)
+			return false;
+
+		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		if (!dsg->length) {
+			kunmap_atomic(daddr - dsg->offset);
+			return false;
+		}
+
+		take = min_t(unsigned int, need, dsg->length);
+		*crc = crc_t10dif_update(*crc, daddr, take);
+		need -= take;
+		*offp = take;
+		if (need)
+			kunmap_atomic(daddr - dsg->offset);
+	}
+
+	*dsgp = dsg;
+	*daddrp = daddr;
+	return true;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
@@ -1356,15 +1394,11 @@ sbc_dif_generate(struct se_cmd *cmd)
 		avail = min(block_size, dsg->length - offset);
 		crc = crc_t10dif(daddr + offset, avail);
 		if (avail < block_size) {
-			kunmap_atomic(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &offset,
+					      block_size - avail, &crc)) {
 				kunmap_atomic(paddr - psg->offset);
 				return;
 			}
-			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			offset = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, offset);
 		} else {
 			offset += block_size;
 		}
@@ -1543,15 +1577,11 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 		avail = min(block_size, dsg->length - dsg_off);
 		crc = crc_t10dif(daddr + dsg_off, avail);
 		if (avail < block_size) {
-			kunmap_atomic(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &dsg_off,
+					      block_size - avail, &crc)) {
 				kunmap_atomic(paddr - psg->offset);
 				return 0;
 			}
-			daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			dsg_off = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, dsg_off);
 		} else {
 			dsg_off += block_size;
 		}
