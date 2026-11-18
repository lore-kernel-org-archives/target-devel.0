Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036591;
	b=1yHElAG2fvujyW2h3ISJbqlscfYyd59zauI+TkN3SF0vz58pWl8qysylCjbTDdGRhAmM
	 Ay3Sj/B8YOdi/zSBrJfm93r7t5TQ6ilYoL51uQzH6ZUYcHCqYmuCE6grRy5yDwRN5Rfwi
	 ylPjaH29lziNhFiXo8Ur92H15O9eExf9nI7jHfcWxgixcRQxSuJeIJG3QMS6XFPGqaBmU
	 OmBf/Ydr2N9cPglUy1D2/9eq3q09MYDzq8boLxwuZptduYPfVtDine+9do6wKJSs+IEnA
	 f2A32oLgTXwz5Su5fFBKOYw8CQvELtxnaNboFWW95rUqN/wC1dI47wWPcI+JQ675IqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
	b=h8GwUJC5EaKRjGyWzo1AYJbfqUYX6Z8/zXill+rl6pJKAyZQB9Y3lwjYPgmTCcomZE24
	 cu+Bv5q97lDTyTvfsTSIew7ujguAPNTTHNzXh1jM7UnRkEL7R7fnrpqRk1C4JgXRNPrNp
	 IIRtgLHGo07n5SRep/qwyYsbZb/mrqJxxZIhHdMP5J0q1eIBTc/Oh5CmvayU3405Ig5z/
	 S1YybPH9488HDkmbSibzghKuoYdtxV8qI27fEGKRcaNvEMjyU8JP4gYVWUoB9KyBiLMHf
	 mH0rwzbtzPhjzfH+txgvYFe0qhCimTdGO0PxARPhnN8CR2uiab4tkTQEll9kXHfC4Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299D606A33A
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 21:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5299D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso904493a91.2
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036591; x=1795641391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=tAKIDOonM/7tAl+OKNOFPyXrRjlTvzxrmWiMXNZVhliT++H88DRZp4VsIUQSlAau47
         6Spe9kGkx/9/L36JcBVgrovt+2ZIS4Cr6mD4O+TqZXkb+Fs8d3BHkVFjNRYauw6KUOLW
         pdZMZkVm1dlo/rRzE7QAqZrltbbI/Gm+XgjCCSuf3kb6HHmDw61HbQhBPAfAaLim7kcd
         KHhTUjMGyljf1cYXetfpnx+xFF8C6Hzq5WQIa6scbKxA9JGH3dzX3M6mnJbWax5CbQgl
         rVV82iAcZE4+QNEKxL/Fr+9TjwXagcNwTZIGgDnvPrebuhix9W35IoBv55MqzEQgj6nh
         xwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036591; x=1795641391;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=SAvFoe+RoMJCrvOCpTpHCWZHXPmsZEwV2ju0Jai37d9CUJQ8T6vvVlJnafNESt3vn7
         0Ap1NU/NCDEquueVHIxjTwUPfuDm5+Pomia6dZGCVGnpGZrTg+QMlueskGCXnf7nhxrG
         Jbb8IWDxFHAjtrnWAmgVKvaS5a/8LgivoYJ6VQLwvhXb/87a++Cfa/4UiGLVZCib2phq
         PheAp+IyLoJFHvbGZNIjwYwQFfPBrCXAEuuPDrJ8wXET+eWPvozZZAwgS4d2wSAbDQh3
         nTrbfd/3MgUvkZFPxyy2JMn3r5oHZ+vYmaG8DTXdbZcyqZfeEhYm95seAfr+dVqwM9bS
         7iOQ==
X-Forwarded-Encrypted: i=1; AL+hErF9eumK/GtEoQKkCHiAZqqOrVaXswucdk/KJ3Oz35E3UeaHpBLgIYGlojU8qNXXGJyRu29PJxRZkVjYHKM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DzjSWWZ2g26vhvZy1hCbCOcUdcXrBeQwW05AuokG5pbqdfOYa
	Gj/BWJn5oRmJlfVhn+IHaixzy/22EYyod3QP9ZRb04GsOcBMduivDFpFSlITZwwKy073e7Aon0s
	uIQ471HI=
X-Gm-Gg: AZFdTZeEVyA58mc8O+1zU3V6q7lQuHW1EVkrCpsbIr6zgTYJtzueBQQyWaO1pgE+r1N
	Y50jx3fMhL6vBcOCUIjjBwlaZ5HLpkUoTqcXI6OoH4HK97Y209nf2k73zr9hiq3KXxb53dJcHr5
	p+fNFWPxMw+i7zg9iM7fK7nUyR37cknxXnyFFokjvPYPWTMtkTtoLXk14DaMoLBUAHh+PdcSqqj
	pzQ2pyGVh19WimwygQMDbEAmIBalXsQIWtOVKPduTcSdeHUAhreMwqTV7hS3hu+kkPUapaIxK/4
	Q6Q//ybCHNOsbGgoQK6PlW82XDnXlj8AdQXR8vAaUY9NN5uxQpx8jOhQ51BtDrJ6FL0x76o/EBJ
	/38GfdQZOJV7Y7zZPRxEEfGq6MADk76hBmhk0184XsEagPruU+mDgcLYjbldte7Gnzt4VPSQ8BL
	5qAzufdOhHRRt8aHLSO6Pmf+AQ/J27vkC1Bul3o6vHRGpTXPELvY2OnEjJOF5gWt7qhepBwZnbz
	EDgIILWU7voms/l49CGijogmcSjOtIFDxdqGdIuifiweW6wPFo374s3/8MUJRPG5QRdZ96NS8Fw
	DUvpYLzUHkavjs1I+YlD2wQgN7cG895P8Bq2OSOwfnkndpEC6JDk2J3YwBWkf8dajAaHGm3JATV
	NL5QwXs7/xxzGqdD/3bcYnjxib6DGQcBv20LCbQ==
X-Received: by 2002:a17:90b:5307:b0:3a8:545a:9e87 with SMTP id 98e67ed59e1d1-3b3d0759881mr3709135a91.15.1795036590739;
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f706dd83sm914903a91.14.2026.11.18.13.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 06:16:23 +0900
Message-ID: <20261118211623.2526894-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v3:
  https://lore.kernel.org/all/20261118211503.2526705-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
