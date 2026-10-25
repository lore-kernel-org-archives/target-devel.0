Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892286;
	b=E4yad+BpZHvo+oFCXnyYdEKMjSFGrsL3hx6ZJnsri5hJOSjphGxQKa+HUbw4Uvcjm344
	 HVANS40L0QgBsBeyGQSaULrzzvJqt1I50AaNaoTXZFqFPEDPs9yeKq7kPjveaCdW+n1VK
	 rilW1Pj8ofGo2kjrZUJQPKxDBq+yHhlWmj4vv1P4hgiRdzggA3N5o45+raGyM7MW9lWJ2
	 OIvISHXjnd0AfAQ5tEftkQKDeFastPd4CJbW/das3LdalhZQgi5lWAHKnDSoPoXucX70r
	 CeKi6gl68+UoHF7UXS4akt4VgSU8N/NQwAjyTMpceY0+dfs5GJAAsxImwczNBz5QhNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892286;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
	b=EqqkRcJ27MeWs9hoMgGtSKz6YlSeb+7G891Ob5dp81tIwxifbnD7GSKOweaYAzrRyGc8
	 SQJdUQ2EocRBM9oO2m+Zkg2yPMjPCKjsit1imBCvYsL7PckvLShCH967NEAd3B/akwhC5
	 C/qdRWcuW9NxlMwjLDYOWdyWDdJbMnlphJAoHfyaPWopQ0vpcWA6wymDId4SRglJHtAUC
	 qoN3VcFaPP5lEhzaQr4dwURlzcwc36yTA9Uel3gfPylkMyGvfrSze/cQVqQoNJ1dtL+Pz
	 R0qqQrzxlQLvqWuFtz246OX1IeCffTlV/neP3VgaIulvTfiTZ0KI7BZ9YoZQFGulqgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sEGEkAsT;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F09606A31B
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 01:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5F09606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sEGEkAsT
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36681e85e87so1426795eec.1
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 18:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892284; x=1793497084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
        b=sEGEkAsTpgfmX82g11PV76q1y7ztdsbuImZnA2R0xNogWSBJjygohuxHaAvHrR5h4t
         MIjSvtpCEnNm7+2UUXIBZ+gmfNImcsjx1SEKy6y3PK18adPKmvvRmeJ9zllhdHjO+1/q
         njtdixJEtnfxjw1SdO+rSCevSSHExE0Q/TCKvrXXbBgsjYcAJGmDjrmU/totlJei9AV2
         NJydQzHgb16+Sman8eEjuNjMtMkqer46DIgBoMmbiRPBrVWiJ8flj7Q+EKdjAOAqOB73
         c9YDNartU+E6io5F3XtQR6ODJmWLZ0Nhe//6KM5ot91kyRbukwdAxh0u4okw7spJD2H1
         blfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892284; x=1793497084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u8h1InsNpeC2AlWGNl5I9ntcUmNs0bzik5YkhmDqhCQ=;
        b=nqauXcSevFCjEaGb6msaXffeCE4P8mOdMb99xPvauYgBj1nOHR9bUSFOUs0P0zP9uj
         rWF8XGUnsoUgGP+zp50uBwRhNDpexm+V6lcSuTtut1Tp+/WRSW2+nLXIC67OBZnfaRAD
         rs3WxWfhWi3PtDn7SnoVABJzvjzkuPBgGnuTDntxqQ/0QwVxtU9Z6HCk0MVmJQD879Cs
         f5ewTVDPQT7cksrYgFVDP8aJr6OdjeyqiCm3nbnwJFwLc5rTYmQ7rOqQ4a2j2boXtfpa
         rk7CtPmaswnVoiwVCM6cPJ8frRF9IzcOAxe6aKr7T+1x+7P5pSo7gi4S4PrYf0IJyyNp
         fbWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwwT63nsf5ALOWMkweMG3hDqZke2RPNwbhK5u+1WjKQvTopLdEki0dTMLu2NiO4X5xuOWO+gRUoCki1jZQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKHGIfTzGbIDAkkG7uVedZAwc4qGA/kPgx2KV/0nC5GX8+QgOa0
	/jE+sArr6fC+8Udm6jlmWygC3x6hEqyrITMW3OcT6s5/w7JfjdWZYwWF51A5XMiDwww=
X-Gm-Gg: AYBFou35Ey0Eb2MvYC0DeC0fRpF7cJoar9sXMZHz+5aUViu3yq1rKts2ROESK7UqpBe
	10VT6LaSWjJZqBp05nLYvs+o8LKPvWPZtGgqu8o5vpdFFRKSic8rGeVOSuD3A897AdWMt/Qm9At
	Qduz76mr8OsADFgyLkmNP7rsJmZwAOyDl64HLsf9siaLwX0B+YZgG1EKtwlh/3ojdCwbo275dup
	Y9EQ1w/QdIkPEXz4QxKsaThY55f2K9d3ecixvt+RiQjPdILtolxQcBhbmwAhIORUnLTX3c8heW9
	NIeFX2faUQGtmB9Diu1Jc5iHNwygdXiXChJVKE15ZTeWKll4foPzt/JYWzpQ5SL/QTy+ExTohGp
	AlwL/sVeMeHQq4GTVjA04pO0aLCWAlme1gpUSLS9VZLtjCQCrGZvnjU6lTRTf/3Q286Xz1BSK+i
	YQAbwKZnbeGgq2R715hfIF8wdVyqaNueHfYDpgUPaBU9vZxOL/pRI7r902pprypTgW8KpoEW2H4
	o8qqjYltroPXf1QuLd08FOoP/P7rkfMvZrlQ/KMcBUIZYjIr4FLZZZSEk2fLIDOoCWfDMnShSt4
	lsO2mozCNqsQ9BSRTm8/xbo8SrDWnzlAZhoqACVN0uXp7D1qUu1IyxbMgO60WrKBHA==
X-Received: by 2002:a05:693c:820d:b0:366:bcf9:1807 with SMTP id 5a478bee46e88-369e84dd76amr5254349eec.36.1792892283556;
        Sat, 24 Oct 2026 18:38:03 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 0/3] RDMA/srpt: fix the descriptor table checks and the context counters
Date: Sun, 25 Oct 2026 10:37:45 +0900
Message-ID: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
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

The first two patches bound initiator supplied descriptor data, and the
third widens the counters that hold what the first one admits.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The first fix dates from the driver's merge and the other two from the
conversion to the generic RDMA READ/WRITE API, which is why they are split.

Changes since v4, all in 1/3 and all from Bart's review.

The span check now uses struct_size(idb, desc_list, nbufs) rather than an
open-coded sizeof and multiplication, and the size_t casts are gone. nbufs
is at most 510 by the time the span is computed, because the existing count
check runs first, so struct_size() cannot saturate.

nbufs == 0 is refused explicitly. Bart and Sashiko both pointed out that a
table_desc.len below one descriptor still got through while the v4 commit
message claimed otherwise, so the check is there now and the message
describes what the code does.

2/3 is new, and it has not been reviewed yet. While working out why
nbufs == 0 reaches ib_post_send() I read the rest of srpt_alloc_rw_ctxs()
and found that a descriptor length of zero is not checked either. It
reaches target_alloc_sgl(), which has no length check of its own, and ends
in sg_init_marker() indexing a zero entry table at nents - 1, which is
unsigned, so the write lands far outside any allocation. DIRECT requests
are affected as well as INDIRECT tables, so the check sits in the shared
loop, and the patch carries its own Fixes tag.

3/3 is unchanged and carries Bart's Reviewed-by.

Link: https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (3):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: reject zero-length buffer descriptors
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 21 ++++++++++++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 22 insertions(+), 3 deletions(-)


base-commit: 6fba331225f5040e93d0947d1027e9712238291f
-- 
2.43.0

