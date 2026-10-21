Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575842;
	b=bSseeaegPJAPReD8fpAOf7eLlGZP1qpYX1rhrxTSe3GAUpzwEglY2t9f9iU64MyMX+w2
	 6fP0y90FAV+eWxA/laOPJ8ye8ZmViNt9amUwGOE4RYWpNmCoHjLl3hFk+s7SPXEb0RYI7
	 f17MtF0Uau/qGHISgoatzFxTNqrjDypOAvrYJA97p/Vc8dg8zs+Ym5UkvPWGbUZJXHKEJ
	 xzsKlX+VzlnbLVUHWCP3E4jTyov0Sa3GHAENlMV6+FdYwOl2J3KoZHjq9u24zodHkWHqT
	 D74YiFOznPWav5Df3JRj8rHkdt35J/NmzswddoAPPFQwE/x7u0eAU59ke1XCrwaWomA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575842;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
	b=RzqMCuLAzoCtCJnYQ4IiReZPG6Xlgx/SIdQqMo1uuWGnOptG3SoFOxBZ5RMmfuyXR16r
	 HXczuMH9EhUek5j6Lnkx6jsj5ZwS8y8OThMQuDf+AjfaZCYRXetzl5gBQmWmyij60y++G
	 lElmu/mNydo8uEVherzD0ZTskMnfxtRSkWwzoDyFNKbyg695czZGydf5w7ys7Mf1cjpY/
	 hQ8B+2Ce4XX6oz8es8ae4pCDtDfmrOBv4UL6leNC1SIoos2yNm8NXYWDM6RyioZ9bQfvD
	 fWZklbOSxd680OrfE52sLMqZ07DogMYGbuseCA/9CuOAsqtnRNgHTM0rCFT6lqxrovg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Src1xL7d;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03A5606A31B
	for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 09:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C03A5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Src1xL7d
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso275388a91.2
        for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 02:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792575841; x=1793180641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
        b=Src1xL7dJtcD+mW+4kphC0vx+JMq83KXMH7usEwmz9UqBfkDiDbWNHsEfnycXz6ud9
         7VivyaxWw+ti00pkjfGK1MlvcmRnSq5gh2DOZe1/MkXLfzQ9CwFQo4aQ2ySO4JfEQmgg
         0kKaPeUdtyv+tdFE3MQcZveKQZQbg1Rm0a0jfYnlKuRomlWGdsohhjfVVyUNem/FuDZQ
         UOQ7jOtGhCzQwc65ruy2qqcKfbCFMfIvZf/jvwcPlUURw9h0goYmGrC4AXueXh1ipwzs
         YlYj1nXfSkGmLs83iusDHVYQG6yPl3bWUdwQLSAOWrFOjvo3JzVOZqQsBPeWon4Lgbxu
         S/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792575841; x=1793180641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mDee8fRVwNUSS62hfCgOdMly0KHJWoEHw3uq1wP+dM=;
        b=pWO2NDa0qIS9IWFQG21A+/DmThBhh2Aj+tYCGyQqVc80S9BljuFg2rt5bMP5gkE8H4
         ZawIzy/8hg+qsOngR8Gek9lyr7NgiXh7W/1xj5vQItXIHFGJQDOjdr5VvsX5zH5Zze6P
         2dMinvVJHSh6kD283T7rr++mfdRsCvDpn/PLvOWaWYSWfkibtRi788yydIdM8leituxL
         tsU2HRrzqwUzzFjzkIQaco+HG4XUoxUIiyDUf+pk1TIsK+gNMHB30l2BrN+3MbBNMv+D
         teazcacM1fDRNJxrJERRpOKAqw3jC1WcvgNgOzjMTZC64onDiXrDSpEyazb84BSRB0qx
         dyog==
X-Forwarded-Encrypted: i=1; AKwUvBxfohLqMZJ3MgBCxxSsjzYvsJhj1NVAwKxwErBJXpyf86dHwgak9db8T8aXLlrDfFG6cIJUm/n2yPkY1ME=@vger.kernel.org
X-Gm-Message-State: AFq9FYI7ZsgIMRXuhHBp6COFUvg85gLYxK+W+GJNpexxK/vpNtKFCgyZ
	sWCKVGEmpL1qSkNoCiJgHqiAWo9txbDlIU/s8zsSRG4MvCk9BVFTeNZG
X-Gm-Gg: AYBFou04TjYfsuhbrAhOHk/BBHrqkD6yOmB8vwnWF1TFpaWP71UUIlPNaE++E5ZyvzR
	RJxm6MP1zVco4AczpOet+iU0xGIAf3e/qtNcjBJJvcL87l2jESsiiuFRW+cPYfq6ZXd7dxiYaig
	5Zix2/WecDwauf5Cnj7zS+Ct1rfgQIqVmRNVaaHGfx1467Ga88+l6H+vkykESlqi0cpbGHZi5WK
	WiY4G3QG5TjvGcm+WlEOuFJyKf5eTBi4ohp3Ka31qWXdp7tXTny0G9V+WBL7W7Vaj+2+i5tM/Dg
	XNOl1OxSFfdgYTV6tHC3iNmE+wWPLC+VFHtfxlmEjCg5HbOoF0TnJeMfr3vQUjDgJwevchKDdo/
	sGGkxXybIcBWQlZO3OcGOYsV6ytGrUscb2uaPAtzI6DTACMD/CRkdoZX04ix7wOM+Pq2sfwIJgv
	KH9JHtYVqMLNGHTrRjdqmr1JM3It7/VKmu8R6xwSK61vQJy1r0vkHRW/OB1TmwfsRKnAqc4zkpb
	G+RIcSNdK2GSBp9kbGEAoXdBWjcmioafiZiEb+sR4eS9lcocZWcskI=
X-Received: by 2002:a17:90a:c887:b0:3ad:53e2:78c1 with SMTP id 98e67ed59e1d1-3ad86e980d9mr1157973a91.10.1792575841069;
        Wed, 21 Oct 2026 02:44:01 -0700 (PDT)
Received: from gmail.com ([188.253.12.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad8021d29bsm3644438a91.4.2026.10.21.02.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:44:00 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] scsi: target: validate REGISTER AND MOVE TransportID length
Date: Wed, 21 Oct 2026 17:43:34 +0800
Message-Id: <20261021094334.198599-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
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

REGISTER AND MOVE has a 24-byte parameter-list header followed by a
TransportID.  A 24-byte parameter list with a zero TransportID length
passes the existing tid_len + 24 check, then the handler reads buf[24]
for the TransportID protocol identifier, one byte past the received
parameter list.

A TransportID is at least 24 bytes.  Reject shorter TransportIDs and
compare the declared length with the bytes following the header before
reading buf[24].

A malformed PR OUT sent through vhost-scsi triggered this read on a
KASAN kernel.  The command is now rejected with INVALID PARAMETER LIST
before buf[24] is accessed.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 25b1bcacc0c8..ca1a2802aa22 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3226,10 +3226,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	if ((tid_len + 24) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+	/* TransportID is at least 24 bytes. buf[24] is its first byte. */
+	if (tid_len < 24 ||
+	    tid_len != cmd->data_length - 24) {
+		pr_err("SPC-3 PR: Illegal tid_len: %u for data_length: %u\n",
+		       tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
