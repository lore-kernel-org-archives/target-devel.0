Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509A248CD4F
	for <target-devel@vger.kernel.org>; Thu,  8 Oct 2026 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503661; cv=none; b=XwANvY7Q+GkdiCyAXLlsVyrgE05gyX4UC4/r6vU3ufgUpQhEOoSsqd7vlsC7OCXquabaxzGI4zLm08xePksw06onOJkCTz6pCmRIs6RxNMYy7cmzxarBf2Ay+OvELJ7/6z6PfP+v/s8CCdywXQe7u0o0g+wpw8+TZkJAUt2lBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503661; c=relaxed/simple;
	bh=m3CYGZJNAhzPMUFu7GeaoaRd2e9cCQEQ06WCsBTVa/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I49lvbmLemlbmRrKXN4KBQzxN/15+xJidFEXbfeudw9btNEuDDZccSau7IaG33AQslpKEKz1ZD+ru39CHNRF4PJm//kseJJ+jrWgTwppUmtGDov8xg3B0IwVXIdwtWsaqngAunx7WQo3M25YKY6mD/q9wQH6RvUOIVjaQijjzz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qpUrz+cM; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpUrz+cM"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91054f9d26eso2706386d6.0
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 16:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503659; x=1792108459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6nrBGseu0RKze7XYtGVGT/Lh66doqcnrdj9NzSKYKos=;
        b=qpUrz+cMh1tbCixyeRQC6Jh+TqgqLlrqXam9ksowDply8tX3+XLMGSKcjrutA7meja
         7XPRQGVrdZP5er16xkTfb2vZ6jtdemD2qZwmmIvyQYVWIlaGEmpbonmjLv5rM4F8BKuI
         JUnjG86pMIwJU5NmLrGxhBwFyCYtMmCcS/4aN9Er44IZHFjiydePfmCtl5yYhg9uIUD5
         Hnvb9erTTGukp2NzYIFSN4SJ8hrCMajUuiTdFWqcSLwGG28zHke+FiXYne6JKCeCdWTN
         CH4j7O7qpb2DydfHqwk31ZfQbHtQ6HNMAvHsP2hRKrT4DCX0ETgh5/V5wT6QilIJ6XMe
         dpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503659; x=1792108459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6nrBGseu0RKze7XYtGVGT/Lh66doqcnrdj9NzSKYKos=;
        b=w4QplV+qPfroAc5ktEwdrbBO8USurulv/z/r50vKz/z2O+Qdy6cjOIrFKxnx0VKzFG
         0QFVCLVPzHJe8dZ/I9Ja4R+VzBgDx5BtnRkzl9qAUUoM5qAf0QAd+/kImoEwpWviTfPK
         NWFso2iNei1fSifbiSqMnp5mwdMyf/p+sHP6Xxy/7y3QHboTXErDlrFaFD2o/QvVkXUo
         tRDx0WB6KXdZH7CO/kC/LvuXQzycgQeTzILzH/zlfFr/alphIde6tMlN5/6cBhKix/vf
         cT8f6GWR1viCULEbrdseM0rvrAU6LNyoUfVl6HbcmxTXMgA44ur8+7Zwst/o/s+5SPZx
         fS1g==
X-Forwarded-Encrypted: i=1; AKwUvBzq1D5MsBGE5T5AGQlTWrZNhEJio2wfkSPHV7SNBsDFh2SQ9mpBXWrGgdDE2VCAvNdVkVIpG36kVFc4kWw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJY7UIan1rUEEKgimFMMeLJKdzni/OcgchPM78PJhcnBK6Jefa0
	rN8a4pgHTRagntQFp1qJGIMDuNbfREmJHz58NGpkZYFT0PKcEtPg/qbI
X-Gm-Gg: AYBFou0GqQC1x0Mb6GaMMuu7nzdDg8XTDvyzWQs9f/hiAKL7azyqg8hioWG54LnHWeb
	vaq6jtmSspMwiO35il69JpUZIcci0TDyl8Sba6UycYz7b5PGg8pryz8cJR3or0c8TueW6ZQEp+c
	ESrztGtP5kVulpzz4gOO+g78OBtfIvMnv/nhHdr7V8mBDO985ErmzLiSDxMYzMi9Z/sR557MpbQ
	T5MRS8+zrZ+MVVbfVZ8xMtZRgMDfKz9Rr7Xd38odU+htSwFOD55YoLl6WI2Yt0QFhfDabe9KdI2
	Uyd5AYi2tWD8N74Us9oAC0PcaeJSLPGb+gL6kXsgiAybsQ4yTexCN2+pJNWDUbbKsWbBnJMaCQo
	ejNfCZH7Xy6YjNtkYTkFg53ierTIyiR0JzXFM6SXqPqDKqgs2OPj/1935veb2RzEgqbstTXVQyZ
	7ewaRx+nnyCY7ZbenTSG2EZnUPyH8rlaExECbzQWdNH4eWXzQZHEfwu61Gauwbju0JnIxKewDjP
	bQ2gX9FVNB3kl76V1ySWBwtndkq4Ad0cBCsoW0V+IB9HdrKrhNemXpl5phDLFj85nMm8O+4FrNw
	j/ao+IS812J1avDVJVw=
X-Received: by 2002:ad4:5767:0:b0:919:59e6:f517 with SMTP id 6a1803df08f44-91b557c3a96mr7022486d6.5.1791503659259;
        Thu, 08 Oct 2026 16:54:19 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:18 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 2/3] scsi: target: rd: Release protection space on allocation failure
Date: Thu,  8 Oct 2026 19:54:08 -0400
Message-ID: <20261008235411.56641-3-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008235411.56641-1-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

When rd_allocate_sgl_table() fails, rd_build_prot_space() returns the
error but leaves the partially populated sg_prot_array in place.
pi_prot_type_store() then restores the previous protection type without
calling ->free_prot(), so the pages and scatterlists allocated so far
stay attached to the device. If the user writes pi_prot_type again,
rd_build_prot_space() overwrites sg_prot_array and the earlier
allocation is leaked.

Release the protection space before returning the error, as
rd_configure_device() already does for the data space.

Fixes: d7e8eb5d9216 ("target/rd: Add support for protection SGL setup + release")
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 97c63b122..b73bdd733 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -263,8 +263,10 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	rd_dev->sg_prot_count = sg_tables;
 
 	rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
-	if (rc)
+	if (rc) {
+		rd_release_prot_space(rd_dev);
 		return rc;
+	}
 
 	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
 		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-- 
2.48.1

