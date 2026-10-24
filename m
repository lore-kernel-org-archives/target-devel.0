Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859355;
	b=qKcoGjAq8DkNyNsyq9+QLlGREfbLLzLIdYJuTNnobgVMmptgP1n2xth9zwM9CLax3dZs
	 kxwXpBpjRTmVmb5sW0LiSQYT3I3oUnLFN6uxTXR1rTg/gD9ItqcKxJVMbC+3QK08/0pQ0
	 VSfviYvXLuGL1OCApbL/AMO6e15CDb7EnelFChHwHpLzrsySk9e0+mjdrEUun0yvC+sx1
	 YsTuvIZXtQrb1If5raI0CmQZqLM6kfTJpNRarxOwgZvI6jtYaWbbK95xg5ElpaERC8aRA
	 KMq+peQ03e9CJ2oMovEK7ILi61Qazb9y0Rcb0eyDwKRi63XbfCQ/30N1y5MyYeJGZ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
	b=srcIjGPBVxP4UsDt36Qx/OfeT+qrCroDz2v1wnPWBvrEoBYfunAVKR4izRg1Y8eHEn3I
	 OyuKaYIVgqo4JtmSzIJDp3GOxmLk6z/bO9E/CsWGMY+fh6Lr1yuXzen9xB3j3O5sCAm3U
	 gIvKCWE1ud9oLYZd6eG2S7SIAQihaxAmM7RCdNJM3pcGjG3FYEwFhmQ1IlPGpVwM3NPLf
	 N9CXL3Kf/+NFdQ7k1sygPlCFfm6FZynPfMpmJL+spA9gZwFO+9SJesvhY9wOzK9z8Kydz
	 C9WgZrsHFR8ubWLWmpYY2uYw9JFzwGWMmwLHNub2Hthj51BxawJpISxd1sWkIfZ3QXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="LH36/ts3";
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76CB606A325
	for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 16:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D76CB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=LH36/ts3
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15ea896ddc8so2973751c88.0
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 09:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792859354; x=1793464154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
        b=LH36/ts36VlL5kZOCkNevpeH7jEyoxgAu8xvN/bAgfRdim+a2kdIfL1nWOf/dFJ1ZZ
         1hLqzHMtWIAZMKvHs1gvc6kfz7ThZNY3lkvtPthr/PURraZcwhjQvZWIpe1fLnqzQIF+
         vJ5FWwUNyxGyxGksDwlU0+YpQYHsn7DV8XCB434XPNWO77QF976M2e7Ti7ck/+k0w3ve
         4L/yq8bW/w8tqGbPYgpjhC2km+tedrMJAxuXmileVgCXpg1NmVL4Sl2P6f33n6DWrAJb
         CmKy6Fva4Fd4cMWf1FPNaKusD+r4PdJW73bycrt3bLM0MyyrbNsL7QvrEoPMOMruP/A5
         r21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859354; x=1793464154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
        b=lMRWVgaQMbjnvg6ZBgaljLxWwHBVOnqeNLi27Qn6inDpFvvUcDXLsu7uMTH7nJdcAU
         DnjLsmtVDWayU5CZMBPi23i01fJXXP47g2rdqgqrBae8wWYYLOfb+ff251US/ofuVX9U
         E6GVjfZSWKhzszrBA1OzSZq0wEUUX7uecIEIYvW0sWmZqb5blKARtgSYuynKvsuuiUpp
         6yPtGsaak9acSiHHNrcxD3v9kbHIivg9wMJg3BPWEgBGrdsjdSkgfnOUY8STqhcE5w2b
         i/Gz3pYcJc42SefVwshABdBaF1dX4kPZB9wcs5tAkPI+ZMSB7ATXUVAzgwTFWfdVRtHZ
         fGaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnnB3ZHsi0gMbE1zHiliqzQmqEHVQHQIl+uIjoR1xqPVVlxX4nCdRWGVadz5TkaHWw85kRCHxR6K0Muks=@vger.kernel.org
X-Gm-Message-State: AFq9FYLEsutxwP1ONcDQURGmh1mNKG6Y4U9bT5I9MVNk7MMcGTJ1p6k0
	uB3wQKLPVjcrSlg/qJUjSgne6vKXo9sVEUP5jgOmOeTwySp/dwptWxY7foUjCsxePnU=
X-Gm-Gg: AYBFou0JT4vRwSbm89vqjevjBBKrIH8JW/0RGsEvaAGDmfZbG9/swInAQEScRttLdv1
	PQnCFVLs8oD5kT9n47aF2sq9dSLu0hohcHKywmpOI0rHNPIviaRPi66L1U8aE7Ktk8nfq90iqJH
	aX8HO69725NkN2gLQMJC6jI8yRbUC46UL3xqL2zmLrt2f8tq6tZ7FJD4caBtbdSVrKBbDMwzau+
	bHKSakTA1Av29i1u8XW9LuF2ohIG0EsCCa5PwwIl6QOkaPpEYP1aAUGTrAP9VhzDht33GV2EhFy
	SnD7mHxMu+/otE0vmfqnOtu7tSnqM507fDgqVr4eWJEAqxt28e22wuhvlKI4z9Lph5tCdFJ5XxG
	YhLKqoUdULxs65L7X+dsLPKrSR0MOf4eqyPB/j56I8xISYuBm06QMtN1pMxCuNRv5P9e8tFvA9R
	b4K1O6udkUu7g4iQeyqAOQecAS0w0Jsj3lJk/++LSuURklSedSsavDPKP65Vgs46iS26FYPGg13
	HSt0R69XNxRgGwfsGvnI43bbxDjgCtAykuu+zNk9HljXsbuon5/9ISnYCYaLVMnYDRM0GZEdUK6
	0AzXtiCJQLZNzqKgZn5VyjSN+19kc+VxOdneltEF3pDnwkPHizqy+sL/KZQnhdvp
X-Received: by 2002:a05:7022:7f14:b0:150:c9c5:1ce4 with SMTP id a92af1059eb24-19928f1541dmr3135285c88.6.1792859353934;
        Sat, 24 Oct 2026 09:29:13 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19a3736d16fsm7192350c88.12.2026.10.24.09.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:29:13 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 01:28:52 +0900
Message-ID: <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
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
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 21264264356a2..17d77818c2bc3 100644
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

