Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5F04B0C98
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872509; cv=none; b=bFpEitMCnLEeTkgR3BuN51isV4p8PC3il8rsUqGd0AHHXrWRgz7owFw0/thq1zsDHZUgahib74CHryebUAnnFjOkrkq+qLnIZZt4+y3lf4ylqHVUahG2diFJdRY2gsoVDMMGp72qCcHeykx+K3XWkm/6Z/OwO5WEde+nKuVcFWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872509; c=relaxed/simple;
	bh=yKooLcN7CHgsaZDkbyO505c2en4X/luvbmOSMQrltvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X67kk2AAFOpAfXFBZRS2L1yS74JG2U91kfLZdCxqlj7Skm/VX0EtrZMwF5aDj/bzD/58HJ2EaqYvjTiW8QJzpsyZWR3gvjsX4KBM7o4XssIQs0Kr9Rjihme5dOwkFEfQVIeUFkAsrzNc0dC/B4IP+e9L9OWFP+MyncywLCQckGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=QJ1kEgx8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="QJ1kEgx8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso130106a91.1
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 23:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791872508; x=1792477308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwgbOTwZS+Wdyws/KBJ7MPJ9pBsymYg2xZOg5DiPzmg=;
        b=QJ1kEgx8z5465tqjVNSNRin25Dx7PonvzJRGqMcfEU+2TfvhEqn53+CCvAVQBGmNsa
         nKZhPERxK5QFcDZIBMDzRNAidFYuop/ABZRdGMNzxX4Wvx8bhn2acu3xciVxp1lkFZe9
         VILlzqWvSDlUHLv+hbg3GRXF9HKs83WOII1LFUB2LjXlIVvWBTyyOm/4rD72Zj3VnKBF
         xnZGPqfFkN5LmWE559jUYfuqpg+RieZKgNl/O8f9eSUiIe8wrssk0tGDJg/5nWs+4p8g
         gQ48K0EzR/H5j5phqdo1UxJyGk8XbSu6R57ieAethjJzUgLTfhOQzA/b+06NRViTDAJy
         mptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791872508; x=1792477308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nwgbOTwZS+Wdyws/KBJ7MPJ9pBsymYg2xZOg5DiPzmg=;
        b=Ty2K0PcB9Ii5tRMeM1ekmK/kWh2uvkcb4fEDZdh8s4X3+xJ5D76s9X5YRINhkWad4t
         rkR4HIvArG4Lk0J9tnVjgYOnvNMcRceP+cMVKgjBv/+HM+2DUuqqXrlRm2hhJWYh4gGQ
         zPYdWQmk2RN86OcpUD/lzyZGbonJ951tRFwLw/dxK4T3YaZmpmA8SRZvoCqOTh4zz+zO
         U51ffHUvca0yewXiFdr1UdGtSfubVK4peXNaHRI2L8DUHxJgMBdzKKDO6cmyDRFsy13L
         q7ywj2e81xYtT3V6+WobLAgcBxdrGkbj8+R8asXtXq0nc2kRaVuafhwIHlj0pg+wpMmD
         qjXw==
X-Forwarded-Encrypted: i=1; AKwUvBwWFxRZ6iYgSuhldce/Md7UXIpQaY4APQtF+MJVsxXUCmsh9Fh+TCBnkN10/tjdpoHuRazHe6Gqa+nluTo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIH0mVS0h3BU1cK7DPtGXDBNC+8RtbQOpElmB+0k4xn/EArf04f
	gsmlR6nd2uSNisJwR8pH/R1quXNlkT/9wZt1VINHgNUD/Zf/1nPTpl/FLgmcyWeAcLA=
X-Gm-Gg: AYBFou1SB2bRb83dWhpDUFh3t4eXQBSthRBUyWbEfzL2gN4kF7vCqX3jhNEIDx2SLHS
	4AMjA9cmelhOxzkbv06PuH2vQuP+Io9Hu8GPfbC3BVEi3nvDLLezQSpgCMMtJ1fHtOrRNdzpjga
	895MI9ICE/nu2+GJ93jgTHr1DSKee7jKCULU64yQzJ/wU0yqOd1yrY9Tad0BVbWehb2KotyPDJG
	M+J9gR5mhfzDvlkqROK8Sfal6CD/r20+MVYabUJpTnDDaPs4w27OwmhArS+LRj6NNs2UHwqSXBa
	YSmt+LPAmqdtBEB7qlKJW2w/OwJ5+kz0gpkWDSJCAWqmfjzycUIH74VWH58PjMlX04zHCfl0atJ
	JQvgu0qfxvB5UnbBz2IMYTiBYdWsRghKoMWq+r+jctKB5aT6CvE8v29bqCscv5bFj6xprk7pcG7
	iey3m7cD0WAuf1JxLGC56xH4WDcwL6eoxsMmqQM1ULSeDSHR5j8iSWvl7LSUSefg0cyKUyrarq7
	nD+5A==
X-Received: by 2002:a17:90a:d450:b0:3ab:364a:951f with SMTP id 98e67ed59e1d1-3ab3a3593dbmr7775494a91.6.1791872507175;
        Mon, 12 Oct 2026 23:21:47 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab32d3b4f7sm9253553a91.0.2026.10.12.23.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 23:21:46 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 1/2] usb: gadget: f_tcm: queue the BOT status requests with GFP_ATOMIC
Date: Tue, 13 Oct 2026 15:21:28 +0900
Message-ID: <20261013062129.2568405-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
References: <20261013062129.2568405-1-yhlee@isslab.korea.ac.kr>
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

