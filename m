Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792511928;
	b=vDoP4/URQ+rjWeDFExwCKICW85DqTpfRxB5r29zE8f/4fe10ZkuIMpcvrExY6CahLXCS
	 WqVcAHvNnW5zU79+ogpaxS8bKe5Rq9tM1J2KR/sn0rJCO4iGxaOc5fmkAH+Dcge+GEIY3
	 8m9G0OsigCrP5BNr8O2XwXv108VAHVaHOccM/qnxbOfxbRduUxDebDvG9hIN/uz9UgBx6
	 YHs5KdMy38SaGBblzoBi8SBUVSrMiVSe8y/N0jvtzVp0HEgC2aa2Wuts+Ld0yQ7JmjjEm
	 spfSdnvr5zPHhsp7b88NJBANF3hsEQGZ2xBuJI5Fc8XdWOSpyUFNkV7lMwuz/dztnvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
	b=Hm8kqgHeFpZ4lwXbZIdGGH+0mgqgspQ3+B/tBdSXl33mxRsiv5PHBdcT3MRj4L9Mqynv
	 8VZbL+k+7RcB/2g70aQ9agGHtyAh9DWkuS3DwjDNSf9bEo4crAVFZ3KJkSV1X3A1sydER
	 jCyODXQuGa86HXPz4QksD9j91ME/3emNN5KRKcqvrwjPh2i9/6jp5TpDmnSRCjbkXlRBd
	 MXDh9+t6EPNKAJnR1kpGwkmedrmi2oFJg80MpTK/3aW+zXM4FK4b1lx/qLYXPbRSrgP2s
	 +cW90lWmo3SH70TwVdRSwcDGfXQ+Awob0b+JPkfa0X5ME0p+9+n/h8WzWrbKRxceQ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="dWs4F/yp";
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834AB606A32E
	for <target-devel@vger.kernel.org>; Tue, 20 Oct 2026 15:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 834AB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=dWs4F/yp
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e985106c0cso23013365ad.2
        for <target-devel@vger.kernel.org>; Tue, 20 Oct 2026 08:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792511926; x=1793116726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
        b=dWs4F/ypBs2AZ1xwmLiUvBHFlCmf8R90S+EjX+Fr8o++IFJHNgJROWISLM+2DVcbyS
         dpw+SVWSiqE9luRzM2CY+51yYYTnOTpHKt1WkTfQwJQfk3ulZyMsLGsU1y65jdjmEEJT
         fFBz8ibm7omXvqc9BsEdrFc+NpgTa/qI2L2fNG6JY+arBT2Lql13qc47GGK8SBEdqi5j
         m0op8io6miOsGhjy8jODfAQU07B7lBEqsNA75zzXBKy1EDbsL+ApqSgc2d7gaED3+anY
         FGwTGl2lxO2y2TcR9qnmFabtUR6T1FCoGNkLBvH/QH1p2JEYVJcTp5aMUJup9u5Big2m
         mK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792511926; x=1793116726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
        b=GOSqdjcNAftbj1XQItmf9X0Fh3xeJ2xKPgLwouIKGGkJF5i+3Xn0daX4gEczZwOYLr
         YbKRFp5QSJF2shLRONE39NMTcOPl3E1wb7HATRiAUEtt8ACO6fKVjLyrdF+CK9GcT1EL
         e1vKb/z8j3z1a14osgw/TTlQDPIhMjHJHpskrE56TVYpt4ktYO+VS2NEncVfhIqGoQco
         ydyVWWXahNwHiGUYYMHQ4Z002SWYVWYT4KQFivaXn4yFjS3xDbV+xfjtee4aSiUll34t
         qzNPOaZkRGjnZYGKnIrIWpauKa7mP7xt5++9haaG1+jvVsoJ/4LLNdXm8C+PZU2E2N2U
         Y0nQ==
X-Forwarded-Encrypted: i=1; AKwUvBwCULUnoGO8eBfPE2HYZdiOgXaiiPGB8+XTUmxyx7rPtcp7lk6HKWQHW45WvJnlcymc183B3zD9UPVoIY8=@vger.kernel.org
X-Gm-Message-State: AFq9FYL+TCii/fJjPXMWUHplPsTOMS5/J8Qjf8Ano7MMbnz0bdbZ1xCA
	vA9q1j5qKbnEufVw2DGUTaw8m043OJtBQjehC3YmRNNkhsmf1AqaLJpEsOAU+r98S1w=
X-Gm-Gg: AYBFou1kyfcBRlJ3RxDYnSvTyDzzpTTdyUN57rWXqeHyg0MG+HhqTf7H90B51KU0lWo
	PCO9cVh+q7p9nQBwkUc8fmevi1RZkaoVlgIRx6xnbrTzCAebRB+rf9ZD2MvQ8C51HMUtlmFtOEk
	D03tnkznR7SiJ+rZOLgKGdMQU77pTQ3lbGEcd0zLSxZdzjn0aZt+Jj5A1LHt5PSSCRZgNFjOP88
	2NkyaHlBV+/dQyIcQPmv+ZhOzfVtL3vCBRA74RLiSXk4kfdQby06kBUhF39kqtR6BjXYZCF5kII
	30eH7XsNBEKXc9K3lA9jbI2o9d3uaEwGlRkJuqC/77O7RGnnHc/V2ekmCiUv1F/5vlrdwWitRp9
	LgELXPQHAmUy/WqAyYKkJQSw1Fwxr8/BoGqBePcVCyQkgivXr1ub2uLzJ0CmnofUFMYXKqfKFE0
	hH4NfY+VnmQ5ktKIxIh8VPLvQm9jjZ3BNR3KHtDFKtsGrGCIEFlSC6FZX9bGo+qSjCHE6awEiM+
	FfmK/Cp4xBILdlqZbcY
X-Received: by 2002:a17:90b:5743:b0:3a8:cc4f:3475 with SMTP id 98e67ed59e1d1-3acef60db08mr10119028a91.60.1792511925477;
        Tue, 20 Oct 2026 08:58:45 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813de463sm41188a91.13.2026.10.20.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:58:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH] RDMA/srpt: widen the RDMA context counters
Date: Wed, 21 Oct 2026 00:57:25 +0900
Message-ID: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr>
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

srpt_get_desc_tbl() bounds the number of indirect data buffer descriptors
by the two counts the initiator put in the SRP_CMD, and both are u8, so it
admits an nbufs of up to 510:

	if (nbufs >
	    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
		...
		return -EINVAL;
	}

srpt_alloc_rw_ctxs() then builds that many contexts but counts them in
ioctx->n_rw_ctx and ioctx->n_rdma, which are u8.  At 256 descriptors
n_rw_ctx wraps to zero, and srpt_release_cmd() frees the contexts only
when it is nonzero:

	if (ioctx->n_rw_ctx) {
		srpt_free_rw_ctxs(ch, ioctx);
		ioctx->n_rw_ctx = 0;
	}

A command carrying 256 descriptors therefore leaks every scatterlist
target_alloc_sgl() allocated, every registration rdma_rw_ctx_init() set
up, and the rw_ctxs array as well, since the kfree() for it sits inside
srpt_free_rw_ctxs().  ioctx is a ring entry that the next command on the
same tag overwrites, so the array pointer is lost too.  The descriptor
payload sizes are the initiator's to choose and the command can be
repeated, so this grows without bound.  A count between 257 and 510 leaks
256 contexts and frees the remainder.

Widen both counters so they hold what the guard already admits, rather
than refusing counts the guard accepts.  int suits every existing user:
the two loops that walk the contexts backwards use an int index and stop
at -1, the sq_wr_avail accounting passes the value to atomic_add() and
atomic_sub_return(), which take an int, and the three places that print it
use %d.  The WARN_ON(ioctx->n_rdma <= 0) in srpt_rdma_read_done() becomes
a real signed test instead of a test for zero.  The error unwind path
walks by index and restores both counters, so it was never affected.

There is no splat to quote, because the result is a leak rather than an
access past an object.  A KUnit harness that is not part of this patch
calls srpt_get_desc_tbl() with a fabricated SRP_CMD and counts the
rdma_rw_ctx_init() and rdma_rw_ctx_destroy() calls.  With u8 counters, 256
descriptors build 256 contexts and destroy none, and 510 build 510 and
destroy 254.  With int counters, 1, 128, 255, 256 and 510 descriptors all
build and destroy the same number.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216b..b174d58ca98a3 100644
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
index 4c46b301eea18..1dce9bcb490f0 100644
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

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

