Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541959;
	b=c10RiMBy6Xi022YhKQpZKUMij7nbqOqY5xU0sq+48MJQpqSXL/Iwmp4vwj5dv+nmGqEu
	 kHg1AdCn7a0rh3jwpyC9z2MGGrkY+WwWn2kIf3QBTO/3/9M3C0ThvIAbt+4APwSrSqj2h
	 VDJw6V0kCh1eKLsanAUwX/icNM1FEeAuvKb29lj/ZwGBK0K/PohGH/a1FXeq2DWO6uWGA
	 9X2uMPBBBXjhsnJr1om7xSBvC+iWWzI9C7qRnP4Durh0TK9qqB7RC3sUJrzEgD6Pi9wAy
	 kXdNBajHU2sjHKbUI/MYWnJM7IqDXsQz3PG0WLlvAX/ZnF8Mm8BUrtYoFnRBID/1njg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
	b=0APNhsqkp/rk8xU/jpjJCZ0gvj8O7mgI7B75rz4kDoKxqBqQzPM4O2orb5oHpeuSd9L8
	 Ru9WYtQiaUTrYed7M/NSGQIbaEBuRCSRg14a1okJk/9g+aWIzFoF4SlaJYVamdz4XW7aR
	 pivUbhLWS8wFViqmq4RhXSw9GFNOFqlv+qVhBM7LQgwFicKKshBYJFdqSyyEbejCkYfP+
	 ayajqzS1MvLvpSh6AWfm/QluxJOI1yt1QcFCCe+n2faZ93+Po2GIwTbifj7UDsn6eHpTO
	 WJqHYZVYKwCAqIojqGVZJXAMGcgNSjTBny4UUodQwunqaFur9ask9Avo2iAw7luqusA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aTNUhhYB;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4697C606A31D
	for <target-devel@vger.kernel.org>; Wed, 21 Oct 2026 00:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4697C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aTNUhhYB
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso42680a12.2
        for <target-devel@vger.kernel.org>; Tue, 20 Oct 2026 17:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792541959; x=1793146759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
        b=aTNUhhYBPXb4Fb5KI8FnGv/yl41UzhK7F9zKmhigXfUmtVeyLgADuCyMCH6nMOONuJ
         Q53U/g7I/R9frRVQWqeW6wCiR94UNCRDBaK9dn5+YyK+TMxBrARynGwko7IQW//0vyta
         FOuBfj4pIkPJIq78Wua+g1QbQi6BK1akPFDHpkihop7w/BwfBrP3s3t5gOtMTSiJszTn
         SbkA/pthRTVAhT85nxpEDBaea53ZJVfF0eJGSiP5icDzV6Rsyt4djG7oZb5ENUNpxyzG
         SgHHUX1p3GN7LO5sK01zDd8WxfeswBb2mHjdiQhAoC05Jb9lZBjFNHBgYdq0BUEuef4T
         fbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792541959; x=1793146759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
        b=M8V2qglyoh9WQPfUb1/Ze6QlKfxQg0E9poArCW95p5zVCM1wy0gBeOdU3wwYzkUlNu
         63wsccQq88GuAp2xUMbCGH6cRUtb4XKCOPg8XQkuA0Ad+k9SFZChIgV1mU81Cql3FYzl
         /cUTfTVrZbLrb1jYClcTsqPszVyrTS1zfEw2+PIhs9iElrwdodxKhdFc4/dTY92gTGhH
         nK59YTpz4jmnIJmv8osMtq74RAShGY3InbDwNLaBV8+QgsW+1udPslaeHvYJhp45jCfK
         TC3smqYEcAPOl1TKImdQarvAY8mFD86fZxNIxZTg1O3hRASslwfkmcU9/f5NO6OTYq0s
         Aa8A==
X-Forwarded-Encrypted: i=1; AKwUvBxa/mDRsDlKOOPQsUKYe7G65NxlN3bSzOo7fbS1SrUK1Uw6p+ggXvPDdEuSG3pelM9H1UWdY+TRCsZKxYA=@vger.kernel.org
X-Gm-Message-State: AFq9FYIF9ZVOI3b35w0NU3w3l5A7e5YX9KPifn91PLdD1j9+Xf6EIfFY
	E2ivtpRQCPOlukrvKSaehAfbCUNWJVWNBiWHZ8vn1alfbzSNbLrkhErNSb42ywsxnSM=
X-Gm-Gg: AYBFou1r/10orRoM+rrUV916r/pBEYhzslGuXI1f+uadVv34r1+OEaz+6KSFR4S2eqP
	BVxPKOZAfJU20T61MgfRxQm+czKBQpExcU9qOvK99Z/BYhbPXlX51PJhX15PUfkcGCW9ZVptMSW
	bBhzin394CMwTDCU+8aVMj58R/zvSJhwZOQXLcUhnUhuaIm45RS8Ygwa2XUrx7Gr/sglDk1HfWk
	wfCxswILaVw12Ry90Lh++wRGwynu1Vj1eTS7Vd5uWK0QHnuDKpdY9pvlEFP6JRB+e8aZCjMrMuD
	DTsiITtCthoUC2TMiBW9wWy2a0weV4CStGfk0Wa8/WJ2lYbk2DvevdxyW0pKA28DzmeCrmlRfcG
	NxHGhK1oN9DVkkKq6CyipB3+uxsL2OW9B1/OcA+8jgqGwMjuEJCAdyFK5m9ywZDDXO4sH9Bpsov
	MKKAi83gnY6NzbKBE4m3eEvKTWHXYqI4LEVWnqrlatITOeDajA/RDuA93XgxV063heusE6H8aZa
	azXsySrsoO669XbNUiwXmsAGZiMvcGlg/4rLTnSjGCHjLi5dzRBEZWkfaftmiq7aQuVhoH761W7
	+zw=
X-Received: by 2002:a17:90b:2646:b0:3a4:ca46:8d44 with SMTP id 98e67ed59e1d1-3ad86f1c073mr414697a91.18.1792541958529;
        Tue, 20 Oct 2026 17:19:18 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad8021ac2dsm1570973a91.5.2026.10.20.17.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 17:19:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-reviews@lists.linux.dev
Cc: Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] RDMA/srpt: widen the RDMA context counters
Date: Wed, 21 Oct 2026 09:19:09 +0900
Message-ID: <20261021001909.2343045-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-179333@kernel.org>
References: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-179333@kernel.org>
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

Thanks for the review.

You are right: the indirect branch of srpt_get_desc_tbl() bounds nbufs only
against data_out_desc_cnt + data_in_desc_cnt, not against
recv_ioctx->byte_len, so a large table_desc.len or add_cdb_len lets
srpt_alloc_rw_ctxs() walk idb->desc_list past the received IU and past the
req_buf_cache object.

v2, which I am sending now, bounds the indirect descriptor table against
recv_ioctx->byte_len the way the immediate-data branch already does, in
addition to widening the counters. Thanks for catching it.

Yehyeong Lee
