Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4543839B4
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 07:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791878190; cv=none; b=P2I6DBYZF90NrB1jSFWQuPvLmIMFhR5dui5ABr8IffRN+q5ppib/4ytPsU88krxSwCu6nd2ZauAu85Ku1mgg0fYbyZDPy1P2z5C7Yexf0k6O6pw8XRwlUV1it70q7KhX25/bvFG2rrFePgKuyq2BAQveJRkFLXDLffDJOc/Mg5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791878190; c=relaxed/simple;
	bh=6Hw6zOizikH4nU5MtOUJGtJVcNg17esB1LQ9dVjUH4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLGKmjiOlcI8NcgjSDg1J3TlavscQvMJ2J4JAnHt5sj3noWKvo+2TDw/4cDVNu2IuE730UHVObyGrkmBHUGtVdD+M7jJE1IF8ekb3K228wG3Xx8GrtTIIOVMF3JG2IftSKSL7ExCS/k2jpnUCbPj7a0AmS83Vq1J/Wz0MROHNvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=V6tzbRee; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="V6tzbRee"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8662d5e95so14247415ad.0
        for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 00:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791878189; x=1792482989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jANvN0a80qAhabkHU+c1blDJzLk3XqzePiZeFwrI4g=;
        b=V6tzbReeS+Q8e8j+UVIysvotjKUF/OGHOMXq7HNsSECehnjjsa/A21Y4QL+SPKJ1gP
         BrlqQA66c1joyrdGG18xan1W8MRZxvsGHAAd61dwRQN0gX8AQCu7/+0VV5n+OnT6LFu9
         3+c03ec2wCCsVLW5NjIhkogAPj2KWsdzEy7EEBUnOz+bwEclsxB02f5vaWou7GON10j1
         mQ9y6lT5gBd36ZSJz2zcac2DbLOEyQwN83oWbdQFV81mLqxb6IBjgXfrXEDIO5Arxi8g
         xRqxUfYqerJ+1NMwlxkVqtz1PiGfToNMtzU+JnFRPJabxpZjfM+ATDf4QEy0zaFwOKKI
         V/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791878189; x=1792482989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jANvN0a80qAhabkHU+c1blDJzLk3XqzePiZeFwrI4g=;
        b=SnU+YSyWp7xZHOxcCrodKhD1pIueVVJkx8CbecRuIf1jLLef2pEuNumOysbKjjO0x4
         RfoqUcvHkH5/JPlyubpFUqoaP63gXqsFYtaVEwsq/KOvuhIR5K3HSYzQC7cvGCOloAAc
         k2e8bDLYd+uku+r4kvt9tKWMOmQz1DDz/Kq5qaJLIzzaB3s3dc5m2XuEidQL0J5Jm9+m
         ri/9ku1+TE4ac+5tcwDhIxv+mn6CMzS4HE/F5f2m/vHU2A+TVr6GIw7a2SIjNxxyjWLd
         MekaD0hb8q5x8Mp4gpEbQRiv6BQKo2uSWD70MKpCFO1flTz/rKrrkqCTFktBYjWphmIJ
         XC3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzItpzXScaADzSOncif6KYPlsE6EirsNNfEyKuDPxgDGSxYQg57jZFbZ0r/dNysPc9W6xTkjDe2kTpaGLI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ88ytM61kutOLi9F6ue2jQHzxYyvRUVhIuXUqUC+xlr668uyY4
	TTgrReZWAoSQ0I83daqaip/eWY2Q+cXGi73ZJ4owONuZzh/pmiVIod4gxdK7R0SY+bQ=
X-Gm-Gg: AYBFou2U4N9czvY55ZgdABTPms+k7vSjXYycXZifJB0zDviAV0Wzfqi4upeak07hgPJ
	8aGP8H/UiLPIg2dABXHELsSg5oLg6uVTzwXTqYp5IaU8VtgTefeMZF7NdGY5PEiCcnXJubprMmB
	V5PDPU15v79TabDO/92v35qSLizwmBIBvYQVSx+z7mSALkTPOhokr3MtW2mhpbDZV4+trUpqx9x
	iJSOynq/QvEV9IPyfLCQLBcoD6cqtPcdAP1xXYvFXs58RPNvn9fHkdNJjW0r6HKJ0FDML8kPpqY
	KCxoslQvgUvUb3m8WcztTGBSVECRGt5xhl5D7Lao3X5gnhv9r0P3xB+B8DP0RG97VTd+3uugu1b
	9OoELL7CGgbstzabmCorR49rpmn95qVj7aDqkysVIqKKOU4ZXFPCEPLHsJcS3Ygp599Hi/EHaHY
	BjNykA281e3qE62nGuNJPeIyrNA1tFxyi94Icuf03aZyeQevCuARj3pDMWtyqaY4rsNHpwE+mmi
	PucKQ==
X-Received: by 2002:a17:902:e947:b0:2e5:9923:5582 with SMTP id d9443c01a7336-2e842bc0a30mr98712345ad.29.1791878189071;
        Tue, 13 Oct 2026 00:56:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422ba80asm52420885ad.63.2026.10.13.00.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 00:56:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
Date: Tue, 13 Oct 2026 16:56:15 +0900
Message-ID: <20261013075615.2940598-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-169209@kernel.org>
References: <20261013073328.2936318-2-yhlee@isslab.korea.ac.kr> <sashiko-outbox-169209@kernel.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ignored usb_ep_queue() return value is pre-existing - it has been that
way since the original c52661d60f63, and this patch only corrects the
allocation flag.  GFP_ATOMIC is required here because bot_send_bad_status()
and bot_send_status() run from the endpoint completion callbacks with
interrupts disabled; GFP_KERNEL was the bug.

Handling a usb_ep_queue() failure (completing the command so the session
does not stall) is a separate, pre-existing issue and would be a follow-up
rather than part of this flag fix.

Thanks,
Yehyeong
