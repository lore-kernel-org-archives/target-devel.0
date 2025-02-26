Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E07221DA1
	for <target-devel@vger.kernel.org>; Wed, 26 Feb 2025 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571829; cv=none; b=DHe/I/hcRmgsjJQBuLouuHNIfapZYFIF8Z8wTFdLfzJPrN6eF0gddBY27ChFdMd15sTjlgMEQZ3hnih2YpQrg8XUoJg3KuxVzKx6i9HO6ccnpowS43yUTvXwGAP/g1gfUuXwBeCPv4sGnbNNeQWe1dhc21c91xK9q7ekmSMb49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571829; c=relaxed/simple;
	bh=NDQLjOPiRU48JFwf9tbOAqkkM206hTnuNHycxmdmLjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idCJ0ZicqaoLuCZXnt+YoD7fqbT2JDK/iJoEMXe3DTy3IaKnoYekyctdJzq1IPacJmyHzIS93SDRqYQFCtPjiQQ8T1x0S55J4x7J/tSw3c6iPB4Qzd6mxZASsWzUnUAJA0HRZGkXHBkVcnBa0H89wF6xrigD/+RX6ObRHhC36O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mGTdLCAZ; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mGTdLCAZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740571815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+i6UfT5KyDRrgh8kYOD+6Aqz438J4G3HLbqw7xmE2yY=;
	b=mGTdLCAZDtzVp/Uo0ar2swpaAsTqoP15oWrtR6IiRyLQyeRGr6tT4k0PgodS2mmOqG7pT/
	5xQwEUPqi6tu5DJ7G3OKlTKKinEurFpoymNL3DPjbxlHJ0BW1ynYW30l/18zgns30n+6gf
	bg+85t1xcXbNWmfYZXGQaU/RACeTS3Y=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: Replace deprecated strncpy() with strscpy()
Date: Wed, 26 Feb 2025 13:10:03 +0100
Message-ID: <20250226121003.359876-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since strncpy() is deprecated for NUL-terminated destination buffers,
use strscpy() instead.

Compile-tested only.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..446682f900e4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage, read_bytes);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
-- 
2.48.1

