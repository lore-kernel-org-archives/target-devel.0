Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792860496;
	b=4dUTyICBZIdWrk++HwP+sfl3C2LNXAn2NTp9QX336FI2kiVwOMQjmXreiSvDOQe+aRum
	 jvt6KCw/in4HiFOxWUGMjExqI1ddEsIfsv0o0A/cCibFzliplcqZXyZtrkmrngioCZnxa
	 SQDcH1kWY7/J+DFCN6ArtSdT9JYbLlyzGU6YLEFlSqKqtHYdbohEVuGT9C0Vw8WD50EYW
	 DqIpfQN6l1ueoVzDkwXnDJDq4+TnV/ZTWqGTs2UIxi/mv0cohgkoYPK/teChrErJxgTjs
	 Y2eR/QTSQOb7fajTxaFAGul0zSOgWm2OZTSUHYBpMjF1jwVodIwoZIiZ6GB7CHeZbgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792860496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
	b=Y8x11dKW84hsZHp6Wn5/V+cUAVDfMqlqDWBAc+YPClsPFgnQ6FhdJJzPkf0ySWwpIl09
	 9rTwSSddP6N1Twr+j2f4A+FqR0b2i3PnmXWIvvacuWY33zC9oS1LiA56gfc49CqS6aDfm
	 XvUrTpqWkZaviwRipMSUcVfFTNNWEngzbr2A6EfTn/9pnsghZMVbwFg8Me2d+dNUnLAx9
	 xe4kXEH2JWoGkSi69DlXFv1j67AP2IwV0Eqq6F7uR45/O5uhAYpt8O+2Z3HT++LQ+u35k
	 nEnm1PauC8Ljmq6JCgdvr9VwJZTK/ixlYFx+2cTUKjrFkXLm0RgknAwbHEmWVyBcVCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=uGZeaz9N;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9BC606A31B
	for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 16:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A9BC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=uGZeaz9N
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc758830601so1140284a12.2
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792860496; x=1793465296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
        b=uGZeaz9NSx8x8gU+5cVfYPY+kB08j9XyRrFWMUzY05K9ULUlFZQLvOrYR7d5zfdDSY
         OENhR8C/AekQGYvo/bT99vvkW0/rKfFydRbWCkudpEC0XmNB+0ARnxjo9WXk3bFqQ8VS
         uI3IPA3/93wuN88jA+BPyVvpnS5zfJERS+7UwiKD2f+0zromq4oVSdAN7HZ5eXwBaNwF
         fd3QeQSFGRU2sZjJwNMwF748LcB9ExXzJ4z0p/tlV8UV8KhSJ48HIq3QlNFDfquR+HKs
         Z34YDIG1yDQCcyA5B3ljIYIlxKnCq7RPrMq+WCK41KYLmQHDI5agHHnYfDXYhWpx/4ZP
         2XyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792860496; x=1793465296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=isFDLv8vN/snFPyaQLe+9KSLlWtekB0w1jnYJnzpvG4=;
        b=1NRaedKYBaxnyzEKaoskiVEvECd0qZPq92T3DtbMy12iSpk3kz4lbNWSVbIikDLHU6
         qy4axYcjCAiNBneBODH1WlCoSNiXVUp35tESZQ1egEhmXcOcsngtvPDn2uZ3GWdlO+uQ
         gsPhmtydYQYhQXtLgGF4XnWZwRJAouyb9GofaMweM2cumMvUusuglbKPIYJoqBAWpdcw
         cr0NzdLLnYOEMnf/tYdCzxd3Ok9GAWqy1r7gj9n1EU5UWhSaSBW+Zq1h/ijG8wjK9K2W
         9NdUpxBPwWJnfQYMhAHM3k22ZMWA2YXBG4WCcfCxgqlpaKWBKEoQgFHtlQ248VDXHz0J
         92mQ==
X-Forwarded-Encrypted: i=1; AKwUvByFj1GmEK9sMW214szjUWprCx/ZGh6t1RFUu+Dvzhj5+MkXIBNppXaWMCQmzug+ZTU09Regxyqy0ri7yHM=@vger.kernel.org
X-Gm-Message-State: AFq9FYJOu9CIiGLSscemkrupLZdvtynJoCHm8Bucx1vVRyfuaSvjGitB
	iGXtG+mE7uF1xeqkV/i9AXqBQ4uAVzX7SK3TBnSw/6DYfFn58aOmPc6o5zfYROSu4NI=
X-Gm-Gg: AYBFou3QmQm+JIaPeAfQiyaQzy0N1L3ygLelGSYvUXwiM1Rm4cAbSGCSLFtxFi9mrVB
	94eDSbOuiEmLklcZuZYSOlGrF6nTAvHeyky0b5KdiC5KIqELh1bXvFEKZ3gMo9s/bylJBXTYJMJ
	gi/TQu/wLXn456Z+QSWxos33TrGWcYwLx7pb4uiJVQlXTO9iky8DB0q4NseM3a5t4IWfZhAm49C
	g/4W1rIZH7z/CuX9vvS0lLVNS9u9gZbpxO+PemqiZ4bRR/5xWh6/pig+bHHKKX6xKEzRsNqFtIZ
	GLPpTMhO+Rn4+nyu9o2E/dsrE1mqMF1WyuCoruH0FDXObmKgSR6O+12F/ejjFfN6k3eM1jKmrSA
	iHj9W9+Fki9eukJLiBmFYOnaCDw657jnqlNzj6oMmJSqADs9nt/gVES3I7+hpPMGZXOLozioBnT
	Hp8NPgp7hWI8R1vlNrf4DJPWO8QbEIOvbTsKteR2SKwTYdRxEtL1pmEXajWsNNR/5f5zBtdVkvr
	cuMwVjqNeWlLXqcT7UAFtd9f5K1eTHAOECgB6R08N8KPPDM6v9wwYaXH1aDVlWEMDrj35XR4kE9
	eqzAwZF9eqg6Su83J5/y87EdDHwogeq4SbDCOgnLRF9v73bPj1Ce9sYKoXh7HHaC
X-Received: by 2002:a17:90b:582d:b0:3ac:c024:b275 with SMTP id 98e67ed59e1d1-3ade9b2ef33mr2135648a91.9.1792860495722;
        Sat, 24 Oct 2026 09:48:15 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba31797sm2193053a91.1.2026.10.24.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:48:15 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 01:48:05 +0900
Message-ID: <20261024164805.3531156-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <65d23010-ca3e-402f-8384-732678b6ffb3@acm.org>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr> <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr> <65d23010-ca3e-402f-8384-732678b6ffb3@acm.org>
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

On Thu, 22 Oct 2026 08:57:04 -0700, Bart Van Assche wrote:
> Why int, which is signed, instead of an unsigned type?

v4 is posted and 2/2 is unchanged, still int. The cover letter keeps the
offer to make both unsigned int and turn the WARN_ON in
srpt_rdma_read_done() into == 0 if you prefer that.

https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
