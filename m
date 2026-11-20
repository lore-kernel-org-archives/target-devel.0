Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175082;
	b=zu4PRUzsajeMXDIlIpjZs4G4h4u+Y+TTge0xvzo7bKyuwGZyfFwjky7lzSpTnD6nn8+V
	 HW0XOLDDEm3sl5jRFlfLZVye8IwyfhYKilzf8lnn56dPInEyt0C7Fd1vou20PkAOvBm8F
	 bhEpo1zX1CAI4fizYAq33EHN2BX3pJwyCRVGjBl2Bn/C5j31hlejxJ81TIv7kM6nfQk+V
	 Mf1oG0RxikVDwLTCYMriVjFgqmLkNZIbxUSke2LgSiXS9UfWryVeR+xwPIKBrrFeDTYVN
	 /rDVwyY3V7hkB0iCaVRs5pFS/NzuGi8ZVy8iK5ThrxyhI8Ym8ZsF7ECOyIRnXu8aYbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
	b=FeYKDf59wWqUwBZPVQvkFNf+li4wBEd8muwgducw1Q6pw5f2y0/bwAs+bTzO6zkfsbKN
	 a/xpZMhTqjArdn2Wxv2D7ln70/yZ8xK8l6ZENCOImeMEYXIMpzWnFAkjzmMBEvQDZUeOD
	 tZo6IFu4Dk+Iffs7GvaHlNDNYXA6phlh7Fk4cpUHvUymFRYe3Q2BMGK8HN5LnqKs2IJ3O
	 NvoVGfR4fVPJr2utFqHbnWhhXSGEOJAuSFJDJ7nbdcAlPN3hj31fjb3KaLHVigNdMFMCZ
	 jiByfnKXSyPPSsCNP5ktQP/doXLvewgTwq+ayofENEGxaBkTHTRKgpOuaelM6oDsdhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cnw6IEIq;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB8060A3810
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DB8060A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Cnw6IEIq
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cdab938dc83so368290a12.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175082; x=1795779882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=Cnw6IEIq/AktYRV2USksXF7EAwqu0FAGMqTsHjbh4ISE1J/9hGAPLV56F74IWpLNbS
         tc0icoflWo4ZppuV3leeV6Vmabym3n8vhUqcuTasw+E7ZrmYBL0rMjQ9r5+3/LekQ90d
         lDCcjyl8Ta0wrp2/3kM36f8TGrXquEc0Jt9ib2wUGONOQtPswHErvnTwHbStAgMqtNLP
         4D4P0ie1E9C8uLUUTfzzT+7sN4Dpl1E0H+AlCNc3myHGkEK1S9f2UwkOtJOSPlSnmh6M
         Z2pMxzn3vMbwh9TqFwZULQILM4xbGjinH62CLMbG9w4AtqzekZKDCZUczIl6h/H+HrIC
         1mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175082; x=1795779882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=xp6hZN9ut+mJwfKfVXHnRixd3fwKhQDzrX0LBJ9SJAG079TLvmORHI9gxS6Ei/ddAb
         8u3wkoDkccpfxYVoTErTNKtsSYNJspM5vjM1Dnyb666U1KxNfMC9GLTEJUpesxqIfjxK
         mkfSir+aUr9R/c6CtYaMa+/iQrf796V8Z71z2rTf/M9vKABsCcYzCxgVE801RRf49c2D
         kHviIxW29hsBKEhE43oAsTVinvuJIguT00IR5XXU5A6usmwnjIRjweIsu/FPn8qCBKt/
         E9tcDX3CPpMBwG0UucvPmoJMPNrKhjH+QdNa6aaZvMuN2TEMgSjtOfdDujVeIsH8CgY6
         w+5w==
X-Forwarded-Encrypted: i=1; AL+hErHaB0eOLTzd7eb911vV7MeWN+AOnNiNk7axqpa5INFVGtbHG/npifQlGkB3EMsxORBH+c5iCNuluRtsbhA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8JDYDsC8KmA6FU43PkgJ05727QXZdl0j3wI1egvbrw4FDhLXdc
	mtjzmCA8cyvYNaXhb6JCk886UPLUaXSdGUJnArypXaCa4FaP9tCMEcDXH0i0hujrJOg=
X-Gm-Gg: AZFdTZf/D5H3B1E4fTD60UZUd99CTKtyXlTcdVG457wk8ypAbfHCAsj6c8e35Niyl5t
	lcBmtDXTWYF6i/XNZkoclTf7dMMrDRuTPneQP/WXqvvcXrNNYHgMtqY8+dUm+gWh0N+unVBZP3h
	6aINHIT+GFyy74ErLr8mcNN6555VrEarLU2pBbxiwCPuvCT5e5jSoZKoZiyfb1qCchVDdKRBMqe
	m/FwSYgitNLeC2seadcIBvq6onVzXqrlLot20c7ZljRFGp3zvGbG+pzUzVOGfORmepfYqK1LxIN
	pwVl1XXDbhtAGxuXAbV9YrFVomPdoDYIyx/YrlsxQCNb07P8pzJtJHENa6lJYWX65V5O6lGUk95
	a9/P98wcXbpZZygYb4uIUd0D/6oX0tfjNzo0Qxbr6EehQz4RDeFSbdSwELzI9TnXzBmJeGrNWCe
	gBrHmb+c7WG7s3elXOHRw6FitbgproTLBJ68LrI6+S41+gVOTbUwjNZksQOTSgoFOsRe4vgu3tl
	yV8PGnvyr3tkpHMHX+ktCyRAciuC2ERGaFN9LJl1Thg2olTyJjzxCGBub8WtVRzv7c3h32qlG0W
	WpELHps07wwSo0p/KGwnCVjwLOtZKWlYzCXN686q47EIrRe090CnvPBsy/qCaeLRlPEB60lCAjb
	Xjb/BHkYPJOAJzIdbMaKpgAl2LVMFyC5eM94K
X-Received: by 2002:a17:90b:388c:b0:3b4:1877:8d35 with SMTP id 98e67ed59e1d1-3b41c975320mr2681077a91.52.1795175081857;
        Fri, 20 Nov 2026 03:44:41 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm4339969a91.1.2026.11.20.03.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:41 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Fri, 20 Nov 2026 20:44:36 +0900
Message-ID: <20261120114436.3072633-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
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
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
