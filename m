Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892838;
	b=JsUokQYf4shpyA2+pBehQoB7ceoLMeU0nSj7M3dzwGLx0kRo87cGUI6OyXNTTABWJVBz
	 ORwyVExGKrU2cgUl2bB3x+IovuJgIhY07XyH5/JiDxyycU+h8eXSsex5cIFIhqOtrFnzt
	 CrTye3nPKZFPPG4LbM0m7gB6Sio4Z9XtVF27UM3K37WdSJD0wcdZjjNqva/8CKUuWhB7j
	 LFUJNFtpKwbLwFsVfeQ5lOylh6GctDyT0NRfNEOL/zJtg7OLCiyl7Uzy2gkIS5eVZxsdz
	 ix+RVFyGFKNrTBV7Jvzn+rlzwB4kWSkQGvL+Gn5XI++oDfWLvoAamji7kIueTIZmOHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
	b=sPEtHY/FFdcxQuOkJzT8+rcNBNjphvGCTdsui0YluwRpL9CYZkVciImQnOe6heP/hC8W
	 hkTOHUoxTkJo3UdvqBdam8ksaONRFCVE+zZz7z1LKhYorosWcAObJLofu4I0P7rXV6ZFo
	 sLyhbs03ZmlLAN0ElSocXB63yTGMOpJnSvItYAuEfsne2SC1mkHN6nri/HAkcqezRhNHF
	 OEuJcMY8bnq8qSrV0VgQdZPCLW14RGwkob8Rai1k8fKD+A/1erMhuxSFxEC5WsmO9jHDl
	 CKd4fbN/t/izP43FjIF71PF4vBxfStJi6nR2sCqHr0XFdcqwba5bfYU6oGSPDSQdTKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=QEwtf0Ie;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF036606A31E
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 01:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF036606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=QEwtf0Ie
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36661f953e4so3705170eec.1
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 18:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892837; x=1793497637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
        b=QEwtf0IezA6YHXZvOT2zMKXka+shhhjpqW8zp0xZjbo9RoGWXKtazpU052jMq4aikY
         P1aOfJD5pn7YBUIAYTpmN5JvIXl9UcAxtgoNP0Wuum0zsCFn0KVIcDlYaFH61Oh3JOGa
         J0Xo4Ks+/eXAjVdS4K59kMW9Jd7Q+/uaimoLmuhIOsQwAINSiCEVezjJJb1DNMjJEDrC
         CRa8VwUHJ2u+OsJaVnwhK4XD6nzQS9bPxMB3ecqG4O0PPYPKIBa23odvI5psIfGrmZMn
         wQFighkpO/PCaKaz+x0KcLOp4LtxiHu9yidXdfUbHb3w9mSjGRfGYaA3NA1Jl5Bi6PP3
         O0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892837; x=1793497637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
        b=zHRgEjpcxlvzoFR+gy6OUnfQ7pabSBE2ZVm3rUvbykOZUaQTAtZo0IiTfobNOaaaaB
         z2zgAjzLpaRzGMW4CXdFHNbe5fMYoIidB2BHb4lKYPI2tBaBjljuWa4b6LSUAtU5kS1f
         6PaJhz74wcJ75UIkt7eN+v05NLa4Q1Vkd9suh16kOMeRFiTkwK5E4Rgz2MdeRAm5ta6n
         fWxGuH9T90dEtKFFVhyjZEUcG6+eddnE9Zz/G1wFQlLsdo/MhHdF5bBwn6PeRKUdoXPU
         LtTfbpHfiutgkgHSPqMc+UKeQsXD88bP2HMqNySj6+B2lJlnsu/xKMvb04IV0Orygj58
         pcEw==
X-Forwarded-Encrypted: i=1; AKwUvBygDkXJkEqvNWQEhmPHTC2+lsq0zAccmzOVUOVAsVNJzPvtjG6eWAK997QqCICrgPIp+PAdab62zhyBEWI=@vger.kernel.org
X-Gm-Message-State: AFq9FYK9yH3zeyRNmYFDwtILWX0nmhnNFIArAl32+b58Kn9UP5FtSfrj
	uiFOGURVds16KyYskc/JTIOAXY+mKJS+60i4RLp+odSiJmKTWLmZRQkkFPYqU2eOVWuNIH6cRt0
	cOl65
X-Gm-Gg: AYBFou2QKtQ3j+m6zGRC+5FekwT96yP0A3o1nWN+9xMHPtgClvk+aq3v+2w+/o9APMu
	6lsvJr41D4XaA0RuW3XebkBfJCmYEpOQ8Mxkf54loxqqwS91H61UBUljdYgzdFIIc1Q0wMiMs2L
	8dtYOejjR+E4chA6rlgxjok7uhDCYSnW98QXmV8m+qKqyFBjLzGpGZm2orJKNBPPw1E6GOHBTyq
	HFtf5KpcdD+cX9kGE95cMVDxptyUQxCZ/KcrtWGFNZeM0Gwypbo/ELhn9mFcDUbR/hoAz5jxKUi
	tA+X7hEi6LAI0rgX38ZUEuO593X9jcL3Oa8lCrGsyW/AdQBvly2R60WdrQxHB9ngsvKSq/JLcqn
	UKvcutt1z1tnUXPr4w4jn9bsebqbe8a1kA/RWuKafs7b0ynQTwAtzve0FIDKaA72Q8rjD48hZif
	fyE1IDyLIsxL+L8MKU7jq8WhQe5/Y3CpnUAwf5F8giO0YjfW2WkbeYYkMBXLTgvsws9rdrWEO1H
	mvECr08CmcYdqup1UhJHksJ9E4VEHre1hBIKC8VR97zPM1tr9hUl1w4TNhIh4zxm1yiGNnmClt1
	3AzYDsATjTTmcYJrY3dQcbRmzGodJx4rdfqbwGJLAoFklvzKbcu7YlXVHAOj3ApT
X-Received: by 2002:a05:7022:3d81:b0:144:e38d:8e52 with SMTP id a92af1059eb24-199374f32d3mr5050179c88.37.1792892836882;
        Sat, 24 Oct 2026 18:47:16 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8c572bbsm11981252eec.2.2026.10.24.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:47:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: sashiko-reviews@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 10:47:03 +0900
Message-ID: <20261025014703.3756487-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <01fb5172-3f8f-47be-99f2-20f2c9a5244f@acm.org>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr> <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr> <sashiko-outbox-183819@kernel.org> <01fb5172-3f8f-47be-99f2-20f2c9a5244f@acm.org>
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

Thanks. v5 removes the size_t casts, uses struct_size(idb, desc_list, nbufs),
and rejects nbufs == 0, so the code does what the commit message says.

v5 is now three patches. While working out why nbufs == 0 reached
ib_post_send() I found that a zero-length descriptor is not rejected either
and faults the same allocator, so I added that as a new 2/3 that still needs
review. The counters patch is 3/3 and carries your Reviewed-by. Both are
described in the cover letter.

v5: https://lore.kernel.org/linux-rdma/20261025013748.3755639-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
