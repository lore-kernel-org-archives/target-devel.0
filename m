Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175088;
	b=w7JwWv4Zc0CGqGODWPNv+ycb3QrFMNphFzIorpKicxYXwA3N4cEYuSh7Gf5IyWvlLrTY
	 p7MuPxbLEEJDnU+ggjYDayi8/IAMv+Oih8K4y3gf5wD4yhAyGiD+zMPIiri0rgqoHoxmI
	 cJbK+Tx1OF7tWB0NX8suBK20RZ+g2GQ5zUdHkXgPDXWvK2bhtOouGmIZYsSaevNT5FG06
	 LPaRkjiftdcDkqw21PPHhmikEh66BWZwbf0rg75WP3TsbFc8wBWRhmzF1y0sg8+o2dZ/A
	 ZYqrXgioMq2Q4K68Ps7JASjUGX+zitCPMcQNkIT/sh5X7KBeapfDvVDXJ50y8Jr9rVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
	b=bGLUgxkZYhB5KaDOeNJu5xfFAMxACquqHz5Bdb+oMv4oS/bEhR5Jgmf6JQYiCoawbVj/
	 L16uGieH3AHlHk9THxtcNXiZOenvVKzHMWJyAv0lc+y4YRiEQ8sv75id1/BTWGpe0rbKu
	 G/sqASiE5laahjozHEWv6okE2ZM7SVHlGHkYLRgPP/IU131ZzwyVPh97wgPNC7DuqSJZK
	 klrEf/H6TFZi7/bAErAL6tp6+1GnXCIzzaiQMLTIRuzeX38ygUZgXsWQaM8bkjsVpgYN1
	 ePP0Nm5Qc8pkgsbw2lrBqDiVEjpxlExtJbBx2Ih+9ZjQ07qBKL9IwH2tqdTh8787Ukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VYKf2gRz;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DED60A6F6F
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82DED60A6F6F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VYKf2gRz
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so794671a12.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175088; x=1795779888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=VYKf2gRzQFEWflJPgPiv4oGKQy18k742M+SyPxTjDcV1YzA2HpH+tEith8h3cUYCqS
         ZuHsPGAEFJaEVdHlTn0+7wfNhRpy17x7VUcLO7RcgDKbxaVa8SVFVULOAARCdUgo8MIB
         auec3S/dXTxxBV41FBH7CIdgKi0Pfrtc3PkRXLAM3G3p8FMhi/36apeiTVqxX4b1DT6c
         Z9da1CHxLqdbPb+a/beQVSqOLTW+HbN1Hp3BIYimCZ1zTas5XxTzLR6JZcXyU4+ifSwa
         mDV3bu5Ex5uNRWhErkpkUfWzDPh4/BdFYDj79RFFWOkJPySppnsX4GlX45k1d+ABtV0l
         t5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175088; x=1795779888;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQRBgX2VgkOHD0W+Pmya6gBX/CjSVN896aNxZV8p6ww=;
        b=nNrYuB1DfvNViOxXuDNxoFgKso+C8Ete8L/L1KHyniY65QLjPbAJlaYbg5IWVzFDcM
         peGelHQ6iNn0rAAN1Hv++0QdEne9BsA19F6y1z49rjLVUY0+XUmpwhdJkVj2iU5kyU/C
         vX2aJFnAhCmfNbxPIDxxIu4CjDRlcfxSxvu2cLf6Snc4KTD3QMhw/kriufWbR/DVp2fl
         WpMfS0E95bGGYDBEoe1N6Vjn/vV76ypzWAerCirnhTdxifa7s+wusG6LI3tb2nutadJc
         pNsUP89FkyJJWZaRDI/rKUMoZI6DlDoYL6fNoFMU0pPOTh2V9RUXU4dJiMAaOi9EsiT9
         Dncw==
X-Forwarded-Encrypted: i=1; AL+hErFEcmbeYRQUV4posBiWtc1YefuhnYlMO1naLIGr/IMXxcrWObijTj6op9Wy5/GqL5VKW19Mnx4fzdlI7k4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+F5Hpo5oRp/gOi9sZYvPiCEBSxh25VuQxzY6Rc8O496kQzWNbC
	OJ2nLLP04aj5GaqYuc8JYSKam+mhx8yRjxumw1B3plfBIwcqCjKkAyT8ziVHAOL66Ng=
X-Gm-Gg: AYBFou0VtbwpVtiIZKivtOLyYR3Lz6jQftzX/uc6QPj5PQueUrNt28d0yHPJ2AYv3pz
	HfZfouVnr3XOpQ3eH8JuT+7V7wac1gFH/FeBhUTFkO1+0sB6ANhAfSWo9rmPhLxPXrPt4tuW2RW
	sqmSlvufp1p7eaNY/MDklU680B7Acc+Yaw2XADGRe9k8fFFLVugJet0D8hH/p94T0OLf4QyB85/
	Ms0iFz7EGpJuZp+8UG7xyZw8D9eR34TaC1adFFlLLImGVAXIEXPaZHQuudXURN4WtLbOxATRvNk
	QeuIWbhSeLLwNRD4ELrPonc7JUbwBRkvtlgJ0Ov0zi3A7z6rPF9MbEDrsN/NpCQlRsHr6tlNZTc
	bfn1nLXtbeyGeqQpqtjwBwRWEWdZf2tHhSzqrGlLr8JE9CF8SVjRA3xheMi7L/6HnRYT02qobxJ
	ApHgb9hgpTa+S96tIjXWBvt3/kLVDYGexEKfpiDZYSx2oJcYkawQEfx4x0dWyVeUhYIWoutnLPn
	j7SYJs1I/eYSfUOeLUUoHId5ECIBJzlTA22JvcC/LU5OyIMCz9Lrb74lA/a0iOmJ5v0n3TSpPGm
	+jeu7S0Clmr8clZvWG3QHrNHPR269m939dbSKH4b9wbdH5jaZSYCsJNK9KO+Sp5DCMNroMAvKA6
	9SMdrywOba0Z7hzlZcEyDjBLFX26N1jFGabPL0XWOG9vUO7h7BZ+zSIfZoA==
X-Received: by 2002:a05:6a20:db97:b0:3f8:e0d0:1de3 with SMTP id adf61e73a8af0-4014bc51612mr2765718637.46.1795175087893;
        Fri, 20 Nov 2026 03:44:47 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea7c38sm1228138a12.2.2026.11.20.03.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:47 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Fri, 20 Nov 2026 20:44:42 +0900
Message-ID: <20261120114442.3072652-1-yhlee@isslab.korea.ac.kr>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
