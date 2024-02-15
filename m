Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9244513247A
	for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708008000; cv=none; b=dgk+6qVVR4hSvRYWV8cq9uQdP46tmJQTI2giVPzxNDmDToW20KwNPol3xVuK6t6MpYVCLu7s20fwlRqA/e0B8aJWASzCVPJFTtg3/TT2aobhTxtkVQ0Q6bwR+qCUgaBD8YYHu84irLPliyvIY1eHtndyObp7VaNUl8lRa/3A14A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708008000; c=relaxed/simple;
	bh=pyiETiT0mWRVTFHitcfy6ifRjN7asMxAy4uLZDURMBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HX/OrxPswGpjOpqOURiIBClzaBs9AK1avI/Ym8Q4hqjw0epftbz6N9gL9BBocuqAg7cFfeSLeXws5vyfG2rpjaQWxDctEAiOfJij+SWDLxhw5M6wghW6V5PbcXPJ1/SgEVpP2SclCv/gtdEHvUaqqj3MK7oZLJWs5ek+C5PVUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+yHeLbJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+yHeLbJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708007997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EerRsS3pnhmM4qDFUqEJSQKn/OlEoujFDPhFMuqHJ58=;
	b=Y+yHeLbJdVL0pl2nmfdBV1qkvA0mbjy7vGt1jiX4Nl89mKFS9veMREBDh6Oev0sJc4UsXh
	ia4HPbhvRhPnp8hPv/kt0B3Ua8zt3Du4hYqR+G0WKahqSW9VUma1lxyyyx/YGIRsZl+tCN
	UTGt3z/dhUJFH5kBBq1dGOaRfWsmVDs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-xzAAwuTIN4WIZqtE8jyt-Q-1; Thu,
 15 Feb 2024 09:39:53 -0500
X-MC-Unique: xzAAwuTIN4WIZqtE8jyt-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B2138060E2;
	Thu, 15 Feb 2024 14:39:52 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.47.238.145])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7BFC40C106C;
	Thu, 15 Feb 2024 14:39:50 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com,
	target-devel@vger.kernel.org,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com
Subject: [PATCH V2 2/2] target: set the xcopy_wq pointer to NULL after free.
Date: Thu, 15 Feb 2024 15:39:44 +0100
Message-Id: <20240215143944.847184-3-mlombard@redhat.com>
In-Reply-To: <20240215143944.847184-1-mlombard@redhat.com>
References: <20240215143944.847184-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Do not leave a dangling pointer after free.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_xcopy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 4128631c9dfd..1f79da0041e3 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -491,8 +491,10 @@ int target_xcopy_setup_pt(void)
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq)
+	if (xcopy_wq) {
 		destroy_workqueue(xcopy_wq);
+		xcopy_wq = NULL;
+	}
 }
 
 /*
-- 
2.39.3

