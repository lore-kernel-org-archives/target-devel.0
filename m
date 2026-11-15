Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733152;
	b=H1p2iHSaQsff1i4EqjJWfDQQKvkl4b+CPjWc88PsXDi4ElgvEdMjNGwWhFjX1S5+4aL+
	 W4sMPOkbAnUERXxM4zx3TgwASSc7CNKnR5j4tRQsLNMiE6oFc8x3whCg60XQH0nA0pz17
	 X5ld7b4iMDsprqPKdPhodSLyGVISm80gHUQaeRPIALE2PmoqtekhkGw0mNYOEvwzg8RlN
	 3DAMla+XHdXZxFZVggGE88qJWG+hg8NJQES+SLCNgzcMhLwfYUNFX2DZWvwN253H8gjeC
	 4sbIQ5GJgMOJDStnFRjR3GOO+3fef7xvAKGBQAEWs5gddK8aQruQcQwio9vjSicNbQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
	b=Mh0jWAOJMdGDZYFR1XSL48vKCRl+xqKCnkuAWYmk+4/Kdkt9zk1OK0jAQuOeUdm2I2IT
	 dpWAamd0nASC9NV7WTX1Z8nS5bzuDSsXhsdVAFuxirkELYOSndqYLIKDmbZ8/2ouKfQ15
	 cdDyYhzxCYo1F1dNqlF/yRK7eQRyIkTsfx6LrGFDsaWoaBe4OQi6gOMkWhqR7b5LL+peE
	 THD88OTdeHeC78xtNwokBlKQ/+CVsrHP3yK0lvBZGNXqnYlsoJG45EuJpmOJQDnclULc3
	 ENRW2kWikNTxp06ndnh7yeAb7qpQZTHFZd7OnFwwW3HuvpwYPKbbbGNPeX7LJ1gFRAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Y3lgp/rm";
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4493F606A33A
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 08:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4493F606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y3lgp/rm
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso1032924a12.2
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733151; x=1795337951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
        b=Y3lgp/rmcuHXtGgT7jiOpAhUdOJjUk2EjyColK+tRWTsylj3O0EhFIqbVdSZ8dov2S
         FBYbHklRubGQqGKxI5Rwp2PdjLLucmeIFSLVw53xmyOcmSti1Ei7PsQMrnNtQDws/HKf
         bDzaFYiVA7pNUjapbfk8z7ZWCO0o38b2UZwPSIrXy1ymv/W5H3VghAjcogdi5NJkk/U8
         6jnrptXeSZtRn7mgMe0VQrPuh3ic239zz/vUfWyuEfpJCZf7kWeGfC8zBzAB0msA/49d
         SdTDWwI8obh+POjb6QClXWMmV0qDnf133Ieyh1z8MY3c0rWNwifB9SUlDqaNea7VhCQC
         QsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733151; x=1795337951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vBzp1cbJBkZ9i3fvRMznU3Qya+xemyFA2/5bJ6Wt8wk=;
        b=AscNU2bJ6TPQvQkyeriL0Oss7xf8EvLf0BUoKk36bMBHBmz2FtSq/suhSOJ9TzMarV
         WMAOaSSPfVL9kGAFRAxYHUCDFR/Cd6v9ciR7T8deMTbF1CX8dzi6RG2KrZYjp5p/V+Lt
         n9IDdNg1Jm0sdOoBz+09zrjTiVHaWtkIsuLWM7aIKROjDHv/88YNdNoICrybtKoE7SQ6
         ioZikNys0sf/Eo0wzREYOzGlZzcLuOg6sNsjViMdwszNM2GgfxN0YuY0vCv2d0TTGvZ1
         kQxagQxfKn/uILKJfjixqlHilR6AhhNroqczEChizL/syuI57ETUjOS1739Tg3a9dUok
         hdtg==
X-Forwarded-Encrypted: i=1; AL+hErHvz+2b6d+pl7w8ugIphDft2ubGJFpx3jaDNPr0p8Tc3vTNtiVj3f22HKZQjNoqnOBpNznRy32KyulU4Cc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+jv0t5Sd17WOnLlCR1tdkZBYwiOuALvihEeHuSSVsSL6jaiNuD
	v8aZ/cFSVbQVhKjLxuIpD+mmRogQG2smA1qB0+hjVctSm1Bj6u74oWyU
X-Gm-Gg: AYBFou0RiWvbzljMAd1PFciH26EGx046m+fbL/a+SrCWajM2n422PUMU56dLCcJ0HLW
	V4d3E0wx3DuIODFn7sCTEL0E+ws20YgESbvHOaraDGPfWUVifmTxlmBMGCbVP2j56MdrW4G7Ifd
	BvztQ4NBfOGSn3akLU123s98zgGiVDfT+WjSToLnjQdyTsMX9zQ9nln61ahbCEVKwZEAQCU66Mr
	My49wHdPthGsNua/D92WxunrZHBIAPEKYtWTN53xuqtnlQcMEslv4bb7EjUOF7xSo/EE7bURr1J
	77U0Q5vd9BAZ+rO3JnC49PQqqM4ULgb6PC7PAukfqFcrl3HF5EXuZ+cmIE2EZwx6quCiRKdHIRB
	nPVxXCCNftqr29UgUlwDWPRCKaLc4CU/UMSkHdPAR+8CzCk8i1cBwAPCEITi/+rZb04c+l2BVV6
	ZcG4NgTFLziC85I0NIHgUpw+I/vPlqUGxQphKumRRu0Exg6/Q9WVuSmuagZNPLpj7qz8tbjc6IT
	cc+JNz3xsap7JPGloDpCR9moNbQQR78EP3BffvuAk7nuQ+4deUnLmWTaD0dvMz6depVCaL1mW8q
	nz965EHHTAm1CLMkhkh8Mer0xiMOyg5a/EEhBVLXmVZ2VymjmJYB1ujddPpcn2IQZJ9zHcQSIAC
	KSuKQ76hDVIbd20VddVTyZMGFST2uKwL2UZfw26ifuGE+TI1rmm+X8A9a7MIgVkdt46qaZ6ab45
	8xFjmzc4XtvqYLOSa/VqgXlo+7RUEm2OfBbLxPJB/I9i7BLtrF/UPclWJStTR+Sh/I0HYrtBy8M
	+WszJ4nofsE+tLfclkgbDt8yGbPRmVGLa2Hf+PjLr8yTlsnAwFBgrQ9krYuT02W
X-Received: by 2002:a17:90b:2e0b:b0:3a0:e1f7:9b04 with SMTP id 98e67ed59e1d1-3b1b09f3b6amr7513724a91.12.1794733151364;
        Sun, 15 Nov 2026 00:59:11 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:10 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] scsi: target: iscsi: fix session use-after-free on non-leading login
Date: Sun, 15 Nov 2026 19:27:43 +1030
Message-Id: <cover.1794732723.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
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

A non-leading login can attach a connection to a session that
iscsit_close_connection() has already committed to freeing.  The
connection ends up in full feature phase with conn->sess dangling and
its NOP-In timer walking freed memory.  The same window leaves an armed
Time2Retain timer on a freed session when the login fails instead.

The bug dates to the driver's original merge in v3.1, but the fix keys
off ->session_close, which arrived in v5.7 with commit 57c46e9f33da
("scsi: target: fix hang when multiple threads try to destroy the same
iscsi session"), so a backport further back needs adjusting.

Tested with KASAN on mainline against a target with authentication=0
and one explicit ACL.  Compile tested on x86_64.

A reproducer is available on request.

Daniel Wade (3):
  scsi: target: iscsi: factor out iscsit_stop_kthreads()
  scsi: target: iscsi: don't attach a connection to a closing session
  scsi: target: iscsi: don't re-arm Time2Retain on a closing session

 drivers/target/iscsi/iscsi_target.c       |  6 +++
 drivers/target/iscsi/iscsi_target_login.c | 66 ++++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 +-----
 4 files changed, 74 insertions(+), 16 deletions(-)

-- 
2.39.0.windows.2

