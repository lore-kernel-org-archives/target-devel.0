Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765028;
	b=DWKyQ5n+1ayW0VE6PML703VzzkX1MhLBXXB3jUhtY39gP4CrVRGlI+epd+dczFrKJpAP
	 YPSeObvgcjhjV1vJ+YHowt/ZavKstBwrWUKnMcPCC+Le0OesElJSM7FnrY+tlfJ1li0PI
	 99HN02bw1yp79V8ZIFFDg7TBcB3IB4KkENmxRWWr3koUNlNTj4z1KeXpIVb1CUaS2SVZ3
	 ujbijY7Flc95YXMc7ra9xqxURbk1DiX8r43bBr9TcSsQyqOQLavFA5I0IFtm12cud2zyg
	 fw6NBl4iWQkjs1z92G4f4Ms6KncZryRbS7j7I/HdGJt81MVxi6ktqrfFEe16PPd6j2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
	b=JLD66O6D9g2cVxWYv6LTpDV76G1TmWkHVnooFXHsAn1yqQLaVRSVu9C8f5gEeA2eDnUg
	 GIV81XVmuFCc2tBmjgyYZAxTZv5HTPsWmTXBeOq5S9JW9cYdUIpL2aP3k1K4nLHDMHx4a
	 J/zOKtihP49zeV+2kkspVOSwGRrzLI9gOYNHr2TG28cpntjW+CUcekaIWRarTYUUNDW20
	 HT7mGT851cjtmL9ChJz//jGiipMKcr1YT+6jeGcwNn5qxkCulynVWfPBIkjZQG4CSTrGx
	 HvNBh0nBT/z/Cttwv+0+on+pG1KW9OtnXuhX+IZkR6whfy9FiYqpuIrEw4D8yucFwdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DNtVJy7W;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5AD606D808
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 04:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC5AD606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DNtVJy7W
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so210625a91.1
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 20:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765022; x=1794369822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
        b=DNtVJy7WBdr4kZIW7QEIk5Rbg47m04NQtpTIUQPEfgspUFHSAbxuyZL+fG5c1tDAsV
         DGdZZSRgcKm+NeZuVDSeCmBNqwyW63dq5L8UMIVTEAhZCBCyDSF9JVxIXexi19TWw1rD
         0LorfhFY0i/mXa/3HMq4zpabDovDljqosDDZAV8axlGIOu1gQkg+Q5DBLNqNh0cD+qkH
         GWK2M+oxgcmE2ps1koAJoSVL/v3ttCvlmnPyCmVy3qnqgspH1naBzgKzk16/071bwqvo
         x1DuHQzUPxa+wSZQHPi3iu8u7JUniKbNKB/3E4WiILxQ9CiHOR9dGYZGzBwGNszuMwBo
         h69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765022; x=1794369822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
        b=oH3/sUbALytONBTL/Agnli1XrvhzspdwN/39i3DEkbBgKrKpog9WQXg7iP2RBWi7Io
         tKAzHBMI6/RbU38AZt/KxNSAbeesRahQV0v4B+3iUf3XjV49OlhGzXc21O3BvWkCd/VS
         D9FAF4Ij0ceAtcT3TTdE4diW6usSlFaAgVbKqfaf56NNXTrwmwvxqV40uOwojcF/x9Ep
         7TIXdAkbmYIgc9pwfl7JAB7qYe6/RTzwzspDFmf0ZFixM8T2s2lJ8G6z0VEz7nXB5nMI
         AuV6UM3Hg8hp0WEnbeUg0GjNVD7eoksTPplBCj6BNoFQdsEmGtJbIUMqlU2nm0+qZyI9
         DlVQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2kqTGDrtsdt1dscXQHF14odjnDjXWQRpXvO5SPXKxTQUzruyG2H8hetwgyfx5NGBks/E+aoQFCSzZKe8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/TavKM+ewTIYoUnaRBWHFb/iBcUZFid5Oe8Z2JFDELsITd83eH
	HGSRKtZgAd6JfcZu2Rc05/VFJSRyCp8rkH2RB8MOTqne2VHLFORwRtauTZaMBYPZ4FU=
X-Gm-Gg: AYBFou37ebcbapLQsqOaNSwiJptjKVFXRqFSfrNp6GuhfPA91ZOkEImjp8iWbz5GLh+
	sxqeffM3gpvjFdxQWpPE75+cwH43BqpzhukWqKVKcKeRy58OTup6d+dQ+lImzDWZzpX9g3AvuB+
	32sG1XbjGJfbBYKKaC4VhNF0nZOke4N9dS9eXT7tvfbtcBgRk9YxvjP1TgBH9LpNzAkPp7cU910
	Oim70iwizXljvAIG8aC1PTMPnbwG5NzvHt3TcSJQdByla2iBRl0vxufnNUwd6Qd1d2Q5Xw+FjhE
	MHgfIpGYAt2XXmIe2Ygi4Gqc6DyNwzffqyjNg9zmU0eHd5RNCQOPgzV4GSAMRLWJHzV+sz+/9gE
	Sp+hk/xt01T5Hvphr36cDcBGU94SiFapDVKHxXbZ0KmMtI5a+HC4RAR7VdskWmloS+kVFYQnAR9
	lXpf0UV5W/vLaktZQd73+G2IyTt5Hk3J/M71qp/6DjZHG/gnP9AdNpB/1gchj3jGM5pbJHBYH2p
	cax+As89JLYldnnnN897IPRNg9YFtBXLQi54FrS2kXn/lajY0kpBf3NBExxhANWnmq1VnORnT0h
	4kdcrUlyPMAGz7MjsQFEQzJOat+ueP9+QwiSKhfs8hs5qu19RPEhn62qCBL8yXF5ZRYqwGAeRtN
	hngGSIPMgXHo1Oy6Z59cE8zlqg+KKOyNnjT1S
X-Received: by 2002:a17:90b:5870:b0:3ad:6090:a189 with SMTP id 98e67ed59e1d1-3ae8983e2f3mr11360606a91.45.1793765020090;
        Tue, 03 Nov 2026 20:03:40 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm1817053a91.1.2026.11.03.20.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:03:39 -0800 (PST)
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
Subject: [PATCH v8 4/6] IB/isert: drop the promotion reference when a connection errors out
Date: Wed,  4 Nov 2026 13:03:15 +0900
Message-ID: <20261104040318.1844865-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
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

isert_connected_handler() takes a reference when it moves a connection to
ISER_CONN_UP, and the paths that give a promoted connection up drop it
again.  isert_connect_error() does not: it drops one reference for any
state.  A promoted connection that then gets an error event keeps one
reference for ever, so isert_connect_release() never runs and the
isert_device reference it holds is never returned.  isert_remove_one()
waits for that in wait_for_completion(&removal_comp).

A REJ after the RTU reaches this path.  cm_rej_handler() accepts
IB_CM_ESTABLISHED while lap_state is IB_CM_LAP_UNINIT, and a passive id
stays in RDMA_CM_CONNECT after ESTABLISHED, so cma_ib_handler() passes the
event on as RDMA_CM_EVENT_REJECTED.

Drop the promotion reference too when the connection being given up was
promoted.  A test-only knob delivered that event to eight promoted
connections.  On patches 1 to 3 of this series the device delete did not
return within 240 seconds in any of three runs, each printed ten hung task
warnings, and isert_device_put() ran once, twice and twice, the first of
those being the one isert_remove_one() does itself.  Three runs with this
patch ran it nine times and the delete returned in 15 seconds.

  INFO: task rdma:206 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-NR3-00004-g11e5479fd20e #123
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:rdma            state:D stack:26592 pid:206   tgid:206   ppid:1      task_flags:0x400100 flags:0x00080800
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? filter_irq_stacks+0x71/0x90
   ? __pfx___schedule+0x10/0x10
   ? kasan_save_track+0x14/0x30
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
   isert_remove_one+0x529/0x710
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
  RIP: 0033:0x7fe0ecec20d7
  RSP: 002b:00007fffe9d34978 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00005621db1ab390 RCX: 00007fe0ecec20d7
  RDX: 0000000000000018 RSI: 00005621db1aa2a0 RDI: 0000000000000004
  RBP: 00007fffe9d349b0 R08: 00007fe0ecfb9200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007fffe9d34ba0
  R13: 00007fffe9d34984 R14: 00007fffe9d34bc0 R15: 00007fffe9d34ba0
   </TASK>

Fixes: 954f23722b57 ("iscsi,iser-target: Initiate termination only once")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 187759ae644733..980bcc0fb23183 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -721,7 +721,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
-	bool owned = false, bound = false;
+	bool owned = false, bound = false, promoted = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
@@ -730,6 +730,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 			isert_conn->state == ISER_CONN_FULL_FEATURE;
 	} else {
 		owned = true;
+		promoted = isert_conn->promoted;
 		list_del_init(&isert_conn->node);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -747,6 +748,8 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_conn->cm_id = NULL;
+	if (promoted)
+		isert_put_conn(isert_conn);
 	isert_put_conn(isert_conn);
 
 	return -1;
-- 
2.43.0

