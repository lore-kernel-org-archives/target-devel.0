Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7753C49CF22
	for <target-devel@vger.kernel.org>; Tue, 15 Sep 2026 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476967; cv=pass; b=KzB3v2BpNKCsWzxYQaMjwL5Y3TcrPL5TgwmdGGHisWncJ81TBtsWjusx0jPXr6syfD/tlcBUbYwaN/BcskEg4DJssBgpeohuP5coQF+TWe19vJYR9dntxVEWK20XbsnOucfzG5idmN6gUXdrFvnbLkhLFNocbnnpKl0a3y/yZM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476967; c=relaxed/simple;
	bh=JfTyVkhgxfL/z3btfG+skDMTPgV8u01NEtVFVAGhNFY=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=cBY8bNPSeo0sQ/UfaBp4BR3Ze6oWVbF4X94IwOMoyfc36tiPwku9JPSywUAMuV579ws5nWoNVZttdh0jxlxchc8f/N+9wxNzcsGrvAdsogNgqsOHyViFavIflRVFnckG5039L/wTVtUXyZS3prwhtQ/mCdVUxQM29UUNaOQwzXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KV/W6BZl; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KV/W6BZl"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633cd80so1402775f8f.2
        for <target-devel@vger.kernel.org>; Tue, 15 Sep 2026 05:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789476964; cv=none;
        d=google.com; s=arc-20260327;
        b=khbao5x9AIwTS04EAFv/VeyWvnmRUFo5ZRWMjJJmrOyaViravtrC+1iQpA88bIiB0j
         lrKMmTSth2RYOynoECzq8pK9kl8JyL0oDklYIOxHC+VAFH7EXQ5S2ST2M21dzzsJHKdh
         OZAo7I+quBnEn/91nQixloAKqtTOPAZiihiTWbWqSJ2yMxD9QGDDpJBYzfH3igZUfXmc
         TcwhOAkUkzZJGb7gQQJUBZAvnzIxlV7bGhTczhs2kTQAJxFhnkUhQ7c7nPIWRJynZ3cf
         NyfAoIdMHtonkgK3aVLXsgXa+0+4g/64fMiCwTXaHZHAEINwp2Yxfwokr34bvTmezru8
         6/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        fh=MEQRVdDdcWKiu7rR3nsaJMZxqn4HY+3AqUqssHsrC60=;
        b=EMzGio2otL2/yrLXJDzqSEcjvguozSsQleF/LZCkpcOeX2ItDCybuYbT4i7uNOHtkq
         Q2g2qDLY7uHpo1VhlZDjW4cV7wLIQ95nvxjYTzyG563F8DEveAdd9Mqcuj9zhjgR7Dm5
         oFhorTSPPKj4ahe9lFqucJ+Dto2ad9wTwGykLhWj02Dc/N1DculpSr8ztbaUPZpoKBap
         fbLk7lMOarrATvHVn9aHXy3vRp7py0qD1LPYOYvWHb9vtmrbC3wuIlOookW09TXBx/l5
         TVk1JYj6P3AmE4ap1nZbQL6F3fSbfLPLTuKAmGybriDIdmj/l4PLQu00uaYKjyamyUzt
         2jLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476964; x=1790081764; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        b=KV/W6BZlaWfxPIWRy8/w5MnwWbiLLrEAMOUo/U2Ozk0tMT1TGQV4bOPCaeEiFdBmU9
         XJzY2GW6VJCg7COFGXnavGInXEfigZdQNR5n8bgMTKPRqjyx5bTPl0S4EEvHQhzNnApM
         ygNomLtcNaljuxBSd0afEHfJtHIzTpl7R2q+2K+GPmigxpfjn7NCg4JbjqS4lmg/RZMf
         Km/ta++MuByFeTEYoBeTWxnEJ84DhZBWEmZazXIA/8aK1aZy7r+1y1vu9rzMD/fZSY+y
         qyPTEWEz+LbhnqvW2LT+2PZRr5xC+7Hg7n3hpwQHe9Ml5Hjo1ElHfqda9qlXEHvKQe6h
         S3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476964; x=1790081764;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        b=vAw03unezg1Wh2tubwc/0LMRsWdg7TT/Uq1MyS+4UnUMTRaQCCbIyuEEcy4z8PvOqE
         DOKGg52I3LNGVpYAGrdONavpmTvZmb5AbV8eTYV//X2kozYupCde3qqJppoq+ysyDmJ8
         yRwf6GOjC2Ov8Z6sT4RaVnxEz3v9eBXSCTuWxwnqR9oUCJka3XE+7v/o0X9IuLgaSt2R
         /U0rAqAcAk+wv9vMZvxAZ4QX+NSeaF/IwzeeSdQSQg2vGr/e5WzH8GmT/urKxDH1PgQY
         y2mzQmttZYSPStODUd/exu0AY4DRPU1TLkdEFepY1SNwzhr9ndGa0cwDLkYDPkPELoEE
         D3wA==
X-Forwarded-Encrypted: i=1; AKwUvBxmlkm1sP6pKxsRS2kHZVXVQpdad4dFJyjgpVyu1URizbY2sj2zWL3/6VJBfNpgF+97U7ngE8dgoQ8Tl98=@vger.kernel.org
X-Gm-Message-State: AFuF++lEu6RAvfig7tenycNLkXrQAfh1apHwndGKJ+hyDuu5C1k02xlR
	mcQjSYw9+ezNJYnbDP2e6gzVIHeAuwDXrwVOhsBKgzb0HaxOMB99hgabEBBbZCzwEmV8Kt5k8ag
	+zSBmZWZdlDh/3I/kIH7h18C5QkJkej4=
X-Gm-Gg: AYBFou0id1bEylRQDdFoFeJ+LN3UzKvywbsr0pa7NPVNqwMlc4lM+wPw1qs27y2O0fR
	2bjfiwBEG23pzWCGzCUpgy62CL1wgBfsRRM5nejvA6Dq00GBJXQTdZ67hHtberRV/n537tR3Lxg
	N+COYNjDdT76XE4fZNiKwjKe8Hhm2AEoKfLJlknEfrKYpGBkJi5DjhwMT1UXoxnhBlmXHAZpkd9
	A2SBBp6WLHyMGnpGJgGX7JMiGWaviCKByPvlGhUIAZa3nJRI9eHnIZ/6CBfTlvv2FcOis0p3YNP
	CxUJ02TZBfAdU2fu6+indB0keyFO5bj7VdWtfPeLZ0/4U1hehwAHoQ==
X-Received: by 2002:a05:6000:41c3:b0:482:eadd:174a with SMTP id
 ffacd0b85a97d-48702b069c8mr8066975f8f.17.1789476963553; Tue, 15 Sep 2026
 05:56:03 -0700 (PDT)
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
From: Ruslan Vagner <rusya92266@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 15 Sep 2026 05:56:01 -0700
X-Gm-Features: AcwNN1XPkprRgPh4CCydpSfrhYjielBopryX2EyTiUwM2QPK4PU6u57OE0y3iWo
Message-ID: <CAF9RqJ6Yk1K5Fj8BHSCXQeTL3uMp8pyPrfmP_tnKkiT=09EUFA@mail.gmail.com>
Subject: [PATCH] scsi: qla2xxx, iscsi_target: fix comment typos
To: linux-scsi@vger.kernel.org
Cc: mkp@kernel.org, target-devel@vger.kernel.org, 
	Ruslan Vagner <rusya92266@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Fix the spelling in comments. No functional change.

Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.c   | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  | 2 +-
 drivers/target/iscsi/iscsi_target.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c
b/drivers/scsi/qla2xxx/qla_target.c
index 53a505df8da0..e25c05b5655d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1953,7 +1953,7 @@ static void qlt_24xx_retry_term_exchange(struct
scsi_qla_host *vha,
 }

 /* drop cmds for the given lun
- * XXX only looks for cmds on the port through which lun reset was recieved
+ * XXX only looks for cmds on the port through which lun reset was received
  * XXX does not go through the list of other port (which may have cmds
  *     for the same lun)
  */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3be23ed067e6..fb26cd1b6383 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1439,7 +1439,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		return -EINVAL;
 	}
 	/*
-	 * Format the FCP Initiator port_name into colon seperated values to
+	 * Format the FCP Initiator port_name into colon separated values to
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
diff --git a/drivers/target/iscsi/iscsi_target.c
b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e7..bbdce7d80d6e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4547,7 +4547,7 @@ static void iscsit_logout_post_handler_closesession(
 	/*
 	 * Traditional iscsi/tcp will invoke this logic from TX thread
 	 * context during session logout, so clear tx_thread_active and
-	 * sleep if iscsit_close_connection() has not already occured.
+	 * sleep if iscsit_close_connection() has not already occurred.
 	 *
 	 * Since iser-target invokes this logic from it's own workqueue,
 	 * always sleep waiting for RX/TX thread shutdown to complete
-- 
2.54.0.windows.1
