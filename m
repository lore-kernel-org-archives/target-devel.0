Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794950080;
	b=XLhFi6X2782xkO6YBaBRuxegzpQ2xM7CgnRl6Hvt+Nd006kncvNU6ZYSSCG013356Ftw
	 hCLOuFTZIWotPoVE2T5XfCtOz+MHEdBg017O8E24kx8Z1qJmfUnIapexNEmDNDbOnoa0x
	 U3tsJcjvgWGIMbqo8VzH+9njqZn2HYZ7T+smfS1WsC3pD4JiUpToe+83OICj5G9j6KHxA
	 fquPcRG+qtepSw7pKJAiMXaS4qfaPCSDseCeGQ0tZGjxXtqHoRcq/Hps7ja9ZmgdXKsGC
	 am/7sli2nSj3gK1PHu74/UhBUbBEKCmWvHh5potnlhScHAnvrzoQmxT+zaRNG0fvJBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794950080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
	b=0zDBve+FsCkV/bHKmrEXxu14hFHtayETROWMdrTmYOkl7JAkx+U2vWAKcQBw4Yv/+v1Z
	 t7+fpbwkRTnq+/L7lsSeepAjac6hMexTRqF+5Tu7a8aL9YqNQ2Bo8A+h82hhGvF15AXPe
	 QxRXkEo8dmODrp1P5DIFj3YmpNUVel9/XrKpfFz/dLlElkZXPNxpWRtezttcfxS9E/xQf
	 W1YIg1LYHLifdBLwe5EDFe5HerJuyVDjh+YXnxBI9Aw2g9adaGJpJNLpJe93o/kNuZ87t
	 o8nA/Z+uHtjFBpUAqaOn91TOzhIxaG+JIk2FJ4V5omHLEZkCL2cbN25tHZM/mJbNXTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=krYuILsW;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68059606A32A
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 21:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68059606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=krYuILsW
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b179528d56so90907a91.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794950080; x=1795554880; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
        b=krYuILsWHqhA5Gmq9FY8UN0IZeD26nP56MxavkHr6MCBWjGrWmjBYCd9Za4K6QPFHq
         VdVPj4+g5OMw3YwQVoJTC17H8r8wtxnoNxb5g8/JF8RQWj+Kfq1hwLjq88OJwjeSyS/t
         nskWICf1Om/CYkF9tortc/3/c+HAFHyjtUEbSxwyxXBE2CnanaEN4BOgvNWtjGH2tFHB
         085tHqjKWG++JuwSoX0S7e67Jc0PShzi9i1w8RSYwOhyCKBHau5WhouqdM5BFgDJSm/W
         4ySxJE0Xd+66TWbiTgQ3wcCxAnwWrpxCW2ESUSBvAX5y2D36oX7Qwl9FY2oszoaVugCe
         tqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950080; x=1795554880;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gOmWnIVUUMx6YsAjuSSvOratSZLICH45prFU4/tE+Tk=;
        b=QPdR2lvTUnwK4+vSCccfhmjGRMB8Z00rSt7ecpXWMniv9qF/MpzeorHOcnbmffx1Ch
         bRhNQN6s2dVbRJpz9hTSS70CYCDPVoHeTqQYYwmSQUVXsOngDHhCtMBISKdPJzoI5TjT
         OzlvxACuXkYYgwk+wVONxb2pP+wQ/4iQHi7iBqpVcoVgjbRwh7Uj5rl+4/FzakusdAUV
         pQS6muX1kT0fo09jMqo0EHyAaoFcFaxW7m8xf8w0l2fRES8QrgnJX8EXk39sIzRiuVIU
         awbEg5UltX0P7ZJ0pfFVkR4XhEXeeIrPOa4Bv1vi/q7JkhqANGWEH11puP9r+ixBmNZu
         CE2A==
X-Forwarded-Encrypted: i=1; AL+hErGmhXSEt/HggL8rEGBeNcTN5ZjuCEG1bds1GVzq6jGjyLG5SmIwLaMgyx8CxIfoGyOfFxbWEaVVDl1/N/s=@vger.kernel.org
X-Gm-Message-State: APuU4Z9RGVI0Lw5vExFxuv2UtF2I9CJhpPzBj2Y2wVbyl8v2tdQ+hzZw
	ppGy2y8mLhnWyLdLzx2XmnqeR/aBQrh4lcODKRP4hm5Yeqj139u5hAi/8tyYsaVHdUo=
X-Gm-Gg: AZFdTZeW0U5InC4YY7xfP1yz6usFbd4ItuiP7qTrpUDR3dPYKyJBvkYqUCERhh+DZWh
	Md4B4nhgjkpLZhw2z6lJRQ8L3UGrgGgxSsheSt1A7UX62DfLs4GnUJ10EllPhTI3SlunODiVajj
	pFiJR21tBpiEEawIF43GDf0/PK25BEUee41EiZ6qAFam393CstjiJh28ZT4FaxvqJwY3fAgAKBN
	TR5Tg/JhSt4RROpGyj9VPQKj/B/IE8y1aJGrbgak86ll0NoZ/kLziIdyOCgLoShMsNsU2tBEtSd
	OwXRpXI9raKkC/r/+YH9wwwtarR16ACjIV91pkyuQMjBiFzQfw9yXuRJx2vZQ7tnEOoZLCf41kt
	jOIifrMXOAUempUsnbfZQ3YgHPcb70YsnjtFdR809MEK4WZpDqYzxU5YllzMcq2gKq3Ezrx2eRj
	uUvjC1I9+n0SlHWDNtUy4MfxJShGOVsej8ZUTDn7xH6FaNm0hns+tKidyEeRcC7Aotxfk7oUpJZ
	vvFOzrHj6GMigBjT2hpnyqOsGWsxRzRVCV8U2M87Sww7GuJn9zdVNggt0SatKUWSDWNMukvodhC
	+n9zTASlxTME+tmM8bJlU0F3UzfbS58KE3Ij6FwCXloZl5jfoparX4AocNZ7Xpg3B3HgXYkexVZ
	RD0kv6x8XNvqdSl8d/vVnwlq/JrlIJztaF95/4vyV7ARi9y1tK4dFDifs27s=
X-Received: by 2002:a17:90b:2b4b:b0:3b3:be94:8dd9 with SMTP id 98e67ed59e1d1-3b3d07b923dmr540431a91.27.1794950079690;
        Tue, 17 Nov 2026 13:14:39 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac2b5ec6sm5772336a91.10.2026.11.17.13.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:14:39 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Wed, 18 Nov 2026 06:14:31 +0900
Message-ID: <20261117211431.2132978-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
References: <20261117114920.1955697-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261117211346.2132827-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
