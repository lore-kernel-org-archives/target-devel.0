Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988E2BE7B6
	for <target-devel@vger.kernel.org>; Wed,  1 Jul 2026 06:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887005; cv=none; b=HdqqhkeUGUl3xXmCkN58EoJ0JUux2HgWlLsfn6DflZfO4MG1Qa4ux88Bt14z2TkSEXZKXXFshrFdG4JIDP0FOSUiqHyJ2xokPAIx8SMnUyniAoGysMQqXewLYYHR/jGlb7/T85me2gMCetTYizO1WdZpdQ09n/csaOvbxP2IHj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887005; c=relaxed/simple;
	bh=iDb19+v9W24MFwVBLKYMAccXrZLiNoIhHW9iZ7BQu8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dS9ajIR8Ouhjdvjk+DDuTF6Ia1WGDyQJB2GZs/ziw70gwioq03fcjrr63fih04SUIx+zISwkyNGvcslTFHv7tI3j33vVEZRqW7H6ZJpXXEOCiOARl8DRvWItGtTo/pK40wSpuR2L1oJ/A/6XZ78/4bZPen5B4lq7LCJB9iGMK2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=VnAXweOo; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="VnAXweOo"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8479f1a86ecso169662b3a.1
        for <target-devel@vger.kernel.org>; Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1782887001; x=1783491801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wh8rPIUKvSG7DWfJknXu0HCqG3Ju9McYV9PNpDjOZvk=;
        b=VnAXweOojvyKVSw5BJfxQV/rM8AerMEQSZwqmZkdHxTRi8VuDj1Ss1hNNofhPyW0Nb
         NZVZQSUwn6tSZ8D4XFg4W8piMMKxdn0+ElYqSBJHGZwGpdMhQYyNT/5Ird9C+Sw/IM1q
         64KLTgF5yr9xvL/v+2Xpn1Apw6ZdfyqwDVc+NXFkRreZ18Tjkr5kPnU30NAjwgZ3OiEv
         rJrJvRJCmf5wOhWW5Rkx+o0ZNKK55f9tMm+6XolbHjKL+86CFp0LYS/UIf0ncvA+hyWI
         Ct8S+mQr+1zLh/v9d3Ayey39yju+jOKMysb2o8QYyTNINKNq3BXKFD1Ysq3AISnPhhCw
         0JOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782887001; x=1783491801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wh8rPIUKvSG7DWfJknXu0HCqG3Ju9McYV9PNpDjOZvk=;
        b=MIJ+bVNQfRncT2btGtGQYNODWbzWOQHsTEWXjh28LLepyqAWNLWlAqFcEcUP+dVh1H
         tmnvR6Rb3+oFy+GrISa5XxU9S8SL0S3sKNXB+fgXOVpvpIaMxtgLnBrDTQKKoxPMII58
         qd9zd9ps5dqblRl0g5C9kk0CTDzdSR2iYdfEN9uPIfoLDvItDTQ4f/fKIC6G6Y6nbkuW
         uTRJ9tnTVef45/X6ABseY8MVPA460epAlyJbMwd355BevjieI8NsBNlgDMKQLAhqju0l
         PPH7Hs1Fq48ujRi0NbudCFE20z0CBsRP/WBrDxS/7Ls+0MKdRXdwXa2yDdH5AkjAxZhX
         ftUA==
X-Forwarded-Encrypted: i=1; AHgh+RpE+LU04zYrIK820WszTaoA29O9pUwDAdYQtgg0ROw63iFapty/s4IMxGuJz/0NTEqEg7D9U52PgtRP2Zk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywft6UtBTfvm/Aa1J877k8cBHyFHboDzj+iOuj/Oba7eN522oj2
	QrTyOZ5jXVymB/pYm8VRHGYEuZZtHdhCwPK0D0imncruH7B2KcjAG2u9mAUVfCeNIGI=
X-Gm-Gg: AfdE7cnPOcPu+gfcIjGZhKMroPLjaHBbiWGTi4uADMO90cTnp4tBS15NptoS10RwHyB
	1W4hZZ6G4gQmx1DyRIgzcYDG4VzmT+Vx8jaIuaFrzztFUGPpZDCqYcbAx0NHv3/dkcUDK9aAZgU
	tM60Nd1i+dCt5Lj+mxVkhE+smF6P9B6x9nxeVNh94Flvy/NtHxgeGAibajeMdJjMG5++ik4ACHG
	k+3N6AYPAPyVDn1qOxRCRZJ44WnwE+/YtmBzTZ5ITQau8RUGsUgwAdFG1Kcj8xR9c4v2DIjjypp
	9NK3/TWqXNwc0OjZ9XiN0sR0zNV37GwAb3bhEP7J+SbdOUXGXS0KHMDiWeZByrDnM2/1YiXxm0x
	64+88Cuvqp0CF+q9BV/GsJCMxW4rzLlY/Yc2hs+HZDW1ly6kC4vvNFNWiSlDBq1WDgGgacVbTGb
	W75lBWkM6Nz3ptJ4ndSIiE8pMN9sqW5u3ftu39o2ayW8/GvAFcoIQr9gh6V86F6OVDy8p/OHJOp
	2ED5L+oy9+zOkhSETleTUIBl9m0CaVJ9rh74mEYHRs=
X-Received: by 2002:a05:6a00:a87:b0:847:9aa8:d3ce with SMTP id d2e1a72fcca58-847c06ddd6emr253010b3a.2.1782887001364;
        Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm3270627b3a.33.2026.06.30.23.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 23:23:21 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: ram.vegesna@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: Fix potential memory leak in efct_hw_parse_filter()
Date: Wed,  1 Jul 2026 11:53:08 +0530
Message-ID: <20260701062313.372532-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an empty string is provided as the value, the error check after
kstrdup() call, can fail even when a small buffer is allocated for the
null terminated empty string. Fix that by freeing it before returning.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/scsi/elx/efct/efct_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 1838032f6486..b0fdeabb9d05 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1129,6 +1129,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 
 	p = kstrdup(value, GFP_KERNEL);
 	if (!p || !*p) {
+		kfree(p);
 		efc_log_err(hw->os, "p is NULL\n");
 		return -ENOMEM;
 	}
-- 
2.43.0

