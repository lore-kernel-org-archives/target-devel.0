Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174469;
	b=lmsgVVeVrysf+FZT8u1xp8hfvh+XOlG6xOZWVi9CorVGVRl0OPUua5YJh3wvBOdmzlO2
	 DtktUqfBTkBhbjEUyPxDHG/k+1hyXTYTLJ56BfDww2a9ulstD4bAsS289za7q6IJE4ULc
	 Pp4KNdMUmFwSzOhyCNAW8FDaMZ+xmPw/emkXTj1XdXPPqeFIkZ8njwkJUq6SoTTni61A7
	 e3bLMjgVzEZ53CKuEHlSIMP4n3+99FV3gSctPL0y9ap1iikHj36Ranfu/ILGfNM7oB+GM
	 zV5A/wtLNSEeXQ0jsBy3fkCtFGUPX6J7mBvLQvDu7yw70mPf0wiVLTM5yIMNcbKb+ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
	b=elg/Z2ecEqayJxTaaBVTcubw+sSE8H2OHVcRT/Kkn/zW/gdi/s5Xcp9n86JD/RAhVg3I
	 G8d68M+e6lW2GHHArxWyRilepwWtFwxioaQX6xyQsCtB34dkOa0iXheYONpojvgU/aLlz
	 NLmPqZSOnmcbfPox+SraY6UmYQjduft8lyB9yc1oGWoB7/oPG3fhp/yM6N0BYYOCSFz8r
	 JsN8xSQ3hBXHNUCCqfcbM4RuWcvXDjg9+cS6Ojwn4ix26MPN6TzIoZFL/NQ+PlLSByFAI
	 2pySGsFymG90MrfJXG99V65vli9iFAFbCLSy0h0mrY1ZyoYwhmR/mUGv9fy1PluFYjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JEjh0Mo2;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2FB606A326
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B2FB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JEjh0Mo2
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2f03eeda984so3834125ad.2
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174468; x=1795779268; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=JEjh0Mo2J0GsDfI03WQPh3umBFOzvFjidFR4Q0F/wRq9gw/lREToR6fv6Ed1SmdVjq
         aIaEGXVO5lH71Uhn+sO7s6PbFMOtP7Ph7MY9NT7YHhni5hO6FdDjR3w8vAvXaEGjxshl
         fCz73IBjqrqbz5Aybo/TpNzG4g6zEvGv4oFLSIw1ddfVNEDOX9qQH0/BUT+Y63pFiZND
         YKAPIYRCSmjIA5MXwFMY6sXc4yhQaJSzTxx02/hQHNPfI6jmBzWf3OUBrrIfYmYuSajW
         cYZf5O2ySA7exWa0uL2I8uss4OWF2FE9uSn9wl5N6FxDQJNtQYhYC8ve6bTTxQZIzm5q
         PhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174468; x=1795779268;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcboF+7Ibrmdu8GyKDhEBakGgWL/6zJDq2Y724rkq5A=;
        b=bUD5VOXoH9Dh+lYa5IH/DIpP2nSiHgt9aoi4u1UhW7JqDNAfLG5PqR0ozk8/+dFDvb
         9NAqQF1n860KSHLuhZfZorBGdPqvUOy9jKAdjTV6DVhdlByUrTAwRGU2EcbXEmvqfvx6
         lDRSoyDnbeDDojD0RVjMUc04l2bfK8AM0SQKag6fLntB/gLsieBaL/bn4M9Z0dNrtdFk
         WJ787t6pO19xTu0mUa4cOj1VjoTT9T3ekPKNpeSwwGiOpaq2IhLRQgnOIHEIHCPncds+
         ZuZgcvj1ZcNjrpbJo/5FyrPncTWsrwYi4G8OnfQJtdRlfxmMnztOMM4ZSvDbLTLrydI8
         8eGQ==
X-Forwarded-Encrypted: i=1; AL+hErEmq0XLsxK8edptVc2R4GepayeFzdea1PT2jYAjwi3N65GMgqzwUf3aJ+pce71OurmjMtCWaff+lJ9G9uE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+rOMj1wqtXMLHepVCszxuTzBiQcivKZErwUcy2vqRTCrbzV806
	3IMT87AuiQ/YtQryNezpfF3sDrlPprshB+BTkH5C4v99DAdAmig0fS+V/6fk8pO3lf4=
X-Gm-Gg: AZFdTZe9stgdJzRr3fYoMaA8rmQNU40vsQUd5mQrz7kkx6C98Z73WC1yIvGyDU0DAs3
	Vt1dztkaFfHw4uAdUKhYaFIz9mxaPBjF/3Lw87tiW981Bgp5FxxxVKz0sk4TfePCzY5ECsorEsi
	m1Pgh5Vg84mYpIK6xxCJe4F0eBBcmre8vK7gpxZOW/H0JRMOWLI436Y5N9GrVOZzfBkKmirKzxA
	c0TPZ1YJDLG+wG8qWjhHnz3CB8h4P21W1uGaVxfxdW+7t1hncqmvC8plP3mEj0QfvA0uJAWFwxu
	/j17VxmqZBmftdrmiw44xGbHG5G9a0aP4q89tWhNdYbZ6z3ufSg58f69JAtzrEJldiO4EGnc+3I
	n9xT1cYkHPtFh3Zm7dcaqDjuVAyzgK+XBwM3Rc5zPiRKV9nZ0XiwR9+PXg30rZeIOIEe2dyQO2R
	Esni0SZrInche9Qvh9QKxK6/kgYELHqnvpo7DKxblkFegXq2hEQw2eOJbWpmmiET+hs+NoKsUw1
	FNZN3myn04xgoev0+WEo+Wnjb0ZReOM5T1rrNU+Yz1Gx480vtq98S/xFWaaFLDtEaMVnxpevP6W
	bRGH5nlb7uPpNAvwQPePvd3krWtBrYVR/nP9zPkCd2qWZtrDP5scDSksLqI6u5zj0LT4JIoBgxi
	EI0oi4H7cFDAoA1Nuuzd/u0uYXgFgWLvxRUnkuHDGj+DlY+QltnYht6SIpg==
X-Received: by 2002:a17:902:ec82:b0:2ef:f3ce:1e91 with SMTP id d9443c01a7336-2f03f17ce3emr31129885ad.9.1795174468638;
        Fri, 20 Nov 2026 03:34:28 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f04913a77csm5741675ad.34.2026.11.20.03.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:34:28 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Fri, 20 Nov 2026 20:34:23 +0900
Message-ID: <20261120113423.3069216-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012154422.2436134-1-yhlee@isslab.korea.ac.kr>
References: <20261012154422.2436134-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
