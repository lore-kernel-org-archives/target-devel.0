Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795195734;
	b=l2W1PANTEpAL/7PE4gvURGNV4TiqzOXSetQ1uC9CiJ1qGUY08XNuGV3AIa0LvUDyTWs0
	 HH1sjk2O8qrkZAhePe+6yh6iRh1cYk1Eb+zVvnDmCZJgbW8TLv3AAVSbQaqC/0+0B8pTb
	 fbgWECd5UiITIy3+f5bPHs094P81lTli1HMjA11kiiKz1YQANYlzknRoEEM4xVy+EARGz
	 SnOj+xX1+P+fl7lidSUaw7ekaEPijJ8z7eM6Udgu/VeiqT5mpICA8g0S0nnHXCSst5dze
	 Lk39K7KONEhDoZIkaPfEB5oTiMBfNTzDOCiuydCcot92SHAtzQ5nBgTcAqsFE21e+IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195734;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyBa1qYdQn+iPfoA42hZVookOq748rCRVECzEXuJvRc=;
	b=CdPKEbgwUZhK7zSvpgQpmo5LMcFX6xfoHSTSw19p3+OKkz2xmsaWaVBNmfDiD8BDECTl
	 1gpXC/now4Yosk6Crf7OQGW4pO3GwpTWDvaDLND7DRX0YqiHuSHhekbmMGZW1dopLzbRq
	 RImAxL209MEreD9ZKiHkUWkDvlxzssMDqCr6m6D61i1S8LBetbL+Ijw+HCX1etX51XqPm
	 GLyUdUZWEi86SXek0gzaquBC3wlfDnyjqlPRprJAXyNyPXosDM/cSgWMmD6quYnub/yc7
	 thoJ1WAhhelCzCdQkZwJBcXd0PpJHWxT4K+QaU9ZW2oV5E+8Vc6C4K0EPbXRJmUp/ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnWs1XMU;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79D060A263B
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 17:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B79D060A263B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnWs1XMU
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a06e79e152so622521b3a.0
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 09:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795195733; x=1795800533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EyBa1qYdQn+iPfoA42hZVookOq748rCRVECzEXuJvRc=;
        b=PnWs1XMUfFDo4imkIzgO8Eef7daylampggE8X/caLT6qMzzb+/AYGi622TouMxSUfR
         Gb1oWHjIfXh4u7XfYODyeg41vf9ftHkikVM0ahGw7dFpihIXTd41GfswSRLFX+j1fW7b
         +XPmawmrK+Z4dMy6+AT9GRfHKYLKy/hzjkoFX/Xyr+BpG1x5xiP+SaBiPgmjCjmMLvc5
         Fp5goRuXmLstA65pUmlIhNvY1+vwHlKazsL0USxufxNhwWQhCW2sDMgKu1HJjVzzRrSG
         +fgEzKNQFUIqKr/KKxva+WLOCRykO1LE7Z+30ssryEXEe9ATzYcKoxL2p3Z0Ox+ut4Gd
         jXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195733; x=1795800533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EyBa1qYdQn+iPfoA42hZVookOq748rCRVECzEXuJvRc=;
        b=uWBD6w0Tr420Qk18W6mxmmCUSHhOlJq45+UMzeUeWAamHU9DFka3ELhMXLYYKl9y1w
         teaf2iiwHivvhHbqGuTXI/2E/ikOH+UXXo/ZtbOsSOu68EsLc7RDSZlDghsrDzpeEgZQ
         8ikk7BZ64qC6kmUJVv3cSmftcG27xScCs85X4WYMGRvVSdiUOplz2v7ijyzVskoM/BwY
         AOeZ1DzLlzHG2YgU0S+pSOirBKASGQdeafHovm6mCJfzlYBIKq9G9a/3voRS+3riHs3j
         5+cG+d83UEt8JtEBNlU9ou3Zy2kFcw9j5bx6RzbLZb1zaN7/y/3PsKulkFtjC51Uu9TY
         LrXg==
X-Forwarded-Encrypted: i=1; AL+hErE5lqPowQ2urkTCQ+GAhdHgpEnbz8eZLdXNsSNR0s5vyKXXZ0GUUK/LK5cu5OZUnO/9bHmfpYPot8MWvwc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+MLB9xH+VD2fak9DrhWHNtsvQrg4VkP+MY84+MvKFAOsZt6hum
	TTp5P0QXdFZ7foGtF3yrM1GWRjI59v4xiVBlVQMNfWS0uoBDgao8+yscBBkZFcPF9c0=
X-Gm-Gg: AZFdTZeCN5Gg9felJnChIV4y8257Y+4nhmv0WFBkTfR6oVccrjngg3Pxbd2tY+uM31v
	exF7/IowiheF0pNHGn/sKvj45SCUGOwVy+gWd4zXWRV0x7aiV+til55H03fRH5C6UvLzqf5FhE4
	ckm3TfzOLy+OR0Uipvke7d6exEEZV7ItirSxGya6CfeDedrjRREQNbinMAUFNRAOvQOBHLQq/VI
	idRxqNALmizHmGjd6a15XR+N3wOX+jGiTGs5AsKO9AMIX1GLBE4i3LtpM1xycuEQ3fmovkNzGPX
	+unQI3eihkceepoHS+cVPP5FzJYg9wSmKSgt/Fao0tzLnEh/o1ZfYkLvfvl6wntuXEfeNDnC7G1
	Kh/MT64jev0HCFkfLIxOvNR+TqmCUNCiL0+5AQQIVz82OgVA1LZUcVulLrSfskhGRsYv6jjw2Pk
	+b6lzdX2AcclRdGKzq0TdpEZ47Q9b2w8R8J/c5G2wa0Q24X52wUBV+FoWYbP+S/jNs4P8fko0Qq
	/b9uowdadvHKphGomM3eC0z4+5qZ1z0IVb9ESMGDpxEJQRMmyRrsUbXw0SMm9m3w6ubwpbZ08eI
	GXJqNLK8QbuV5IOfvwQMDG/Qz1yMNdt9DewZ2cjx04iyzojvIxxdv2FB0q+mHQ8XksDtl//uaTn
	ONWkzDzPEVDZR0Fy2dl7pEI2CTmzxGq0HEH6V
X-Received: by 2002:a05:6a00:3c84:b0:8b6:4eec:f501 with SMTP id d2e1a72fcca58-8c87bac51a0mr3657544b3a.14.1795195732839;
        Fri, 20 Nov 2026 09:28:52 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87334890csm1867911b3a.33.2026.11.20.09.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 09:28:52 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v9 3/3] usb: gadget: f_tcm: clear the scatter list when reusing the BOT status request
Date: Sat, 21 Nov 2026 02:28:29 +0900
Message-ID: <20261120172829.3286180-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120172829.3286180-1-yhlee@isslab.korea.ac.kr>
References: <20261120172829.3286180-1-yhlee@isslab.korea.ac.kr>
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

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v9: move the test note out of the changelog (Greg).

dummy_hcd does not do sg, so this was tested with a small module standing
in for the controller's queue path, dereferencing req->sg the way an
sg-capable UDC would.  It reports a KASAN slab-use-after-free on the freed
entry for a read command followed by a rejected command that reuses
bot_req_in, 20 runs out of 20 without this patch and 0 out of 20 with it.
A normal sg read still queues its own scatter list.

 drivers/usb/gadget/function/f_tcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index a8fdb24f9d94e5..b21db34fe2a7ac 100644
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

