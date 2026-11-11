Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794378586;
	b=TxzuNTnwyidLjoMx97FyZQXdkHbAY+N29YzmLB5UmFxFeZniignsRjn6yl3lCqY7lBa7
	 a8mEa1mAfBjwt+mZcVqG9Iwu6bYXy5pRPY799kzrdnBiwJW2ow746WpkFiG4yyZ5NE6Al
	 t5lBNKy1WcA1S259QG+ncy20CRYaT7q/qySHTsgfNeoSZ0eX+6ccEKnvcSS9RuTDTNWgV
	 +pcZ0YCQ5QW4Q9ePWHim9nvbwypkIpD19mln6MKmdlovwwHH4jBVpOQz1c2GjvGKXgLVM
	 4hQxey71ryVDjxRxczVVbFlt/u3cP8NPNaAMlNze3Sstpe4i9AXYgoli7WTzdbRIg0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794378586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
	b=lCIoBg1CKtmv/LZIRzJSlrlL2MsNnxUxjGQu4krSo2VnGXglYT1rBzwg2IrrAAYx9SjC
	 kFAfOFkQ3wpDynUvtjjy0jNhQJ53BAhP4wLVaQpPrqK0ZIf/UfiFZQvtVAFakBBBax1jO
	 QBQJBcG3l0IiYSsJlmDa2Hi/lzFVUKqSsqa96E4eMZzJgQiS0qJWFmdog+BKBnMbCWhOv
	 brbIUlE4D+/6QDiUoZZAn4u61N1gHgvqXcHD/GbU4x8CHliA84VO2cGAxddL6NF8C1e5k
	 GVmDEfMRReU6xyKQSLLcuqgybEh6rpZ2yxvYxSJ4Nl/Bhl4irnrLPannXEtS7+Hj16w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcGrU7AJ;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83BE606A321
	for <target-devel@vger.kernel.org>; Wed, 11 Nov 2026 06:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A83BE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcGrU7AJ
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so1673510b3a.2
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794378585; x=1794983385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
        b=rcGrU7AJZ3TRwLxUVeh9SZu6G7z3Wc5rpfM3PG1/5MlZKLWZKgUvDi5n/3XZ286nHt
         QXztxMQgJG6fjXgy23xxlv7srj+3uMgioYvgKHhFj4vBlMwfGh0aCS/qinuKzS2Sip4i
         vNMFBtM0c/iaERTORa7SiSECAI+Do/24rzSbAQ9zg0mKPU/WpOXjbrcHFvHX79j8ERVc
         gT66+DBO48fwF40KLU1poVQOsTfHuTEPKmIWohfbMcXNOmGQ79IPgWQpROsMDsEd+ztX
         PrhlumJwpM3pQt3PSOLMQeQ6yimeXzFfJngh8XwVjtn+kyFI/Gfr42g3+T5V/pTdzoBu
         U2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794378585; x=1794983385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
        b=0Z2YqvTHP7enmfGyIOhDaDc2vSDSINhILms7gZwzrthzlRmg+tAWdGrVxaAJuLKJyi
         0E2StQ6iCk8/PnhNYlKxcOVuRzKSjlb8m928gNifAjvVhcrb63R3Xq8XYJllTN96MXN1
         th8by24euh/gahJ7x+tFKPiubYsxk8SYTH7xRK99zcZHeJfiLgjIeOqaWY1XrxZiRcPQ
         LsAwSEpiqwodQEWuLHhVPUfMd9VmB27JfhYFjk9NAII6s+IWTbR5a23wSBIKDoDQJj59
         KjcYfsWbwzZ+0z7YTxga0qV8be2K18hVlR7SPjft9XiUHNudzSRtrIC7o9yimAkWSGVh
         smhw==
X-Forwarded-Encrypted: i=1; AL+hErGjl+k8R4yAKBBO/6QPfiXqAUhpzBNZ0YM6yOtHm55CgILNVWiFTg18/DXJ0uhIFyumMdriYGPBQQ7fOuI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6ID/MFurRgT1yqlCB1tUjeppKfg+omeG4QtdPzTt+5ZYV8Q9s
	D8VxGZ62zDrvSc070iHF1UN4D5m/jMwaFm05/rlME7ojOoVzDz+F/zbP
X-Gm-Gg: AYBFou0u6EZvJrbKa5ZIDPYlOTRp9nU6cJdvY3oJyw6dxomyjdLubp6amYGRehFnRVe
	OHoUKEBNDkZr/cIxYyMvsKkM2ayz8glRkyrJwqqNKarNK9G4QA0MxJKtSOEaMqIhrWk97Du/iwQ
	kyXU0g0kG/SAKUTF0uD5+0XWBBJaKXD6aKNEmN/6dO86N89chYerFQgjvM+ZgG7uIUHXHbZPj2V
	2k1o8oGXkwOjcu1kM0VrrXZSlDBB4dUC+M3aEXQSd+0wZhQoiNQgQsZdTlesXDbXnzgwgrKeugo
	WuAnMraWoCCsNMxk4FldzXoLr4lh8l+NS/LagMgzjqNHtApl6hM/ha0cExKdW6MAn26L3m0KIKS
	tmytfIAgzjOW117uHK7S07y3s41bmpkgVOp0mV7wsvpbmBuTA/cHygttiDV+2fHwBTeO4EF/WJm
	i1M6Xmqpu/D8TuIp+eNnid/A/ej2ifnGHziJ5v3oBryZbISf5AErGAnikNl2UZFcwN7y11BEVYE
	6VqzyFUAjxgYlBl5koRCMYTex+NQwsAlBbDnir0MkRNdloM4xlTe5sflBlULR7kDOtg9ooUkX28
	hoHRctxZfSYqLwbzsErU8lca751L2xtItfKkHA5EuA==
X-Received: by 2002:a05:6a00:2343:b0:8a0:3336:4b45 with SMTP id d2e1a72fcca58-8bc1c594810mr1681640b3a.12.1794378584851;
        Tue, 10 Nov 2026 22:29:44 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e25esm1768266b3a.37.2026.11.10.22.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:29:44 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: Re: [PATCH v2] RDMA/srpt: Limit read data transfers to the command length
Date: Wed, 11 Nov 2026 14:28:50 +0800
Message-ID: <20261111062852.1279950-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2e748067-f733-4edc-b71b-540de4bc3d26@acm.org>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <2e748067-f733-4edc-b71b-540de4bc3d26@acm.org>
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

Hi Bart,

> For the second case,
> srpt_get_desc_tbl() should reject SRP_CMD requests for which the sum
> of the direct descriptor lengths does not match the total length in
> the indirect buffer descriptor instead of building RDMA contexts for
> an inconsistent descriptor table.

Agreed. In v3, srpt_get_desc_tbl() sums the direct descriptor lengths in
u64 and rejects a total that differs from idb->len before allocating
RDMA contexts. The existing descriptor-count check is preserved.
I also initialize the command before returning BUSY for a parsing error,
so the response and completion paths have a valid command reference.

> - In srpt_queue_response(), zero the part of the data buffer beyond
>   cmd->data_length, e.g. with sg_zero_buffer(), if the data buffer is
>   larger than cmd->data_length.

I have replaced the WR/SGE modification loop with tail zeroing using
sg_zero_buffer(). v3 saves the original buffer length and clears the
unused tail before posting the existing RDMA transfers. Each separately
mapped SG list is synchronized for device access after zeroing. The work
requests and SGEs returned by the RDMA R/W API are left unchanged.

Thanks for the review and suggestions.

Regards,
liuyong
360 Vulnerability Research Institute
