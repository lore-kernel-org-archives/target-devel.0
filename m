Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765131;
	b=Y4BdpC8o2p+5IpGmP2AFAXYhMPL6R1ZsJhPtWZsgf9zB3tCeJ9fHOQc+V1tr8V6zrNqR
	 /euv1Kc2rD+Y7jvpBmkqLRuxnCOSUrTE+wC/leuYw5w4M8X6dqx+9n0fvACyqu62UwWcw
	 KmlU5s5IqaE0I0crZSxa84rjypqYUyrRbXJiHNUuM7f6T9S6x2dUgXKaSeEAASnD+jKXD
	 oDaHkL6rKtxzzifXNbPjQntgR8U2578CAMYvnnoq21fgQiCNJUHsUctWNBayVu0IGNBQr
	 fs6zpHtv9L9kCp3OiHsB9lSOIbwcDkpsk+Jm2RLqV0Y7webEAs4wOuVD4msVm4Akvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
	b=lnHf0H2jc3OZQJ4+dl8H/gd8oR0xaaezzmnbQntzc4FR57Q4NJuxRTAk8QJxu6i/i+Iq
	 OzmjPv30InDxPQQpMRH9ivLGnRpiAAzWyFJ0hylLP5h7PrmXMAlMotAe3i2sA0BnrmNvE
	 dB4fNZVddjXT+KS5FveZO37S61HIsZuxBaj1kA77zHXegKhTMAWEy9S/OBIn0uF33m+RB
	 R2ba+u/Fai5zKkid8DAsmttNBQ2/W35Q7EqG8fhjQH93rYWHkIwk/Vv5FWamGQZhRf++l
	 WXLkoop2hzHme0hPn1Pe/6B/h8ZvUL6ed2LWYDuYM8cEafc4LhTHuYYaq8qFoVnZrqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8170606A326
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 04:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8170606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e831e86ebfso1663485ad.1
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 20:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765125; x=1794369925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
        b=lQgCf8Fk/W/H1qJuGTKkIbLrlKnXkKqxCXOhS3tV7Eu7U+fVhPo9nb8yLLixdFyQFa
         LPRjYf4ZjsXpIpV4ekdgLGX/T8O3Zyhjf5iK5Fpc4pt10M74Z0INpZ8EZ5VybwsC3YpE
         3Tu4T9YBF8xuYsMtzNfC+j+14EuldYyICkcK2qPSEq96RYY53YaNqgLwJL6BjiSLbDza
         2amGqz1zdXDAOc8/Y6Dtgz+DMNehkJ6zixyw8MsDbYAXMzmYKF3Vp7FLRUuL4/fWKlDk
         zaPcWvxhgXkRPLivzQlWBAKrfU6Q9lC6MJ11Ri9VMSsHQlmSonWg0NfcG3yz+XaSSRUU
         Zdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765125; x=1794369925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
        b=E1XObbL6Jg3MTQrcecYcz4R+JXq0JQiea4iajJnQwMaFYPWjryeBLM7O8S91V/e5nh
         A4pFbz062/WcEXRx2tV04+A+/0RRhNc8qSgftQgc+lbbmtUDJLxBEz8OjXaEXh0c9QSC
         Ket5W+ck+8e1Ejd7OXGzT/l1c+dZNrlFa/5vJNRuH5J/oZ5Et9V1AEwUr9vF19aeokDv
         PvnjKBhFskKHvonuFHWVcbA1YxL1gMu0EXlTzslw/6+vFI4+szUQCAvbqBmzW2BD378n
         P8qcM7QCA5VxyGgOYf3EAgvX8Hwa31Bynqg5eAHJynphCs8p4ZS9knT3ZGIUe4dlH0cl
         wd5g==
X-Forwarded-Encrypted: i=1; AKwUvBzLDcmanz4YCGXl++5AjpK3tkUg7/+a4NLYg426z8c/vLLID8Fgrrdy9jEyTKdmQc00RMbwJ8es43fJHJo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9rGjLnB22atU+tOUby5qIvfPA4jiNOo6c86maahzHk+kJaZWDC
	RjEAFe/T/LNCt7pf1sNtifSjIUpaLkjow9IYyS/5gRCUGTSTE6YwPk4900wD/J4AMM4=
X-Gm-Gg: AYBFou0OmQ7GyFEKxLL7AJTasvJKKByAIl6NCqA1vBpQIJP+8g198DZoECRlm4oF6NC
	3j5eepfeyQ/cKz+8C1d0nLKEvyeAnnbQDRX3XJGIxR3QNCpYMTpyLHlMy7P4XX1q35BO41+txnE
	HO2VnrNQwYxAfjAzjpmun2WLrRZhbOjk3J+dPp1dA/9kM5hIwbpkQHVzdK07n6ABcWCkjruFLyG
	kruCPTXuS0IMuN2gfDLhUUvIHJRbEhLKgE6L97rsFKAJkKr4JkniEWYyWPXRxRW+rArzrT/rrDV
	qc73QEjWTZXSMvIz3gCA/YEV0d2NxR7Ze3dLGi6vznSP9IW7Kv8fy5ZTl+9G0+POzKlnzZ6rC2f
	IwJqX8Czp/2bk9Rjka+WVshk4kkJlXlwrywG4dupq7hP6x8qaASDePJ5vp7kAqw9kwCuYHNY8h6
	9FrennJWpt//Hd8ucztOVRAqyygohpxhHMtZLj8Xe7bSwaOl1WFwp1acb24i4nXH/gYJ+IKpqi+
	lljf8OHWCBsnnRLok6eAFDRP8kRK09kFPk+reaOh+J+75A3+wXLR91vP3fBEsSADNNPJwAZT65x
	S1yXxQs/ZvJoj5IPybSGOPwkA2DFD0+3f/4eAaUXqV2EbMhEljrSiD4OPYDsrHYWWovvfQ/Xbzu
	r2GNo8fxdpuSEtuGbl1w2RRWss8HksKZ66uWb
X-Received: by 2002:a17:90b:1a85:b0:39e:6a80:dd9d with SMTP id 98e67ed59e1d1-3ae898194acmr12972752a91.36.1793765124818;
        Tue, 03 Nov 2026 20:05:24 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094d70a60sm873913a91.1.2026.11.03.20.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:05:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v7 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 13:05:16 +0900
Message-ID: <20261104040516.1844951-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v8, which addresses the two Sashiko
reviews of v7: 3/6 clears cm_id after ib_drain_qp() again, and 5/6
looks the isert_device up by ib_device pointer.

  https://lore.kernel.org/r/20261104040318.1844865-1-yhlee@isslab.korea.ac.kr
