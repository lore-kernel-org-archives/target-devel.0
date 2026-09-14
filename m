Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A523547669E
	for <target-devel@vger.kernel.org>; Mon, 14 Sep 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391158; cv=none; b=Zfx4HYWyRHNNR3+iT28VrNL441elhBqhVHZSt2yg+L6XZ7qoiKMuFqF8rcCDtN++GwPI1nK+6NumqXbFMramOLRg09Tg7Uth3+R3IF4YJiqbd116DqQ6WKRasNnMkBpLO0MJ3wN10MV3I8dBBdqOOQ4lyu7Y1IPxRi49LEN+Ef8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391158; c=relaxed/simple;
	bh=+ot06/esph++ISFoL95/F/SezXZW3wAoizYDA/ZXE4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDjWlvD4hj8HV3xQw//1esO4jVPyayDs+rQ6lXZUgk3mk1AfMitcCMjJvc6Ijij59WSSqh4HoqgI/nAuYe7Dc0gtuidxTQ6HrjjmuGrutXw6QsB9Op3NOUOuCpK2GxsoM3Ordvk5pbw2ydDOb/ADDgZ0yapKmdFVO+NIvfAAGxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQSD2/J5; arc=none smtp.client-ip=74.125.225.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQSD2/J5"
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49814d35686so1547485e9.0
        for <target-devel@vger.kernel.org>; Mon, 14 Sep 2026 06:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789391155; x=1789995955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4bb1Qf4ZN2oQ0J+b8ooyhKAW2X1wwD7W1Q4Zbnoqvc=;
        b=IQSD2/J5iRNkrn/HtQNzL0kpqSvWQsblJ31UhQ+T03H/YIlTIkbMZTlkhQWX4V3ph5
         R5qGmIUP7RRi1i4wCp1nx40viTQOcsBzwos+TH0EJ+HVgbFy5wKzFs/8eM87Xjk1tqg2
         sSvnpoJAcISVx8/yx6kiJf+9kUJcOdsH6+1d96Ce63Vbcvtj9QpDPJVraSPjyr//oAcx
         5PAkuaAfCqRwIGS5UGtR8uOCSusQtyRvjm3Opp48M3A1cXZteSmeVK/xryPge5Pg0rAM
         AVJ1E03Gv7h7vTUVizvU1t6JfJm2GaLB/QpJEDxtix9J3bmC7QbzQh1SRDZluLWNBzOj
         teew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789391155; x=1789995955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4bb1Qf4ZN2oQ0J+b8ooyhKAW2X1wwD7W1Q4Zbnoqvc=;
        b=mklInYBv2k82L+uI3RJQnBAdlkY5bLEC7somqtVhi+wVKPOr6LgMekEbAP1QSlZ5Z1
         gaq4VRCzhAP4rEDHoRO/1hoFVR8CKhzxJKjMwBai4VQ0lRKc2Q6ErAmXy193GZPlObCU
         0iHhociJHpCJkwVLEuXgLWhrTo4HYkfTzr14iGPWkuZGr8ZK+WFX5xw2vf1u9UaCW1G7
         I5LFY3JJ2EkXFqu0AmbU7QZoq1SOArRzwAblTMV6IqbdW8ocDDkLMRu3W9oGuoTcaVrn
         VBmhkrarMTxiuL5cSLPAmqipiPvR5IUQNGbi+UB7JlsVv9swINMm2KZ+sUHak/dpRa+q
         pyvg==
X-Forwarded-Encrypted: i=1; AKwUvBwaS3cwyisEP3fGFoLDlUIx3LmnYwbNqB8TqZY13F5Ia05nXt/X4kJzuBSKUxkXRdTY2gY8HE51XR6yQhs=@vger.kernel.org
X-Gm-Message-State: AFuF++mHrVItUPBo751yoniHXyr2E2l5rzxXf9lgcG1QEHo92qEaYh7C
	hzctof0Qkfw7yxwPPyhESTr3iZhsryIsPdEr38J3A1x+en7ES1J1k/xe
X-Gm-Gg: AYBFou1w/ytN5qWSlw5l7fz+fbYAvRsUzKBjejEIF/poaQ2m3v5h5VTPc2j03XeI+ip
	SMQjM60s/AHeA41wnnrFTEQF/g5DCF83rX93qG/W1zYmyVwPqneD1NUK73OcnDunQCTJ0zpTUN/
	6Dfe7C+qYW9aJE/zP/9bZCtddYi/8Nj4PYtCffQZ+0b8lYR7gSzvVb8gTw/1Atk169vRJuGlthY
	VeC3unbWJKX5yy2XDuBwr0SJ+DqrEW2ij6T1yedsFVj69KK3q6bHa35x64KnrdgdbOiV/k0d8o0
	JG8uSjvjpaXIB/U2L/X4BUdxtxSbybBD+js6hwWVQvSuwmpyvIjg5kI9QOF5+Z2nhidgWpxO4z2
	nmY/10lOztg4EhFBW4qE+BbcmGiZyR5lPXxIhPKL8hbnt8uqygp9cu90TZTUH/ZXA5BUsqLUbpC
	kr/6RTBOtR7PTcGdTnqmt+qx7l9F4MIakCitN+zl8quyrr5UE7N+8hRGKaAeXqdsI+gzNHupY5K
	HYjrQEMUm2+Vkc=
X-Received: by 2002:a05:600c:8b2f:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-49e7a657446mr26349045e9.5.1789391154592;
        Mon, 14 Sep 2026 06:05:54 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e62225628sm234119165e9.3.2026.09.14.06.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:05:53 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: bvanassche@acm.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/srpt: Fix srp_sq_size documentation
Date: Mon, 14 Sep 2026 16:05:36 +0300
Message-ID: <20260914130536.19769-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace "Shared receive queue (SRQ)" with "Send queue".

Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 4c46b301eea1..506c11b84359 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -350,7 +350,7 @@ struct srpt_nexus {
  * struct srpt_port_attrib - attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
  * @srp_max_rsp_size: Maximum size of SRP response messages in bytes.
- * @srp_sq_size: Shared receive queue (SRQ) size.
+ * @srp_sq_size: Send queue size.
  * @use_srq: Whether or not to use SRQ.
  */
 struct srpt_port_attrib {
-- 
2.53.0

