Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745600;
	b=0MpXupf7dh5BOOT7M+9nI3MIl+shUaMdydwvIBi/oTtiAJW5IFw2cjsfDaXmbDoKosZ7
	 t7iH6JOltTa5KNbIwYkkXUup+d9jIX2BzFsLsmqHcUX9Xop7Lw+dJxk412Q6i4hTSG1Pg
	 hlAQwhvsBgtw+gHyjmpICCv+JEBEgtsjkTYCqdYdv8Kr09clmEUNUq8BTQgNPpecjexbB
	 PVamjsCTu6QUtKKAUUfpRvqBwBy7A7dciEfUQKAmbVIOkWuPcN+es6AuMk3o0NTC0Pfvc
	 94LnBQ4Hrav7n09vLVapG28trRA0830Xn65GsffaXQWbsydRmdDHj5dPY088cBZ4CNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745600;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
	b=ce7rvnri3sJVjvYxFUgiTEAkaXexIwJZcKn/6BXz2PYPDIa/Gsglk8FDYCQwtA/3sInY
	 IGvqBK/5uWbvPHyTh8ZpbjaBEaoFcrTsOtXCTAVd5XAW20MrS66HNdoSiWUiNrYfPVdF+
	 +hYSzaXL04CBfk6B/jXHLRz22hKIxHwlyR+31US52NpuLu9Kwg7TCLXLO7Q13xz8DGfGc
	 5Atb2Iu6XKz/JrGrmZwcyXDIRXLDUz0GPdMb6psxozsFNGsc8JM6kCMlXP+on7+W+wRix
	 UxWKes3hNSOYnju5orrluMNESoOBBbmKHJrD7CkXkv8/c1QWu9dvS/nlpr08R4RM7Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t9+0qfDC;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A89606A332
	for <target-devel@vger.kernel.org>; Tue,  3 Nov 2026 22:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A89606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t9+0qfDC
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso49036a12.3
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793745594; x=1794350394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
        b=t9+0qfDCYwLylSmVAKRemuYBtlBZtSEc+OwR8egCGuHW44FrD9qGXupxIVP2sK5RcK
         gmHttwu2rBCZKtFtMJrm9PyA6fBRymv4FsKNKVc1zw+XE1ZUKC1PcXjm3fKuNeKOoVTr
         t8HiFndykiCtgEK/lMZajxktnukuNLVgoXXVfg4jQFKtczvWw+/pOYmokImYksBc/ITd
         x0k/nEIdiKco/iaIxoJ0jb2mZ8ry7s/ssMr9cql7NhE7XIaIsRq0H5la4a8ii+DwXAcK
         WaytQ+JGfu5tiiZ8chSCPiCUMyp8RHuwuHwEn1Ww7Jrz8LGwFQMtspL29OMRaeuMMglF
         m5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745594; x=1794350394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
        b=0SSlaYQMmWt/3hUbAFHhZDJF7lpFwXF1aRwqoH6BMPJ+Xgukrt1OIBl/asayS7y1kO
         V8p0t6XWKccocjhox67+Kvy8tVO10906YbYqNl7RDaaKs3/PbvVHdE4JEVycCzBc+OnC
         SXV/0jZxo68mCLMvdCwJkQTS52aqMlU2+3xGwJzegfahT9jxpcbuh5Se1QHqGN69lXY0
         tJZozsxL1YMAIFJD+4L2wPmjq1zlNRKVMeB9xjMjof01KInh8tviPDjuDQk9Kyvm2Frc
         ebUvMsNwKardBiFB9pkGypsDY+djvHqlfYkHQH7o8jr8SxQD52zOpGt/axfSP3z/ZZtB
         Sf6Q==
X-Forwarded-Encrypted: i=1; AKwUvBzmkn0/aT3zfYWRne+V2cmUPbz4X2rJ4CPTUkFvKZ0s5IvW6ISrK9cplX0a1dc8bhoeEFInYSlt8rSaCjg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8gIvnpfMHeDMvax+fnXNEDkmEuKVvWNgMYk9ayxaSFGK6Xus5g
	6FlkITndRb/kZkz9fRwwdKxEzvvB86dE6IsLBAO+cSFZl2C5nXrUDindPaJrr+vqd54=
X-Gm-Gg: AYBFou3v/NwwU+n4/ufc/p/Ec21RBgvqG+l0kXJaXnobMwegH9zlqg3IW1Irqd5AOQL
	2rz9xg2+HKoaQ6mbSn4lcDFr5SNSX7xO1Ap/5+pUXTf1vmkDHrxPIinLZUOgdJYX4h/6k3RpkZW
	tyO/lvwyftwpQ3mDb1kR564nmfrbWb+U4gyKBtP3LtwlKWLFJMcUZnqs0t1Y9vBvtWnvRa+ERqH
	YfuWI7acgx1SOAyXsK+bLy2y+hgdg4ER7NhJQXLF26QBahQHE2lo90cfm7vyinSP9cQrRasnati
	opBiRmXcZnjAruoSinrepZaUQhAmKD/hAWJkSmfDuWqtSpujo7goYuzpsfd6UIbaxYD4lfXxuel
	giPk65siMW+BCNDCXAL8f5mC0BkfjuluiwdPxStUwA1kD9x56VcK/b/KoQHVKFVSPTuM1OcYgPb
	3NUrLXGxjHa6IctTS8FJG4v8EbOaMXjuFRfASLhLlkNQ+atwWBdKWKktCrSH83N8HAWACUic93v
	zfaNeddYxAGtCXAt/g549tRA78G5ZZR1Cf8RjLaXdCa1cUvOt3Gw2sLtjdrEwYsEm2WT1Fr2han
	C0zq8U5R1LIkE+jBE02Mhk+HWyVmfp5MwVVKpN/GsDnzYBNDRLfdUcnDIoUU12DsuqFVDcOrJzd
	C5I0AiqiEKhg1ZlUdtdWULzx4IL21aQPfAhSV
X-Received: by 2002:a17:90b:1844:b0:3ac:9c37:9429 with SMTP id 98e67ed59e1d1-3ae89838746mr11403550a91.52.1793745594421;
        Tue, 03 Nov 2026 14:39:54 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944a0ff7sm886691a91.10.2026.11.03.14.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:39:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v5 0/5] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 07:39:45 +0900
Message-ID: <20261103223945.1697775-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v6:

  https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr
