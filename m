Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005622;
	b=V0O3gEzIXRMTU1wflQkV5g1ysHFpsCDsKfLgKc6YcAPonvVhg/KhE4RxJje/hNSmnUcV
	 CQD6KEsL2Xj6vz6dnMLoecTEusq9p8qD588+J5Mv+GQPuo6o5eZuaKM0B1WQWskWQ5d7T
	 sORka/LZtE877PSFQswWSnG4Z6G8C9wlh0WeSoJPydIj0AU6WgoIM/HENRpr7YjW+Soiq
	 dQ6e9yziwrDAgZz4ictxmP02IQm6ojMi/Fzsg6Vy5+0dQnejcgouw7tG7gU0lAkdfRBZQ
	 jRKREPOeDD46wIIhrREAh9MaJsGL+FfLYd/EI33Czfz7+Oklhl+GQgCYueLbkgq3miQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmq7Af/sM0RcMj+9tuc6VMNoq5IrrSVjtEHnLJaumaY=;
	b=4lm7PLYE1QJBPViHZxb2H0H/Dq2vyLEeXoJbOHYPZLroESgMz9+P0x/Xsrly9OE8hSdj
	 uxTawue+XNZvBvDkUwO7Moon1i3rBx66Pg4HButJMgrvcc143WhK+OfhdPeTNSludmAz9
	 IxwQqMa/dDVfdkWiMy+ZKi5bk50LV7QsQYEwtVIsYihr/lrxzLdDh8F9DYFYRQ5UQYWJs
	 PJqIrBos8tb2g8MRrP1U8wWd0Htz0bcnZMg9cnn1Axa5DDVhDwln6AfUXhauuguTrPBnT
	 4VFJ/yoqZEdxNyBNC0z1AlFk10m/CakUF/lO7U9fzmfpL2yPeqil5vOS4JWjuNH0Uag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=p49ssens;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0732606A335
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:40:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0732606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=p49ssens
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so1181172a91.1
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005621; x=1795610421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jmq7Af/sM0RcMj+9tuc6VMNoq5IrrSVjtEHnLJaumaY=;
        b=p49ssensfNeolb6Ih8IzXirPrigVla/RaZ6YMNBkNmOJ1WnxeYsjKRHCEk3DJ+xfri
         NjkF/f/XmkQtpAFHNLVPyNBsFwJ0SvlYr3W9hdEy1lBDfIKbGKwg8zzxQM6ZjJmujwrn
         UK2nk9/rHDbN+QgBxht8vdrPlmX+7MljZ+5vlp19cqr7/Z+HzV+wsfXdK4SQMND7xhHx
         4erVtxtbbWg01ScivNolsL2hSyDo5LLUbVjV5a2RvDaIZJE8Tv5ckPXTJnQSmXIJ6L4T
         AGPlKP2qUFcG+9ghK803ZXbC6Hkg8t0JCPaXwWY1oT6OmIacKRoVGEsyK63Iey1Nu1qm
         uUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005621; x=1795610421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jmq7Af/sM0RcMj+9tuc6VMNoq5IrrSVjtEHnLJaumaY=;
        b=BEIPJ5F4i3nF4IuHjFgQeGZHDn9bldJu36RTgzcy+8sQYdjNFKDBxAybfHZSZa55sv
         oE81zFETtK+mbRxpNWGgtTwB3MQijKCNU/FspPdQC2hCTCTq8/wGyp9ON4I5K1Nd7xNy
         IeWj5Q/8D85cIA+ofIAx1L/ZM5cKUIjCoARzODff7HlE73BlzrL7JTBCtbUUbLK7OXLk
         SuOxXoNTbBkxFabNYIa/nKCwGHBSoDlFr03Y9x5Zf6zHsjBX36LldiQY5RlmVeNrFIvq
         arppwKrM+zjMW+mpsMNgS6xrHXfzmhuU/Ma6bs/iB4oK4T7Z5Opwx68wGXeTvuE0TGha
         TJXg==
X-Forwarded-Encrypted: i=1; AL+hErHlEqjIm5oaHQ/t/R3ALxolMVsVFxBa9dWsNmY2Z4bz+j8fbLUh/HCJtp99er2Gq83ZDijA5/xuLmLo6r8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8mxNzX7vVk62Uf26FN/uPwS2VF2ufTaczjSLT2GGawcoZMTkwY
	fOTi+VciFKu5hCgyJdhYiJw4uNw+m+dCn368v3IWN1PMQPJt11BYxvmOlPwRe94/hvc=
X-Gm-Gg: AZFdTZe5yQ5Nt2a3XFjIErBkXUiRYylMZCz3h3d2yKz9+NUwrTybHPnR6ntnIlzhEIe
	3yt28uuhMUVq8cIAIm3BEhQeAGJR8LyCiTofqhjRJe6hM21qqKiEV9XicxMy+Xs6D+VG2S+luGG
	NiR8Or/2GvgdHhLMsIogK6IomNwzmeVvKUkNhEaq2cXTCb6fH/pRnZdNb6sW1TBiZfd0/ZXQ82B
	2PKPd+OV8KkPtvmKLQtsbyRnKM/ZV7x+d0Eq4l4yhi/FWvExibyQIOg7LHk/mxCQ3AeYLfvINZ8
	Z708FRyKOcFogASk8QfETfCyja+I5bX0Eh1u6eSWbuEOjdY2U0Akw1Ff4kTFlIl4g+gwAvwNrBB
	qpMQHvuWvEFMCFbn06cwz/9NibB2WZslphlPzGL+ij3R8t7b5Z2c+q8jMPkTIWSZWA+IubyceWx
	y1qUbijANgnlkQ6dFkdr35S4WsXH59VNB6SiO2L3zrS4/bM/ca8NQpbD/f1OQ+pG7K0w4ISFSVE
	IYzwmbJV0MgyguQtQH2EJoNJ55PRtLw2u4wwoXeCIuEZrqxIIAe9imT4KRXzsKzFAz9F6kmrIyb
	7rmXrg5MXi/y48SR/c+3JvZbbf4upR1VejXNNcLhKM3Z+sMm+6CtPRgmc+lCLrPlpDQICD/33fN
	CcsfeO7729Kk5P1H8YTWyayiDD3OoNSdBO4myxA==
X-Received: by 2002:a17:90b:5848:b0:3a4:b509:88bd with SMTP id 98e67ed59e1d1-3b3d063dbcbmr1675099a91.2.1795005621132;
        Wed, 18 Nov 2026 04:40:21 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d19b6e18sm4257980a91.10.2026.11.18.04.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:40:20 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v8 1/4] usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
Date: Wed, 18 Nov 2026 21:40:02 +0900
Message-ID: <20261118124005.2428068-2-yhlee@isslab.korea.ac.kr>
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

bot_send_bad_status() and bot_send_status() run from endpoint completion
callbacks - bot_send_bad_status() via usbg_data_write_cmpl()'s cleanup
path, and both of them via bot_read_compl() after a BOT read.  Those
callbacks are called with interrupts disabled and must not sleep, but both
functions queue the status or drain request with GFP_KERNEL, which can.

Queue with GFP_ATOMIC, like the other usb_ep_queue() calls reached from the
same callbacks (bot_enqueue_sense_code() and bot_err_compl()).

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f39900a27..12e2b20e33b921 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -139,7 +139,7 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
 		req->complete = bot_err_compl;
 		req->context = cmd;
 		req->buf = fu->cmd[0].buf;
-		usb_ep_queue(ep, req, GFP_KERNEL);
+		usb_ep_queue(ep, req, GFP_ATOMIC);
 	} else {
 		bot_enqueue_sense_code(fu, cmd);
 	}
@@ -167,7 +167,7 @@ static int bot_send_status(struct usbg_cmd *cmd, bool moved_data)
 		csw->Status = US_BULK_STAT_OK;
 		fu->bot_status.req->context = cmd;
 
-		ret = usb_ep_queue(fu->ep_in, fu->bot_status.req, GFP_KERNEL);
+		ret = usb_ep_queue(fu->ep_in, fu->bot_status.req, GFP_ATOMIC);
 		if (ret)
 			pr_err("%s(%d) ERR: %d\n", __func__, __LINE__, ret);
 	} else {
-- 
2.43.0

