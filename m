Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174457;
	b=SjLWzUj3+kU2NA7oDhgvwF3fsx0pQQxQpAzcJ6BngtDpsw0E8tWnUGWdA3nHBLRMVPBk
	 23HVx6Aclv3htXpDO8kEDeSsLvVy1f5+be5XXwqrEl1e9tEAC4oEIpBc55oL25/pjK7UI
	 Iraa9pdsLFfPYX2wAPcH6C/tLxvKrE4BaO5AcgemGWECm7tNBBPGFeBTkKj6mRkCzxqh5
	 9uNGcmd6ns/nLqaYXNll4o5GqmT9AOdKdW2/U75S1/K+4ZGZhZp+mHC8RvXOU6QxOBezx
	 ag78sdICvM8+HRC/nSbmA0NVgiC5pthSHXUY1C93J0137JAThejvOpUaS7wBeX2L+7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
	b=psbtF6a7UmFpaDG8CCVetwXrxdqkZ7nRRSWDM/8Vk8C4Hc9GvUfuuIj/hN1Smh3Q1IXz
	 peK8jzhXLnfKjAfDQnfYXPlLyy+3zRrNlhplJcyIs3IkxjMM/xA/N3TN682U9xKcF6T8n
	 UAoGVw7yGtbq4T3lnW2usrpi9xJVfnV8dworD1tHdgz4ignoBhvAeNvV4VsVoI4syP+4H
	 VgyG9TqCvybUCClbycXKDEkM97VEHi9+8sEubAV/HRKJdWdtmFtwVtIwyjnO6AKEGBrfl
	 1M0WTJ8f9RIJw3wTCyR+bn0pnjVTMxcvrMz+CST++JqM+h2Kyx7ZNGDmhAc4PX3vS4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DIc6sQdh;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6044A606A325
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6044A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DIc6sQdh
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cde5a7d79b0so404105a12.2
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174457; x=1795779257; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=DIc6sQdhoZDPF1oyrHBgIwAwhZPAIRAL8eGHMpk5qP89FFgKp1tR6BkAnF+hMY9T4f
         PyNHTZJJwDtHG1ybaDoDrltuNhrHabjdkQTAoZYt6xnQ116XTSYSI7X2LVz0nGOmP5So
         CMHFJrk9kTVCkC9TPhtS+JeYksO+a4v8Ffu9PvL5UN0Y0hA7gtTp3qf5QH7NR3eWjnBF
         aOWW/RcQnIohHINE2XXl0RU9fpICmw9jme6+zHEDO0GM/17kck4pI4+8oNLF5qw0Upc8
         wvuKutXj13KzgOsn2B8HcBmWqXhqbsnF8CpvAc1eSycvPEMsucdFfkXcPCh19pte95N2
         rmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174457; x=1795779257;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=QTGREZRtaGoarUDsHVUGBseaqP9Km0rpKMB/OOl+lgVduk0WKv+CDUxmOPWZQ8Qtnu
         jc4RC2FK/FUFriHJU7dC7n2MFDEod/R5uv+CmQLeGKe8yl0ICxqggr3vsO5oWRDLNpNE
         zZFrTd4n57xF2FmniQDfowZZCWagw4pFYuoZBR3ye4If+YqnlKO6dWvI8iC/c2Qt33cw
         D0w7utZ0rTMDGv+RpsV1/BsYF/i4uFejdlGhyqLLrb6wARjRBsMjfuLNzOwIEljah27+
         R5FI8fXw2uHonAJKzTZuB1tdG7P43aHaYa/nlv2gEdmqLTCzgM13gCO7Ymio0kBv3Y/A
         hQ7w==
X-Forwarded-Encrypted: i=1; AL+hErH0zU+jID1GwY8inhbepcwSdNYaaRSx9W6ZDwIo3fuSAF3dP52HhgUekn/jzyIrFxnZ3i8QEDw53pt9gtg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9usFJrV/qXQi68BGFFTm9QGm69irUBLnvWwIk25voKCF5PpLgC
	ZCeOg8vTQ+d4IcmJZB+q6hmW1hgWdxtu+XvBfiUqnT5xY9LRFnS/Q98XcDiNDTt4zjw=
X-Gm-Gg: AZFdTZfajD85StTJOM3p/ht0y8y6mEXo6tKYVvsp3R4tPxI7S4iDEQ/NmzP5LqKv5mS
	c5lVcS2SX3K+C1C5qngXxoNNUGUrrmRT1sxcFafI+GUYx3cEOre3UEpiq2osWu5qkQyhtvSraPs
	MmJN12tEdZuOt5Zrh8QbUOdXB++aYLLA1Ua7wwOlLmexmF3kvzF638rxw3o/vXm1B5UN9QWkMnd
	kTcwG9zdUqIN1SRtV4Z9In/V2nAeG+W9GpRSe2C2bASIakHZxe/6Z3CnMlmPQw3OQR70CqI4JIO
	KkwjnU3RCgvsh7mChFjAumOC6CP1olDILVMUJQuVvCZUAAdMfbFharJImyVwbtgixkmdrlFc+vk
	TRlOb/YZwaTx2W84vwuT6Bi17rDPu1ihUb82IBRQnNj5THF7oFzesSLblfhiKBPT/BfRrh6Dmcd
	512Lr9L08Kf/klkefM8eRQeHwU30HiOUgUmKa2LHWukQtF2WiNk7grWyP+XepKtwc4R/Sd8j9g8
	UKRqeq1zrpTOt8JtqAGYQI/O1nPAn1Kd+rK7ekM5deQU4ITxmGnrfqexbr/KkQBlRWhCaxgQXsw
	Avuz0SgiKWv15tlXG635k1iAks3z9W1qEJfbflx6IPJLUAid5yfhqkYq+NcR5TQXO5alXPvsPHJ
	0MhzFy3o7dXiU0qrGnHEznoIWmztEO16lcT/p
X-Received: by 2002:a17:90b:3b84:b0:3b0:9a2e:b491 with SMTP id 98e67ed59e1d1-3b41c97c897mr2571898a91.66.1795174456775;
        Fri, 20 Nov 2026 03:34:16 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41d22aaeesm1455309a91.3.2026.11.20.03.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:34:16 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Fri, 20 Nov 2026 20:34:11 +0900
Message-ID: <20261120113411.3069169-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
