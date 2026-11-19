Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795097212;
	b=MsyRwIRMk9F26zwv06353nwi0i2gjglfP2mXJRd+/lSz5rgipr61xW9VEuP2rdhQte0c
	 W5ou89IwIG0EDpnTw19tJnLXBYjVt7pOPelJ1mfPCm98Y+1kdOQDscq15FROtPI0sBZ7A
	 uFBo+x97y02DOsTcdRuu+JWQOjR1TM8/+e6hfd3P368FElHWsgsjQ5RiW7I+WvxmJK85k
	 8jwtBMQ6aepC3ksQ6mA2tAYlN641EYhdT/7xATcvkGkgrbl4Ftu5+MY60+R+cYtgJtVd0
	 XQ4busMImyEhEa3nKmPiGtpdN2dpVr2n4J1OzuM2PO0MHQLAbfaD4DvbiaQP2ugngdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fKe6Wwe+uM8ct2ILYG9GC0z59MDxTFu3ZRvOh8CsW+s=;
	b=TdCrpspdl8hQV/gOE5m007sv6sgy2Orbdt25aQTM+7Dzb1ATFYlw0k1TT0LrQmYN28A1
	 s8dNYMsnYPU01MsvS1vEMfMLpbcPVHdypjGCv0gBFmIry7VmwHjvBL8K5xVks0DHWCEZn
	 YEDsoEVbDRdN1DHos95J4Gq27gT4WZZDQyXROGm5+RuOCU8wHW90th1+DmfCopzJDroXk
	 Ra30r0BLMU8E3r+uP/E8Fx8B3KopUqMSrAmcBrKisAEz7RSctNs5DQ9AoNjN2OGqQtvoA
	 hiUZ7nab48fEPrs9OhpszNKYqtQHgnA40t2QOiI2qxTeF/04qEFl2YMADNZ59Uz5Uuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qMGi1RB0;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5199606A32F
	for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 14:06:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5199606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qMGi1RB0
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso1123061b3a.3
        for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 06:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795097210; x=1795702010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fKe6Wwe+uM8ct2ILYG9GC0z59MDxTFu3ZRvOh8CsW+s=;
        b=qMGi1RB01nCTpeGcD+3NQ8KonAivL3GAgldd75Fc5LllsDJ78EPnPBepVdshc8isQD
         GxyCtBkLhMMfXe7C3p/WEPYBoH/Q6q4JIYQ0hKi0KmIZI55b9tZJCRbxdjkn7yX6Y5ue
         xELcvthzb2Ac9EbY0GOTePQyt7uUJI+U5qE19R7kqhG0TQP7CZZf3emnB0o9gGFMKCof
         OluppgY8UpuQSl78qEYIpYiWqFBxt1p0PQtvAueAoWMtd9gKK9RoFnkD2v05Ipk1JrbY
         pt87+Ej1vdvmWgIli9h1GfqVjit/v7kmR/lwNle5qY2zj8VUW951R9CZxiAXEd6GMhBa
         /QeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795097210; x=1795702010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fKe6Wwe+uM8ct2ILYG9GC0z59MDxTFu3ZRvOh8CsW+s=;
        b=TSYZ41cuaROJtPIU5NtBoDkBCqnnKcBd+n0w+bUVgodLy+Jl2fKmIuh+fe//ODqsTl
         yEBayw1gAqkrhN3dL9agX0lqD0fozOFMx7VasbE1cwOZv6O+Xo4oBpnGvSf/NAmJ1Ckv
         7IBSG+VU7TXZgcm7cK1R7EuEASAdI59kGLsBKQ7qr65lDh7Ya6JuK3AcrcrniZN0rOw3
         45eNDzHTrmesyW7rvmUEkoiINEQ4xEZSlGkQ0Wc5AniyAoO/KeY+5ffDbZUtyLMRfRkX
         QuTCUNCGNNOiYj9yJ8AsBqeqJLHZuzd2/rmuYaUNRcGnM6tuLA791wtN7L1KGOhUB9Mb
         CF0w==
X-Forwarded-Encrypted: i=1; AL+hErFP9jJD4j4e9tBoH/7BBG6ES8KMH1w3MQ6JIyO8j5l7v729zCW4AddKmetpXQ22f83NqPWtl93vl/j9AX4=@vger.kernel.org
X-Gm-Message-State: APuU4Z83KM821owEjFGNhFbuSCKMdsUF2Rsuo5euHYFX9okx8nbD4ZoF
	5aM/9aHU6xqD9kuh4fRKjsMokaFKLvdNjIVr8B0/Hgj7XQe04d+12IqqGy/c89QVuAg=
X-Gm-Gg: AYBFou1W6va9sXiScmAVcX8tlVdjepBEHpztBnsKR0OtPVAOUUoDypEBAGOp3Ucg2CO
	MPzzAhZoQz84y4T1auYU7bsa/j3SVd0jp1CKViYYW9XJIWhJ/hSZmo6RiA3V9PHTSxorN3sZYKD
	n0ReVX9b5+zir2Y6i5LTJO4E/TRG/JuzyrP33KqPZyuN+UTOZ+wZsNEqJ5EF9Qjn5Tsm6dojKuw
	JP6UvXw4w76G2i19j0YYXbHvL/vfkiEwh/ORku+blwB9ny3/fkhtdPdI+m6Rp94dZijbRb7f21c
	zPwAPVTKAKbXwSOSfi/r3NYCc1d/no0mBJw7KjmK9ANjjQuPUNVVeJnyDYXP8cLAz+UZ5YbL603
	cpnjEiRUpv1UHbazqnbwFnJcUVjIFLjeR99n+e0xKKdfH0YG6DPsMzvmZSguhiQ/cQjhxPWbzYy
	eGXg4w+H2l0/FJSi47Pl8cnCA0hk1XzbPVB9gn/8oe5vxM1QuELnHfJvTeVHXWHFCNPtm8Qjg2p
	II3QS12YSPWn2K/8pQRGLxdvbzLeO2Mq+1dUevJDBVeVjn2iLxvSHnXsEWRvnZMQPrFYhijg4w3
	IjcqeV9cgnJQ8Ar1OjVCw3K9CG5rCFxHw3nCIDp/SDxba8Jo8bX+eYSadj5EThIqlK+kIpBUeRe
	wHlILYrIkTJorAz7uoPWDWRrmOTHQJipn21/Mlg==
X-Received: by 2002:a05:6a20:c90a:b0:3fa:53f1:abf1 with SMTP id adf61e73a8af0-3fe8b6e5b13mr6374216637.66.1795097210065;
        Thu, 19 Nov 2026 06:06:50 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5ca7aaadasm2808154b3a.13.2026.11.19.06.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 06:06:49 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lgs201920130244@gmail.com
Subject: [PATCH] usb: gadget: f_tcm: put the overlapped command's request back on ep_cmd
Date: Thu, 19 Nov 2026 23:06:40 +0900
Message-ID: <20261119140641.2768465-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

When usbg_cmd_work() confirms an overlapped command tag it returns the
duplicate command's slot to the session tag pool and cancels the active
command's transfer, but it never hands the duplicate's own request back to
ep_cmd.  The two sanity exits just above it pass that request to
usbg_submit_command(), and the status path gives the active command's
request back once its response has been sent, so only this path drops one.

The request is not leaked - it stays in fu->cmd[] until uasp_free_cmdreq()
frees it - but it stops being posted, so the gadget can receive one COMMAND
IU fewer for the rest of the alternate setting.  There are USBG_NUM_CMDS of
them, and a host spends one by sending two COMMAND IUs with the same tag,
so the command endpoint ends up with nothing posted and no command is
received at all.  There is no memory error to catch here, so count the
posted requests instead: on a dummy_hcd gadget in UAS mode the count falls
by one per overlap and reaches 0 after 32, and the gadget then answers none
of four following commands, while with this patch 33 overlaps leave the
count at 33 and all four are answered.  Three fresh boots per arm.

Take the request pointer before the slot goes back to the pool, because
from then on it can belong to a new command, and queue it after the abort
so that nothing else in the path moves.  A queue that fails leaves the
request in fu->cmd[] for uasp_free_cmdreq(), as at the other two sites that
post to ep_cmd after setup.

Fixes: 29ed17053872 ("usb: gadget: f_tcm: Check overlapped command")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f39900a27..4dcf2ba0083848 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1275,6 +1275,7 @@ static void usbg_cmd_work(struct work_struct *work)
 		struct uas_stream *stream = NULL;
 		struct hlist_node *tmp;
 		struct usbg_cmd *active_cmd = NULL;
+		struct usb_request *req;
 
 		se_sess = cmd->fu->tpg->tpg_nexus->tvn_se_sess;
 
@@ -1318,6 +1319,12 @@ static void usbg_cmd_work(struct work_struct *work)
 			return;
 		}
 
+		/*
+		 * Take the request before the slot goes back to the pool; it
+		 * is queued on ep_cmd below.
+		 */
+		req = cmd->req;
+
 		/*
 		 * The command isn't submitted to the target core, so we're safe
 		 * to remove the bitmap index from the session tag pool.
@@ -1333,6 +1340,8 @@ static void usbg_cmd_work(struct work_struct *work)
 		active_cmd->tmr_rsp = RC_OVERLAPPED_TAG;
 		usbg_aborted_task(&active_cmd->se_cmd);
 
+		usb_ep_queue(fu->ep_cmd, req, GFP_ATOMIC);
+
 		/* Send the response after the transfer is aborted. */
 		return;
 	}
-- 
2.43.0

