Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005698;
	b=diMSi9e7bd3dGOutq/bNAu4nPqTsSr5WESsSCblaWTaDiiQiuaipqIWtjzzSXwIzzK/k
	 upTq05ohOw7uhoVG03kYdWblQQdZ6i3vAHZmi5A/Z3O8hIXmWxkeVfBCaxWv8o3OQ6kGN
	 HcU4LWIkXMgSfqj+rCuqQxDOhuGM+B6FZuUXSzV0HGEUtHUmfk82FsQlKEv6In9DaqgQ8
	 fzZgDgDHCRR8YuEkbbieeA+QzqvRRwxoW3vkPrAyd+CfrnqpZtoZ2LvQvq3NOlVVQVcwJ
	 nERDDjdWrEeHawodPuMFcaDXWTIlp/dBbnpRfpp4k4LS+4LmQ0d09Tv6qRUDixYDeWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
	b=RyVYmUC3rKBI1qLUjIOHQni9SCqHy3jOPFurpfQhsj+2tbGl0FFhhetgM2E/dSsn1VvM
	 ysGd0Ql8Qqo2OZdhIzlBY1L6G98F6fd9pLrotJK0YG/ssdryGT55ofwD375J7A64A6aJd
	 q0WDsSTIIoBpX/D0vSKZGvc0+deK4mtdiQCS1KnKvY1lBbq5hIo2sdqHcRMxyqvEg/DmN
	 CAH9WTahtoEiJwKiRmH3HoE5PtTvB2KLgxgSqZD/t5axcdWuq7b7QV4Wn6xZhmFwdyUpA
	 lFvj301Nrp3L9rJn+16mowB7J1FxlC0AoUp/1mc6S99Uz97UwrPOPTnwDD9vho0KcNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="WhBlZ/yZ";
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB660A2614
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7AB660A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WhBlZ/yZ
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2efddf749e5so9641475ad.1
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005697; x=1795610497; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=WhBlZ/yZxXcYb7YarQ2nn7UczKWtdcgeVeO+6ldy4EOoIJYb3YZaZjC095fV/8pbmq
         HpSqbZts9dPVoEn09rFZQjsDt+8hRqjfo4Kud5wn2XWfdbl+8FfVmf3C/LhFUy4DfGfw
         PYuafEvTsrjWCHjhNXlROmzP3yATggGmR1Z90hI4dbi70UxIvZvY4kNp+9YicdHv0lcW
         kS6ZG1VuO3rip22fP9h4OXQFVsfM4UjzP+C4NosqMqpKRy1xwFchvF/ijdHsTp8u3/1V
         cylXYxcVXggW4BbND0xySCXoCZvrVe8FBZIo7Eur1e5grb1wtbxfD6Q/6ERJbJuPa1uQ
         cbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005697; x=1795610497;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=bkbg4Tlv3KJ/3BzgnrkwpP+wzNqZcj5d98xpcxmHc8jcNkY7xchIHSzsTlMV1lsSTY
         s9hTxYFg6QEOoUUB1+SQ73gsKpE3YvmE4KLkTGkD71XXzahSaA4POoo4JJerYXxx1dPu
         g7CDlvliJPneapu4+SiUkq2LlDdV+dnN++STU1zPpTQkwNqoIN3Dn6ikJm7LQmBUAcjs
         Js65IHBGbIC56BP7620m165nFrOoDXT0yiSHpJ6rFm9KDiDwAqe2+w/jZdOmresR6XBl
         lfKGMXXfgwUXTXTTrPmn28ksPfenDhxQvOVw/lE3YCDnTjcurx1SFZEwFA4/f3/JnoLq
         kG5g==
X-Forwarded-Encrypted: i=1; AL+hErHEc/ryGrsMY4ZXo+kL1fLs9kcxDN0Kw28hV7uNDDxgLGzjBoVa74z0mtaLsno69zL/nkx4grecIi5swbE=@vger.kernel.org
X-Gm-Message-State: APuU4Z98FDX4/atigBR1/a013fFxHzQ3IJxsWR/X1BZy11Wfhze/P3aq
	RCjaFN5XM3SbjePgChu3h+kB3vwSscrYbXa1E6HWe71CVPgZ2enINxSb1KhP0PKvB+c=
X-Gm-Gg: AZFdTZcHPCRkMUCVKSefmxqGrKTOrp0zPu8vuwCmPoCKGkQvHqjhrmfiA5pOiFjvBFV
	FWtelSlJ8hL4wSo3/5ngo3ooPUe6ubCs1FMUOdMu8HV4Y6ZEPx2AHuQPL2MeVeTvMKMMk2wRO0w
	3506sl2Uw8Gk2zg89JYxe/gZgLtYwHMwOITll6qT/jYp9tZWfdfMem/uPOZtX1Mu5LsjmbbmV87
	sUSAkGBF2UrSWmYb3jEdRSvgZZDMKFEKTF2dW8m+YC1ONcEVCCmGDMlAN+mYHdWLpN7JAkihSaA
	K47CNuzzLMsuxUDDDuU/Mhw1YvAg4/KgWlvR4PlGYVqdqwigmqhw+XA0flHKizENV08qqfvmJC4
	cwaUMSPPSf0f5dqO9sgkb0Qh4Hct0rwK5lCyGw70HT6wQKCijqVUt9cMszuXeepqjtKXJO5Wvm+
	D6cnTBzy9Yly+wyrCxUk39JTFRIin8mHNLhisUD84bjhT01qfglFS/N9tM7n3JazYSYh0hbtXSA
	PLDTWG2NEZXSnltMoWvBMARWudwXUO9yGg848cJcYxCdHmzCt56dOfkaFTCsXBJ+KUH/YKwmaS/
	cj+B8G2Uy616uQwWkSYGapdLIqoPAm4LTQnqsaaoKV07XxwnmdO5M2NR8tDYAxCr57kM0/9fgbC
	eYmpN3oq6JshdO7a16QpiSn1lSAakAtBpyIRlhw==
X-Received: by 2002:a17:903:4b4f:b0:2e5:41d6:178c with SMTP id d9443c01a7336-2eff754479emr17857265ad.33.1795005697064;
        Wed, 18 Nov 2026 04:41:37 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff611630asm12923485ad.17.2026.11.18.04.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:41:36 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] usb: gadget: f_tcm: fix infoleak, sleep, and UAF in the BOT completion path
Date: Wed, 18 Nov 2026 21:41:25 +0900
Message-ID: <20261118124125.2428233-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
References: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
