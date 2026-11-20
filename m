Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174349;
	b=PV9chOk56BDXyWEqa/pK1Mw9AdKvuaxPmBl5GvRZSiD+z+zXN4WeBkX3+N3XoG/4oJnw
	 iqfmR6welraHWZog3sqUFsgeUj/cclJhinVPx7If/+G9MM6k+lzg0P/0fYdsSYPrNmzjj
	 JGJexPurDOZ4XvCT98wS+/FMoslN6IbH235oGu0VEjncQ24qDcURfIEN97I0WoKJN/h38
	 uey86GjI1tyVsBEsJwdO+sC03thu9oez+kF7Rgl70FeWUyaoZF7hkQouZWtbiLvzXRL6x
	 11rnww4sKocT4nFCzs35aHY5eOvadBbe2nFMkRZuUrXIsinHdZgmX3IiaOOTXPjiuIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oT+e5zei8W9zq6B7ygBEpfry0rHVJnLOEe7Dp9Xm5iQ=;
	b=Q1nD1xeTZd3YLP/b0gWcY01x+Stfjxlq0dyz2H2yxG1Z9H9Dv1W1uVELqsbcv7x/I1xE
	 1WNH1KsYRFaA/K4Bolg+G9y72cz2KNVq2dOXDWVqq3wrw1QKcBuzSiuRUOWlqV2mjR/J8
	 qR9fQ+3Oz3hOcvGFWBqzhCCDhTvcndnzVjp01zeVEGdqxylAniDl5Vc8pe4koA8YY6qeb
	 c0DSj1wp/xUbckpsW5bRioxv1fMjkSqnELZTNMgwt5U6Frf/LLsXXZQ4OHw+g0kUsn+ZP
	 X3tq2VBRFjaaUtM1FESPDuh/Z6XQTFZE8nHNfzdWMD6egAUUThTy03BxXGmGrXjwCzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=I9l4jCPO;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8B60A2606
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3D8B60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=I9l4jCPO
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f03920c4a0so4943115ad.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174348; x=1795779148; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oT+e5zei8W9zq6B7ygBEpfry0rHVJnLOEe7Dp9Xm5iQ=;
        b=I9l4jCPOg3s4jnVn9JbxVQCPLY1V+MobJ680af7AuZNKjBk7eA+YRPaAmB0yhXoIxt
         QQshzrzYHQxrDTuo3Djua4arc8Ha5nzzoI9DqFHylBe4TCKxUrxw95NYujJqZ3VaVdvU
         HqWkktDJYS0t8LUWSAwoGr788QxKfFP8QbL2Q7J9GjDUw4TEP6ujqaszk2kX1t1uLX1E
         RbvkE/tRieqOPy+0g+N0cRXhlgrn2OysQYcibsg2RSw1qIdlgTq8g5LpnKJd4v7WU4CW
         Um5HyrcfKKBAuRZHXk4qj+Ytvcrmp5oLyuygUYLwr/XzoqW6xbC0x0oZvBJo/8+fXKig
         c7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174348; x=1795779148;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oT+e5zei8W9zq6B7ygBEpfry0rHVJnLOEe7Dp9Xm5iQ=;
        b=1Hjd4YQWUp61RGctjxBS+OABp1xpLqryhfRuZVUlRD8UbxG3HzuUXDrH0BJH8qcOqK
         VBUv4JVZn50WTu6HLRzfB+93HJHPLXwRJNXcQytuXegrbJGMRSkKjC3jFVUjC0s4u41c
         GsR0yamzDxC/wQltMUMMrSCBawLa6xv9lePSYgaB4rdeljD/CcGqeT20PPUpio6KXwVQ
         z5qfbGZgJYJLhalkFb0LqoVadnaPuhBOhbhYw5ovuSgBblzb/xrR4p6unFULDkGXCPjS
         rbq6d9U83nJi9tzkuFOn7m7UaxLaRMQWtj7oNWl584+Zj8nXwouXlQJiAKkA5abO4ONh
         nmGg==
X-Forwarded-Encrypted: i=1; AL+hErFlJS80ZG2QUVHWFb/dXW0j08vscp5MKdCDhLC9s3GICCYS4xzavqC7STK02TSSO8WwW277lyBmdqwIues=@vger.kernel.org
X-Gm-Message-State: APuU4Z/DVigxa9awlA/PTciXTip74PooQX0a+OHCFe33eD2YOkP79SRR
	4W3OlRPXyBQOJlhGqv/iL2yrOSOCgWUIA5KTf1dCah6WG2KmpJse7N24pujM1Qnq/aE=
X-Gm-Gg: AZFdTZe/Z0ZH37gLbOa/w/UmdMxIbmt93gWJrmzpuSYN4B2fDuZpM/3Y9h+PzZDuf42
	TlK8i/xVEKVksY6kbSJGbU30Z6b4rjl7nsRVdKwHXVPKu8I80c5JGIOY/tdXRgnkFZtL0gvO4eC
	9QSmkIlQ0Hr8yDURdvY7GrND+e8kHaD8kyobh4Nu/S4yyAA1xISHwYN9zCU7YR1p8NGZ4wLQcT3
	OGly0srrpM+2jc4mET+rB01jfX7Re3/0lSJ/Dx8rXEVyo97bdv6dI1Ir7vEBiZvZoXYHp3v5r4q
	0di/S0ELHmeFGC+/YN6moM28yWOVByCfXI+1o0q1sOfgkhpDAuTqyJfg51c6ZUV77PREaABVogW
	s5fEfO+NPuE8zHOY2dr624VjHMav4q/yoK0Jx8a8/qkrS+m+WwGAN65zqRIqt22UUGmYKiWMUB9
	/oNEOAhO407QYM+VBlL6BTJW640X/SgtmQVqLhDRkCirjccgs9Fdu2yGo/SPbVC3QLpDh8e5zwn
	HbETnhGIVbjGy3FtRZbqQ3Wpn9x2+9hGwZlVYG+CRo3LwrL5Bgk2yjRGG9TLxBpmPFoZTjbN8rQ
	+2xJdnkSKELhPzvSAU9+QV6frCjVkFyQA2i6pNlVTelRGgMkAfg5o86xXNbIl1aeKGak6txsYu/
	WbaNH/YrhFwxbLad/C4Sf8sU5eehDT3OPnjm8
X-Received: by 2002:a17:902:e741:b0:2e9:d0fd:639c with SMTP id d9443c01a7336-2f03f1ea747mr29262845ad.55.1795174348092;
        Fri, 20 Nov 2026 03:32:28 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee848c1sm13247705ad.10.2026.11.20.03.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:32:27 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: nkapron@google.com,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH v8 4/4] usb: gadget: f_tcm: clear the scatter list when reusing the BOT status request
Date: Fri, 20 Nov 2026 20:32:17 +0900
Message-ID: <20261120113217.3063855-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026112046-thirstily-cosmetics-1aca@gregkh>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr> <20261118124005.2428068-5-yhlee@isslab.korea.ac.kr> <2026112046-thirstily-cosmetics-1aca@gregkh>
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

On Fri, Nov 20, 2026 at 11:55:56AM +0100, Greg KH wrote:
> On Wed, Nov 18, 2026 at 09:40:05PM +0900, Yehyeong Lee wrote:
> > A test module that stands in for the controller's queue path, so that it
> > dereferences req->sg the way an sg-capable UDC would, reports a KASAN
> > slab-use-after-free on the freed entry for a read command followed by a
> > rejected command that reuses bot_req_in: 20 runs out of 20 without this
> > patch and 0 out of 20 with it.  A normal sg read still queues its own
> > scatter list.
> 
> Why is this paragraph here?  What does it mean?

Sorry, that is how I tested it.  dummy_hcd doesn't do sg, so I used a
small test module in place of the UDC to hit the stale req->sg.  It
doesn't belong in the changelog, I'll drop it in v9.

Best regards,
Yehyeong Lee
