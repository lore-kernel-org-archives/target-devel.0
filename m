Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881796;
	b=vZwODY6s3h7s2lZNXBTm0YqABbUFyRgVk/NwxEGoJlpK3dOOoM1nzWvvj4Q1hQjnI6zZ
	 V/yvjmAjMg4Le3WbVNVWoLHgddm0m9u/1gcXYGpVunvg4zLcTaShki6X0xhgMhVLBqhLp
	 npJXSFcD99PTR9Lyb1pQonVgRAY+0pZ4U3YyJ839ckFEwOWLUHyOsYGaMmLRpIP15goZi
	 NkOwFCmuGGSmQqqwa6Bt5zJRa4Pjn7Y2QzBtHKiR+m348qDzliNNYTB7KQGiL0vI+jiK7
	 crJWQ7EEnGNvJ4jeYwOPgHUQ3J4OoX3axHRcqlAU66TLR7b7sJqENoGPJxSXhiaRcoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
	b=rj/RyEcszG4Uo7qpDnfd0pAy2jvDryKHxM2cWZaulfZm1rXfMrcHeh3hOZOIiUZ5HOeI
	 ZB0FW40mVP9JLEat5M84Ve9zAlsgG/EgtA+r04pin+N+j85bL7nNt93rtjRZyjufeU6dL
	 e6jN4EyggV91Gjj7jDlUpCjJ9EdkSO+1cwAQxg6h+r2sQscU4m8YFdU8DnKiGd5/1Qnz9
	 JUvaPkkFd36nOfx/B3TxE8vfXydwoDSpDyvuopk4c1X3BGZF6bQOHN6yejoQYwB92NuyH
	 FS3PAlShOBHjPAlV1d1XWStW0AaaNKvIb1gkj9fPFqJrgvHM1/sqZphjhGfQEoqJ7zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fm9JXDkn;
	arc=none smtp.remote-ip=209.85.167.181
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677B5606A326
	for <target-devel@vger.kernel.org>; Thu,  5 Nov 2026 12:29:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 677B5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fm9JXDkn
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-55e02e89f78so571434b6e.0
        for <target-devel@vger.kernel.org>; Thu, 05 Nov 2026 04:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793881794; x=1794486594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
        b=Fm9JXDknaDxCxLS6wrV3RwSaRVQyUWNyTKmw5zMxq57j7qAaUBOCz2g0+vaC8PktZi
         Xl3mOLAdzrg7AipdBjCVXYFQNDHTtcX0Ap6rjhEOrUgUtxd82+8Ps8qO7zW60M8NM2DB
         7OPX5YLz89b9d3OF9x/ufbkSv8D0hUxaJIkNulN3mVQOrjP3k7yFfmqf4b2EkOsepEO9
         0JHBkx4TFPJoTSNWIDgMBvVxoUoGlGonurD6Qx3L2ywAIkZHePQ3v5/a979E7tOrhbt9
         7PU6KRLTjGtIvKtQdVPfrAwbxDfoT0ciak84WFQuHn1MpBYE3UKQUiSGCwcXpa91SbeB
         OPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881794; x=1794486594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/UKcMNNWqDuqXMXW8ATBrRl5fb2pZBkn33rI/MXfTss=;
        b=TO0fXXrCthNJsihgSzj6vSa10ZTHe5xpznZFks+jsbuyzMPewqCOEuVZGRk7T6Ll5N
         znSmlqChVXfOYhuIsGakWWska9B+ysUETVDC/4z5p90Q7CO9mItc1uzAt0v2nXB2X9Tr
         U0n9zaM7OKEgoqw4SL3P4SaRZTwNfbvTUC7GNcQOy8zCNqOoIIU7qDdIIHfiGtMBZ31a
         sbjqtS/cH5NUIk9CCNvLdsAkd5dWvVWPbS23c9s8OKct4aXQWnjIeRv/5BtDhniWKPLC
         q8BxEUyKUITEcNZ4syg62mFxV5uJqQOoaLY1CtssSwvWXQ/Iv/zpZkiJ4IjKvXFhaK5F
         QCLg==
X-Forwarded-Encrypted: i=1; AKwUvBxo8oC1FGdZhBXUw0WtTclA1lnuwhaiWtNO/OYq+Z5XXHmh+/RskHh+7ikqe14ZKvslgV9gevof3fcSenU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8NsCaIl9eiUPQMZ3Rk5KWfq6JY5Ui7+FWrnPSJHUOutrMmhAtn
	QXDnrE+V9g4rkGYdZztjULf7K/HUOvHxGwL2yucICrlA/3/1KwT2E31W
X-Gm-Gg: AYBFou349qMAv6BZ+ZCZ2G1eym0BOtNZr8fk8+EdI4EW50TxMEyea5zWqYWr+K0n/CW
	mj3FkSHZj2AXAeJckqAPwAJ/XIu9n0sTtyNkrWb1HZTrjlEop2kNDxTS+JLOrK4eYg6HdsRgqUK
	YJ/IZZra+0Xd/yNcRI2Z5IumPuYfIVDa8mkSgZC4qz0QC2YLebGuM8+MWBpSX3USqvm/CMwLmmn
	i2Z8atGGpHoviHVEjo0hpF7LG65IuJ1j9/bi40eEsAk1wR/H1IR4GP46Q6ZE3vEsEYaXZ5ZDmb/
	8VirtpwC35s7NLDX4LrINpOV74mHToyXEYqvJ+M4QKxJuQt7yf1+zvSzz0YbZhxJB4stEEFCOGH
	g1SVqcH0G58ILeS8BDAr2LUA1ddZaQ4wg9WsCNwDS5BIHC1lcqzBZ4q5E7/Y3RaAR6eVqlDTgy6
	k0QM2J6lY+NlmH9bCm6kenskpnGqT6zHlZqH5D+VGrLARo7zvU0veKqoNwoXKWdHK9LX+UzsYrU
	8j0943nMEp8mS8edSItTiIzvF3cVzeTVHqYYTV4bINx6i6otzbkbp9z4gVcoYVurK5IepNNDSqB
	cfDWEgx31F/NByP0w1y7BYNsKrdcFcWrQtle+IWp31U1PLukXX6Yrx/0qyZ9VP/ly93kgUO5hqD
	1W5d5ky/3n644lPUwWiCBi7BqM9OclUc/Cs4uQw==
X-Received: by 2002:a05:6808:3099:b0:551:eea6:9397 with SMTP id 5614622812f47-5640de26014mr15832813b6e.59.1793881794223;
        Thu, 05 Nov 2026 04:29:54 -0800 (PST)
Received: from cr-x-ubuntu2604-client-2.dev.fyre.ibm.com ([170.225.223.17])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-567a9f9115csm4244355b6e.11.2026.11.05.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:29:53 -0800 (PST)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] scsi: target: rd: Use memset_page() instead of kmap()
Date: Thu,  5 Nov 2026 04:29:47 -0800
Message-ID: <20261105122947.2727448-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The use of kmap() has been deprecated in favor of kmap_local_page() or
higher-level helpers.

In rd_allocate_sgl_table(), the mapping is short-lived and strictly
local to the current thread. Replace the open-coded kmap(), memset(),
and kunmap() sequence with memset_page() and remove the unused pointer
variable 'p'.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 drivers/target/target_core_rd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 092d9fe0d4e3..a8f214bd14ec 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -117,7 +117,6 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 				sizeof(struct scatterlist));
 	struct page *pg;
 	struct scatterlist *sg;
-	unsigned char *p;
 
 	while (total_sg_needed) {
 		unsigned int chain_entry = 0;
@@ -158,9 +157,7 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;
 
-			p = kmap(pg);
-			memset(p, init_payload, PAGE_SIZE);
-			kunmap(pg);
+			memset_page(pg, 0, init_payload, PAGE_SIZE);
 		}
 
 		page_offset += sg_per_table;
-- 
2.53.0

