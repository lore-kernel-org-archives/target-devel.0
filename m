Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965068;
	b=noccJX4s2fGpEilT9juFL0RhYZBZPfnL1ijC7Uy6nV4Udr0ij4AJOpo5vrmLiDJkNXoT
	 qtxjHmVlgRuSLREGSXSZNl3sfMt5RuFrXxr13MHBfCNV9vtBPp+BDPiNuqGDDACEqe5wg
	 3qLOl5EJ0VWhE046IdJFvkO5nS/yche3TAZN1nyomwFK9LpVO1hnyo0rCXhTfdltNLzSt
	 wpE5BrPcRWaUma2g8RcUZ26CT6J1o0L/RcaqYosMSY/mB+tG2EGKjLOozQMuov9umrPtI
	 jbgc7tzp8iz8DGD42197oSgssSslYGTQBEV/By4EcT+DnQc3tV29HyhTLRk/AVot6gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
	b=5tKwI6eeiOLpxxtp75aSKdwAUW90hMPVCtMatVIqzUiCP18fJBeYmtJb0E6AhroIf/wX
	 B6xzfSQZ20zgX5TMoq2a1Ckb5BWv692UR5RpUrUhoAWNZk7M+PaLcmHAVGCyXg10Tz2g1
	 ehAK5hKTgRsAsK36nj0ZjPv1lDJ8nTig6GNIpfF1KGRunkxbBhrYjn3JqjhK8+FuuYEtH
	 nSDsaBgP04Df8YlggGkDv/BOF2pPTP1P586j9xaB+A9XM6JxkuPiXxxIBniuEf/s0mFIG
	 FB0p6yhSTVkfzbceO09xkTp5MZpdsz5mgFYd8QJylQWfgnSLHAlIZLj/izg46h4wncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e0rnDNCC;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B4606A33D
	for <target-devel@vger.kernel.org>; Fri,  6 Nov 2026 11:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF8B4606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e0rnDNCC
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a8cc11ac42so524486c88.0
        for <target-devel@vger.kernel.org>; Fri, 06 Nov 2026 03:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793965067; x=1794569867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
        b=e0rnDNCCP/vEzSNMrsvM7E2F7XnN79sZ4lA7f2scoMSld3YqrX2kvu7bGUzammNRwk
         FZ2qB79S8KuD5vM3UVIrU6cd+wdYWfzLE+/ealF8EMr6U1Lw/X3ebsPL4vQOmuvFObpC
         9hxf3QdT6lK59b4jvXcEa+KdEi7CkXag2rYcLs6dwhebdkdII+xVQN/yXq2EHh9dAUja
         Ll/iHDCa5c5E91jsTTV6OGcI8ziKHFmMHDlrIjp4CjLFur6OvmR8kgkdNeuRScRxa3Wr
         NLF9FjDs4hp68IdIdH0/PD61Emgy8bhx5wosAPos6d4snA2+2aB7w0Lkp3psUMeMIU7o
         y6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793965067; x=1794569867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nk/cwVUI+HhtrpE9+By8yGGW1zgCdHKuqXC1z6SrQpw=;
        b=jzqnjkqsetvDyh/qC4VxisYEAHhzmCKxqkWcEHZY45F8AmklJ0i0EF8O6AUcbaoXFa
         5n6y8rmcZJe5Skvn35E5OtcNKG9jtynO1w52JRLHe6XOGJPMZuPIL/MvDYP46zLioXiz
         mNMdIJX3qH1vtZFOhfRgrhYvpOltAtbowxc348dBdra9M0+6Bmoqzx3bpk7VEcge+tZh
         D4hUFJ4kQGBozhRmJFLyXrbJknTDoPWA83igC7t0DEkrRbb6y7qMxXITmNH4gAbt7z4x
         3jPMNsm5ICPj4dCMK1bvQGZuM0lskNfeCd4W3o1zcniql2T8Pgn+OMvz4k/WhbZo0zlA
         1DLw==
X-Gm-Message-State: APuU4Z/Fd+rOzhH3XZP13jFNk04vT6gSkq7D164+/lN2+Q4hW0krC8PT
	4WP6+G4Zk04IxTTtHuxbfydMCIeTKKlPqXRh72SMCH/ZOPeiPWccizuJFQ41Lu6LA0p4bpGQnv/
	COk+VsMg=
X-Gm-Gg: AYBFou1mlGgmDcfwrfMX8uCaU9XIJBk6dQTMYYlZOB4FZK3ZOtCR/iOpLZ9t3jRXmJq
	j9mKEN/siahho9gVxe7HEYS5dP+Nu0txzic/T0+ki3aEbvv0Fi1JGRwDpg47DTODBAZ+f3bY1RH
	rgAom347V7RhrbUY7bArqiuFpjJF2poiTDVp0xR0mAZlr+eKbufnRaMMz0J3OtCjbLf29CQr2Wt
	h0DboADy8c2TLESUoDELA3jPM++0PV616sVcDcbXsYTEVk4cyXRJnck6uKtEM//ABe2QsxRcNGL
	B8UgjDxGmWTV1ii/quM84YJMr758nldSOaszTy5L9FFAI7jtl1C3ZemwqzFkrSi7w84j/XC/D9a
	GY0gcBgQMhljHIeKJjanAmA3pXFkAhHqbZnccA2e/bAxj1fG//06bGxy84TLuELaieQJtaSeIpu
	mVz+vlOLA3+lCcUVz8QxDw+EUyk4qKn0/gOAv1K+h9Nkd5Vk6JBCMooZnwPvZwcc2F6Y5rrvnpe
	Yr1Ez4j7h1WK/REppvb7SmotAr0Uvh62T1xtq7PPX1Rkv9K4ADm4CtF/XysWPfIKVsm/9H3+SZx
	FIyUMRTtZCAMJ25wcK8cMV6P12i2KNsOGfAOyKy9mTve/hPbxq/zJr/4dyNJhglK6SSpXQ54pc/
	Rq4i1IzkRtSRm+mKJsUSvvvcHdzXk/8eoerhxMQ==
X-Received: by 2002:a05:7022:7f04:b0:1a9:cad6:5b58 with SMTP id a92af1059eb24-1b25d3650f3mr2994163c88.39.1793965066505;
        Fri, 06 Nov 2026 03:37:46 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:7bac:856c:1494:b5cd])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e261962sm8107687c88.0.2026.11.06.03.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 03:37:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] IB/isert: fix the device removal use-after-free
Date: Fri,  6 Nov 2026 20:37:38 +0900
Message-ID: <20261106113738.2063585-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104142043.GG478286@unreal>
References: <20261104142043.GG478286@unreal>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Leon,

Sorry for the flood of versions. I should have waited for review instead
of reposting every time the bot flagged something. I'll stop here and
won't send another version unless someone asks for one.

For what it's worth, each version was tested on soft-RoCE with KASAN,
racing device removal against connect, login and teardown. I don't have
iSER hardware, so none of it has run on a real HCA.

If it helps, I can send 1/6 and 2/6 on their own, without the stable
tag, and leave the rest until someone can test it on hardware. If you'd
rather drop the series, that's fine too.

Best regards,
Yehyeong Lee
