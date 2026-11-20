Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186788;
	b=TnE06r4qdqHPENaNxAQTkVcdaBOZnISiVJkRIALH4noWsirXEBjB3AzMmlLBynBPqK7P
	 EnYrIS1fHt46/afl6Gt4y6K6kYw17zFMK3v/z3PnYBcX8r7NQuDXAuM4O8fBBKjWEvy/l
	 Zb6wN9IJRJVIqIBOqcx1pFyHKWY3/fv/wz9Br5o3amrU9y4UZ562UIT/k5WEyB61h/U//
	 12qyIHMW48KZTv1T4zwsh/KvbmLjk4BljYWSAooyigXIAgafX4TbQalz8JZgUch7vC3gh
	 dN7IuDDZtOavbwmwQgWYuQxp/fPmQZ9sRGcJDdL+r6gZ13W8lqAyNFW442OYG6YJI1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
	b=FaaipLeqjpZUNhrse5zYcHruOdaC0D2BV/hkvMVGNMtsh+1+1XCR+z/JR43KxNuIulTH
	 wPW/U99qaHe+y7XvhDzzqX8QhxINL4l8ANp/XJ61/T1OxWjTQMr8Qs8/bW4XD8P7EmZ06
	 C9AYTYm/MhKs2RL4tzI+d1KLkuLFfdS10sWLcpjaDuhBH7J9wjywsHlr5PxVKSpDihAj5
	 9mchGGt7+pJ/85QKLuqc9apHZrdNwh7XeF+JalPjbfXqa3qt5S1HcKMV1vec57itkHZF4
	 Tm4Et1Ku7AwOwGC/4Vv6F6vw9hrBESBONN/nRS3OtrxN/jeU1zCHiZ0rnGRxNvUNJ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GQOBYiiS;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD0B6074D34
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 14:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFD0B6074D34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GQOBYiiS
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b40d23e1adso841732a91.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186787; x=1795791587; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
        b=GQOBYiiSfODVUY5BPry3vYjPqZmWwB2BfZdrAloTbnofeo1ihjK8fEuQmY4qAki/+H
         jwPOg8fmGgNKjzaulexXfpXOcrl9MwTULPR/FJxdXVJsigwLWaLXAlxE6jqrSNMGc/eh
         j52M0zK2n6Zpm+MyLwPg0s21NdU5uwqmchktt2llqHaQayd9LVWN456DCblY1+3JY4HL
         XhndWn9Vu+h7ht+ze2TgSV0C2XS5wgVL/G97xEOt4LpCp/yhAsLRsl3TNgrTRAPYXgGa
         SUhJX0IBxJll4EgXwcY+Sd9f3UTkAqLIysWbU6QJnSXhRakTLmSwW/CvoaXZxntnu9Gt
         sYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186787; x=1795791587;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0hY5ua3O3jmOpFf4vZNeVvm23+ZKOqIsiyXF3A3efJg=;
        b=N7wgB08mS6SaMyY6PjTejlLFn9wTCWId5yVuCl6tXKxzriK/NuZvXON1mGryqWUqa5
         HLIWjbXdeuz6p57/jp4kPO3BS/ggP8k3koA4dwYm+V7r4X/s5RprKI28ZdWqBxyqLfWE
         DYjD/9WCQH4I/5iisjG+ZDP9ISJpu0A9RvZ0YBwnde9qrxwqfPM9B8s24by/bXYh9EXv
         7/RYLH+hLjV//Mo45sc3AUK0MXAhipC6+ysvtu4gn1rw/gy25p0zj7PoCYQlds1tpp0W
         fXR4mQnxDDk4JBqNZarwlxoxRGQAJ1sFlfaSm97PItm8aauymVyIRSrYSdwhncowXmw8
         oAzg==
X-Gm-Message-State: APuU4Z9vvoW6oObQBiVvM6FIe2TxH0y1r8kq/P3lxjJconf38ui3+Sho
	NKUxFBJZ4EFzUSRURkx4OPU2mRGnsvjOyzLKBcET3TcyKEgrlZY/x68n4M54nEIZF2k=
X-Gm-Gg: AZFdTZe9mkbRBPkdwbFJ08Idf31/OFpfF7qga9wo8XLbpMRbHnt8nkmB5wntw8CGxZg
	3CVR4QOn9ntg1rAOz6OPFK7UIMYIaih2tgha4FEkFxdpkUhiJt6f+a87UN8FPt8EpyYYfKZtMqe
	+93UZIKtgjMA8fVKlbS/HremJLxsPGeeUOy70YzWeFZJyI369fia5uArYVovV32vits/dduVlPs
	9x4u827o9N3FykFfjTBFGdogGkSs5phskbAhhXXKyQjihyQppJhFGTzkUF4w8h11a6SWIsc7+vT
	YIUV0JPDJ7f2U7+xSQJIB/gKbncEDrgJsLAGW380l81jN5/JrFWrE+mGB66ujgGITN9txsRFKyu
	1+mefnPyWsnbPz0IA9YbJRT2c1suAIAQSsCSP0aro2te5Bd43cjRSv0qQF+u0qUIv9MxG5Bd7yp
	2TNcvMkZrhoOPvMfpSkjgsS6aiJ/YyTOWTLRBygc543Rnu70HADVr3EUP4p3mA7raIqLF4s7R/Q
	m6a5vjw1bk9N99MHNxfotXn9NjaAPS4HwSF4oqCQHeClFz5jGiSbf9NyKuvHQQALsQ+d3vcJQfl
	u/FKn7M05wOlWisMNvlHnFCMPbhLtLP3EN6CuaO/RI2+OEbE5BB9DwRunIEbusugZ547gMm0FUh
	HT1qMaR1GS7V8r5DNRplUMI9dibaTtlGpx6YH
X-Received: by 2002:a17:90a:e7d0:b0:3b4:a90:7f3b with SMTP id 98e67ed59e1d1-3b41c97c98amr3317137a91.56.1795186787223;
        Fri, 20 Nov 2026 06:59:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm4660624a91.0.2026.11.20.06.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hare@suse.de,
	bvanassche@acm.org
Subject: Re: [PATCH] scsi: target: tcm_fc: reject overlapping write-data frames
Date: Fri, 20 Nov 2026 23:59:41 +0900
Message-ID: <20261120145941.3127955-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
References: <506886f3051941899c26b3dd4d2a32a3c0cf9846.1791812937.git.yhlee@isslab.korea.ac.kr>
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

On Mon, Oct 12, 2026 at 10:51:59PM +0900, Yehyeong Lee wrote:
> ft_recv_write_data() executes a WRITE once the received byte count reaches
> se_cmd->data_length.  Frames are placed by their FCP relative offset but
> nothing tracks which offsets were filled, so an initiator that sends two
> frames at the same offset reaches data_length with part of the buffer never
> written: two 4096-byte frames at offset 0 of an 8192-byte write get the
> count to 8192 and leave the second half untouched.

This is superseded by v2:
  https://lore.kernel.org/all/20261012153502.2435483-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
