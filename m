Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711063;
	b=mWyvA95Gdsh/9K1XxiTBieZyzCzs/1WGSPco04QbD3NLHOWEIZkkjU4SEK+kMkxsV9ey
	 9efxYM9tK2t345+biTiNQVoDHu0R+gGFJKS7HIKAtYW7PNGBlSq/3g+B0jLcedZXL/3Yl
	 XMyMsv0DziNuqY7dR0wN2KdYdgJ3jQGx5f3rceQu/WMjMTes83RsNjLX/Y+LB9kCR2boZ
	 Lv0df4qmik9vSafwtGMsKrgPd1DpqSJCpXfo236eJSwL0zG5FwRyNUAzmrykbgWq4cnPK
	 BKrVYYnzlOF287VFY2+DD+F3KTnrGlL6DirkfLsbGznHbOP8yLeWMVQ+BYD6ttTkMTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711063;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
	b=xUiwHqFm2ud56vxWGHgswZ4ChhRAxWCu0Zi73owcgFFwxRUBJtP0jT7kUm5i4sixKA9N
	 V9zbU357aV0xISKvZtxwm/4WrQFjgm+5/JJ9TkA7n1F7NqyuI9bUcB9B22slyQiqszHLw
	 cSNlbvEXQG7HhIWmOlHpiY2IpsxRy9uU6Y9sE2BarXxGwj1ro1iohEty/q6lbETNsrLry
	 EOJj+mgueP5eI54JdP8zFBTpFCxRPysubUpYMpgckHFHPKI3f2/eGpnP+Kao4O1013+rU
	 SNJsCbxXY5noMLXlG4FJXqhxK9gnjkzr7otsq/yLj/ev2CYojs/C17aZ809oUJteeAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jfTU9IJ5;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD514606A328
	for <target-devel@vger.kernel.org>; Tue,  3 Nov 2026 13:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD514606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jfTU9IJ5
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso1503222a12.3
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 05:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793711062; x=1794315862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
        b=jfTU9IJ535MeUG8o1iDTqc4DK8Z+RI6JLIR91BZ6dNkfDjOEsh7Yn2H5gw2hAtNGnO
         LjYDgB4JN9AKz1vM/Djlmqjj1aCSXQ9p5+1nTv5AHMlcEiOVkAkj2WrOdztnCeJv5jL4
         psh0Jq2Y3d6WFJWMqYsfYBxWC6RLVxLjAje4n8Z9FurJ79WxOyAaqUpLJeey0OcNK536
         OMvOmOBKpjrz3QrWzEokuX0VzYZiAUoPa997R1esVqRRdGxFmhp/cK2QVkHWd98Ke6jZ
         1ElEeY4tYKq47GH7Zl6+DJ4Ogs9YpiS4Y1ARqR2Kb81fhNPY2nRczTVkwO1el8E3CkMD
         Fg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793711062; x=1794315862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
        b=yFk8KBO3nBYh4u6X7OyId4demEOPdfGiWdHxGm1x9dRQHQQFM5x/Tjv1/YeulU6FKC
         XTGHlO3WD/RrDhy0mHVRc/YymAlT53vcMaVgZsziAKbvb9bZTrN/mZ6TSwUkSQLFyghI
         6E6PEMMEAEJsKaaCw+QxNVyH8Pk7abzgBNRwucMTDpvjVfXaTdQnLY+ZGhPlzABKo79f
         cElDSHXiRlFxorJS11OChAhlP0BjuI8x7N20riZouOTRJfhcjFr+no5C1qYSedQvMnll
         T3ojFcMyjZAaXQohqOy3WgQjLZvHMwLIznjQMY1v/i1IJjOC7ZuNrs7QYF8KYSDG7Dlm
         7aew==
X-Forwarded-Encrypted: i=1; AKwUvBzYELXfmwKW3ZkNRv9MIw7nwo7Ke+3ulzOJdPw4K0ONGWXW8DAqjjjRcf6+JEw0ImALMMAFDGFpPUdi8rQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/pohdL1UCh1CNM3ArbKtdySAqJhFAuE2c6ko0QryIPdLvA98Hf
	jOWVxEIsWE4R1GfPlFp0GVFjbiQiFDrh+/uU1zEUlebJ2BIWAxvdKeXEJx74kBxanfc=
X-Gm-Gg: AYBFou2Pf84yIPebJGXsnIoplNvxnhBlDwIPeUquSSiWjgnfsGQN9PfeRFgMbb2KUiA
	rYktsQ/df0tURX79K/R0fPQZTpeJiqGVQTcTEBQ7sXxFKBmoa0PsgWBVTKRExR12eQUdmNotuSh
	uZ5Fq4qiaOltIn/smINcUhuNPkOmSC3Q1jO2Mw2Ssw9w81ov2KUhBylaAjlTJTib1+uI/sOtE/E
	wagJy5n5A2f4Kyr8Q5Z5rCSC96QLKEF/rWQLgDRI3ta3az0y8NRt67uq1ycSDbcwBctd698PGHq
	MA/irZN4hm09VOZ9xreQPtWQvTbczQt1mKW3O7te1CbOzsmfjp1IT8f+aSEUxIDhdyXoVyXNF8W
	pU4cumYyYWVpCw3rEm1IzCrjj8I/rKVhwHRgeXPx03W4GccBn08/soe82X1cfgFV6bYI1OWVrlD
	EVoEpVoGN8eVeVF6QJRiCapLIwXBOOgLwmjqeDlpkeykBIwphmQ8oCvE8qccuzreXmhK0icV17J
	R4plJYL+KVNCIcqmCMPJmaxtJKIZkLS1/XXwvdvAqODnRUo+D/hlG3oGcaEazPJLcpSEtBWMl9r
	ZEAAvhJMRhftw6xCyu9I4YyP2wq3Kfi/oRCnXzv/nbSNEO4oNgJ3PCaPIZOu5U2Ip/FAQ3cYNlw
	fnlwwXcy8ymWn3XCRAqc+/rMrd1nmHw747Eo7oA==
X-Received: by 2002:a17:90b:3d8a:b0:3ab:9f89:e1b3 with SMTP id 98e67ed59e1d1-3ae89764eb6mr10599503a91.40.1793711062055;
        Tue, 03 Nov 2026 05:04:22 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b08759344dsm2265061a91.13.2026.11.03.05.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:04:21 -0800 (PST)
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
Subject: Re: [PATCH v4 0/3] IB/isert: fix the device removal use-after-free
Date: Tue,  3 Nov 2026 22:04:12 +0900
Message-ID: <20261103130412.1530793-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v5:

  https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr
