Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317384;
	b=IYC/G6IdeSpZgU3dLXD1FtbCbx7VzKQ0+M2+KAF9PkJVWjG9JMZQd+P0POubcIcUFBMW
	 CAWZTnXv6g39wVHMj7rJ++VXkBgXUKC4KWaVOrj+XMsWuxv//xQCs7Bb2EZKsmZ8QJFA/
	 fVluFHvbOsGfMCsXAyafhmZCDaKES0Dp5dOfp0Hd2y35pKbJmroysTjY1p0CTC+1QWVCJ
	 G5gCtC0Nc4HoqOGe63BbtZc124HCW5RydgaoaqbmRaLqkzOpzQuZqn+Ijd0dEyAPd4Xku
	 MbjYdKqEabWBNtq7OIR7MXp34uj4oCo+/ZakX3yj/PbyiuSNoZUXIvQMF/S62UOitVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317384;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=jgso6tJmEB2XfIL93/0JPnTAox6S4LW6+iOQSGCi6XY=;
	b=ftfuAZpu9v4LjeWJx3qluAo9EmK8IiDxZcvSjqCecuWQ6gjPPVESMZyXnjSHSfzIqkFD
	 3sq8shT4zGekbCUAHVRVi/irqcM43wJgnZFD2RqKleayIU87MZHwG1ryoG2mVsK2xd3av
	 8tVs+OxwBC/UL9Mrz5RXyP/kt1bVkk//zNWxA+Abm3rnR23LWcTyjsK83wAXOAkxCi2jx
	 IZbKtxeOXdj9tHEysrfAFoLZe7K43tCTpAmOl0sp5cjNXcljwW5vQNGt7zR3PvJ8cXbjm
	 7RmMYFooe/r2Y6FHk5fHBYp3GYoevAQPs4cF/ipRLKZfid3q784FpQt4xYuYJqLB32Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="orTvB/dy";
	arc=none smtp.remote-ip=95.215.58.118
Received: from mta1.migadu.com (out-118.mta1.migadu.com [95.215.58.118])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13651606A765
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13651606A765
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=orTvB/dy
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9cKpPKmEltljz99s+i6EK4S9sRHBgg9v/XDr1c1H/ps=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794317382; v=1; x=1794922182;
 b=orTvB/dyxrHMpYCsImRyYMBXyZWB1OztYmlnPzJJQnIbCL4txFHl3e4BfprgWI/wlEKQ+xhP
 kHbfzzku2+u/M6xMwH/NH1tuetCKfzMekQBXwddof3JWsX9G6AJnvozmt933N6yYPmJqQN5kY8H
 OAd+ZxQKl4gY7H40DUzQ8rd8=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8423c878624c449f;
	Tue, 10 Nov 2026 13:29:42 +0000
X-Mizu-Trace-ID: 8423c878624c449f
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Tue, 10 Nov 2026 08:29:33 -0500
Subject: [PATCH 1/2] scsi: target: alua: Don't wait for a grace period when
 attaching a LUN
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-bug-target-alua-lun-gp-v1-1-127a46efdae9@linux.dev>
References: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
In-Reply-To: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

core_tpg_add_lun() attaches a new LUN to the default ALUA target port
group before adding it to the device and TPG lists, and
target_attach_tg_pt_gp() then waits for an RCU grace period.

The wait protects nothing: lun->lun_tg_pt_gp goes from NULL to a live
group, nothing is freed, and no reader can reach the LUN yet. It still
costs a grace period for every LUN created through configfs, which
dominates the time spent exporting many LUNs.

Remove the synchronize_rcu() call. Group changes through
core_alua_store_tg_pt_gp_info() keep their own grace period.

Adding 256 LUNs to an iSCSI TPG through configfs, five rounds
alternating with and without this patch, takes (median, min-max in
parentheses):

  LUNs  before (ms)       after (ms)        change
   256  3144 (3104-3175)  1379 (1277-1393)    -56%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_alua.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c430..35d36cd36db6c 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1833,7 +1833,6 @@ void target_attach_tg_pt_gp(struct se_lun *lun,
 	spin_lock(&lun->lun_tg_pt_gp_lock);
 	__target_attach_tg_pt_gp(lun, tg_pt_gp);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
-	synchronize_rcu();
 }
 
 static void __target_detach_tg_pt_gp(struct se_lun *lun,

-- 
2.43.0

