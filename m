Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22515477E57
	for <target-devel@vger.kernel.org>; Tue,  4 Aug 2026 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879456; cv=none; b=THn4BFG8MJ7galRqn2WG5szPPPfl0CSjavTK451chxH/EUV89vlV8vA/dVq6m5qW+KXNdDsD1JI2DSjNx9XJxtjLga4qVXn5ugEoeO7pfimzIO/wJ3QJxXZa+WZEpqefbqTw7BFQAGaxihdBugee9wtUnkWpVG6RFl6J6bTGhBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879456; c=relaxed/simple;
	bh=hK4xPGY2IK3gul7IpcA8bnueNq7919WPVp+ViX9mklk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrhSkduu1Mf493JurmihYKlXfzw3ukG6YTdlf5KxANV/iHklLVjLRC2fdB4lSQb1X1fCVfjaqqjo5DZmiGB9OeSKjWTPuRmRT+cOscXWAblD0a+Czm3UX6ocl3IyoJqhiD7KrIxEtx3OXZ1MnQ1KfEXH0psy6xd0NeuXkWYA0ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FP//a1VQ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FP//a1VQ"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-caf45fc5202so231109a12.1
        for <target-devel@vger.kernel.org>; Tue, 04 Aug 2026 14:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785879454; x=1786484254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JOJcT04MAKZ1R+76HgJ67upFnuCPH8VuW68e8b3zSd4=;
        b=FP//a1VQLkR01akOee+BfgGu0DLtvpJ5nNcfey3y5ZbeaaSQmH/RcmX75DbfFPVLLD
         MxxtgvvP/p3HaiO5uMRQjjyhYR03yEiiTL0usmgEINsjoXZRd5RQFFuXQaHgL6tLh4wr
         Teg2XwXLvw3G0QWREJX+g7Zbubbquuf8uXkgYC5EiG1zmuV/k5oZBIELlD8aA1/AUId+
         oXfG59JQAWxIcwosJ64/n9Vso7VU+C6t5o7C2Heg/RvwO3WdqYVtzIdAHF41DkJiiK+I
         Dj+CPgXbzxo1P44btva8E6+01oDoG2LtpQxTUNESUnJJ5TTfFvjiWJZORGW7Tt9N3ewE
         /SwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879454; x=1786484254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JOJcT04MAKZ1R+76HgJ67upFnuCPH8VuW68e8b3zSd4=;
        b=UWe0Md1m0FYQ/HYs1gkHgRRQTrbutLkJqzGP2YOiUIYyvbEQltP8O8sMCD4Q5REGSs
         0K1WpoJJpFTQlUwNqxfqBUX4nQC8q67IiFEXYTJ0TjBLJ6tYIvmCiQwg7Hm+Tfu4Ft6d
         f7wj3fLVLVwXrMgNGc04x4+ah/XiCQYqy+als0z0PVHyBe6TZ7yCEFDOf3OBuAnsrril
         l+M1T77a4a068iXFlmHjHv4LWIqCybTc9zDbmMJbkuyiOH3KCCIqEmzkscR0VMCw+dpb
         uFlmdICctyCFDaZNRrP8/gjytPG4b6mUoPpn+/nhBqrCZwqNYv4OFTeurSxqccof2pwJ
         Ggog==
X-Forwarded-Encrypted: i=1; AHgh+Rrl5nbNYcTpoJiEjrwuEzgQvPSSpgYkVo2bKXMwDMa3CTQcxt9s6DtagtV5S68Ya3rfdyjJFkWrl01n8yc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYW37kZYuwgtI0VrG+Z3prQ+PYPk1bZ828nIUKijbdnH9+O+5X
	B6o26MmEY6DzQG4P3KKOdE48lbNh8hD1e5NxURwfkuRBlMJj2gIHb6jf
X-Gm-Gg: AR+sD11lu2FWjbooKO8nlRaCHKMrLFSeDJK5ILECZyd3Q0gXxcFXW2XgRqCBG1TsPaO
	D+xQHj9bv/72RdYd5FgFWpMRuMqZVfdKbRRY6uNIvlSD5kr8gPbgDJGUMm4R5R8m+BE3Od4Dc9E
	1dMU13OET/Wu2PO0m88vJ3CtFkY/F8WgJnf6gQUf8WGp8CW+77cEvkQ4qDRySP0zzKyRrWmSh38
	RYrT31a83Ci+YLZCKu7fuIFYUGYtEMNorB9Ag2ZIOmm3OkA27QjKwghc3BAk3sUA3ki+4D0uJVd
	5xHTlesSUg7IOE5IoBZIO141vRH8WZjbwSIzGbtODjkEHAAsV9PSKUrgJhrPrW4zvcBkIBJ9w39
	13dHmJAff09+4pIVTWQQq2n6V5ueUx3eCOJjN6XqLm5NBnOpZPrSPbqUPuJw+pqkdEqythRgnLj
	elOibZSH8cF3icZ/NhFDQbyxirNURbS6mOJJ+cKJ7n/T5j8Z1DEW6ANOcpSxNPzChbDQz+kvJyn
	TvXgFG+KjpfgXg0ANcc77FH8RDnt6iXeFDSR4Zm1zU=
X-Received: by 2002:a05:6a21:3392:b0:3c3:9595:57ef with SMTP id adf61e73a8af0-3cb85ffd1cemr1992015637.31.1785879454517;
        Tue, 04 Aug 2026 14:37:34 -0700 (PDT)
Received: from LAPTOP-DPAKMOI4.it.purdue.edu (pal-210-106-74.itap.purdue.edu. [128.210.106.74])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673a9e4sm9532563eec.18.2026.08.04.14.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:37:34 -0700 (PDT)
From: Yifei Gao <gyf161023@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-kernel@vger.kernel.org,
	Yifei Gao <gyf161023@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: use kref_get_unless_zero() in core_get_se_deve_from_rtpi()
Date: Tue,  4 Aug 2026 21:37:25 +0000
Message-ID: <20260804213726.3411698-1-gyf161023@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

core_get_se_deve_from_rtpi() iterates nacl->lun_entry_hlist under
rcu_read_lock() and takes a plain kref_get() on deve->pr_kref for the
matching entry. The disable path, core_disable_device_list_for_node(),
unhashes the entry, drops the final reference, waits for pr_comp and
frees it via call_rcu() while holding lun_entry_mutex, which the reader
does not hold. A reader racing that path can revive the kref after it has
reached zero, defeating the pr_comp completion barrier and leading to a
use-after-free.

Use kref_get_unless_zero() and skip entries whose refcount has already
dropped to zero.

Fixes: 29a05deebf6c ("target: Convert se_node_acl->device_list[] to RCU hlist")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
---
 drivers/target/target_core_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9db2201aa553..bff97c6efffb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -220,7 +220,8 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 		if (lun->lun_tpg->tpg_rtpi != rtpi)
 			continue;
 
-		kref_get(&deve->pr_kref);
+		if (!kref_get_unless_zero(&deve->pr_kref))
+			continue;
 		rcu_read_unlock();
 
 		return deve;
-- 
2.43.0

