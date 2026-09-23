Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B447254B
	for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 08:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152708; cv=none; b=Ihk4FG1V+gTqBMqQCYbyvufUYGAgr5UrrVd0Qxja5fN3HBStYh8nO+0t+yZqUGkAnMayoODfNYN5fPydgsJ9zTgCvx/WG8+6tAhF75XI6LGLmodkGfU8x8SkffnjqZiMWAqhoqJz/sgOSrKa3fJpAJpcDB553Vt/H8ToE6L9zEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152708; c=relaxed/simple;
	bh=5MDcLEaso1xaP4AeiREVxfmH9AbDxkQzOHe+BIo5YwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mva1ya75RwwzVHqOWh4sftfcSKhPceh9ds4alQbbefrwmFJdetkhzBTxJnEhhRXKrXguY4jELS+f1tkoRG6sV/PTE7eOLIOhE3ld+b6l3xb8XorVBZpUYFPMrQhQm9jxE6BQcLP83jVem78Ey3X2wJZYAjHJBC/6/y1/Bs7TAQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLoN/6zf; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLoN/6zf"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccdaea75so275423a91.1
        for <target-devel@vger.kernel.org>; Wed, 23 Sep 2026 01:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790152702; x=1790757502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ru5GUJQ/jJZenl6rNxGccFjH8Yan3srwh4Oocvd7nRs=;
        b=jLoN/6zfm9CbOxH8qxymNFwqCUMt1S25+4Gk+IVP/eN+OwAhQvHqSSDbVjj0ORBAVv
         Ykz8r67tDXSPTI47NPHW1mrUMVvdD6SUNoVKwg76BShDRkTzKMVT1IcPAueu1bo6UmLw
         20gsZaYOzBUQwXYykHt29e9lodbsVkHxe+N4kiE0IM/RAd+A+35nhqZB+JhfXBP4RihP
         EbNN+knskx1vnEVw35aOxSvQBnI0V/yiZA2Uob0t73sM6V767hBrufofEq05MDr2ph3+
         0X4hp6YgulP134edRRWMCSHb3BnqRBt0YvrbNIVDFzmxN5RxrnTT4gPL7WQHhCO6YwFk
         zSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790152702; x=1790757502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ru5GUJQ/jJZenl6rNxGccFjH8Yan3srwh4Oocvd7nRs=;
        b=j5TvMmAu4JGy4lWJ8ZPRZFcA/pMoj/CJlf1n3972R9JKGxXY3nDFI/7kHFJDVMuQk3
         CVecy2uOE2n1nPkmxK1JJy/NLoN0QKuqerAsS4jlbKs3PYkPWVBkaHVLVhZoosdZug+h
         dIIwqmBZKsY9tWhPz/PyLN3kTIMn/Tt6lc78s8pwPIpHGwKsRovg2gfG5D6sNupwriAI
         9sPEEQ6k2NOQ3j9ftwfuxiO0Jrm9OKGV6o5F+QK8/ZQm7JorDBpZBNgZklqLsZxMczIu
         BlJi9slIKPBllL/YatGTZWXjqDNgK7bMIaRQhadImBDW9xhQBi0bspDbUv2V18NX3q1G
         sP2Q==
X-Forwarded-Encrypted: i=1; AKwUvBzlAR9BFBbzVdU0TSK8CM8znRHkwfvip/j0FxIeFo6xXp49sa3oH1tApiwTOKqTHbt4Ao5G9tTFo+UFrqk=@vger.kernel.org
X-Gm-Message-State: AFuF++mAS9gfA3vlk9Q5HsQ3yzy40PIWQmoVUjZNPPr0jnf2KrsGkz2W
	ZCJ5npQ2MQbgO7VCo/ESMW+JBAOOI0LKEAgY6v4sqW8QGNPUG0UQY00a
X-Gm-Gg: AYBFou0Kd0mXDvb/ETHadFp16wEtnPDwWKI6rh8jr1PvLgVkFC/+E4Xl2mxPKS3d7te
	CFYi6iMxesuhFTmpsDthw3nmC3FmOP8Uo3HgWIA0eqwrWS0dwEMhA9F7ziVgrxkroz3CYOIuPn+
	X0ay2Dv7Wnm06LvDyRBZe/qVSFN7/JmVgC+X0L0AyvJZOyG94nbF7srAtFWWOiObByPSat9EVgY
	EXxalYK7hqlf96Ax6w1nAC59IQWIjjlWKEu716b78qOkr9N7MwAT5ytTThVpmAr6ctyY0lBa1Yz
	8cZ2Q3B7mbL52qGhkE26gjCNztyXCbH8FsiAgRBBIrGpeQuvDH2tnURxA/T66phRDOxRctdsKap
	SI+w41D5L5UsMK2mNYE93ejTzHMN3+Btxq4pMB9HlYy9m97/xeZIKf6tYFH6qgixkgTJO+XqZ/M
	VWh5EECL5WaCF7TA85qbiqr8aHVM0gBXbOmuQ/9CRlmqDt1/UGtQ7r+XCsqxvZMOUImdkdQ7/kK
	MqpPANGpHtoGQcKZeS3ZUez3O4dn+LApLOG9dZXDeVwfsT+UdE3p/KipX3sI2XQT6FWchfCy83v
	lA==
X-Received: by 2002:a17:90b:50c3:b0:39e:6a7f:618b with SMTP id 98e67ed59e1d1-3a07e595addmr1182846a91.28.1790152701752;
        Wed, 23 Sep 2026 01:38:21 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-242-176.ap-southeast-1.compute.amazonaws.com. [13.212.242.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dbc5451sm4314920a91.7.2026.09.23.01.38.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 01:38:21 -0700 (PDT)
From: Ginger Li <ginger.jzllee@gmail.com>
To: bootc@bootc.net,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: sbp: Protect agent->orb_pointer and agent->doorbell with the lock
Date: Wed, 23 Sep 2026 16:38:13 +0800
Message-ID: <20260923083813.64892-1-ginger.jzllee@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tgt_agent_rw_orb_pointer() and tgt_agent_rw_doorbell() update
agent->orb_pointer and agent->doorbell after they have dropped agent->lock,
while the work item tgt_agent_fetch_work() reads both fields to decide which
ORB to process.

The work item already accesses the fields under the lock when it updates them
and tgt_agent_check_active() takes the lock as well, so the unlocked stores
and this unlocked read race with each other.  The work item can then use an
ORB pointer that has been replaced by a newer request, or miss the doorbell
that belongs to the current one.

Update and read the two fields while holding agent->lock.

Fixes: a511ce339780 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
---
 drivers/target/sbp/sbp_target.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -721,10 +721,9 @@ static int tgt_agent_rw_orb_pointer(struct fw_card *ca
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
-		spin_unlock_bh(&agent->lock);
-
 		agent->orb_pointer = sbp2_pointer_to_addr(ptr);
 		agent->doorbell = false;
+		spin_unlock_bh(&agent->lock);
 
 		pr_debug("tgt_agent ORB_POINTER write: 0x%llx\n",
 				agent->orb_pointer);
@@ -757,10 +756,9 @@ static int tgt_agent_rw_doorbell(struct fw_card *card,
 			return RCODE_CONFLICT_ERROR;
 		}
 		agent->state = AGENT_STATE_ACTIVE;
+		agent->doorbell = true;
 		spin_unlock_bh(&agent->lock);
 
-		agent->doorbell = true;
-
 		pr_debug("tgt_agent DOORBELL\n");
 
 		queue_work(system_dfl_wq, &agent->work);
@@ -933,9 +931,14 @@ static void tgt_agent_fetch_work(struct work_struct *w
 	struct sbp_session *sess = agent->login->sess;
 	struct sbp_target_request *req;
 	int ret;
-	bool doorbell = agent->doorbell;
-	u64 next_orb = agent->orb_pointer;
+	bool doorbell;
+	u64 next_orb;
 
+	spin_lock_bh(&agent->lock);
+	doorbell = agent->doorbell;
+	next_orb = agent->orb_pointer;
+	spin_unlock_bh(&agent->lock);
+
 	while (next_orb && tgt_agent_check_active(agent)) {
 		req = sbp_mgt_get_req(sess, sess->card, next_orb);
 		if (IS_ERR(req)) {
-- 
2.43.0

