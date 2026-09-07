Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E2A48424F
	for <target-devel@vger.kernel.org>; Mon,  7 Sep 2026 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781682; cv=none; b=lOOb5MoYm9LaOtei84Jc7Y4/z4hW7lFde+HdUGHEpWnPIOjpAZE5KHlDLlt2U7BfSCgyp5W8xRMy7okhaXIJTD45duf1JurKj08s/oQoQZWEeAzj7dgNqs7n+lkk3TAJHaz1tFoJPBvlK6rBVXwXp8hMCoFwEsNHCJEFb+A1FUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781682; c=relaxed/simple;
	bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTCMpftDMK4+D+5sgd4LNV2BImPFpRy36XKNyDjlqsQKrIJORFttyWPyQ/ED9wbuAzR7pakMZb6fEvEjnZE2egCadPBRhF8A1PPMzEsXScvoSmmsk/aRHQu1OJ5QRdC6EtQvCO+SwE0xyP7L4tLU6RZHEt4fSK/OLbpbMXyjt9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PzFMbc+H; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PzFMbc+H"
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-48437576531so1519031f8f.1
        for <target-devel@vger.kernel.org>; Mon, 07 Sep 2026 04:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788781678; x=1789386478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
        b=PzFMbc+HE71k5MHz+pMC4F2BIVMETuZRIYspiXiS/GSAaiGUNGZItVCmI23siOCgxA
         WxJyZzagmKeANJoihEvf7l1YNuO3WAX7Hhca/d0xuvj8jj56uGRoiyINDGDQC1TuqjwR
         LNsvnR/bgeaEevdjwC58Rm7QCbehCkQEgEHg/m3z3Eq+1HzYbjWEWRzHmUWgdkqVkGPv
         kHGMUKSTiyL+TuJrVDdXO22KekmWm+JZpLSYnrQhXxz7OOVffY6EQib0rpq7y/9xx49P
         Dbsu6zZIqa1JwE9x4wgf2IPAiVfaBHJg11GGFbu3zvQsfRz7J7zchnSaSgZcf48nFZCb
         jUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788781678; x=1789386478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zisK6DSZbOvLPwi/dAk2097X/6CPmHmVmuul8j51ByU=;
        b=s18pj9YXSmsvoQ/SIlAUpAg40JgDJI4aPeDd9HNZq447AgqX189tGOpEx0xsbWoYAd
         Fk9Jm8khXGhlWmmOwIRA1n/iX0PPEJlOJzKwdkYnlujnNxMz2kNAXZwgHptaoBuFF+Bo
         NQXGHRReXFWR2uyxVdp0cuGeC+v1e01Gxx1zQGYPAJ3mCAGrU+45H+UhEr0RcKlOsUs0
         vmSOWj0E9To4UQvSBJN4dPFlBN4EJf/F+cezKZtlgqobVlWk0uno8M0kU6HOycBqtU6D
         bl55yP0NNKe8HvCku/iq6VYzCPb9990oyCAXYVoA5XohxHH2KAbKfNVYZG0aG/FiBvgs
         cRhA==
X-Forwarded-Encrypted: i=1; AKwUvByjBBxP7MoyGcclOV412fk+YqJf5xLNJODnDxSf+dYfnuKBAO8WZUkXjT5y0+xdIt6fA8y/tTpWBC9fP3k=@vger.kernel.org
X-Gm-Message-State: AFuF++kxvIIobHGaTCwLOA8KRYlSlv0bNqcDWxg3Hzgt08X6Nm+dp80T
	2sJRtGmP+gWL5oUZJn9+147jaKejjLQgFqGmvwZdkRuZR1qsJ3dEbfe3
X-Gm-Gg: AYBFou0TfKs06+F5m6vUtq2hlUAf6p9WOwUJwhlkGjV3vCp+SPJXAQ0AeEB3fJuvLwe
	3C5LQCZuFfc1AMLLwYRtbknAWRwkhVQzGciwPh5zN9jY252wsZM3VvB0/e5P8mnyRrOzzb5+knM
	C0IWBGTHkaMBGDN7UhxJbQ89M3J2dBKIdowuENik8hebFXc0sBNJTvxFw+CK510mgwCInzcBjs2
	WeqjN76UGhgwzPlD/nsPIFTxgXI67XL5jatbtRMsYBkPnKUwnTVaRrkn5G23t5RDsSzYflAuFGJ
	MEDsdtGN8TZcTMIJXW5uLDys9kPhZXtbn961sL2tuF7f7KrcY8HSOCaLqN5lw8umzDu+tMPolwp
	hTLfoMWpYF+VJaHpl1jIpXU2kfvhuueD01WmEmCkGBO73Mn5cT3ATtPd3yEAUBEMqy2ls3rHVAG
	JebB5Hs2bD9bdoXh8QAccHRAZ0WWYbstiL7TApJzJrMZqASXIcRc/CiCgz2+Qgu+C5Jrh4xmGqb
	Mau4zjEYHzw4Ho=
X-Received: by 2002:a05:600c:154f:b0:49c:fc6e:8cb5 with SMTP id 5b1f17b1804b1-49cfc6e8ee3mr219765505e9.25.1788781677871;
        Mon, 07 Sep 2026 04:47:57 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee80eda4sm383491635e9.15.2026.09.07.04.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 04:47:56 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: leon@kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	sagi@grimberg.me,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: Re: [PATCH v3] RDMA/srpt: Clamp the CQ size request to max_cqe
Date: Mon,  7 Sep 2026 14:47:25 +0300
Message-ID: <20260907114725.28908-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907063251.GE13683@unreal>
References: <20260907063251.GE13683@unreal>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Sep 07, 2026 at 09:32:51AM +0300, Leon Romanovsky wrote:
> All these Sashiko reports suggest that sq_size is being changed in the wrong
> place. Can you check for the correct value in srpt_tpg_attrib_srp_sq_size_store()?

I think sashiko could be triggered again here due to theoretical max < sq+rq
probability because in the default (4096) state of sq, store() is not called.
max_cqe <= 127 and max_cqe < 4224 points to the same issue and it is not
resolved at this layer either.
