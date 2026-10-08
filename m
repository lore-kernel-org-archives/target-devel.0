Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940335C692
	for <target-devel@vger.kernel.org>; Thu,  8 Oct 2026 23:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503663; cv=none; b=sgYRZy3FBKyajsZ9jI6lZwE+8XRD1fTpy8WWTHl7cqYMu2ZzjS2LCxDkOj9ysWCKUej4iYktbbCY/ln6uZSMhHIOOuwE/m92FKMdbCQpYToFG8HJ7h/N7Y0nF4K9gulblYi2f2CNQFbf0n+V46pacPYG2wIYQ5zlfb99yxfweA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503663; c=relaxed/simple;
	bh=u3mdpHm63NMciZUxyZb2tyyjBHYBnsglAuR31W/GzJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6Rgo0DfujSgV94XZwGLhQPixcNEsqU9BpjU/rhu0S/Ug8gDmyg8HcdBWcxmgjtZmKaBDUBbXJ1jn4qTAwMzivYe019N3hGQId2YPP0ahEtgnzWcMqZhszVOkvH5Q+DxXkaFvOebiomrjF7Ztf4W+G/SCoQOjCLm45VmR6htSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VngPppVk; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VngPppVk"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5337ed8329cso3684591cf.2
        for <target-devel@vger.kernel.org>; Thu, 08 Oct 2026 16:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503661; x=1792108461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wogysuar2t6CIwSyb2S0JLKktNfZleR32/9OzbUkzlE=;
        b=VngPppVkXb2mu5RKY4vYhCsw6dDqNb728+i98WsmGyE5Zeemvaa4dRJZObWBjWru6O
         jhrInJu9iMOGjcyeXdGOukwXMnBONeaJf8JYIgFIblfg3JeiCtLZG6tUPrfqfJVaht1W
         BsDf8t+NBCpfFphT5rDmDkTdSwkGsuHRi5u3AN5EIsbdjrdMZCRTWdsbTCPgnXnNw3l/
         nrS88FBYiBchVWrZsNid1tEim+qudTANn0QyUbYMuRX1nVYiCC0vY6tLNfgqHQGkij1U
         OiDUBl+aqTQiS+uU5JcmzDeD8kIXRg/yMT1dnFV+DX2i14PN2rqIQ1moQSJjjgzq8sDD
         +UIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503661; x=1792108461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wogysuar2t6CIwSyb2S0JLKktNfZleR32/9OzbUkzlE=;
        b=HF7H7ZF5ZH+MMSeMsWWGfoyb7OsQb0mqsb/3Q3pxU5EGV1U7KFwPqQ0m+FygoKWyLf
         vKk6BNgUEQmgAttnXG0DKk+TctMeyw15jxEYSe29KpvivodOvE7KZ+3IHEtmGZG8RVqN
         HZPvdVPqyC1xgyKLsC8kcHvbsm+uQn1pM3RO8gP30gRpoKCUd1pCY+1v1ThDyKcoItAI
         xwnfrROQO9WI0B7lmoR2Kg0hKDrjKJTrrLJyQlsgxynLqI6yVNKq5BarnVYDVhbE9Vav
         ezOqXwNno6FvSRzuMwcsskglUnRNkc6NFI7ofghldTUBMT8ZoBUmqxg4GIIzBbKgtd3N
         eq7g==
X-Forwarded-Encrypted: i=1; AKwUvBxhabT9nzg5HIDyO0rXXaoK9s9u5e98EbBZzu441nhaLHcJP1TWYQ3QMXKdkBGVU5yweoEbY+ir7SYnHf0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJzZFomvn2EG0zvBUIyuPsLy5Hy07HZ19d4MGA6eH9jmpmKO0/h
	HP7sTG2S5m1w/DXehjJgSKghGG8+AkQ0BLTZnGjcaevzprNrn2/FTo5F
X-Gm-Gg: AYBFou01/D2ZczDvt3obBXXs1n3HGaLySBEot1i50t3zs9rTUeN/JJKQuFAnIHGJbzu
	zER6Rb5aKnSvYSpiHBU8oILaj3axv3OUcx4Jcge6neV4hYtVi3MOwuQqHXh1Dqz2lN0cP3iEoaA
	8ywl40U6Ffa8Z0pW8EpScZijk3VaquQ3kaqDscd9r5vKvzLw93S9jTEhn9A389AmFjoWKdTfOB5
	Rg2NsB5EsGOhhJzfgwSZasbHsSHh2tgUF26MDnujNmLNDPHjxbr0QENLYx9DEX84y9SZzTb+7TH
	eDpkC05IzsbX7HqyNZ4bACzvdZggyYtfgJidRKDgQ9t+liLqpjD+706dYa5wFz1KVDIQS36FU5c
	WZQsVW4eOTxPNraRrEX3VMKQWcRSDE8zKXOOtUK0pmLwqiYhmUqTJ9u0bNxPhMt+1nYUg5BJ/9M
	6HeiIhZnu2Xqn2OkCgXhc1hfqn59qctyfd/36MsM9rgl5Yd7UL2Up2Tn90ysLFuOZbOXztTAEdM
	66VAbqa2ztuSRKaYmjUnFTpzxfPrS3vE8dlT1VYmdAvSwUVamo10mVCf6ET8YdkICZJvRq26ffq
	F+O/CiL1VBNhOIe/4Tw=
X-Received: by 2002:a05:6214:4118:b0:919:847e:ccb8 with SMTP id 6a1803df08f44-91b55345787mr7524496d6.1.1791503661318;
        Thu, 08 Oct 2026 16:54:21 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:20 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 3/3] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 19:54:09 -0400
Message-ID: <20261008235411.56641-4-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008235411.56641-1-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

rd_allocate_sgl_table() allocates the ramdisk's backing memory one page
at a time with GFP_KERNEL. When the requested ramdisk is larger than the
memory that can be freed, these allocations do not fail but invoke the
OOM killer instead. The pages are not charged to any task, so the OOM
killer keeps killing unrelated processes, and may panic the system once
nothing is left to kill, while the configfs write continues allocating.

Use __GFP_RETRY_MAYFAIL so that the allocation fails once reclaim can
make no more progress. rd_allocate_sgl_table() already handles failure
by returning -ENOMEM, and the caller then releases the pages allocated
so far. Add __GFP_NOWARN since the driver logs its own error.

Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index b73bdd733..7c53d8a72 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+					 __GFP_NOWARN, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.48.1

