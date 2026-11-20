Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174929;
	b=MNj3clen2iUuFS5hymKtseaVfrvA0v+4Ggyj1aAQy14XnKsYbSBuC5EWRM6iWe1DyZti
	 ItqQTJxNae5HQcz0ziPNi3K6+WzjhpcW1EIcMC14d4PZ3zkhGhK+EZkth73DXTHrHjAEt
	 xKT5GRZM/HPBStiQsiw6ftrEUdVv8tjZzDOIdXUuTOUvonmtpzE++oybeiyfJMlyxcpyL
	 D9ZKz0Byflfvd0a141g5SPZtk/SsS1LN5ehNRV1ACObgmF7eReUyH/0frTm+VIrPTJsGl
	 cY/Dbu9/V9QI3YETeD7FrCVDAGfVz5v6umYjOKzW4ErUi5PguSuqzXqodfvkH8Jzqyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
	b=Nh+c/2QUhtg+IJ8yWTDRrJbucPJD+6Q4JOIG0v2ecgsOoPGwLbKpQ60HF91uQQH/84ni
	 pHrhkafBTgKP9hgYAdn7XFcgl95QnMzr/HZ691nRb9X/7F1yflSpHPcj5y6ZILCih8Tvb
	 RHv32FDNzdEbjAsfsE8flUFhgLZ+cDFnOPqrz/j1oOdZg82TEVXfnTUQkcFGxRkr9kPye
	 jZTqhCy4KQlajvRc9oFsKEIB0oFEKJVgEj/LMrYIHDeWas97gs+Vu3fCSYO8lQUrAERFu
	 kyvnDRL4mJy5Vv/R0xnOLQ4i2rIghICa+FiWQYkycY6ASrW+4mDEsWEBB1LEwYDet1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WFYq8toA;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0D3606A32A
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B0D3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WFYq8toA
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso444555a12.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174928; x=1795779728; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
        b=WFYq8toAzjU9exok8ixcfSZNb3P0glxTUSaEy8hOf+NhxldDGjaaUQwOSER1rPEBd8
         QVxRWO9De4zA8neTAaFV8QZiT6CAnxQnVr6liQRdNok4TCWdeBlKaEkLG3ptWSAugg4u
         J6AuIB/qiVgrTGjpZEW8i3D7di3Js9zoDxfdz2nwrbVhfh4PNrHGnQkB7Eeamo3vhoa7
         80LyErUdXC4vRCHTF/UoGbkFOo8+XCm2uq1wVbErarOv34E2c78I13V3iVYCGaqzN+m+
         37GLjgXK2Ak9gI89G6EZrdJ1guooUm2uK9BnOyaVlV5xYA1EvIRAu6ZoJsdwpCgoEvyt
         UTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174928; x=1795779728;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tM9naJv7UO6Voq+aBXlPWHG73U+ad6C+ZL6d3U3QEdw=;
        b=gzXTLRhb+1UIHwvPHsnUiyPKWnuBiI7Wo/QW84SENZ6fknI6S8VgjNDkB32lrXiUth
         BLu6tFqsedkEwpfj8+R4ixHz465c59yZL61qtpIwJMElVj4x+dXp6oakkPSATIbgdW/L
         jsd6eq262bx2uhAv62vU/xQyAtrv/Fc2gWMjfuI1NfjCTkFeXUZvXRZzp77VqbXQEWYj
         KhGnql/s7p2t6Ip/fQgE/7mE7q6InBu7W2BNqvf0XW8JENmEQI6ui2KrgtEsNk/93SRP
         HzYvq16y/JbWjvYxzHlXRc2a2v5QJYAHRLLnEv/GsvHJozt3J3M+kaXte5UL7W9owIxk
         IyuA==
X-Forwarded-Encrypted: i=1; AL+hErEIGzJrBuy+3YIkTqE3kXMAxF/C9AWG5EO0GzgQCLA8VPdurcY3uyeHAxBzK7zmXcscl3WLeNhvgQ8cTrw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8dwta91yTWR6aLJRbBt1XPixCBP/6RbvG521jnnjT7n/TtTY0/
	nqrn6bRaE9bhpl6Joosnx5cg4scpENRm4gKLxxLBBJgvXRuGLylbvP4dVxzYsGIyKzI=
X-Gm-Gg: AZFdTZfovb5W69dp08KoXIMMpN66mti+4MPyMrgk+I1YAPmLJjSaJig2Pv2/7cBohXj
	0t1IvlSzm1pduDP81ZXYOy0RyEDnlZpsSAWu/aztSl5XKsNDsi2S+1KMiPS3JfSpGZDy8dhBjwQ
	H7dG1s3HG284oKQHBWMtpuhjQHiZpXI6ihzzipSg0liNpdzeh8E8fbLGs+jEe2XyT2LDpfe0Nix
	FXHjaI3iHMJQhUJgfOuU4iBU4+DjRzuciUUWdyI9KPAR3FMzMIFh7z4stYmRnh85rE7xnmnXJvB
	lhG5ota+q6ubGO9ND8TQ4E4bTdHOy/WtfS6j+Ih2G/epAKC8+9duFEsA7YkADjSJjftNkpEv4fQ
	BYkPEdleBXQlNHWiPnlGs8OroPyR7g6O2P/3mYWVDRE598MIO/oL3o2WPczYW9LdN2gE0ue1zYF
	YdLtyKNL9V2kOlmeusZay55b0BsAFLpTIWkBMCVafQzUqIiUuJ4MDDmBVBEFe5FtwwsSPAYf/eR
	tV2xudQbgaAyQInYD6R1ZdeGZ8W6A4ksIpSkfXdiTJ9AARevSvt97So9iJW/s5W7Al368ed6a1o
	no0vKUfTILkRz7dNZkOY8RR1J8T72UI5y+jjkpETPaxcodjo7ajMOGm8HSuIxsQ+lpWgLA3rWK1
	OodRnLzWpppYnMU2Sdb+UKL4Pz5SjyykmR0fw
X-Received: by 2002:a17:90b:17cd:b0:3ad:25f6:1dd0 with SMTP id 98e67ed59e1d1-3b41c8fe29cmr2476643a91.11.1795174928635;
        Fri, 20 Nov 2026 03:42:08 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b42ab9c2dasm849879a91.1.2026.11.20.03.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:42:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: martin.petersen@oracle.com
Cc: michael.christie@oracle.com,
	himanshu.madhani@oracle.com,
	ddiss@suse.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_complete()
Date: Fri, 20 Nov 2026 20:42:03 +0900
Message-ID: <20261120114203.3072082-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
References: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2:
  https://lore.kernel.org/all/20260725165818.769963-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
