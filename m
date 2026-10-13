Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B344B403F
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 06:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872512; cv=none; b=GaQWbEbPXxoE010nLrrY05JNVinZ6YBJpzc7mmNZ0tpyk3K9U5BDq2U0JtyotLCKOk7ilS4+tygfBmTcOUqerawxsCmELJmWrc24GB1ymNuqb9WEIbNIvW7b8ntfUY2SVUnifN/A4J/W4odRMpfNhjOvemNypkMEloN53571HPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872512; c=relaxed/simple;
	bh=v2xoffiL2VDz5NojqZv0T7MpCAZB7J4RpYDb1c9cCbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n95wuoEOoyDruDnpvvjDOhSTVqhUiTWaAMnd3MuCdNrFZZ25xsjBcfFFJnzKPUrwBI7uupfKXFHOBx5TQTsmYDMZw10tPSqJMiwhnOvfM/D2mf93X8h3gIGfhP1xorthAzgOB6Y/jYBL2emwxDH8Z+InnjIPq/x7wk5QPHY4+G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=zqBE63TG; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="zqBE63TG"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so1274511a91.2
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 23:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791872510; x=1792477310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=POSn5GjUfqQ74/iwNoPgD0VKPoE1QYtcinfIgdFuRqw=;
        b=zqBE63TGRXvepYvPvyZReCISYe3dPCAhV4JEldeaU9go7EzhQ7/DUukfzXgNnbsCrk
         mMGs0+APpNeFty37LzKb5+7fFNl1eUHujDrYAqUyprbOydJFAAxlB+zxUiJtbFqo0O3J
         8/qOQQjiuL5xYLepRe2wVQdMf4Iv7Sc23Xp+boiTkHAln7oKbZLAa92kCWhP6Iyl7TS5
         GghxE2dsFgUjfAENLoBjgUmvWWEFtvIJ+eQx0Gv6PfFKzOarRVCTgqYaTzCHtr+HvviY
         cHVWFQBFxc9Jaedx8hKmxqj1v9kujz9YYxY+/QmQNYRB8dcIl0iPdHF+J09OAsq60DY5
         do6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791872510; x=1792477310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=POSn5GjUfqQ74/iwNoPgD0VKPoE1QYtcinfIgdFuRqw=;
        b=bMqYOIIBX1KBcArSyUP6Nch3zSiSgV7qSub0fm7ipn/7CCuvvQBu5/WOX3p9zNzLlF
         cjkJTYk7DXZ1xSM+N7eB5VAK3glfjoQaf9Zz+cwATI25SSzgkLids/wgHRvFaKu51UnB
         KA2W1Ms7WftxizpBYMsdp00cmkvU5kqmSooke09BL2usO78YD1GnBwFGDkogLl6Yc3K9
         GCCWjnezyQPNbenkP+q8kpzkZOqpyuPz//85EOh305SaO7qQFXEwlHrDq75MvnyydSGZ
         x+foBW5okPT9khAeSDcIfrY1mWF91xpsWkKCaU1MTPxSeYe0aF+Hf7n7xvAmbK5LmVb1
         GA9A==
X-Forwarded-Encrypted: i=1; AKwUvBzpPpcKHqDTbeeaF34Ou/q0zDRtPsLYT6hBtfCoqbmmk/Z0LhqI+XSaQBGzNg2QpER7/TAZgNYNxq/v5ss=@vger.kernel.org
X-Gm-Message-State: AFq9FYLpyZJryr+8w7+5WNOSlOzq90ixXJYQbKsSPW+GtYMemh9uzzwT
	m3VrxKlounkmZIFeydg47jc7nI5t1acjidVsYghJcT6qiT10+y/NM0ws9IUPu7Vfqjs=
X-Gm-Gg: AYBFou1Dwd8Jw3Y/+RzvbMF76rwVB6eul06cp7eXNLR7gbaiaZvxOIji/bZdGhT2qgE
	ONkbRsLPQr6fD+q5pe+50Ox9Wq8FapZILcIwZ9/B9I6hq/ucHn7dNu+zKXjHyYRvJarb+l8/O93
	dBbN8WVIbW4l06sZsE5aKWdzkoIG5mzbw4PCrAvr2HGovUoLUJqthrfO6feqxTeAH4pSSdGJMBf
	Z0Fs6usT2Nc+IMo8pHvo7j+VfBTeJJoUVgwCIRw8txJlikG+v9ASJj1k/WpMChnnp+QeymtvtHL
	R3LDzxAEa6vFiwahwUqfguGx0+SuZDevqJUmZh6Fvl6eHJChxTO/aaLmxgKAvy2HkexkAGtY3QQ
	IEmGE9XHcSD6j5vETLLbTTK+gKYaSsrE31OZhRePhyjZi9cLHnrq4Pd6jKrKJTEbROp71aR0Hx6
	vUkZTFaeu4nW1nIwn4ID/q5w1N+ZFU+9eDRI2UUGONR+5Q5QWXwr4o6/6YJ6XPMOzrF3+PVbBMU
	H+a2Q==
X-Received: by 2002:a17:90a:ec87:b0:3a0:516d:9f88 with SMTP id 98e67ed59e1d1-3ab3aafbd09mr8834314a91.26.1791872509775;
        Mon, 12 Oct 2026 23:21:49 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab32d3b4f7sm9253553a91.0.2026.10.12.23.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 23:21:49 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 2/2] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Tue, 13 Oct 2026 15:21:29 +0900
Message-ID: <20261013062129.2568405-3-yhlee@isslab.korea.ac.kr>
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

usbg_data_write_cmpl() copies se_cmd->data_length bytes out of the bounce
buffer into the command's scatter-gather list without checking how much the
host actually sent.  A BOT host can declare a larger OUT transfer than it
delivers and end the data stage with a short packet: req->actual is then
shorter than req->length, but the completion handler still commits the full
declared length.  The tail past req->actual is whatever was already in the
kmalloc'd bounce buffer, which is not zeroed, so uninitialised kernel heap
is written to the backing store and can be read back by the host.

Fail the command when req->actual does not match req->length instead of
committing the stale tail.  By the time usbg_data_write_cmpl() runs the OUT
data request has completed, so mark the command and skip the ep_out drain
in bot_send_bad_status() - there is nothing left on the wire, and draining
it re-arms ep_out for data the host already finished sending and wedges the
bulk pipe.  This mirrors how f_mass_storage stops draining once the host
ends the OUT stage.  A command rejected before its data stage still drains,
since the host has yet to send it.

A short 8192/4096 WRITE then commits nothing to the backing store instead
of 4096 bytes of stale heap, and no OUT drain is queued.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 14 +++++++++++---
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 12e2b20e33b92..a37a3ec8e7a4d 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -120,7 +120,8 @@ static void bot_send_bad_status(struct usbg_cmd *cmd)
 
 	csw->Residue = cpu_to_le32(cmd->data_len);
 
-	if (cmd->data_len) {
+	/* nothing to drain once the OUT data phase has completed */
+	if (cmd->data_len && !(cmd->flags & USBG_CMD_OUT_DATA_DONE)) {
 		if (cmd->is_read) {
 			ep = fu->ep_in;
 			req = fu->bot_req_in;
@@ -1090,8 +1091,15 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 		return;
 	}
 
-	if (req->status) {
-		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
+	/* the OUT data request completed; nothing is left to drain */
+	cmd->flags |= USBG_CMD_OUT_DATA_DONE;
+
+	/* a short data-out left the tail unwritten; don't commit stale data */
+	if (req->status || req->actual != req->length) {
+		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
+
+		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
+				    __func__, cmd->state);
 		goto cleanup;
 	}
 
diff --git a/drivers/usb/gadget/function/tcm.h b/drivers/usb/gadget/function/tcm.h
index e1d5a93916127..50764a33cdf36 100644
--- a/drivers/usb/gadget/function/tcm.h
+++ b/drivers/usb/gadget/function/tcm.h
@@ -88,6 +88,7 @@ struct usbg_cmd {
 
 	u32 flags;
 #define USBG_CMD_PENDING_DATA_WRITE	BIT(0)
+#define USBG_CMD_OUT_DATA_DONE		BIT(1)
 
 	/* UAS only */
 	u16 tag;
-- 
2.43.0

