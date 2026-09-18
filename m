Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725A51B17C
	for <target-devel@vger.kernel.org>; Fri, 18 Sep 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755218; cv=none; b=q+0Gq3heOzet5txHFbdGKHZAMEJ6ZK0uCKRHXrdPthwsLceugb0WVOuEt4hxIGVPUHZs8Z8Uw9kj9tVOFSsNp/bjzCD3cGC7RTzIJQyaOCxfWZZTE6I7dmac54nkhhsCf0jo3iVs1Q7OeDewj4WALdl5UO2IDr8adK3I9Hlh55o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755218; c=relaxed/simple;
	bh=jxB51OTaF8ZQDmHlLnMOrVw7Z/Ws4WNrUhbIMMa/FPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwwZ0CUlT1rSknCibYfoSzGUMyuPtOMALiUOXIvz5WSl918h3N+aDenFA1iCE5RCduAVZUUXLtuY2BT5nMAjg2DdLKlDn7tB75F+oYrEyuk2JGiNGovw3wSM84ZpDxz4MkKLszfF7VJopcwYpPSfAuKd6Q7BcL042ZU/UWBy2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M44kfKPW; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M44kfKPW"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db1ca06a25so7774585ad.2
        for <target-devel@vger.kernel.org>; Fri, 18 Sep 2026 11:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789755216; x=1790360016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=shS485b8tZfkhk79R4MyxZiHCFajwa7fKOgCDdDkLAw=;
        b=M44kfKPWKda/HQ54Lt3AI06EuzRL5MzqGj+Ht2X1/cHXTPkh30UTbI6D7FpYB1tsiO
         244NTerQ1oOA2MYCE8fqDDQ0LPQOCjIxo6a+qEmAsD9HqJSvuY/K1AGPxhOJnFkb9PJk
         mCmWAe6tARA8Js0hFMIelim+afhECSapODYiiZitQF7XqbebCqvF0uBtpCscJ4rLm/EB
         J14zTg6cAJqkmhixjA78k7BHWMiguDofXXh7Xzsmhw5I6jLhjmu3CLf8F78b5J6aOXfl
         feb6JEsF3ZWS7skzm4tpoZTpXqbjr0h/Q5HkeqM2DoqbInHjdPzOI2PjCIsbvTm/sUAT
         94dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755216; x=1790360016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shS485b8tZfkhk79R4MyxZiHCFajwa7fKOgCDdDkLAw=;
        b=Iy6BbOTJLH3tquZrGgN1tMRTsirKkqPLjYx1DL+RMOazsIpqhlu4Rfie64U625cCGf
         ouZFUYaDdHzZ+VD6nInGqDsvRkVbcP0C4uj1optq28pM3KjHAeGErFJLRrIUBNq7O0Cy
         3r34nF2xT0Wgz5f8jcbqkl2xPxjgQQChwqJP3A2kXdP1Healq8c6UlVzN9hnJR90xBSe
         NaDmfbQPc1SVaMJMROZcoL4u49GVfWfC7dATnlwpuQEi7PoeTGQ0dq8SNMLlAX7j1oF4
         5S7n/CzgXB9iIJIG7b9llOgA/Ev2n/nj9xRQptXAfCgB0ztofhsSxfbCFJ+1uEb8yqLD
         PP4Q==
X-Forwarded-Encrypted: i=1; AKwUvByMpcFBHdWx2o2sfxHloS5igwKS1rcw223HakY25WWj9d6xowwbXVrcHIKXuy/j7MyljqT0XE38itg9zbQ=@vger.kernel.org
X-Gm-Message-State: AFuF++leC5FxRxODSPScv9DIxktGQCymgSZR4HF+wKvyM3qmcijM+tzX
	E7UjtPD/48RLJ+iA219QYAnuJKLPbqpgAmVI380mYsDCLefCJJzQy0ZD
X-Gm-Gg: AYBFou2e9GCbr6j3gtg7J5Ak8OgqbYQ64UL1H/zzgWUR1pwuXnanCMl62CY69cyReMc
	pGeZmHc6AaTTwN11wItnfu9cWEvJ07+UZaA9FlgPm76Fje282AWTj1NRRAyB5vEgDW8MlUwosEy
	QCAHJUe9zHXzIV6vFByiN5eTRIT8WTX16oJi/I+XhmpteEoqFv2MWJf0sKxKH7aUhO3433RKrpr
	f44nd+L2y5nazBZyXivKte8aTuYbNE7GaBJSdP83DaN4HOwrKc9IQjAPLdPIID1GarTIl8xbkPF
	8hK6BfgWbd7V4J6oh7InJB2fjYxDfayscb8MPNUr7MEwDfi0P1FPQ1MTz2PGebAJLm3zH0iLSdG
	YvY3et0SleYqeFIYyLPfsfRy4LesozDAUy1bdbjbS+Qe50RkSd70XetvFLZBXQ0gNUK4Vy7Qyet
	+VLPpFc558aDDtrkyMz2RVYkKdA2Z8gU9GtR5EUKrUR4sD5rLL63BjwLJ/KeS2DdUm
X-Received: by 2002:a17:902:e751:b0:2c8:2808:3ec9 with SMTP id d9443c01a7336-2ddb1ae69b7mr68800035ad.12.1789755215937;
        Fri, 18 Sep 2026 11:13:35 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc1788bcasm662465ad.21.2026.09.18.11.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:13:35 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Hannes Reinecke <hare@suse.de>,
	James Smart <jsmart2021@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] scsi: efct: clear MWI on remove
Date: Sat, 19 Sep 2026 02:13:26 +0800
Message-ID: <20260918181326.3633765-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

efct_pci_probe() enables PCI Memory-Write-Invalidate with pci_set_mwi().
The probe failure path clears this state with pci_clear_mwi(), but the
normal remove path does not perform the corresponding cleanup.

pci_disable_device() only disables PCI bus mastering and does not clear
the PCI_COMMAND_INVALIDATE bit. As a result, the MWI configuration can
remain enabled after the driver is removed.

Call pci_clear_mwi() in efct_pci_remove(), matching the probe error
path.

This issue was found by manual code inspection.

Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/elx/efct/efct_driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f453459e..720bad7b3517 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -613,6 +613,7 @@ efct_pci_remove(struct pci_dev *pdev)
 
 	pci_release_regions(pdev);
 
+	pci_clear_mwi(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.43.0

