Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755448;
	b=QUbttXV+OQVNln14xUymtXtml3AnE5PFY3uyaNQVFrpnBKlJruHHshAZeVyMzfc3Ktfr
	 K7XlQ38QjPfEkqBG/BjAw9GKa/NP+zztdB6S4A3RkwtZueYlxS41q6v9JTBEiIyObi8+5
	 v7/wc24jyGa2KApWlqHp6Sy9JpQKbUWANaneZqnlX4UWvVKAGHRx4lbsc7C6EibELwBI5
	 CaGweEa3AcGNRK5rkLhT+8csqXfirniDNVK85oX3SvTxqgffxANDw5g02EpdlxCKGKbHx
	 RkGobJ3+LleWPKeNY/NKVZb8OjRY13hhyHjTsbKTDiehlKpbR0GXiOYCjpZ/wNU45kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
	b=zn1wjqyZggw7pBQA8rG81jYeKhMOu/vSk3hL4FLxAMPzjbVStsJAJlUjFs+D9hlYF5hZ
	 nIVrbq12ZIhjh7zKkMmCZ1wVohDh8c7A0zQj+ItS8UiIrLvc4X6rXUYhtqnw0FL0J3i4h
	 wP4laB9RX/PX0YbBxuNcscveWzFU0DEguv5M0D5/dWuHtvN/eRkv+02+5iz5rQSJAdJ9b
	 IPq8WOr0VKQvzhZYg4FCxVnenbMfeNgxzyyliYX1qYJ3zKPb54if0qrpJhzrgf9MtgItB
	 YVzbfPaW1Wr8cRmCmWwzQA2hO5ycqQ2WfP7fhvgw/5VBy0S7PwcjxczaeFw7QuBZYjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ERR3wnij;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2FA606A326
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 01:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA2FA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ERR3wnij
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-89d6bd67045so57430b3a.0
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 17:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755447; x=1794360247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
        b=ERR3wnijf1jsNe9Qdqkrh2JIJmXEevbKnf+o4/cuu88tzR0YfjP9dSlA4F57zxQb4D
         QKivwgmy/GbarHTPLM4iSd9WnrR1MwjBJP8Go5n66xS0H6BTDiRl8FmeH4U2j0YIgNs5
         RAGMiAZMw5EKRNQ+jAayyZSuSwQLTJTXdQtQ0+yxM1BVSy2V7vrx6yGE0Z9iHhLtn2Ly
         0reh6wCVlx7p4D4JTMBW23HwxJdfvFIs1r83PgfUZqgCK+MmPnIy/SW+WBUDYvUBAyrz
         qouD5g2fA9eRU+ZgVWGJkX7Ej3TpGus9gKsbG9bCfOLLWinmafn69IlIkNGvsHRxH7rf
         hh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755447; x=1794360247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
        b=YTHXdxLtMrr0xb7w732K8xrpMhFHnwHOsYjBpVZ4pt/SfI7uGVDYsM00xZyNivBm19
         f/94iqujjY2eRjrXoW/sztk7MMVPUaRYE8DzAzhkLZ7bMaN6QleIimys8hjJ4O5dZXBa
         WkxmbMe1nLVNmI8DH1Rl/WRLfdRCg/YUQTMlnkCwC19DwkXA9cldGVxeeYXH0vd5sgcG
         VmDMdH1hxSkPKAlQ+iQyOApKyLsQm1M9HWh4HvlpoN6tHLRdVGWp7/sNz7REfGm5gqMn
         lQ7HB2CgSaF01HieCKa1ASdg3us7ij19DTzAgAzOIhrZuK4M8GOPla0IWgCcitJ4fn5t
         88zQ==
X-Forwarded-Encrypted: i=1; AKwUvBxee3df0I60S8xxaMXPIncWuAJelEgt3H5sR53O4K9V4VRGsUsy1jKjhF10NDHl9D9z6/gaMfZmFc9Tl4Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z/IQQvsyEaeIcxACm2usUpKeStOLEHjbgTRfd9a8lVHKd7GWYrX
	6TkKUKkSGyYWJU3BLJwLG//+HYPxMRJ7Mnb5jbQE9QJWqetOXGvICfQ4W3J5mlOFliRD9/OvlPR
	ulqcsUpI=
X-Gm-Gg: AYBFou0pcJCzGBBjyt8HSJ+pvlJb1bzfW52S5OpUfuLio1BSFJnDENpnAt288nkgPF/
	O9t1wTQYerYKbxwr0oDjsmaTWbRghIIT938l2JP193ZEph2hIr2Yl0g18MXibW/zL91Gizr6e2y
	jO9a9ZhA6S1GMPYP8zOJzaz3nm694oupFyEL0ToFNCFMG4Ty+BaoadA6GdYcqkcEHasj+/Lb1U/
	vRw7T1mQQlfJzJwpdRFI8mM0dScfoWeDTyorsRN9G85PIdjRpdoC8MXm82h6RFMtvIl5sv5y7Yt
	pVYHYBFbWxzpi7kM2HwUO5DycTfDKlAt7flLoFGbY1qBCe4w583AilrfV8uauyeV5+RI9QqlMT/
	sJRhKHvpIWNbq1Ak0UYD4tCon6W/3Tsuo2Ax/gp7ohszkMccfCMU7KsSWbe1SOkNKf+ENaaxm13
	0DvCWCa+gfDBOuhGO+lrXf3npezLCoRq0LVHi371qtjzQ7QEao1Svw7x0nq81DM8dcu8uvJ5qEc
	wHKAqNbxsW3cw/rgWCnG1t2ZvqvXI/ugSBulNjy2yevDpLZhC7VHAQU+SeWz+82D2cSWxRBW6Kf
	O4fpuCUS3pVcnkN42eK695wTnlrsUYDTms7PzztCi79vwdrwJbuICESC3TA6t2IxlnKoRfkAgjF
	biG5z2j1uwDVv9wBV9y8QAiz5f4UbAGRRDnOp
X-Received: by 2002:a05:6a00:a256:b0:882:2195:5a73 with SMTP id d2e1a72fcca58-8a9bfde0494mr7910507b3a.29.1793755447467;
        Tue, 03 Nov 2026 17:24:07 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09a7cc082sm197577b3a.12.2026.11.03.17.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:24:06 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v6 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 10:23:58 +0900
Message-ID: <20261104012358.1759607-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v7, which addresses the Sashiko review of
5/6: isert_remove_one() now sets the removing flag in the same critical
section that clears the client data.

  https://lore.kernel.org/r/20261104012219.1759523-1-yhlee@isslab.korea.ac.kr
