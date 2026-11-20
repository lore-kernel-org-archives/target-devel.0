Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195726;
	b=gutSbyo6wYavBGZAo7DqBbfFp2rmUzk1Yy6LWWFkNctgOmAwQJfgtwy7/+5Op2xXfbrj
	 MD0HR5aYsMtLPLr0Pgif3dmeJ1AfwgMf0hvVmBoqV8yjy0eMHFUGfPujkXqj8UlncUJbD
	 H12wRcWZJMlfhtbqzjQBClM0UrLIx7TQ79nR+j18YitqrM1mcdI3ifIBTzOt6wbAs10um
	 jh+0sBnFD2XBIkJQUzwjkZDSDh15bSgDW1LkQQG4hNkhsG+0ZxlxLVI21X7XSjoAD+40D
	 81Tvnfyefvm/+3Csr7TO94Go2TvBRWpcZ9Wif3fi0u2tAtfT1QYznf46aaeY7zXRaKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195726;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/lQFrumXY/eO2ACD5OArHzMhyMrdljnPb2HKCmNt8i0=;
	b=ibgGH/wJbwEOUByls7a3/DVrRFKJstrsLabltT9+buHePqEj30srMCMM/RB7ZpU11QzW
	 Dui6LtJ09UR2YwmalzuKeXTSdEefc2GEq8R9h5VO3s5i7ObbFPj6F/VCAXvtSzCq8+ABs
	 N8Hgwc7xnyblbLE09aP/hihdiHE1eAgPBxNxIE8TD1bJ9c+y/j6wKaBH7gFuJr7SW3Cnh
	 ezvKikXJ1qGxzDwRrlcDms4aaiOodVf+H15uj+gQwjwkPsaDgUoNGnZQf7fCfkwRlV/Au
	 A/zbHsMoamRS+vZ2HGD6oDHUvPzX4X4GVs3nGvuRfHjqk4R8jqSOWIwW+4jOBAebw6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dfH6Gy+a;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA7D606A320
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 17:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BA7D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dfH6Gy+a
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-89d6bd67045so575537b3a.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 09:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795195724; x=1795800524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/lQFrumXY/eO2ACD5OArHzMhyMrdljnPb2HKCmNt8i0=;
        b=dfH6Gy+aSviOS1anR7xvcOw6hlW1P/zVeUP1d6jCiadqppqlOXcSVj8En2+UuWYn0p
         eRy+8Vv3YB+V6f7QILp1yqfa3nhh3dL1EClu/RNtmuk92/9v9KAKiD5EE3cXcqAiM/Me
         oZLaMxLnI7HdHnrI4310uvFtDudAq7MI/rrEvLZtkZD47KqvC0ZCpRIDPH90Uq0Mtio+
         NghmoS86I2dFndjeWGz4EpRJjEUSx0eCxI2oMMPDNXKq94zu+tEo6ejO5aub39gTJ+01
         4f2KC3v8fvePDD1wsNeGaskua9ba9CfoWx2mIhGP/mMoyIHj9ZBq6j6223BfTGiHZSdq
         vgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195724; x=1795800524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/lQFrumXY/eO2ACD5OArHzMhyMrdljnPb2HKCmNt8i0=;
        b=ngGhyuZWNJX7ohaYgDNS2nPPTHqDZtkuizNTLFJUp9u6DvGEh9Ieylc8sQe8ztxNhM
         Yej5yujXDz3i5WhyvoH4L4dlqZPNnIpc5JqVGu8utwIjpcnA6HI0VIwe4h7DBiSdX1yB
         G0XJWVqL4hrCbIQQ1R3J5lBrGFixq3UrBPWhyBLLBtxKPzM4plcbcI1m/WDYB1BgI4rK
         PEasePE/lITs2tz+LW1RBqBIVweZYmEv372LM/gCTo231JDBXc6TD5FYK+ul4SoNiDV3
         mNpX5D96orQ3zp4X7tcB1QCq2KgApKqgjvcGKR+JRHes1te0DsN/nsFHGxl55y7Dy//y
         k+jg==
X-Forwarded-Encrypted: i=1; AL+hErFt5vyg5EqlOhZfGQKVrf6AItpyaL94+z7sTzBDI6zGqXVfMO7T1YUjwFiqjmyAIyDYC1rY95fRu0Nhq0Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z+HsrkatYSg+IcqwxEy+Letxq0SkUGNUR7Keynwwdm5+y+shTrZ
	lGiPGuTQheh79lm8qbc77znJCfcny5Qdn76UqlgQqavRRH2Z77QceHGKad4aNzGpEss=
X-Gm-Gg: AZFdTZd20gllhLmsK85rxP0Ya+8WLiaN5/m8O/lzA2dDb9BH4C+L3E98j0ytzEGQcWb
	ZD7KjkJ8d3LQgQEVS7bzJDHJFdkKQqTVrl/83ZT4C0sACx8rULoVEBsvX9ISOnJKzil3Uiu5ie2
	8/DSAaEXLAXIEjYW+xoqFNRlataohQcXWX3C/wB6Uyvs68nAQdPDL4WFYltdzrA1lD9cSfy1b+O
	whP4+hoI2ySnJeDY/D9DCPnqkqCa2+qr/GGdKoeeIBOOmU70w/d/rUB1x7iknKpZlLK0dm1Vjn+
	nDo9RtwnQ8s1AxaScOAgAb9gVYyTAwyGh3Kxcs7nd5PgqBhcslCL5eisWUzuQZFa++Q2PzOpZzJ
	vm0a42ZJoLuWDDYwJn/qQeBXvZrTFjX06hmYR7i1nTWgT9kJo8RRq2hJCPM+Kkg156m/f1psODJ
	qVeCBHQkqx08wAYWJubHdccVTRIRlqWC0DWA8YFcK4fbHb2uG1pIrUmea+08lqSp2rRmNQeqAuI
	XbrwSqMyN1Fg9gtZvVGYVERwh6OZIVlL2y53yubRipXEMYSDpzD6lc0p4ttFg/lpX6+V7PwM1zg
	RNwz2Y+GcMKB+jo16JRrKqY0TWrXoSOPZ3DW2KYn8yMXWfCVcnoqgqW0Cec8ZOSnT8X8OXdw8A4
	WIHF2ITpu3pyUrjDBRtL/o6PjK0qzhIKZ7l3f
X-Received: by 2002:a05:6a00:3003:b0:8a0:550f:bb43 with SMTP id d2e1a72fcca58-8c7ddfb0281mr3651179b3a.34.1795195724025;
        Fri, 20 Nov 2026 09:28:44 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87334890csm1867911b3a.33.2026.11.20.09.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:28:43 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v9 0/3] usb: gadget: f_tcm: fix infoleaks and a UAF in the BOT path
Date: Sat, 21 Nov 2026 02:28:26 +0900
Message-ID: <20261120172829.3286180-1-yhlee@isslab.korea.ac.kr>
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

Three remote-triggerable bugs in the f_tcm BOT path: two infoleaks to the
host and a freed scatter list handed to the controller.

The first patch of v8 is in usb-linus as 69b3b657087f, so this is the
remaining three.  v8 was posted here:

https://lore.kernel.org/r/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (3):
  usb: gadget: f_tcm: zero the CBW buffer the status path sends
  usb: gadget: f_tcm: reject a short write data-out transfer
  usb: gadget: f_tcm: clear the scatter list when reusing the BOT status
    request

 drivers/usb/gadget/function/f_tcm.c | 14 +++++++++++---
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.43.0

