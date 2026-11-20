Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195901;
	b=hk79djACABkzxAZ8VTouXBSb1cJqS4G8Y7TR+IjuWefp8CPBUIV3atVyjjvB/d/qzeS6
	 ckYyE2yIAaTFQ6jECXK+oWzVE/dKRuxEVNhFHDbT30r0gyEpivRMmnzEYofZELFmcFylw
	 4YPpILcsKzN+emyR/QZhcOdid5F/HUsVY89AWAt9104UggkjohV7lrYofAXHdPyoE81I6
	 cPhthA8uxMT9gHu+wZSOv6uWpTgn2/cwCa51xykxvyBcSHHVrMGAFfwoexylceTnFasrK
	 XtHC6tkB/S5UYNiPm0NyhJq55DILzayfHngZK6xt7s7Pt1IPVE3LEBeOPQ8vZN53P6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bxKwdrIUuzixTrlHwEraSTTfViGb7kgcBDYdj0LG20I=;
	b=PJCxUTU8KpphSQfJcxaSLeDrLecp75gS8zcA+Jal1pyc+JmqQXXRStF6LeoNIgQ+dMZ5
	 1NIuRKtwcUNyLGsFnZZj98xBOHG93O9r2CrshOvwiKv51BQQb/h91bcMj4rrnlyzBCNaH
	 lFbWsp7RZQD3q/mHelgy5PZyVuZ/d0u0xtB5q1m4L0IZ9JL8BT0/31c6Y/8BN9JM/YuVF
	 Xv0hg5rQMa2Dwe47vI9IiPvVKWdDFjdWKhRAjn4Kn1cUKnnkV8p4AMZiHk0FA+xnZ82OV
	 rTvpEQH4tzJsJ1SPUTddV4Wv4RReKtcfnsx16JUBmLRswiyCXG9qf1woquHiU5C7DeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=h6UztEPa;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19860A2633
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 17:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F19860A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=h6UztEPa
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2f0213202fdso6867605ad.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 09:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795195900; x=1795800700; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bxKwdrIUuzixTrlHwEraSTTfViGb7kgcBDYdj0LG20I=;
        b=h6UztEPas0J1ez1Yuh9unLqPaR1gDwtjlSvghhiSA9vaXNPrRi5uxF5XEJRGkESiUd
         lRKd1Wx9WDP6/GvtOIgzygcN8Ir0csDzBM47drzwYJkDExX7qaqcrGuvB5kfqo5AgVyn
         tCgkqmAja/nlGi4MFQMTlf/BWdsQwRzgAChDghUENbT+UCRDtKEo6NCCned5mLOSgJFC
         VcyluTbKGOOqYmC+NIOZqGt1fcOy4nMjdTuJCGIJsNUktotD4q7DQVgyF39jjv95aZT0
         pjjbTtCPbYJmKL+VT/Fy9v4YtXuX7drAsoAk1VQTGMiEivSpHruSjmRhsEEmpErZRVur
         fo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195900; x=1795800700;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bxKwdrIUuzixTrlHwEraSTTfViGb7kgcBDYdj0LG20I=;
        b=EDetn3LpuZJwgUB7jML+qR6t0k0V3IABbyV5gP4EudKKy89n8ZXzVNwYnkJT/kpKD5
         vpdHzyhdEPWGSSyosvCJX1jyf/8e41fLAYyQUd3A2VMHQpxmA+v/DPB7exdMmgSqIzXq
         8D79Mk1Iz/gfTOq2sktru6bAu/AclJ5C5JLEV64cUyfvRViOEcMEFNxDauBYToeaqGzb
         3m/PRnP4cTM0SH1ZBhrU+JrpqJHFpYKrv6uBDoxD7xVCfje73aRm9BvpLgJRo+NUhTcT
         Z00NbawTXPUt3R4JIfIshBlzTsJp733HLQiKBCgQwoBwWZfms4i3olWFvQc55i6lfcKQ
         Lbow==
X-Forwarded-Encrypted: i=1; AL+hErEgPbeiUAdCYMRYFzumqqi9OoMMEcwTz/YqHThTtSmsHbTmyRx6JvC4vvAH70oGtV1RffwzLELlcrwB6q8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+xJKButZW4QZ7xO92ZxkiTzm7qU1nMOzhEESp5ACbyR4CK2fSU
	jF6z6nC2pmJeC9bDnKgafoDDWj00+ZDB7nTJxABW8SEA3IkoYMqvZquD7d5yb8SYNxg=
X-Gm-Gg: AZFdTZeNJFur0lA7AJGtwB5ReMZr3qQLZF7qwCNLyI+GQ6S1l4QwE93WMozzjritE3y
	AOpBW7dRcg7Puyhgdjr96KVV8EbGZFfUHbSxih9qQorx9fIJQHk6xQ7vjE2Da/3rfU1VcxRkaA+
	twPG10wV3Z54CHYPoPzo/G6awwguyIB2NW7jGA1wc4NP2lxXqQM9AszYeO2/1pHGCktQJZ7LO9Q
	MRSVpM0vRI5jifZilnl3Y07fw9PGgDeBXaEok4T7SbgyQV63d6mFoKgtiql73RXhuxoj9L6qK36
	CwM8A0KoXI/+hjpceQ1zHLtlEbe2GvlrMPNWpgu03MuIit9T5WxKFudaibxfcEKBrKr6tMByC9U
	LmbT+5eQtQ+RL8sL0fLmIVHFtQtC5Tw0yWBQrBwcgKnXI3oAEfer6uYR59NXbjzgCEk2IfkHLZG
	G+RMSFcW+Xvo0GWsDZcrRGsMHXaWhH82yyMQvAJ8b8hz+BvDGgCef3KTF881qqdNedc7GIQqzWs
	NKVFBcMvBr0rLjeehpSSZwzcgs1XTafX8cUIn0Ysj7t4WStA0/PEb7o3M6D8rCwg4cVXFSZYwla
	LJ64rOGpyiuz7wcnS4dQ/CfHF21gBMTOyfXpjn7z0DMxiBQ7jtb54YQK8Y6tNK1i+QnlW+BFCMV
	G5mtxexqmloEvTjbJCxMiG0j/NlOI04bSZQJR
X-Received: by 2002:a17:902:dac1:b0:2ef:f819:3aa1 with SMTP id d9443c01a7336-2f03f1f0a26mr46054785ad.56.1795195900424;
        Fri, 20 Nov 2026 09:31:40 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1482c3sm17173225ad.73.2026.11.20.09.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:31:40 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: Re: [PATCH v8 0/4] usb: gadget: f_tcm: fix infoleaks, sleep, and UAF in the BOT path
Date: Sat, 21 Nov 2026 02:31:34 +0900
Message-ID: <20261120173134.3286557-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Nov 18, 2026 at 09:40:01PM +0900, Yehyeong Lee wrote:
> Yehyeong Lee (4):
>   usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
>   usb: gadget: f_tcm: zero the CBW buffer the status path sends
>   usb: gadget: f_tcm: reject a short write data-out transfer
>   usb: gadget: f_tcm: clear the scatter list when reusing the BOT status
>     request

1/4 is in usb-linus as 69b3b657087f.  The other three are superseded by
v9:
  https://lore.kernel.org/all/20261120172829.3286180-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
