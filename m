Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174452;
	b=KfyflePPRjdm75EDDBsck40IcVbO6y06jqGb/hJTxzW2xKRgmgrE7kakOlJzEWEVKdjm
	 YZeHjwUDL3n8zSFPCDe9vKnwmcqgw0OU9dffxP02TfYCYYZyFhm/gmwO0xUVtXxQFv6rt
	 NZfm7HdC5cd0Rom4hb0J21aaFAFSVRQWWMhi3A5FmlqLz8i5ty7xnASZ6xxR7eO3gavxA
	 iQYy4x7tXZRtB2ETPw3xu8hxsLuh4kf2LoQi9MRHpVVsP6JFdIPgvPaImOaqKcryTYZPi
	 +4nF1Xj6X9ofJMGlVw/bWf1yWTJhe59hRzXRnZPsyU+OW5EmV7XMarlUCap6E04YpwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
	b=Nqu5GgqDcRi56/ix969KRvitZQiqlRzkn3ehi81vWgnOQ18Mcziw4ODM0WJ6KCXJaiCp
	 CEkGcz0KeGt+ttqH1qu5LpDcIXVn6w8Za4GACuj5Tdz1wwy9SO1oCpVxAtwnCo7strLML
	 AMeNz3O+zFUUFbN60LhUTjyXIpXI2NxUh1XdvYyMLL++oYAz4A/WeMoHZphqr8eg+6IIx
	 AbwMaYgsS7LQrwSUFm6eWn304frF3LCvTDzjzlsxbrxXZ5DC2IV8pkFLcpUN5pxyb3IlN
	 1dcjXQ+V9C9DgFts0jgnSIWyIE68BXMGphhGtzwK+OZrxdvVrcZ1NJRH5vJDRcsDROQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fN1o8DTz;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52E0606A326
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A52E0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fN1o8DTz
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cde5a7d7849so370489a12.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174451; x=1795779251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=fN1o8DTz8saUJXAI6UDM2wPcHyFeJeG8poNNyE4LnUesELXn51xESxwynt+UlGze3v
         zHG2oR2rTTiuoUX974exUvSPmUQQnNkydu72xnJu7SwhHh62M4i9rz1ctq+7nUbKbCl1
         Pe7toDAWmf+cm7p5rEi2XLL6qOF8nkcZWE1N6gWzLCLLmj7b67x05Wfhbqh2kiwasHwu
         J11Tfhp+rblssB8m3Qgm8W+7L5eCPyFQ6NZZW96aMCGPzHzCH8OTJ5OorYL3xvwPHdnF
         jDAtzG55BpDc29Qk0xk/RAab5uIcRcrIT0i/2rP3Y6up5LloZFot2JLWqnwonk9+6rzA
         7Jqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174451; x=1795779251;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=Ih+qz2gE1YvqzumBeCDiGNEe/dPRlygqveVZLNHBBdLcoIQ7EHlZMMt0vMGUBM9gpj
         XZPog/cO85X8tljfXdbqmTKQsEvHZz8103hU9idPsSAjAsne1M+dqSgKRAlULooi2OxO
         im0kxdKZCsBuRPLepUIqv49tkVubmiHlV0u9iaodreWGGiJKNj+U3WCx+Oim4R3raFI+
         f0hq0xXObJ1P56IGmGci3ZFJ9OWRkgrPylyGDo1wCOnalnweVz0S1yed5GQdqgxnCJI0
         X/f7IHJPknDNkkw8+HYtDLEpm9PyS2h9s+hA/p/U4RT4SP8ShoviIZr6/YcVqb5CQAy1
         z2Mw==
X-Forwarded-Encrypted: i=1; AL+hErGLVc18jhCDWD6LE7i+5A+5R/oVvBufoo8VTH9HZ+BqxuClx+WECe5Tq/A09gNSzw495sZUO3kc2dG+wiE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/6cuLxwzvRbCnszlUe7whPBIMNG+tFWo6FkBd0puFnGBhnXWp3
	SWl8KrNCyb03pqt2nlSeyYhLtsTnLUmwhdHWB97TfPi/JjZpePIjuusjbjdbZnabgbk=
X-Gm-Gg: AYBFou3K1Ara4rgCy5nwzG2791b441S9K/h2dhzjTMhLb2KR6g+pPKruvUEHGHgJfVT
	3bAETEGbx0/evM1asbAFGPZ4l6M7IYmXhG3JiHxzn86uxe1E/oe0jECCYloY1cTuQ0uSjmPuN8V
	jnRv+hbWMXQRGzuKDLHWL6qAf8o598D6hHwIza97fY9tAWE6e+yjPlg+ReJrW/je4Zfanu0lfOX
	2z67/XetQZZpRZF/cLFjlt2er87aiISIrIC9vhZRtaAZZmprnZ2TyFgRVwUwUwUvNn5uCIpskwo
	7QgSpPg5UClrXKbqEH1r69zfCoZKzLf7L1Eumus+P8wotco/AZjSot9CfUoln7nUvGHO8sY3uRO
	te8gzieP5WlRT56hQ8XrK90PoJJavbNECBvubu/hII1r0U/XKo6W2rIV0QrYfCnjpPP7P78InAx
	4GwJ16QU4juDY378dPVwlHaUiMUxrxxBMFgemz/izJYfgLU1r0s+qfgSHPTb/tQjXNF4MVzj3pL
	/IEM9nRyfyatgJkPASgI+McISJ56GdDqiyWmkvPXvaiiWL902rKB/QDVfgKrrIDTKp9zn30vQ1H
	Ntlmx1jGISaC+S4CjrR7THXLpItFncOOVraX2ytOAHwU/NT3oklDf+qkvGsib0Qxx32Kg/EQdQW
	vy55TznZKJRr+mkfNB9VKjqy9OnfnBSPfEG9U
X-Received: by 2002:a05:6300:95:b0:3e2:b85c:4b2a with SMTP id adf61e73a8af0-4014ef51c4amr2831753637.73.1795174450911;
        Fri, 20 Nov 2026 03:34:10 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm1139702a12.28.2026.11.20.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:34:10 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] usb: gadget: f_tcm: fix a short write infoleak and a completion-path sleep
Date: Fri, 20 Nov 2026 20:34:02 +0900
Message-ID: <20261120113402.3069090-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
