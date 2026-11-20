Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174875;
	b=WvIkaW129vh/oLcwvNI7ZRy3EMHEYT+BDEQgT69B/zWVUtF7hLIUUMpb5jqxpWbpTW5n
	 OOi2NvkWZ5Ng+6ZS/fiwxeQpqEYOZBtAZJLvCMfaSqYpQQ2fB/X5IrNvP8+YV+eJN9R6G
	 VdZthatZ7n450j/OgwFa0c6JD/WwScf1qZKzD628JZEDZKMnsnY4MBJcl3HYD1SKlqd7s
	 XywYZtPJEpXejc59g9yo3xc5W920vjSmZH/aX3/7iFFKKxQxVvdlKDMPPlghhVV/oiM6Q
	 JaUmG+RI66G+MY6OtAphCuZu76SWhc+QKqt2VZdfRZUbz0KzQH9lixsxAdKabVIV1OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8CwPJKjV6kCIIzcblemdluBfnd2QRRX74DnK0ggRw68=;
	b=UJOLCpijBLN+lIx+fT1pA8Et/AX+nMZdjsNFLubcaR+8F9BKC1+Co/OffqWEmesjJ9kp
	 qjyn8RbUblxxoMVb34unoivY63VBXCb6433+rBd5kv82oFCvpyeDWtoJ0t/RmsfKSJ86t
	 H5i0mu0Ed6x6t1m4/u7WLLbuJ2ihx9U7CbLlsCJ7vvyaykEqpSQc+57AGMYevmLGIs0+F
	 OhU890Ua29v29dKh+ZNtDrVQR1W6C1j9NdHm4cVx0VAzIlEiJFON+DOS87/Xs1NlKxeZk
	 vj9mMJJKu/jtU0I6fXAi3u7hjGQlU9Dg3VxiCGfVBbvDmNj3gC08UkEElOu+eTw4zew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T+q7QWH4;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765E4606A32C
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:41:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 765E4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T+q7QWH4
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdba1b5ed8dso396102a12.1
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174875; x=1795779675; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8CwPJKjV6kCIIzcblemdluBfnd2QRRX74DnK0ggRw68=;
        b=T+q7QWH4CwDRmAMjxVuYKwoDHVnOWgOKxBKRvqw3xB1wacFuxx/+Eshd2otJ9S1vIW
         HqBrAyjdiDA4an8Tyhu3etEu546IyUmqhc5L2N2bMrKbW+h2dyk5kIVNvveE3+rklaDh
         W76WW/RzEtqeB3V4eKTQ+ko0vh+JJOSJy1PeeyG3lgAGshimY48LPpiJ82xzxmTmNlqA
         34QqIGS2HegNP+hZmdtl5EsGsEM+YZOo2HyMAXVjLFJ8nn4hJnVhGZHsmXNVF0HDGb47
         fayNpBFbP4V7R5WeklzQYVI7udmhahxcY357jKBBsV6A24tNEz9wEM7V1zVRW2QvNQj5
         JVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174875; x=1795779675;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CwPJKjV6kCIIzcblemdluBfnd2QRRX74DnK0ggRw68=;
        b=QQnIXc3y7WoqQ8tflTjs+H9SYEkaaA9pLOyNXsnFq43YbTKoZYyQ5H1qYOVBEef4KF
         ++XckDdLdhnxhMF91m1CcAOmRJmf4E0ESjsUT19EC02wm9E/qKrPtqZh3Kjiyp/6/mTp
         dh9pxLVyKT1MMhyKUStRQWNJfdyjYUxnJvVpdKZkLlZjBU+75m+EaCKCTbVrc0ADKzg7
         KKWn7z+ILdGq0G53KNaknLHj5mlB6lnqjA2zo+EffaazcWuQTKEiU3gLsP/beTUPcm1E
         pJPmXxkOonk+/Jc9GBoyjdNDSZxBEQZYCeT0epccclkvUA8bftQ3ZqMjIzzERZe89qTS
         /BnA==
X-Forwarded-Encrypted: i=1; AL+hErGS+E/uTZhdRYPcYVWyIlY2XmThPikJib3uEFYVosyMLPLJjSm8Pv9KUmHNiS9rkHM44+7lPaiB45dHpfc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9cpsauwjW+CW1crOw8rgmi21p5irIzo8lWmsbLsqenlkixv/nJ
	BrDCQ5osXnet7dzuOwXRr2g4R9QLdeDxshHhEEbobGZGSfNbgNIoPVhGH689lnknGtM=
X-Gm-Gg: AZFdTZe/BeA0nKTnGpfcjqosrzemKfTmGQ1Pf4KBC/RUxjUIK9qBKwvpLprjEHHeDwa
	/toTySE473dJLMe1l3BdjQbtuJ/MtdJnJjVyABbPwIz8k2n9VjjrfzpxRlTM+VYJYAAkUVlWyHE
	I9QSn6bnbTBsTgt+rDWnJcVpdGTd0ghEA0HQxwH8NVZm7VHUX5rOTjSA/sNobO4COts8zcLKhBu
	lJh3d1mCDaXMJ2HVa7/pY5WKrgkX8DZCa0i0eftYVm1QRvG34mSxPlnacUbfCNgY3V3rWFcG+xv
	Y8I1k90I9hCDwX6xDvamhY/49Iyk3IFho7Iu0jMjTT/VHlI2HJIU2mcbmNRXbhr3FSdq/6J8BtA
	+OTkXK91u/LxR+rlqWW5cksOjg0zNCLumGKWdcWMSPClmWAaiXZXr2ajnDxKcVUkRexYWLukwmK
	uQmAACjJbI8DRC7TTEYCQBRndYYdMauBa7UexJD8Zj9uiteujxy5Mqwgtg14PJoabNYf+KCesSY
	H+UQ/nW3u16YWkusReq4WXUbhul6nFE11JVy4KOdt1U9G0Oj9DHzvoznYQVM6Ii5Wuaxnx55MpL
	4RB2MWbU5gs7zRXWp9H7Iy/mboaaf5tuvt4GniHyoK+tEj+ku9DxzPQG901RBPovIA74z5sBnVm
	8/oO+KVhKXRHhRySkObMCdE0elrTKwQizxHhw
X-Received: by 2002:a17:90b:3e48:b0:3ab:55de:e089 with SMTP id 98e67ed59e1d1-3b40a611fbfmr3110569a91.40.1795174874780;
        Fri, 20 Nov 2026 03:41:14 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb2076sm4125523a91.2.2026.11.20.03.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:41:14 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lgs201920130244@gmail.com
Subject: Re: [PATCH] usb: gadget: f_tcm: put the overlapped command's request back on ep_cmd
Date: Fri, 20 Nov 2026 20:41:08 +0900
Message-ID: <20261120114108.3071955-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-223285@kernel.org>
References: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-223285@kernel.org>
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

Right, this is a real bug, but it needs a non-default setup.  With
emulate_tas at its default of 1 the core sends TASK ABORTED instead of
calling .aborted_task(), and a BOT session can't send a TMF itself.  So
it takes a LUN RESET from a second fabric sharing the backstore, with
emulate_tas set to 0.  It's an Oops in the target_completion worker, not
a panic.

Fixed in a separate patch:
  https://lore.kernel.org/all/20261120113956.3071640-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
