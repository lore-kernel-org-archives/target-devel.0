Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792860485;
	b=AC0Wu9X/M+mEdQ2xA0KGxXIscdHzCyMAPhrIveU5v/mFuFZcXMAms+4G4sYnw3XbccfZ
	 5VCcuLWtjhYacpZzq5Ez+wiuGxDdOmE4SFuBErr/DSZsj63xBA15QTpYv4JCyA7L5MTOU
	 +6jrnRXRvYBfpWI8XoJlhrKB7tRzDDv4h/gTSehZYGho5KxXjtZB2T/CvyelWc1t7SQn6
	 b29bDiTTJHflN+Xtt0hVuhgJXpvxOlsNfuHDHzgJxsYsVtSgd7nlduV8yo4w2QyeOOTd1
	 6ov7PeYbBAcXpqYXcnVPxGBTJ1eSBYDvGlC83QsvbdR0VbmJFeEaOSyFMe6RnxiAGgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792860485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
	b=VB/vCeKgfWdHFOXv9BABerZJEOrcUt+RpH0qaGjVsr198UG8qQTcsX7OI8l1WivqqR2k
	 bmG5cpg0nqhruXzPyUCbcaNi0gaifLYhmncHqh+f0pVe2KlAK7Xn2lww5uVzB4yRGgv7s
	 HU0r+Zh+bkfxmDZm/pIdsbxyoT0toUG4Zuslp8B588vHB0RdYSNK3VXSwTtwmV7g6Duyv
	 sOpacnVrM2LLwYvTAiBRBX9buaBX+uWris9W4p3kHSRsH+jixwRIeqWirv0VjJLld3ckL
	 9MAZA9jvGUpZE+3Kx5jl7UqH/mrqnapGwAxIAMUI0F9Ffma4hezoSWMSyEvvRW6dkLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=doFUy87X;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8175C606A31D
	for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 16:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8175C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=doFUy87X
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3acc96a256dso1010427a91.3
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 09:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792860485; x=1793465285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
        b=doFUy87XTMAZBcgxsctiSxQm6UY2QpLcDhFXPl7Q5FUufUfrnr0IqaRvQy5BGIFsXN
         vDPq4a5HJGH49+CstisPR4zii7cHvgxSckywC3Fleysm/+e1Ylp3j6+Sf9tPZOAVSr0t
         C3wBSCcyGbaHOePNv363BRwrX+IXsc7p5m6cpRTkbNWuTQ9CXCaBpbHHvB9cPrS7fFU3
         m+O9ye0KZqO0tobxJ6zIJecaXb0z2SjFQX2/iZI2JtntPjQh0DU5WjU9XRzexzkNrsYX
         JAMof+kEyBM3D2wpT+oCXiqKcuA/vnaOGSRS8Co2I+dbSdSI/1VoBLCVPtbNYaYlIqAW
         7Opw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792860485; x=1793465285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
        b=XWr/mZXcFLlJGCMSw7vZVWf6NpwhZ8mhGSHZrkYmqYncdGvvwvBmlGSivR1vkK5LRw
         sbxtr7skUaIU82C8P7IAjYC4Mj/g7EtpuYHlNsNcjCnVptxV32w8ltCqZbXg+senVeRf
         epGtkSuvzz5VLS5Ix7o4eK/irEF1l6EkuPyncQlKijOKKPCoorVKSiZIUuzEENxeCXv6
         kimV/sKld7H0Dt+ySHL7r6PDVRMeIAIf1pULBplR62Sq/vyVKUY59M5BfuQqEebblOP/
         n+ahyKECPtoMwox9smakDk5GNqypcfo02q3TF+XbN1kuYYBT0C+uNkvQxf8MWsYr0Vwj
         OYFA==
X-Forwarded-Encrypted: i=1; AKwUvBx5bxqqRSzcHAepGE8iHxlqSeDR0kj+d5O3uHeYYd92u+w4vLUzaDWkkPx0oscylWBV3NnE1nmHx7Mk5OA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJhOn+YA7l3puMUak0c2715m+1LvFDYU5NLVjc4PlqxfZuwDRnV
	Sq+/Vc/W52t57JUiGe74BtQcXgLfY7+Qz84CrKkvidoBwdftl/eMcaukFiqWimlM2oo=
X-Gm-Gg: AYBFou3MDzWkFMHbwAQ+HPh0cugx/ZsO2bu73uf1P8O1VImrWz5bVXNaYhLEnFUIM9X
	6XWr0TlvrPexLIrcz4zOHn6H68HwJF7hg34+xiYm/COvpd+zY2CgCrmRezUJ1/wgqDVxD72VLdm
	2BozNnlJl/CT5FPkWzxbATGGntmFcB9AgsozKZrOOjy6NnTNhl+Og5HWdpOSf0NK9e2HnMGl1Xe
	CHfikJ4m8cbp2nqTcRPdh1cWchfFERWBxGfctxw5acNbvP8TYzmD6tSI19LibqoMcYQjLYh9I4F
	H/8To7zjo9CKngYgzDrHM2M0dsd/o9UYfLc/H5vT4U2M6I+00gRQOc5s98E1iH7UKlCegIAq/zO
	96ww4H76V7T1k2Y6+kU+AOsbayq2p6VEz5MBewHYyIVRLhHK7wlP0wKdhtQvLNEeZRuvdiI/nmY
	pTm1+4Q46ZaYZTU8yUw7/3lT8wXFM0NIwcZ3fNX4zlNf4X3zZR6WSGzqQZD6AUVm76PUaj+F/6F
	W63Um9WhoHbx2mw06Y+LOJD4sqzTEtizcwkLFMtlyEfqGE0lDIDuvbvvjQPc5kjCkPEL4E4thLz
	F8qF2wZRN3dXXR6z1g5bjMNJJm9KhQGjY49j1h03Z0KJRDHFFD+uDkXiTjhlV2xz
X-Received: by 2002:a17:90b:1a92:b0:3ab:189b:6981 with SMTP id 98e67ed59e1d1-3adead4fa0emr2149206a91.48.1792860484851;
        Sat, 24 Oct 2026 09:48:04 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe6af24sm3289037a91.6.2026.10.24.09.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:48:04 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 01:47:51 +0900
Message-ID: <20261024164751.3531142-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ea3e91af-53b7-419c-b83e-d70d002ea321@acm.org>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr> <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr> <ea3e91af-53b7-419c-b83e-d70d002ea321@acm.org>
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

On Thu, 22 Oct 2026 08:56:12 -0700, Bart Van Assche wrote:
> The idiomatic way in the kernel for subtracting pointers is to convert
> these to uintptr_t instead of u8 * before subtracting.

v4 is posted. desc_off is a uintptr_t subtraction now, and the room
division is replaced by a direct span comparison, which also removes the
truncation Sashiko flagged in 1/2.

https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
