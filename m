Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186903;
	b=URp9Qtrof6Nujn7/HAOq1OTaJiEHhhhJ4RsmVaFj3Ng4tJOqlP8yNYNViDPR3CI6Pt05
	 0cVFLYSyMkIat7j6xAssaVeFtcV9UfFfwnct3iVGWCiCHWiLMQ3bl+JXByIT87pSpzIiK
	 VCAxZggxEw31XJss2Y10PQLpeEgxItAKRLJQOUVSankS/tQu7aV+ImA/c+p34VfKXnmyX
	 y6j4m+nT/mM6Vghp4uAkUEKLYBXx7lJvRkY7D6lzDIkPvVP06REMYHi7ZdiImEQWrSqXt
	 y9Vbgm8ztOBmRT/atGHX55dMKDMBK2raQDQ7iIHByB6SBUQQd5ChGKbRESlS6ci4hWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186903;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aUKl5uun6K1IYcbSDOkhJjIoRsG1dFhoyOQzbur6oQs=;
	b=s4bcbqwdBo0AQhC6k4SRDNvBdaBTDwhAq2whsdWcFAxYdrEegh3FjYhR9753JEnG8xzj
	 N/7WV55dwu7sKw7bpb1ZcV6XFOECBNDdZ5EI9B1ZjSaojZ1tVnm2aCBnoF/dOoq2MOWEL
	 fgLJLE98t5Vo4e9A/t86e8iKL23pMIZ3IOnDiyqXLj3Pu3SIUHbrIe0nUm/xM+TAeD9Hx
	 C6VPX4O4zSdRPv8BABSY6PdjOSyrVp08JgB+tJkC4dqUecJ7tl7xsZVzIaQ2tOLEjjc5Z
	 WECWc3QUe6triXqU0cs6z1JneOWDLGAYrs7jTJfQpjYcX+8GV23OHvbegxN1L13Nm+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oDjDQUlr;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B791D606A830
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B791D606A830
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oDjDQUlr
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc147d86bebso561623a12.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186902; x=1795791702; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aUKl5uun6K1IYcbSDOkhJjIoRsG1dFhoyOQzbur6oQs=;
        b=oDjDQUlrOmSFk2QDYknfQKEG5sCRn84GhjqrmRVYHdQYciNvWi4ANxGrRHRrd1ccV9
         /5SRc+jOgTmuV/gZ7/C5q7CNmRo20O55SOifHQHSV0e2djtryOwvGKHRTy+Cu2dBndSb
         823hZSA+we8AsSY2468ITes+IM4kbp6RwHQkRoUbs/6ToXlSuSRwrrRPl/yiVT+3wV6A
         gXbonlmLCARF0yDx24XMT9Pv7Nc9AaWqhmVhefm2ngK88uPA357e/XzHLTDjSnysNd6v
         2MVManmYPHlrUtGo+gIBDe31vGpYcR4L/sS39mqRUGTqOlVSaUaExZLAzdCb2zTr3/HL
         v4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186902; x=1795791702;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aUKl5uun6K1IYcbSDOkhJjIoRsG1dFhoyOQzbur6oQs=;
        b=E+IqsW+n8IqsR5P/Ja9J9s6kMKWuItocvvSJsmHVYfUwlJVe7yskePILGbmFgkPbSm
         d1/kkEqaQWGoQf/T+cxbbi0Mpb4vN1hU3gFhWxrpD+Tuvjp7fWhXkCvo00WcobGl83nW
         l6sLCBHZS+BKnNu34E/rP76OOJVmQtzFA9ZoT1DxSsotbHGw/Zjz4gARsS8qR8AwVAFU
         jERbURFnaQV5IiAP777G3PRKeeQye2wAN6nk+sXH5C9c8EaeiHYkHhFM3Rn5wiMR2Snd
         2EwvsDDFpiouoE74t/oxCz889yeZWAoFeS0kQWr1d58cKt5TGAQbqZrDkteTFtWmizZp
         7bHg==
X-Forwarded-Encrypted: i=1; AL+hErGhQgM9ij2yqLo6RPimBYj7dI/R9V7yN45BFUbz6owq2z1vCdkx+CDAUUPkqpJ2vgGbcw42DAq0WfJIpps=@vger.kernel.org
X-Gm-Message-State: APuU4Z8O7ONQwHHA1sgh4I8kBo1hz/6UvEIHyz3+Stptr3lc+gpPzqFj
	Tz1zGTQw7TOOpJx0M18Htw4cL1ccM6nW+fUUx9RQ37SFkR6WVPddSNuUidxQpIF5IUI=
X-Gm-Gg: AZFdTZcxwZbZmU1X7nPhjGAYSe59OflFe7phVMrlfrbGxH5PnXuY7lboz/8r0RbRy6Z
	rku5tV7Pkecdit1BLV9HpFRiUlIeP77QddBufqyJS6wIchiQAPsiVV+pf+hgwxnKUORJNVZBfDM
	T3Q/1ExyLa9785HLu8hm3W3hKHbCgBr1HOQCNTU24Zaxk3pNEB5rrklJTPsvxJTFrNJsxhrTTVf
	YNNWYUp8CPx2y5swD13xOKIyWxNzKKf8jO2pdu6eL9xMhXh8HgzUm5ECjadHMq0LCMP6nW53ZSc
	K1omjpDSz21zql/GohdW9mTInCRzqhsquDJKW/SvQ77ALvDXLC/M69qdjOgaQ9tliSPhUQhQV3w
	RKAgyJNb4F221vXFBBk4A0qrea+qckraSY+cqXdOT5XmA2+uPsTQehh+QJ54UbmLJfcXU9rAp4O
	xsAXA0klvS0pAeMnZxDeRzWm2rfqge9s0hyfFA8I0Vody6vW4z+E+bfNYuKPus6CN1I3I/fPKQw
	PAJEo3FWiJNCZrid6asJ3iOi07h+cnAg6jpvEq6vhjt6ipSZDHgOUb2+N8lG/otuouS8WyHPPpR
	IqKyGd7aVp9wOESDXOEV80FtBo0EUqVA9fk5SWsAu1QET2oduY+Kr3LZOmdkD850OUd8gaQQVOS
	9EzqjoTK0aHyUF/MFj8lCrHcVn3NBfaKmZW33
X-Received: by 2002:a17:90a:e70c:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3b41c7bc5a5mr2410758a91.3.1795186902056;
        Fri, 20 Nov 2026 07:01:42 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm4720383a91.6.2026.11.20.07.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:41 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Sat, 21 Nov 2026 00:01:37 +0900
Message-ID: <20261120150137.3128398-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
References: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Oct 13, 2026 at 09:58:54AM +0900, Yehyeong Lee wrote:
> usbg_data_write_cmpl() commits the WRITE buffer to the backend as soon as
> the OUT request completes successfully, looking only at req->status and
> never at req->actual.  A host that declares an 8192-byte WRITE but ends the
> data-out after 4096 bytes still reaches target_execute_cmd() with the full
> length.

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
