Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C4A38F649
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 07:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876826; cv=none; b=tadHro7nJJDQdYzNQCt8TUtq9aqcMChJrlG//IT2SDw3jfu4U2e4urnibvK/jmiakRJ9hqE2lymZPAlGQ1Jk0IkBo6WEBdCXCcHgjU4gvZrJwwVcz3xMipEHRaTnm/hjI+khdmk+ZzV2w1+/+UvwK8EUfn0JH+11dn24U3M/8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876826; c=relaxed/simple;
	bh=yKooLcN7CHgsaZDkbyO505c2en4X/luvbmOSMQrltvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CauwEdq5VTOHAr7sFzmmrDD2ubSfyWg5mEAJiJ9E1U8n1lO//HZ4nJl1MRAGZ8SF5znLN6ArY1R4thRPNmjYYFZytYWPVOAiXP9aQvUYgPmnAAy90YFWFK7bN7ihd4FEwCSU6XuvcFP/kreuFbdvyxtlnV56FR/oMESeZ6qBLY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=qJxWhSZi; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="qJxWhSZi"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so1093661a91.0
        for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 00:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791876825; x=1792481625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwgbOTwZS+Wdyws/KBJ7MPJ9pBsymYg2xZOg5DiPzmg=;
        b=qJxWhSZiO+8phAUlyAKagE3JV3yDtbaW6oDzkWBGcpkwC5/0Us9sq6+ITm7OZVdoqx
         Q2eGdJn57hMEy/RqMqszT7uXS80Likex/j4xbxDiX7k6OR45mFN3hrM6Vic6r5hxDvjv
         6Ywp7Q55W64ArZNZw43k5xb3GGgqEPeYc7v9e1L2N2Dj77yQLxCHtXCcnqwXAK48F3fJ
         Pe5g2CtLwVW7f4O0tqi9fZ2LmSgwzNSMWmuHUycfHy18Vv+tR31bvcHsWP2ObI7WQ+o9
         nJwsqick/lnyFB+Qq33sU2Q3rAC3I6PRXyqzgFzJWlJRU2nHbToo5nUjLY0RS6H8kv3k
         u2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876825; x=1792481625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwgbOTwZS+Wdyws/KBJ7MPJ9pBsymYg2xZOg5DiPzmg=;
        b=vpLz00Rt8kiW+z6DKf9q4/3szCfnzKwLhDJFyzu7pownbuSpbGcB5ua+yBnV9bxaVK
         gVR+mtlkcoMCFLAkCXNUUn9HirJhpB1w6aNX0t9rutIey4luwNiJJp8uRuoT3f1tgqPp
         qXrssvdDgqAgZymLEfZfxoh479x85xQYXSIMuo2j3WpZrMKrarNSwhS2do7XK6zSnMwP
         EO0VtXyI2w/n7vaXwpFcAVyo1Ia8w2ILeDPCSjlctwjmSoJNDZP9+Ku3vLM17t2d6ajx
         dBxuXKTit7u17EHyq/RHE8Wj7R1fvLFqlifvU6Hn2vfrDuuhcmqNkP9r/AQhBv/i013W
         O3kg==
X-Forwarded-Encrypted: i=1; AKwUvByZ73y0OBoi4ketpyKDLR8j/v8hEP7qnMGfoWvVhT6rK+uPLY15vYNoW944TVXOARliHVxx1tSJmawh9bI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKu4e7FKFFnTTisTNLIyY2oXNJigyIvcUIe4a3fplfNBQvhwtTP
	3rBhUdti3guclAhlempUWAqbGEwDoq2RzsgLvhZNythGPWl2mmu54Lq0IRSXgPmm6Eo=
X-Gm-Gg: AYBFou11O67cKHGlmrliPluFBS3HX5D6nLOgiYJYcEtA2mWMu6sSC27pRoX+X+L/GoJ
	/XAFHERevsuP9sdxK7Hfp6pDfk/X2gILRPl7ChLmJ3S8zPBjH3q60a1GrnCTCzzYw07T2x8S6VK
	a5twUIP2TcO03bCXJ9UmmeBBNDR8ITVlVjyVfi38FS8liQXlG59bua0H58RE4XMfZMvPEj1gMRP
	iTArfNCzEQEL3ZbzztFscWzrlZeVdwCdVVGcvmH+MJazpitmhieXUZSJVzrplqRelkigA8ajKgR
	ShyMx6hQonqPeuZ/uXp2P9kqUc3nQqt4DHS80upDe6jSr+/W3ibMyevCD2deTOxj/yUqP/y58K5
	QynWK+FdKiv+hi4Xx7txz/IPUCKblDRUdb0vA+euD54jVi+TDGPj6gMwGjPr3fpGBRSE8KZUrB/
	WApGIg2LyG4pKqPEjH8G5+HcCYKv3aqr9wgSCVvdBMCjrXI7Js/zUNoZ2UyQda26pjozxI9ymaX
	nu0SQ==
X-Received: by 2002:a17:90b:390d:b0:3a0:9fe0:3aaf with SMTP id 98e67ed59e1d1-3ab3a7a42bamr10025027a91.48.1791876824559;
        Tue, 13 Oct 2026 00:33:44 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab36ed0daesm19973923a91.5.2026.10.13.00.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 00:33:44 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v7 1/3] usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
Date: Tue, 13 Oct 2026 16:33:26 +0900
Message-ID: <20261013073328.2936318-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
References: <20261013073328.2936318-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
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
index 9e6d4f39900a2..12e2b20e33b92 100644
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

