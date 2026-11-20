Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175002;
	b=X1qXqFGs3/Qm4GAa5jNFCrlMa8LXF6UmgSwgz4z9QBJdr75YcNd16ltxuffV1FDZT9vd
	 +J0A6aZH1RpHT7fFi5moAp0pGGfUWwP5Opc3KsBhp895NyoB1pI/QQbhJOvaY+qOG5Skh
	 bvdD1P4VhRmXeI8JEsE8o5Mo/L4YykR6jbpiycz2eqq55McT/NSEb+H8Ip7HyQGXu5r+9
	 /Wp0FTggP4u51v7Yh0loDuuo0YYAhfLPdxgIcTwABYi+ezdrBB64dPlyx4GMxhbZpFOP0
	 kff4ISq61guTuezM2fONsWPS3pn0lzyR13Fp/fZhvr+ilpJAgqZ8VTyHTA/tynbxhYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
	b=wzjKkzVDbqkRN3KLQT4nxHXtYslzYoyQYWNY+fCfxskB6DNPJ6rA+oBSB3oRgcP3ie/O
	 EHUZcwC8e3dqvrOTJ7xqZUZaeCUIbbFvGh22Oc/pfPH+zwIgdO1zr38qhI6dnfp8764Ie
	 cZkiL5NG8s7UK9mq92q4a3mE4gVImWRqJwA8QMY0uft3QLB6KzWia6w5TrGcLCIayqdJj
	 sCT9xL5Mr+RFPH2mEjkDooqRkXsJLntkohI4yiQ6kBOQiYPc297TbOXmNnjIXJ+CptFzt
	 VUMSobAcfq+Qbaws8U2iORrn7BMmNVogc9A+IKD5o6p1mNxRoAxdRHFpVh+uqWg76Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m77It3AR;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEF4606A32C
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEEF4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m77It3AR
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f046b0adc0so2519895ad.1
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175001; x=1795779801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
        b=m77It3ARMTjZqUq6OHHALOtQGx3sLhRKjVH+4T4LeA6GJU6KfxYHZoeezT3crTOGz3
         WMYcQp4HQ1n4/6NmOuMqJjgl6tMjZSq8OZt2p4Oz/RTSe5muzguVAEV3K9ZiZXvq4BYk
         4bXui60+BjxYpJzNXvkR8TniBOE1SX7+NkKZZYfwbAlG+EsJjBfmNrhIMSJvSU1lfLeO
         S0u6E3XfNqGdxLCyIHG3VNw5xPqy3/SAPcs1XHNezg5IuBEug1VOjDGUyDDyfMxqnoZK
         8dwMC6e3X6eLC5hVy9c9q4JkFcTUAhvQixkb29zsfgsiB9SEKNemejt8YeHuUHIrKD59
         CeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175001; x=1795779801;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVgtKYkwPgYU4uayGBjffLSsBvG0HKLAfvNm2HOLvA0=;
        b=t5xADpPbc0QMdbT5Nj6wuvjQoPZiB1fz6rS5jwwna5U0y8+G1HUtf1Qyq2dRINQhpH
         4hjOw8c6e4oDNnqgYK3HwIaLuTZV0WEyVkXtNf492qQVDkRfqtlnbP+uS3OV9/h9Eu+k
         Ftjo+HAXDNkbM9q2bs+0LKuaaOmU31D12pyxAF3bhK1Vjp2MgF2k0kTZMgkpcnJedW3k
         9NdBwihxiaPhuhcU1XqxP7cRRkBpK6hXSwfsldnXzHrUmoFcJ7rwXRU3yAdOY0Om6j6T
         eBEFSzkz1iTF77PJHFdXkxCZKSah2840nm17z26z8N+O3WgT5Xi5w2g6L1yZ1U/aIAo8
         NjDw==
X-Gm-Message-State: APuU4Z+tDtSEq+VMYcp7OXbL75oMOpokeAYmHV4PjuQsuseLvyrtHL/s
	xBdC25eCNlzNsW1Fa6F2jskTywKZwZQ/eO4+Kj93qciwobvGC7L/h1FYdO5MZiU9bWQ=
X-Gm-Gg: AZFdTZdNF9IpcHI+itpl6kzcoKHpo7xcPKLQppm2DUYVBsXE+m6LFyIrZk6yCoMvHr8
	FFya8xWkMZUyshLYDBA4rL5ENfB7pjQGREBpL7kun8vweu13R/yVXHeGC1tKjWydv9TWUxfKdC3
	LaayFK18M6i/XPVoNPF53yv4xeqhfYRGDzWYSTIxqenZEz4g7n16ke9h14OlFmT+CHgWf7DAZCv
	qo/Mv0mqLvXB7hhg5kaFfB+DoDo+nog2aG8MeAtcCQwm6/ic/b1mUj/qpkzp2QuRIAagyFIRmHu
	BjRFnhoVqNIx3EBQIyXFtepT98Cx/HcxAEttIKN5Rw9qdCxRQrpR2GrgACLX8NSswugkXettKS8
	9wOYUuIJ9jnXgT079a3MLbWEkXBAZwfCCbkZcSq8r2aVk5yyB2NYuCNizYVE6G3wrRZuESHRspf
	abu4xkxKhIzvkXUJIwflb33ekfs8l2F8PKSEC1MHazOGfvd9w6J2jHmYM0KEluwgnS0LrTKqbzg
	wiLM3sjQl1HgXTy4imU0pvDLG0Y0MTun4me5TevFXwQsYfvcRHdlE9dChMsPdeyEWpt8rewYzg9
	WR8xufISTMX/8oA9o6vCGu82Rr01BgjSGgN2oXRzmPDCNwpPfUFch8eE4ZYWsUcAozK56BtzleD
	QyUnj3g6eU7p8VDVPtjaxDP8dLcDnx5NhW98i
X-Received: by 2002:a17:903:1ce:b0:2ed:d1ff:fa8a with SMTP id d9443c01a7336-2f03f147f84mr27476485ad.36.1795175001342;
        Fri, 20 Nov 2026 03:43:21 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c2091sm13072045ad.20.2026.11.20.03.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hare@suse.de,
	bvanassche@acm.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Fri, 20 Nov 2026 20:43:16 +0900
Message-ID: <20261120114316.3072301-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
