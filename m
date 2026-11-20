Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174464;
	b=MTKBRgbADzSrVYTC0a44szuADAaOyOVH4bDS3jWv0b23TU0282+k+Bp/HU79ZJ9cUDVd
	 HaljTf5D5gNvPxAI6EcvUwIDlfJFqs0V3rH39OGxcF1PfgzfwPvECFFG4ysRI7YVbEGQM
	 2q8KL7+eXSIJ+BHTGxdB84+VnzdvXrZAuPb6SelNkekGSNTM4z1pFHY3jyOcg+WEy9JbE
	 CT5BoW5q9/PTFje7666JGCnT3ZZaJAPXqQID6zC7kgyw4DgNHiYKSJjBOCufHuNG6JHkG
	 Jm+4gdzK2kIx9wd9KAh19DMVpubDTKInpqnSK4zcnpseU4jaZU64As20HrzqIskQ3VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174464;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
	b=hyTNLuiiZI1chWJAR1HYZml0EV960Et4dRqbvvIQBkfo+eMXz3pTLlrfuNspN8xGYS1C
	 CLo/DFJKJV064sq+Y6ZKG9cQCIvkujHgLUgkd1R0JnKAJ9K90smXBQ9w0OWHi1JoBI27d
	 mS2+dt5km/Kqt7MetRrJR4pKN25NUgHCLMKS513LfMbyew6c5BSKYtOgCSKI3nUEMNgQN
	 3KuKKd6d3r3LdeFwfWgPaCBdJ0InbprT7Y1k0WC5JDNLhadkqamptWw7mWbOL6GT3vxWH
	 k9MVr7W8k/UsIw+J6uIp41ID6FeeyAuFLNaB15W6O3ANseMy6sKjeXFtB3VMtse2pcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ib0TCad1;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39CA606A336
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B39CA606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ib0TCad1
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cde1479f76fso532592a12.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174463; x=1795779263; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=Ib0TCad1F95Ie+xma1sMys7I7UCPQQc4SOoNtHTOow9PYPTRSZfxhOEqcMd4S3UPpB
         xOIhzinkpw2Uq9t7KO1a7+CaKP42943VIelv2oiikPJnJ3n/Z85DYMgS0T79LBkB/QjX
         ZRYReuSsBgxh7i3dWCat3I9kVDijlloz+UfTOwKz1wNsh9Bq6U3vw0pppR0RuH+y82hc
         qrG0JnrTDkjodnqFTcSv3H52DCKO8NwdJOkfx5xNQwfrG1w8k6AG4Pxxjxe2bjVcXfpr
         MyDBylv/ON/eHQlmZuDyBrVbBmCLVzvCTJ5SIs+ZpUpEanFlyi+od+4/CcKARe2mtAVC
         sFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174463; x=1795779263;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=AqzN26SWxYE16Mhn7EYXgKwiyJUeRKGfj9lhFom+wQwKThBAhizIezhRGrAdrhm1Ro
         GuMaxuAx7Jo8AFo4Ondpy6S8M+8uTSCuWFVEihPjBNrBp2l1x2iljwZmRUwsNcYTP2Cy
         SSJQGA6DDA+dc4JiPNhp+8QL0ANnrbNoxDvLBc4lZSlyIbae0EU1COTN7g/u5fKO93RI
         1aWU3NFBs+byN4tC+YHI5AzESLAtC5GbdsnCbWsZu4xDdpG+G7H3CAcpnDIi/H7CgdqX
         /mQymhzQuL1Op4zT5thZqJ2//LniOYqEiguAp0b2K0wQlQ+BFP9eN1EREXRiGtk8uQ3F
         EnRw==
X-Forwarded-Encrypted: i=1; AL+hErGzm2CdeYLH4d6rMnqJ7csSN6dGHAwSd2ZxKhrEvc8Ikbok+/mcsUFlLZRlWMNb5Me/PyLF/fAgfo80Rvs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9kVPE0BP8PliqfssUluFjsKPmIy/5LR6BsUwuRRRFsqgcUU9en
	fSbzWUX97MMEp5B1tcHIZJf7ZZaIQmC8+6LCTFKVFBo6nsGch7dbtKe8f4ylEasj7Kk=
X-Gm-Gg: AZFdTZfPyHWy33s9Jg0U+OrU8YP6BXCHNH9vOB7yEvhsr4ysWLTSBJGp87avsLxtxlf
	A+p7Zha4NIGay7hGam0p3X5y7VrC0gNulmDus7Dc1IGCm+dTk3xCx8JiM13ciqehlNTTKMfKZnT
	iWUS2RKE1yh2AgDsm9Lzxc8F7F0dKh2g/Jq55CQQBU2E+Mfxk3Sdb1dAPc3bw6CRZhzo/yn8KuV
	b+jwL7vILcKBfHZQzlzMIGkyhTwsLfXpriIeOdEZJJfzJg+TZam6aR9LFSSyW4dLRBEJBBOW+Ph
	i1SNmk+nE0UvCC1Ha4OU9URLibrePvVxXD7+kr2Dnck95PPDA4EdaTgKYFzPpighQCmMSxgPp1N
	bh4Js5ywO+ElKXuOMZM7dM3LqfYIegMoBwNNcI0sovOaM/YEdRKTUfpg40NA2WJQRWP38WwZOrT
	kaiHSlYhd4+xoiUzAM9Zp3RO89YJncYTWL+8+AL68Xs53Kxm6FSOqdfF0CA//RvV2feF641Rbmb
	gC6qwP1mKg9vo7EgZTmWYvjQ1fC5kzqMydoAcBJe4YolqhcSSyMYwJKLxfayfdkhOaRP3kTEWJW
	wcu+JX9BD2bmzZ0uENXEm0bagIH4ymAXFZmm90p1dmpAYMPAiu7e94Xvb9thWL1m5zE5DvVwgvt
	xMhrvC6mHL3yNfXkoso+ENfA+EWF+ea1hmY5l
X-Received: by 2002:a17:90b:17cd:b0:3ab:884b:65a8 with SMTP id 98e67ed59e1d1-3b41c9032bfmr2325880a91.26.1795174463114;
        Fri, 20 Nov 2026 03:34:23 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad47091sm4117971a91.10.2026.11.20.03.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:34:22 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Fri, 20 Nov 2026 20:34:17 +0900
Message-ID: <20261120113417.3069190-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
References: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
