Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005631;
	b=e4LpHnGwzdAVPIiOkjwelRSkbdpNuxMy5YMiKW92V0TiWd0Y9RWssBQ2OdlEB1lttgZx
	 C/9MLz5nZMzN4wgizEh2MmmVNJfZy18dz1wZjykPm5IOmzg9HLecQRjR1nKPqR+fwCAP0
	 q6fevrBSMvyG9L89G/yAGw0hIGOR3PlFRvdJKIE4keA9k2XEgxLEOLSkwg1bLkagHYQTI
	 r6xD33dBD4anmt6wTGuVfqz4lRrHnQd5722cBrmCpRDgp0+Z2E9gzfaBdqWW09ezzSTUT
	 3u9qGKxpy5NlGCj8bqyyN3eHlk49fcCKrQmCpQKQSU0dKLqvNivXxH4TfjDPI6eIYsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005631;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkQIR6xullmNca58dESOLHq+G6witr/d+tJ0Hc+yeYk=;
	b=5XIvDy7+jjLoVoYjtAqqF4lEvYH63kmY912u/+tJfqRhvGBCmqNEm7P7lzOqqn8ulcOP
	 Lwh8tCQ+3yX9yDm4J1cGrrQzX8+k3G41VXCkazGzm8xkNk/PDv/SljKcTG0pwt3i6bFQA
	 uJoghTG5w9pHnz53aajuxXCeL7Ku0IA22I7xZbTJkb6QMQ9svpE/3QmlS3TulGmMtQxWj
	 bTG3n1d5/P7BZItSVFkBL00fufdVva/oS94tozOhFaOnpz3Q2paRTMZl8IJOy8oqQxL/0
	 266K8DDkfYByH6kTFBsR0iEVBPOHiBkPUDLhUpZHjJEAa5qQVPJrYTuD7HQyHh/QfzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rWKI3Tdd;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F83606A333
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6F83606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rWKI3Tdd
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so1181257a91.1
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005630; x=1795610430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LkQIR6xullmNca58dESOLHq+G6witr/d+tJ0Hc+yeYk=;
        b=rWKI3TddjM8acucdR5sJ+4iTrnxQQMVeyJR2vXKW73kZ2BAlNP1g/IedL83z6fQoOh
         kFZmN214kJYrJbke7O1ArUouR08RhXy6klodXf2ZM1P2k1S65FiK1Jl0L3YEevNtjCRP
         ixN6KQYrnwS0fiLZ9SK5zUulqHyA+kUjdWyk1l+7GKjteJH328QG3drzydYZxmQdfwiM
         G2bmaaO1v2qLK2P4BgjlMxDSWWjHoKMnb6iOzTfGIOV/ZDjzTlUwlMtt/9lnsheeM0VU
         asD8f4pC/ybzLyF7n+U01cEPuK/r6KBoBgrUku7XJbCGfjnDpc7LNeKQGFsPPgwKgl1+
         hxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005630; x=1795610430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LkQIR6xullmNca58dESOLHq+G6witr/d+tJ0Hc+yeYk=;
        b=KfGF9F2Q78t+N+Bac1I4JWfBoAVQA8X548sbxQo++UwDfX+7QPcEWxOFrolOLqB9mo
         3nZanvn13GiRpGDGgICT2KywXa8nk4EPhs/0sy2BGOAH546Ryet94LtubKOfN9msuVMi
         /zg3AxnqMV9CeSaE/6q/ltzfjkuqYcdRVh09rPtdqdG4mDlXVRTMuuzS2Km+tyII96dy
         5jDSsHJebfPK7gMHUrSqf/d8fXoUhrktipj1YqpI2cO+Af8lmAneQipJ8GDQUwOEG2vW
         pewUPYtZC15JtY6yheontKNH3Q+kfC0k73AdwfKFRkgSS6TKYZibPuw0/gXJKi9HZJ2a
         FTOA==
X-Forwarded-Encrypted: i=1; AL+hErFbI0kz6hjlQzQ8dg6cq8GCPPTPbimul+rwtOTMhL9dPV4MZSsV0DFNWuPgnXbmYhb6bd/imDULVIMukT0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/27WcJMcJeWB8Ii6GIWGDP83oFz+DQ7EpXY/VFnyjrK3IenSiz
	GueiyXLPotB25vV13P1JhHKSxq9tKthCNmNBB7fMdTqXOw8wBDCUefa79Ez4R7ySOcQ=
X-Gm-Gg: AZFdTZcXcGZ7zqtCCnS5PmWtwxfthtl0rxWyHD+9SBYXFhLSwi3U5uglL9sxU2sew1b
	klX7+lAuFribotK7Ed0H5NwclojDr6N+q6QCpYhcmXutgUcB3PJdx+YTqyNA5lETU5/b2FGwJTp
	MQBbo9KV0OsMtgOYzBsbv82BXqBeKWZDNHuI5waEVwvBWMdFjxuvn6wkaAUnEPN9RnqNgTgsK36
	9PSrVPDqh/w7WjslrgP6BKE7yS3EIsAgYfQbIS1tCWg8iDjLDh2FOqAnBdKRdlIyA8C3iX4VKE4
	8eKKjozw5YO7Lp2ayG2Zqxc1zME9xev+s7ML8ZSScKd3xw+ByOcifmypA5OMQqn2xDSE/PVZBKH
	GYID/ubHlqVQ4qZQQn7zui5K0wNC9Jt5ce9Q+g52XHlVGuO8GYbN7fyFPCKSIVKgj1KJ3sxau4I
	URbwij7aBsJ7/NiCce+nb6J8izwSRyUwUS88YRY3Y0DpWDjAhhxC1+KTy88LXafehWbAfmWi7BK
	YBcI0P2Hgylx0VckpWBrJ/c4YjwQAKQLAWadjBpn8C8ytwO4oCfF7fqZmMSiPvI1+o5BIT9Jms0
	cuVEsN3g+k9tdlqWxaL1jnrCvlU3YnYFaFQTmIz29SScVWYGZpXcL1prxPbQl0SCPVdMggwWZkO
	xAUZYkcAn6U28RccqFsCkgZ9nf2B8PGTCLvAGTQ==
X-Received: by 2002:a17:90b:518c:b0:3a0:cca0:4a8c with SMTP id 98e67ed59e1d1-3b3d07bef79mr1656925a91.7.1795005630028;
        Wed, 18 Nov 2026 04:40:30 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d19b6e18sm4257980a91.10.2026.11.18.04.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:40:29 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v8 4/4] usb: gadget: f_tcm: clear the scatter list when reusing the BOT status request
Date: Wed, 18 Nov 2026 21:40:05 +0900
Message-ID: <20261118124005.2428068-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr>
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

bot_send_bad_status() reuses fu->bot_req_in/bot_req_out to send the CSW or
drain the data phase, but a preceding sg command left req->sg and
req->num_sgs pointing at that command's t_data_sg - set in
bot_send_read_response() for a read, or usbg_prepare_w_request() for a
write.  That command is freed before the status request runs, so on an
sg-capable UDC the status request is handed to the controller with a freed
scatter list: the controller reads freed memory out to the host on an IN
endpoint, or writes host data into it on an OUT endpoint.

Clear req->num_sgs and req->sg so the UDC uses the linear req->buf instead.

A test module that stands in for the controller's queue path, so that it
dereferences req->sg the way an sg-capable UDC would, reports a KASAN
slab-use-after-free on the freed entry for a read command followed by a
rejected command that reuses bot_req_in: 20 runs out of 20 without this
patch and 0 out of 20 with it.  A normal sg read still queues its own
scatter list.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 970dba09d75e4a..e2ecd5922ee77c 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -140,6 +140,9 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
 		req->complete = bot_err_compl;
 		req->context = cmd;
 		req->buf = fu->cmd[0].buf;
+		/* the status request is reused; drop the previous command's sg list */
+		req->num_sgs = 0;
+		req->sg = NULL;
 		usb_ep_queue(ep, req, GFP_ATOMIC);
 	} else {
 		bot_enqueue_sense_code(fu, cmd);
-- 
2.43.0

