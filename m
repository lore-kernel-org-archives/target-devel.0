Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679992;
	b=AR54fsqjLG1OGYASHB+vYaQCYgXo5+yJlShCeqrxQYlU8BsODmu+aHrqCVe31N0PprC4
	 Nrlq2MmWlRF9vhDQr7CI64tmpxF4XrGhLJbC0VDdY6oi43J7Sw+CEY+ioybEMj2oxuanI
	 TKzpwD+YzATIglDe/U05HWVwig3oHFm87iUBkvuZcCjJGid1+L1HIKztuQwtmDKttGdv/
	 DOQaa2vLPKXlp6qHDzuENjaoDTLYDpNlBfGDXNHhNW6QLq764FOi3MhYPesQgimYlw+E9
	 Q54O51rjwOUQqeScKomkye7NegxXTmpNrKfe8i3IRcwN52YBSTJQleg7rT4G/UBJBlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
	b=S9RRh1hsdIOZkcIa3/kMVvM7JN1745gAXtGLc7+6AfRYT5DH2cw1+9MxMsqWbgMyNJgd
	 aAMqnKJ+2TKShGMkGr6TWtSVBtNtyMhb7vqqGEu1YxDD7h8Az9RjmPAWirm0KtBAwkDtF
	 WiPEzcZ/mm2OtKU7gsXFNR80BYYN86TcAZN6Wjf6VirYUVmQ1jt5ujl8OSEP0mnxzPgnI
	 N0eosf/VeK7uu5Sl0MMgy3j/txQSZ4VznpRkZeYe5WkcF5jMPZifpsmFs5URY+Kf4xm/g
	 OmwpNr+qDpOWXZwY6vwXpLtbGrIVJ0h4QqQ1GwFdAdznAYJofSfq4FbQzwdqHm+DF5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="HPC/DVkB";
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D5606A324
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 14:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 384D5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HPC/DVkB
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so1133671a91.2
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 07:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792679990; x=1793284790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
        b=HPC/DVkBo4HcbBXil45ZFefmZkRsZyJkf3WYjjWDRzkhswnw0IxNmsVw/vWBCZmtpL
         GfdrFrThBDAB15NBTdsVsGxhZ49VDftZoWjPsXHPPXBQt/bnhHp3WHvZbjWolg9rrmJb
         rVJx8p+uCVT1r+6J+5jrppkkxchpu8L6zqSdMJk6rSCThBnfXMYWZBH4a9V220QNexTi
         LTQrfnJEr0ZCGQ/4+GEqCOdOQgA2C5MDpb6ncaOU8rrbCEKr0gcP/5qr0F39vqXTyyvf
         TCSwVfEWwVUqRPS/v+ao7k0KAHkCrAUTaz+4BH2eGa7JqttC+rCRT3HVbHDfoQDfEKKQ
         CJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679990; x=1793284790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
        b=jHZvVIPTjeY/LQ9TMNwh/lLPKAFyODzzpwJhWjVGyC6Bx8pp5aY/PoRwmOr9a+0OVL
         Z/GOng9kB1R4TJP1F3imxoihF8DFT4P0yl8ekPN0szzrWUrhMU4A/cl/96MqnDjxagB3
         wBtw3ixpMjeTl8mxYu3no23y4K6b136XF7Wy0vyNQjnFKe9vUQgfaKWWk+y3a7rt4rUy
         y97h/TkyNdn9xUIiXPM7pg+WisRU1t7zcbBnn89VF/S8VXRKl9XDTzjqRTfIp5FXHgWs
         YD1OQa01v5bbr5Q0xOM7AFOzBSpLVLeFMX15hvSaDP1NGNhdV73BC/FRlSBPCAintyNH
         X/mg==
X-Forwarded-Encrypted: i=1; AKwUvBwhUUmRFwGRn+YovEAJfGBsYw2b4CFxjEgr645NuFdDQstkjLBkTEVt3MTZ2rOBEL4mtkuPDBLR540kJV0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJPCmOivpJ+nXt4Sbb7QzxOnRKzLiI67dDF4aPEXvuOJEHE9mpQ
	0eUS1W7N7D8KIrvZxZaS5glDxSNhWPRxpsTNrh0x9XpXirbQ1XK4ZuTciyfy2cEiSCE=
X-Gm-Gg: AYBFou1Z64TAPAamAIGvcH7z+D3EqJKQgHbv/6nZNSSX/InKqr0E497BbO34/cSe5bu
	DaFBnOa/N35RIzWf7aqh8mUjl/7EWI9NOPi8gIcgBExxXF2VYzHUaZ3x0MtYAtjKjSRXKLF8tKj
	YbOhJG7UIRQTVw4+YneBJ9OqkzYPPvnUQ681ohxp5b0RC4oSzCm6LPFxtu+Ys1l4tx5YNQWGT7z
	54G1bEFRi79+rqPmcS46qVbKtQhzqh+cXvHC9RQNHp9fkPnWVJbt3IWqARygLwogoj6p9AWSt+1
	lV27NcaeBpRwlheXkYPkKNGny5nvWNKCLrIsLfFD4VrdQKiLlyWBt53ZdNDcSK2z1Cijm1xtBG9
	BK6lLxK1YEVFrJmadwclomLRlg80cU5UwmEmDiCxOgnO/GOh4toewPqrxAL0xt2d8i62xvpPf/b
	1E7IpCy/IyEmFn7qGlCRLGSMH8SFuq9qV8txRjWWw5KxjdyPimxUVBrQa0UoZrNSG/Ge5OKPWe5
	6qFubA6cIf1K5utyfaQnhNEReDjXb0ZD3iQraiUaTw7PleMNvOqfbW7MRbwEwnm1nOcVtJIuEVd
	e7E=
X-Received: by 2002:a17:90b:1dc1:b0:3ac:80dc:f407 with SMTP id 98e67ed59e1d1-3ad86dd7f06mr4369996a91.60.1792679990283;
        Thu, 22 Oct 2026 07:39:50 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4887669sm4719043a91.2.2026.10.22.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:39:49 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/2] RDMA/srpt: fix the indirect descriptor table bound and the context counters
Date: Thu, 22 Oct 2026 23:38:59 +0900
Message-ID: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

Both changes are needed, and they fix different things.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The two defects also come from different commits, which is why they are
split here.

Changes since v2, all from Bart's review. The two fixes are separate
patches now. The widening patch says that n_rdma accumulates the
rdma_rw_ctx_init() work request counts, so it can pass 255 with only a
handful of descriptors, which is more than the 256 descriptor wrap. The
separate descriptor header pre-check is gone, folded into one room test
placed after the existing count guard, because the header can never fall
outside the buffer.

Yehyeong Lee (2):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 12 +++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

