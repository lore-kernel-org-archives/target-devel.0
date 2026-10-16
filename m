Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B39379EF0
	for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 06:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792131142; cv=none; b=FuQLVSSwPQc1vmp6aazKPCryY3X6OX2Q29ZiFsFJyFYaT1dT/C1DLChs8MdJhaFLyV5sZxjCH4ZWHu349BpscBjeQn9z6PdvYZipEQVPFSJCbCbxHo/rGLsSPiz+fu+aKYiXWZXZlP5shh8k7gUDro/rGJ9Aru+5BisYYC1S5Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792131142; c=relaxed/simple;
	bh=GiK1rjWkVKYkYUyerIeHUjnzQfFpbLLdF4axllSUko8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nElf5YED84K/X/YntO5EWBc4T/1HT2lOsw4DyFW3a3R7ujxAjCvT/4vMLiAqH36Qrd56njxn9WBbkx4HdLS6YmDIs4Cn7wOvsdllroCNTbUbSqIqU8YDaVWxEzqIQZQLuWC1W4/jboe2reqMWRLjVYoqJVZDwrWSYuU/S157IF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cT9KOWN2; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cT9KOWN2"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so2433518a12.1
        for <target-devel@vger.kernel.org>; Thu, 15 Oct 2026 23:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131140; x=1792735940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cECDn9wixA330bGvTffyTHattrcKzY/ix80ysxVbhlI=;
        b=cT9KOWN2ERwzS2XFzWsSwVytrHoIP911OrNYFbosERYwo6FDgwjUiNTI57jAI3WSNz
         3LKijCyMgpUQbfNdQCKgzq/Ox7FLy0scCdzLXEbOArVwnR6XGM/u7ZLrf3v3S1JyhSiD
         lwOV0Id1fiShnsro1j+WJqGEYo+gSYc4wLAGY2KLfHs5IquYACXuE35wYYoYvUmOeCz9
         gBSWOl4LT4776qH6BGhkhT9er5Cc/B8IZKAvwYOL6gnAVkOp9AHQXoWtrxJQFf9NnnsI
         06RcscAltZ1PUwgO7m2mzFKTxSkmMCXavjFDdq34zpOfZOB8R7v9as1Ma1BCEuUunbgh
         eCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131140; x=1792735940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cECDn9wixA330bGvTffyTHattrcKzY/ix80ysxVbhlI=;
        b=iGgRFma4PPn5UORvoOC4zV6BlALYNxAS0nsQv6TTJtDh2Eo3Zoudm2dsMfSmRb4Bv0
         DNDJsO/BjKuqN9axvnq42GGCVu8gRd2b0A4OFA/45Lx/p0lAmhNDbGIRuOi3VqyurWPj
         sxdTocZ8Xuxvilx+6X5iYiy/SQQ9N3iE3rTjhqGnI5bzkl6xnXl6z2ZxluZ7im2FnYIS
         vbLiICQ02X5nXeEa9oEZU44qyJJ3iinjzMfPvOFzoKu+1bk15uWoYYHHyLdVfpmmK6n4
         +tp3GbT1o4SmJCTy7nPAJFUICZQqxD7DXUgn/T1vWnnnEA9IDYNwtmD8kkZCd1UUxWFT
         +LQg==
X-Forwarded-Encrypted: i=1; AKwUvBzJ4xAq0mproLce5YP5GEedopnSaU8Tg0QHR1l57ItjCwODlFDhJPVrnhRm6c6E++xgWuQXL2w/8KN0AF0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJZQx8JVrKP6FqY5uUxuyuwt76Q4VUSgA2w9jzZ5hVChNyr/VHN
	5/Yc4hIgwJqHlKO2UXoO9Nk6gCjX9odPRwQieov/+VQpv0zA8MHIHL6s
X-Gm-Gg: AYBFou0FbQKesolYuZtLYb4fO2vzhKRkTwxt3ckb/F3juLlG1KaNOLEgawR9Xy6UM9w
	RRpEHIQlhqT1pXqkVTZR9Wp+eC8akqFNu1IPTxbrqYZhZoAq+PrLB+V7GflTJx/Hj1/LrDDR0zX
	Yll9y9NCS9m/2HuThE1SAsZ2hyk1JWylGHUFOP7gE4LawXZM3CTXk3JEbIlj89+yhQWzMqfTsko
	QTINsrfIVSaIRXfzNT2LBCO+xP5Tlnr7cRemwkpiVn24x9v526/uEAegEWtk5FJPy39gN3+18+y
	xAHhuRtX7xr/oIeYjvf5zhMbMt8A4MAthcbL3y2fspYzpbrYZ3bg1R7xPZISmsM3maVS9VJTQSu
	+y9ZsAyzughPDSYp7+KbzDnafZafrzROlntbmKiQs9IbrpOjRTtpSDsQ03PcwE4ZyZrkuwNge+l
	fQttimtjTllplsq971+pXoG0jGvjJeWZpokcCnI6MMZf8m0DTtfWCq4hEzd4AFIab4vhaNeMoTY
	o6luIf8YajBp9S/SQWqT1DmzANwGr4Ig0TisUUo2/O7rcAcN4IxJJnssUQuFC9PsS3ssXoxyRdJ
	6m7EsUJuF3Z842olTyzCSGoZxLdxMC4iXZYBt2MKTecgrx/s
X-Received: by 2002:a17:90b:4acb:b0:3ac:aa8d:19d6 with SMTP id 98e67ed59e1d1-3acaa8d2219mr2736921a91.17.1792131140016;
        Thu, 15 Oct 2026 23:12:20 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947dfa00sm7587036a91.17.2026.10.15.23.12.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 23:12:18 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: use-after-free in PR REGISTER AND MOVE racing PR OUT CLEAR
Date: Fri, 16 Oct 2026 16:11:50 +1000
Message-ID: <20261016061150.90624-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

core_scsi3_emulate_pro_register_and_move() (drivers/target/target_core_pr.c)
drops dev_reservation_lock to allocate the destination registration, then
re-takes the lock and re-locates it:

	spin_unlock(&dev->dev_reservation_lock);
	if (core_scsi3_alloc_registration(... , 2, 1)) {
		ret = TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
		goto out;
	}
	spin_lock(&dev->dev_reservation_lock);
	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl, iport_ptr);
	new_reg = 1;			/* result used unchecked */
	...
	__core_scsi3_complete_pro_release(dev, pr_res_nacl,
					  dev->dev_pr_res_holder, 0, 0);
	dev->dev_pr_res_holder = dest_pr_reg;
	dest_pr_reg->pr_res_holder = 1;

While the lock is dropped, a PR OUT command from another I_T nexus - most
easily CLEAR, which frees all registrations - runs
__core_scsi3_free_registration() and clears dev->dev_pr_res_holder. The move
path then uses the freed / NULL registration.

On a stock tree this is a NULL dereference (dest_pr_reg / dev_pr_res_holder
are NULL):

  BUG: KASAN: null-ptr-deref in __core_scsi3_complete_pro_release+0x9d/0x3b0
  Read of size 1 at addr 0000000000000228
  Call Trace:
   __core_scsi3_complete_pro_release+0x9d/0x3b0
   ? __core_scsi3_locate_pr_reg+0x13f/0x170
   core_scsi3_emulate_pro_register_and_move+0xa95/...
   target_scsi3_emulate_pr_out+0x3a4/...
   __target_execute_cmd+0x56/0x140

A NULL check after the re-locate is not sufficient; a use-after-free of the
destination registration then shows up - allocated by one REGISTER AND MOVE,
freed by the concurrent CLEAR, still used by the move path (three tasks):

  BUG: KASAN: slab-use-after-free in target_scsi3_emulate_pr_out+0xaf5/...
  Read of size 8 at addr ffff8880058db670
  Allocated by task 23:
   __core_scsi3_alloc_registration+0x7c/...
   core_scsi3_emulate_pro_register_and_move+0xed7/...
   target_scsi3_emulate_pr_out+0x3a4/...
  Freed by task 33:
   __core_scsi3_free_registration+0x3d2/...
   target_scsi3_emulate_pr_out+0xac0/...        (PR OUT CLEAR)

Reproducer (KASAN build, panics in ~1 minute)
---------------------------------------------
- Two tcm_loop TPGs (SAS, distinct rtpi), a nexus each, both mapping one
  iblock backstore -> two /dev/sdX = two I_T nexuses to the same LU.
- Thread A on nexus 1: loop { PR OUT REGISTER; RESERVE;
  REGISTER AND MOVE to nexus 2 (unregistered destination) }.
- Thread B: loop { PR OUT CLEAR }.

C reproducer and full dmesg available on request.

Reported-by: Yu Zhang <yuz08559@gmail.com>
