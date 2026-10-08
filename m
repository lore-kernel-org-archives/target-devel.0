Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722263002DD
	for <target-devel@vger.kernel.org>; Thu,  8 Oct 2026 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499039; cv=none; b=D9Ht/GNGJz/2WilxAvqRk3n5jOjDvUkNcnRorHB1SCzN+Uuma3o/elO8rvV3mntXf1WHPbdkLHxETZcgI3SXLk7qFnBKTZSp6cWOBNrsr/3y+t+XW8G8tD+Fm+DnlrMOlsfADsq+7st7VEk9pUiHJrcypt3Cj9WlDbPuOKUaWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499039; c=relaxed/simple;
	bh=56Ig+iq1BKCTYcSM9xnOgOFWggZbgL06r7h/vH08FI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=giLrvcjeKZIQfI2UXe2E52X7BY+mhCTodsK5Kx4XuEpzqO/akTZk5nb/206pRmrwmqTM7EFETTyiTUDMJ2uxrg/aWthTFAKBcVJEp6+SmX9PojbNEROP4V/11Bl6gb80yJ5CWrnsKtGeEqUWo6sICh4vYaxLHZqjrnreWITzFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5Vz8d+6; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5Vz8d+6"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5c82b4d250eso57337e0c.0
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 15:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791499037; x=1792103837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PZACjmCS1oASftukGbD2aJ9Y7h6BQoT9c3bmi5RvtCg=;
        b=l5Vz8d+6dOSkOlTVyGxGLaf1zfyQJWFowWGtpWIIzOg99KOGFDYoA0ZEy9/bcpynt3
         S7ZD9UnPSFZwo6Ayo28MV45+xfCRV8n2iYcdIfK0498VkpACQJfbKLqlLQX3dQOx/0Im
         xWJe4ug/PR0wx8a4d1N3C5OsVSwu46QychpJkcIcvxqYB0iBVjf1g+QbKpE6j4fN1J8R
         qPX1joZM9Y18incYa5OUXZ9F2hfHgLF25PScTN93O6Ih9NWVNhu/1GOP6qv3jjkxZZmo
         elDDoTDrY5hn6Pc8FhJlnHKFRdPs8BDtCatey9b55TL671gAQ6DWIXasfl8OqObxbFMb
         20Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791499037; x=1792103837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PZACjmCS1oASftukGbD2aJ9Y7h6BQoT9c3bmi5RvtCg=;
        b=cQYYylTRk0xkKgoXB6t/eacu1+F1f6tQ5y34ffdVnaWXTzlkUN/QGK6aqyFaWg3ymL
         suI/3QW7AvhuCjhVFi9lCJJiMLKfH7o4hdAtkghIxIUSQuuVPyaCpqqRY48MF9PfhI+e
         28/n/H1rZD143Xu1ao3u+ipUMedcdS843IQ8aGFl61zAqxOI8Ir+kJWbT3OT5vx0MxXL
         LrY3krWNxi93a3GWPaH361iJttVAqmZkoDp/Olf+sEiXypp1pwe+0RaQYYJFrt8yKQ2D
         fuhKUc2jyIP0JxTg5EhM4hIGs8z5zkaeYlz5vsQyQaW5yCDmJXvVVD0JS/ZfhcS1x+7o
         3FUA==
X-Forwarded-Encrypted: i=1; AKwUvBzk0c64cL2se2Dgjaipo7jssYS2sex73tQMTdDOKug5KIDZ5Ykd8hg+8MlmHpr9LVXfeTWJS81WuPxOPNc=@vger.kernel.org
X-Gm-Message-State: AFq9FYI8uc6NggA9zX78Vlb5/fYoc0+KkzVjz1EbXDEsQFo7kjlSF8ff
	XPABy3LtkI0+Ufe9oSN/OqvPmMqoPvsJ56qCOgStoA6L4EXC+qce2Rzx
X-Gm-Gg: AYBFou3O+3rVm7KxcPhrLaZRzOtLkmdFOThOl/Fb7aXxKqZ8hOqxNq6WqnQsXFwPRbh
	McMjz3LHJLWahU0RU88uCihKH9wX20KSmvXokjgKZp6NEZLReZGpvhJrslpUgWQpIdZUuBoO6ef
	o35CNta8siGKt5bRZc6F4REKog8AS0+5ejsZ+DT1gkzdnuRSTp/Ndex5l++N3wTtUlYztZuiK5t
	2i5D5RoXffogiFVOHyuCld71DnDJO4rYB6FtAmNE6fQXIULQW/29WgA8wi0C5jMIyVBpz6kltKe
	OU5Sdnf6M/gJP3p7uB16IsZIsehQ317Jbl/h3c+ZIJFrRKLhm5bfg3rtMb07wxNHIQpCo3H86Qm
	Wm37V7Q+k0vDOp1JN8kNhpGjLJldig9JQP1zdppFyT6uTperh+V5ux8nZBzTEq4t8GmFVzShvTz
	XNw4Dnxq2Bzg5KfBIISwWYQcigWmxh4HROBvdAe/B0SFLTkRtr/b3AU8lO9PZnpslZCiXCDbRF0
	/PJ++cCHQ7AapVgC7wCTaOPkZBGyqEX+ay0WzIOeMFeeUqhwJMwdSyW5BYT5TK7L0kgcQFXX5Md
	IjPayoBpwgPCj28tGIe0taQQb94fXg==
X-Received: by 2002:a05:6122:8711:b0:5e6:6546:84c7 with SMTP id 71dfb90a1353d-5e91f339ea0mr24904e0c.2.1791499037319;
        Thu, 08 Oct 2026 15:37:17 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab8c40sm393284e0c.3.2026.10.08.15.37.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 15:37:16 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v2 0/2] scsi: target: rd: Fix oversized ramdisk allocations
Date: Thu,  8 Oct 2026 18:37:08 -0400
Message-ID: <20261008223712.49827-1-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

A ramdisk page count set through configfs (rd_pages=) has no upper bound.
syzbot found that a large value makes rd_build_device_space() attempt a
single sg table array allocation above the page allocator's maximum
order, which triggers a WARNING. Patch 1 rejects page counts that
exceed system RAM and allocates the array with kvzalloc so that valid
large ramdisks also work.

A page count close to system RAM still passes that check, and the
backing pages are allocated with GFP_KERNEL, which invokes the OOM
killer instead of failing. On a 1 GiB VM, rd_pages=250000 panics the
system with "System is deadlocked on memory". Patch 2 allocates the
backing pages with __GFP_RETRY_MAYFAIL so that enabling such a device
fails with -ENOMEM instead.

Tested on an arm64 QEMU VM with 1 GiB RAM, with the syzbot reproducer,
normal and NULLIO ramdisks, DIF protection space, device removal, and
rd_pages=250000.

Changes in v2:
- Allocate the sg table arrays with kvzalloc_objs() so that ramdisks
  larger than 512 GiB do not hit the same WARNING (Sashiko AI review).
- New patch 2 to avoid the OOM killer when the backing pages cannot be
  allocated (Sashiko AI review).

v1: https://lore.kernel.org/all/20261008215709.46014-1-sanan.hasanou@gmail.com/

Sanan Hasanov (2):
  scsi: target: rd: Fix oversized sg table array allocation
  scsi: target: rd: Don't invoke the OOM killer for ramdisk pages

 drivers/target/target_core_rd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


base-commit: 6c377d19d4a5116d9bec5203aa3c6c11523e7898
-- 
2.48.1

