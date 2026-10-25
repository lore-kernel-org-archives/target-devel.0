Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892293;
	b=JMbnCdzoop0iuoPfOXjCsaG/M6SCDhuihCpU96Lv3mj+nhWlYDy67Ez4DKFGuwXnyVb0
	 cEiiZQLOi7uaeM1kjFyxmS0pgETfCOZkd1iNclMDfF1woyCpn+64vheNaGeiVy7iKSL10
	 LyILu+BN7H3j43tby3V7+OLtUQuqWg8HYbB3VocIYLAH3ep4TI3UwTlZhU9KpafDh6M86
	 2gwwunTQ447WkrN05C5eE9WO0ZVq/y+m1BMsFct55T0PUhl4qkwLY5Iu587HA2hHT3RVC
	 Ksuy7c2oBGIIunE5VhSCAGJkD6uYOTU1n80wlfxbUe0fObZJF80XCgGRVfaWFLve4lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
	b=HLyXzLYq2EmAX3Lwvq2iOdCndiSbvT0OhvQxEH9hVKh+JREjtDiL4OcQIDIKRIA5t0HA
	 d2wdhh1kGH2BinCSMypLOju5nY8dLCjaPa2fBzD4D9JlWUCY5qk1G0ALObNaaOyM/eiIE
	 IAaRVZLL+fGr07oteLyPKYSvXnwEcg6IGmGNPU++1SzqgUJlVEsP2/mpuMa7K5o+Ivs94
	 6VFAreDt43gH/v96vvIYm8DYYhuE9i4jwozyIt3nZnNcplLvpyDGe1B+m1g/40VM3iP4U
	 6MxDxex0/hyHPAxQUANR3r2Ih0U5STgX/y0OO5C7c6+PlBLkXYWxH2Q0XBKg6jN06oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=iQHI7mA7;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE12606A322
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 01:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FE12606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=iQHI7mA7
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33fb4680717so3193263eec.1
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 18:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892292; x=1793497092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
        b=iQHI7mA7+ZzOl9CK0wtM3zFhG196uutFD8us38y2LTGi8QugKaq2lzH6OukKW9FGTM
         misApk5qzZFKUhZo8t5MWvifMvUMyOfT10FQBGQ/OFe4rBpJdEk+OCqn3aLovyWiszmn
         2FTg5YCDH5ndZazMmzgTwtOylV1NFVyRCeJ8edC5fqTZ904MTHeUmYctHSXGtu+xTblw
         z5c8CULHZYO8Sbwu/mZ68/jwBq91jem/Fl2DBqpR6s4VVYqwSGxpfDnSKTupdXSu0D37
         mmaw3E14HbQneLYcjm7uJppGomjpEXWLXbdaK7uUKQNcMqYlEL0nzX40P2oIK3Xsj9Eg
         BdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892292; x=1793497092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyBv9Dc6Qhx1XOQaA7oqdIJfObyTsj1C7Q26W9Ag+os=;
        b=E1GAPck8cq0lMxP/Xbs2Jdg9J8l87qNr407ErYHjg+IqC8XOyugtXmLF34v5lSN/+3
         DZ8VbcK3XYL7W6YXTEXdbRV42ngUbohjbw4o/KK0Y1lv6vshZ3y9Y4Rl5i0w3+zXZYs+
         HMxkZEbbLqK2gdeWcyJWd3nAXq7Z8ENQKDm7IRlStJ2WJdAQXI+UrMAawBzYkgmmvIiZ
         /q66cfcKf6doiCTrbrX0hNiQEQi4EDZxe9tN1QX466UgO2LUcZwY+Aq269ptbp49pFiE
         5y30fQZqGvVeXcxGd8GnlguxYvQ4QFZPNQRrkddxvN3jv/AKcRpWu/AbtnOW4d0eyf/D
         lQQw==
X-Forwarded-Encrypted: i=1; AKwUvBz/wBQ4sGS9ly6U8MXWCGUdwETm1TG4TgQYnMjFLBIVbzMwuENRR/+f09m47nF7f7bre59bOU2tRSGDY3I=@vger.kernel.org
X-Gm-Message-State: AFq9FYJUWdGFn8ZQArAUuqFSIFdBlfcmr8DS8HW+6TUYJZtGGpo5k3TG
	9rR1nPnutgZ7RxjFz4hugnKb0Wplyrgn6zcMoYwCoVU+zynt+LU3ARReeOTdHsntRbA=
X-Gm-Gg: AYBFou1Zh273K1N5go1VrTjphsAt0LButLTJLN09yrynAVwTIw+sA/vWkQQ3uu9a+kQ
	XRbBuYdThfAy+9nbOM65LTG4QxS1DoKPwz973vL35b83/u0VhZ6zzC3EFuHYmc7Q9aPIrP/EfCk
	4yj4ciijK90lLBCX2F9Ka+oRizt+VdExAs78RfivUgLlyrq9b1u+NlmcWd67uZzraiRjOJ2yD0p
	gdC0qC/9ytnWNQ0XiSMHklyPIdyBqXUxb0dmM6Tgqzx57+1RZbxwXRvOqvtx89tbw7WIxHfg0Mt
	qWpmZKUieKo7x6ADYzFcLC3NzamLb8qFNT05mrMEGMkJOpABMmOb9dNMMqT5qFzuXdL2Zc6FV9I
	7tiz/m5VHSA+pgRFvhGD+yZTtINq9z/v3273G4JcTXnoiWMWHSZtzU5UIu9r7Fyj7wNCd9TpiKn
	lWANG5qQA5mCYcKvrWWa1Q09rRfuiOYJXSjK8PglpO+41pYDI93FXcxjO8XuktGuBntoALjDiKI
	HSu/xyaDQlxoCLh7pJCQR/X36BDB9TUGETsPb77Ous3Wp5iDkLnqashIQDfQUZWUTXOP+D8RQPI
	NidTor/VM8f8XwlsuM/g1UZV0VLdMUKqUUmwPjUAkhQEt96a4pnjNxAJoQhqoGY/ZQ==
X-Received: by 2002:a05:7301:4711:b0:369:4c3f:8a5 with SMTP id 5a478bee46e88-369e84b7d3dmr5194521eec.14.1792892292449;
        Sat, 24 Oct 2026 18:38:12 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:12 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 3/3] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 10:37:48 +0900
Message-ID: <20261025013748.3755639-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
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

srpt_send_ioctx::n_rdma and ::n_rw_ctx are u8, and neither of the values
stored in them is bounded by 255.

n_rw_ctx counts the INDIRECT descriptors a command carries, and the count
guard in srpt_get_desc_tbl() admits data_out_desc_cnt plus
data_in_desc_cnt, so up to 510. At 256 descriptors n_rw_ctx wraps to
zero, and srpt_release_cmd() frees the contexts only when it is non-zero,
so every scatterlist and RDMA context the command allocated leaks.

n_rdma is not a descriptor count at all. It is the sum of the
rdma_rw_ctx_init() return values, which is the number of work requests
each context needs, accumulated by ioctx->n_rdma += ret. A handful of
descriptors for large transfers can pass 255 on their own, with no
unusual descriptor count involved. A wrapped n_rdma is then handed to
atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) and tested by
WARN_ON(ioctx->n_rdma <= 0), so the send queue work request accounting
drifts too.

Make both counters int, the type the values they accumulate already have.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dfcecbe3a47c7..a2af0882eff5a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -959,7 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
-	u8 n_rdma, n_rw_ctx;
+	int n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 506c11b843593..d9061aa65c1a8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -223,8 +223,8 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-	u8			n_rdma;
-	u8			n_rw_ctx;
+	int			n_rdma;
+	int			n_rw_ctx;
 	bool			queue_status_only;
 	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.43.0

