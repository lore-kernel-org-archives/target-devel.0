Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712644;
	b=BqZHuDW7F43DYoHbcxGtvYA5UPK7p0dQnRkLyrl6wA9Mf7yVR0Vk4kyb1Jn6/64hH03k
	 7RaPn07Z+oB3Wf7pV+yOXJyDotG8/gDS1ZqKIuS6tFa5IWPguYNcDnv0C3WtQQhTOHiwr
	 aXw7G2GdQXbNXGOUpPvvaT1xEbTgTo9fVJPJ+MDugUCYuUI0OaYpI0aICjFtlTLR8y64N
	 Faowce70SSkbNF+eEXkVV5oKefx66YJ8Q5TEIhzTT/CK0ZlwDZMj5odssxZ//Ozyi3Dt2
	 J0egcjUk7uFiVK7+JeTZ9FOfvwoTRE9RvGC2h6TWq/60SdmTzf0J4yuZPTsH/45ygNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fnh9YUI73W9upwsx2dI+MC9ZPKD79q7rWiJ2BDXOpW4=;
	b=T0Cms1kgMnfuFPWy+KCyYCiFYXAK3nBrM/6YHW06DP0w6puy36sWgwH2RSHKFOPRbskN
	 xPIt/6o+1v5MgjmV7Se3b8HgBtEH9G29ObSJprdyizVyGmqNtKwG1PQHxxwgib8UjTS+c
	 k87wS2OqWRVbjzhDB+Ko3078TDf0O+Pgx46W2Of9hWrEObXk/hc6KGFO1Ag4WidQem3ad
	 pH1bQRhl8M97CCXg8QTTDxSM9rG0kpvjvpqGck+ZCrizgr/5DJ+LZxMIxOMBrgCk4YYw1
	 H32U6SbrSLdPz3WjA7gCU50tNiT2BwxtElFxOHikHKnOJq8cCVnksbZOFqqWxEWqCaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF8606A31D
	for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 23:43:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAFF8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so207415a12.2
        for <target-devel@vger.kernel.org>; Thu, 22 Oct 2026 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792712636; x=1793317436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fnh9YUI73W9upwsx2dI+MC9ZPKD79q7rWiJ2BDXOpW4=;
        b=cTfKnNjMEmAgpuZnqXhLUjkKjK3844IAJCQv2wWy/JwTOnrXtVZQbSowCKiGyEkIHA
         Qa8JfTFhW6YvaJq9DjbTQ8XbwvIphm2K5iSoC2+CEu595RM6bt7yIyPbKNqYapeGh6qy
         RUQ0up8/jeY0I/4dimnPNaohzdkhN2m8OtF3KkjvNypzw2YFDFNUXn2BT0yx3Y1Duw5n
         V6HT5xmmSP0cQ2edvHHEm9M+1f4bCnHxeCrORxB3BuTnPh0uD5kUC6PUvJJ2oyOGubzx
         aLoFhLeOVhgU90/LrlTc7KK76TX+JLYuw+72xKSQC4GeMg74qOZ2XNIx7LSoC4QMGcQi
         GuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792712636; x=1793317436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fnh9YUI73W9upwsx2dI+MC9ZPKD79q7rWiJ2BDXOpW4=;
        b=mR3p39SN3iZWzutfoQceTSE8bnwTJMt9ofeMAW8V/zK0Ke/DmpEsbb3gvFSUdgdgtS
         e6h3eUmzvliRy5zSK+QNiF1gFGwYdBSkx18LFBI/DtNZ2e02CuBcna8+RMLc7cvHMvo3
         JMbR7U+FkqFarbVqE3X6BhAB6yULnLdUGA0HUP9EcghktmzfMW6PKossgHKmLKfe2tbo
         DFDvwTWEdn7FFEUSxoQR0lyGFW7xjS5ueteQ5ELMn/qRrmosdBBgVhAf4m38HRtlF2PJ
         pFmbDT0SPXp0npQzhq62VCHROCfSJhpjAintSDsrcWlzjlCys9D9AwNZv4M3AAvmPO8+
         O05A==
X-Forwarded-Encrypted: i=1; AKwUvByL795WPByhtMtFT2FPHtzIeWQC9pB6ZWvmCPpcm+YFri1NaW6yWKyvENZQ383AObI62F4eLZGNT5rOU6g=@vger.kernel.org
X-Gm-Message-State: AFq9FYKuwceNiNWsa2kBoWizSHcUBIE8dI+mLDudDBr+zazrUiS/LgmU
	0M7KTzzDOWzsKiJZcCTcExOCdJB51zcOKoC2ZRLXJZz+aXjQIacBcostQjv9VBMyBug=
X-Gm-Gg: AYBFou1hb4iC3ginQIPVsK3ElRiwT5JHzSXBXZuBvaVX2SS0kk+CyVI/imuIJ6N/1bF
	AXT8TnZ+4yaqLw/qGyNbwPOvF8NDcQHzVisPR4f7Uy8SDNz+tVIND6mMU4krtTh9Wos8zvXaad0
	a0xomh9vPvOnrzvoJSObrW8ZFnoKOZ9u8FnFpq/9+FEhlpwP5aHUw1SOixJ3sUYS7Yq2ooC2iQN
	tzJIVXTglSwQSVrM/ys/ze0QEsAMFmVDjWtnV3pjlNiASD8yAC4vnSg3N+pmeleaebhAzy5cCUN
	rdCsKaxzvjjBHe5M/UXqMN/HJMYbwUx7GPugxONPkP+Ut6TokQan/PHI7F2l8ZXM5P7W3r+uBkE
	MiuuLvNisY7XPgWkPmJeH4neNQYvQp41u2N+icsXlBdsWVU48fdT54/fn/M481uuNlporv3fJe2
	IaUlREHao2jvbLpuxqqZy6ZzU466bGy1lF2eqLVKMqVzCLodWtfZid9WCmbj8xvnWAe4pbFC2CW
	okmD5M5SLl3FvNaU4k5OlnxIpAW6f19jGfNS85XD4f2iHtr+NEMgmL7oJbUQjN2VaCmlucOHpFY
	2Szl
X-Received: by 2002:a05:6a20:7349:b0:3de:8ee8:8323 with SMTP id adf61e73a8af0-3e37668deebmr388484637.29.1792712635638;
        Thu, 22 Oct 2026 16:43:55 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a2c8dd328dsm137866b3a.29.2026.10.22.16.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 16:43:54 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3] scsi: elx: efct: fix target session lifetime against node teardown
Date: Fri, 23 Oct 2026 08:43:39 +0900
Message-ID: <20261022234339.3046449-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021142818.2782104-1-yhlee@isslab.korea.ac.kr>
References: <20261021142818.2782104-1-yhlee@isslab.korea.ac.kr>
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

Please drop this patch. The node use after free it describes is real, but I
no longer think a correct fix fits in efct_lio.c alone, and I would rather
withdraw it than have a partial fix carry a Fixes tag. What follows is what
I found, in case it is useful. Line numbers are against f47d223627f8.

efct_scsi_new_initiator() hands a bare struct efc_node to
efct_lio_setup_session() through lio_wq and returns EFC_SCSI_CALL_ASYNC, so
the node state machine keeps running while the work is queued. A peer LOGO,
an FC link down, a fabric change or target teardown during that window frees
the node under the work, which then reads it:

  BUG: KASAN: slab-use-after-free in efct_lio_setup_session+0x934/0xa30
  Read of size 8 at addr ffff888002d538a0 by task kworker/u4:0/12

  CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Tainted: G                 N  7.3.0-00342-g66b1ae16db8c-dirty #7 PREEMPT(lazy)
  Tainted: [N]=TEST
  Workqueue: efct-kunit-wq efct_lio_setup_session
  Call Trace:
   <TASK>
   print_report+0xcd/0x620
   ? efct_lio_setup_session+0x934/0xa30
   ? __virt_addr_valid+0x208/0x3f0
   ? efct_lio_setup_session+0x934/0xa30
   kasan_report+0xfb/0x130
   ? efct_lio_setup_session+0x934/0xa30
   efct_lio_setup_session+0x934/0xa30
   ? __pfx_efct_lio_setup_session+0x10/0x10
   ? lock_acquire+0x100/0x2d0
   ? process_one_work+0x835/0x1c40
   ? process_one_work+0x735/0x1c40
   ? lock_release+0xc3/0x250
   process_one_work+0x88b/0x1c40
   ? __pfx_process_one_work+0x10/0x10
   ? lock_acquire+0x100/0x2d0
   ? worker_thread+0x2c7/0x11b0
   ? lock_is_held_type+0x84/0xf0
   ? __pfx_efct_lio_setup_session+0x10/0x10
   worker_thread+0x649/0x11b0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x3aa/0x550
   ? _raw_spin_unlock_irq+0x23/0x40
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x493/0x940
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xdc0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

  Allocated by task 33:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x8f/0xa0
   __kmalloc_noprof+0x23b/0x580
   mempool_alloc_noprof+0x143/0x230
   efct_kt_node_alloc.isra.0+0x38/0x4b0
   efct_kt_uaf_after_cb+0x7a/0x370
   kunit_try_run_case+0x1ca/0x4c0
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x3aa/0x550
   ret_from_fork+0x493/0x940
   ret_from_fork_asm+0x19/0x30

  Freed by task 12:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x43/0x70
   kfree+0x119/0x490
   mempool_free+0xbc/0x100
   efc_node_free+0x311/0x4a0
   efct_lio_setup_session+0x6f1/0xa30
   process_one_work+0x88b/0x1c40
   worker_thread+0x649/0x11b0
   kthread+0x3aa/0x550
   ret_from_fork+0x493/0x940
   ret_from_fork_asm+0x19/0x30

  The buggy address belongs to the object at ffff888002d53800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 160 bytes inside of
   freed 1024-byte region [ffff888002d53800, ffff888002d53c00)

Taking a reference on the node for the life of the work stops the slab use
after free, but it does not stop the driver faulting on the same ordering.
efc_node_free() clears node->nport before it drops the reference, so
efct_get_vport_tpg() and efct_session_cb() still dereference a NULL nport
unless they check it under efc->lock. I measured that: with the reference
held and nothing else changed, the same case moves from a
slab-use-after-free to a NULL pointer dereference in efct_session_cb().

The reason I stopped is one step below that. libefc does not guarantee the
backend is told to delete a session before it frees the node that owns it.
efc_node_free() makes no backend upcall at all, and scsi_del_node is reached
only from __efc_d_initiate_shutdown(), efc_device.c:225, :241, :255 and
:264, and from __efc_d_device_gone(), efc_device.c:1451 to :1475. The first
of those picks a branch from node->init and node->targ, and when both are
false it falls through to efc_device.c:293 and goes to cleanup with no upcall
at all. A remote initiator can arrange that, because
efc_process_prli_payload() takes both flags straight from the PRLI service
parameters at efc_device.c:366, and __efc_d_device_ready() accepts a further
PRLI and re-runs that at efc_device.c:1355, after a session is registered.
__efc_node_paused() is a second such path, setting node->req_free on
EFC_EVT_SHUTDOWN at efc_node.c:916 with no upcall either. On both, a
registered se_session and its efct->lookup entry outlive the struct efc_node
they belong to, and efct_node_find(), efct_unsol.c:22, hands that entry out
and takes a reference on it at efct_unsol.c:34 for every inbound FCP or BLS
frame.

Three smaller things nearby, which I am not proposing to fix either. The
node->refound block in efc_node_free() calls
efc_node_find(node->nport, FC_FID_DIR_SERV) at efc_node.c:137, above the
"Node already Freed" guard at efc_node.c:140 that would have caught a NULL
nport. __efc_d_device_ready() discards the scsi_new_node() return value at
efc_device.c:1312, so an EFC_SCSI_CALL_ASYNC there is never completed. And
the target branch of __efc_d_initiate_shutdown() tests only
rc == EFC_SCSI_CALL_COMPLETE at efc_device.c:244, :258 and :267, while the
initiator branch at :228 also accepts a negative return, so a negative
return in the target branch leaves the node in __efc_d_wait_del_node,
efc_device.c:82, with nothing left to wake it.

What I think it wants is both halves together, a reference held on the node
for the life of the setup work, and an invariant in libefc that a node for
which scsi_new_node() succeeded gets exactly one scsi_del_node() before
efc_node_free(), independent of init and targ. The second half changes the
node state machine contract, including how the two delete completion events
pair up and what a re-attach does, so that is your call and not something I
should decide from the backend. I have a KUnit harness that reproduces the
use after free, the session leak and the stale lookup entry, and I am happy
to write patches or test whatever shape you prefer.
