Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3934AF9EF
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 06:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872507; cv=none; b=LQu1DEtB71yR2tQ9UuUOsjIae6JO6yhWqWvcpNdHE7AuhtQqV6vSfRjxJxgVfG141H4liABbIO0ej5p2nQgbwMYEMx6sy8xjb0BrKu5kp8TYb4XbQPZfaFM3hUi8YQFftiL6B/lkeqwIP4ax2Z0f0vaXq4gzRdjNm6ZY/1Dn8rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872507; c=relaxed/simple;
	bh=+0sjJp7GUck+kmSTLcqkNlFdCrd4HH0Kges/c2FpOdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VoMr6+sRe8Uuan2kE8CoefxTBpeMMLvW1mNAW4tkPXuEx8fS3KRYfYC7+DJT9uoJqy6p+LxrOQAkYeIcpbq6QiSt4RhZVpIfO1hNxSk+tB+FGkXboeCp96P5M0GWddmOPLBXcWNoXyv2btIKLhJQNPwESZyk+7C4Nlaif5LwjvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=cp5cASK/; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="cp5cASK/"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so1975969a91.0
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 23:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791872504; x=1792477304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=el7un8E4JafzRvdVXq40LHzl6eMzoAXr03vHGUr2/AQ=;
        b=cp5cASK/hp8630JFZl5CV+DYLf9TE9kVVHmk+K1UK+5mNeipxp2plUx4JyWqnUlKPS
         QEuEOgQgUEo/tK8ysO6l80aS9O8R8uR5Y2NqI25XjEF8Ip879ut2UmZn6qAOTNLklACI
         0DOH2Sl73okzxlA+S4/tRcw0Icv6lBq35ElL7h1Ve4tLOq3ppLf6CxcIcCjrQhDITZbu
         jZu4VDfJyKAO1rVVso3gKatqmeWbgl7XPC4zGJw3sUP1M1fsm6V7RoN5+sFPknt4gLsE
         Mhr9476eUeNbHK71T53o5VeRNkxzgFFTf9aYARGRfHxgV0oVtdyARbYvcsoHkYC7Vuyj
         RqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791872504; x=1792477304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=el7un8E4JafzRvdVXq40LHzl6eMzoAXr03vHGUr2/AQ=;
        b=wlPzPSGo4GSDYvEcJ2WA0ce6v5W3JrpX9/6IRult6vSgSVFY7ZosHp73ReYO8OlvWZ
         eASGBVrKpfvCPlXZMQqmQum5UNMwicGPTwQgoWLaP0hyh4pyIFyYeONJUPSBnTJkfKcP
         UglGMUCHTeg2jF1xmuBfF8hPykKh8OUhggPRWpKV6d0ax5ouKu60B68czkBQ5SMxKyT+
         cAhFYKg62f4bjU7F3KxLkzE/z5G6GVgyabxvEqAY6hpMocjC3dNSlPsFMH0s/bKhz4ZK
         RKel0ucqAil22pUQuEHUPgmI+Wd126vGkb1YAfuAmKEki80Su6TjuNemaW0EcOsTUlHt
         uMvA==
X-Forwarded-Encrypted: i=1; AKwUvBziE7JMgFpS8YaI0UxrB7/cZFfjooCEQnKxXPtV4mXLgWM9Al9Pl1bkfByj5Arg66odiRmt7WQLrp9KNXw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJoi1V8aGJTgFBbhCP2dEbhvKigOdU2f6xtwxX4tR6VF3C3wpZe
	2VdD32sxS6t3vPT6EvvKb8GTEu3Ie/RromlXWMD0BcRbPoScvFW7b26g3TsURVzFync=
X-Gm-Gg: AYBFou3hD/eWgmfO1uiFLRRV1qr7+uusUFzhH/cJIiyPqty2T+zSkcP66g+Ygmk+jxu
	7M6HzZFg0DZr7BUjtxFHkrM/rXFKXBUYbPF6UmJn2f5sXx4KA7UM9hwR/Qeij6szAl980OMd1Q3
	VI7PhJ56mdBiFJGeF3j4XEAlgXokR1E2MyIkNOx8GuzJ4YxVzivL5PDGLe10bL3Nb0RJvrXfqVv
	lJWtqimB08llLgCvI/1P08+NUabr6TJ1iqTc3RbcVE6zsdLbArcRTD3YJ4TSgMIl62rH0l3SMmv
	X96uQei1mJTS84hs7vw331UguBcjNgTKf3VkH6j3OfDNz3AlK68LUVw/sTXrEUzWGQUlfCLnPfo
	d3Lv4xK1y2alSCXFBY0kSmi+oPMDYoeMK8mJoSTQVaSJ+zOiO8lPSjOIc3EouHDns6SfYI4wUz3
	XSUIK4eeYsx19a6J2yioGY7Lrwt8/Eh06S6yNaSzbrzV9j1+04HDibhk4SNQJMv7exsdxGWM4FC
	PSrww==
X-Received: by 2002:a17:90b:2784:b0:3aa:6b5d:9fe5 with SMTP id 98e67ed59e1d1-3ab3ac91446mr10249452a91.55.1791872504286;
        Mon, 12 Oct 2026 23:21:44 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab32d3b4f7sm9253553a91.0.2026.10.12.23.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 23:21:43 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 0/2] usb: gadget: f_tcm: fix a short write infoleak and a completion-path sleep
Date: Tue, 13 Oct 2026 15:21:27 +0900
Message-ID: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes in the f_tcm BOT completion path, both reachable from a remote
USB host.

Patch 1 is a sleep-in-atomic that came up reviewing v4:
bot_send_bad_status() and bot_send_status() queue requests with GFP_KERNEL
from endpoint completion callbacks, which run with interrupts disabled.  It
predates the infoleak fix, so it goes first.

Patch 2 is the short write data-out infoleak this series started as: a BOT
host that sends less than it declared leaves the command buffer tail
uninitialised and f_tcm commits the full declared length to the backing
store.  It also stops the status phase from draining ep_out once the OUT
data stage is over, which otherwise wedges the bulk pipe on a failed write.

v6:
- 2/2: skip the ep_out drain whenever the OUT data stage has completed, not
  only on a short packet, so a full write the backend rejects no longer
  wedges the pipe.
  v5: split the GFP_ATOMIC fix out as patch 1/2.
  v4: keep cmd->data_len so the CSW residue stays correct; skip the drain
   with a command flag (v2/v3 cleared data_len, zeroing the residue).
  v3: https://lore.kernel.org/linux-usb/20261013015416.2503787-1-yhlee@isslab.korea.ac.kr/
  v2: https://lore.kernel.org/linux-usb/20261013005854.2470384-1-yhlee@isslab.korea.ac.kr/
  v1: https://lore.kernel.org/linux-usb/20261012154422.2436134-1-yhlee@isslab.korea.ac.kr/

Yehyeong Lee (2):
  usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
  usb: gadget: f_tcm: reject a short write data-out transfer

 drivers/usb/gadget/function/f_tcm.c | 18 +++++++++++++-----
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)


base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0

