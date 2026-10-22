Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679997;
	b=D35AXDHB0f4Igqa022obyq4tMixBs+7/pidE2nMbgDGdld3FczPUM9VD4wnAMGLJKGwD
	 vRBO5ZU95p0OBVjfQDUalf/jPoefG4haJcCgztPKegKJgWgdvQafD4sAC6CYMHzvsHT0Z
	 jjmVPIAIOZ/q4DZmcgjM/3L3C3fid2dX5CJgotdo62IFfl0iSYD7TbWHPz8+dEhCK+SrK
	 pe3Pb4R0/nwXKPBU9onZ4EiV3CHRXRN4ACo2WVjlxe0dsawQDmKAML8/CUOWDCRL0f20G
	 Q6+h+6KFEvSfkQVVQ1iNv+z3BlH0UCIdEM92+aUq/gWdI9GkgzkPNAL4MFPCwo4Crkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsVtZqyGS71E5D3pQPE0mMNVJWhaOlaJlReFBXIDzUM=;
	b=ItrHZvwx3fFyENq1bzh3B2pMhp0akgsj4TJYbhkprXbG2BqcwxVcGJLqokh0dnX6/ANJ
	 9+a+B8cBG/h4uBcbYkPYSemPIDhiGk1bA3kZH+rwrPMV8Ef3couixfCdpYhfHnd+WuM2T
	 QkkY9HEnL8RZjCDNkvXv8Qnxo1KTEft50aGfvu9FEvLyrW4muSJZpR2oJJH3SD7g3derD
	 PputLhMD7CiOARmTQ32J6xsCg5wYmZ7xrT6JxQRRLMIYq/FzzVSuNvLTP3HE1hYjfIg0y
	 oxmwRpcMkj8KIb32TV8H9rYZe1XPlKWJ94v1TeGhaTeNE66N84ZVr6GYmz+4xaHFtVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=tNSU7zVm;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB6606A33A
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 14:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35EB6606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=tNSU7zVm
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d577so1709209a91.1
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 07:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792679996; x=1793284796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TsVtZqyGS71E5D3pQPE0mMNVJWhaOlaJlReFBXIDzUM=;
        b=tNSU7zVmKU/HHHTlxBVkbJL4t8ldBOPRMROq9Oi04M97HxCp0LXAHBz+iPTY4dLD/L
         fNstykDXUyb73Jig3KTA5TbQMFxbXDAYVuYy0F3RX4oUovYfvaFwnEE5R9q3ob4MvzVI
         Et70Qab4D2y4GSVsjXl7H8uqI6uYZ3LlFZODL/K+Cq1xAx4uJsgs/pbHCjwCF79rTENX
         8Ma22JDiGppuqf9QItmr5u5nNEebkn5hZv9dBv0mZb962UZLm9RDEUTfAz+wcuRn4u/b
         jyQk1ZodhTD6z+ekWV5+5lKhGJ/1Fxfgq0GJ/eR86E7HDJjVyu1sQjVCqlCHY0tf+P2t
         XrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679996; x=1793284796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TsVtZqyGS71E5D3pQPE0mMNVJWhaOlaJlReFBXIDzUM=;
        b=NxDPUVP3/cPwc0UVO15NfLEBIluvIG5SQaoC/1Wd39LDqfU4Cpo45KsmmUzoHRrD8y
         nGEim3dX65UjKCPOPxn9JF4Dns11vc/LzjudHoNvg1QXZf9+059dgKBNDQAQkI00Zf9H
         H01QR4/l8ZBXcII7FRIt2L+vYha2P9dGnuMaSbtLVh5wEuS2YXvpscBk3SW0HNvYh21p
         9SNNCWrFWSfEj10wnzqfim/H1fAu4mheqskPZFYs9xKMo3x6ECK8gFLC3VJOF3qJPm95
         /kIzgnP059+mKl5/RzXiDJ2bqMoWtxv9UVSfHjA6rBXVLdZpCRo+3zSwvNBi8Ktlp6uq
         UsHw==
X-Forwarded-Encrypted: i=1; AKwUvBylNZS9TF8QxBGL1B6FGgjkHXFh0coW04P1Tj9A4w1m+/qCwxeJlS1YHMntGhZMrujAycgde0idc/m39Gs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7etZoxwbZ8xuh7Tfmfx56+k5WrPsoZ6bsphBfIdDGGUa8XWjG
	p22UFQItpN9Vqc/Vkl50aZENx8LLnjDYcRKygEi6M6WXREuUZf/n6NkJfXPfwyiTGKE=
X-Gm-Gg: AYBFou1cO5wYZEMs5y9L0BBY7ddm8pi6GbYIykxGDXeRapSWnRHhplXv8JUfgcbHTUu
	1FEq2xrMamgA8+EhDdaZBvyjAmVIxt4ni3yxzPKYpIVVtfX9HElEhS9m0jiA6q2wP7RGBxYw0fh
	Ec5SEml5qBMfpBSR+6AbQ2dm7ZQg2Kbgfy3AfE0PH5ikG+orq4PT9YQoAgCsaOtI7QiXjHDIuJ7
	L5/+PgKM/JXp6wO7I+3XksTNbq+5JblipgM8V3Owy6KnqTrdk1eRDgxO464e/hJSgR9strZw1ea
	gZxQtFdieOYL0nSksaC+GNTuFUxHwldByAvkcVVpLkFQXU3UIv2gLN3yiPqnEJzs8geVR2GlP4w
	7z/ORVIZtNwO5gyQQqsecQGzpZa+kSssZdol/8ewRxxGvrLXJMjt0CDdM4sAOVNkFbQGqFFhnqR
	HrxBYs7OxT43G1WJw0sXpBlF+byfKb6GAmE5xHzo4pJJhTlkvoH3vuMY8Fb7+yupyDW27trvtDi
	pj4YPYDW0E46H18BR3BzVZO6+4WzYqRrjcmrl/2LX4uCqPVFnJKdYuQWDe6fVdjjjHWnP8eBVKp
	lmY=
X-Received: by 2002:a17:90b:5908:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3ad86f44c42mr4641606a91.10.1792679996527;
        Thu, 22 Oct 2026 07:39:56 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4887669sm4719043a91.2.2026.10.22.07.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:39:56 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Thu, 22 Oct 2026 23:39:01 +0900
Message-ID: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
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
index 97758082f71d2..bdea47316539f 100644
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
-- 
2.43.0

