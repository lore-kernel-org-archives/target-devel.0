Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588507;
	b=B0xwYAt7UJIOBiCkwI6JN5l5WmGf4n5mA41XW0A5PlYR8jYXSHEf6JH1kmAP5u6tc8Qv
	 vd40ICBpC16otDEt4zs5Vw8ti6d0yYSDm+6uk1p5LVux/KtYL3M7FGlt8XhXSs3QmYsMf
	 0gJIQ+6PKDQqZPwOteqCer8+6m+RJXWglL99v6PX546MEFr1gMhNc8AFkOLXpApuhnO+l
	 gUkogLXAlCIxceztjZUDtYS3cpoA8K0V194+x3fNZ1mN47QeOH11ugMX4xVEakUwHDLpF
	 OMbtS2i/RgtCDmO7IF0OFHKzHW0RJZy5qks+8fFxvfJhRXd885NCqOFythQvVTVYQDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588507;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
	b=iw2uGDq9vy2YpObFccfCTvPPHQwLro55h0Vr3MRXIbE3P9XWodJdeiFRN4w+fjST3xwf
	 0cgMNkOSOd2+tYsEDIWwoErFkS9vh7L2/8lzBX2KMkhN+hbE1hFOg2X71y1oMXOz6RlSo
	 CCDMHr3PAL0mEU9KsCbL2va1M7LxvtwK9CQcyz5pwpyElMiBznJZSVwQTXwHXesRWpf6x
	 oJXChu546uUSdY1jlX3v3xoGQsBDJA6xGiLBDajDhf6TRSAUwBbOkTLUCIc3oxoL1M4yZ
	 ifp4e2PMpX8w1rmLXhf4grlSrVTmT0fsbqGXorUMm5myqUhY08B0z8/OwL0mxKpgvxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=cZxc9PMc;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3917F606A325
	for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 13:15:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3917F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=cZxc9PMc
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so421754b3a.0
        for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792588506; x=1793193306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
        b=cZxc9PMcIDgAEbwFGgeWmIkWu13zDvGzXhwYXDl7NUKjiQEQsPJx+aSIuD2HbjHwoB
         2wtQxmUnjvfhc5m2a3I35zEoJMBAcryVhJSov80BDZl60z26TtQJsjdr/qy0thVk0LrF
         kpLxwtHLWM/ym8GOUg4WbdeHOr9DHJ/znHnB2YxbyANnCFPFPJtddye9YXGarifnw4JJ
         YYV4kJDRNlsf5+Rxv/FI++/YBD2RUltaTb6FDZD9KHT4OtSrgSCVIjFHNCWzPg1JdU75
         olwTLsl42+8Jvb/Qp8mwazf2pgnMhJ9sCsvvjRNrLU45TMLkXgKkG2ULnWkRUfsYF4gy
         3uYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792588506; x=1793193306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
        b=TGkcoWmpvVj+1noMqfQp8Wdz5J0IlIYcPETlElmoIzrw6lc0QztXm8MA+jvt5/8Pdt
         d/b5oMppX6csbBEMJXGdg7AUCcnwd3JMvjrlAlNVOviW6tfhUgL/nLTfhXphYSBC+JSQ
         Ejs2CMAZ/7xfMFvUFoAUFRfNRA8Zg467aCFn+FAClp8vYkbK/Ad0XBuh4cs15nUJB2D/
         fm2Z8KyBSsDa/076VhTF2Lat4eJbBSdKOxlnJABy80YxBxlwngdoPFtxOfIGcUVxX59h
         Dr5797Dhtqe6yQhNQkPjhtwJxQbEAUynn4WaY62rqoBcbJStbuOF0QZB9x4fTeJcQNoa
         PFsw==
X-Forwarded-Encrypted: i=1; AKwUvBzfWaT4t8JzbVbZayjGSN/UIB7mr6NF3RJqnsLAu7114027e811zkkKHhWVjvNCdVK/ejyyAGIVt1pO0yU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKh8OV0+Qup6IdzwUywy8jX7rSPLYAFVqOhWjDNmC/ugoZ0YUUs
	extAYrtLYoCgbP/U7gNYHZz3Vg+NGVGE+DhGhgbsUwrffhxNb41EgtKa/MaFDUdiVthvTYRigDF
	Xu7gk
X-Gm-Gg: AYBFou2ujeVuaA+7sbRrypi+3I2zVA+4HW/rgDCPx5oTVOogrUPhY61UTVXwa9Eo5Ik
	VWwSxb0SH0nbAcaLexqFFAmGiiiis68N89qgE4FmGqoeG33IvByJjIzJgLVwiCQgF1lIWhHX48Y
	1LT+6cFF+DJDebn5CfmhCPjbTfI1sM4NkLKG2vHTC5HMDvz4LuIwJHp4o0O/cB8Ym0xsDNN5JsM
	snvgql3e9xCwA/4fKXvbh+fIMm0zi3F70jcGLhD26EeniyMGFkxdtBsm2F1Xcz3a0sc6jTXKUEz
	yngC78y0C9b3w8a+FvkYWKm5+VnHLnD8SsIuYG8t9KMeEHoAikX/gy268HdhxZE3LsvU/d1tJ20
	Lo99kKoCP4pURiP+M4o0hyS4hlnXSLLxaWLL71kJgrmVKZbTGBBorlSBMqiF8nlmDsohEtv8FgV
	FIWE+uzMHNTbsCm87Fw3n10HLIO32OQMSTxVEOl0DpM3YsvuHymBxBmqRAplQfmo5SVzH72N4YN
	PodC4uOqY7RdQHbybOc8LJzzucLhGgKuyRR8giTWvCnInFtlMbGczgjLV7JOrdWj989U60Dx+pR
	OA==
X-Received: by 2002:a05:6a00:22c5:b0:878:34d7:6a24 with SMTP id d2e1a72fcca58-8a089dfdc7emr1689491b3a.38.1792588504540;
        Wed, 21 Oct 2026 06:15:04 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm889414b3a.41.2026.10.21.06.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:15:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Wed, 21 Oct 2026 22:14:48 +0900
Message-ID: <20261021131448.2692313-1-yhlee@isslab.korea.ac.kr>
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
Content-Transfer-Encoding: 8bit

Thanks for the review. The concern is right, so I have sent a v2 rather
than argue it.

v1 gated the setup work on node->nport and node->req_free, but that is
not enough. req_free is only set in __efc_node_shutdown(), which the node
reaches after efct_scsi_del_initiator() has already run and returned, so
a node sitting in __efc_d_wait_del_node still passes the test. On that
path the setup work can register a session that nothing ever removes, and
in the narrow window where efct_session_cb() has published node->tgt_node
it can store a lookup entry after efct_scsi_del_initiator() erased it,
leaving a freed pointer in efct->lookup.

v2 drops that predicate and gives the node an explicit target-session
state, read and written under efc->lock, so efct_scsi_del_initiator() and
the setup work agree on who owns the session. I have posted it as a v2 at
https://lore.kernel.org/r/20261021130802.2691833-1-yhlee@isslab.korea.ac.kr
