Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484EF3B19D5
	for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785393103; cv=none; b=o9+3U95CjA1kqb+cCVfBt8BD7VTND15qJ0mkJOIfdg0TOjL6nqteOHY5Idh/5e/flhGw7HICPFaodMudkLd1Z+bw5mHQDBlpnHwH5tR2TPWBi9bxzvtQOnMLLkQRhE5S+fOl3kieOg1su+3R1Ds5m/iphosDk7Ks8+kgf2x5p6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785393103; c=relaxed/simple;
	bh=9Y9BgO1WtAsiSL3Gdurc8SjRxNaQGCvscr7TqLMUqv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Amf02z2cwsePV3aTGsFVxca7z/z8vpO90dWHmS+3NqGp1+w0du6v9W/xjdR8shLpI23NmDb+0vJZeRtGQ3qbwa9Ah/azNYCNEfQpP7F6Q9UMXNo6pQey+EEEAqYL7w7sjOojnvS/ojw5kXa6pxKOZAUkbyC3amxuAwgBePZe/Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ecG2kIVr; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ecG2kIVr"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacf197759so27099845ad.2
        for <target-devel@vger.kernel.org>; Wed, 29 Jul 2026 23:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785393098; x=1785997898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kg9S/o4nFgsyb+c2+vFdfJ2/3S3goiFvIeD4r4YcYuM=;
        b=ecG2kIVryuJJl5/9Ek5h0cA6x/ou74vRdg3IZ99wm8KaHhBWP5toz07AupM6sf8Eih
         6RxDjbfjZXmNdwJxM/Qtv9MSmnjcJzulWrCNZyZVosbPyKjK0wpqvBPezyATNGzsd1Fz
         +kRc2U+fZsOURJ3zHTgjUv6rMtJtFlDqT6wRXXOsdKIRN8/9ocIKcYhjsiRedG54fP0O
         LpiVW+pQLTPaxFNX80gls7o0TdpVRux0lv6u+RJ3GS7g8hzHPHGce29ZuOp8hEK/zT3k
         ljau4BIOCyXrHOO7RYjSt3DigfdRUG1dQC3qeXD4E48cu+J2+NMI6FCXTeOD8b25cCfH
         Xckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393098; x=1785997898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kg9S/o4nFgsyb+c2+vFdfJ2/3S3goiFvIeD4r4YcYuM=;
        b=hN6B/spP1w4G2jiYPoCiTOh6KzNvO2aaaeaZm4VB6e8qsuBui2DRH8E0DzdUNEdg9o
         mobQosvGbYJQNBDNTmV+PVqewiQXsM5y9Z3v286i+HWa6P9cff4+MhjWEnm2nOKcjsWu
         6qntzWdJWrIe0GTy3bbRx1QUqaGwZtdLjQChHU4RDLTxGFfhEkvy4myrbWu2bMrmZuCW
         1s9hGNmCzuHVIt602ebJvhKmjylGsvEmE33W+K2yi5STnWxKgAtuklQnjysmruBVkrgC
         5PVpAMV0e7Yq4lWhg9ptgMBMi9ijilWLR8+uarKMq4toz2A+j4TrRqBiVZHJEmB9N6TL
         ZnyA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1cMk0nWlFyZ5FcqpNSBMvczVee5JeLN9IezCvZHhXb12XGa+b4VN8lumoVvHiIkDlvC3c1MmgbhFmrQI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwHYY48W1UvXd3r9U72QWoRQxuWAWTrLSxe10+vRZnM5nVIhZ/
	5WuMed+YcoYCVBQXXWc6KNwfm9lWOIC1Y41KMWwKEbl84S+L3GKKtQ3/mBOcHHM8jHc=
X-Gm-Gg: AR+sD11X4HtnsqmrO77ntgOgeaSSPsG3ekY5tOvKJUZtryyL/jtPbf8mMsGwtY8KpVo
	bZB4apUrDWwlXBnQKT7EqBn01PHRZqpAyvyNVnciHAOCdqg+pJcMd4YHpGJ+2gab8yp4NTSukdy
	ttalEUTbiNMMBuaAap6EYr5712pkmxWqh7B0F2uGCLti7hcCCGRx9VlhqCa12Bc8hRjvx/w3WBz
	rOGTFhLqtc4UkI4N5+A0eb8NO4l8DTqCnJ2j0dkUdUxAa+M+UzGeBjWXccmQbnaIFB4jbQztO3H
	BxxhRjD1Q1wua3X6ENlTzQJ+6sP/ZYjXVHzBPI7CG5VDnqAO4mROQpyfZ5ief+dGSRmTB0hJ5QM
	VRKTZG35h8v8TIDEpsTmYLgzzwRyc0suGsG0Cu9Lihlmm/EDZpbROZGBImdiWfowKaxn9sTdZp2
	BsihZjcuSb2hXMf0DhSaHrHerejmOFhBLhPt8f9d5uEKClO+Na8RRCzu2pVxIiPWfmJHFJ
X-Received: by 2002:a17:902:da2d:b0:2c8:1c05:16bb with SMTP id d9443c01a7336-2d035cb864amr13717425ad.24.1785393098267;
        Wed, 29 Jul 2026 23:31:38 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c50f43sm21144755ad.83.2026.07.29.23.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:31:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 1/2] IB/isert: delay the final Login Response until the session is registered
Date: Thu, 30 Jul 2026 15:31:23 +0900
Message-ID: <20260730063124.1554460-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_put_login_tx() puts the final Login Response on the wire before
__transport_register_session(), which iscsi_post_login_handler() reaches
only after iscsi_target_do_login() returns.  An initiator that issues a
SCSI command as soon as it sees that response can have it executed against
an se_session whose se_tpg is still NULL, and the ib-comp-wq worker oopses
on the NULL dereference.  The login must complete first, so unlike a
login-phase parse this is reachable only by an initiator the target has
already admitted.

  [    6.469002] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] SMP KASAN NOPTI
  [    6.469652] KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
  [    6.470053] CPU: 0 UID: 0 PID: 178 Comm: kworker/0:1H Not tainted 7.2.0-rc5-V2CTL-gf5098b6bae76 #10 PREEMPT(lazy)
  [    6.470560] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  [    6.471120] Workqueue: ib-comp-wq ib_cq_poll_work
  [    6.471372] RIP: 0010:target_submit+0xbe/0x390
  [    6.471599] Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 89 02 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 64 24 18 49 8d 7c 24 78 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 5a 02 00 00 48 8d 7b 78 4d 8b 6c 24 78 48 b8 00
  [    6.472497] RSP: 0018:ffff8881058cfa78 EFLAGS: 00010206
  [    6.472761] RAX: dffffc0000000000 RBX: ffff88810c78c6f0 RCX: ffffffff964bb363
  [    6.473112] RDX: 000000000000000f RSI: 00000000fffffe00 RDI: 0000000000000078
  [    6.473439] RBP: 1ffff11020b19f52 R08: 0000000000000001 R09: ffffed1020b19f52
  [    6.473790] R10: 0000000000000003 R11: ffff88810596c000 R12: 0000000000000000
  [    6.474153] R13: ffff88810c61b000 R14: ffff88810c6a3400 R15: ffff88810c61b044
  [    6.474479] FS:  0000000000000000(0000) GS:ffff8881822b2000(0000) knlGS:0000000000000000
  [    6.474884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    6.475156] CR2: 00007f1f1b83c000 CR3: 000000006fe72001 CR4: 0000000000770ef0
  [    6.475483] PKRU: 55555554
  [    6.475628] Call Trace:
  [    6.475763]  <TASK>
  [    6.475886]  ? __pfx__raw_spin_lock_bh+0x10/0x10
  [    6.476146]  ? __pfx_target_submit+0x10/0x10
  [    6.476348]  ? mutex_lock+0x81/0xe0
  [    6.476517]  ? __pfx_mutex_lock+0x10/0x10
  [    6.476722]  ? iscsit_execute_cmd+0x650/0x850
  [    6.476958]  iscsit_sequence_cmd+0x186/0x3d0
  [    6.477164]  iscsit_process_scsi_cmd+0x87/0x300
  [    6.477362]  isert_recv_done+0x1002/0x2390
  [    6.477546]  ? __pfx_isert_recv_done+0x10/0x10
  [    6.477761]  ? rxe_poll_cq+0x253/0x3d0
  [    6.477945]  ? finish_task_switch.isra.0+0x1dc/0xa70
  [    6.478192]  __ib_process_cq+0xe1/0x390
  [    6.478360]  ib_cq_poll_work+0x46/0x150
  [    6.478531]  process_one_work+0x633/0x1030
  [    6.478730]  ? assign_work+0x11d/0x370
  [    6.478918]  worker_thread+0x45b/0xd10
  [    6.479099]  ? __pfx_worker_thread+0x10/0x10
  [    6.479295]  ? __pfx_worker_thread+0x10/0x10
  [    6.479480]  kthread+0x2c6/0x3b0
  [    6.479632]  ? recalc_sigpending+0x15c/0x1e0
  [    6.479848]  ? __pfx_kthread+0x10/0x10
  [    6.480029]  ret_from_fork+0x36e/0x5a0
  [    6.480214]  ? __pfx_ret_from_fork+0x10/0x10
  [    6.480399]  ? __switch_to+0x572/0xdd0
  [    6.480566]  ? __pfx_kthread+0x10/0x10
  [    6.480748]  ret_from_fork_asm+0x1a/0x30
  [    6.480952]  </TASK>
  [    6.481062] Modules linked in:
  [    6.481235] ---[ end trace 0000000000000000 ]---

Keep posting the receive buffers where they were and delay the Login
Response instead.  isert_get_rx_pdu() runs from iscsi_target_rx_thread()
after conn->rx_login_comp, completed by iscsi_post_login_handler() after
__transport_register_session(); iscsi-TCP and cxgbit already take PDUs
from that thread, isert alone does not.  The buffers are still posted
first, so the initiator's first command does not meet an empty receive
queue and nothing depends on RNR flow control, and the header and payload
live in isert_conn, not in the struct iscsi_login that
iscsi_target_nego_release() frees first.

Over rxe, 400 login cycles per run, the oops appeared in 10 of 20
unpatched runs and in none of 20 patched ones.  An initiator that never
waits is handled by the next patch.

Not covered: iWARP, discovery sessions over iSER, and real HCAs.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: addresses the v1 review comments, including the Sashiko review.
    Post the receive buffers where they were and delay the final Login
    Response instead.  v1 delayed the post, which left the receive
    queue empty between the response going out and isert_get_rx_pdu()
    running.  That is absorbed by rnr_retry_count on IB and RoCE but
    not on iWARP, where cma_accept_iw() ignores the field.  Full Oops
    included, fewer comments.
    v1: https://lore.kernel.org/all/20260726144213.933544-1-yhlee@isslab.korea.ac.kr/

 drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++++++++--
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750a..93f2fec942dd 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -956,14 +956,17 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 			mutex_lock(&isert_conn->mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
 			mutex_unlock(&isert_conn->mutex);
-			goto post_send;
+
+			/* Sent from isert_get_rx_pdu() after registration. */
+			isert_conn->login_rsp_pending = true;
+			return 0;
 		}
 
 		ret = isert_login_post_recv(isert_conn);
 		if (ret)
 			return ret;
 	}
-post_send:
+
 	ret = isert_login_post_send(isert_conn, tx_desc);
 	if (ret)
 		return ret;
@@ -2585,8 +2588,17 @@ static void isert_free_conn(struct iscsit_conn *conn)
 
 static void isert_get_rx_pdu(struct iscsit_conn *conn)
 {
+	struct isert_conn *isert_conn = conn->context;
 	struct completion comp;
 
+	/* The session is registered by now; see isert_put_login_tx(). */
+	if (isert_conn->login_rsp_pending) {
+		isert_conn->login_rsp_pending = false;
+		if (isert_login_post_send(isert_conn,
+					  &isert_conn->login_tx_desc))
+			return;
+	}
+
 	init_completion(&comp);
 
 	wait_for_completion_interruptible(&comp);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 0b2dfd6e7e27..0bac5aa66c80 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -178,6 +178,7 @@ struct isert_conn {
 	struct completion	login_comp;
 	struct completion	login_req_comp;
 	struct iser_tx_desc	login_tx_desc;
+	bool			login_rsp_pending;
 	struct rdma_cm_id	*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
-- 
2.43.0

