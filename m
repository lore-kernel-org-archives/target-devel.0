Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343A43D0930
	for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785083985; cv=none; b=MOPKUaE0jBL2R/Jr0zcEnSOdzn+A6hoLwvgsRaB1gehIPE5O4JVgIR07BJYpQPRx+xyJH2PAj/kjEDzoSrl6yM6fTEsoluFg99gGVsGOTYtYDTwu3UT796BTwf04ckE4mLeK2fy2GWBJkXZgr/LE7dxrlMUxDj1HgfrllSJqfc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785083985; c=relaxed/simple;
	bh=AVcPYjc6QLCVatsp0wfA+iasmoc9YvU94lxkhLMDfr8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=er554XRzjKQzyl13sAush39r7noPTO2SCp7o7Zia5RKfHAf8IFXpMIzUkvp2UdKuzmOF1CETC03XUqXBHCKopKwtgKr00CHbxiz8hbrHrz2/5NtbRZEGrNM2b02qfmKSMHaLGKfcE9AmOpODBMr6f1fnF5Wt3lYl5socx1pV+ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=UHFtY3ek; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="UHFtY3ek"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso22203825ad.1
        for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 09:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785083981; x=1785688781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4soSgIPSPRGKWmUtXrCCmHkfACDKe4WQ0SOyo9kxG3s=;
        b=UHFtY3ek5RWFIUbIP0gbf9cbpvT7Hj5lg2YWMAxe+gt5rXkRNSW0fXUuLVQ2XT/GKT
         5/7Iwc5wfMbMyohIDZX1UXj+Dhf9taPhBh9ih6nxBnEj+KPxLzcshlqOx2r+lY16Vr0R
         NF5+CRKeNmEuDeybt4x/ECS99OnuQMnk74jXXDGJWVSC+8zENMa9y5CwP2X/bQtccIh5
         y1q9mHk6A9jnABR60P35kajKKkaMURhZGPcCgitfSBmh8q95mBnvZkV6pgsEW6+cYUdg
         SKOxC9c149dhhUvHOnd4bnxtnh4QuGwiEABXhnGsh58A12Pn/3dMHi7j7n9XTuqUt6Bq
         RU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785083981; x=1785688781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4soSgIPSPRGKWmUtXrCCmHkfACDKe4WQ0SOyo9kxG3s=;
        b=QQg+qHmAm7oAETLDWM7xgBkbN6Y2g5z2QVgqOsQvbzDU+Er6+JyIY4YovDbNOPZgtX
         /K3l1G6Kbc+N7qtTxUS7I7f/DzGBOhNvD23JFG3EAoL02l3FlT/m3H+SXSSeqa82KQvY
         OapFsWRQ7yDp3Z6LuC+BIpZ9Kkczk9+ewrcdGN4PZbH8hsjNsAQvVyp/Io/ISk9woQLd
         JUWFvih7Q7T2ejEFr10F/ctVcJRGKhOae9u60QQWrW6uMhZpS/dSLpHUrB6PzOWwF3/e
         N993Jev8qMc3RSWNv4rANx1YB9XV2Y9TbNssNwXu/9lfnIHp6T5OfcoBoWdppEGI5ipA
         GU8g==
X-Forwarded-Encrypted: i=1; AHgh+Rr/tkVhObzPHDPV7qJSohUqHPqv5gR05tRyCxGMuQy8T5iUczq6vU2pw/PMrEwj48cG46qYQuTrPVGVuLE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrRIKHcD5Ogd5xRp+aeGNnaM1ia8Z8+dE7eTh8ZggNnHzGO45R
	z8/89mM1+SvYhQ3p3LPkoXbjDwbMVRJFdlJZPQq9a81reXrtYiW5x3DHYLDSInyGs80=
X-Gm-Gg: AR+sD12OoN4KRrYTaJ1YVhNTdcA0eblbF/XUAxuh+n/zz7yYF6cNMETz6GHechJFwKu
	K+mqLLqXmFLl5dCJEPCy+qSmAdoj9E+CrxOCG4aSFzbjybISPPI0KGK+FsqpdE/UJxNhOw3cd5i
	sEU6k1Ub1wsa3Yfe9UoYoH+n8+5vlRZBMFZQiyNtp/SMCNpEjqvPYAYLmLzxqoS02d98immF5uA
	e7AHew03juy7ZvV2RUV5Djd8919tXYzulswTCopelJLoPaWijy9YXVp9sOfz0eSz4qoTNJ8nT9p
	Y8un8I+jh74zuS8zoZlQmweOxQPt0W4IMGFvVeOSFn731/ayuX9XMgCGoK6EYAmFr7j1baE6nk6
	SrF8G+8Ax6KMok6DEKA4A8P29HQ7RtFQZiD6gWWKDv3e2oco06ttGrG31Y0uAuxfylzooc4OMpA
	8WF4anXBjEke7vmYqU3Pf5J8jt
X-Received: by 2002:a17:903:388d:b0:2cf:b23a:3e6e with SMTP id d9443c01a7336-2cfde880cacmr53129965ad.40.1785083981263;
        Sun, 26 Jul 2026 09:39:41 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde80306esm21514315ad.75.2026.07.26.09.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 09:39:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 0/2] IB/isert: bound declared PDU lengths by what was received
Date: Mon, 27 Jul 2026 01:39:29 +0900
Message-ID: <20260726163931.971063-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 added a wc->byte_len check to isert_recv_done() only.  Leon Romanovsky
pointed out that the login path needs the same treatment, and he was
right: the declared DataSegmentLength of a login PDU is never compared
against what arrived either, and the login code reads it back out of a
fixed 8192-byte buffer before authentication - from two different
callers, depending on which login PDU it is.  I reproduced both under
KASAN before writing 2/2; the splats are in its changelog.

1/2 is v1 unchanged apart from one sentence in the changelog, which said
the login handler already had a length check.  It has one, but not this
one - 29e7b925ae6d bounds login_req_len from below, and nothing bounded
the declared length from above.

v1: https://lore.kernel.org/linux-rdma/20260725011846.538191-1-yhlee@isslab.korea.ac.kr/

Yehyeong Lee (2):
  IB/isert: reject PDUs declaring more data than was received
  IB/isert: reject login PDUs declaring more data than was received

 drivers/infiniband/ulp/isert/ib_isert.c | 40 ++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

-- 
2.43.0

