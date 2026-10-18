Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A3948E0C7
	for <target-devel@vger.kernel.org>; Sun, 18 Oct 2026 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325647; cv=none; b=ODXQQgDfv9Ky1K58bdHgxy15d0HkZ4rsby5WYNbLBZ5NjgFo/Q+dJXE4ApSm6ILxJtd3n4mFn9dau4m+MTg1jJza5AWxQhIZV76sBYVPi3KGud181zbGDFU4spGeALB/mCnQ9tNsiIeTauS4lmPpXm+KpLd7DCmh6jbYXh2dgUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325647; c=relaxed/simple;
	bh=0ZUoTOrw2sVIIJsHysZ9LrpXCPGOLNSWoimGoqE2U2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jxIOIiyMZuu/3sP9p17pXJGfs6nBv49lt/qkxc5ZIzyyBGjOmvxOv+oytq95+zH6pLx2EtrCxk0X/GzMv9iQCTJKpu6tjeziFvTNwe436hjNQdWQHwUg9XVZ90ly+SUaQNy3pxq2RbpuDlKLrXSLNGSJt51M719Wwa2sIX4qKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpinP1vp; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpinP1vp"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso735086a91.3
        for <target-devel@vger.kernel.org>; Sun, 18 Oct 2026 05:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792325645; x=1792930445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rTNuU8y07OWc3gpsCtxs9hMoDORTFAVO+j50HlgZwnM=;
        b=hpinP1vpFyJpDdPHICXGzIQIRyImrKMVDhw1wgqsbp/SHHH8D77WA05IczWynz+ZQU
         cE4hrlX3BUbq7wjQ2t4DM6bRSyXh/0EXGO5qZlEud8ZvnbFJGqykMI+TPhQQv0kS7MfQ
         xFQoKTXBNyOirmkztWZlwE/YDM+shn63+be1LPBgy/2eS3R3X2gnx2amqEzRF2LNeQkE
         HZseIBZNuNsA747O7X3E7lW71cbVvbIh/lGQg3N38dnYaB8kNGwKHCz7Ajg0WrVWuWx2
         q2YRb2LbIMcOHjEUexc9g5nVeahpZZ7W33eKZE8hXJROfPktp6fSIBjvD7hMOqBXHKSr
         Cxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792325645; x=1792930445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rTNuU8y07OWc3gpsCtxs9hMoDORTFAVO+j50HlgZwnM=;
        b=HVmm6T60mGYuBBJwJgX9TZE9bIeDGtMYoQPa7n7a0u9+AhAMcoR7NTsjW4purM4KoR
         7gpViKie7AqCGJSQly2DW5O/Z/Man/zyKMgdHL5dbn6YjcoHdqbGWaQyzExwamWXc6qO
         cLf746yOss1Wa+DyoMgLl2NKN+BqvgYimqVTiin0mUyZLYYgYIpwdTFH3EInrP6Frt7T
         25d2WC2r5sseKYef0p7sM/+9kARl3Ma7bdNj4hKAnLGzAriCji7xgr2lSyM1/7A6PQ2i
         nfink2pkPk1wTkSzG5nI8/BPneVcxVxGz7KARUDPVWiuG4GWoUYvb1e04TWU6Eyj+s6Z
         2lsw==
X-Forwarded-Encrypted: i=1; AKwUvBxBIkFuGh5or3mJbYrS7RTYg1cfbg1ueZziSOeREGEOXOonMcB5JNiyVBa13DC2tBO5F+T73NUEyqAEQAE=@vger.kernel.org
X-Gm-Message-State: AFq9FYItDcmuKipnsRmik1QCK5LFb0zKSfVRwYWuoiRxNcQFJCNTL08k
	m6TU1mbFvaYh2Na/KioPXRH3aV/EAHULOq6ul1pdfGzyMT0ml3/NK/F6
X-Gm-Gg: AYBFou2ZRGwOw4/qxHkHPCfDqDOhVyyW8zjp9bu/jpalkkoPPj8EiLKE93AfOXvJJNt
	VWg5LbfCVeetEqRw80Qa15DiiEdP+FuQ2TF70SZM8re4+1fOwH485qCHLtmD872V5YfZJyE/ryj
	eqHYsH556ppp/Oj/r5PZ8zlFSyZlq5DuoqJw6RkSAiQXI/OhvzSGJOy/wOKs1YwCB9P/+whwIYE
	TBFMQaEFrd1v2SExPX+pevyJ3Ag+wIyo5ctdFLwu02ietlcYQTa86vhALhBj0Ii+zZTriKgG7r1
	P/48clTzI5G3+U8lovSN4ZEF2ryx+Wy47yOCmgruIAcQhh8SxBj+FcJkM1J/cdGXmBtJWJd6YNj
	5uwEndFzeklOv9qEXVomMOqDY/mzK8+TyUdTxpvqfI7qZkkkloCbaShA3GSv4jq36EJlFYLrkjd
	b5ewQ8r1GNbXUyQLhxLE5bwwjjCkkqiSh/UUHdrmGf1Y0sTmNDJwXTS8xU4N/W6YaCrZdnlyI7U
	9I7vIYFibVS/eR12u/FVcTprV+MCc0DPYiuVGQvkgbq8n2qx7RvIZ7utQsHo12aA6dv4c1oMaH4
	GGP5ODEZJfyLCvavPKZI+4YmpAbp11ENnZBktU+jspLmEkQL
X-Received: by 2002:a17:90b:2c90:b0:3ac:a521:953 with SMTP id 98e67ed59e1d1-3acef0ff0cdmr4044977a91.46.1792325645279;
        Sun, 18 Oct 2026 05:14:05 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48e8646sm11116604a91.10.2026.10.18.05.14.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 05:14:04 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: PR OUT CLEAR registration-list teardown races concurrent PR OUT -> UAF / double list_del
Date: Sun, 18 Oct 2026 22:13:57 +1000
Message-ID: <20261018121357.63980-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

core_scsi3_emulate_pro_clear() tears down the global registration_list holding
only pr_tmpl->registration_lock, and __core_scsi3_free_registration() drops that
lock across its pr_res_holders busy-wait:

	spin_lock(&pr_tmpl->registration_lock);
	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
			&pr_tmpl->registration_list, pr_reg_list) {
		...
		__core_scsi3_free_registration(dev, pr_reg, NULL, calling_it_nexus);
		...
	}
	spin_unlock(&pr_tmpl->registration_lock);

__core_scsi3_free_registration():

	if (!list_empty(&pr_reg->pr_reg_list))
		list_del(&pr_reg->pr_reg_list);
	...
	spin_unlock(&pr_tmpl->registration_lock);
	while (atomic_read(&pr_reg->pr_res_holders) != 0)
		cpu_relax();
	...
	spin_lock(&pr_tmpl->registration_lock);
	...
	kmem_cache_free(t10_pr_reg_cache, pr_reg);

Unlike PR OUT PREEMPT (core_scsi3_pro_preempt), which holds
dev->dev_reservation_lock across its entire registration_list free loop, CLEAR
drops dev_reservation_lock before the loop. The same registration_lock-only
teardown appears in core_scsi3_free_pr_reg_from_nacl() and the PR OUT REGISTER
unregister path. PR OUT has no device-level serialization, so two I_T nexuses
can run teardown loops concurrently.

list_for_each_entry_safe() caches the next entry. While one CLEAR is parked in
__core_scsi3_free_registration()'s registration_lock drop, a second concurrent
CLEAR acquires registration_lock and list_del()s + kmem_cache_free()s exactly
that cached next entry. The first CLEAR then advances onto the freed entry ->
use-after-free read of ->pr_reg_list.next, list_del() on a poisoned node, and a
double kmem_cache_free().

Reproduced on a KASAN kernel with two tcm_loop I_T nexuses mapped to one iblock
LUN, each looping { PR OUT REGISTER own-key ; PR OUT CLEAR own-key } via SG_IO:

	list_del corruption, ffff...->next is LIST_POISON1 (dead000000000100)
	kernel BUG at lib/list_debug.c:56!
	RIP: __list_del_entry_valid_or_report+0xc2/0x140
	Call Trace:
	 __core_scsi3_free_registration+0x12d/0x430
	 target_scsi3_emulate_pr_out+0xac0/0x13f0
	 __target_execute_cmd+0x56/0x140
	 target_execute_cmd+0x1a0/0x5b0
	 tcm_loop_write_pending+0x15/0x20
	 transport_generic_new_cmd+0x40b/0x700
	 __target_submit+0xae/0x1e0
	 target_queued_submit_work+0x64/0x190

Note for a fix: simply taking dev_reservation_lock across the CLEAR teardown
loop (mirroring PREEMPT) is not sufficient -- it deadlocks. A PR OUT command
takes a pr_res_holders reference on its own registration via
core_scsi3_locate_pr_reg() *before* acquiring dev_reservation_lock, so one CLEAR
busy-waiting in __core_scsi3_free_registration() for another nexus's
registration to reach pr_res_holders == 0 waits forever on a nexus whose own PR
OUT is blocked on dev_reservation_lock (observed as an RCU stall). A correct fix
likely needs the registration lifetime reworked (drop the locate reference
before teardown, or defer the free to the last put) rather than only widening
the lock.

Reported-by: Yu Zhang <yuz08559@gmail.com>
