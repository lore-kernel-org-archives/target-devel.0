Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAF92E6CD8
	for <target-devel@vger.kernel.org>; Fri,  7 Nov 2025 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762522610; cv=none; b=qKuYdbvFqhQX0uokvgjitN/c8/clv9cKPE8BPovITqnIQ/BOE7ClKJBLapA1c7GHgkpIlz/Zwe9fnf0jp6wc12xmx8HW98MZwPy3rMGvEj3q5BMcSqrb34r2YVp6JGUtNUEsklwpdle0vcavMIe9rmPHriI4PHwcT7sAnQHxWn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762522610; c=relaxed/simple;
	bh=UZwswUwbvM3wAsUrhwZiZhYIMvbdcwWe0ZDflLX2Vw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FF48nC0J//oF1s0zUzVf51CbghOfclHGiCkVWeqSFPumgI20DUegs/MlaZSiQPl/mt8zxodYZKx1GMC7NTrEhzYdqj2eu1kh2Ns8vwNrH0dCkbjcjgz1KtTHIxmIjE1sZ34vIdJ7cDE6Vcf2QoUbzQyBS/9IfFNIcsEKJxLgQpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OyMIxDJ+; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OyMIxDJ+"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-471191ac79dso8505195e9.3
        for <target-devel@vger.kernel.org>; Fri, 07 Nov 2025 05:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762522607; x=1763127407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JobActy8Q1tKHJAQkXK8C2eUozNLqX92f26Y3cDZo6s=;
        b=OyMIxDJ+4EyK/M9wQWycM/4cg3QY0YOWqYQIOr5kNlwN+MdSL/p9nPUCcLqDvS0/f5
         HhIiXg6DPyCCZzEn6mX+WP3BYpYhnoSJSFcuVEpNd26g2qQuU7tpr8XjQDp9kqIc7Tkd
         EsmN/obX9YoB0AdgrLpbQYgAyDEmH0Xl+qZDvExcw7aSnZlN1Sa6y4nyxcqJFI5aJbzS
         BfTMwTar4p6cu3RlSvaAsUrsp4PgdzA2wM0vDbQqtP/K/Va/2SfLPtfo9DxgeGsvjbcG
         v1MWgx8x+KrVI+aXTHr4GbzpdPCuurOBXBUJYlTEf0KyztNLnTI5lNMxvmpb71TXgUIt
         U3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762522607; x=1763127407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JobActy8Q1tKHJAQkXK8C2eUozNLqX92f26Y3cDZo6s=;
        b=ohKWgUf+q3MzLAfqJfQdzTH0uPOSyDgGDkT5Pn9N7+ZrgiAfNvMJErxqj3cl7Z1n4E
         nO2TypNlg8Q5he+WqIWSeySTFygRuzFIejOq1TIdnocbhtPB5R+rp0sq5IPNH/4v4hCS
         fu54dRKR7rs7VGng9fObYKpMYfDniIBVnaWIMUWLqIV+kUl65bu3VwfeE7T9AMObUXO5
         nVjOGbkogNSvccg6bAxbaP1U3okSu1x51VdGStlPoTUl6Mm5cfxLja6kKOphnypVW4it
         Q42gWEwpS1Ka0Dvmt+9jcuqjt/PIwpzQDUw5+cTJh5lAOM9NLzdhGd7EZsq7w7gu/1Oj
         cg3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuWI9xHfwu3icRBgp94+cq595GlnWTxkxkpoLFDe8LUbCkmghuDb4MY42v+dh9YuDbpVnkmynJRry96EE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywA2BayU4L5OdR5aEa1Iu83zk/k4k7R+hIUokCa6c8japUUKzZ
	cuGxhZAn/GLRowpUTHQAs1PTQees9ggDplZ0/6L/i56hhNMw619m4+pz+4ilXXib0Lo=
X-Gm-Gg: ASbGncsq296YaWwC7K+td4noDKaslpl6RHXbmdw+3/415xDBz9zR50Sejp8zULBaQPh
	Bv7CTHPXPLCTjXutIecIqnw0rB8Ol9xZN5BxaEq52BtYXZAxReoqNk1KRFik6Wu0OTnbh6PPURx
	e0Mhu36gPTy5j7yJtJJU6hWG12iqwnZiHftj6I/ZOsrGZSz6ZHgWaqrpZkMYkMm9G8V78Ux2240
	efg8cDf8Jt0H3VMs/GQIHeqlrES9vgauePVQJLZR8sgKI/QLjvTRDqG4rxAof8uVC1/ViEENBoR
	ptbAy01STOls81enz3tt91lLJPJijNRewxH+oF1cloHVDyDeH1G4cbK4rZJzlVWqyLc75FotGtt
	vx/6rWPxIpe/gltY58XXnrIzoVYJ3IzVgyfpxU0dW/ib2yOocT/ggNDDD0QJ+sku7oIE+G01zBY
	az7GgXZ2/bQG7ryYS2WJYmpr90
X-Google-Smtp-Source: AGHT+IHigxOt7e+EuY57cRMkA4R3lmI1I5oqR9eg08rBEkmbJ647xE77iJ/O9h1VcgnOpYFGx9jYAQ==
X-Received: by 2002:a05:600c:4fcb:b0:477:59e8:507d with SMTP id 5b1f17b1804b1-4776bcc537amr26494345e9.31.1762522606742;
        Fri, 07 Nov 2025 05:36:46 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763e4d7f2sm40627915e9.4.2025.11.07.05.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 05:36:46 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] IB/isert: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 14:36:26 +0100
Message-ID: <20251107133626.190952-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 42977a5326ee..af811d060cc8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2613,7 +2613,7 @@ static struct iscsit_transport iser_target_transport = {
 
 static int __init isert_init(void)
 {
-	isert_login_wq = alloc_workqueue("isert_login_wq", 0, 0);
+	isert_login_wq = alloc_workqueue("isert_login_wq", WQ_PERCPU, 0);
 	if (!isert_login_wq) {
 		isert_err("Unable to allocate isert_login_wq\n");
 		return -ENOMEM;
-- 
2.51.1

