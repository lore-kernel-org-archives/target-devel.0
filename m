Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739231;
	b=KDEtR78m7Z3iGcTkdkNJYAt26oUb9R4MpgLw+1qk5RSar9tMyX8HTfgddJZoZvr8GAbH
	 frjKqk6wKsXibncFNAuDEFuuhRnkus4YxS/fXT021RO1bf184iLrc+pziT6FHtJpooTf4
	 cAU1S4G5Bh5c3n/lav/1swT6xiIzZphFon3jjr1ZpCxLSw6mm7Urag1iSLldMoUkuIkH5
	 P8koYo3Vn5CSka8aU6C/mNisuuN5AXSrkSmKobmSY09z9Vtn484szW3A/gL30iwtoyzwM
	 yCkclr+ItuDOtnZrTlnuXOc0MV8f0Sco9Hrpb3Ucc5yExWxkf3nH6FucXJpHdk+VTxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
	b=sSXISADLSSukgi3Bnxeb7BZVBQbpYfmEQiODoMGBt89XgO8mtc2BiXEVpOL1Uq1WE2Tx
	 rn4QzIyOGAVmjb3G8hp+1oFhFlJ4OJMf8+wXwf7qXfv2COLFf9e9ysClHWnguMW10om4k
	 zd+AHYohpzMt1AIkyNfaW2hbTZLph9vTRezTMPWLlBU1xUqpm/m3adDG60RlcU6AjF+wF
	 RIQXxQ7anEu3bp1Jt/REVXnlvKrbBSp4uaOWDnSwt8Y4qCdZexWog72gSo+MFyHXN6O+V
	 0bugnlOQS3KFELufpPDb/qZnEnPJRG4mmnVnOUAkC0YDQTmBI6BwQIszWNTL9f+UPUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OPQa8KoE;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0AD606A31E
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 10:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC0AD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OPQa8KoE
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed1b9e8f43so12338615ad.1
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 02:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739230; x=1795344030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
        b=OPQa8KoE8NBz3masLHOa9NpIYzd93Qy6Av/TK/2YtXrNMgSbxwBHTomVuGb6UQEXH3
         V8WWCtgwPExlNJXpxqK8AsFYFsJVyqG4cJ/p//GyUMf5KTEOjk91J6y6MdTx5XDxcLQb
         e/48Es7FElgrqsmFukokBnUVF4t4RYYgvBB2p4yS35M2HmgnqtHEfo/rxhtLyjDztmEs
         3RYqVxEupOhSNRWAvbq/jzmNKnVsNBe9mp35/AIOALzYyespId3qbxRkGLos4+JlsHP9
         JskTlyN3jIQUOQWUpDLRKpsBpZa9hsu9zmS0tnMjiOI2A6HT8pm4EDo4BXPtxfz7ga5i
         eAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739230; x=1795344030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BwKMmAKqPu7cs0jztWGbf0bxcekRUKjcR30xSolmQKA=;
        b=UBHFfapRR1yQQlHJwfBLVGOqjKAm87JQYXn7X7cKlzjFihXb4+HD6xt8NETSqyxwfV
         ZPwX1udYjt7ZbgCDoCrd+4+yKMPhAhbrltm7iWdA/9+EMm1+uFlfugEjo25gX5JgJA04
         HySTJLDLhhSHd7IB677uFnHosMKEIlL5TZki4ncneFmXd90MMU8gsQX4OSSNQpwzn2/E
         p0Jx0i+F+fK6FaaMWDUjo5fflblqZLxBVs5WlJbVqj7rDq1R4e+g4saWoX4Ohh617EdP
         spF3cDyjjmRFRrr+ZKKt7khLs6YNSkXNcXS/g22vccmZLfrVNZmG5ca0csNBrZnfC+Ly
         1J7Q==
X-Forwarded-Encrypted: i=1; AL+hErG/wuaOXxNIMiml66xEzvZ/+w5n6LgdIvzOJWev2WjnsCwGHC2a6m241Xf6iI6i5CAH9YkpOjjJDblTi8o=@vger.kernel.org
X-Gm-Message-State: APuU4Z9mGGrkIPky9UcMMmPI+0eHHWpDB+KcjzTmENMfUBCQXFKqCrAX
	4VJXFbVJ/M0q5gtOq2JHzDtbjSv2kVZOJqSazj4uXdUSTPg6X0QblmXC
X-Gm-Gg: AYBFou0wox85B61zBszSz0acq9Lcjte+pAe433MBrFHP1sEUB8KP+aNN2qjqi3dIQcw
	sX2i3jSIsCqqOKO4e961KItxb49oOYpUn3Ep7Ko+2orbRPWGEaI080tBwztcx7OkoHeCq1FDu9C
	H8w99dhuafOLu9Sw8p7+H90zBgMx00jkkeGQvWg2TySC8dnCtKDGVOZZKmKBB54PWU4SwlAXs46
	EobpMIrujGmBnGbfrgyXl7wo+bj9w1dJjni2JbV3tTcWS3kv3M3m9XEx/gWLAqSj5oP9wCLSvwF
	lEcTi35J6zopOodTQZnLe+xV83awFMb5c58iTiGKf80BaWBO1ps+0a8CKZ2RFpR4QrZVdafMRIj
	O2A9i4rgJJlsN9lN1g5M7QvUhvatEMzKN4xU0lDwlKrW3Q6P59zFRBq/8XKHuVq1Y8i2HLOY+CZ
	uEtxxAeMxfEDhkKLwWhWseHwCFRL+e+IukPWOdV5VDUlVIteRhwRVArDf2fIduZAjAFQ+BDPA05
	pySwWVhbVvPRwiVgY+PXZd7IHeLypNmHC6rp96AKTm3ZBQ8D59KRxjnm+ZrNuOqEQnqOAnzy9w2
	txH9eyBOt5VR1FZzEe8nVxFxvedzXpvtEhtJxNj8/j4j90+V2Haz7NXImMwcqS1YrqmJ2DWSMhj
	RMMWksu8uLJNUm9FD58nldEUWMN60VhKcj7qG51ydmnusOoE+/Q+d5RQq+t3BXAmTHF9HyFXwZ2
	+wWzhHLuMhjXYh3YzqW2mg087VBh7+fRrF24Hh9IjafV2hBICJ7XDiTl3u6GQSzgbUP58DjLnvX
	mQZgo7ZlbDkgmdyXoO5kSetWMi+p6Mtej014xjZ/9EghxG1ZHham2fJc4uH1gt0
X-Received: by 2002:a17:903:904:b0:2eb:a1b:e9e5 with SMTP id d9443c01a7336-2ee0e0cf7c4mr80607895ad.52.1794739229907;
        Sun, 15 Nov 2026 02:40:29 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:28 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] scsi: target: iscsi: fix session use-after-free on non-leading login
Date: Sun, 15 Nov 2026 21:10:04 +1030
Message-Id: <cover.1794739041.git.danjwade95@gmail.com>
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

Tested with KASAN and lockdep on mainline against a target with
authentication=0 and one explicit ACL.  Compile tested on x86_64.

A reproducer is available on request.

v2:
- 2/3: re-test every condition iscsi_login_non_zero_tsih_s2() tests, not
  just ->session_close.  The Time2Retain timeout and the multi connection
  ERL=0 path both reach iscsit_close_session() without setting it.
- 2/3: publish conn_state inside the attach critical sections.  Checking
  after it was already LOGGED_IN let iscsi_target_tx_thread() enter
  iscsit_close_connection() and wait on a conn_usage_count that the
  refusal path then deadlocked against with kthread_stop().
- Both were reported by Sashiko AI review on v1.

v1: https://lore.kernel.org/linux-scsi/cover.1794732723.git.danjwade95@gmail.com/

Daniel Wade (3):
  scsi: target: iscsi: factor out iscsit_stop_kthreads()
  scsi: target: iscsi: don't attach a connection to a closing session
  scsi: target: iscsi: don't re-arm Time2Retain on a closing session

 drivers/target/iscsi/iscsi_target.c       |  6 ++
 drivers/target/iscsi/iscsi_target_login.c | 81 +++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 +----
 4 files changed, 86 insertions(+), 19 deletions(-)

-- 
2.39.0.windows.2

