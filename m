Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186914;
	b=skfdOblXwzIBzcEU7ujVRFk5T6aru+0WBE6hdf2g6v6lePJJZDqzOrQd3VyvczRmilCO
	 ocvXs8UhpzydkYcHNEW1H8rV6dMetKhJLYRgYzcSA4uEWBPmgQD9GAyG1gZuVZA3lNXsr
	 eJMUOtuTrXJbHchX2MdL7VMYW4hqu8M65XzU56yai39rk/gYjmpUgk7FjNBJzJF1e7z1p
	 s4f+YoA6Fhr9YWOtq949doOYzLma0R6aDivn0dt8XMJlLLD0tWnoB7xrecn0dan0pksB0
	 mFrDjUvncbx3085Q70JrGk2ZzR7Pn2RorngwC8ZkWYe9hRZUcp58mmJBMCPLNz5BVAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jJEKPitTmspiZgBtv0fmRLCqGp7B3w2kyTO0lmVWhjs=;
	b=r6O3OxrcD2h4L223AgD39mK3ZAtIfgxxdiQOA7kPRW+WcQGCQda5g/Xc4LxKI+VFNF4X
	 XIdQC/nYS10eS5Qrjd2KTJgLUe1kcYjv7+XsfDsvIvO3Ed3zr0ZuDE/Y0ACRvWvm6/XYh
	 3wNX1Dz+KUoKwBot2LzlwME7MlCZQswO8lXE8DeIdYxTBRnQ65Xn+fP7GN9Uz10CtOQtL
	 GCUuGZT9G8k5MijyhmXo7geKce1AuHPUiqZiR6zrSWA2rehBJpAtykJM0l7MHPY6GA5Kz
	 Gnu6/Kdf1eNEhVlP9sPEOo/CULjHzr+rRweVz9KIfC2g10XzeV0+HehsWAv96UH3cgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U4s8W1Jm;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66F8606A82A
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E66F8606A82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U4s8W1Jm
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso613615a91.2
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186913; x=1795791713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jJEKPitTmspiZgBtv0fmRLCqGp7B3w2kyTO0lmVWhjs=;
        b=U4s8W1Jm3lFPfs5+wrNBLswuiF5CaYpfjnOxkfOInBFakmkhpYm0C9r/dy1VhXq1MO
         wdrWuDs/Mi96lfOYZFvrI4u1zIz5qwvc3TxAqyGS1wMcYe4XMvV4WIi00Z1lW/XLLn0J
         4t53eku5S4V0IDuURxyQofa7YrieQ8NQ+1mX/vKJtkpqaZXM31QTx25qfHENw7SHniuj
         7sUwMxR0LiudslXaIdockcUbtvPmsafW5FTn3C+pOSoPD3OTrZXcg0WQ7SCuPNl0qT7c
         B2Tr9bxR0ui+0N87wRF1bOsGkrYI1orBRgfj11SQX2kbWZsyEOTiTsxA1PogtHPpGBJK
         Uhvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186913; x=1795791713;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jJEKPitTmspiZgBtv0fmRLCqGp7B3w2kyTO0lmVWhjs=;
        b=mBX2LCLh0C6ksZJ0UR+NDC6amDeCRG1oQNMWFRb8x3jWks+dAiBnyWIjfMzUyqZ0g3
         +eyRdDsmk2uVoSlI5XRKtMz4+63oC6jzN8eA2SZELdj5knvSRjiP8zk9OCaZb6cfanLo
         CK9b35SIMJENtzTQPAEntyUvEM29Q96lZUEjEYpwGLQQ3ntXU06DqgOzeKQvmnMDTFmW
         PVNfOi6Y9axqHLRmDjjLfApcAER3EJglcpfnIN3hDN3/nVXgu3cZrgYmp//qxMFMdqv+
         QurmCcya3/Gs3UOp7AlbV3/ae0edMZJaQU+KQLNC2ivQAZnonsWkHM+zMTe4EXtskHE7
         aX9g==
X-Forwarded-Encrypted: i=1; AL+hErE9qHBpg/xfA0muPLQ7i9JU7b+HgaioWgnp+fmHmVraAeuFVzRx3LTPmPq2CWd1P4yZUyUaUhvjwX42iBA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/TFt2YGATNrt+kVw8fiMLIsHMGdd/wRCgoN65amzUhe80KOEVf
	scUzT9rxBp2OjseYZitCO0RnXWuTRBB4u65OyCgzzLX0SpgGTyZOcpd0qoy4OuC7Uss=
X-Gm-Gg: AZFdTZcYDExvU+T9LzjVrqZUeWXxpwo+iyGlluQH4JuNa0kV5Y5Z4WL+nP1Qzy7HF/U
	yayJh1ybjBvOMIrGfMJqIKQvtzsvM9nEQk5V/qZ2pISnlpx23aBIUE4jalE2+M761SNnlbWNYz0
	4ca76EiUhJ+F+44+F34BPCuUtbHIH7siabXozstniOE1qd1NajJbtuLG0BsRpqRafxxSI49/cmB
	rWWHbIfQh9t2XqafrdcI39Ca3WjHWKQLqFbw5yOR3qt7G2pbbAKmh+XwiZKOnPMiH11um2l+0cV
	NxN+5eDydVF7yuE9H3BRoxHJKkO3kI+PERmcyv0ZRfwwpyDp2brjpDBCMN7Lmr4FOUHlvrUIMtp
	AAu/ILC+UJFREwi2y6Dqx6rqig87yDwXMt3ilf6vY1Ot7sqJwdtnVANIJNFTHUtBApzp5TKYMEV
	b87JFLaYpbTiaDxR1w/L9N5F9oZarcUevyctcfLyN3vPAp6n9j0oAafIGCxSm1+crX3gdny1zuu
	USNWzUej9DNSQiSxVGkiEn6e/05gj5tZDllq9qO7k6cPBU7vP7uyUNimSMQAUVX5qObiURlHxP+
	9afKNMsLRvcxgcfngISVwqDG1f/2biyVWDKomu0sysIytRYdBKjm+rl6Y+6ePyY6WSXAFQ0laCV
	oKcKWl6t8NDy77+wM1abqvOwS+sVJU45EWOlQ
X-Received: by 2002:a17:90b:3d4d:b0:3b4:691:d073 with SMTP id 98e67ed59e1d1-3b41c95b0c2mr3210879a91.55.1795186913056;
        Fri, 20 Nov 2026 07:01:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm4733348a91.17.2026.11.20.07.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:52 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] usb: gadget: f_tcm: fix a short write infoleak and a completion-path sleep
Date: Sat, 21 Nov 2026 00:01:48 +0900
Message-ID: <20261120150148.3128435-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
References: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Oct 13, 2026 at 03:21:27PM +0900, Yehyeong Lee wrote:
> Two fixes in the f_tcm BOT completion path, both reachable from a remote
> USB host.

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
