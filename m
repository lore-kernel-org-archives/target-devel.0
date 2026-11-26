Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657016;
	b=03fylmZgGn7ks33Mu6cKkQBvIWkYhN4b65M+hizYLQ5B7ETp6zL/ZMT/XU9/p+gv6ZsI
	 x7mJ2dbLifzXg69F4WU9pR0upMzbGh1kMfh0M8+GSqP7IwU9RbuuaREoRu0bE4s/8FLhy
	 ffwvPVV0iRsPimRR/PqSHSypYxtUe3jqoAw5E3JnNBthjd9ubcm8VkeR6vtEpkBMtA7Pv
	 f5RIDtexTVFSMPq8O5ucyWdt/SmdYBKpnb7mZebKiPBa0MrWsfQbesObt1Zl6/HQrv6jM
	 4T4l1yBZv3fziLbap0ZO32s5LBmuTEgJFW6e/wQg+MaWLEp6l40T/nGnMMujIH03JcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657016;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
	b=gWSnbSc1s53NP+gYLIqefmxOiyzGrXXDON4+FSLMEZDrJ4d2IloUysUdZE4u5AXCTyob
	 D2tf7FjDoP7XdOtJC3TLJoTqhB2eHkWxlgECS3v6Bjd2sQxN26evK4Z4oaSKMHVbgRXyp
	 FljAHn8rmIi3fklfbTE+4gD/X/xeL8HocuoO7E+659ODD8ETijvgTD8/JsOuhNWV98G35
	 J4A2raYV+mosfJt0a+S5rxWF60+DqGBv2OuEsG1cWv5eOwEz2lXCQqjNhfc8A2Se6kQf/
	 CYFCX5XHOs31YQAT1FSHbRIybU7imugxaFrn/Savny6mFWuTPbC0/F4eQezCDIV4MhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCJMTtV3;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9D4606A31E
	for <target-devel@vger.kernel.org>; Thu, 26 Nov 2026 01:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A9D4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCJMTtV3
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc758830601so4835275a12.2
        for <target-devel@vger.kernel.org>; Wed, 25 Nov 2026 17:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795657015; x=1796261815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
        b=jCJMTtV3Fg1ztxOOwJsoJtoeXuyMNNjxrZGGUgThjQOmuw7sXBhI4zCwRzbCdLu9tm
         5FpSTBHePOQQnduznAkRlDthCnoVEs+9UDcmQBlXGEFBvtNsQUz55JqvlrugZiwRNY7L
         2pHtRkuEER41k6K4C1AOwCqxnN0WvfKjob4aQ5iIk8c3b/fXi18+2wNCCutKhoKR3SQf
         HFCIlnHFVAJqyrB9FxPbtkO6tFsDS+fHovHHCkd5xn5dlHCgZsAzE+oZFB4qHglTuARd
         0IqUkMUVrbR6bebqCS/ydMkN89fOjEvQBefQ/hCy91UrwaPapvFUEoVFZIFYxhOFoZg1
         UKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795657015; x=1796261815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ONTDc/ySzGKj+/9hGNst87EjvfnG8jWay9zEngGSmA=;
        b=FJVaAQ0M0gaDMJF3O4zdZ36BQ/ytXvSpF4Izr8j4CeFRh8mT889zQ1pglZ8Fa+c5Nl
         upDt7O//KXraItQpL/vWmzPmaYIQbTyMWiMfJ6H5dDTIV8B2tVvWQIaS9bYxysfzsG7/
         DXEYPccEcOOAqcsoESysLLXpsutZYFbs6wUyJDDDusb3M1SOE9B64z7eC/ycVwwrPOCb
         ivrw2Zezxwa08t48uof7mIaFjZK59QQp5HsZwqwsU0l/PGUy1vzjVvDvI7hO5jjB2fvM
         NKqvgEUWHmk6CoXu7xHGebre5wRm6l3R9M6QEII8vyrhH9ETFOLnSRfY4ygXX4YKtU+6
         WWWw==
X-Forwarded-Encrypted: i=1; AL+hErEszcUicJPEpw9lKTC36dVV/+0TGgI5+5vNFFKCFWBpNoQc8ReFttWGjSkA79oJJH820H2HvcyacNS5jwk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9lXAw2W23QiSnRbOjBE8fL5wfdenLRp1SigX1OYanbMpLn2Wj5
	zSy1u6HtYPfwAHuoeVRO66SopihOm2cmtCUeOY+/eRs6JKJz0lqi4wrJ3rsIrBi2KEaKrw==
X-Gm-Gg: AZFdTZfZ/ZHtHObcjzmocdgFVhxsQ5znrDMiPtXKNhndkuOY+m+i9Pj2ekUPtuTPVJM
	Yj+eL1i3RCi6GiTv7rj9WZi5ouxkF/fI547cARoVRDm0fFC2l0Nx+RMSjO4TmQU42HdTCV3sGWN
	XKmJkwhpLkDCJfCwXYeZMTswwvP45k+bKeQxHoNQJZVkFHdqujYVmR9gBJoiTdfalrI2sUWvtoD
	X3r4XJQDVn4yixsKLqokJYFznP1HlP4XgrtsthKjyeueb7MRZXHrRE37A19j0JbM83sg7geWDy6
	yd12XzplOhWJPTOSWNmf66JHUsmOwCIcu4BgSbZAYPIBO6YDASUyECbnVc0hDPjEIT21C6n/+I6
	iTq0f6XSQAdcKIj2byYuWfZEWbbKxXvCIGBdphLFhYBv9JmKnKH7Sr0Qh00Qw+jqSBCKLmGTpcv
	HIArwM/AkJCWMyX4gb9z8yJac/iMbi2N8Q/dh4Ck73Y2dv2DRIiApj8zTkN2Pmc59s6y4e3A434
	3X733knVutLw23ok583Q9g9rvoSzfJBmPq43ZQ1EnwxpB9kM0BNYFXNgEny88vZ0RZ9UJ1kek7q
	dSGKlpOpQQFUov+5lyGHKaLaNk2G+mhTYZq5LoYgPkAArIv4M+5MK/ALJxD/yAFpXLLqwn0xn+7
	3XbmeFnYRLZ+Lvi1S2AdYoApwN13v069vM3RA9jgxQ9kdlvI=
X-Received: by 2002:a17:90b:1dcd:b0:3b0:968f:fdef with SMTP id 98e67ed59e1d1-3b41c9758d8mr19690426a91.49.1795657015247;
        Wed, 25 Nov 2026 17:36:55 -0800 (PST)
Received: from lwq-server.tail118c18.ts.net ([74.176.208.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b21e19fsm11338967a91.0.2026.11.25.17.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 17:36:54 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: core: use list_for_each_entry() in __core_scsi3_alloc_registration()
Date: Thu, 26 Nov 2026 09:36:50 +0800
Message-Id: <20261126013650.2169132-1-shunsheng1218@gmail.com>
X-Mailer: git-send-email 2.34.1
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

In __core_scsi3_alloc_registration(), the ALL_TG_PT=1 loop iterates over
dev->dev_sep_list with list_for_each_entry_safe() while dropping
dev->se_port_lock across each iteration.

list_for_each_entry_safe() caches the next entry pointer before the loop
body runs. While dev->se_port_lock is dropped, another CPU can remove
that cached next LUN via core_tpg_remove_lun(), calling
list_del(&lun->lun_dev_link) and poisoning or freeing it. On the next
iteration, the loop dereferences the stale cached pointer, causing a
wild-memory-access / general protection fault (or use-after-free).

Meanwhile, the current entry lun_tmp cannot be unlinked or freed while
dev->se_port_lock is dropped: the loop holds a live percpu_ref reference
on lun_tmp->lun_ref, and core_tpg_remove_lun() (the only site that
unlinks lun_dev_link) waits for transport_clear_lun_ref(lun) before
acquiring dev->se_port_lock and calling list_del(&lun->lun_dev_link).
After re-acquiring dev->se_port_lock and calling percpu_ref_put(),
core_tpg_remove_lun() still cannot unlink lun_tmp until dev->se_port_lock
is released.

Switch the loop to list_for_each_entry() so each step reads the current
lun_tmp->lun_dev_link.next under dev->se_port_lock. This prevents
dereferencing removed entries without skipping remaining live LUNs.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
---
Testing:
  Reproduced KASAN wild-memory-access [0xdead000000000100-0xdead000000000107]
  and general protection fault in __core_scsi3_alloc_registration() on
  unmodified 666539eecdf4 under QEMU/KVM x86_64 (CONFIG_KASAN=y,
  CONFIG_PROVE_LOCKING=y, CONFIG_PROVE_RCU=y, CONFIG_DEBUG_ATOMIC_SLEEP=y)
  using tcm_loop + configfs (4 loopback HBAs, SG_IO PROUT REGISTER
  ALL_TG_PT=1 racing with concurrent configfs port symlink unlink of the
  middle LUN HBA3 while a timing-only kprobe parks the walker at
  target_depend_item() on HBA2).

  With this patch applied:
  - inject (middle LUN HBA3 removed mid-walk): PROUT REGISTER returns
    SAM_STAT_GOOD (status=0); PR IN READ KEYS and PR IN READ FULL STATUS on
    all 3 surviving target ports (HBA1, HBA2, HBA4) confirm 3 registrations
    with key 0x1234567890abcdef and ALL_TG_PT=1; direct PROUT RESERVE,
    PR IN READ RESERVATION, and PROUT REGISTER key update on HBA4 (the
    surviving LUN after removed middle LUN HBA3) all return status=0.
  - ctl (same kprobe, no unlink): 4 keys / 4 full-status descriptors.
  - 0 KASAN, 0 GPF, 0 lockdep, 0 WARNINGs.
  - Compiled drivers/target/target_core_pr.o with W=1 (0 warnings).
AI assistance:
  AI tools assisted with initial defect triage, patch/commit-message
  drafting, and QEMU test-harness preparation; the author reviewed the
  locking and percpu_ref invariants, verified the historical Fixes commit
  and QEMU KASAN/lockdep results, and takes full responsibility for the
  patch.

 drivers/target/target_core_pr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index ca1a2802aa228..660772d4674aa 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -703,7 +703,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	struct se_dev_entry *deve_tmp;
 	struct se_node_acl *nacl_tmp;
 	struct se_lun_acl *lacl_tmp;
-	struct se_lun *lun_tmp, *next, *dest_lun;
+	struct se_lun *lun_tmp, *dest_lun;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg, *pr_reg_atp, *pr_reg_tmp, *pr_reg_tmp_safe;
 	int ret;
@@ -726,7 +726,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * for ALL_TG_PT=1
 	 */
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(lun_tmp, next, &dev->dev_sep_list, lun_dev_link) {
+	list_for_each_entry(lun_tmp, &dev->dev_sep_list, lun_dev_link) {
 		if (!percpu_ref_tryget_live(&lun_tmp->lun_ref))
 			continue;
 		spin_unlock(&dev->se_port_lock);
-- 
2.34.1

