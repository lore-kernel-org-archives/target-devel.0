Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002028;
	b=KmTSd9+33ssY8ex2EIeDmhC9EP6MS0ZNk0Op57QbDGTNGjj2xe+c/3paGBYeFfLm8Ro3
	 QZZIc69MAunuMYvxmu90LAynmGeFYctkklVTUhALvJA8wQLCVhgkGR6Di1ZXyVptmP7ke
	 63IIToWksKGREgaLUoYtGNthE78xMlruQbann71lEBr2MYg29jvy7jibuvrMQyp2z6kPz
	 6vyW6pcQhrEJhFrVk+TPbGeWRy0FbtST7WXpeRO0M3+wg8mLLHhIDFa4zoMdagrt1BTxx
	 3cntfp1L26c4pO0+UkALDDNZWqo6ngnMEq9P7vpujCUGf3KxfV1NBGiocpKCFh1O49Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
	b=aeoQLbFfNW+XnuwqA3tw96rINqMac+GvK2exZnNxcJ0Nqem9UfyzeKUNDBuZv93zYdtK
	 ElwnfHvkoGs086zM4W535mCgFbXRRq/hZG6hgUPrs62UdLxjPFcQsdymqxSLh1z6iISeH
	 5HhsuPj/HE8kj1xSF3a1hEi/YH8qebvKCrxuRbe1tuEQL2ReXmyRjdJUj8jYweO3jFcZU
	 Er7WLqJMA1OqdMbqYbkN9LadqJB7qXA9Upk3gEgks/DKVnCeoBT3vgBkyA72DSPUaZNYi
	 yT6JXQJjwpgILV+YjMW83JAXZPFWXEH1f62V8nIc+BV2jE/WL1erRUr9m3zV9fiu/uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85959606A32A
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85959606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso506135a12.1
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 03:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795002028; x=1795606828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=Ri4FMxE0ENmt5ExlIpMFuucBbg8Ff7sKAf10q/8ianryZQyKtbi3YXq+ktSfczLSfu
         IctLlAj/ddfPqpMpLdJSQfghV9HsCVBQXGWEkWXn72XaqMlG1/eCJwwmgrY6/N3rntfN
         ZfpbOVhacSiGr87oYY/VR6SGrjRQ6qgHuYNfoBwiKRW/cuRuT2NWrM5Mu7Gx4VZAQNMu
         gxJRzVDdgVqV3Xko6LFK3vws1WamrlKSqKm9s8WgCUZWPHAPe/9bwG6Cn6uK0NqjWDH0
         EzCBn00mfADqxTRlXynqAz78TtowHCugr1TZsMaq4UJcPOVvGtmybUrhGNu/nFBP3gme
         pEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795002028; x=1795606828;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=w4DfsqTBljRZkfcNGJ8nQ3FBBil3e8pegIYLGAQILnCT3/pUszntpbpU10YYdLrX1G
         vBp3iucs5n8GOFnH3swAp4nqF2chJtjtWTyEvNJtXHv4yNr2wue0LT7JOdcys92Pj5Ah
         OMzV9wgv6VU9JipkkJ6AE6PxRXokHi8T+Acg/UP5Ib/udAPMGBdDhoi4E97nfjkb47lv
         Llw3pWPT5UNofoX23/ZHw/mzoM0K+sU8OU6dbK9Kw4BOsNDd8wCUKHzOVpXV7fPU+pJo
         oKjzpSJ4WXNZA+lnbQK+R/ZhttZANONdI/8b0+kR17wxp0HegHXfGlzCxaTDXUwRlylj
         ImjQ==
X-Forwarded-Encrypted: i=1; AL+hErHFTYfnR83fR6HTmHwjFgL+34aZ5jZ6LmXsPhLFZhKTJ7bhiz0au1m/Fe+iFCNon2cJpSDsOsE8fTgpWfU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/y+O4VWhkWyvhfpntNgzBSNVnTyqBBE7Js2leanD3aYQta359U
	FKtXuuegD/cF7oBJNGasSR4P7DUTAQqA8/t1xq1F6nfkBaDISryKJpWDntnbmDPtRA8=
X-Gm-Gg: AYBFou35zp+qIPKxH5an1VhnfaQF7gCjWE1ubJDLixXInohmk+O21YSAHJFzsW5T37n
	7QyH2cFkd9lVU+cB3t1an8X+1oyYGQsC8NJwwb29fx/Vn9GLosO+RtsfgdEeuU7ItYKSbjM3LHH
	NzKEZp0OFTzqLbPp/+FyJ/juupsUx14Kk0qsIA7ZRz9GZX4TVKyjJrJVR3/AjpbVniX/Ss81GcF
	F63AG1UHrD0eYUrgfKqzskjCLihbGcCfAXF99sU/c9R2AtkMImd7kYkefTw2pCQK+liMb480NqR
	7VhriqHzAw76vOF1xpqpwT03Kms1vY6cHpGVFid+6n5mt1pW8SrcWV02zqBEbIq77BWkK0y1iMc
	tFK8ZLZFRcTdALUaQLo1XmEINnhz10YiuLwWh0X6fne5xvrKacSprRJYfVQit2fEOFhEsP0bqTJ
	3HdCDwEbOhAxdMCSW8OR3BAm+x7zEedKTiVoBwWlbya1cR/Z1ci/9bvEGOMSryMliYVLwpIuCqQ
	xhvq51dBAAgtZ5wuRDmskMCc/5Dct3soyiS9hBQh0YvKoKempNxBWzUFhWBG/qDztkGbmSAFoqU
	NZVorjdps2sNccND8LGAP9cSUY/3xOhKwJ50+0dKMBtUhKjvjG20+FO0CU1+tSteBov6lncNP0j
	zPoOHlQkHryAIyvBKVcrUMAhUJEvCWkKykk8ywQ==
X-Received: by 2002:a05:6300:6690:b0:3fa:988:1ba7 with SMTP id adf61e73a8af0-3fe86bdc721mr2207986637.11.1795002027791;
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5cb35db4esm1038189b3a.35.2026.11.18.03.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] IB/isert: finish a Reject the target core allocated itself
Date: Wed, 18 Nov 2026 20:40:19 +0900
Message-ID: <20261118114019.2362132-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2:
  https://lore.kernel.org/all/20261118113905.2361969-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
