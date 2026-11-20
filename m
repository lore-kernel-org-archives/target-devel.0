Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174283;
	b=WcK7RbBxI6si1Xfb2FzkttK/gzrPY+DZDLMSIhSD40Mp8ebkBblbA97o4ReK8MXJ90xr
	 jrnjPLFVxBc5b1unzo9DHBUccq8Xohsz4nm37Be9zbQ8RAVt5ggV/XUzZ7Yey1LyH4HNA
	 JX9RtANRZwP3uaUdPLoKav/XFbpGpvDNlJ6nszxRofbqSD0CqPqdV1Z9uGxWZfWyiTT2m
	 wXi12EPuBnKTUA1EsS3THyD8pGIqpt4KYq0X0o42sxi5MC476eteUMqZepPKMSbLlkTYE
	 tYQ1TuwUx0FBN/dx1JeyyRafFrGhudY2SkyfjuSvf+7hucUO9FBrCMvas9m/3s1DD7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RX+856AUzmCTNUy6Uoa6YuVj+X3zQhsWSDJ5mJQKXuE=;
	b=MBcByeg9GjB7WJ1DIL3j/yqBSbDc4/Q/oESLGHWDlQfRHFtH+N4YADMLNdkBiGX0B2hn
	 NrvVVIMcwEpDtp6vOyauGW8qmDDd9ojdKDkWQITUVlKKCRiyeS7O75weincrqnqtpGpUV
	 Mi1C29JgE/PyV2nFLb+dbn67q1k5q8rd2Nwv8tu7J+lq1cmHyJfwTZGnrPS6BuwzOh1TN
	 /3jSUPmj3LA9MqXKWlGLULR6kgmJGXmGkL8bFdlQRoqC2hzUFviFEyQjzctVTwnbpGo7G
	 ZlFdzKysOFAVVXaJhNqy+kroklNxLxwJDMdGATebu183BIOzK3RpOWJuVm+k0OnoKIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d8Vxng05;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E5606A32A
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 448E5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d8Vxng05
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cde5a7d79b0so403088a12.2
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174281; x=1795779081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RX+856AUzmCTNUy6Uoa6YuVj+X3zQhsWSDJ5mJQKXuE=;
        b=d8Vxng05FQgd+fvSGYsdHS5kgqtkzPNIz459SZ0oYQW/AouySIMAngko5Z2WRDOonM
         Lbny+vFRNti8nv+xdvTzCkZ1RCHyMXDtMPygPkWmtWpX6jT0RMXqOstAkgeH3pvROnGD
         UOzmqYy7h1yPOzvakLnvQfPt80Gc4oay4wuNmhmMGl434SPvS1fXuIhlUy87tjuvpfSx
         e1k2ts6CiQ+sEujcdCLZsVk3CsG7Az7qLLWaROFPqBueMZU4f0G2pSZ1OOrrd76bSYOb
         Bzoo+nijHDZsii0L2lCJAu/xCKY6HB4t1T4Sn0CdqJ2EzyID6uHkek2ARQFrYLx9sq2P
         GCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174281; x=1795779081;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RX+856AUzmCTNUy6Uoa6YuVj+X3zQhsWSDJ5mJQKXuE=;
        b=mcnmGL8ygzqD5X1aQ5CJgAoNLFSnmBe5j8m6vHGRg7iPGywXfW1Qw3uvqMif6uMq0O
         8HqE706oebjGKGKDzhPYLXH+JHP3lqP0WwFPuH+KvPV90U3Of82VOqfWDT6dihcLIVZ4
         VU8vR7f7O+ctA+sPA6z3iC/TlM+LGoUyCbxHzXkU4jl0SS4Gl7CEu/w6Ay99HMGQ/XoI
         Vh7inDvQ134tF/wghfiVOrJKFDVeio5yryuXwkqIBJPqIigyLPGoWHDq046S9KKzUWZO
         Y1jxhm+3iIGfONHHyYXG+WpvD8VRhU9N+d29PkMXOJStK60lL+vA6G83GJXN0XFg9UYA
         +OOQ==
X-Forwarded-Encrypted: i=1; AL+hErFHyKRlk3qp4303gfMla4C/JhAjclDT4cO/vutps7Yt0b/4+TcTZYtp1vJX53AAe7WUuxbAC7EGnXxU5EQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ac8HIUbNaHRzrxX2yfVbQ620zkS3z5ljg7UvSpOniTQifj1Fb
	EQDbnoVHDlAQ0yTd/c/TeXuSDTTrPrXZ8Kwcfi5mGg4uQGN+AwG7v08XMJRf18Q207A=
X-Gm-Gg: AZFdTZduIMfJ9lBlofFtBAFx17Ge8h/MMg6C/2t897fTm0BL5L25IoQiO1XNWlajihL
	1krLAtZaqObeX1qt8Yh17I1YfjSqp7olRQfzT1RRvbVQFNpi+0evPF+FZvT943Vexc76YJNBu0f
	na59RIb1kQy2E6UjM4EL15BVGwf8Z4S3dzofEWH2XTFsM9y0ndvA1kiPLi2axYlzQHTBHBSgHBJ
	ORkCOWMw6eq9VA9RqrKKaQbRE3AdHQQCyTfmHLAfHMSSW6ANp6+vSKGzrSm8g84O8Hs/ihY2H0y
	nkgYVOUGzsKQQHAlxvfJqJnt2TQT6Y8ktMgWigPBPYMQ/HkAnUvlpMd5LRCkrYMJYcAkOrYISKH
	bVPWTix2okxZBuD9rHYAoICLJJ1T8GyLNjfJnETvZ2KRj18dXRk9xr6pzsuh1mIJwSwGZM+limj
	WdGneh65evBpT95tkbLAFyNYI5jsoFc4s2Q3ElkAl3OUWEHBMd4ryrRl3yZYhWTjk3lhhZYjWmY
	8uMOfFRC7dHk5HcjTKJhCsT/Ic4fseGK9SfrQSI4rKeliR+0dXdG11Hh+pGdSK8VvTPnytYUs96
	XXCM+6UwS2lHY4pNCh7tw1RKqG/+bYJJ+Ij1r/9DOFAh7HQP3Vv2hjy8smKMDSVfWAu66UbFGOk
	rUbAnL5RxVdngC/sEX2u87Yn07Hst0mGXTIBS
X-Received: by 2002:a17:90b:3f10:b0:3b3:b8f1:f152 with SMTP id 98e67ed59e1d1-3b41c7e1414mr2197961a91.2.1795174281280;
        Fri, 20 Nov 2026 03:31:21 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad47091sm4104731a91.10.2026.11.20.03.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:31:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	linux-usb@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Fri, 20 Nov 2026 20:31:12 +0900
Message-ID: <20261120113112.3060035-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026112028-starless-aching-bdfd@gregkh>
References: <20261013043951.2534225-1-yhlee@isslab.korea.ac.kr> <2026112028-starless-aching-bdfd@gregkh>
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

On Fri, Nov 20, 2026 at 12:09:52PM +0100, Greg KH wrote:
> > -	if (req->status) {
> > -		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
> > +	/* a short data-out left the buffer unwritten; don't commit stale data */
> > +	if (req->status || req->actual != req->length) {
> > +		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
> > +
> > +		if (!req->status)
> > +			cmd->flags |= USBG_CMD_OUT_SHORT;
> > +
> > +		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
> > +				    __func__, cmd->state);
>
> Why is this needed?  And __func__ is never needed for dev_() calls.

It's not needed, I'll drop it.

This is an old version, the current one is patch 3/4 of v8:
  https://lore.kernel.org/all/20261118124005.2428068-4-yhlee@isslab.korea.ac.kr/
It has the same change, I'll fix it there in v9.

Best regards,
Yehyeong Lee
