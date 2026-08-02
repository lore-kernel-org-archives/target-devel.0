Received: from mailer241.gate86.rs.smtp.com (mailer241.gate86.rs.smtp.com [74.91.86.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF0314D1A
	for <target-devel@vger.kernel.org>; Sun,  2 Aug 2026 20:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.91.86.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785701075; cv=none; b=TeZHisJPdvZH8E2QFj4Tv0GW7zaEJMjeB9Z24u4ENXFdlTPrpDe0VAx1s/jQPsKsUd7S2BeKvM1O02rr5TOlvR9LUJmHcztn0LrEyNHVI1vW4Uw5rM515tMnu+ql7K0oZ9ruXGS+s4+BEWl+6Rm5O9iPxXNalJrIqDDPYKr7/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785701075; c=relaxed/simple;
	bh=qltARmYzXUm3qHAeK/h0ZIoqQNWedRlot+Q0d5xsxlg=;
	h=From:Subject:To:Content-Type:Date:Message-Id; b=Wqvpz3dqXh4iC74b6h9aAaRNayUw8BtJcxvmLQkaf1piGnCSg6/xWTLBacTARaL6/kDc4WvzC5WSLYMe+ows9p9f++EXl89Wl3vL+VwKcuri0XLbEAA8Ie5WuQGLUAFCSFOCgNuibWpkVILSWcbf4hgfbFjf2gTE8VdI7Ecft7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com; spf=pass smtp.mailfrom=computergamingpc.com; dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b=bcr1EQZJ; dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b=MM8g7Tfq; arc=none smtp.client-ip=74.91.86.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b="bcr1EQZJ";
	dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b="MM8g7Tfq"
X-Report-Abuse: SMTP.com is an email service provider. Our abuse team cares
 about your feedback. Please contact abuse@smtp.com for further investigation.
Received: from [10.0.16.126] (unknown [10.138.12.203])
	by mtl-mta02-out1 (Halon) with ESMTP
	id 100b171d-a7af-4569-a776-cefa5fb2ddc8;
	Sun, 02 Aug 2026 20:04:33 +0000 (UTC)
Received: Received from 10.138.12.169 by Caffeine
 (s0-aws-app2-swarm-manager-3) with SMTP id
 9c567019-8e1b-4e61-bad1-a6028bb27bc0  for target-devel@vger.kernel.org;
  Sun, 02 Aug 2026 20:04:19 +0000 (UTC)
Feedback-ID: 9194450:SMTPCOM
Received: from ObaTech (unknown [191.177.202.7])
	by s0-aws-app2-mta-in-2 (Halon) with ESMTPSA
	id 9c567019-8e1b-4e61-bad1-a6028bb27bc0;
	Sun, 02 Aug 2026 20:04:19 +0000 (UTC)
From: "Computer Gaming pc" <sales@computergamingpc.com>
Subject: Availability Update: Memory, GPU & Server Components
To: <target-devel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Reply-To: <sales@computergamingpc.com>
Date: Sun, 2 Aug 2026 21:04:19 +0100
Message-Id: <02182026080421C6D3C521BE-AEC90AD0A3@computergamingpc.com>
X-SMTPCOM-Sender-ID: 9194450
X-SMTPCOM-Tracking-Number: 9c567019-8e1b-4e61-bad1-a6028bb27bc0
X-SMTPCOM-Message-ID: 61ba7e99-c469-4e0c-ae15-28dc08ebdad3
X-SMTPCOM-Payload: 
 vV50iWwD2EatlawlDYfW17JRB3Jd33Gl7JHtVZ0z-hOjoblHeL-PtTfkrA_Nbz20Lpxp8jmC_fJt4hK76eiJK8jdcslM7DjO2M3BZqLFEKkEqrtr69UpngCPKFM-JjkU3miQ9qT_EZ96a_iHXgIFPEGaHWj5iv5CNV6aJmzW-_oXtic-qmk7taw9QO6F8_fsPqTavw23I8Ek9fApY_SApg==
List-Unsubscribe-Post: List-Unsubscribe=One-Click
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=computergamingpc.com; i=@computergamingpc.com; q=dns/txt; s=smtpkey;
 t=1785701065; h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=qltARmYzXUm3qHAeK/h0ZIoqQNWedRlot+Q0d5xsxlg=;
 b=bcr1EQZJ1bFazBfzciVehhFfHclYjVyjqVGHw4GcdKq4WdrT3cP+iHz3U0AI0H6K2u0vQ
 xo4FtgpD5J2IwQN/w9USD/uyXKKtmccm+ZCic8Y3zGq5f482SKV1Y1aKeY13vrOQisEP4tI
 LxKLJLUDuHhK+ThT+vbPYsWv79iLYnpzeFzqzbt3y3xFc5FM7MhO3geJA6XZvytfAmjXFIa
 Q7PCWzhKROiv4rfc44jiVoxODOwXJgfT8l+zJNAmM8nWXZmvmXUmPNp6h9+FdSMMvII14gX
 ljKBbnSC85KIlFpAn4uEnrmBEmRQDoqf1tV9Oam8m1QTHGrexmtA+M2ZFyfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=smtpmessage.com;
 i=@smtpmessage.com; q=dns/txt; s=smtpcustomer; t=1785701065;
 h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=qltARmYzXUm3qHAeK/h0ZIoqQNWedRlot+Q0d5xsxlg=;
 b=MM8g7TfqL2ZPfyUheBTS/YVxt2jTScP69zlTlIWjnBgC9nr1bCzF1+z8oNsMoL58yZk8g
 G3Un8uLKhl842NIyJnSA0xSpPtHliXDVtRzOxFGJlF1xA920IrZm6tSprBpS80yOl7wIdCT
 ooGZPgmVH9XCgg6SuESHezutsZe/XCd/7frWtXoH1ib/FblzGWo1eJCNgIfqQR/9VrbFcL0
 SOW2ltDbVCfrRDsgIm3jCdDzp8E2D+aXqqhuDQ3Y1C9hZV7M6ISLCRc9NrM+GZVbuxhHlIK
 lALSeD5oXUNKbCMTlp7ic0ob46N8VGdpbcJgcjMEb0G0GvuSEJiCjYxo114w==
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>

Dear Partner,
We’re pleased to share a current snapshot of our available inventory for
immediate dispatch.

Memory Modules
32GB 2Rx4 PC4-2400T (1,500 units) – $40
32GB 2Rx4 PC4-3200AA (1,500 units) – $40
16GB 2Rx8 PC4-3200AA (1,500 units) – $20
128GB 4DRx4 DDR4 PC4-2933Y REG ECC LRDIMM (980 units) – $170
- DDR5 64GB 4800Mhz ECC RDimm 2Rx4 Samsung (Qty: 500) – $750.00
- DDR5 64GB 5600Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) – $850.00

GPUs & Accelerators
RTX 5090 Founders Edition 32GB (90 units) – $2,800
RTX 4090 24GB (45 units) – $1,700
RTX 4090 Founders Edition 24GB (90 units) – $2,500
RTX A6000 48GB Ada (54 units) – $1,100
RTX 6000 48GB Ada (51 units) – $1,200
Nvidia L40s GPU (12 units) – $3,000
Nvidia H100 80GB PCIe (9 units) – $20,000
Nvidia PRO 6000 96G Server Edition - $10,000.00 QTY: 17
Storage & CPUs
Samsung PM9A3 2.5" SSD PCIe 4.0 7.68TB (115 units) – $650
7.68TB SAS SSD 2.5" 12G Server Drive (140 units) – $650
Intel Xeon Silver 4214R (120 units) – $140
Intel Xeon Gold 5220R (130 units) – $200
AMD EPYC 7542 (97 units) – $450
Intel Xeon Platinum 8380 (95 units) – $450

For quotes, availability, or inspection scheduling, please reach out 
directly:
sales@computergamingpc.com
Call or WhatsApp: +1(774) 559-1248 | +1 (641)232-4364
Thank you for your continued partnership.
Ann Sam
Computer Gaming PC Trading
2500 US-6, Iowa City, IA 52240, USA
To opt out of future updates, reply with “REMOVE” in the subject line.
