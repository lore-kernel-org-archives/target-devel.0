Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C01397
	for <target-devel@vger.kernel.org>; Tue, 28 Apr 2026 20:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777408797; cv=none; b=A1ZPtLLuCEsEElsuFNQ27aVdNTS2afJVI0F6OMatq4Lcwe8+4pmD6p3bJU/BDFtpsC9d2Axcmc6wNyz2FJBA2U7qRNh8UTBoTzgW0GoA9FOF1OGMCHfNmakLJn89o/EPkQvRT9OYc1CZ7h+KQXzeoXwt7UBi7TWxAU6OD2n/Lsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777408797; c=relaxed/simple;
	bh=SgcA+exyHXAqIJdItIDbidRJ+F4zZ7AWpIefSP+VdFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RD3cIPlhTNRCFES6OEdviexxbntBR1oGhAjkQFqtuinYliClSw5MO4kRUyoa8pTjiwoojXs94XAyB00lpqbU+WD4SHD/TzQiWwQE0EWjrZSkWBgLfU1sfZbc5jvnosMZ/gjzQ76ReQXr6e/Y8zT4cAxvm5asnhBma6Qm58HGcYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdjgU3IS; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdjgU3IS"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-69486849137so4899848eaf.3
        for <target-devel@vger.kernel.org>; Tue, 28 Apr 2026 13:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777408795; x=1778013595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C+si7lg3A2lMf4zRs+JJ+IUUmngjpZnIXbiZMqlnVc4=;
        b=LdjgU3ISBuPX4xuNkqFPNE/ZGrFlz26TQ+LI6Nx1bNm0XvAm0mg/yl4QVA8vhY6QGB
         F6/DwPJSTmtpFKjnVcJV3tTGFt0jJ07/KFsY5RSp0Gv28IYEF3OiNZL4+kTgkXBU5ns3
         lkUcBzlwkU7XdDWQYZa7+nku3QiWhuGYi+PGVv8t4ktXKwWkL/LrEklHr5xbO8YEUoS7
         26SRoxW7/UylYtDJfsUoEN/L9cZft1+Z2dVzOGptU07L2SAlFOTTLugnnNuLs/yZSeeu
         6eNW9hxlHMq5wnTzACYd2HfNYjcwOHsUh1iy3fITgoPVcZ2hvJiYTXJl7kXkD+yDluhe
         EkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777408795; x=1778013595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+si7lg3A2lMf4zRs+JJ+IUUmngjpZnIXbiZMqlnVc4=;
        b=r+J4LkSl+4uISoVDShwpn0bQKTfVrApGfEUmHeVZlTJG+JZdNr4JdWx/6TkBMdhF8g
         s2lNcx6fuVTYP5rE+xeItFXzuUBVRbcautRqZfY9OcemboFrpLpzITMc2B0+d2YTpv6n
         YHJ4mLwij6JSICe40B0BFfE+e0IflnRuir8PRlt3kC6rEeWclL58/w28SVih37/q7+Hf
         7EEbOKsN0UpwxDWrpJW2IrVFeYokDZ1e5DyIT+o/wfqHtMCBkmGLeUH0C1HGXVDvCSdL
         vG6sR1KzwI5r3lH9stJpQDHbbPSCiClKs7Qs70dCkk0l+Z0B1H2/+zzy8P1oAVaU0T2J
         2yiA==
X-Forwarded-Encrypted: i=1; AFNElJ/5P7TyRjs6Jk58YwKqSVodY5piPNkC5GQUpQGvxqLGMNtUgu/nqOB/Pu5TCeGEm4AwCLmcrDRlRQ0nX/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV8T76IaiYOBpMhSQ+1LxC6U4RsPlGqO1c/ZrrU1zY1woZTMLw
	6IeWlfAVznALrYGcH5v6QaAh5X4xXSi8nIftUaOWqtcnHPIlpqvlYEmM855Ntg==
X-Gm-Gg: AeBDievA4lr09zFEu47FiiJUq0sb0d5SF9IQrsZ9rXQqqhUUKTl+oGIDF9IzggOFOHj
	xyg3DdKjzEMAPl0pKk0y9HA+yTzTX/F2CXx3+6aMg1bot1k/jfkDnLzqfy39Kbqmim5/YCPm4Ug
	p8gId7NE+19FNIC0z73cLz8xn9MfZ87IRGqlRQYSEIPVcU8H5WEqw2rc7NsZIa1559LnuXpxJkN
	kk+gjvY8JyBS707s6SOqywl4bX/qTvrgCDzUr+0jtx0U/zc6e9cfbE1lwioSkhHPsejTQ4Baw5T
	wKfNHumYJoyY74lwLRFy4VY5U5mHRdwnMuaY/0JsBOn0iIPDhdMHJpuKG6zwd03cZMq/ycNPjpx
	Q/3cZNufFFho3/9mO6hgzdb59g0wL/eWKYi9mAe1Oip26BeJZtUTTj9ZDIHqn4+3rCg8R2alqeh
	STFExAKaVUzcStph5/UhbzYTEqwQ0e1iFrns+JkRVUHr8jiFquywnh2Q==
X-Received: by 2002:a05:6820:88b:b0:694:6acf:a42d with SMTP id 006d021491bc7-69668490410mr684717eaf.39.1777408795078;
        Tue, 28 Apr 2026 13:39:55 -0700 (PDT)
Received: from localhost.localdomain ([143.166.81.254])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4340e388b97sm233616fac.0.2026.04.28.13.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 13:39:54 -0700 (PDT)
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
Date: Tue, 28 Apr 2026 15:39:38 -0500
Message-ID: <20260428203938.9738-1-stuart.w.hayes@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify target_check_fua() to allow FUA support for devices with no write
cache enabled.

Without this patch, accesses with FUA set will be rejected, even though
they always go directly to the media when there's no write cache.

This is needed because EDK2 FAT filesystem code sets the FUA bit when
writing, regardless of whether the device advertises support of DPOFUA. If
a UEFI pre-boot write fails, the filesystem can become inaccessible until a
reboot.  This can cause linux installs to iSCSI to be unbootable, because
some systems have firmware that will try to write a file in a
vendor-specific directory under /boot/EFI (such as /boot/EFI/Dell) before
attempting to boot to a UEFI boot entry pointing to a file in the FAT
filesystem.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
v2: rebased to latest upstream

 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..0e07b224c4d0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3722,5 +3722,6 @@ target_check_wce(struct se_device *dev)
 bool
 target_check_fua(struct se_device *dev)
 {
-	return target_check_wce(dev) && dev->dev_attrib.emulate_fua_write > 0;
+	/* Allow FUA if there's no write cache */
+	return target_check_wce(dev) ? dev->dev_attrib.emulate_fua_write > 0 : 1;
 }
-- 
2.47.3

