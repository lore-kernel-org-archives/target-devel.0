Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646EE4570F5
	for <target-devel@vger.kernel.org>; Tue,  4 Aug 2026 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879433; cv=none; b=ud3QbqeQmDmPwdGFnM/2ODoooc3irIN8eFh+k5rjXL51cqdHmq92GJ/QyuoZIEZz3Tn++GwHYBBjgAD+ydLd1DLM1D8Rz7NO/HIag1sQKOrvgF9jIdBk4cd5M102yqrSCAOl01hF19kun7z/r67GSYbzGzmW2TaGMkT/iNiSESI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879433; c=relaxed/simple;
	bh=EojRtJx11W5xlguZUK4s5OiYfzm/jUFXVb7sX9hq9PE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dMpHt5QgDOZMZIxoh2bPeXnZE0JBOb+C/67ca3pE3LNhBreTxtgaTUvpfn7RPv1rDgYys2D47fJXqxlH8yqxCypwPAxDLaEcJgDGEeddhIT6MPgCbIvRcrYTCL/CAy4F05LqnHGpW7pqhJKm3nWINwxLv1ZSOTkR7UJc7ZO75WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rtFC8i+i; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rtFC8i+i"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caed617615so4728705ad.3
        for <target-devel@vger.kernel.org>; Tue, 04 Aug 2026 14:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785879432; x=1786484232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+wiL1g37iz3L+Oh1WFh/qb02WbdA5XTOtdYfs+Nou8=;
        b=rtFC8i+imWIcK/Bf3jTHIti4mE5qdwFjcIgyZaxH2OYWK98I5Mup2NvVA41LNAAYDD
         a2+deYmWeeDDS550BwmcgrZ/s/pLMLyOzoiy4bW+9fH5HGR1rxgsitFAqYx/sE65EZ+3
         y4gBu2fugFC2HxNs2WA4m3m4uIPIwo1DKRbezpUNBaUKpqsd5slGkPYxhemz28cgsZJr
         evN4QRW+lIEfN8KRMy4AeDC69AsaF4BKdqc/7Hy7kXFb4Mlq6Cq8kyyEICyL2BpzF7C0
         5oke3Z4LZxm/Pgzf6xOgipsdZjeGELcE5niCNljwoO3QAEh/rqhNe3pG/Bfq8KdXsgGG
         4M0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879432; x=1786484232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i+wiL1g37iz3L+Oh1WFh/qb02WbdA5XTOtdYfs+Nou8=;
        b=odLAuyRjyV0jm3pwnPR1Tpw7UQ3UlMm1fxY4siK7QGQgCYC3JRTKFXGtuEFsASfj31
         gW7mXPIKy9S0BA1z5dKIXnPfpk4GJqDKASEGCQDYCSGf5fjtXlrvpohJlfc93OTq66ak
         aCeWA1pPKCvNLxtB2+BrY3Y/N+9DjlluiYHzzIpYz1HxVa7AN+4/6ok7kik0E6RaHtCu
         REzhnP7fdb7jLhMX53fjpN8lPCQ/MVPh+kYgfn6CPj1hjXjERhYQK+sj9S+OOXhfp708
         rxLz3rK2o7CDm+xpvYaTRduAwZD1t7k+k6MM20S/TBlSCp+34gewTHgD/uBLF0O5fv0G
         wKjg==
X-Forwarded-Encrypted: i=1; AHgh+RoKou/Bd+8DyTr40ETAWjawd/KD04YQxn6+PX21we24enYJMZkMrQKbAVgSRoIzBVss1Mx+K0MBhLhbeTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs5xsG0YTiD4i7SZ2b1o1CquMp6DsegmQZyTzL6ZACQlIUYTH4
	3HH2N8ade98cd1taYudqnw3vGA/8Uwl5E1RhYDuoybJ7eJ5J7SdnTzfC
X-Gm-Gg: AR+sD11MA0OV06Y/nDdqWHzRlIGmjqAQnwDodk0C+tikGQ1d2kZVaXIgtmAyeBXcYiW
	fTmT3K1jUN9/oUFqxs1p9sWgjkB+5+lswoeIc36Z1M30Wi67V8Kkbgy2RBzTTy7RIJhSjX0DD1G
	LhHsxuNQ/T3DDbV5WmZqLDycuYLjrRfbRpxFRtqHH3AcOVna41q1PhLqhxt6CMsFXMN0kYSyMWZ
	isbBbhiSlPbwxB7z5YkyU/owdGAiUqTF+cWv+w3GoweSERvNwQQW0h8nux+BtDW+thqtFBfT33r
	JKfGghMbJ52pa207mnGQHuR/Us0YhSYLOKKmj8kwfzHB6lT8jCM1TGTVky3A2ZV+bhTUYn6i8HI
	/Ks0NkX+e8/fJ69WXGTYTy8/ayT816NshSvg/wi7OYRWks2magzL2iCetEtkuB78LsD2aMNe1Bn
	xEGi2XE3JhL2F+y6DFg8sRgK3vNM11t/bqh2kRYrREZGO55JRrzYrUyPXqt/Gst645pCeJE2Y9j
	Eg8P6mrdeo0ZCxqcDxn9VILR0IhNZYC3AqsBS3Mhjs=
X-Received: by 2002:a05:6a21:329c:b0:3c3:8315:80b7 with SMTP id adf61e73a8af0-3cb85e9757amr1738601637.9.1785879431707;
        Tue, 04 Aug 2026 14:37:11 -0700 (PDT)
Received: from LAPTOP-DPAKMOI4.it.purdue.edu (pal-210-106-74.itap.purdue.edu. [128.210.106.74])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca8df89asm13408224c88.9.2026.08.04.14.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:37:11 -0700 (PDT)
From: Yifei Gao <gyf161023@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-kernel@vger.kernel.org,
	Yifei Gao <gyf161023@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: tcm_fc: use kref_get_unless_zero() in ft_sess_get()
Date: Tue,  4 Aug 2026 21:37:02 +0000
Message-ID: <20260804213703.3411166-1-gyf161023@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ft_sess_get() walks the RCU-protected session hash under rcu_read_lock()
and takes a plain kref_get() on a matching session. Session teardown does
hlist_del_rcu() and then drops ft_lport_lock before the final
ft_sess_put() -> kfree_rcu(). A reader that is preempted between the
port_id comparison and the kref_get() can therefore revive a session whose
refcount has already dropped to zero and is pending free, leading to a
use-after-free and a double target_remove_session().

Use kref_get_unless_zero() and treat a zero refcount as "not found",
matching the standard pattern for RCU lookups that race with kref-based
teardown.

Fixes: 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target (TCM - target core) support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 797be06ab71b..1bc7d2dcbea3 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -172,7 +172,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	head = &tport->hash[ft_sess_hash(port_id)];
 	hlist_for_each_entry_rcu(sess, head, hash) {
 		if (sess->port_id == port_id) {
-			kref_get(&sess->kref);
+			if (!kref_get_unless_zero(&sess->kref))
+				break;
 			rcu_read_unlock();
 			TFC_SESS_DBG(lport, "port_id %x found %p\n",
 				     port_id, sess);
-- 
2.43.0

