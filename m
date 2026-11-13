Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559227;
	b=2xQ6+Vdl8iQqoxDc7ByuKD1xFwKIpuKEe/2puqS09CJAsLWWZrJXJYnvaSN7eGD0MEEN
	 EiARBwpGJXAPKKa0OHYTm7e4VsX22if6Sr16RNvYYMlAFcxVMaQAFcMoxaHY1WfVU3/ey
	 1qjb5fP65PiHecTjsCGvIN3+y5VutzMEYFDha6+wKz+4yfz9YfGZU74Bp6SFbuRe1NgS/
	 Ojz5W7PEiVlwa9I+1lwp9qaNdSulp1KPS4OBHkfIOAg9NvLi6W81IbahS1awmJ11NItEF
	 XY7eIthWaZrlipekeEby/+3QyYfT113ROxn5Kc2b1s3txdQBrKF/E6is0PdlX9U1Sdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
	b=GHWUvuOBc0B1OT5eyIia3z8rGS+tnqZJCTW630wegQ7Q/HiBto7/I08q05YCuSs1AaZI
	 amOIACWB61wFzt7cijVbqiQlKVJm9q4T+nThCY/O5epdAAZbDqTkd4niA1wF/5Ea78qU1
	 CETj7qMQ0P2xY22smVrEo6Y/yC2gxmGyvHUSb3k6PQ6nIfGxHJS//OmfBTjJsLfXtoGkq
	 3B3R1na56vcj5H8fZVOkAb3kxpK1uJB81wywBwpCaJH2bQtage36I9MNbGQm4F6wxI0QW
	 KDXjxaXkeNGJ/xKk8uZqY3mEW3NwVYuKN8YziMsuhT/pW5hrt+obVpalEY39ItyUolQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B9606A8A1
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 08:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B47B9606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WMW3oCUZ
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso255541a91.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 00:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559226; x=1795164026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=WMW3oCUZ/rAbrvlxycYpeBLVSzfh2TLgjVIcTTWk0wKtre5oqsAU4oz9pcN6quLYki
         EU/bMMfcvEgcttMb9KZqWf3fu9f5+JyBdDUffJwHcSWVoQzx4x4aibqf2XX2cuWGlEVN
         jHg+RH+23I1Hwne/9x6ygIJUDwWrX8IAll0CKyXc4bjsaWYGh/v4cEvlblf11+PRq4TG
         aOQ3JKy/k+k1L3Jfm5IxA1OIUtrFHzONFmzEA8ZZs40hWUFED4kxkbdRsSNOkGpv+/aP
         ve2h2AkSK1xNt6f7GxVjbdv/44T9tB5GaQHXLjsduAhQNcgbD9fUH+finDFVkUy23xTR
         B7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559226; x=1795164026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0nrv620IQZ/22wegrLOV31hxsjt1XF7G7GYY2hu98s=;
        b=hURykWzzN2TsbyB5s0f1M7H1sQAZA14DnDZRutKEJlDoK3pBQEhUMZcaZRyrwMsYUv
         urF16zuHFmVRVbc+QX1vplZkheNNE6wXdt1BlgmrrazSeOLVMhoMKvgqG3ITwvUzdCOx
         6zF+uvX8Uhvm7A1hC7Q3qZLJw0K2SqUXg1noCmDXRNxMt9JA9fyP/UHQfl7q5XgS0IqK
         WwU6HcktMVDMDMX6545k6lPmSZHsIe0DyJCNyrQhYkGUB9EBjLeKRMNzkw0jNUbXAnxf
         N+lrczwU7iuI5AIg4TUyJiaNRUojA95PJWXyWqT/9tq2b0hNHOLG+U/Hl7jbwCGbzCbP
         xylA==
X-Forwarded-Encrypted: i=1; AL+hErGQvxd6Niu0NSHZCGmW7eugSeKwGIDWJfVvMd1fZlUXi3U9xx/Wapk0i10rlPUdMCCKR0pL+m+kq/anYMI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8J26imq2HroGMxbhFuoyrQbSllpBELOcKgsBIGkB6ZR1Ojv4rR
	DmrF0+hzbMHH2RA409BqICJwLahWZ+cI+KflQaE6W71mi+/LJsfwKqOo
X-Gm-Gg: AYBFou0By8bcFgh+g9zVVKNnwKc4d2oWns2PmIKzH3YzXdH5M7TvBiPiLQedvmKKSM6
	lXbbsWtY/1oFb6APMJY5R0xkvyNG+GVS6CHxhAnVGOIEpD0h223lc1V5XszwjmXvhM0p45t0kz4
	qKh3zLIejkdJ1o7fiYbgYacODOhFBPe2Nhu8utufVeyKuiml/4+E1lCIp9crVn85lBWgPSYzsM7
	2lJjDotu2GmcNxJqZsTuDdckK8DUrDTldeWhmxQgLTI9bl5D+3mGg7/f/Fm/v/9nqbGDX5ZPyQs
	XWCCKKtEkSa3vld+5ewR4Vm8giebTaLgcGx9aNap8f17SD03vdbqqaflrVdFHS/od4LB+BuGG3k
	M8lbzVcNqnLkcoCTO8TRyR0Ql+GWbpSu3OJoTvbXwBIQUNBp2itihPI3vCYUHkjkVHw8nOExX+O
	eTC8q2yRhi+uY7hEUsqIz3pXGjbjwrJS/NfdEb+GHkYj9nhYNtqkDROkVKJzBf9ZvUKrHd2PxXK
	gghWPZBI1KYQJA4H+U6BChvNDmAvD0rOtuFymNS82p4D3R66TzFD/DXuLiXqpS+YY6EoSsCGWS/
	Q8iR8Q8qNJf04xux9GbHHm7vxBUUXOGMMj5pvp1fYA==
X-Received: by 2002:a17:90b:4acb:b0:3ad:6090:a189 with SMTP id 98e67ed59e1d1-3b1b0b67b18mr1705922a91.45.1794559226059;
        Fri, 13 Nov 2026 00:40:26 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:25 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 1/3] RDMA/srpt: Initialize commands before returning BUSY
Date: Fri, 13 Nov 2026 16:38:40 +0800
Message-ID: <20261113083848.1517595-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

srpt_get_send_ioctx() clears ioctx->cmd, but descriptor parsing can fail
before target_init_cmd() is called. The error path then calls
target_send_busy(), which dereferences the NULL cmd->se_tfo pointer.
A remote initiator can trigger this by submitting a command with an
invalid descriptor table.

Initialize the command before sending BUSY on descriptor parsing errors.
Do not request an acknowledgment reference since the command will not
be submitted to target core.

Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
Cc: stable@vger.kernel.org
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..127f256c6e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1597,6 +1597,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 			       srp_cmd->tag);
 		}
+		/*
+		 * Even on -ESHUTDOWN, target_init_cmd() initializes the command
+		 * so it can be completed with BUSY without core submission.
+		 */
+		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+				scsilun_to_int(&srp_cmd->lun), 0,
+				cmd->sam_task_attr, dir, 0);
 		goto busy;
 	}
 
-- 
2.43.0

