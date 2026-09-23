Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25561531AE5
	for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169209; cv=none; b=NxENxpIw9u4kJOtPImtIUceSERHea9Zmdi4Ho8e3x7eY0gL0CVYU635Y+WJ/384vXhUfmjncLQz/fDJDO1RCnwSfK8jZ5ihitUEqOVnBOPeNd8vFb5dagcGH0CfnD+12awvUCGJUZUIxelXL9vDGr9qBQ0XLs0hZkV5NTi4Utn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169209; c=relaxed/simple;
	bh=II6lr93DMg9hJaSLm8z69j9Y0iee9yw5A9DTDMf4bQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmVylJXiUcXxn71FlCyHdqh0rCVuFZo2ROtgOWpCgtMZgMsAjPDgIppbAgxDkCeDTAlTx1mUEg/hX3idyAaJpbL0Tqs1X7iea/5xzSApcOGFVaUDqZbJQbI8hWhVtIF58Z1xsJ6CM12ctuhZ4bf4ok0XbYnWvugLndq1S3ejDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kU0vMsuK; arc=none smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kU0vMsuK"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-47b8afe046dso570365fac.2
        for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169206; x=1790774006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mQYxSBPSGsPGEpCxfkSkSGM9Wdwhb7nPmrXw81ANLdI=;
        b=kU0vMsuKteMPPQ/3hlyEZx63hvWccEeH9bb/AhG2W8fdrSCA0oCWVqy3nLIBNoWs/z
         Hu7gZSnsnE5V6DZIrRVPy+eqh37GDvU/Ipk7rPSiUMbl5uZOHceiN1GSJgQ7JVM2Eh0G
         Jb5WBeI43c1G6BvJFnmebsqQuTUNqIiLyqF5c54nIuklWeqvmJOoqKyK5QFIf454+NIN
         zgkMtAxIirjB5Ppw4MjagH4l71FRsXrIelMYVLCGdxVii+VueSNxN2mExBg8i+6uLJi2
         8+bAtmTap8H2nyzL2d6h4wfWxonnSyBqX4ohNWnPxxUhfZDfzyUFijBsyWddr4vZLimb
         qHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169206; x=1790774006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mQYxSBPSGsPGEpCxfkSkSGM9Wdwhb7nPmrXw81ANLdI=;
        b=jX3V5j8jkBf4E+LiFOnp7rFk5CUy9l+xC2HDa3+iZxQ+rZbEDs+uUFzKVSdZTBQko5
         6pRcPwphr7UnMLLObdWN/zpKKqlzgc5Yd0B1lRjmPFBZiCcLwtYZU9UVn8Pkd4Lj8+Jf
         U5imf40TQQHMDY7kHcsm+bU4DJzkyPWqEVY5RkSInJVvf57Tls3KF8RAK0NlKdZouLWi
         d2PCJ00JzQREaD2EnAVtoYEhAog2h5jd/yJMEmZhJeB2OJQ3Jrv54w1EVypyESflA8/P
         KDypfqrD2M5NVw7qnsSkEuCFweNrLukPIPcqPDRba/KEnP24Muui2yAFUz9X6EXbxytK
         rH7A==
X-Forwarded-Encrypted: i=1; AKwUvByRxCPXGBq8vJ9YZavBQ6EHGOZ9VidxvsNE/d4ZOqtL3zKOoz/wGHXiN62NoemOWXAskC2/7Zlvg39azsc=@vger.kernel.org
X-Gm-Message-State: AFuF++kxjk617XdWiyDXdcDzi68Ct58K9pu9FQTsHegpgYCUYVu+pYMC
	eWErZlgmGuU0tC7CDf6mVx4UWWoBrREcf48RhhKcyRKY43+iEke3Vhpz
X-Gm-Gg: AYBFou1XDVk4xULYTwZuYOE5O6a44DTqhVLi0d/hBttUxdBHBW5zKlbl73uKJGj4b1M
	4yJPpU9ka+c+VzwPeeLXpb7RTa8L4gFl7q2Kflwz5xM7/uq9rnlLAEi8PN9dqxbt2YqiR10KJhv
	SbsYHWsqYLI1Dm5qLjts1BUPsyZw9eMy9o9VqauuROsrpMJz9WH6uhBLv3/cHffvgDJs8p/GS6u
	zyxTpmG3+Rc3gUq8KiFOt4eoodp+5AdlNXpXqrA4ZLUdMs5oHP2CVWn5NJGwgPQDNr8KPVPs0Ui
	w9Cyb6RbIWeEBuyrK0vO0LxAuzXlLMHJs76O2fdVJJZlxDS4rOuCTF6yQZeuHkXBMaG9kHYezDn
	dm4RHnFyZwssrxgyeylwRmVwK2LV9KCgVjFzdl/p8Cuu+vh4FLablIwX1imNbVZrmO02+JIuEWv
	MOxV0yftn7tbjzWV/tT6cHvPVrQWnFFsw2+/Qym0byapCAbZ3qsSd2vpkwuSmiT3k5ZTn7RlRvb
	X35CeZR62golXLogvosFYgIt/WCQVmyrxT9ov3F
X-Received: by 2002:a05:6870:9129:b0:48f:e0f6:bd68 with SMTP id 586e51a60fabf-4908c5f00c9mr2317244fac.57.1790169205681;
        Wed, 23 Sep 2026 06:13:25 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4908e54f277sm1599838fac.7.2026.09.23.06.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:13:25 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH 2/2] scsi: target: core: Use kmap_local_page() in SBC emulation
Date: Wed, 23 Sep 2026 08:13:19 -0500
Message-ID: <20260923131319.310123-3-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923131319.310123-1-danishkhateeb03@gmail.com>
References: <20260923131319.310123-1-danishkhateeb03@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmap_atomic() is deprecated in favour of kmap_local_page(). Convert the
kmap_atomic() and kunmap_atomic() calls in sbc_dif_generate(),
sbc_dif_verify(), sbc_dif_copy_prot() and compare_and_write_do_cmp().

The mappings already nest the way kmap_local_page() requires. The
protection page is mapped first and unmapped last, and the data page (the
rd protection page in sbc_dif_copy_prot()) is mapped and unmapped inside
it, including on the early returns. compare_and_write_do_cmp() maps one
page at a time. The code between map and unmap only works on kernel
memory with memcpy(), memcmp(), the CRC helpers and pr_*(), so it does
not rely on page faults or preemption being disabled.

Apart from dropping the deprecated calls, this lets preemptible kernels
preempt the guard tag CRCs in sbc_dif_generate() and sbc_dif_verify(),
which run inside the mapping of a protection SGL entry: up to 512 blocks
per page of protection information, 2 MiB of data with 4 KiB blocks.

Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---
 drivers/target/target_core_sbc.c | 56 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 55a8c2f0a286..2c79bca5f6e4 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -406,7 +406,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 	ret = TCM_NO_SENSE;
 	for_each_sg(read_sgl, sg, read_nents, sg_cnt) {
 		unsigned int len = min(sg->length, cmp_len);
-		unsigned char *addr = kmap_atomic(sg_page(sg));
+		unsigned char *addr = kmap_local_page(sg_page(sg));
 
 		if (memcmp(addr, buf + offset, len)) {
 			unsigned int i;
@@ -418,7 +418,7 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 				*miscmp_off);
 			ret = TCM_MISCOMPARE_VERIFY;
 		}
-		kunmap_atomic(addr);
+		kunmap_local(addr);
 		if (ret != TCM_NO_SENSE)
 			goto out;
 
@@ -1222,8 +1222,8 @@ sbc_dif_generate(struct se_cmd *cmd)
 	unsigned int block_size = dev->dev_attrib.block_size;
 
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+		daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 
 		for (j = 0; j < psg->length;
 				j += sizeof(*sdt)) {
@@ -1232,26 +1232,26 @@ sbc_dif_generate(struct se_cmd *cmd)
 
 			if (offset >= dsg->length) {
 				offset -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
+				kunmap_local(daddr - dsg->offset);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					kunmap_local(paddr - psg->offset);
 					return;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 			}
 
 			sdt = paddr + j;
 			avail = min(block_size, dsg->length - offset);
 			crc = crc_t10dif(daddr + offset, avail);
 			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
+				kunmap_local(daddr - dsg->offset);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					kunmap_local(paddr - psg->offset);
 					return;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 				offset = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, offset);
 			} else {
@@ -1273,8 +1273,8 @@ sbc_dif_generate(struct se_cmd *cmd)
 			sector++;
 		}
 
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		kunmap_local(daddr - dsg->offset);
+		kunmap_local(paddr - psg->offset);
 	}
 }
 
@@ -1336,18 +1336,18 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
 		unsigned int psg_len, copied = 0;
 
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+		paddr = kmap_local_page(sg_page(psg)) + psg->offset;
 		psg_len = min(left, psg->length);
 		while (psg_len) {
 			len = min(psg_len, sg->length - offset);
-			addr = kmap_atomic(sg_page(sg)) + sg->offset + offset;
+			addr = kmap_local_page(sg_page(sg)) + sg->offset + offset;
 
 			if (read)
 				memcpy(paddr + copied, addr, len);
 			else
 				memcpy(addr, paddr + copied, len);
 
-			kunmap_atomic(addr - sg->offset - offset);
+			kunmap_local(addr - sg->offset - offset);
 
 			left -= len;
 			offset += len;
@@ -1359,7 +1359,7 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 				offset = 0;
 			}
 		}
-		kunmap_atomic(paddr - psg->offset);
+		kunmap_local(paddr - psg->offset);
 	}
 }
 EXPORT_SYMBOL(sbc_dif_copy_prot);
@@ -1379,8 +1379,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	unsigned int block_size = dev->dev_attrib.block_size;
 
 	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+		daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 
 		for (i = psg_off; i < psg->length &&
 				sector < start + sectors;
@@ -1390,13 +1390,13 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			if (dsg_off >= dsg->length) {
 				dsg_off -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
+				kunmap_local(daddr - dsg->offset);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					kunmap_local(paddr - psg->offset);
 					return 0;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 			}
 
 			sdt = paddr + i;
@@ -1414,13 +1414,13 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			avail = min(block_size, dsg->length - dsg_off);
 			crc = crc_t10dif(daddr + dsg_off, avail);
 			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
+				kunmap_local(daddr - dsg->offset);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					kunmap_local(paddr - psg->offset);
 					return 0;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 				dsg_off = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, dsg_off);
 			} else {
@@ -1429,8 +1429,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
 			if (rc) {
-				kunmap_atomic(daddr - dsg->offset);
-				kunmap_atomic(paddr - psg->offset);
+				kunmap_local(daddr - dsg->offset);
+				kunmap_local(paddr - psg->offset);
 				cmd->sense_info = sector;
 				return rc;
 			}
@@ -1440,8 +1440,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 		}
 
 		psg_off = 0;
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		kunmap_local(daddr - dsg->offset);
+		kunmap_local(paddr - psg->offset);
 	}
 
 	return 0;
-- 
2.55.0

