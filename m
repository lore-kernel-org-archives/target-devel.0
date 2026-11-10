Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.114
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317382;
	b=BAjQt8cfDKknhOmukosX1e+1vijXjvO7gQm9EkzKsp1teSfIqFd8jTkYfgA3B1E62AQa
	 yGT6xd0IvvHiPoeJ4e6KwpcY4yw2fqx5OaMZ3q7v+TzSXJg9/xmyMP2Ff9QrS3Ma7Eh+N
	 diOo7TknLtIKcNREBbxQMzOcZ3GjBd6bE7qr6tUWI52NosWNrRJLMXLITRKY1kL1eMRrZ
	 UKnutolpATV0DGuu/aY1gzxRIILpbxmqC1kdKpgft+JQ3ilMti8N3lqA/A16uJzebi/Qr
	 pL5olt0IEasYLaUM76atA9Rgfm4frVjTFFJaUHxpErRPT9rH4mNIlQl6k2u3POPINXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317382;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer;
	bh=me+Mok8uviVB0NYu7k/EZr8NLfEietX24VsByp8qjw8=;
	b=qPpnbRxqRfgthHuFbZPeCCnzvGvyfFTVPHncMKM3mcSVybeXftKI2m30qgXPbXmQqt8T
	 nXFM5qAUDVoDXDsUNxlcKieZ6B2BSrQtqPdjKScGfBWqVUyGUHnvdg2Ix1fcvuoL0ob04
	 f/D0hoB78OLpoUp6MAznLxJ8QURMYjRDfkTa9fPAJ8D7ZMzMMihwCcM41w++Ypj83mM57
	 8H1mN63J8I9v255RAgInKz6hXEEthQksm4zbsH9eUi0Q9JW0NUU++TvpAyHROcwsnelGJ
	 VSNqsHlDx0FsGuGMtCNCH06FFUWn84lfar8DGtoXcs+uvjOgLPrtbuWdRVqFADaDQCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WXfrJjJC;
	arc=none smtp.remote-ip=95.215.58.114
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6D7606A762
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:29:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB6D7606A762
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WXfrJjJC
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TqP5vO691FPgdSXaJrVOyHuZq5HHrrDwziy9HECDC6I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794317378; v=1; x=1794922178;
 b=WXfrJjJCbTwrC9fiPFsSbMJUC4Ao8udEQ6VunJsz9jrta4xsTU7mqyGlvAK7Jz4u26xSmMHh
 zMSL7aiqzt4HM8HG7qCT8ID8xw/76RTZJrcruyuWZW9Al0hpmgT+ylvfCt69ZRiy/DUFiWvcwLQ
 Uiwm8N9BpuSeaGTiGwQax+LA=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 52397fc075a5a131;
	Tue, 10 Nov 2026 13:29:38 +0000
X-Mizu-Trace-ID: 52397fc075a5a131
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Subject: [PATCH 0/2] scsi: target: alua: Skip grace periods on LUN add and
 remove
Date: Tue, 10 Nov 2026 08:29:32 -0500
Message-Id: <20261110-bug-target-alua-lun-gp-v1-0-127a46efdae9@linux.dev>
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
X-B4-Tracking: v=1; b=H4sIAD0c82oC/x3MQQqAIBBA0avErBtwQiK6SrSwmmxALDQjEO+et
 HyL/zNEDsIRxiZD4EeinL6C2gbWw3jLKFs1dKrriUjhkizeJli+0bhk0CWP9sJFk+J92Ii0hhp
 fgXd5//E0l/IB2rkvQ2gAAAA=
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

Creating or removing a LUN through configfs attaches it to, or detaches
it from, its ALUA target port group, and both helpers wait for an RCU
grace period afterwards.

Neither wait protects anything, yet each costs one grace period per
LUN, which adds up to seconds when exporting or tearing down many LUNs,
e.g. when targetcli restores a saved configuration.

Drop the wait on attach (patch 1) and on detach (patch 2).

Adding and removing 256 LUNs of an iSCSI TPG through configfs, five
rounds alternating with and without the series, takes (median, min-max
in parentheses):

  256 LUNs  before (ms)       after (ms)        change
  add       3144 (3104-3175)  1379 (1277-1393)    -56%
  remove    5222 (5165-5244)  3551 (3436-3810)    -32%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
Qiliang Yuan (2):
      scsi: target: alua: Don't wait for a grace period when attaching a LUN
      scsi: target: alua: Drop the grace period wait from LUN detach

 drivers/target/target_core_alua.c | 2 --
 1 file changed, 2 deletions(-)
---
base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
change-id: 20261110-bug-target-alua-lun-gp-b410ef8d1144

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>

