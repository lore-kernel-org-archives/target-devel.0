Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE4B53163B
	for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169207; cv=none; b=hDwqAo08ugX2Dau5EknLm6Rc7sHnDpfJ2qwBkR6iK4yDWaIIvLGloQWboqNJc1uAfr36XvNlxsZpMX8GGnHbkkrruYaxQdhnAeWugQ5DouRLJmhBXyLTd/VhUPgzwMhDzvSmDTXUmfPTNyKpWUVgiUUgNzLQ40B6HRstO/Hbm7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169207; c=relaxed/simple;
	bh=wJPbewVAsF07/WKXUvjLddxh2zDS4t1o5x9ugWJR6EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2YO0a5qjiwhNd3zWFyexATw7xHreDtO/rJwudG19ui/2sj0cuu7D+p6Ew46P5JS0+6nM0FVBuRnA0Cw/F3DUi/wRWC0DebDwhtEC8MMUT300VhXcWt1/Gwe2KiuCSrCfSdafeBAJoMcC9mySWqTscbsKr4JcqWF/+vw1+NZBdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=orjoyvcP; arc=none smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="orjoyvcP"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-46accbdfc39so824930fac.3
        for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 06:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169205; x=1790774005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GWcsyWerzXtmqpdXsdvwUzYUFNtc0z30AKuwtSX4TlE=;
        b=orjoyvcPw50EmeaJOqhxKIZRhoxLAo0uWIso4JrS2ty7Fu2oIiC2cuNQ/IKlbXs7FK
         2lpXLkPr7Zxtq37lmWZK3N+wK1/skKq0e3PfRzjhj3K476kaBYLA5EVrWqoOTcNcmqS4
         LCntTxW5YLc6VMFlJsvmlmtAR/Myf+UpG8V0JtdVxdMqV6SE9/JLVs5DsqBJlJ+JJJM4
         +hGxyh4VPZ3yVH2UzHwyMRuhfsIn9yIrfbawgcDG+ZjJePnuM51SG/oH0d343SUcTNi2
         lrj2jEwh1YXwMIv17s3Te6U6kMhuwiy+e1tE6yD7MOC1128R1WcfsGzSgOc/28osm8fT
         REQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169205; x=1790774005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GWcsyWerzXtmqpdXsdvwUzYUFNtc0z30AKuwtSX4TlE=;
        b=ovCrChgD19eC66iEY136UH0GIoYkdzbihLKE8EdBYdIbyUrA7khQaC4r+6AtQhcPqJ
         kcE/qCI4Jx5FzyNDr+tIT15sUiEPj2Z329kjKGVcWtIAOMACk5/i1c6Gdyq5uRHG+yMU
         ZFqOBSVgzELWV/1vb1UyqZdwnq3ZOsLk435dncxMlPueL1NJzTtcORd6q32tAhPDHmiN
         xaR81fyaCBqT6wtw4k6ayexeuVP7xXUoQYHvZoMNgWX4bGJB/67BmKmTpHzpBz/mQTpf
         HS6nx+VNCoSFYlJeQQujd+YO7Bh9H/ORMV/chuZ7f6c5+43ES4S2TvcB9TlN/qdX8Vg9
         JsQw==
X-Forwarded-Encrypted: i=1; AKwUvBxxAz16+c8o6H60uWaL5noSNdTJx6PBWe6rfeTcKB2NHWXTGqaROV6AUL5WGIA0nzYNy4ii2Qx07cty9qg=@vger.kernel.org
X-Gm-Message-State: AFuF++k0wtN08+1dPvKrnMpKN9SifFK1swvsoK+/usyvEzdzTtnRXhsM
	7tPP0YOu7R2ZuU2DhOt5v4mRywke6RRx/BMG5j+cV9fGYPAvvwtscshO
X-Gm-Gg: AYBFou08jxeOpa/a56vfD0purKQ3027+SZro/ARm4fQLn7WdM0bRXHajEoqQ+3YHP51
	8tGN+Utq1RBthlcTrRrFqa6Nz7OfpX22CiitfjcbYQ9nlSfrB8FAIf2P/UUR6IWYFrnBRzp7oRt
	B61OGRQJpenYZu6nJmgYw0N11UUZtceeo/Jhta+3LF13oEcs18R/MMlWtc3xKnyoFdR0O+OkAPa
	/bwxhHcUjWNSNU4FpLum1jFMEg4JYvgfyzhgPt4TYAjsVyxCPgZAAM7hcPGhq3O6hrjCCeiXoab
	XUghclugcjRFDGCyh/Gnx10hVnIPT8hGtd4jpGa48aRCgIC7DvoTwdfHzZWrQWsemQXv0hTd1DY
	oTcuWG5tuJ1yH5TtVA50WgDFWV9LWDDy/GyhjlW08h2RcUqJ0ls8vTDDh8Ag6S4N3U3agPyiA54
	znm83RK3iUrwBTpwnuzXxrqgdvq39Tf8zM1ZygKfsM+FOkyLTtePDeReAZfHYHhc2uwAxUw1RrH
	RzBgWfWs8tGwaYarEdB4EcZa7/rjvfF90rGiRd3
X-Received: by 2002:a05:6871:5814:b0:48f:e0e5:a1fa with SMTP id 586e51a60fabf-4908c3d6c7emr2513096fac.46.1790169204734;
        Wed, 23 Sep 2026 06:13:24 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4908e54f277sm1599838fac.7.2026.09.23.06.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:13:23 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH 1/2] scsi: target: core: Fix kunmap_atomic() address in sbc_dif_copy_prot()
Date: Wed, 23 Sep 2026 08:13:18 -0500
Message-ID: <20260923131319.310123-2-danishkhateeb03@gmail.com>
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

sbc_dif_copy_prot() copies protection information between the command's
protection SGL and the backend's SGL "sg". It maps each page of "sg" with
kmap_atomic() and unmaps it with kunmap_atomic(addr - sg->offset - offset).
The unmap runs after offset has been advanced by len, so it is passed an
address len bytes below the start of the mapped page, inside the page
below the mapping.

The only caller, rd_do_prot_rw(), passes the rd backend's protection
pages, which come from alloc_pages(GFP_KERNEL). kmap_atomic() of a lowmem
page returns its linear address, and kunmap_atomic() of a linear address
has nothing to unmap, so the wrong address has gone unnoticed. It matters
on 32-bit x86 with CONFIG_DEBUG_HIGHMEM, which selects
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP so that lowmem pages get a real
temporary mapping too. kunmap_local_indexed() then warns

  WARNING: mm/highmem.c:623 at kunmap_local_indexed+0x148/0x190
  Workqueue: target_submission target_queued_submit_work
  Call Trace:
   sbc_dif_copy_prot+0xef/0x310
   rd_do_prot_rw+0x115/0x140
   rd_execute_rw+0x354/0x3b0
   sbc_execute_rw+0x2b/0x40
   __target_execute_cmd+0x22/0xb0

and clears the right PTE, but x86 flushes the TLB entry of the wrong
address. The stale entry keeps the slot pointing at the old page, so the
next page mapped there is not the one accessed. With an rd device with
pi_prot_type=1 exported through tcm_loop, reads and writes then fail
with "DIFv1 checksum failed" errors.

Unmap the page before advancing offset, so kunmap_atomic() gets the
address kmap_atomic() returned.

Fixes: 57636388af32 ("target: Fix inconsistent address passed to kunmap_atomic() in sbc_dif_copy_prot()")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---
 drivers/target/target_core_sbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d70c..55a8c2f0a286 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1347,13 +1347,13 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 			else
 				memcpy(addr, paddr + copied, len);
 
+			kunmap_atomic(addr - sg->offset - offset);
+
 			left -= len;
 			offset += len;
 			copied += len;
 			psg_len -= len;
 
-			kunmap_atomic(addr - sg->offset - offset);
-
 			if (offset >= sg->length) {
 				sg = sg_next(sg);
 				offset = 0;
-- 
2.55.0

