Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186880;
	b=wyqnUg3Tm1ygwKRkprJz3Spd/Ove5pmu4XvLH6pGQd0Y8aGTDMuaywTkozIf96NNBnq3
	 m3bu7quKrm+cQHNRnQUFJhutBnhwlM1HQPly7fXMMOWhDGk+K4eY0YXr5Qzc4npzMdQXz
	 knpvUY+KTambTUMs+2qoNTY1EFWJykJ/xTaabIarm/BgbtWwkhaUnMKSKEv9ESrOY5D80
	 bYy5DCDDfX/n0Ag37TzCuf0dSjW/PlNeLYzlZyG8wY1FMCYFSMvo38REH5bvL7N0WMThb
	 lYNVhTd+bhevG/ZUXEgAhjXIT9eLmeCeXknUT0mObRl2zMH+76I3Bwmxz5QGh2Hqk6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
	b=OO/L9IwpwZybspne9ChQtBxGwvgGtP39rceDBflshoOif8hjZTYNRm5NrO5bD6werqeB
	 T/QXhrx3ZCl4hPFFGc7w09xZnMhTXfSzgu4bVNW3ZYo6A2K3nN+QC7U0f8fr1TV0FMD+h
	 ghjEU9Qmjtk4k0gKAdTP90qVeyborv5l6hg8ISPEuG3U6XwVtNgG0D7H+p518po3BJ0Kt
	 9eYZBJ+As5AWyz5VTUxBH7x4rqEpZzIJ+cNIG84YG6vk7hgWRfh3VWh7zHC3a3SlCng5e
	 aEJAWtKy/OyR2hkBTZp49E69yf5dVrDZRoqVNSOLjscFvseyClnx66kN3oN2sfev6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JvSz+61v;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2BF60A5BC6
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E2BF60A5BC6
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JvSz+61v
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2f05b465cd1so204305ad.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186880; x=1795791680; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
        b=JvSz+61vQyUZqYJyiTfG07ysQ2zpBtbFrcR6lmftpISADf4xgS1s7hF9NFLDmqknVj
         v+x2IBguo7+M9xKQdefS1WSvzXB8KlfUg6m4NwfgrkWKs6lRk7XWHNTrXg7p4MvZOfQT
         yDhMmyx7P84x5WEU/WLZg9UBxV+gdSGQhF1Ykww4UyHSIfTmqWdpMjzzX/HQBCByoE6l
         /8dY27abJx6u/+GSsi+24FRWophKKvPATbynOHgbL/XlxfG2iTOfg2S3xSvkC31ay1r7
         atGPb68ZBnLSOt3keQPpWiK6aEr/sMsm/KaTAZGOW9jnuLMkVCIs0uTQTfQqaj+ra71T
         WfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186880; x=1795791680;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCRm+l6ZHE272rkjlmN9VUDSwPrbwgekcccIxZDKOHc=;
        b=gUaGROK1V64blusecp0whtpelDpqfIFbdbh2qdRoAXK9isDrlSw7OHnWCCGfF5SJAR
         8yIvlcGxJaVHQSZaIfwxC9qdslLz1KQPz+ciMy76yX/N51h/6+uHaim3l6OjKHJZZmuQ
         K1ebAyrCABmSo+a9IUCAzXaewnqadxMBdTq8yBZx47rJOLwnaf9LJ+laq3lVSY9PiDS8
         oENtS2sEIQ1aLnkkgPyVdtJM3JbJBdSKtHGRJHEzxRbP9y0HdNaq/kr4Ro5T7BARekv5
         Gr8yeukwZlo61UmPbYpe9LXViuhVD+/OaSERYTKaMq3YgcNf7yXAKL0m4q0HdUi8i2ww
         HSKw==
X-Forwarded-Encrypted: i=1; AL+hErEGF+hA9jBXJO7qGM8doOooD7Rw4nYQSVorCKvUOxH4iE2xHurHRWv4ocHa9jo+8miYCYB6tVUpjCmM5Lo=@vger.kernel.org
X-Gm-Message-State: APuU4Z+IU/GW2DmiBaq5vqZW/XDWMgfzJvmPKu5Z0h6+WxSZXz6pLOXo
	5I54vO/6trqiODsbaKAmmNW+fptN8zq5RUZJz0CE5K6SQpv7YQbLnz3HFm+nN9UeNYs=
X-Gm-Gg: AZFdTZety1kBbeS87U9KXgt7Bb4EEksMhu+KdfvPuvfGtPRjSWKlCekngHMTxIgV7K2
	4M4DhIN520mUpRW5Q0/70qvFNDRH5ojjVtdglUQl00zTAAi+yRLlU4v3TTgBZHf2UeVdb4T8e3h
	w8g7Su1JV5cgFyMWHOPwuJOBlHP0vlCPxf347oGABDjiXNd1AfDn8HpUYwcsAyMv4ZYQDpsv7na
	LY/3ZDWHEmOMQR4wwDjBQid3g2M6tMKtWtid9WT+p6Tc9nmZcDbtHXhZ++4YIBLjsGHdRXUh3fl
	J7fgMSS01dyqgERmcAZMRVZANnrzeox0YfAfIjaK7vrZFGGf4jNW727Oumz5fJC05qLEv0Un8gu
	LOMM5s3MKZEaEuYLgvBCryC9H0SDsMXv2UbWe9fyxKxeEwWoEr0dHw8BREnRlv7qxGvFg3RueRN
	pm7kiM66fD4a/bW+tcbx+2syupNLaMYaFtruRBBtzUxaB2BFZKHtZIWt1lCwKF7BGRaKIS97NSh
	CBaBm0ALqSBSE/n8eOJUIBNpoaLQdtiUZ/4VgwVTP7HfH130FRyuX4yt1YiFilfb2E6hYw2dohw
	sahTuX+V6W38yw3F0s9GpJR13FSsBW8N/FC2w9OqnsBfLb5/9HTAQ5x2MDoz/NMlTsPT9QaVNtL
	xf+fm1th9G/w4LP14qIdMfvrDFtv2zp01pCyp
X-Received: by 2002:a17:902:e551:b0:2ed:ff4a:6d21 with SMTP id d9443c01a7336-2f03f1beef6mr33867465ad.73.1795186879777;
        Fri, 20 Nov 2026 07:01:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f12028dsm15024705ad.60.2026.11.20.07.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:19 -0800 (PST)
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
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Sat, 21 Nov 2026 00:01:14 +0900
Message-ID: <20261120150114.3128328-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
References: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 21, 2026 at 10:08:02PM +0900, Yehyeong Lee wrote:
> efct_scsi_new_initiator() hands a bare struct efc_node pointer to lio_wq
> and returns EFC_SCSI_CALL_ASYNC, so the node state machine keeps running
> while efct_lio_setup_session() is still queued. Three things go wrong
> over that window.

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
