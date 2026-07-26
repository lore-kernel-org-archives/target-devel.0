Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48874908A9
	for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079903; cv=none; b=MEfqhFgRO/UY+gv3X2UicNdXt5SoUP0ieh0cXNGpxlKkIbVglv3vXbZ6xB9jU3/GnGnrloAvFyhj73H9XVc2H7ypaLzO/Pm9yhqfkzoN/jWr9ipRJ4qgGlTLrigV6gkZHcNuXpBgX+FO7LcxIjNXyVjFqcFI4h5+mG8CUDN4Pk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079903; c=relaxed/simple;
	bh=c7Pma2i2/+N0DV+POQ+i7P+HjseyUAHIKJYjDdV80zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYOXmH8NX2J8zh07APfch3ftf42LtFVIx0u2SIS8HzGCqcTrn9sxIj4Cyo1o93YY8C5frh/zc632Wh8nx9nhtQ/i8P7LhD6ktPidvvij3y22EXKFqFZRlxekB8IVyIj7z9u8a9NLHiVrveMzZIZQ3QbpmNFSfKNnmmKWbwyh78Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=rKiEsjWh; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="rKiEsjWh"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84830c774a0so1901251b3a.1
        for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 08:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785079901; x=1785684701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WCyiXiL6v90bExJpgxX0aqjtKCXo1CaNitEii2ppwEM=;
        b=rKiEsjWhnzzAqJLL7OCDGduoudqQ/5GIclJJXbPVLYgTbSGFI2l56Cd2Cv4F0gqGgU
         HZbJ/0UtFmm73THsKxsmzU3cIqaORXSHxg4LlzjFRKJkRjb0qQ0UJxZBybiIe+UXIWBO
         QUSH9DzMvj+V94w3+ZX3T1epS9QlOhPf+35GQGdtG6Fj40Ow2ENXslrmHbDvzy6jlkqF
         39wBku8EqpNBr+aJC1IMMAhxLucvKKBhSO422a3/8KmH0iVwnvOyYEGTiQGn67ExbgX6
         hErEpKJSfSCL2vIXAwsks9nvoC0dPztAukBXZZgHwix3Y7uZPruj5xXxSQML6q+t74zA
         lVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785079901; x=1785684701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WCyiXiL6v90bExJpgxX0aqjtKCXo1CaNitEii2ppwEM=;
        b=JiFYlU1QuJGCn1Nquh/6/nHj3vzC7+S6lFQSp8daPZ82QdU/pTesttX4jD3wFvt0yn
         6XK1Wtbpw08LjWmmk40RlPYVcmvS9jEfFAcOPj/BzJBNblhhY1JcnZdOfdSn3kPE1+hj
         7owi7oETdvZ6E7RNrkS5XmOPB/a5Fu6baNWheay6WSjDH8rf+I5zPb1W8457KZUch7bT
         sipOv1uX0U2S5bKEm4zq556CduEkzq+ltLNnvPtML8nCLnBwrwbajDwVRvHpqYsO0K9n
         6TNDAJkOQL0bjh21NsERIFms6kx6YVjb/GTqNNeHn2W3HztxCP71/r1/V20grjoX31ot
         oLIg==
X-Forwarded-Encrypted: i=1; AHgh+RqJIYVi1c33Nucb8y1lo0Y/VYnxSRYYeviwbQgguzzXpcdy5ZUaeLKOy/k2EE8e56sll9dpUkqyEvbAvbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgUDbGljEj18w3N0iVa66ll6M7c2/3UscKzPgCHl6vVa3VMN37
	QaTcoc87p0lD9JPv+PSbjnO6tmAcnOUon0e1hLiUIWJ430mpRM0X05y/bl8VgdtmQxI=
X-Gm-Gg: AR+sD10cwortm4jWbVvVz9ZvUfrsbVK5Rg4F1BtjHaQVECaZZF0rPyBLdHJ9lipyY/k
	JbzhLE2Ezb2JcHrUMW53YTJ1jBvb4K6OH+AdoIY4BGlitWzLu3K9KRzT5ZlBJ62POqBm91OG5Ld
	vrPQQ0SnqWeGUjWljLHJUU+hXDUSeOzRLZBqwzQ3w2y+5oAkYz6gkiPchLuwigUOEAUagv1h3mE
	+R2ptUvbh1OWODPcdQxgZEkipfFY1kXqxEBxOmxXk71ce0/fCwkfz+MWMl7LjPtj5KbiLFsA0M1
	23IsrQ9xoz87hsUIL+13aI3D4Ms3ME3I0ddPPSL836tzm2P1c/FuLqq3XF2pzIAeTSd6GD6uhO9
	LQyTEhzvyeY608Rt0YpyAZzk0gXhVnR3aflj6FTc0GZXNG4ZyvzWZ/6BXdzaa1wFAkd7dawR4pd
	qt/FFDOakYHN+7f6pppQOVg06I
X-Received: by 2002:a05:6a21:6004:b0:3c3:daa2:2b7 with SMTP id adf61e73a8af0-3c67df28fb2mr5230165637.44.1785079901080;
        Sun, 26 Jul 2026 08:31:41 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb6622461sm2088301a12.8.2026.07.26.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 08:31:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: leon@kernel.org
Cc: sagi@grimberg.me,
	jgg@ziepe.ca,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] IB/isert: reject PDUs declaring more data than was received
Date: Mon, 27 Jul 2026 00:31:30 +0900
Message-ID: <20260726153130.934622-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260726064628.GA12003@unreal>
References: <20260726064628.GA12003@unreal>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jul 26, 2026 at 09:46:28AM +0300, Leon Romanovsky wrote:
> 1. You should review patches generated by AI.
> 2. There is a need to add similar check to isert_get_login_rx() too.

You are right on both counts.  My changelog said the login handler
"already rejects PDUs shorter than ISER_HEADERS_LEN"; I confirmed that a
length check existed there and did not confirm that it was the same
check.  It is not - 29e7b925ae6d bounds login_req_len from below, and
nothing bounds the length the BHS declares.

I reproduced it before replying.  An initiator that sends a 105-byte
first login PDU while declaring 8193 in the BHS DataSegmentLength, on
7.2.0-rc4 with KASAN over soft-RoCE:

  BUG: KASAN: slab-out-of-bounds in kmemdup_nul+0x43/0x80
  Read of size 8193 at addr ffff8881056a8000 by task iscsi_np/167
   __asan_memcpy+0x23/0x60
   kmemdup_nul+0x43/0x80
   iscsi_target_locate_portal+0x48d/0x1180
   iscsi_target_login_thread+0x19a9/0x3350
  Allocated by task 167:
   __kmalloc_cache_noprof+0x158/0x370
   iscsi_target_login_thread+0x971/0x3350
  The buggy address belongs to the object at ffff8881056a8000
   which belongs to the cache kmalloc-8k of size 8192
  allocated 8192-byte region

faddr2line puts the allocation at iscsi_login_init_conn(),
iscsi_target_login.c:50 - login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS) -
and the read at iscsi_target_nego.c:1136, the kmemdup_nul() in
iscsi_target_locate_portal().  The read size tracks the declared value
exactly; 16384 gives "Read of size 16384", and a control run with a
correct DataSegmentLength produces no report.  It is reached before
authentication and the length is attacker-chosen.

On why isert is the one exposed: iscsi_target_check_login_request()
already rejects payload_length > MAX_KEY_VALUE_PAIRS, but it is only
called from iscsit_get_login_rx() and from cxgbit.  isert does not call
it.  iscsit over TCP is safe by construction in any case - it reads
exactly payload_length + padding from the socket, so the declared length
governs how much arrives rather than how much is copied out of an
already-filled buffer.

Your check is sufficient and not merely necessary: the posted login SGE
is ISER_RX_PAYLOAD_SIZE, so login_req_len cannot exceed
MAX_KEY_VALUE_PAIRS and size = min(login_req_len, MAX_KEY_VALUE_PAIRS)
is login_req_len; once dlength <= login_req_len the copy out stays
inside what was copied in.

I will send a v2 two-patch series - the isert_recv_done() check as 1/2
and this one as 2/2 with Suggested-by: Leon Romanovsky
<leonro@nvidia.com> - once the before/after on the login case is run.

Best regards,
