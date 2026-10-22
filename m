Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680355;
	b=GFehD8sBCx3nn+ieNfVUaGkpxhe0L5ay4Zbq97bcQeRg5tMlYjs16G7O+4PdMSHsMAUF
	 7cMGqHYdt1GQWZn+RrQc8Lh9dYYYUcZcZYhVov0imyuZGLy0/LytRheZ2mRRffoR81VV2
	 5KjwFPrZdSRaF4d5af5J/czuyP5saXu1ZmWeYtS/3FwC2nXgsVEM/1O+JY5TzXO92LxQx
	 7gcKWaC+eCIYzhmzB7VHGdRktnlgT9RHjslMGJvUPe32otUSz9VoPcFmenH34YPUbMjmJ
	 C1W5wdBR4WhzQexXBb+tdkSVZLcpCgxNrk1+/jYO8C4mces5wVAl+p3DWG7X8oqmpMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
	b=LxLkQUy+xCvfiImJJnQKUY34M7T3sYwJOnL4a3jM7efegeaFyReKWwo977HOwySmMr3G
	 hHQqlrMvNdX5ZCPjOQeKnACNztK1NNgbl/Z4tr8UwWGCqFW9rlt7cMpzojzB3PFoqCblr
	 vq10pcI5YSmulSex5SQ5T0ovD5d0g9QgPMaDNT6f+XMmkaUS4dJJrYabEeEZJyAJPWgqj
	 51GJDsu4YxHeCps0zMnjrls1mFLP0ZCxbBNliupbiositB1ZQouh+nvD0LKvfC+h5kHFM
	 PjpJP0TgLlOyH3Kum8gDj2PcDhJkX5relyaB8+8oBBjZXj2UGVNo5fIdNCUkLL0k2jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qBNLJbzy;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6434E606A327
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 14:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6434E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qBNLJbzy
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ab98332238so1447815a91.3
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 07:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792680355; x=1793285155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
        b=qBNLJbzyQ2fv9FJJZOr8XO2+DYEM9XBI3CpfM2+b/SPLKiMsDlJZQrMSr++dmOT1LS
         OxzwP8FIXM5d/9mkVTFj6in4DKBcl8IsYD3pldGLfLoOYLfFv0zVF8+1oqWZVYLOHPh6
         z5KS1ApsTdd5TJFmv6N3bjVE/QZz4IDsrCRjFue/lWVRZPMjYWCzez7jjNwnQWZUfxyP
         bBA3zd4jd7iWBpgb24N62Cc7h/nlKVB8tMHrLZOk7D4ZVcUhtvsjhzkP2eFPWbe3vKnU
         glLIe/5+aQutul0CSUe+RWL4WB9TbRonzcS4ZMaAYffs7UOPI4Qt05s5PX98DtoF14Xp
         gtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680355; x=1793285155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
        b=mckQ0+0egO3G/CKbGRE/ef7nBqYGpv0R40gOgGDb22l8Ev4/Ip+0IHr5LD2EzFKe1O
         uIakqQmBPGHVrasQacKgWmxqEEmso9uY4yS6SZOFETrfZsmMYLngtxXKu5GbdDWD0yuv
         nKLqwQTAezkKoTazI8iXQ9gNwdoiXDmyzCgYF1bpm6mA6ScjxxDcVo9IK8bGrUITPZup
         nYjw2qUqfkqSpj4DbxeUaaQJJ9VRG8cd51HyELH14NtDNyPsoYOo6e1dFabrV5aTO6B4
         4kB52uaM4jUTjqRVuZAA1sqyS94n7CUkzYEp1YeYyHVSeYcO0J9O3iSXZsR2Yb/abiBz
         Oraw==
X-Forwarded-Encrypted: i=1; AKwUvBxnA5pCH1LqA3VP5r1gF11QvwT3T0V2bEdGkSQ2VZlwSy39dyuqGY8Ceg3kgeWIG5yu+Lt4y7rMpaWJ/IA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLiBThvR/JycI4EoWK+GczFNGq1iZzmTLbcFMf1WFptnStQrtFG
	S2yJE53wqgQL62YahqaI5EPIwOrugnJ6CZ+wCer6Ywh3i5U5mrW9TnpP5xyzkLzx6JVni9lo8Os
	CrQt3
X-Gm-Gg: AYBFou21Oy2Yr5D0dmvIPC1mQCEOtozfE5FDyokWWEN4EcQNAG89rOYivvqWLvEE2iF
	jyrBI24wMpkf8Cl7Kfj7yxpx0NLbF7SO8EmgH6v7OMvrwaxUqaR5n7KYDaVpFGV5M4s6rNXkKYu
	3jHuG1JQJjB71lzIOeOZ9Ba5cBl7t2w0LM/yWuYUaaWhoJ85y5GCFYl4DsVkbo523zRJhyunrgs
	W3lU6Th6ECdlnIFzLSMSdShtxrWbqgfSz9r+Rypv2WMdak9PAIUMmSSocfft/RnS/ZMcgKQCgdX
	x5zujq89w8G6oCosrNBKW4RGoFHbUw38xZcnbZrGMc2GjQH2a46vBWVoJpY8BZADUxuBJfyTAyb
	uJcVCV8N6Glq464Ef9d/vvkpmbE6izc/SQvOb4TazjSydwx+bMns3p3rkAxO6Yu9dLVum40T6Bg
	1dlG5FFOgBPzGTmdCw18ZoLDc9v7nRG4AFPuDXEqqHi/TCe8IpZg37uTUjHIG0o3lRDuqgIheeg
	dWtO06uJY1Mbtsfqg+LXVmBa3vBDxHjL7OKiywEdFoSFCEPkrRiX7EZKgVS4K4XiM1zPucQVwvE
	tG4=
X-Received: by 2002:a17:90b:4d85:b0:3a7:250:333e with SMTP id 98e67ed59e1d1-3ad86ccc8a6mr4599506a91.11.1792680354722;
        Thu, 22 Oct 2026 07:45:54 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed74bsm4551444a91.3.2026.10.22.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:45:54 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2] RDMA/srpt: bound the indirect descriptor table and widen the counters
Date: Thu, 22 Oct 2026 23:45:18 +0900
Message-ID: <20261022144518.2991452-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
References: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
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

Thanks, all three are addressed in v3.

It is two patches now, the descriptor-table bound and the counter
widening, each with its own Fixes tag. The widening patch says that
n_rdma accumulates the rdma_rw_ctx_init() work request counts, so it can
pass 255 with a handful of descriptors rather than only at 256
descriptors. The separate header pre-check is gone, folded into the one
room test after the existing count guard, since the header never falls
outside the buffer.

v3 is at
https://lore.kernel.org/r/20261022143901.2991062-1-yhlee@isslab.korea.ac.kr
