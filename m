Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859349;
	b=HTsUqv6xzRzPNO8tOwdPa3pIOD0mpMxz7kxMl1UUYJxUqaEG0wFnwcaXUpc9iJiBlknO
	 Ho1eRrZyY0EsDObphsmwclWpacWRvwOURIlAhTa4r9yWNEE87F+uEZw0dQAXUX9Xnbiac
	 Rv9JY+MMbTBEWBcq0zN5wNzismqJL2ragtStyAgYwEzeyeLykpPr7dEiNcKtMqbImTGpx
	 r5Mb9m09QOnt2T8nF18ftI8HxHMmEeRDrTfFR5TGCebXZd3dCXpaAd4qS7yWHOeyRIAqL
	 xbBUMzhF4DHBNt3iMwDQALwYeycTAtdom6kVVFLPaIOlGNUfdXDgnXfHqp6YtdsaNlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
	b=L0bf9fKJJtkUHdKH4jXE9vWqnTh3E2dttnb91ddEiEJZgOOWBB8tzny7RNPsEHNXqb/U
	 eFV9+gTk9JmqqX5ZCUEtMBfyxCCPMJlwS/UwHbrmKae0ETxeoFE7PVhENINLz/YgV4CFk
	 /YMRwO0gE1NXl2m5+F/Ft8MoERHErjXdPKlwZ4UyIhgsYw/O0LcrQnghX7eG22uOB1jY7
	 Hn4aGEhHuuQOoek5pWBYMveoNTWoMgW3B5dTbqXXeb1YQvJanss69G+EcHwhU7X/v1hEx
	 l2Tm7i4uBuKPQaWyDAo/Tg3rIPijpI/3Rw6tPwViOIdf7ltweBGH2vM+nI8JszKTSeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Nmqafhes;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73041606A31B
	for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 16:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73041606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Nmqafhes
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso4306883eec.0
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 09:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792859347; x=1793464147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
        b=NmqafheshdwPak0EWBNwAofN8AZNgmQptxYh3iGuiskd4q9UV02Q5UGh/oeX7f6FAP
         hsww53lS37P3JAtMBHk1Ke30ZUyjQ970syUPgtgen7abOm3OdBvvHzNhQeSS8thBBjN2
         SC3HNizvps20P1by+xoZcccTn9VK6mlBWX86kM9SgLixrnZqkm2a15VPLsC1r5akYpOd
         GbFtf6SAKcIIaCFJLHlyrXE7eppDpukU3KNhEmWL7AFobu0iXnIDJT2TSN8h/2LThiu3
         chbxN23xEius6S8t10nOzv38wj/umbcr/Gbh4ewd8+Qxc1HolXYT5oZhHgwwouOLAZCq
         SWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859347; x=1793464147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=llsgWckxU6HrF1Oq7gERdngWWd2BM5NRfeUcsEwDim4=;
        b=KjB0qCCx41zjpwH2qW3hWQFQosmWsKSxox1MU4I4gSQkHcT0QAHexlV4H75lXGP7tE
         1BdH+vOTdtlc4D98sf6fkv4pbCrvBzWhjVHZ/VHG6nUt86KUFmvZ7s5r7kqBWeVysXf4
         hj2vMt0yuXz66fw5yrmPRU5PkkA72ttBUtxqZ3NJsDclAmbJXDv7HbL92kOG6GouEW1l
         8+ME40RVxu/ZevDr+5VSEUVJQOV6djfyJSynUFhSl7+tVbtSIvYbIPEDFrhgLrrEKXWD
         OQQu0V0peSbROkI8lDQHQkWBJYjtSgh7TZnhczGclrvdZhhJ9+roqBRqUbC0/MtNAByT
         RxkQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/Gwya4Ze1RkaPHIrQ/Nc8BxlVbf1ulJO3Mb+E4cjP4zFTBpZ0iUIgdJyN6ingxnmr9iSi0M7z/iimnaE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLRSUHvydha3AV4b0MZIRXj/YQvUsDzCRs51bNuGMJ767+/FABi
	cDBppnZ0sx+zWHOU/yVj7BYn/ZUR5q2bkzUe/4ayPepoBlzbCsFCI1edcTxDYUVsQAM=
X-Gm-Gg: AYBFou3psjJaCVixcawp3MutnZ8faxOYdgLhxIEFxJ5S9xjwWmRT4TGePXEouMS57Oz
	6PI5aBNSgxp3IfdiyZF3qVxI7UsgULElbIDNVlCxYyugagqF+p/KTmUhbzwtgrXYL/DeYGOCL1k
	//TWoeBeb0z6+MxjB02kiaK560WvfZhve8rQa57DR2HDlSjjVvoQBlf4jugmPSLmZ+lFxMXq30q
	RQVGgpuTbFJ/2xNs+ffam6b+YIjDTlREZ6P6j4L5t7YgHhpMvpCfqSLVkC4M3YI19Mgcbc5f4Ld
	5E25dKpC0LHsDjDwDM0zhZB0cVSo/DxdTrMc1O/fflynSgACI+dru5i2Urwb+mwRsbMRugpOGga
	prMsBlQRMLRo8w4/7IAKwoVQC9GOzM3ZNlqA5ZW2G2vUorfe/0HEhpblrBB4koJHNn+RCEMO9Pm
	q74Bb/RYXeCyuX/ao0bkxMpX8ujy5Zdp7avtbmJiQ5HTUpcFYcuErTgLAioZ4k/rnQIyjwRWfv4
	C04A+R+B+AHi5JcPPO78gjkxClbS0weN+JmQ+tvw+EYtoZU0iEtUTmOYC0YGQDjlByYICm4gYsi
	hibYpHuhFxEAZiDXwAV5v/BfQiuDfMA7olRMzv8dY+pWKyo/472CuHdP76d6x2Gj
X-Received: by 2002:a05:7022:220f:b0:14c:aaa0:941c with SMTP id a92af1059eb24-1993fba154cmr5334530c88.35.1792859347154;
        Sat, 24 Oct 2026 09:29:07 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19a3736d16fsm7192350c88.12.2026.10.24.09.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:29:06 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 0/2] RDMA/srpt: fix the indirect descriptor table bound and the context counters
Date: Sun, 25 Oct 2026 01:28:50 +0900
Message-ID: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
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

Both changes are needed, and they fix different things.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The two defects also come from different commits, which is why they are
split here.

Changes since v3, both from the review of 1/2.

desc_off is a uintptr_t subtraction now, as Bart asked.

The room check is gone. It divided the bytes left after the header by the
descriptor size, and the division truncates toward zero, so a byte_len one
to fifteen bytes short of the header gave room zero rather than negative.
A table_desc.len below one descriptor gives nbufs zero at the same time, so
nbufs > room was false and a truncated request was accepted. That is
Sashiko's [Medium], and the v3 commit message claimed the opposite. v4
compares the span the table occupies against byte_len directly, which needs
no division and no sign, and the wrong paragraph is gone.

2/2 is unchanged. Bart asked why int rather than an unsigned type. The
values are counts and never negative, so unsigned fits, but
rdma_rw_ctx_init() returns int and the WARN_ON(ioctx->n_rdma <= 0) in
srpt_rdma_read_done() is a signed test, so int leaves the surrounding code
alone. I am happy to make both unsigned int and turn that test into == 0
instead.

Link: https://lore.kernel.org/linux-rdma/20261022143901.2991062-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (2):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 11 ++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 12 insertions(+), 3 deletions(-)


base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
-- 
2.43.0

