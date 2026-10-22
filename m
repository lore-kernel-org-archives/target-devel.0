Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692959;
	b=EXAfS9Yc16eoazx804/N2qBpgQK/hq2u8E0gSongAiRF7xWdWweP3oqGNwr1jVbU/ZHR
	 gKDVedyKAxKODj/WirvnY8mBSF7F4wPKOKvSZx1XD1gwemepKJLEKtvkY/dafQK3MU7qZ
	 jWczLVgRB9FwOHDvtsX/QUqLQceq8uXNE5CBIJ7r0+t/oETE/N90oyGrjRuYp1gA1BJ+E
	 6zYGbpPPX8JcDkCvpRSoc6lquQQXfoaYEn0tqCwBWQt+uKDHo/tGPQ41hgAh2tzPdNwaK
	 43g5ZEihAwyIDUv55N96wYQki0yTv3GV9ZXQWpiBGBA7KB1vCXiR5NcJzQYiVMPLJNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
	b=QbU4Ls3P8NnqFp5bVTbqhEspXCgA6TYYPkyP4yjEcZ/nO56xolfgP7N8W71ClERt1lyP
	 Wpxe7GS1l8GMwc/ldshY0yhIfcgNYE0eqt2JW8GE4D6V3zW71Q2h3fJgyJ2NMtttm2COG
	 MEDwXcBQCjy9Qsa+7UIDOvlawyMNJyvHK8oZ9m4NQalIFu97aAegVI3qDADCwoMTAxnz2
	 Tt4NP1zSUro83k9SxaMXpFVcxpmlDyLjpbI3RE/bdupPyInwNG6f657gNlblYLHLnY+/I
	 s682ZkiFMxwiuXRZXvHZJbY9I/l3DNLFRC1UwWzrgefI6ZyAHnSwxw3DUAyaUeEIWbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HUdkciLA;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D8E606A31A
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 18:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D8E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HUdkciLA
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so14392a12.1
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792692952; x=1793297752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
        b=HUdkciLAp5pcrgIMeGlsE49QqY4c/gj8GGPVNzXjaemqOnDMlsMfhrFlrzH0TK9E1j
         M/NMp2TN5BE5twQ4b6AQzmZ7l+6ZJZgEtiWVLZknISktkyKaWT7sTcYlVlV25yu+2lRl
         nFDgf1FQ697hKc3Gs96cp0ZT66kdn7EQ/dURcm4cV24EASFIOs0hdzq8tNHG1CevRc0l
         hGVt2EW9JdQd10jMH8Q1YGCVlbe1mFIRYICPJ2D2EIVNSULGH6qnSa6ubh+SgDkBur6v
         cLJlxp/p7/9O6Vg7ndjQvBalbX8MvaL/AzPh2gVkMOYnmKdV5Ey0LVL3LB3xf/4Ejopw
         nINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792692952; x=1793297752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PaN8bw/YeTmYvJNsbSyjovsCwKlcPndZnsf1s/btpFU=;
        b=bOv9+Hk6rN0Tb2XwX3oerE2ibHuiY8sMg8qWIFdShUG1TV6puLBz1tcRCR+iws8E9D
         ZJujUK0t+jbM21euJ7azpMJeD1Vyj9UE74zMM0SgMyi4ln40Tn+t6z0qpkmN+0hj67vF
         nvDJn7l4UT04C1oG5YzbxJlnh6mGbwzcUL9jwemYqGHU0YyFddNCzpG8MrC8HDKSF0ij
         uS6HOwfQJ8gTlbmZYT2jaPEW8tKV2/LTXV+bVXw91Nxyc4dmI7knLwuD03RDrcazRnLd
         XLzYXop0sADhVqdbPvqKRQqAAjFG4YotMXo+VZXggxkv0CPOktE38EFWPNUwYA2XeCdr
         Hsnw==
X-Forwarded-Encrypted: i=1; AKwUvBwbs8xJjuCv/K3sgPakTJIk/oNi5pDJbVvhS+uY32XMHTzucagpcAD3myb79AlGEG9SJCuXGlilvkL/rmQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKrFcAdKBg+FODMp2bw3vY6yYWJPvsI97vb97hHJ+hOwobFLed1
	5/r6uBIrXglOH+PhX67Z9MYddTJkWX06CdaDy0Tapt3+V5JxM+XyPklC2cgFT2qMrTE=
X-Gm-Gg: AYBFou0E6is4TVidu50fZb4mOOcV0RCItywbFPhUzctK8dkpP7r3TfHc0f2agdndd5w
	7/LRuCcP0zNUaSJJEvVTnDWZenqF1lDEnQ6hVbCD4fk+5u/izJ7uxBJyjWyKPL2qo1x0lDygaFz
	CDuX5RWozMA7CQU8HtM05Jt6DyFEzjeE+v6Y7Ry8TpyKGLGgZJ9rpIwcUaeBHWl5N5dkk5CYT9c
	b6aB5Movb0KHJmANmDsokU+bE3zuMta15nvHbul561rvsGu8/O0U9J9K9LGmBzbMCmXmrYHN9V8
	L9S4uKqsTBV/PZrSGGOeN8j2ljspQAv1TS4ef4irLwcQOgaoRrRW6LazXDOyuksPXdUqm8grEW9
	13H90ovKpS07oJD+PojSIvROuojLeCw70+3X3hF9ju1Z/lfpc48/M/mNEcp8t7jqTuBVxzM3+pb
	tH5rJRcc5KS08BW4S4S9nn+qpulvcRGr9634i/PjRRvvwGjqIJVNmKhVHVRRhMVglYcolQk+BMT
	XZf1+1PrcVq16pWvbit3Ky1BhaM+maf5sFhOflFfReDJCKFmZ9aH4h/e2Q51GXpdIGDoLmSzA==
X-Received: by 2002:a17:90b:5403:b0:3a7:a3c8:8f4a with SMTP id 98e67ed59e1d1-3ada6c7e603mr1884805a91.18.1792692951864;
        Thu, 22 Oct 2026 11:15:51 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([115.138.38.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adc8ed1b23sm176638a91.2.2026.10.22.11.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:15:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Fri, 23 Oct 2026 03:15:37 +0900
Message-ID: <20261022181537.3002021-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
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

Thanks, I will switch desc_off to a uintptr_t subtraction.

The room check is also wrong for a short IU, as Sashiko noted and as the
commit message wrongly denies. The division truncates toward zero, so a
byte_len one to fifteen bytes short of the header gives room zero rather
than negative, and a table_desc.len below one descriptor gives nbufs
zero, so nbufs > room is false and the truncated request is not refused.

v4 drops the division and compares the span the table needs,
desc_off + sizeof(*idb) + nbufs * sizeof(struct srp_direct_buf), against
recv_ioctx->byte_len, which refuses a short IU with no reliance on sign
or truncation.
