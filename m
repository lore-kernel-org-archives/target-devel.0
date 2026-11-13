Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559222;
	b=NeWjsgLh985F4o5hpDi1OcX8bsfTK0NIs93/JLBblh6A4cx50MBMMll2JssQDCd4+hth
	 dDmMiVpbINfmN1wAX2J9Oq47BOWehqrwNtxbX7hKMGtUZ7sd5dbiX3JVy3wI11VAFzZPS
	 FuaPQ3MHcY/JnuEGtWnMUBuMbJBI94ToU8zjJqJIT6f+nndBcYRZ0d7I+IdKgab6LrRBa
	 wcSfFnrTuUi6UdqMt2Ipu8l7/sb+5LGkqIxFY2S0xvUh0wyeIHT7xYx/P9OklQl8Y6yuI
	 cEWmm15vAzJEwUYfYzx0jIGbZo+/QQxtIuXXZD60PN5qMfNOAMw+l5JNO5T5U+MDPoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
	b=z0XwK45QKQvWrKZQg6Q7raroPm3HmIQocj4xc4K6ryoyv+xcQ88sOi+/9kyI3pP5d27L
	 mxM1HSykGN1cDiTnntM6jOhSl7FNHBpwlh1TldhkIS1IpElBm6iprGv3KnzIxzB/NUjQ2
	 iMjroRPd53Nxvwt2mxkpAm5IJZAQFGjHK2iiZuke/p2Q+Pz76inh7eYGOMSXXkcUqT/zk
	 Jgz9+zMXZx4oTMflm8S6yC8xe51VMglMl4Wy4l9zJAjytaKTnMo4RgXqm3S/m0qi/2aiF
	 RiRdBex5zFEb8V2eLetLIJFkUQQnmi2GAN8F3E0d1aotWkNEHg4VsjFr2fJiGonUGuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792A606A32A
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 08:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8792A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ae691283ecso333216a91.0
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 00:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559222; x=1795164022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=vMPn8R5VMR9iI0ko8VJph2JIkdkn5kHcbotl71V6RBCRzZ4xd+JdtnHZcwclEOOlY/
         ihl0rygCUBMSiarvtTlBqqMxkfY9u2CClFgwurx1TK6eKare1vnVRAbexXkzeYIh46SV
         QBmJ1zWroreUI5Fzah7tNXOGTJ49iiIe/KtjQF0YlrplHBFRmwCcAIMZfL8vJRjiQ+ca
         7H9i3Hf4bT5R4NybB0h2twif9li5VoE42xYo2GJwYc24FbcbQw2OB4p3uTSZnbb3qqaI
         aMPWa6E4FT+mG8x74fpTtNJmAz8QYIfmmsQxJcv2IQ2XJk4eU+1//UWlcQlI0bDVtwUa
         yIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559222; x=1795164022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=iuyQjC4QBRrQfYa+SKFot+qVzxnSoFZ9Y3li4wv+1smmvxzk1mMJdg14nyG+PK5tkE
         9OLi4X/TWWjYJKNqiLQoCSqfobCyh/bMBBGvUrNpElowNHZBUSpPgxlQGO185djDfxoI
         ZYl/I4IJg0pY4rRKLNQW+CAIN9MTGZWDBRuUchic7BZezKUqqVBAJnnrL9j4pnCKgXtL
         PV8k6vQehQ9EoKHCvEXJDKDOFJVrSJSkEtiTxtgpQlifPJXmGuYouZ9htm6lpnQ65pwW
         waOUl2kw9qnmWPCABKgq2f5ZawR7BUOqWN9oXw7awF1m7PuWsfEGWfr2p43Mmn/1iVza
         3k6w==
X-Forwarded-Encrypted: i=1; AL+hErFSOcBuFcFxYThRhzuuX0ZB2KvRYJX8lOsfjYGp7y/5WYFpzcl+dxEimLee772nORmXg6wmynInhQCb5u0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9f0HlWcT67IXMfIi+dgyjuVSJV7Y3SGddiB/zO+48ERmpErluR
	FGFxpwJKPvb99X1R2Z2wcK1y3nplcOO87WZNG5VmpY+JyFy99TXqPfxoQFigFxB1Pes=
X-Gm-Gg: AYBFou3L1bV/1ngs9czraG9u/SSXq89MSPN4zhIPe+OWflRnVJHwVrwnY9I11t44f3M
	WYxpdpZKEKATRNjkDGEjBkdWhoOPf3mlDJvlCDM5bfq+ejuwwPGKUZ54a7YAHocmZnbWWafTxRu
	kWys15cLLU3dAWAe0MtBstbFoFZLCF7C/4u/NwintW/OxW1ST81xBsykIx2B752Qwbi5qm1asr5
	tn/YdMKACvYZ6FsnzdbDQwHsBwNjtzj+BIBm6mDL0+MfS8AtYMMoI3873AuAWOCKilDLw+XRpsh
	vyTrILm0mK3HzcEFSPHZX+DPfhTt6M8gpAOfHkndRwt2fg6X8Tl7BFh/DIwHiYwk8JIA4WEcvTv
	8Sw0t/+E+l8cEAO//3s1CeVhP+Tj4M6GfpEmjMDTt1H0rGyGz3z6mhZRQJ+eOvlULWCS4pzSzvH
	yX2EyyjEzWecQaQ25FiCevU81FrUscpkVnz8VOFiRyTo2SnyOFrTW/+bvUkXM4XF0g/PpAzx8Lx
	GF47tEl8wzrRx2Zl8F+qedjDWtYep61ndoCH4fMHfu0VJ20NQmBWO4XxGP9o825aTE0Nx2bUyRz
	JjaLIHDeZnVVDGt9KA7wdanxhEBV7oHI/spyQb9Z7psRwib7WknL7yzmle859mQ=
X-Received: by 2002:a17:90b:4f41:b0:3b0:a1c6:95ae with SMTP id 98e67ed59e1d1-3b1b0ccfbfcmr894078a91.31.1794559221886;
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 0/3] RDMA/srpt: Fix command initialization and read buffer disclosure
Date: Fri, 13 Nov 2026 16:38:39 +0800
Message-ID: <20261113083848.1517595-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
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

Hi Bart,

Thanks for the review and suggestions. This revision separates the BUSY
initialization fix and the target core control-read buffer fix from the
SRPT descriptor validation and read-tail clearing fix. Together they
address the NULL pointer dereference on descriptor parsing errors and
uninitialized target kernel memory disclosure to an initiator.

Changes in v5:
- Move BUSY command initialization into patch 1 and explain why the
  target_init_cmd() return value is ignored.
- Clear all control-read SG entries in target core in patch 2.
- In patch 3, log inconsistent descriptor lengths and zero the read tail
  with one sg_zero_buffer() call through the command's chained SG list.
  Remove the SRPT-specific DMA synchronization.

> Do the SRP tests from https://github.com/linux-blktests/blktests still
> pass?

I ran the following against this v5 series in an x86-64 QEMU VM using RXE,
with blktests commit 79c32fb31b7bca6a4383b749030128683cf6b6b4:

    USE_RXE=1 ./check srp

Results: 13 passed, 2 skipped, 0 failed. Tests srp/003 and srp/004 require
legacy single-queue device mapper support, which is absent from this
kernel. The multiqueue test, srp/002, passed. The kernel and modules also
build successfully.

This series is based on commit:
f66469d9905b39d2c260a15d7d6db450f4db67c1

Regards,
Yong Liu
360 Vulnerability Research Institute

Yong Liu (3):
  RDMA/srpt: Initialize commands before returning BUSY
  scsi: target: Clear all control read scatterlist entries
  RDMA/srpt: Prevent uninitialized read buffer disclosure

 drivers/infiniband/ulp/srpt/ib_srpt.c  | 24 ++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h  |  2 ++
 drivers/target/target_core_transport.c | 19 ++++++-------------
 3 files changed, 32 insertions(+), 13 deletions(-)

-- 
2.43.0

