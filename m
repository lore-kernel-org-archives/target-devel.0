Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186908;
	b=wxUwPtPP+K1ZIWhp6d7gEJ/q777VIuBt7UijJE1R0Va3po43SYr3LnuiD9ay1FIpkRxm
	 VCvIl58H6JIkGOGanPcBNkrfF68lYhZA25h/sKQwqo+U88gRslX0eu2xmbr3llQY0l7r1
	 zCgVfKGSAYO7rK0YHW3GxFOHAuNr2VUn9oydvZpr/bAzyTpacwUSXXKtP2nUP9a35PLBt
	 QYo+xPWY/Y69D9EjGRDL80OVYvdcRsByrNQQvK02mjba/smHrFzsrc7ecJ1lkUHov6xFY
	 HUBtQh0GhcwuZRrGOA2PQd2u90GbeSKvqoL4+XGVE8Q+roAmNCrGdRvcv1iADEBTmxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186908;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UeVDu3TiM5Vz6KYQ4zy5qxzuulWda2oFHtHtn3T8jvk=;
	b=3/xmSnAuAF1n5TDjmNnvk23nXanI03teFJl1+iGHWe11u+HgQgQsIAmNOBencktiQ/Ql
	 xHlHKrkKcxx9wp6ZnO18J/rJAHVo1YPGWwIugUfV0gvjU1Oza5TRoumaWZryTE+bPGcPI
	 OwcTnU+WGqW/zFPYNj1eJjAKiz3RGBu3gop7WV1mo37+M5AaeFMg+TuMm8Sta3VwZl74y
	 5074cFNUsHrPcMaNcUepjWpyzYfd2iGeyOJ1BcrEf6MiC2hIdd2FzQM+EYtuvf7Vu/gwR
	 v24mXCpBhThk0Aj43egsxbfAqckSdSBMXQJbDonENqo9YiKFFI+JqRfwdQNLQlnnUUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LISZnTJy;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57500606A336
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57500606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LISZnTJy
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so572407a91.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186908; x=1795791708; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UeVDu3TiM5Vz6KYQ4zy5qxzuulWda2oFHtHtn3T8jvk=;
        b=LISZnTJyqLv3LTB7PkrPUThBJeQR0BHqn7qD9E1Ag9PKjSJtfRbiFz+iBJZzj7yl/Z
         xFogTX96DPjXvEtX6aUrQTNh4WHnrUn/h183GHEuiJ0e7I4LdJwVx+nQaePoov26GafG
         KNc5N4QnmjcaloWXmOKn0b5p6n5AoLSFanJDrN61xFBf+yTBC9wyv+T2pXmL4qh5j2rT
         ecK19Bu+Y18SZepHrGQgR5cah9nhN61Pk82D66CRbZpTvCN1d2f7HWzqyUL2B+hVcHTc
         5w0tA9Tu6DuOg6Z13j5E5t6mP9hbVB/F6Scfb9l6XdKeuYeIcYbkzh/foD2hx5Jhfx81
         cPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186908; x=1795791708;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UeVDu3TiM5Vz6KYQ4zy5qxzuulWda2oFHtHtn3T8jvk=;
        b=1xqN/rNPpfJzS0DKbSmwiVZcI6Walu+8zVhA32X3etzY77qn+0y1mBeYKAj8XvLylF
         PWepO38owj1fQ2rPUPd7mKY9jZUXF47GxdEVP7xMG4MFtjXnrIb62VHLfnbJJBpo2jAr
         LtWoIL+EE4E0alXoq9cKa6GnoOY0Yy9Qy8iW+v6W2utFPif74w3+mAzLlgPcMD5/8rnW
         HOgHRR8rKqVQifnD2B80VVrGjyxMuswB4pMTNg+h9jc6Y1xM+1p9B/mcwu4CiRLQEI4t
         4R5wcUsFHQYdqL62qXiLLDz26Th4xoS5st0ncJf6zkC+Ee0ul3pvPIcix46iGhGEluGw
         BCKg==
X-Forwarded-Encrypted: i=1; AL+hErEPyJ8v6gkJCPbO+Vh2se990wPyM0SgPVzu0oXRSWwNmbAmc2hjV3f/JejXr4qK9OKQE+trR+d7HO/4uJA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8HK+SezRnNAKdw3g6NBfscXiZen4nMms7oFqhfYkK/hm0qZh23
	5YSDwY0xK4eGJRp72Sr96txfLDAfaCmiAQ7sExf6DOz/lX6g3rJ7kCQSOjLUkDQWBJU=
X-Gm-Gg: AZFdTZchYBsZcnbgXqnaBkb3UhWUpE/Buja3l88o53fc/mSrOlJFEl51yGKxWstO7vD
	fuwrBw1zdQDLEcCkXDx2J5u1FEb6y9ysbapKYyk+5yPMh1NYTVG4yiosNEZSfqTkC1bCq6kF0Ge
	MqkqYhtBwCbvEHvMcRZTFb2JMb+SHC0G7eLbbFkxJTGPTYbADhD8nNSN5Aj7hAvSrzrL2p2dYpc
	lHExX95S8JvaBXFb9TbzZfnoIteOUaoTrAuawUDUdi+MnclDqYwr294vmEoKDgVATuy5jc4QKO2
	o9Aqn1BJFrsPCkppsOK93wQRPoOXVe6xCOXzeStJMLU+B+yzlqIPYnRNP6bNzaa1trvgTDQuuJ/
	wYU6WxUPyaSxVlIW78TgSHZYLjzUeiKRgA94W8WY/5VzmHoR8AQmBKdtOT9imroiA96bauP99EA
	BN87cPMIToI9NhLy2yTUl+ZNNMxBK/y5zAYPq/MG+2qsZrE+uYNn/ftMQ+R4MKr7WZJmjmK4XDz
	nY3GyvX0bHvCFi5ECHswRZv/50c9xUepL1cxriWuyVt0PM3BxCqpkEVXnPz2eHEREOyeMeOYRRv
	Q5eaKCJgianQ8yyMTuGeXsakg1OnWZpX1NXsdBx/D5lTMGf3AR/9cqel1lIejvzR8KAeZ6rizcN
	LcNrOftnmMhNSu9/O9IQxHJnkmcKvZyooSc3n
X-Received: by 2002:a17:90b:4c4e:b0:3b4:d22:85fa with SMTP id 98e67ed59e1d1-3b41c98a150mr2948394a91.14.1795186907561;
        Fri, 20 Nov 2026 07:01:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b409330ae8sm7543261a91.7.2026.11.20.07.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:47 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Sat, 21 Nov 2026 00:01:42 +0900
Message-ID: <20261120150142.3128421-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
References: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Oct 13, 2026 at 10:54:16AM +0900, Yehyeong Lee wrote:
> usbg_data_write_cmpl() commits the WRITE buffer to the backend as soon as
> the OUT request completes successfully, looking only at req->status and
> never at req->actual.  A host that declares an 8192-byte WRITE but ends the
> data-out after 4096 bytes still reaches target_execute_cmd() with the full
> length.

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
