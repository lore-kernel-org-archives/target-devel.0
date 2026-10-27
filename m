Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104137;
	b=yy6ANbOzVMfYTJrq+loYMQN0CzdLy4TW0vhod4jfgTFtF6QjBib0aU5OoADkbGOwS+05
	 r6/2Hv52PgU58vyeQV7XaAGNjZMDN7OHB1TRkgbirxE46ICcpNghxin1WQZEDXIfqD0JC
	 tTNYn+ko2XGDmbcgw6nucRTBurIM0C5OgfYC5lm9up4ChFBJhQaEjo5UJ7VpRSWey+jhS
	 qvioui7cjpRSQls5gTGGZOBk2PVrpAo5dBfcbxI6d2T4Qmsr7P94r/AVP2bGULtdHLKgr
	 nuUsYpvKaMbzZKI2a6SD7gGdo9U9jRFeXHs5hMiWwcyTgdNAAV761DRb6On03eDdzjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104137;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=WOyAdyJ3VwLj6BYWXKFaYpPKWtpHPNj/CyN5SfKZYo0=;
	b=0yLmvH82s3fFAfpIWmnvi8camZmj4XCy4t7NL9siXdkFW9U2dSogrC4REE3W9PeVNO9C
	 QflW8VcWzELTNvTqVuBQKffC6lDmLA5xZiBDIdJ0EnyihJ+4BqJtmFkwIEQWkuv/yk23e
	 ZEQ/RPVkAqN4lJBPtRIUfRt+YNdI7g2+yKXXSQ7h67P3ERSUUfbdzNM+xrLpcawjwabZ/
	 Svj5k6/wAZ0riW0CTBtKUTJG+eaGNV1k/ocjOUhQDkhMCnDixgDkFa+oCzwWnzurI1Ata
	 9OW1jY7P0Pjv5q3ykYB9ElWlusCfPv1S7T9H+eOHCUG9U4gMY5Kcw5UwVfDifndcXtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lu3mH0uE;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4BA606A33F
	for <target-devel@vger.kernel.org>; Tue, 27 Oct 2026 12:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A4BA606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Lu3mH0uE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793104135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WOyAdyJ3VwLj6BYWXKFaYpPKWtpHPNj/CyN5SfKZYo0=;
	b=Lu3mH0uE2NXfv4aS5OhfPDZR1+of9pdtLnSI5OJYfkAEWAvOTjz6GGHJP6qN5eY4TSzg1Q
	y9HLNNRxyHlz4VItGmJ2l1x6yRBHugCeyGaqH89qN/7ptgss10cO8iWb1n/x4tMYx7BeTj
	VUXiuLdipv3eeq660kANephHoBSVgLE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-8NxQxAqJM0-ZHjEXoNMkvQ-1; Tue,
 27 Oct 2026 08:28:46 -0400
X-MC-Unique: 8NxQxAqJM0-ZHjEXoNMkvQ-1
X-Mimecast-MFC-AGG-ID: 8NxQxAqJM0-ZHjEXoNMkvQ_1793104124
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 911D51800864;
	Tue, 27 Oct 2026 12:28:44 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79BC930002CB;
	Tue, 27 Oct 2026 12:28:43 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/4] scsi: target: Do not re-enable interrupts in compare_and_write_post()
Date: Tue, 27 Oct 2026 08:28:34 -0400
Message-ID: <20261027122837.2148074-2-loberman@redhat.com>
In-Reply-To: <20261027122837.2148074-1-loberman@redhat.com>
References: <20261027122837.2148074-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

target_complete_cmd() may be called by a backend driver from interrupt
context, as the comment above target_complete_cmd_with_sense() says. For a
command that has been aborted it calls target_cmd_interrupted(), which
invokes cmd->transport_complete_callback(). Once the WRITE phase of a
COMPARE AND WRITE has been set up that callback is
compare_and_write_post(), which takes t_state_lock with spin_lock_irq()
and drops it with spin_unlock_irq(), unconditionally enabling interrupts
in a caller that had them disabled.

Use spin_lock_irqsave() / spin_unlock_irqrestore() instead.

compare_and_write_callback() has the same pattern, but its
spin_lock_irq() is on the path taken after a successful compare, which is
reached only from target_complete_ok_work() in process context; the
success == false path returns long before it. It is left alone.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Pre-existing, and not needed by the rest of the series, but
    compare_and_write_post() is modified by patch 2 and the mismatch between
    its spin_lock_irq() and the spin_lock_irqsave() a few lines below would be
    confusing to leave in place.
    
    No Fixes: tag -- the pattern predates target_cmd_interrupted().

 drivers/target/target_core_sbc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb8..8c52e1e 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -352,15 +352,16 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret = TCM_NO_SENSE;
+	unsigned long flags;
 
-	spin_lock_irq(&cmd->t_state_lock);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (success) {
 		*post_ret = 1;
 
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	spin_unlock_irq(&cmd->t_state_lock);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	/*
 	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
-- 
2.43.0

