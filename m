Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88764B0E42
	for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819859; cv=none; b=DgoPO9M0QJxRjtKFcLNr+0HJngG3F66EfucVHosA6tuuXNvuhLC6SBWMnb44+x3x0+Dk7xLecfGwGijvArHKZQXAo8UXW1ldB8UcKlCXRa9O0sPPBt5dzfdKGKL4niHMPmt50P6WS3XplHDeXsu9jY+tMD5DQP66BX0MxDY7CTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819859; c=relaxed/simple;
	bh=Q6ojckRBjYD3QiFvyFjmdXI4hG8QuqSOEgoyfAWTMMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYfDu/clSD6uiNso/SUHaXSPBbRRJpoq70MKwHW8cf9JJ5ms010kK1w5VfGC+SRi7CQJJQwnV1LDfEfAHZMUgZuoUHIJwlIVBtCYcJsx4iOz00dbzHbM0/9+MQAfVo9LkmM0+SrdHN7BLN5J+7m/SsnP7N5pynaC2NGY0elOp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=x/s24oNx; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="x/s24oNx"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8875d220446so905430b3a.3
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 08:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791819857; x=1792424657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JhzmDkyNi5tXfQXog831HLqTAGZf7SGBLNEnHb+ghbA=;
        b=x/s24oNxvroLDDLAfp60YmQuPRLo1FIUJqN9c1HmGA5rKvWVm2VBbtuReZykyaxpzl
         gHjE3uJYVmtrjreKLo2B0f3VXz+UBJddpig53TRZG06+eFhnGIF9Q9zn7DGLb5n8+bvX
         jzhfa3XYnSRTNp1dw+Qd7vDhCG3xxgYUxlzASKZuIrtmm7DZMsB4LaWkvqpqEYGZSgOS
         ghrNoZdSJ6SpNmGnjyYxg/WIe3URGDtmItBhBlJbfn0WMQvMlga5lNkgF7NPxswTK0T+
         ZBBMJyDcGtleueDM4L8NncXH73dHu7RDDpkchWgVsRYrCifafj9D6pCRww+rXFXBSXc0
         bvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791819857; x=1792424657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhzmDkyNi5tXfQXog831HLqTAGZf7SGBLNEnHb+ghbA=;
        b=U3dQRcN4vrt9JqIWVNlEvt3TYXgkgyp7SJ6K0anAS2msPnn4mcegl57CnFzrSQ7LoS
         Z7IYkiUWL7i2vYvVvdPbHOlMEizCKy4sqg2g/QoPmCL8Lzt8j1OzuVrz8fXaYxCNIojK
         VRkTB8pOqnuOHS3y9TIGaXKruIR5t+jvHVzEUn+PPD+n3VB64AnILvy+JhNaMIcqkLrK
         /cJZiPJwBfPfYuxdc8rssPbhaZnKRkkxoKDFDtNlRdN3t5WWmUHsS90b1fcArmxgbhMC
         8TxbFZUejJCG/BmXfQUntJugm8+JsPQ61IXggjcR0gzD0hLyOXRyYps3uIK69GFpI6PC
         vC+Q==
X-Forwarded-Encrypted: i=1; AKwUvByDyTSsNAaJ8naIM8jdHQFedhMXw+YEYWVgbwLuE64XziCaXm1PnGd9orazzUhXzTITMdSbeUic2v8UWiw=@vger.kernel.org
X-Gm-Message-State: AFq9FYL54qbB869DL48kjBPpUyptqztYHmuzhHpRK+PJKqWiOroQL4Qu
	NpgPGwdl2EIWlPj+k0uPyCk0NG7/NLQSPylEltXS1z74/RbUfDuiz7eLWu95BYixnqA=
X-Gm-Gg: AYBFou3ZIWpgMJ/nhhjXLGaOmBM90zn3hWjKZZ/QrGE36R1gGTP+J8/MwrpM5QhyJwT
	NmSL4FflfZj/Sq2FiZeMzFpEOfZns4jU6+Wdd4wSU96r1IUbpXibKeZh0ckY0wc8v1Jr5ALJeWE
	wEoiQhMzOGYVmiTP5mUCIX6s3es6B33LGIm/+iNaVyXv8IKby/MlGljMozccpJAarl0Yd2Zj+Fp
	OqYlV0JIvgJiFDHhlJWNs2GY8LxygMYoA+hKAdtdsvZgpk3qtZEln8nBdqxBqrplrjwU2sSRO1Z
	dUFSZFp3HGvT4RhMPdvxO6shXmwHm7c/8StbyKqQBJhFmIJiHGix5FxerCCJZtXQ3FrCSMGl/qK
	wTYxYwf8tPwiiP1WOqhIhj4XyoTVg9NX/P1oSG0e8FKGZZAzfHSeF8BTsHfZstb3uBG/S5ukuO4
	/m9stLuGD/Jmxs7jI8VRbqJqLf1cVbLWrHQkyHfHbO9qWgs56z8fft45x6RloXTHhhprudr6w5B
	rcwgmpodYu5Pgk0/sdwaA==
X-Received: by 2002:a05:6300:68c8:20b0:3e1:7199:2309 with SMTP id adf61e73a8af0-3e171995951mr4822949637.64.1791819856742;
        Mon, 12 Oct 2026 08:44:16 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd5dc37c2c1sm3342938a12.6.2026.10.12.08.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:44:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: mkp@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Tue, 13 Oct 2026 00:44:03 +0900
Message-ID: <20261012154403.2436121-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168243@kernel.org>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr> <sashiko-outbox-168243@kernel.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks.  You are right - v1 extended a tracked range but didn't re-check
whether it had become adjacent to another, so a reordered write could fill
the small array with ranges that were really contiguous and then reject a
later frame as a repeat.  v2 coalesces adjacent ranges after each frame, so
that no longer happens; I reproduced the spurious drop with a reordered
16-frame write and confirmed v2 accepts it.  A write split into more
simultaneous gaps than the array holds is still dropped, but that is a
misbehaving initiator and the exchange just aborts.

v2: https://lore.kernel.org/linux-scsi/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Thanks,
Yehyeong
