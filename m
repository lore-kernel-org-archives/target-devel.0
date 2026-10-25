Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892288;
	b=rdteQRD2LQqXRMyoIqcBD95P9eBFb/5O+18QNXm/wTGJxmWG0fzUPLHd1iPp4+clOs8F
	 r4NwmL1NnJ31O2AUCtyz/WQZFVyD6k9SJLl96y+BkhuPiOnHpG1kE5ZByzK4DCxmg7rdD
	 9CD2ZSiRZDvcRIQ0y4t+XPM+7I5zXSEPCeJo0z85zFgdwwlcsVVyOVTSZyTbZdzEKL4KQ
	 bTDSm6TSmf3ba2+wxBkRCo/mWylXSjdmZpBfzWhdwSx63cuOGNZH2TklWI38OnQsHZw04
	 eMCZPMop2qPtLuIDOAPkic0rHnkI+qVd0IHL7sRZLbJpsizmrXUkk1jM02cDffy+6oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892288;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GE7Vb8T2woD+VGnNBcKvWotC6HZWTCQNkbu5VL66Vv0=;
	b=5NaT8iMKVO9NDJCsyJMPw24tMzdMLOVbFEzGfmbOQzVdh2jOJYjzNdQSw6DUQ7B3CDkI
	 xhadmSj8/+P/s1HOBt8g0RABqY0PxgVCQnXx7pmYpnC5dD+3uCTcVT9X9mrWyMp+IGHAa
	 0qxSSsfv5PpqirUOJOUKMd99NUxQshaE+ohGRAVFGlLGMOnpx8b2VxVfkIUknytxqSwJM
	 bPij9nfKgZO/ZS1hLYtXPq2d2DGtHrvEX19kEfzmtUXrrgBGHrSRSeG3ZOzYuryV/Tw/b
	 lVLV7hF2nAnTPw+qXTX9omZGpPGObMCEJ9RENN4yo1nBKSRWMFseY3h9G35kNs/Vh2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lgsgyk2I;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74329606A325
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 01:38:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74329606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lgsgyk2I
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3514b90bb89so4673902eec.1
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 18:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892287; x=1793497087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GE7Vb8T2woD+VGnNBcKvWotC6HZWTCQNkbu5VL66Vv0=;
        b=lgsgyk2IbT9HmYkF1vkL1psHiDVukRm7MKEwrZkVUM8QFdh7blIn7iMzfju7b/2w4d
         1FHlMJZ4v68W1wiNSUF3QiBh54VsVFyDEMMrZlrhjLIfXaB8u8lY+l2FRYcnmVANAFF7
         lLygdedp34vN8kGgA/Xv0bxuQVl5x+s8LpM0Fpb1oa14m+94MjZwON2yKAUNZfRA5ZTa
         7HYU4y2JGgiqlNOBVqx0KyyWF4wjv109UhBS6CAWz00iRJyydbjseO2MWJT8hCsCcmXn
         AZObaGGlD7K2qCgVtnCBo7yyhaM6S4UVex1jEqT/prqMJwQz6BUdqrnoU3Wcw9wRZ6O4
         Ds4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892287; x=1793497087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GE7Vb8T2woD+VGnNBcKvWotC6HZWTCQNkbu5VL66Vv0=;
        b=SZjUuCnJlHnc2JN4sKh0FmjB1OWHa/9JGo808FkLDfn2m/xj4dfTgyU+XmN9xtmQWP
         hRfHMLeWEwuTN9dnHnmyP0TK3qfsP5kp53yyWNVvyL9tS3aP8z8UcbqPEGKCDEjyx/IZ
         MHSW564+aGAzvazvH/DhsC8luEOn5bUdyZtcuXZTlJlO/n4K6txCGYJiZ13VBxA3Qks7
         UxNG/rtjnABVA76GFsJLczqhgz4iI3xStRyaUyMtwsQJrrZSXDME6uPO+nJTJ7fXjCTL
         Z9RLbTIEvHcwXKPgnG8LCuBEEf4h8nmbBi+47P0Ot7bzOO7QfO9K+CxjEZYB9mfWic1+
         sRfA==
X-Forwarded-Encrypted: i=1; AKwUvBzBLmVNfLPnRK2ZQD2Vh2MWx/No4cKvCHtp6+VZ+kYaU9Fo3/99757xGkfkqavvo/bBT2d12NU99fuF6L0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLSltorWruq5SocqZhx9YyeruVXtmd6ROKCeaOSxTe3WnQd/zjB
	wBBbzfzr1iSpFXariA2NaTMqBnGxfJzQ/3fvAwd19FeBslxsQTBEGD/ZVV0w2UKsZHM=
X-Gm-Gg: AYBFou1TV/7O1eN+zr+TUwZOHu48edlGBDGAcXgWN1YqlsgujIfs0zRNduB4hEpAFmK
	2/9SSWoCRxhLwmSQTcT6uCJ/pXCXDPsbqNJVGqzha9j/bhpBkbkqKWb4d2E5PeeqSMuOVxU29pc
	ba3aJAYliYQP2wmLT0/aaieftoYxVPYKU+0zXbeFRPvQhgaeuz+CxJGFWE8nHjGpVeq1CFKnQ1u
	y/1hrA2rSMu/HBr2FDNy5wohZpzYyhdJqXPDp/nUN+pBEqQfr3L5GGigSh50tsINqGNYkkiHB5e
	rbCAKl9Quv1gaIyMt9ocnRfq5dCG7o6yMl6ugbkd++9Jlug33q9kRAWknO+bjJ9kKE6hRff/7eL
	Q7DVfe+UR82JsOQyWa8eRrYIWN0Jt54tudCoZOlHU2cXrknynmM9GEpifKsTxO1DCatzevFtB/L
	GC6avsiNV324pfG3vdTNMEmzsk6DGLeE3pP6T7I3hT67XB0KqaYR7EfRnG+TjQhwes6kyVxYcjC
	hMf4ZsWMeTt1vVUsoAg9i8G2UHpxm8cIoBDzIAe43ReSH2fW09GYNWhH+txcrGlQgzZMizNmo+0
	VDncds6/Ub0vJWG4FQIsthkfZoXu769yBKhZS0KM9yjR7b6u6wte23faer+uNCIg
X-Received: by 2002:a05:7300:e522:b0:351:245b:d1e7 with SMTP id 5a478bee46e88-369e81d398amr5582153eec.0.1792892286486;
        Sat, 24 Oct 2026 18:38:06 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:06 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 1/3] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 10:37:46 +0900
Message-ID: <20261025013748.3755639-2-yhlee@isslab.korea.ac.kr>
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

srpt_get_desc_tbl() takes the number of INDIRECT descriptors from
idb->table_desc.len, which the initiator controls, and checks it only
against data_out_desc_cnt + data_in_desc_cnt, two more initiator fields.
Both are u8, so the pair admits up to 510 descriptors, and nothing
compares the table against the receive IU it has to live in.
srpt_alloc_rw_ctxs() then walks idb->desc_list for that many entries.

With the default srp_max_req_size of 8276 the table fits as long as the
additional CDB is short, but ADDITIONAL CDB LENGTH is an initiator field
too, and at its maximum of 252 bytes 510 descriptors end at
48 + 252 + 20 + 510 * 16 = 8480, which is past the end of the object.

  BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x631/0x870
  Read of size 4 at addr ffff888002d6a05c by task kunit_try_catch/43

  CPU: 0 UID: 0 PID: 43 Comm: kunit_try_catch Tainted: G                 N   7.3.0-12378-g6fba331225f5-dirty #1 PREEMPT(lazy)
  Tainted: [N]=TEST
  Call Trace:
   <TASK>
   dump_stack_lvl+0x3f/0x50
   print_report+0xcd/0x620
   ? alloc_pages_node_noprof+0xa2/0x140
   ? srpt_alloc_rw_ctxs+0x631/0x870
   kasan_report+0xde/0x110
   ? srpt_alloc_rw_ctxs+0x631/0x870
   srpt_alloc_rw_ctxs+0x631/0x870
   srpt_test_parse+0x114/0x580
   ? __pfx_srpt_test_ctx_common.constprop.0+0x10/0x10
   ? __pfx_srpt_test_parse+0x10/0x10
   ? srpt_test_ctx_init.constprop.0+0x4cb/0x6c0
   srpt_test_run.constprop.0+0xc1/0xa60
   ? pick_task_fair+0x126/0x1950
   ? __pfx_srpt_test_run.constprop.0+0x10/0x10
   ? update_curr.constprop.0+0x4a/0x390
   ? __set_cpus_allowed_ptr+0x181/0x240
   ? __pfx_read_tsc+0x10/0x10
   ? ktime_get_ts64+0x192/0x250
   kunit_try_run_case+0x1ca/0x4b0
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? kthread_affine_node+0x24b/0x370
   ? __pfx_kthread_affine_node+0x10/0x10
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34d/0x620
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

  Allocated by task 43:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_slab_alloc+0x6e/0x70
   kmem_cache_alloc_noprof+0xfc/0x2b0
   srpt_test_ctx_common.constprop.0+0x46f/0x9b0
   srpt_test_ctx_init.constprop.0+0x30/0x6c0
   srpt_test_run.constprop.0+0xb6/0xa60
   kunit_try_run_case+0x1ca/0x4b0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ret_from_fork+0x34d/0x620
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff888002d68000
   which belongs to the cache srpt-kunit-iu of size 8276
  The buggy address is located 8 bytes to the right of
   allocated 8276-byte region [ffff888002d68000, ffff888002d6a054)

The KUnit harness that forces this is not part of this patch.

A table_desc.len below one descriptor is the other way in. It gives nbufs
zero, which the count check admits and a span check cannot catch either,
since an empty table fits in any IU. srpt_alloc_rw_ctxs() then returns
success with n_rw_ctx zero, no scatterlist is chained, and
srpt_write_pending() reaches ib_post_send() with an empty work request
list. rvt_post_send() evaluates !wr->next before the loop that tests wr
against NULL, so an rdmavt device faults there whenever its send queue is
idle.

Reject a table that does not fit by comparing the span it occupies
against byte_len, and reject an empty one. The span is the table offset
plus struct_size(idb, desc_list, nbufs), and nbufs is at most 510 once
the existing count check has passed, so it cannot saturate.

The header always lies inside the allocated buffer, since the largest
offset srpt_get_desc_buf() can return is 48 + 252 and the header is 20
bytes, so it ends at 320 while srp_max_req_size is at least
MIN_MAX_REQ_SIZE, which is 996. It does not always lie inside the bytes
the initiator actually sent, which is why the span starts at the table
offset and covers the header as well.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8e7e..40d796840befc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1117,6 +1117,7 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		size_t desc_off = (uintptr_t)idb - (uintptr_t)srp_cmd;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1129,18 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		if (nbufs == 0) {
+			pr_err("received SRP_CMD with an empty indirect descriptor table\n");
+			return -EINVAL;
+		}
+
+		if (desc_off + struct_size(idb, desc_list, nbufs) >
+		    recv_ioctx->byte_len) {
+			pr_err("received SRP_CMD indirect table (%d descriptors) that does not fit the %d-byte IU\n",
+			       nbufs, recv_ioctx->byte_len);
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
-- 
2.43.0

