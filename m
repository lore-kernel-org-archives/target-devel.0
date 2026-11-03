Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745515;
	b=cOOU8PjizDYziScpckr/NjD4EejZYVsX34OTmNPQg/iNrP1PlZnvZFj5MdmiLlVoH8i9
	 tWOQZ5TKXAt8CiAA5AgyMbynnrxxB45n2S9xxMVofi9GNAnBGlDwesI9LTF6euXbE5eep
	 HzACtKz4VMTVC1reUVUyK/rZtiUbp3/B8lVc1f+fkM8iT6PvTXw313H8xQTF/dlhbfi86
	 NmiNUapv5UzuChKAjs3rzNUj9urZMKH+Wjm9UmkztqEgtYuY2ZPCHuzpoA/GDaTWpGRAc
	 ahu9+VrJ6cpPqaWI12N5glaGdkNX7kRxAamzfiYGqiArgY3lQG24IWm+HraFCKF1lNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745515;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A7XXBCX30Xg3KVcU/Qg7WxIOkAveBqd5SEDNjAUB0Uk=;
	b=TQXACVrYDvD+Edr94fkJrxvDkPJ/59KWsh5MwZI74qlyrbeqdpolBnkKlZwvnQm/PZ8w
	 87Bef9DDLIOQwtMZu20FQrqZ08Kyt9NXB9d/Gw/H00KgXGr67Zm7V2cwAAA23OtkNfbHd
	 UWspQtX11Pybjo5g+8g1Jg6vucxx4lWweI4cBmFrofZ07ND+SmBzAoGqesT1z0XUIURdT
	 4lYA6es1oKV0ts61bQnZ+R5Ef4vTpBXjN1x1mJolADxgdvh7XoPA2tv6s6KodVJJW7M8I
	 rVXpTI9aQVE4buUa8rvT4p25JuIo65930PU1y+WD5zm8dYA7v6W5H4RxG7mYQjmefQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fF3RbS9E;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2743606D819
	for <target-devel@vger.kernel.org>; Tue,  3 Nov 2026 22:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2743606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fF3RbS9E
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so116581a91.3
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793745514; x=1794350314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A7XXBCX30Xg3KVcU/Qg7WxIOkAveBqd5SEDNjAUB0Uk=;
        b=fF3RbS9Ep6qmrVOnUoPxn/Yxr5j7JbRTNIKbWPTNQEPGNpnjZ7xOC1wQZbceJtp02x
         RKdZVZNjJGTEvxRkBhygNmM0YQXjBQuqfPlBr+72WaEYjf/DDUrfr05ENUwH7vMDo3mk
         CEmzl7xnREWEvlG9hxLvkjT0UJUUa+/GmJMfAA5mTRw/NhsP2iFIuQuw14Ph9m5vvEAR
         gm75nY1450I0uIaTtglSh3AEh1/QjqRk+yIVx7R+eYasMlpnXFNsri6s0krIwkl/GobT
         lmxp/lakUZycBYzot0U5nb8qSz3NRAK0CceQcIsSBvSo9vLGTLPc1/hHEJ0b5mzreOlm
         FOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745514; x=1794350314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A7XXBCX30Xg3KVcU/Qg7WxIOkAveBqd5SEDNjAUB0Uk=;
        b=wqfPjnqySdhI6uThuGRjnkVgYRqobcWk9yfEjg2N1aU+k9NgKsBjSxqaOIah4UehsW
         QruGs/Tn8pyU4NPzjsMQXfxdTImlRXZMZ26Aj3tVEgQMRslC9hOCJ0t7VTFy34Vp4czH
         hOnQrzmicgbH1JQSo3Cj7xC2XfK8U/IJYp71YihZQro4b4jjSaG5EVUBOSCG1qMGP0YT
         T3SmEYVGA0ASm/mUVSkocKIAL7ikKu2PaCHvcFgsqeY3t9jLaNH4Lfc90gBnLZYLG/2b
         pVoGvqcO9WkJgMQfB/+H/mE7J4FLYRepT5h8EH4pzfe+cXvxPbI9kgi29U77BijFdfDM
         UMUw==
X-Forwarded-Encrypted: i=1; AKwUvBw6bC9W4pSjL+iQQ1gIDFkMjhLnY5Rjw7ePZ6hKLJtOYyxEpkG5x0QfLm3+ZSM2vupuo26Xyb/GPWrajOY=@vger.kernel.org
X-Gm-Message-State: APuU4Z/X2iL4xNhYL0P6n4SM7BI2QgSFYt4IZnLJQQRhrTIqi1yhby+l
	XCQMf7JIxkifkwrrPp8vziq4pdL9yNFSgZQhHycix7Ucui39QdHSmgdyNXIyVL5ZA4w=
X-Gm-Gg: AYBFou2sHHuOviQNSxty+VcH1TYwqAsvhShTG0ELFInlmyPtNX12w34q5JLfT7stEKM
	dDgJhD4ZQVkGHMY7VK3xXkUbfBvBQAx0UBHsn/8qjKCO5+eNnjhhWBjXDEOK0fU47xGyVRHCfk0
	C447no/mi033JFebQQSleBtSffo3dpHk3euYRfy4etK/ETwCLkXcfYItA1F/r5CA6g1Yl0ueB7k
	DXsd16dHhSKF2vaYh/U0LDuvta1nPvFDG0ysWMj4qyGaAeWjrCluB0Vvi5oxtbz0Dc6IZraGlnC
	I+H+bYIgjhuIhowcEFC3te+76yjpjl24evwQGJbGGVId+KR5RqEQBzqa66a39StoP5Po20fxCxI
	2iEwPjIUyOFvkxba/khnDcA8IkEeKReITo6hWVJH3bMgj4mNDp/3zNu37ulv1EnPjj+AeiHHXcD
	5MvVn+fp9wWSHJLP0gB5jTEaJkHgZj8z/HB8MAOHI1jOWuofoNB7MTc0JhPZ9ZV/N7+ms5wQswh
	TEC4i11Nh0C0kJOyPKIIxKfiH3KFU4VhPY+1xhWSdCF6F57Bx3iatTfGduVLUd2GGuxiq7umr5+
	dntahJTgTVUibh1PVjyV2z+IWvm+jyq0SLFoeiwLnvLxgdpq+RP3oPdcYKgZT2mG85EzmHIUROm
	EfHgJE0DESAEg+8XNzT4rEKoOnXlBsN8uFdjSmXU3SpO06saWslEsigcrBg==
X-Received: by 2002:a17:90a:c2d0:b0:3ad:eb34:4c6c with SMTP id 98e67ed59e1d1-3ae897c886amr12337321a91.13.1793745514170;
        Tue, 03 Nov 2026 14:38:34 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b096b6116bsm223711a91.4.2026.11.03.14.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:38:33 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v6 6/6] IB/isert: only reinstate a connection that reached full feature phase
Date: Wed,  4 Nov 2026 07:38:02 +0900
Message-ID: <20261103223802.1697607-7-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
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

isert_teardown_conn() and isert_connect_error() ask iscsi to reinstate the
connection whenever it is bound, ISER_CONN_BOUND included.  A connection
stays BOUND from isert_accept_np() until isert_get_rx_pdu(); during the
final login response the rx thread is already running but still waits for
its login completion.  iscsit_cause_connection_reinstatement() sends it
SIGINT, that wait fails, and iscsi_target_rx_thread() returns without the
connection exit path, so isert_remove_one() waits for ever.

Ask for reinstatement only from ISER_CONN_FULL_FEATURE, read under
isert_conn->mutex.  There the rx thread is inside isert_get_rx_pdu() and
returns to the exit path, so the signal still helps.  In BOUND terminating
is enough: if the login completes, isert_get_rx_pdu() sees
ISER_CONN_TERMINATING and returns; if it fails,
iscsi_target_login_sess_out() calls isert_wait_conn() and
isert_free_conn().

A test-only delay in that gap, with the device deleted inside it,
reproduced this on all three runs of patches 1 to 5: the rx thread was
signalled and the delete did not return within 240 seconds.  Three runs
with this patch signalled nothing and the delete returned in 8 seconds.

  INFO: task rdma:194 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-V7L5-00006-g4f59be58f97a #141
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:rdma            state:D stack:26328 pid:194   tgid:194   ppid:1      task_flags:0x400100 flags:0x00080800
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? __pfx___schedule+0x10/0x10
   ? __pfx_complete_signal+0x10/0x10
   ? irq_work_queue+0x1c/0xb0
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? vprintk_emit+0x200/0x2f0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   ? mutex_lock+0x79/0xd0
   ? mutex_unlock+0x7b/0xd0
   ? __pfx_mutex_unlock+0x10/0x10
   isert_remove_one+0x554/0x740
   ? xas_load+0x1a/0x250
   ? __pfx_isert_remove_one+0x10/0x10
   ? xa_load+0xbf/0x120
   ? __pfx_xa_load+0x10/0x10
   ? __pfx_up_read+0x10/0x10
   remove_client_context+0xa4/0xf0
   disable_device+0x128/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f1de13200d7
  RSP: 002b:00007fff7f1dd9d8 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 0000563429332390 RCX: 00007f1de13200d7
  RDX: 0000000000000018 RSI: 00005634293312a0 RDI: 0000000000000004
  RBP: 00007fff7f1dda10 R08: 00007f1de1417200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff7f1ddc00
  R13: 00007fff7f1dd9e4 R14: 00007fff7f1ddc20 R15: 00007fff7f1ddc00
   </TASK>

Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2057bb35af4cac..2564c9f5ea9a41 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -682,14 +682,14 @@ static void
 isert_teardown_conn(struct isert_conn *isert_conn)
 {
 	struct isert_np *isert_np = isert_conn->np;
-	bool owned = false, bound = false;
+	bool owned = false, bound = false, full_feature = false;
 	bool promoted = false, terminated = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
 	if (list_empty(&isert_conn->node)) {
-		bound = isert_conn->state == ISER_CONN_BOUND ||
-			isert_conn->state == ISER_CONN_FULL_FEATURE;
+		full_feature = isert_conn->state == ISER_CONN_FULL_FEATURE;
+		bound = full_feature || isert_conn->state == ISER_CONN_BOUND;
 	} else {
 		owned = true;
 		promoted = isert_conn->promoted;
@@ -701,7 +701,9 @@ isert_teardown_conn(struct isert_conn *isert_conn)
 		terminated = isert_conn_terminate(isert_conn);
 	} else if (bound) {
 		isert_conn_terminate(isert_conn);
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		if (full_feature)
+			iscsit_cause_connection_reinstatement(isert_conn->conn,
+							      0);
 	}
 	mutex_unlock(&isert_conn->mutex);
 
@@ -732,12 +734,13 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
 	bool owned = false, bound = false, promoted = false;
+	bool full_feature = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
 	if (list_empty(&isert_conn->node)) {
-		bound = isert_conn->state == ISER_CONN_BOUND ||
-			isert_conn->state == ISER_CONN_FULL_FEATURE;
+		full_feature = isert_conn->state == ISER_CONN_FULL_FEATURE;
+		bound = full_feature || isert_conn->state == ISER_CONN_BOUND;
 	} else {
 		owned = true;
 		promoted = isert_conn->promoted;
@@ -749,7 +752,9 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 		isert_conn->cm_id = NULL;
 	} else if (bound) {
 		isert_conn_terminate(isert_conn);
-		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		if (full_feature)
+			iscsit_cause_connection_reinstatement(isert_conn->conn,
+							      0);
 	}
 	mutex_unlock(&isert_conn->mutex);
 
-- 
2.43.0

