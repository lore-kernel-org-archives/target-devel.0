Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7E63876C5
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 07:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876827; cv=none; b=VYqBjYfR9ACR5ojBwmfnO8XxoR0zLtnX5CK9FmBfQVH0wJCBNM90ZxAaEuE3L2RY68arcu6SV98vjUQV+urVmIEm//VuPreW7+yyzMC/YQUH+02EDW5A6UboBJc60zw1Ex8UX1u674KZZzXkn7CREYsxgGqvOscZHSGxaF8NvRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876827; c=relaxed/simple;
	bh=KucUBB9lTSz8tRyvoLPHAINkNXwe2/G1KGvnMr1jeZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tslv+1waCKFncwwCp5dq3s/LKRBrKLP2s4fMb5L9ZtNlpbiy+F+7T9CMeLS0Z+TdFwgVV+A4zTwHy+U2Lc13LZ7ZFo70szyKjukWQ3IfQDWFkctFqVeAFTJPGLZJD8p7JyHUO82xcbBYPYoDhTDlPKH/bjj7U2lw5yjzpmG3pXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Netz97Gz; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Netz97Gz"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a706146559so1518842a91.2
        for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 00:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791876822; x=1792481622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TRRiHYy6zpA6xKEITPlGXwjo9lrzT4B8JgkHU6vPJVM=;
        b=Netz97GzE4CGHPuMHo58ZbhQ2vxGYyXPM2dB+JwkmfZPxkLThaK4BibcO+DVwq2de+
         x9hYSzclzZazRlLfogQitJMWpsqIhjX/i4AbymNkN7IhcwqtFxgPD+KFbwOLitm7w+97
         GziNBlJekrirEOQ//rn55R2hSp3iVqcwiOT9lJtjkFUZ1hjzSG4iqbg+O/vmb5iGp77I
         MKKE7K6eCeBcvCFsE/zOlXeDXdPN129ZiAOaMGOpwqS7T5UsAAFapd80LcIZ6dhtwywg
         yK0TobyVusgAn9JNjTz8LFT25DcMfeEm5ZvDQ7SsAXBUsWlKqQeAJiDpHClQYPi6cem1
         ddWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876822; x=1792481622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TRRiHYy6zpA6xKEITPlGXwjo9lrzT4B8JgkHU6vPJVM=;
        b=BXBfGxtA8bCAmEIwND7XvpjHOcWyLtxB6H+V3TRbD+sryb9Wvx7tEU19bL2NX/A76s
         JQvM76QBPMpx1BULQ2GPxDhOoYpnkVSVgENkxzmcnFqqA/P112yyoP5cc4UuROF/EwoH
         ZETiz9llcEefDvXEnn7cPT5uutaPdRhU1+XL+zOCOl4FZSln9PrsEIVkgCfwh04QuUCo
         l/Lq+lBgVElqjdKVILIPQ18dehA689HS3Qsd0D4t28v0PKyk/2YzcX9ZAmCT8UAJA7M3
         5L8x4Mp88rlM43NugiTyLvQMRK2M+BTt8BR03Lfg3WvUSSWY+68EARqRDrUWf1iemPea
         jyDw==
X-Forwarded-Encrypted: i=1; AKwUvBy6hoX8X8laf3Mvp5BVh5cknOyTFD4jZcsMnTaW0oMcJUQY8J0yTzgy8f5w33ZS0oie4BcOJF2o7BhwoBI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKuwdeZr8sO4gPo4pPO8D0G4TUBPi5UB4K+BZAAT10NS9UHaQAS
	yAH94mWUiH23wNmglByovtcUMqJiGhR0lIUG1UaqOsU5H7qDq0V4XyWAGIskwmckuAg=
X-Gm-Gg: AYBFou3dsA3ZBRDyk4Wq68GDi4QXOaXX5nF4NfER5rIrjjHMfEQf09G0Njrg/KMdrlj
	O7pazrSisklUT5rwGFE2TKjYa040CVOHSYvlTCBBxTSQDOADjfR7btPtnlK65imtoHuy5y5FuZu
	EP1mpdx5udnK4HmvLusWROK+wUMIgvmPH74I1NkqNnEHc9uRSmMVBUyp1VPUTkGJ+/1rZn3m8xa
	0vEAX90BN2Sl+5Nmrj0gP517/AMIZt8dsQ2tsMulPDHToFhjS0W5mE8dGlwpXR/REqK7NxVRkQ2
	2iXBZu+nKOlHSnjKB7oknXYDivpEi+LAD+1GVYFAmXoTTFZz8egcJo22qPrIOcsflpRtExg+XyP
	UBwZnFNvqh2ys9jcrJLifpqdiL3Swa4ZVPNdgMajTxV427s4IuQiBGcmoDaLEC0T6kr176hM/FI
	9f+WKg6hcB33JFP7Hlo+FNPJD0TqwD7UonKDJMt+Ra7X4n80/OGP/sFKam09MMsp97EZF2nOMKO
	dyZDkI1iP+1lvL6
X-Received: by 2002:a17:90b:3a48:b0:39d:f6a6:60d8 with SMTP id 98e67ed59e1d1-3ab3a33db57mr9822164a91.3.1791876822064;
        Tue, 13 Oct 2026 00:33:42 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed0daesm19973923a91.5.2026.10.13.00.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 00:33:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v7 0/3] usb: gadget: f_tcm: fix infoleak, sleep, and UAF in the BOT completion path
Date: Tue, 13 Oct 2026 16:33:25 +0900
Message-ID: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three fixes in the f_tcm BOT completion path, all reachable from a remote
USB host.

Patch 1 queues the status requests with GFP_ATOMIC: bot_send_bad_status()
and bot_send_status() run from endpoint completion callbacks, which are
called with interrupts disabled.

Patch 2 rejects a short write data-out transfer, which otherwise commits
the uninitialised tail of the bounce buffer to the backing store, and stops
the status phase from draining ep_out once the OUT data stage is over.

Patch 3 clears the scatter list when the BOT status request is reused, so
an sg-capable UDC no longer walks the freed scatterlist of the previous
command.

v7:
- New 3/3: clear req->num_sgs/req->sg in bot_send_bad_status() to fix a
  use-after-free of the previous command's scatter list.
  v6: 2/2 skips the ep_out drain whenever the OUT data stage has completed,
   not only on a short packet.
  v5: split the GFP_ATOMIC fix out as its own patch.
  v4: keep cmd->data_len so the CSW residue stays correct; skip the drain
   with a command flag.
  v3: https://lore.kernel.org/linux-usb/20261013015416.2503787-1-yhlee@isslab.korea.ac.kr/
  v2: https://lore.kernel.org/linux-usb/20261013005854.2470384-1-yhlee@isslab.korea.ac.kr/
  v1: https://lore.kernel.org/linux-usb/20261012154422.2436134-1-yhlee@isslab.korea.ac.kr/

Yehyeong Lee (3):
  usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
  usb: gadget: f_tcm: reject a short write data-out transfer
  usb: gadget: f_tcm: clear the scatter list when reusing the BOT status
    request

 drivers/usb/gadget/function/f_tcm.c | 21 ++++++++++++++++-----
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 17 insertions(+), 5 deletions(-)


base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0

