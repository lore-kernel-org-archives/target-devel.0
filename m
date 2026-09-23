Received: from mail-oo2-f39.google.com (mail-oo2-f39.google.com [74.125.231.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522A35304D4
	for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169205; cv=none; b=FyYUYO7ln6mpcakHG1bjKdXeJ4rF94Hf2j9g7CoH+4qCNLzQP1uliYTcFG0lXWPhcdelk2pC9TKOnZgkW5Glpd2j2wiEppLCb+zgWmDcjtaP6v3XmUc+QPtLftJStDVwywX0byhU7up8kGTidS9I8qcwmF+J+L7Jv7mgV8vZCcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169205; c=relaxed/simple;
	bh=GK5ecAyK3OXsUN1hxKCW7v5WXRm6BtLteeK8HP+W+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ssQ9ypCBG+X6G8WAcjYQ3076DBdOxV85dxhWRvxX3Tvp5rDnaXHIfvDoHrWX6YJoiWo8CqsRb7R0JW4BGQE4JWEpU6LrPMbD0GKw3hNYRtsHq1mHz19s9tRr0XRWDLWrT2/Ba1fa0rb5wuoY1YXirZ7nqleu4/c77NGFvxG/y18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHtueHBR; arc=none smtp.client-ip=74.125.231.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHtueHBR"
Received: by mail-oo2-f39.google.com with SMTP id 006d021491bc7-6b1ae6a9aeaso525340eaf.3
        for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169202; x=1790774002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nv6lEl/XuVHA69+WOwYewTTKvCN1uRHRSoP0EqmEiFU=;
        b=gHtueHBRlj/l+DD27c66zli3FQaMk6DAcAq+B4tzE4JT1ewaz2RasJOlMELzB3zNdA
         xe0EkABKvckfyAkle4Mb7EqFGn+Sb6XPoInc69+LhRU6LwyWTYuxJzR6r6E61s9ogBhs
         8PwShuXXD7mSlGfGlwfaMnCCwSow/9xRUil9FevH1UEgkj9tapKKJx2o/nOu/ooadLOA
         L02o6T6sliPhU+khVevLMG+k94zMxqTBgjV5GDvFPG3v+zJmh9IjYtjAsrJ5IzxQ+Aj3
         q58RU7eZHz32GjvQQTECfytl8EBs8Z0yOW/ArRbgYvHCTORNhRQLlfDFMrsTcujrdxpp
         BAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169202; x=1790774002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nv6lEl/XuVHA69+WOwYewTTKvCN1uRHRSoP0EqmEiFU=;
        b=aJ8CgVOd8jR9Q3zWdkx/AwOoU01eFZWXVgYPg5WPZ+Vz9mQutdt4EGgAbClYb45KH6
         Ia9xC9i28kUBOSpSJG2DldELXiDvr1DzNMN2qJfV3mZB6Z09WNCTHB0xhPz1GIfyYizA
         P61czX3/7TWMsT6C6E7EeK4ay3749r5T2IvkFyoiDdE5+bP5zvo1h4hxldh1Sjxwl3TR
         ltE7GR/vSMJNYfNTXUtOnFduuxipA22sIKRs30KoRfeiJxwao4qQC08XUNLc47RwUATw
         ZrAWSlVfBKbHXtflCoyaKYF+jx/N3swBB6TlDzeMh4fWfXvagT1GM/jNq7JYgck51hKV
         mySg==
X-Forwarded-Encrypted: i=1; AKwUvByUTtlNmvGPsjhDV+SV458D35mpjD1eSSTM6zk+vgeDRxCVqAAKniIOSLE3rx8+4OiQq6bcaKVj0UWc1Hg=@vger.kernel.org
X-Gm-Message-State: AFuF++mEATUvmvN/7PmuWcRDJ2L1PJUBEcCeZVUA3iMdtYsXRcIyrqQE
	uS6/2Y4aAyOGcWEJRSCIosKupwWr7ijkpwsl6ZDRt1Ks9sjggXR2cjWA
X-Gm-Gg: AYBFou3UP6NcNb0la2WCUYKseLLx6ILc63SxM9lWm0PmWsQ/pfUhiU7WJyYKoQT3qNG
	62QZ92qEHHdkcycamG4ZHAcl/rtPi+JLjhDGj06CA9r7n3y8bXJ/nhx+ojOXDP6AvZXlr6sMYJ+
	0vBSqGbcctavSXiSJFM7UF1Q9UlfLE4WexX6qm3QS8Vh/WUFXSMYJTsfQnSiuj2V0XNbdI6dwYl
	LHkiq8W5Rj/Qm7sRt/zYz5AwNr6P/AUzbrdAzHzq9XJvISP+hQCLE0lGCa1ZrNTLTg3TqYxY+6z
	vbJTwZfOT9HK4Iqk2ICVdmMpuHLV3TjbuTJ59mYMNS4Blu+L5U8RxR+JSFCwaGiQDp/Qk3dxuxg
	Eyc+blHmVb6Onupz6DB8Cm153/F5m1Pn3etyJL8bWOssVD9i5V8Bae/byBF0olFWAGp5MCI7c4I
	rffOhGLjBhLVU8tpmAXWspPI/Hz2XvG75rX3MDPRpasFAnzt+ga96G0rnD+d28b/IF76BjxJSlE
	F+LfdazjyonWknV2DRTiEb/vvgeb5o5hZFhvXHT
X-Received: by 2002:a05:6820:16a3:b0:6c0:1ab7:8883 with SMTP id 006d021491bc7-6d2cf84ab7dmr2261569eaf.13.1790169202135;
        Wed, 23 Sep 2026 06:13:22 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4908e54f277sm1599838fac.7.2026.09.23.06.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:13:21 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH 0/2] scsi: target: core: Fix and convert kmap_atomic() in SBC emulation
Date: Wed, 23 Sep 2026 08:13:17 -0500
Message-ID: <20260923131319.310123-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 fixes the address sbc_dif_copy_prot() passes to kunmap_atomic(),
which has been off by one page since v4.2. It keeps kmap_atomic() so it
can be backported on its own, which is why checkpatch warns about the
deprecated call there. Patch 2 then converts the kmap_atomic() calls in
target_core_sbc.c to kmap_local_page().

The rd backend's protection pages are lowmem, so the bug only shows on
32-bit x86 with CONFIG_DEBUG_HIGHMEM, which gives lowmem pages a real
kmap slot too. I have not Cc'd stable for that reason.

Testing, in QEMU/KVM, with PREEMPT_LAZY and DEBUG_PREEMPT:

- i386 with HIGHMEM and DEBUG_HIGHMEM. On fe2ec83746e5 (v7.3-rc4+),
  kunmap_local_indexed() warns from sbc_dif_copy_prot(), the log has 103
  "DIFv1 checksum failed" errors, and 9 of the 23 checks fail with
  EILSEQ or EIO on the rd PI disk. With patch 1, and with both patches,
  all 23 pass with no warnings.
- x86-64 with KASAN. All 23 checks pass before and after the series,
  with no reports.

A static init sets up three rd_mcp devices through configfs and exports
them through tcm_loop: one with pi_prot_type=1, one without PI behind a
TPG with fabric_prot_type=1, and a plain one. It then runs O_DIRECT and
buffered writes and read-backs on the two PI disks, SG_IO WRITE(10) and
READ(10) without PI so the target inserts and strips it, and COMPARE AND
WRITE with a match and with a miscompare at byte 403. Kprobes show that
sbc_dif_generate(), sbc_dif_verify(), sbc_dif_copy_prot() and
compare_and_write_callback(), which inlines compare_and_write_do_cmp(),
all ran. W=1 and sparse are clean for target_core_sbc.c. I can post the
init program if it is useful.

Danish Khateeb (2):
  scsi: target: core: Fix kunmap_atomic() address in sbc_dif_copy_prot()
  scsi: target: core: Use kmap_local_page() in SBC emulation

 drivers/target/target_core_sbc.c | 58 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)


base-commit: fe2ec83746e501645709761605c2464a44fd2929
-- 
2.55.0

