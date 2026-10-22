Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692962;
	b=NjPBNbUl5qaIGrwCNAtvRNPZKLgvo3iZB0Fmij72AwvEffVJ9rgH3SysQ2dWqecJBLTT
	 aaBtIf7CxxlMTd53byIi6u40FUNrjCw5jmRyW68QthxZPUNv93AyX2W4qgDxCF6G95AOX
	 eG12lkQkQ3OFpd91enATa1mpozb3GfOqUkY0G5vHIVMCCr1scgludUMrfWW7daIlS0TuG
	 K0awaHrpgZVVi4CLHkkqGLnfbnMQa67rCU35Qkg5yK8i5bZtHqzPcMZlwEtb9mmzKf6hi
	 3M4vqcBelhlIL+HMj363D+/N7FL60qsvHow/6hGqvT1gP9v0mRsKVy2ZifJYwO0bfmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692962;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
	b=hu8jjoFn+298DNNQqyZZs/cWhq4MXGSLoMcq8gzljWom9Ps0elHb0kme3VQGKHP5Pt29
	 uuMYmDFubKFJTryPeCz6l9f9wr+PJHiSyzTjRwoSYobF39zMyazML76WUmxzOFhUm2p+5
	 9LtkE/E8fE/UChiz3Asu30XxSnDDLhXkIGFq4Rvw7VtQ/wS/0hLrE33SeC5PPlswwMwOV
	 N07S0c0odusWqY0gtklo8fLcnY2wB83vpx/fOK0SY4TLZheFiSRIIplZcCWFwMln8Kll3
	 vMVYWFcuFyNw22O9+ZmjQ93GmLtlS+HdvHD9ldKvccHKJ9+qjuXJQeJHoJyAWuJikMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=SUC15hpL;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FA606A324
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 18:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B6FA606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=SUC15hpL
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a01cac8733so114053b3a.2
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792692960; x=1793297760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
        b=SUC15hpLmjAXHuU+ZW/v4EzAW0sUvPzV+xIGiD58nZmal4dDIlWvOYNA+3V+j+Hm8h
         5FoNm0tce+a1YjeoYofPA5gjuUeBxDZoQf6c2pybde5UtZLACr+gmax3fLOsUNua+1qZ
         S+2hyNPEgKdPT6dXhNSKJdA4veGGHlBNAHW9+FhP5zwYTSPuEm6nvzUOy9NiITXw9c9+
         H1cgF6ANDxiexWMucb3BO417vNnQWExGtYxY4zQuv8Pdds59vP9c9WpqaMVK/a4/N/0b
         WIWa5k2nVWww0EzQMYliqwExN0IVzfoAfbPHOiJOX1JX+D70xEczmTfVKrlyqXJyjHxA
         XsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792692960; x=1793297760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
        b=YjsOIpCkg/TkkNxCxZHenAlVqe8G8m0ynS1a558aiPudKBgaMjJG8MUK7Nes+doHBY
         5Id80vi+vvsohtUs5F6s660miMOWq5pHDgFmDdaTQfJQYXpmNy2yfF2zdrZ0UkmtWQYG
         yt/6TdXVB+yGZzKH+juQKstzSgZGYXOw/czfXOdrpwcSX0TKpkD4tA8DLHr9ZApcaiLq
         4qkv5m896Ac14rs38XA1bNBY2Pc4Mx4K01uJo4LN5XQnPooHSQRHpmqgre7jnVaA3QII
         nbwogXJmlP3S/0ow+mtFUENWAK3pD/X3e6oCbhEk5hDKiS8q2C72w1lhEmpUkxIhIdnf
         P6zQ==
X-Forwarded-Encrypted: i=1; AKwUvBy2PHrSXhewnOkPi2z87bFCLfEDiH5DaILHTAHwybVbtWS/gJiLF/0xGALhmOoMn1hsYD1Kq2tUgUlQMl8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIR3gVugeuxnGbjdx3Ewh16YVUCHuOODCnLVVB2ry0kEQQtv961
	D1deusceO/PVvW6tYEw3CyacRqPbYns7I1OcR1LPDw/nXstekg/jy0C8gcnIWmZObFY=
X-Gm-Gg: AYBFou3gjVs3OeB8IyeEYMbjmAG75E5VOZ/Lk9adVJqRwkl0S5CrU2rGtabilORlclc
	X+wOuJHvO0vr7qiMExtsOH1EcxCSMiJHFjakPEoxbL4xfHaHVNt9bwmv/EeVUYnProE++g46QEL
	9Rr7mPyQXkYDYSJkJPiPohwIYTOrtJVIHzQ3K0S6hWgPrJKfb9cX3wQDa9K+jClcWBH7yTTDrt6
	FGRXXY3H6ShMSkcFjJY6wXgka3nhU8BYYjPCBXeAWjAvDzyMbPriPLa+9qLHBd+IVMhyqmnUcYK
	RFFPxV2HK1CUktrV9OQUFBOI7/rEQrKbBJWJbkwusT1P6tBpIHD5c3jLfPBr0yb1/Co8uLwpDeW
	HeCE9cEcH+Hcq7pdCwuEYX5aq5MtkxCskdVuKi/3E9z48oxIojS7U5a+OrvhLvoYYTmgY64ArnY
	PHMHAXWs5lsKcgWarxnzglbUazpGt468aAqmz3qbz7+4dlzjGBWooX4BVC6s0D/o6wrWyCwQT6r
	uMVRh5JLTyZLT0sMXM6NOHBOk8W5lOtEKd7x7+lE/yuUIdwOLSHSXOEeoIHAcmRlyEOuu8VwQJo
	ygRepuz12dhv/QIgMHg=
X-Received: by 2002:a05:6a00:328a:b0:89f:450d:90f5 with SMTP id d2e1a72fcca58-8a089dc75admr5056028b3a.11.1792692960553;
        Thu, 22 Oct 2026 11:16:00 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([115.138.38.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a28e23ea52sm774370b3a.33.2026.10.22.11.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:15:59 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Fri, 23 Oct 2026 03:15:52 +0900
Message-ID: <20261022181552.3002041-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
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

The values are counts and never negative, so an unsigned type fits. I
used int because rdma_rw_ctx_init() returns int and the sum is guarded by
WARN_ON(ioctx->n_rdma <= 0) in srpt_rdma_read_done(), a signed test, so
int kept the surrounding code unchanged. I am happy to make both unsigned
int and turn that test into == 0 if you prefer.
