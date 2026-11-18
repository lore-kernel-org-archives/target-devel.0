Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975238;
	b=mEbJEjj2nih2dXNEmPCYlGCzT6EMPaQHeur9Pajm306R4v6sRvWNklg1+dl0cDY0Z82g
	 D6Kgn+f+RH3PngEHbAvx1O3VILacIIZC150zMtcIVsOowsV9M2XPSNx7em/9Jvo4Ikkke
	 DPQpoS/3z6Ap78/VH7U6K9d46sMHjWkDYyB9jKQ2uy55msWvF7T75dUZHCRudJe0HJCIg
	 ZMvNNe5Ig7czKUWjQfzWFQtAnf5LRAAsd0+IVRFZ08EYXqkes4b5/ZMLsc74Z8SzULAp8
	 5tvnbfxIix+6OgtxZFpZp6xx7j6G8s6LRxN6mY5q7NGSjeM08FlssHtqMVfTeMrk+oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
	b=v9q6dQc2Zw1yrmz7GqFip9n8yUnXAGzVBx+smBXN+6YrJJN1JiLDcHvNm1ebaesi6qtO
	 WegTFPmVCMqMzBRns2pJUyUZf1IdqlHd1b3LpDTPMP+ACdxOe/aALb3ovA/b4HyajhaLO
	 BrIqEnY5hU2FyGQT9aqPCK39qioEfZ3hDtTdcqIHJakRkNRVRbn2uvhvyvzIB58swuMob
	 YFZy28llfw5ZI65y8jtfnwqniLJZQruRQmwjOIkXfueKBmywU0DCuNieEVtdWsrxwydUO
	 JqnjjoD6x6dLhAu0ZVeVof38BLbdo8EiVBKhU/tNzsfIEb/OqJBaA5OcRaq+fnkVQfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHzlUa3L;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D711606A333
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D711606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHzlUa3L
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2efd993e9d6so2195825ad.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975237; x=1795580037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
        b=hHzlUa3L8oeFVoRTNRPd3jqxrDytrnAMuKpitUROtse1WA+Pl3Ra/c03SJlC9mrxnb
         ZeGrJTHM4ct9uXLmcR6NuNrizvLVQEAbItCIDoXtVdBdohe7e3WGUBqY20K1ecbPjl+2
         HQeE1p1JNs9jVkZVr4UGGWb+nAeaAC7/WQU4yLNDfmcxjN97IkGBDGOmjuzAV/ZKtQ+n
         w9TnNVX4n2e48KuWahKY2hpM3EcOm+x/hU8Lu+PeZL45joaBfItFaQduz8vJ3/3At8cA
         mUP64ua8GzRtyapA/8C0ET8wWM80K98chEabonISWm6rh2KkjlgadCFdcqOrQ6UxWJS8
         nWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975237; x=1795580037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
        b=BzHIrZh1u8rIquVmRKz3lnDFV3S3ufGMPXrjmdIqip4+jT2Bz4Fn4jowcVa5u2CfjG
         aV3IVoQZY5mryC1vZY25Lx4pkYYvk1jjqtH36GGMJSrGeWwfs0jIyfV7/VzhmZuE0dIK
         dGylLDXIMSz4Ss0jQqW1LywctsoGZWQVU/ij0lGPs6VR40Ta2chdVTHlKJeg6rUxFMp/
         nPXQupnpxrzlPJ4U9hjI1JjUW4aQz0XwzpzsCqjP1LcsC2IHO2Kb797D6NvbmYZOoC0P
         UkJDTi5lz9xeqcgkurLtZadmFQMjHyc+kyFzBK5ULplLthiu8On15TZ3lbcWNDzpVqPg
         ACyg==
X-Forwarded-Encrypted: i=1; AL+hErGV9s/7H43FikwMnd5VV1/AmRut7BIbs/mc3gKdCC3JZ7eFpaU4Yg/5ATIS65mn8R7WZzxXTlG9JjGN5Eg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/2191g7Gr7GBcfv+SwNfSweVDfGgiLwSIMLJrdJmxWXjwOTg6I
	FCR+dQ061EkX380VHZobTkEAp+7aBV2jxbxxZTNPlGY4guQ0E+hda9Ky
X-Gm-Gg: AZFdTZecP/uEdJNH90FhHvE4rsMLH21xQUy9YfA9CuMsnwJnJMmD+0c9HPyZTkfQ7Tn
	NP2XgnBccFQrwPhaaBlddJOh4FC06gelF7fGOHtnFYepId2kggsyreKzsk2/pAMhJB06qB4g0Jr
	e1m8ws3bX+dx7g2jXUJcKiaBZ5Xk8YhYzcoALTC3H0ZNMpu9WfoH8TZohb9lemEnGrM5Nz47VCr
	lNYqArhR1LABwcp9PNbp2iWv4gcsVBn0wL9uDITKnBC5/iNlwjcX4jgw/aQg1QPMjv49841jY9K
	3faP1KcTpyciObm6KguFTAR4C5CkSfTtTXKRzGxyffpraL5ExcYJKv4+BnsYxYNunCTzJKMh+RB
	6J5lH2vAQtf38bKah/OqWAv+UEw4ZVkqFIYIjwJHSDldxj6v4EdMiyKnU8NHNaaLxSUe+pgNpBy
	6C/3FcE4dMGqdrKuYhBYbZdRB3e69YKOwW9z++Ry/mVdix1a9vmS87qcOt/DEzPw9zvRMtTsLZ5
	qzybUyPFZDiyypRvU5+G+xl3PLzhOuxiOTqzVWgqkk1s4iMvK4+NjYyUzE9kAev4m9PTQgh47Bk
	hy3s/56d0IxpE/KWZ27U7A==
X-Received: by 2002:a17:902:f683:b0:2e9:528c:b9ea with SMTP id d9443c01a7336-2eff72fa3c1mr9708575ad.11.1794975237447;
        Tue, 17 Nov 2026 20:13:57 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:13:57 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 0/8] scsi: target: keep command bytes inside the sg
Date: Wed, 18 Nov 2026 12:13:03 +0800
Message-Id: <20261118041311.19011-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This series fixes eight target-core accesses past command-buffer or sg
boundaries. vhost-scsi can supply guest buffers whose sg boundaries do
not coincide with command fields, logical blocks or protection tuples.

Patch 1 builds the COMPARE AND WRITE write sg table from the entries
that contain the write half.

Patch 2 limits each REPORT REFERRALS LBA store to the bytes remaining
in the response buffer.

Patch 3 rejects SET TARGET PORT GROUPS parameter lists that end in a
partial four-byte descriptor.

Patch 4 lets sbc_dif_generate() write an eight-byte protection tuple
split across protection sg entries.

Patch 5 lets sbc_dif_verify() read a tuple split across protection sg
entries and rejects a partial tuple at the end of the list.

Patch 6 limits each CRC update to the bytes available in the current
data sg in both DIF generation and verification.

Patch 7 checks buffer lengths and uses sg copies for the pscsi MODE
SENSE write-protect byte and tape MODE SELECT block descriptor.

Patch 8 makes sbc_dif_verify() advance past an escaped block spanning
multiple data sg entries.

Patches 1, 2, 3 and 7 are independent. The DIF patches 4, 5, 6 and 8 fix
separate bugs and are posted in that order: patch 4 can stand alone,
patch 5 uses its tuple-copy helper, and patch 6 builds on both. Patch 8
covers escaped blocks, which bypass the CRC walk.

Changes in v2:
- Keep data sg advancement before the escape check in patch 5.
- Retain the existing atomic page mappings in the DIF paths.
- Fix escape advancement with the existing cursor loop in patch 8.
- Use the existing sg copy helpers for pscsi mode data in patch 7.
- Correct the Fixes tags in patches 1, 3 and 5.
- Explain why PI generation reads an existing tuple before updating it.
- Shorten the commit descriptions and retain the relevant trace frames.

Jia Jia (8):
  scsi: target: take COMPARE AND WRITE data from the write half
  scsi: target: keep REPORT REFERRALS stores inside the buffer
  scsi: target: reject a short SET TARGET PORT GROUPS list
  scsi: target: copy a DIF insert tuple across prot sgs
  scsi: target: copy a DIF verify tuple across prot sgs
  scsi: target: limit DIF block CRC to each data sg
  scsi: target: keep pscsi mode bytes inside the data sgs
  scsi: target: advance past escaped DIF blocks across data sgs

 drivers/target/target_core_alua.c      |  29 ++-
 drivers/target/target_core_pscsi.c     |  37 ++-
 drivers/target/target_core_sbc.c       | 422 ++++++++++++++++++++++-----------
 drivers/target/target_core_transport.c |  11 +-
 4 files changed, 338 insertions(+), 161 deletions(-)
