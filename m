Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005620;
	b=vXDy846w7hOgqs+Gzqzs3rSDGOSZDgNjLv7ilzFgEKCMUsOInnl2x2ZcyQS0bp1BVEGE
	 b7ySuFH2Yi2H641Qkllssk/ag9+EdM+HfJf7C5BtHsi1URPhAKn9GPvoW3dSj4fkF3RSm
	 e7YhA9owyJonlL2JV624cIS5dNX5P3reckfJxNRthRjOarB/z6NoXd9l3FgX/LNNxY721
	 rl/ypRU4jcydeLmVgZs5MyP1jEKkVvZCwrZw2a9MyjyTANcRBMjpzMzpAfovd9cFL1hPh
	 sa6uane/olnRaNglKHGV4Jb21ZYJw6pRHv0vrX6guLxZxAQ5kuB6IAsrZbBPmId+5BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5u9A3PL16118dnwDzUsQLtTXzEbAMsk2owyLQhcCKJA=;
	b=lLdpZYpagx1r59Z16umP2+0I7+jVD3q3G4C0KhMZCUyYr6Nnf3BpiZCCwgXywcwgE4AJ
	 jBVTLoRO85dOMRozqK5lKSyW84lwT+w3vZaGhAJE6rO1CZIaULbn94YS1MSfmFK8o5KGW
	 i93ZDekbWa2kuH3c25TzMnxfmn78hs8Bno3pux85uKAv12a22vTi4upaRqd+XRTHwOybi
	 5G2tScVFNzJsiVQpCSmp6GkZQSakkxwXA3+s0kiMDoHZvBrNcNdRRIOS5AWbsLQtudrDc
	 Gc/S/odAxe1AevuSr8t88LQAQVO3U1LYVBVdF9UJ0JHnQfnY1J146VBDGpUmo5EyGpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fjXVeMEP;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBB1606A31C
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:40:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BBB1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fjXVeMEP
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso489576a91.2
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005618; x=1795610418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5u9A3PL16118dnwDzUsQLtTXzEbAMsk2owyLQhcCKJA=;
        b=fjXVeMEPXANBKTkfuitkhxYl4brjaF4kq+WAE1yMT4ZeBGhEKJ9Rag192Ozcpj3g9s
         ZyG2it/ZAVFK+Gdag4q3vNXEFSQZ7TErvrgKKVa0zN3tsRoSAjd477wvZz00KsLYB/fK
         q/GYPIjen06QV0sT8lPYehmyRMiwJTavo7fPnS2ffcB2D+8ezhYJRpgGb15D8gcjxDBX
         vGsYEjKxFYVk8aviP2acTMSq75ELzaRz+jRDFRNulWvTza3el9/K7Br0B2PG5mTEVvbE
         0/SRCQdFrmonZJstIJ3DHKo7Doo2wPLavTa8cfbT1EhTB4TvneOG1SPzgNGR/jwlL0sA
         AVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005618; x=1795610418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5u9A3PL16118dnwDzUsQLtTXzEbAMsk2owyLQhcCKJA=;
        b=wPHB+vDdBpLqsDvMys+emEg+KxeiaM+YxvUmC8jdd+9x6T/SCo3iaDVxxnFztgKZSg
         80O/NVv6khduWw9fgTRLGx9ndITVa68HIvK3P4fR/S9pPO1P3fXORWDDptVdS+r5t+M5
         8/hp3uAkCNM2eGWTYzx4K+E735YzGMhTaN7aPdlgJWg1kdw146wmHVxkj51V6VRoX+Gu
         trSCE9H9YT53gyaSDxGzNaNmJJHBxyHhBCFSsSa3XQgXqX3BMHoZnJXdQefeYoFVLYrV
         0XGvFNe9AqBahCnA0mOJnOHVkmy0x4MbwXB3gcHa4IEQTjsTiA2zcGoaELWh9qTbUCLe
         1Sbw==
X-Forwarded-Encrypted: i=1; AL+hErGqP23tw3mB8HPkFhpM7+VHRVNuJjVMRmBqOOx803T2Nq+Rec1w8mEmw2roK0wpm05nBKydB89MAMMlZfo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9s6oFOXuCUavu2YeBEahiQ8lVZHOIdKjkC2myV+L+d0kcRuei3
	gYR/ME65QoP7VVAhG9XRF2ng5LmfCIk9SMocNUK/tiO75DoVF0wgU7QmbYv9NMLYhOg=
X-Gm-Gg: AZFdTZc3ScrhUy8N3GYFbFlb6nTIl1PUiJPrY/8XDw9bcQ/HAv9TIrtUu27Uazoxhg8
	q/lRkz/oFIBMxOfzMB8FsN7uXtUdVmIToD3pG1cahDFujxeNuy10ZKYT543hmlWuSwUcVbKXR7d
	seAWAumPEWvIeoiH2woHryywA/Q8goyR02Ibg5nqkB8f7hUUO5deCZEUi/XFwdcDzaW4s1n1Pc7
	r7w7SYJFIsjDAwUzu3bGVRGmBTMcoEFhYRe6TGlJMi/VoT3rRF6abnd704MSmBu22Y4HMyWr3W3
	VN2eODXAvZuVPr98mIgys1d6njRlVgymR7NouVV3hbiCz/xy9cRKyWefNePgOOPpMgfLkDbTnD6
	SBb1U1W1bfEqMzylxUejXpmJqWBIHAFkTnrYWiFitZvN/RXuuk8X1tPaJdbTcureHwGU9AaG8XK
	H0zWDY4ofkg6GgjNm+5acAtbOhMW5IoVnOJ25Fn+StXTRImUAEuwmnIxr0gi10lNYTGCb25hCpD
	LFPRmyB5sIOkisJqUe2GCQ94yBIYvOHUDB5eVYqpme0bt1xlnVm+S5QkNx9Xgx4o3TsSgoNffjp
	HLwOFQ32yrbtVWcP4kVklrmmcLIvV2sf3PnHEz9yeSUT88QlTGwgcKaQZYfMm1kEa2KxihWMPqw
	muIL/723i1b3RFx/uldVV0poT6WsNF8sEc7irzqBi4DIMdflYxBkVn9+J1A4=
X-Received: by 2002:a17:90b:2642:b0:3b0:9a1b:b708 with SMTP id 98e67ed59e1d1-3b3d07da3cbmr2529004a91.62.1795005618178;
        Wed, 18 Nov 2026 04:40:18 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d19b6e18sm4257980a91.10.2026.11.18.04.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:40:17 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v8 0/4] usb: gadget: f_tcm: fix infoleaks, sleep, and UAF in the BOT path
Date: Wed, 18 Nov 2026 21:40:01 +0900
Message-ID: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

v7 was three patches, posted 2026-10-13 and not applied:
https://lore.kernel.org/all/20261013073328.2936318-1-yhlee@isslab.korea.ac.kr/

Changes since v7: a new 2/4 for a second infoleak in the same BOT status
path, a measurement added to 3/4, and the recipient list corrected - v7
left out the gadget maintainer.  The other three are unchanged, on
7.4-rc3, where the file is byte for byte what v7 was written against.

1/4 queues the two BOT status requests that run from endpoint completion
callbacks with GFP_ATOMIC instead of GFP_KERNEL.

2/4 allocates the CBW buffer with kzalloc().  Only the 31-byte CBW is
ever written into it, and when a command is rejected before its data
stage the status path sends that buffer to the host for as long a
transfer as the host asked for.

3/4 fails a write whose data stage delivered less than the CBW declared,
instead of committing the untouched tail of the bounce buffer.  4/4
clears req->sg and req->num_sgs when the BOT status request is reused, so
an sg-capable controller is not handed a freed scatter list.

Measured on a dummy_hcd gadget with KASAN, one fresh boot per cell, two
cells per arm, speaking BOT over usbfs so a CBW can declare one length
and the data stage deliver another.

  WRITE(10) declaring 8192, 4000 delivered on a short packet
    7.4-rc3   CSW status 0, and 4192 bytes the host never sent are
              committed and read back
    this set  CSW status 1, nothing committed
  a rejected IN command declaring 4096 bytes
    both      4096 bytes returned, 72 of them non-zero and the rest
              zero, starting with the previous CBW.  What 2/4 removes
              is the part of the buffer no CBW ever writes, and that
              part read back zero on this allocator too, so the patch
              does not change what this test sees.
  login, read, write, readback controls   pass on both, KASAN 0

1/4 and 4/4 are not exercised there: dummy_hcd ignores the gfp flags in
its queue callback and never sets sg_supported.  4/4's evidence is a test
module standing in for an sg-capable controller; 1/4's is the code.

Yehyeong Lee (4):
  usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
  usb: gadget: f_tcm: zero the CBW buffer the status path sends
  usb: gadget: f_tcm: reject a short write data-out transfer
  usb: gadget: f_tcm: clear the scatter list when reusing the BOT status
    request

 drivers/usb/gadget/function/f_tcm.c | 23 +++++++++++++++++------
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 18 insertions(+), 6 deletions(-)

-- 
2.43.0

