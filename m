Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6816942A15A
	for <target-devel@vger.kernel.org>; Fri, 17 Jul 2026 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299117; cv=none; b=ZZw6nR192mil2McfF41izcR7t7iOCZHvmmvBhnSq0Myyl1Ne0MoiJxzFW6yFnPDH4wrMInh7zhgfihHXtOaCBiryF7+iKkrOvt8sCYnfxREIerqPQdjp608DwKrnm2HzlyNqh2r3gT0DaMgOXiCa1/XKLmyYvM2pAL7qqJ/HLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299117; c=relaxed/simple;
	bh=LfRH5bJsDHJBWSFupQOsH6bHXaDCRaV85j0kObW1Ifg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TMXbIZicB07gzxhudotQ994+njce5aJkV1wWfviE3HDTf6/wqZXmJ13HQLW4LuEdBho7Kl1v5D/6LQwlnWRLgjp7sVgLQ+f4NQYtC/tWIHNm0FWc+gsP/yenmTuj+KgJqGuZxqx0SnY5vtF66UxKutoZrEUV+ZiUmGn0W8DnUIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eiNdN+oH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eiNdN+oH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784299114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BfCUTLYHuWN5D/6gqeV3ekR4lZSRbKURFUZg7kQbOC0=;
	b=eiNdN+oH3mel4zr65EMaQ40Z31xVm2euDKKclOOQ+fDEEi9tJLvDHILNpEcnF4XMFON/8w
	aFf5Tu2G+ObctQJac1cOnelblmayFFEx+L/TjIn4F2omG7XQD8uyq90esj/f/XV3b/jYli
	SWgj+L9xDD3KyTUToenIZXBpNySyRbQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-_rFLOVubP8muOuTYFHZd3g-1; Fri,
 17 Jul 2026 10:38:32 -0400
X-MC-Unique: _rFLOVubP8muOuTYFHZd3g-1
X-Mimecast-MFC-AGG-ID: _rFLOVubP8muOuTYFHZd3g_1784299111
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 644E81955DD6;
	Fri, 17 Jul 2026 14:38:31 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D161D195604D;
	Fri, 17 Jul 2026 14:38:29 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@arkamax.eu,
	michael.christie@oracle.com,
	target-devel@vger.kernel.org,
	loberman@redhat.com
Subject: [PATCH 0/1] Write commands abort hang
Date: Fri, 17 Jul 2026 16:38:27 +0200
Message-ID: <20260717143828.76291-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

One of our customers reported that sometimes the LIO driver hangs when
performing a LUN reset while I/O is underway.

I was able to reproduce the hang by using the following libiscsi patch:

https://arkamax.eu/misc/dataout_abort_libiscsi.patch

INFO: task kworker/5:0:514619 blocked for more than 46 seconds.
__wait_for_common+0x94/0x1b0
target_put_cmd_and_wait+0x6d/0xb0 [target_core_mod]
core_tmr_drain_state_list+0x2a3/0x330 [target_core_mod]
core_tmr_lun_reset+0x93/0x1a0 [target_core_mod]
target_tmr_work+0xce/0x100 [target_core_mod]
process_one_work+0x188/0x3b0
worker_thread+0x2ef/0x410

Maurizio Lombardi (1):
  scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.55.0

