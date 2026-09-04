Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB03803D0
	for <target-devel@vger.kernel.org>; Fri,  4 Sep 2026 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788552228; cv=none; b=ZngmuGEbZapAjnQQmwIuxWPIIQ63NZlIFx+PpPMWbsZcdzlA34BSqzOB1WRsuVpRyddPU8rXCfcUr68L65XNwgA2INZG0QyBM12ejgdZZBR7EiXboX27Bdhq9zWfl9TTEq4wjFcGc4k0oKSdwCF8sjAagyh+at7qj2Fy8nx8eiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788552228; c=relaxed/simple;
	bh=vmLc0QU+7tEqTAWdMzWFy6dCmHlNO9qldr5uF86+PMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YppWHishFxQLnuHhNVOhyPs1C8Ro2PFWnIa5M5ld5rTM2UGs+KfBCwC8OxfIH9NS5LwD1LDUWB6TtJK9KMpI/PhmPJd2m62MHpoGVgnkIz4GvKtj2d+IKtrChGvALO4a0w9VBT1ebwQaJdJx94ajQho+lFK93c1QrOdftNWhCo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXkF5btR; arc=none smtp.client-ip=74.125.225.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXkF5btR"
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-482e61db882so314986f8f.0
        for <target-devel@vger.kernel.org>; Fri, 04 Sep 2026 13:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788552220; x=1789157020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3UTb+wha3en9T7ds19Z5GD7eJbXn6Ymtux42hGN1TZs=;
        b=JXkF5btRjLVeBkun5UWWZ/sB4imYW/MqmMiEabig3BelE+mXsbsUUY0xs6KJ8mH4nK
         bK1uwlCD3G/9qGfC+ozlr46ZGGCUy5XLApTPh71d/m0Rlb6TROhsTWBkPIFLYWnxeQpz
         up2ZjGbIneuzNoeqNAJpYATV8dnt6VspNUnWL1opUjp2ur2zOpHzEnQjgNaeJJ/NV2KX
         Ko0T6thZcLn9z7a2T0GR2DvVmpepI2SiXUB2VxAg7f9jJqjzchPS+PXrTaC5E+3lPot8
         QSK5b4ugBMOFAhAijP7c0q182jVm29oN2GSE0PDEyc4xF4GctS0gu3w35SL4+Inq5k52
         fnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788552220; x=1789157020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3UTb+wha3en9T7ds19Z5GD7eJbXn6Ymtux42hGN1TZs=;
        b=rjoWeq/PLRObkop8dK9YMuxeoKW6lAh959BDY2hariAp7UPMy9VsL9pcDBMIGp9hZj
         EWaEu/8mMaGLkXKqy6/n5KQVCiGKkHDAl5NjEhkQbmxOsucsmHSQgXaX0ei+KHMWU+kv
         XTqLiw+q+K1uiy/zvdQoG2qUk3o0CkQqCp+SXGMQ0LVN3RF9o2uvE7fKPBpLqP+LvVUj
         tu3lmcqhF7yUMbv0a0XDmO2PskahSrPhInAQRPDZoIgziAvRN7g7scngwT3mlOm4937N
         JKFp/Q0jNoB0zXPKo/R5udAXyfZ9FZk9giHOlhpGxJRIJLqUa82l65qxa4mRPdeZG0JS
         71jg==
X-Forwarded-Encrypted: i=1; AKwUvBxN7r/Uxtw92cCds7XvEb1bJUG4RAstxQT8CC9FG6uv2QzKJwkB/duteQ1XEUXk0VHP20IJh1HQmMG2/Rg=@vger.kernel.org
X-Gm-Message-State: AFuF++ll8DicFufD9JLDI9ZB5FaEFY/QDEKkxDhXuOM44dobK8PwRM8t
	+QSI6S1QaNJ0Aauhos9f2xCP1KHN4rp00GsvFx7J4WYbfcFaZXgV/1TB
X-Gm-Gg: AYBFou3SEo6vpafESIccuIFT2u1RC8TrLKwngFhU+/ujeINpTyUPG57DbnQHgIL+bsw
	b+ropviUq620H69lnFsdupE4DIZMkavFh5IqZMi6iVOSlq9U5lsmTka0lqbZ1TvwQI9cHDfvvrx
	lAb7+2144cMeakMHrQizJ+h1Ymtk3XGwRcmpZhlH1gmM7RBUP3s+7zJ1llEOcGow6sYREEJ8C3d
	YwKIPiSSTmsYsxOclSaonOJ0H5NsTsllCN2h4fLjuSOPcWHnq7wMm3mb9xB5/sxv+fTp+ItnERk
	IoznbAhf6k3nOLdIsEUMUA42cEaOiq2t16TgKFRaogjXDc7FyF9NtNk0aPJYwdKtqaXHkCyxJjT
	qxW42liJPmPquWCKZYIbke8pFE+VuVu17QPzjfoYltqhLvM2RzKydajR73meDB4bZN8bsf1FpB9
	VrVbYoFu9ujQkDmpz5YGUF9hup9lRUWBKOMzUv4WVnXAtNcwxcaSYB+MPWaRj/LKLOoVb0KuG43
	qtLkz/c9B5POtDFAtcBycrtcz0=
X-Received: by 2002:a05:6000:610:b0:485:82bf:8728 with SMTP id ffacd0b85a97d-48586e32b7amr11331315f8f.0.1788552219337;
        Fri, 04 Sep 2026 13:03:39 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885c5bbdsm7868460f8f.36.2026.09.04.13.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 13:03:38 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH v2] RDMA/srpt: Clamp the CQ size request to max_cqe
Date: Fri,  4 Sep 2026 23:02:40 +0300
Message-ID: <20260904200240.48976-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srpt_create_ch_ib() asks ib_cq_pool_get() for ch->rq_size + sq_size
completion queue entries. rq_size is bounded by max_qp_wr, but sq_size
comes from the per-port srp_sq_size configfs attribute, which is only
validated against MAX_SRPT_SRQ_SIZE (65535) and never compared with
dev->attrs.max_cqe. The largest configuration srpt accepts therefore
asks for 128 + 65535 = 65663 entries, while rxe caps max_cqe at 32767
and cxgb4 and ionic are in the same range.

Such a request cannot be met, and ib_cq_pool_get() does not reject it.
It clamps every CQ it creates to max_cqe, so no CQ it adds to the pool
can ever fit the request, and it keeps allocating batches until the
allocation fails. A single SRP login against such a target exhausts
memory:

  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory
  Workqueue: ib_cm cm_work_handler
  Call Trace:
   __vmalloc_node_range_noprof
   vmalloc_user_noprof
   rxe_queue_init
   rxe_cq_from_init
   rxe_create_cq
   __ib_alloc_cq
   ib_cq_pool_get
   srpt_cm_req_recv.cold

Before commit c804af2c1d31 ("IB/srpt: use new shared CQ mechanism") the
same request went to ib_alloc_cq_any(), which rejected it with -EINVAL.

The existing backoff, which halves sq_size when queue pair creation
fails, only runs after ib_cq_pool_get() has returned, so shrink sq_size
before asking for the CQ. rq_size never exceeds MAX_SRPT_RQ_SIZE (128),
far below the max_cqe any device reports in practice, so the
subtraction does not underflow. With the clamp the same login proceeds
exactly like a correctly sized target.

Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
Changes since v1:
- Move the fix from the RDMA core to ib_srpt, as requested by Leon
  Romanovsky.
- Clamp sq_size before the CQ request instead of rejecting oversized
  requests in ib_cq_pool_get().

v1: https://lore.kernel.org/linux-rdma/20260831171354.72140-1-serhatkumral1@gmail.com/

 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216..58064a4c606b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1867,6 +1867,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+	/* The send and receive queues share a single CQ. */
+	if (ch->rq_size + sq_size > attrs->max_cqe) {
+		sq_size = attrs->max_cqe - ch->rq_size;
+		pr_debug("reduced sq_size to %u because max_cqe is %u\n",
+			 sq_size, attrs->max_cqe);
+	}
+
 retry:
 	ch->cq = ib_cq_pool_get(sdev->device, ch->rq_size + sq_size, -1,
 				 IB_POLL_WORKQUEUE);

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.53.0

