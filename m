Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005625;
	b=rsx6ZQrPZqUpKVLVcEyzRzyLNUzdyavnilA8LA0dtETwC/FYch1zebX4VZmZ3DJIbx/T
	 /LtKN2QPZDFQtSe0OZU/vMz7Oh9fE+RUN74w18p85CX7uIKvKu+B61FYdpfHPpP5xNzcN
	 1x2lnpHNdqmdHlGIYdjIcc1JTxIY8+O24DsPeRQOam+fCI8jp2GgurM8FIoBvvxsa8eo/
	 xH81B8w3bEhDpkdyVUAxZA+YLZRW821Yz9+jrHHgh8gY9Lig+3XpeteDGdPMzUcGk0rvY
	 JNASyiERVcrJLIhSfzSVEygKxD95gA067hoSEy3N683ZFHKhQBvWiRIVzKV6/f1zlqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005625;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pJ96I8CCGvOS56AX9pgEAEbaQ1usEuN94BGKUJKVPo=;
	b=3vmrNqJ1uePUxv8n0ISrUSl31oyBkXRhJ/T3PbONN2eoc8RA2qwLscAOrKTPXJHdYRsy
	 uV3ZC8RNZyemgf2r8T+UNYsGq6yhFRli+5CAnFlhncyw6LZ+hJ+8NlS0y0rTHhv9pWz3F
	 aRsUg/bnHzOFI/L4xhkMsx8Npo1hEXc0b2f73twM+LcXFCYqLf9BGA0vo9gWaPa45pY0+
	 jjipl0M0Y5mHNK+xC8K+ax1OTrfIMehppGPlxycm2DFuDMDNK7c/qUo+z0JNC0Q4n2Z9c
	 f6KsJJJcAZb8hrWcPp7TDF/RlBGq2hNbrcbiC9bc+hMVPjf0RgeQS9veLmPwfo03hAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QYuCHNu8;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FAC606A336
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5FAC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QYuCHNu8
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b197cd42b0so562626a91.2
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005624; x=1795610424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7pJ96I8CCGvOS56AX9pgEAEbaQ1usEuN94BGKUJKVPo=;
        b=QYuCHNu8QiyJp2MmNEq84pI0sM6uyoM03JyUTwEf3p9qB0jGDLOjhNGToBsEVByldX
         Mueu575ttpUYhaEDvPC2u2xhTahftneuoIh7ORw2GCegd4CVy/iGP0v1QPoW49WXCa/0
         BYRb/8pMzvEG1N3th1yKnxl/mVa7G9lF4IU6HqtVveX+bRwVxJVdW8Qa3f13KQ0N15ok
         n7N8BEGML5RYFPICQrFPESxVHejYefI7vPzxR+J7Ct3LszSIv0FwxIRPxqNMchLjLzgO
         wVAP6gUr6Wkyq+snL5d7+igxRnS/XIikZrwrwg7FEmqpU8RKemBOCFo2x4MlKX3McsVt
         g7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005624; x=1795610424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7pJ96I8CCGvOS56AX9pgEAEbaQ1usEuN94BGKUJKVPo=;
        b=wI01sqZkBmfJ3CL01vB4CJ/qwGg5ef7SsMwM+Hq10rPJVYoz2fs5dgXylayD+nqGtf
         Smri0M8WQSISsAdDBKUEXltxv6wZdtNWS1usVOdH1F9smxj6W3TO8PjJRADSyWAnOkN8
         azLiV55NEiyo9Qa47Xz9yErL2NkZVO8k9IUM9d+dMfsyIaaXob4AVMFMBKv3n9OT/47g
         3EtKM1DvIh9Wrk5L5shQ0HiCunu26iEfCYBYnxoNrPJDFn8p6l7W4DdWcrTYKCmeB71K
         qUf48F1km0sxr6UrD9U2qFzpO9x9JS79CeaDwnZjwMIihxW9yURFarVqZV+iSkL4hMu6
         NzfQ==
X-Forwarded-Encrypted: i=1; AL+hErH0F0WEujdmTgwkIqUCtf8VUWajBKtprvlhGfVZ1vnUp0r8hZGQiASlci923GQFl68cVVHbQYg7erNLbFE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/3+2U+IX5gaGGQFDNczs6FvrzCF3UPbUyZBe9AIrtg7AUkcRe5
	gCO/t/fm6IqoUvMe8/kS7ndyZ3EYdXLdbZfeKwBB+oLNhXjuw9AzYkDseOOc1vA8ZPA=
X-Gm-Gg: AZFdTZdZAYWTXB290+ZT2cT2iztkQGMx611vhGrWR/lqII0SHjPl6zFCckfF57Lmtp3
	SQKUORH9YJv7i1iOEGTuTW+LSQIeuddR1Wb5toic4Ujweo/DHFx9GEv4WH3ojFB090XvvHAizVf
	AL3+qfG44exq04S9GJMFt/CEOyGW/JiP7bi0A7EowDmUG8dBqR5og5sA55rI5fc8OzjWtc4RQR+
	QIkNSTW4PdkLnKBFp90+K1gAyGse7CN/W96z11guyY39JwHufipU5DVQdSOKiMLiCCRqoYqx6I1
	53S5d9A3I7tPIyuQUr+E1alHomq5J7/40FWbhIQWDFbSw4MPVA/RjarlwfxGFeVJC/b1T652bmI
	sAXYS0MtqbQJ2sl923FG08v6lKdnxUgrH7TcBPpKwLWzInqRNF6QsQUTGjgeMPU4ZhmjE/ttQL6
	ai2i+cbotJZ7Fihm48hPFsuPjHP6DZdcqES22ARU1JpQ2Z3kTSuaq+ERyFn0KxKYerr2ywwObLA
	onYUypolqj0BBSjUZYV4Jlux7oHcV26UvyY/CimX8DiS1zdGLu9uaMiE0aEjiVgLuHP1UjvDqoQ
	DYjCiSB4rvbtAwr2Onxwi3E82j+w/D9yDbMgyjrgE2aZv64XOGbFZO6yDSq/i4PNFqYWj0AUDnR
	sOCmdjqjoRc2uMaczagSYxgZuJMbgUJkoDwvYBg==
X-Received: by 2002:a17:90b:4c8a:b0:3ac:7c52:fb04 with SMTP id 98e67ed59e1d1-3b3d07d80admr2483888a91.44.1795005624070;
        Wed, 18 Nov 2026 04:40:24 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d19b6e18sm4257980a91.10.2026.11.18.04.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:40:23 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v8 2/4] usb: gadget: f_tcm: zero the CBW buffer the status path sends
Date: Wed, 18 Nov 2026 21:40:03 +0900
Message-ID: <20261118124005.2428068-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
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

bot_prepare_reqs() allocates fu->cmd[0].buf with kmalloc(), one endpoint
maxpacket in size, and the only thing ever written into it is the 31-byte
CBW the host sends.  The rest is never initialised.

When a command is rejected before its data stage, bot_send_bad_status()
points the status request at that same buffer and queues it to the IN
endpoint for a read, and bot_err_compl() re-queues it until the length the
host declared in the CBW is satisfied.  So the host gets the buffer's
contents back, a maxpacket at a time, for as long a transfer as it asked
for, and whatever lies past the CBW it never wrote.

Allocate it with kzalloc().

On a dummy_hcd gadget with a 512-byte bulk maxpacket, a rejected IN
command declaring 4096 bytes returns 4096 bytes to the host, of which 72
are non-zero and begin with the previous CBW's "USBC" signature.  The
part no CBW ever writes read back as zero there, both before and after
this patch, so what that buffer held beforehand was not observed; what
the test does show is that the host is handed a buffer it only ever
wrote 31 bytes of.

Hui Peng's multi-driver fix of 2026-09-19 zeroed this buffer too; the
reviewer asked for it to be split per driver and it was not applied.

Link: https://lore.kernel.org/all/20260919223521.3890508-1-benquike@gmail.com/
Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 12e2b20e33b921..f2e7a9ad77809a 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -330,7 +330,7 @@ static int bot_prepare_reqs(struct f_uas *fu)
 	fu->bot_status.req->complete = bot_status_complete;
 	fu->bot_status.csw.Signature = cpu_to_le32(US_BULK_CS_SIGN);
 
-	fu->cmd[0].buf = kmalloc(fu->ep_out->maxpacket, GFP_KERNEL);
+	fu->cmd[0].buf = kzalloc(fu->ep_out->maxpacket, GFP_KERNEL);
 	if (!fu->cmd[0].buf)
 		goto err_buf;
 
-- 
2.43.0

