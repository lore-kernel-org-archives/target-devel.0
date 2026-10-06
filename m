Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F04B3D891F
	for <target-devel@vger.kernel.org>; Tue,  6 Oct 2026 09:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279291; cv=none; b=IX6NnX4FRXYta5SfY2PSQB1R4WRxSWao1rUwvLRaRNKlJTxZMUGwvhb7Jc7DZBwtRn5bu4yZiYce/11WHVbJZVx+tAnhVLimr0r9urhlnd7vvKcEnF6evwIzhMsQedbMvtvXAtjQGgS+9VJeX61BMfeaWr+OL59v/YqmbA12So4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279291; c=relaxed/simple;
	bh=K1Cdy0hZLUv7y3GkdQGg491Yxdx0wxO32Vu+2QYlCcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XsfxSZ2Iucjw8YtuzKhqZd5bh4LDOCQDjW73KKsEtcOxNZ53KkagiV+JAU45qN8A3mf82qezdRgUBPV6XdHx/oWkhTrFjqXVXj0VDVTL8llH0KHiiRNL5IW64tarRciXDs3ZGm9L9oHsZGVdQje1FJ+DFDu9poBl0No3dpIDidQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmbH++Q2; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmbH++Q2"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so217109a91.0
        for <target-devel@vger.kernel.org>; Tue, 06 Oct 2026 02:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279285; x=1791884085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cL2jFqv3JPAJHulSvum0HPm0fQ5nZHPbZHfKCLsG7HQ=;
        b=FmbH++Q2Q4k/xIr9KgqRdDqC3nC1znkFPCfirIkSoCrxxKXwgnZll/WfU2t0S8XGUt
         sSOOSA3Qsi9p6uVfqW8G/12SpgM/zO9pO9pMyMg+dgZrMxskX3DAqHPWEfbZho72iUpO
         kLRgqWbKNWX5xGMmOh+x4Dc5DvYKU0rZuV45ctqotZYVwSdf/FC9HLcQNeL5u+mtjIC4
         o0TYBlXJ9cj4ZncBtwC2hOA/BS3bgFiIsTfU+tCTzM0YKMr+LLibgC/ODzRobkAm+34r
         SClfDUtMFpvqIvt6tRTH1RLgscNsAcvbHyj5J/qetOO0z+VqVrQvvjdeAuZRskNa0XjL
         5RjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279285; x=1791884085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cL2jFqv3JPAJHulSvum0HPm0fQ5nZHPbZHfKCLsG7HQ=;
        b=mF1eI7+Jg1MFIUreIAyt8/2b4PjbUKSxRaR7svwHOQ6GMI/Z/vMqu33WebfpBN857L
         i+akdNJ2n8P7kdFlrkuUw0u52X3ya7pHOetv2ORBdnklhoKJRXZ1dsHOoJ0ArQAizuDc
         BwOP0Wii/im2F0QJVd1L2cP0HcEkvWP9CBd5QTTSmHVVov0+7m5ix1XKHJCQEhvTM+jy
         gZ2FgqFo4FcItKCEQblJxokvvXYB54WcfoMtHmgA6GMZegNZEmfajZELhLKGcVQotrlU
         VQSJD/YMwyu+gkI3YfDeDXzfDPHIuwd1G4fYDL8KfjfvZG4J04b0ZFHMv2nARDZpFIir
         qxvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzop2G3AcG6kA/g3y21GZ81cWzGxTF05SJFNtUk3nkCCZSzAR2OgBhobHkoV3bAueD7xB/LKQcVPWlHEw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKMqvtxgOoAJb5ObdIQqED3S9TcOejf9mCVb9NkA7zOeqq3M5lc
	Y/3xNdfx4r5eYotJju5LZy5Yl91X1a0fSWYozu7Uv3vxj9lrPPvzN5dG
X-Gm-Gg: AYBFou2tmqee2lb9rInig31IdXeU5Qwm+0anx3a7Cy3eWfS9mQ0ptjzpXBlzArQHo9E
	1AW7v63cx5Bxu+4FrTyVlLUAchXKQSOYpW8gRj3JxffEM9021rmcQpCH3z7ykGHP5aV3wgPsRa8
	g1i2EM+yt8REswMPwKxqmTsWb9TXHEfV0bxqfeZk5SDgPxM01qOYhRGZ3kQ4X91WDZNj2ukxk4P
	eQJ60ZdgsaPWYoAbFaNpf2018RYbgxPLHcwovpCXU39hWThCwhVUicddhI30lJ/0v8NWqFbtTfo
	QOk7VJ/fY96DiQLKzq+zaFn4fonyg2B36HgK7wuZuwtvSKIPlZgy7ep7oiITFqn6uxBHrZgbbK/
	Mv4x6MB6i1PNctpTHnrJas36dQASvKWT6Rvn6Cf+NdEafF14eraKnV7kQqBVIxXlVUck8i8J5uD
	l0BDYa+V8bYKQX4Li4NeYnKa/k072wthoX5B3QAFFRSqThbJQDDnTtiv+cp68OD3K6w0u/2A==
X-Received: by 2002:a17:90b:5101:b0:3a8:6b84:234d with SMTP id 98e67ed59e1d1-3a87254fb70mr329706a91.6.1791279284761;
        Tue, 06 Oct 2026 02:34:44 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:44 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 6/8] scsi: target: limit DIF block CRC to each data sg
Date: Tue,  6 Oct 2026 17:33:36 +0800
Message-Id: <20261006093338.27342-7-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sbc_dif_generate() and sbc_dif_verify() CRC one logical block from the
data sg.  When the first entry is shorter than the block, the remainder
is read from the next entry with

    crc_t10dif_update(crc, daddr, block_size - avail)

That length is not limited to the next sg->length.  A 512 byte block
split 256 + 100 + 156, with the 100 byte entry ending on a page, reads
156 bytes into the next physical page.

vhost-scsi can build that layout from one guest data buffer.  Software
verify and software INSERT both use this CRC.  Walk later entries and
read only the bytes each one actually holds.  The helper unmaps the
current data page and may leave a later one mapped, with the same
kmap_local_page() calls as the rest of the walk.

KASAN reports:

  BUG: KASAN: use-after-free in crc_t10dif_update+0x91/0xf0
  Read of size 1

  crc_t10dif_update
  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork
  ret_from_fork_asm

Fixes: 18213afbd8ce ("target: handle odd SG mapping for data transfer memory")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 54 +++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c0aeb8886743..76dbc986e887 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1310,6 +1310,44 @@ sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
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
+	kunmap_local(daddr - dsg->offset);
+	while (need) {
+		unsigned int take;
+
+		dsg = sg_next(dsg);
+		if (!dsg)
+			return false;
+
+		daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+		if (!dsg->length) {
+			kunmap_local(daddr - dsg->offset);
+			return false;
+		}
+
+		take = min_t(unsigned int, need, dsg->length);
+		*crc = crc_t10dif_update(*crc, daddr, take);
+		need -= take;
+		*offp = take;
+		if (need)
+			kunmap_local(daddr - dsg->offset);
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
@@ -1358,15 +1396,11 @@ sbc_dif_generate(struct se_cmd *cmd)
 		avail = min(block_size, dsg->length - offset);
 		crc = crc_t10dif(daddr + offset, avail);
 		if (avail < block_size) {
-			kunmap_local(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &offset,
+					      block_size - avail, &crc)) {
 				kunmap_local(paddr - psg->offset);
 				return;
 			}
-			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
-			offset = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, offset);
 		} else {
 			offset += block_size;
 		}
@@ -1543,15 +1577,11 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 		avail = min(block_size, dsg->length - dsg_off);
 		crc = crc_t10dif(daddr + dsg_off, avail);
 		if (avail < block_size) {
-			kunmap_local(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &dsg_off,
+					      block_size - avail, &crc)) {
 				kunmap_local(paddr - psg->offset);
 				return 0;
 			}
-			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
-			dsg_off = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, dsg_off);
 		} else {
 			dsg_off += block_size;
 		}
-- 
2.34.1

