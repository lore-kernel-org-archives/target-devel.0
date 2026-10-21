Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593194;
	b=Sa2xSaDMLCgVEjRsm92/ho1QpewTDaqUMAni4iATFdxAaRS3pJPeStO04WkpRJp9rKre
	 rxCFihjc9cQlw1YvXTOUJHInK5vA0n1AFmh3R4wuM2wNRMVo1ViFSz6iqPRYfMLIbu9ro
	 0k+hW9XduUzAlBh4ng0vivmxrVhWuiCN3jRE5Tz0zkyQtlomPtoNg9S1gsdNEtGOFDERM
	 sTcSMfNvaYAwvwGxFLk6IhQZEa12RflHn/SViJQu76nV6ZcK57OFNgVcXmwWbioAcxTg7
	 snt/COzB8SLcVWc+2qouiLPmJi0GAEzHvBg2r7lAZyu7ayTX/xuJP5hwLIbVI1EIKMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
	b=liwU39Me0uYDUAp2zf9CzN4kJfu10ChQn/515zyV0iovzcf9RNpaNVy0LrDSjQjONaNq
	 Z7ZKwJkzfeSX91Aki5MGOEHgSszuEw1ERx2Hg3qXT5TRBgfIArNGC/EWdmMLu7XGEc0vV
	 DRAsq+zKMO3pDetti1QRPQUiCdZn8OfuTxZL1Zv0sdbL+YsD0kjk/y1jtPyQvSIPtHVOr
	 Mfk1uyyiKolMCkuVFE9DRBjAlkEP1wz8LR4WV4BdAyGa2ub6GUVeeaKKpf1pvL4ZGIegm
	 D4SqgP7HrOO6YlLbF7+Mi8NMYjSavBaCeW9y50EkGeqnkOolNwE+eunsXFCer8TfjpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=WC4wSCQ8;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD28A606A329
	for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 14:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD28A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=WC4wSCQ8
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070755c8cso388954b3a.0
        for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792593193; x=1793197993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
        b=WC4wSCQ8IBwhhl+eC3sq5GnHMVsUiN2/Qh/0fQ2HNj7a5ZjnhjyoxMb960eGoVE9GJ
         4F+Q+N7jCRk3Xao7tzIO8i8dLQNoNLi835ckMZT4lZX3/Yw6jGrEz7cuOEXY6C9rI5nw
         HlBpLO5UWS+MhHbS24Yxgur+B4/pO+liQoM6W17S3ET3VbEWlDtHRBcYAlPlgVKm81E6
         EdvVwB4kW8r8eWh0vkFhORiE34VcBLAdLg5OhRuOTKdelrGqjSeRTuew6TgYn23YXruS
         nVaLZExLbxQtw9k5u8gifNEGRsbxlVkNSxL17rDOP5UsYAA0RuH8ymF6nxyOAXlRlwkM
         Vcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792593193; x=1793197993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
        b=D8GvKkMuvicwDDt9rPuzGz5OFUqxLdlrrj0gAwNokm4kKNrDbf5t00NxcnVjqA130Z
         mD5ZiDCbmk0+9aJiLvLccSx6RvqEOJysHsXkmTk/+ZmUmla0+3goLmnzLjhjsgBiSB4o
         btzW4PmVZvlnCkM2aKKyrCQdqJrglmi6gNlUA7F/MsS4PAj/GJoTVSEyAI6HEqg9B76k
         PPmmYUo6vqPaqVjOOGfOIgEtOVXRKdxXww8bz12C97iE7LnyS3vC55LkiblTrrWWFXeQ
         R+KP01PRuDiZbUZSDgMpvRUsFKbpp8xKW0pg6DfrrnnRcuu9ukiGADpTySsLxoHOAw8H
         /Kqg==
X-Forwarded-Encrypted: i=1; AKwUvBwHDmQm0bujSAxuxeYo2ow6xG1JWpg15JS8R/+g5LU5ogcQ3bLkNAJ/JIG438L8xDbhOW29Uqlk0vNqnB4=@vger.kernel.org
X-Gm-Message-State: AFq9FYIufOo+5ra81mTAN+UuKH0I3tWEyBgSR0tzPOBXpgmXHuvIwTPM
	hh/HdNTT46BnaGX+A0jAHU+Ch3XDzCa7pe94YYWYHllo9VYVjyHJ08iWh1P1VuktdvY=
X-Gm-Gg: AYBFou3S09nkO/hAnoTW/CeWPvHypD8yudw1EHA1jl4ktZTEdwhvL1PCzLuMbjrhSoK
	QANz2jwzeAtwX3rbq++0UntUFIWy2NkuIz1uWg6TQiqFFgPgIiG3qdS50Qnm3UvZdDcau8b5dVX
	gGdO9j67hA+yjJO8nvR6wi4fGNph4Dz6wK0ZE3pWegx62Lueocfi7W5SXofNG32J6RbDwdtVnig
	YfLFW19roaFRxqW0mL8lEYTq8Q7L8wK1sIduMQjNIc8TmVTJtNPpe9HoqT52CI1mmWQfEvRUDlF
	GSaIP6U21wE6zLjNSpgI6JWmzeq2OL9mpzaC3/EqsWMOq0UBAkfKAlae1BzHhyH3dUfu5TJrCjn
	C6gaoeFrT4Iz1geXW1lXTRncVOxb6EzckGEbUBzYV1VeSFfRhFHUfNJrNWqE3MS6sLK/K1Q6GnC
	Py2YT1mozYDWcZBM4pln8BubLbtyrDKsNoGqLE8aJjnuudObxNZli3PW+HKYzApc1ACD2X1EaPZ
	BMYvcFhbHkETI/3+UKH/snAd1A2Gs+YodgiqwpeA27zV4wloOC4DPBzIx6/18IoNDp8st7viQHK
	uC4=
X-Received: by 2002:a05:6a00:17a9:b0:881:be70:448e with SMTP id d2e1a72fcca58-8a089ebb6f8mr1941007b3a.53.1792593192467;
        Wed, 21 Oct 2026 07:33:12 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2813:c015:8111:4bd6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa967sm991720b3a.47.2026.10.21.07.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:32:58 -0700 (PDT)
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
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Wed, 21 Oct 2026 23:32:40 +0900
Message-ID: <20261021143240.2782323-1-yhlee@isslab.korea.ac.kr>
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
Content-Transfer-Encoding: 8bit

Thanks for the review. Two of the three points are right, and v3 fixes
them.

Both came from the backend reporting a synchronous completion while the
setup work was still in flight. efct_scsi_new_initiator() returned
EFC_SCSI_CALL_COMPLETE for a duplicate PRLI, and efct_scsi_del_initiator()
returned it when it handed the in-flight setup to teardown, so
efc_d_send_prli_rsp() and __efc_d_initiate_shutdown() advanced the node
before the work had registered or unwound the session. v3 returns
EFC_SCSI_CALL_ASYNC in both cases and lets the setup work post the one
completion it owes, through efc_scsi_del_initiator_complete() or
efc_scsi_sess_reg_complete().

The third, the window around efc_scsi_sess_reg_complete(), stays memory
safe because the work now holds a node reference across it. The second
efc_node_free() it describes is a pre-existing path in efc_node_free()
that this patch does not change.

v3 is at
https://lore.kernel.org/r/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr
