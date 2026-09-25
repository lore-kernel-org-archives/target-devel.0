Received: from mail-wr2-f7.google.com (mail-wr2-f7.google.com [74.125.225.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4484F4733
	for <target-devel@vger.kernel.org>; Fri, 25 Sep 2026 21:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372220; cv=none; b=fWfpfLcAq8uemqBmQnDGCusZB2soVoJ3u/HjFqFAjofuBpFfwQUK9OEtNkqGiWrjlZaE55sXmgN+RhAEnSlPqXC12cUFd93ofnKEIvBV1/LcKyfuKXs+z5T3jGAge9HMIBAJka2d/RqzmHc27gdDcEkHJ1EeueRGWfSCkW6uMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372220; c=relaxed/simple;
	bh=14Acq4QSZJ2hz6pe2oxe3D/5LXQaAWPm75oRsFXV9a8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u/9gpd5K2FN4KTq2UWUXXNGK9mlJLNoeFH8jp6q34XsURuEQQ1meusgMtgAwC4htDqu6AWQbVs9fxbC7TF24hJtfnIWsqinMMnQP4LlTwImIJiOiTHqfsRSOE4Ykd8THNpEf0q0jl9+TL3zRqa126wqFo1QzpAWCs5zS+LdV4qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJXB3m8B; arc=none smtp.client-ip=74.125.225.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJXB3m8B"
Received: by mail-wr2-f7.google.com with SMTP id ffacd0b85a97d-487166a578eso100973f8f.1
        for <target-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790372217; x=1790977017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uH5VHzqYeyzrxon03BvBTLMWbRiul1yKTMOPE8eGDHQ=;
        b=UJXB3m8BWUABzBMwtJF0nYnO9hZD/W9JBhG1kTxE+2+FQ/xBiPacVf4PWwxXoc5iA5
         G2TAHJjxcsRfrajXhlcMAKsbNwBVxos2syNiprkFoWhG6FVc2TdTZe5dXnVcTYqzEE6V
         a+ym6q5m9EqUePi6x86Qa3Gi6RM/ag3Rw75KZ05o/FQbbEV8qfbX9KbUQuqJS0UzPOsO
         +4bWh8r9zyuXwNfL8SUj7iylOErGp7T24ud4JjPgB4KPnXK+003AJ3JjCYj7lu8OieW7
         /5JyYad7MJfg1j5PvSr/Lf7kc45WoVbY/zgO7troNMkC3J8KGW6ogWe7GlilFwB0ARJp
         eCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790372217; x=1790977017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uH5VHzqYeyzrxon03BvBTLMWbRiul1yKTMOPE8eGDHQ=;
        b=1fAqK+mcftRSTPTEBHTPM4vvCOz91m7Q4Gu+dmyfRuTrcu2JE2u8kobdmO2gUvPpwt
         UCCsqYtYtyrqtDtaxjV1r5BKZ/jRwpwTxW34fJwpcc6aiEk+iIqynGPQ7yYk3cckrSpa
         u9VS+XhWgGuYH4bKQwB59LtDXBZPRS205jjJafTPLP0IGzlCa/szOMSJdNOqukRv5+8r
         s2YcAu4m9C6UcsutgcIv2XSVjyrlPeqYx/srKKtyvla9hi4RZAePx+B7924W5GXAm2uw
         ZgVwBcjUyGSXXDONxoSfpGTioXQ3K/W4dWwvhV/KCFIekSG9SwnVKs+m8FdkRj/H4CTX
         NPJA==
X-Forwarded-Encrypted: i=1; AKwUvBx0XLaYV43vRGSfVRifnhxQh1PYxCqoZomJnd+hICXAOj2zC+I3VF/l9TTsT5dRggc+fKJVo1PylL1nBqo=@vger.kernel.org
X-Gm-Message-State: AFuF++nJjANYHOXUGruEvVlGq7KANO8+bhy74biR7ZnMys39pqrXpa08
	7lnVHLwar+8K7OwWsdBxGY/1GUlySJCcnEsmZBZR3IBun2JOcFEt9zQ/
X-Gm-Gg: AYBFou10u7zW8KGyZy2NSUioUrme3oBUMgL85ZMZ5MmtzYGsMXOJHPhZ259c+MHlZb4
	r8f9Q6u7EkGfD2R7lKaL8lyXR40eu1lhsqs5YdA4Prum40UVRYZ+jFfB1A/iGEYh9XixfPosxpO
	TzBHSoPWZXKdwlntKx4Un2KGAoSJhQRbQ25Y6N6HmfiRq7XBPLeE0LHOduFZYt8FRtvdsPZvdO2
	SHMg2GaHT1O9/Dws9BElgrt495WaGC/taT9u7lNdEz2Hv+fKckjMulPwtvYKDAUJwyaVIYPPt/W
	tWd6A2VnSxtw4sMIInllYape8Jfby9M7hxjH3hSHW+/2A9CCY8eQrP5TUgXVwggxGPVhNBxsI1T
	6ktbw1h+57d3ec6GHajlBJJHvs9YoZTUuCpIpFhBLwsaVr0CISwT9FMWcRkPeklqxrbh9FDQlgP
	/IKFa1bpvplQQYZlug1j+YTy4EkD5Tq8nKrCU2pBoB/E1k4z1p42tDC0toOIEHj6rY2HCuPqjYh
	El5Ri33d/MZ4n0=
X-Received: by 2002:a05:600c:8b28:b0:49f:fbad:29ae with SMTP id 5b1f17b1804b1-49ffbad2d56mr188775e9.17.1790372216761;
        Fri, 25 Sep 2026 14:36:56 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fee915f3dsm84624035e9.1.2026.09.25.14.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 14:36:56 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH v4] RDMA/srpt: Reject an srp_sq_size that does not fit in a CQ
Date: Sat, 26 Sep 2026 00:36:29 +0300
Message-ID: <20260925213629.8039-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srpt_create_ch_ib() asks ib_cq_pool_get() for rq_size + srp_sq_size
CQ entries, but srp_sq_size is only checked against MAX_SRPT_SRQ_SIZE
(65535), never against the device's max_cqe. On a device with a
smaller limit, such as rxe (32767), ib_cq_pool_get() keeps allocating
CQs that can never satisfy the request until memory runs out:

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

Reject such values when srp_sq_size is written.

Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216..1761345b33f1 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3603,6 +3603,8 @@ static ssize_t srpt_tpg_attrib_srp_sq_size_store(struct config_item *item,
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
 	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
+	const struct ib_device_attr *attrs = &sport->sdev->device->attrs;
+	u32 rq_size = min(attrs->max_qp_wr, MAX_SRPT_RQ_SIZE);
 	unsigned long val;
 	int ret;
 
@@ -3621,6 +3623,11 @@ static ssize_t srpt_tpg_attrib_srp_sq_size_store(struct config_item *item,
 			MIN_SRPT_SRQ_SIZE);
 		return -EINVAL;
 	}
+	if (val + rq_size > attrs->max_cqe) {
+		pr_err("val: %lu exceeds max_cqe: %u minus rq_size: %u\n",
+		       val, attrs->max_cqe, rq_size);
+		return -EINVAL;
+	}
 	sport->port_attrib.srp_sq_size = val;
 
 	return count;
-- 
2.53.0

