Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794824051;
	b=kzLRlcpSdlGksdRISCsy5BX3gqG+yjx94lKspolxk45+P5DEVeYQues2BYszClVeGxlG
	 mvyVTh/qkKcAJM1qLJFQ1wVKA1Ws22H7CyowO2+7IFcyV5TwdiuOnFOqh5yrb1Le7gqKl
	 nlwqzy+NzMp1CJ54EPgUZJPUHJf8T1Y0k696T6D3sfMTIpahjOSgIcKGAcRHptoyo8HsE
	 tQJ+nufKpF/SOZpIIjhhO1KCuELlsdFcEQhdr4CpvLVfAEemslLYOnclvA/VFr8i8XCSk
	 /0psDZ5MV1mQduvA+X5l2CyIch4jQBgM5kNoedjZbvdg+OhjTWj3GJscE95Xo+IMhOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794824051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
	b=wBcfzEJM2q7Q4ZfSa7LeUq32v6z/xuZt5Doa6pmsO+TQNrtUd7dlwBQGYyNXoaPTtJJJ
	 aMm97nUQHlrjctGaQTKDlL7Rv1WJifrvFnL8tlU3Mlg0VeAJprqEFjZXAexBGKlwNN76S
	 QDC+ygXqKKmJ/qAiCeZ7+TIxVN/T8FoC2gDZGHwpS1kfMpN/lYKNOitbZyfxMCXX0BbL0
	 s//mUX1cHTdH5ut3Yoedij/X84mhvPuC9YESz3Opaqw5wEwvsf+p3BwDxu8KW/r7wXTLJ
	 i0lVjCPJnsVcMXESSy5ENkdu8ccyB9pDN7PeOj0vxmwtyoIDGJ1kXbvp0xc2JAt8ejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LJdVJliv;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5D606A31C
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26E5D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LJdVJliv
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-37198ed3727so4814079eec.0
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 02:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794824050; x=1795428850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
        b=LJdVJlivULwySoKe7RmHEPKDa8I//vM/iWsIU1h+DLgudWNXKVV6sia44lgJLI5Xi0
         wr1smIU1P9IioTjZ/neNVSRzaOfBGTfbum+dpcki4uxCmk/vSaGzR34Aq182E36yqBWJ
         nKBRncsEQKyLiXrZ6+h82rzFtqlISgOBZrHfRdNYFY/c+LamP7WiibdKv9KQYNYYl0dk
         I+bD+lNU9tHNm02lHpyK6x2f+unB8B2Vi9dcMTpKgSpz64iMNtFGOIJraXiF1/nXCHI/
         eRBD4f7OHF9uaMa7wkOWWmvvk+v+EVuYFtKMQd+y+yPnkTHgCvhQjKmj1gLoOvEP9XzC
         Cp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794824050; x=1795428850;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x2RdWa2epHt4WctzJo9zXIVV3S8rmZhGbykyRTHy254=;
        b=mtQaNso+p4Btlb0dJB6pH6pTwfHPoPxO39AQZWeKDMeaUeGMHWc8NjXABLZoTR5vaP
         78GGpp5z35tWVX16mWSypHSe/VhY3iiFH8yu3EyUx5/59Mzs8kCmwrsT7vvTGY9c9svA
         6yXAOQrKAcFN1c21l0lZMJb+TVN95xt9SAwxqRkmjwEHXB2R5bgi3iPrVeH6MewTj46o
         3ntKN7QHXz8nOIyMms/mZMjvzVmp+qypWvp/xF23sbyTpBxHon18lPualvMJ8yhdN9jy
         4IcBn+ktOdgkP7ET1kfPm9OuUmlrLHDmf6/3nEAn8F3dk4Vu2g2Yr6QjET5dOMVNx7R2
         Llrw==
X-Forwarded-Encrypted: i=1; AL+hErGKWr2C7AnB3KTQLJFruvJdW3ZEq8QPhIx0mwJ6I7g/b5Ml57QTqWaDqeESIHL2psmxIkR9a+xINM5de5Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z86fEqVaxABv3T449RGy/+FvqrzBlrT6IEPenlwdxxVo0wjm/TH
	HnMS7niRrhTnNvFkGhDwu5XtU3KjzAVVUSnncjQEAx2830ruq8Q2XG4+FInrQ2G9dXc=
X-Gm-Gg: AZFdTZdcbe+y2QdjFW39R9og06BhUVegu1FgUjRyhRkxPWCTzmOGVwVANaS3ge9F4jg
	ysVy1oFdKJhcgsyJFL9bQYbXTQqC3T3IOwMIfFDu/TCZdU9ir+Pi/ggV2wMjw1xMOp1zwgOUCWW
	78d29FkylTZV5bRjwEBcoO90zvDLQjBajjvTG6VV+nc5gzooGgizKQbDhzSM7jrUVhywY+86o2R
	4SzZTI2Ex9bpdPZRqCMEib+Yr2G9D3JGYOR8WWt01a6ENMaIrWV993XcEGhvUJO/IqnS5eTe+I4
	7J6k7Vl9uGCSJlSPq+GhJbTTPOTz3Jq+Xg2mkL+wiXKMCqYsQNDft3ke850OiPYNJR93Gy8fyDI
	Urmfx97Z2UsfqzrqI9aN7Np+qBXJVMUBlZoTcdzjTcaDiz8AFd5Dx2EWahuosjCfxQ/QigEb4m2
	/C3l4VawKlIrHlTk8JZAjf2lUyFO7RGWZAKGogVX8Zd1sbuN1YyqvnP74q8YYPeOD2TawsYh21Z
	2fw7Kf4ZRnTj/MnFPYTOhbpXFVhUbFHC5UI+VOru5gJNZnMYkXyJ8FPFuA1UPj5VMVJvgjSGbVU
	wuR7uk4p+18QBXbQnEkhbP9vqADEsyjtD2HGwi3yJITsdeyASmMd23kmb4H2CyAnYtJJVCSqkd1
	lSmZ2l/Cn8obMWitcazsjqpup96pCnYjEZftXLw==
X-Received: by 2002:a05:7301:f03:b0:373:64ef:5dfe with SMTP id 5a478bee46e88-37966096b9cmr10223982eec.8.1794824050090;
        Mon, 16 Nov 2026 02:14:10 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm35126665eec.28.2026.11.16.02.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:14:08 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org
Cc: mkp@kernel.org,
	michael.christie@oracle.com,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: do not reject the command on a Data-Out overflow
Date: Mon, 16 Nov 2026 19:13:48 +0900
Message-ID: <20261116101348.1650677-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-214783@kernel.org>
References: <20261114161931.941441-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-214783@kernel.org>
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

Thanks - the NULL dereference is real, but it is older than this patch and
does not depend on it.

iscsit_check_dataout_hdr() already answers a Data-Out whose
DataSegmentLength exceeds conn_ops->MaxXmitDataSegmentLength with
iscsit_add_reject() (iscsi_target.c:1573-1578), before it looks the ITT up at
:1580.  isert_handle_iscsi_dataout() calls that function, so one Data-Out PDU
after login reaches isert_put_reject() with a command the core allocated, and
isert_post_recv() faults on the NULL rx_desc at ib_isert.c:761.  I reproduced
it on unpatched mainline, 5 boots out of 5, with no SCSI command involved and
this patch not applied.

It dates from 4366b19ca5eb ("iser-target: Change the recv buffers posting
logic", v4.3), which gave isert_post_recv() a descriptor argument and made
isert_post_response() pass isert_cmd->rx_desc.

So I have left this patch as it is and fixed isert separately:

  https://lore.kernel.org/all/20261116101108.1650132-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
