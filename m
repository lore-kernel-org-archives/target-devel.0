Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E343B314A84
	for <target-devel@vger.kernel.org>; Mon,  4 May 2026 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777881907; cv=none; b=gqUq+xQIiPsLChfMlFBndeAyXbyOJGmNw8/SLfhm0PT4ZcdoifHNUZgIdtrVJUc4/Kq6ESW2FYaB3Goqm+Pei+MVYFOnaCG4U+daODudpeDzLQ8JXAruS93NKZ+zAO9ryGRF0ag9M6dIHhu2v8Es9/hpXMUKLGNZDiZTLMnctuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777881907; c=relaxed/simple;
	bh=TzBZ5d6t1avGrBuVqX8j20XzTnEYIlJHq0BqR6MK4pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bY5u57Ke1qmwHYYXqyIZO0/su20S8c3cZ2GxXrYBFrtOigwYeH+/yt3nvuppcYou2qssa7PFEwaMsYfP7H1cpmdFqrJTP+qsCQUE5kFM5RhU5Ar3HhqmI2t5ObdF0W9M7elYOGd2BpdwRw62qNY1tH/tgPbEOMyBQPzT0NPI1sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2Lyx1Si; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2Lyx1Si"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c15849aa2cso4911282eec.0
        for <target-devel@vger.kernel.org>; Mon, 04 May 2026 01:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777881904; x=1778486704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XshvABmAm/1LOdjBec6SaTsaXNuMFtJtTQSgJo3OP2A=;
        b=h2Lyx1Si1enFDnEWAkgiv3e9AXqgOlf4NWoW1COPaQeXQWccm/jv925EaGS4ZAPYl1
         zKQLZRjF4qZmQd0ZLa7B+KciLztcpj4STF23sY2xguaHyLDxHnwDvkERk4HxtXfx+pxN
         VWFJF5/4gqcA0Qbztrl8yP8PESnQ24x3prVKwNq1wbjsVi+59jb7DKzSVCE5DbNaZ7Hx
         UIyFhaPr5dzSQS5rTUrK6m4oiDGa/pt69M2fvwgzuMdDEQNSvB5RDPA6l9rUMJwZAg6W
         VFqV3+xn2HX7RmFQzPyZO8rKXSASVNqsWHfjViJCcd0z8B9TEGqZHrxqNjolFaOP0+Dl
         z78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777881904; x=1778486704;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XshvABmAm/1LOdjBec6SaTsaXNuMFtJtTQSgJo3OP2A=;
        b=nNLpj5c+CUebfAGwTL4wzYPxYz62ETLXusFFJ6HBnSALzKQymi+8N4yqHAc5FGw2DS
         +ntGb7uSzAwURh7J6sMEjlaRWNe0fj2VmhyX+Dc1NGyEu2GVKCDXt1p+VR52/TGnaTxQ
         5nW0yHzYDNw7sJg7SiccZITOyNeZueGv9o/zr/5btJzTb5r92wuUNvAvwiCVoWhlOdKl
         lrCIqyXpVBoLzJ0hlUSgCVVDgRVmnhCpZopoEByGdAytpADU/OqA6ehf5KywoEHc9nqP
         ARZ/NNBIkAKFlsQzEZ/3Uqg+KyFRjO3RvGMqUUk7Pc48XNw6XKtRZdLljveZfYRNeyez
         xneg==
X-Forwarded-Encrypted: i=1; AFNElJ+yXjITIybJ4Yhtl6/QD0q7pkGpPiptFc6khDmkUKsjoASJs9BXfp702mAE0a1zgJ2MU8DXt9Y9ndYS494=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQYoXxwQa6wQYC4rveuWTYEQD9HAUBkkc4M2n8ndwl5slXsDUr
	LajSK7RBZNml1kUkhSfYY7yj3MOQiKkXrA2rjZJ02d9kXfNJKDsFDR8=
X-Gm-Gg: AeBDieu63+GTUfor3uorPe/oQ1PmkpvaagZxQJiBEvborE0UW4yBT3xWwsk7EBTf2SO
	2z6KdGmPtw2NYSBWW/GjQgRO0hkWRz0U2J43jfTegADQmZgdIzBprtjPztmWiTWaQAJHwQGuObc
	wBd4XJPI+w4W4OrsQmo2DxQpI8IwpOW7H/cMGpnZYOmGv9i9YfQtMT9LkKgKBWocmVR2VsiXEok
	iEPfOr1sV7djeu6L43pY3KihbQBzBxSQ0GfIMyt62RJD36YhTUKT5ZW9rY8XsjoYPWygIt923Qb
	SjveyYUM7JaHo7xPbYOMvmYuz2iFR5E73y5PDW4d9Tylp1q8am58rg7vGtUxS+7HNNASsVjrO3/
	+vb4p9yGm7Whp8vEr0T0x8G+rh5cU/Po/VMXc79NbrUQKaaJri9eIXiqZzrfCfTI4PKr0h/Yiqz
	qZM3zqvLBave27Kvz6Tdg/+0FOSg9ivif6dePCbX1AepzjsIN55iZ7rDTeic8WqtsLkDS/V7NY
X-Received: by 2002:a05:7301:e25:b0:2ed:e14:42e5 with SMTP id 5a478bee46e88-2efba4a8667mr3520504eec.30.1777881903908;
        Mon, 04 May 2026 01:05:03 -0700 (PDT)
Received: from A02816.. (c-73-71-102-182.hsd1.ca.comcast.net. [73.71.102.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee38d78391sm20198312eec.7.2026.05.04.01.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 01:05:03 -0700 (PDT)
From: Sara Venkatesh <sarajvenkatesh@gmail.com>
To: bvanassche@acm.org,
	jgg@ziepe.ca
Cc: leon@kernel.org,
	dledford@redhat.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	carlos.bilbao@kernel.org,
	Sara Venkatesh <sarajvenkatesh@gmail.com>
Subject: [PATCH] RDMA/srpt: fix integer overflow in immediate data length check
Date: Mon,  4 May 2026 01:00:36 -0700
Message-ID: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

imm_buf->len is a user-controlled uint32_t received from the network.
Adding it to imm_data_offset without overflow checking allows a
malicious initiator to send len=0xFFFFFFFF, causing req_size to wrap
around to a small value, bypassing the bounds check, and subsequently
passing a ~4GB length to sg_init_one().

Use check_add_overflow() to detect wrapping before the comparison.

Fixes: 5dabcd0456d7 ("RDMA/srpt: Add support for immediate data")
Reported-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
Signed-off-by: Sara Venkatesh <sarajvenkatesh@gmail.com>
Reviewed-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9aec5d80117f..f66cfd70c263 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1129,9 +1129,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 		struct srp_imm_buf *imm_buf = srpt_get_desc_buf(srp_cmd);
 		void *data = (void *)srp_cmd + imm_data_offset;
 		uint32_t len = be32_to_cpu(imm_buf->len);
-		uint32_t req_size = imm_data_offset + len;
+		uint32_t req_size;
 
-		if (req_size > srp_max_req_size) {
+		if (check_add_overflow((uint32_t)imm_data_offset, len, &req_size) ||
+		    req_size > srp_max_req_size) {
 			pr_err("Immediate data (length %d + %d) exceeds request size %d\n",
 			       imm_data_offset, len, srp_max_req_size);
 			return -EINVAL;
-- 
2.43.0

