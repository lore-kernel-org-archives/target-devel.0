Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005628;
	b=rtNGdigazynmpn2gyKtPjornGUGMby0Q2IyUM8NkAwcETEOmlIrn/AWCuUfRQGP1rI+X
	 BDwfUXK6u5DHXPqHppPP2LyNAJ4f6WhOllUrwSa5UoP/UtjdjFX6Z+lxS7vva33fxn/Yo
	 1ykFLmyKiCRXO+INmmR/VHT/PicqYoVFXG8ket8pHfx3bWigXKlJrdJYbdjZAcEOrndDB
	 oVrLO5VrxaUjJo8iFZhO0p8Qhd+WnBq2dyaFlKz91wjdlO6SVVYHEGh6dniSWI2oAZZ+h
	 iHsn/iNVml/uKnVME24yPOFaUSZmSeytjColYJ2Zb+KscgHItsC43T+z9rIvp4BtuxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005628;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1fLgAjtCCKjoVBG7/UvopeS2Qcc4ohL10xzSiTgRuPw=;
	b=kh6vDHdH4O75M9yNS2NQdVI4SaU7ei5p1YTZK8O96YVBmvLAI7QK0/13pR64cvgSnSyn
	 P35v+xJGZIh2xQ9t1R7mG2QF8w1npDtP5F5ckaOhGBvewrnFUc0NX+sHu91vsdEqnIf+Z
	 uwVQpo2OtIWFSwlj8uZCAJ0AbHV9qeFGJfrSMA5nOr2MW6VrHgb50KvlRT4Eq/Iu+h3eJ
	 x83BpPsGStBnCpuhWzTwSDKclGtwoQoE2NLH3jy35JWxRbh2ECQOI7PTJTLz4U7CMsyEu
	 40pwdFUlTTQjHHx1zJfdpMn8EoOJQ0iU4sRCQL+ARKR3+sRA9jH6mljccVbG8Aqt9iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=de0KmxCO;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C65606A339
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:40:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C65606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=de0KmxCO
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b3a914e4c8so523622a91.0
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795005627; x=1795610427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1fLgAjtCCKjoVBG7/UvopeS2Qcc4ohL10xzSiTgRuPw=;
        b=de0KmxCOwsMT+Q7JG1G1Ao1bVgvmu+KIUWF9XBL77XKi9Npqia5BWLthh6/AsNxofe
         1AePDOzls+Y6RTUFAqfPuBUWKytnR9wa6yCFny5iSPUChNKwDZVA3/fh3IPY/Ka8cAUe
         h+95ROccfHwWHlm5nAQvOevgnyqR0zlayv5PtMzt8EXLJSBBM+PrX7iLMllfhoQ9j5kS
         R9jzRgOkMQgtfKiVfKbhM04l+w5fYDd/ElyGfDecjbVVmS7tnXBVuR4Tm2GpsnVAjele
         n3l4ZT4bOvxsHxJLj/Cxj3gCT9M7wuedB+U/0ywgkPL574Y8FPwuOCyem9bPkIcvvIMe
         24OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005627; x=1795610427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1fLgAjtCCKjoVBG7/UvopeS2Qcc4ohL10xzSiTgRuPw=;
        b=KymfuR3fwPw+UdsRTdZV9VzBI+6/ZKBGS1BC0lzEIIZuCTKIP69PwTNILLJiGQkiOZ
         AH+2WZsF25h/qL8BIExdVve4bLAcs2U4Mo/mtVhsyN7FSJJeXEjUKlIcRVAeJPdukcbp
         tHMTJ1WDKOGmG0yq0ye3P7V3tNYTDrNkW6Rq+BzQBodkUfihtjZH372fIKNGmr8qUvmq
         SxXNlVoBoBilxVYc04WiUeD24LP4gSZt6D+VurSwAIdYeITFBK7KUgnABFBSCybOjJLS
         ohs9ntSfu6egoAnGuO/3ZFmHuqlrPvx0KjKo22ZaIxNGx8SwA+FgfQXwNLF5OFy5WH/X
         X9dA==
X-Forwarded-Encrypted: i=1; AL+hErGcdjBxb1Mc8Z50rbRWJHU1xz9mtuZiD8nm17p0QOe2zEln1fBB4KF5SnwgK8M4uHJlxZCRC+Yqi/EaQ3E=@vger.kernel.org
X-Gm-Message-State: APuU4Z90Kj7VJGpsGDpX8K+ymM6ez38/VpgItLo1EaXzBHsltGP8eZja
	092OuW2Mjvq/+ihu/9HjfuNbaTWmOc25zq93iHMzx31yIpgR0d9kZ246NY7Rl1SJB/A=
X-Gm-Gg: AZFdTZeZOMIC0T5hxbEvw+8YhpqC/T76P4gme7x2VaxVa9LIKfLYCFl48/jQuO4Orbn
	WNkFJ3QfSN968FJXSxC/1F+dbQPq66CVejh7CYwZ9uWTv7Y0y3brGIMnLxVNTp0zi8e3UMfaMIy
	/zimIQVriDgKdK/IW6ysGDGam0mEsqPEd3e6/gGR88qNYj0hugLzZ0GrvoqTfMB2Mu2NBho11vi
	IIoHsXl7VMLLJfqgjWaZgkswIeYOfbq2JFtuu/NMxgulnnEGJCcVh/Id0Pbwhs2r21s5v5OahMF
	er0jSDS8ZwUb7Ri8GJEbdPOyvyk3PoIlTjY9pKMvO9jVu3BoUNYxVmuDo7EWo85LfD8aTAoxFuY
	QdbWpnhj36QDorRbUVCVCc/Ti7d+SFtg3q8H/z8HoNc2Z+jCrQSdPACVZ+mifF3/uA5Q6kG+sfW
	szDiQLnmALxn7vE7T3s2KZRJkFkvgC3mV6O6PZYR2y22s4r4dEYF8NzoV33DZa4yy0TYQEF0w7s
	VSDf+hBLlKIj4jIYETlIsT79BzWGnwOLMUjyeTuPeZ2UL58I6lsoIiXYBp8OPURzhElG9+zG1u2
	RrcNF/nJ+/mZcnAgXX1c7dlNA48HhlWv/jOzXeUPyC8rFtuwKKxSQEDDsv9hDOgWGlWGh05YdK4
	SPze0THYWPZlJE6VKgQ+G/CS9OaydRkwQEIFY/g==
X-Received: by 2002:a17:90a:d605:b0:3ab:189b:6980 with SMTP id 98e67ed59e1d1-3b3d07d4100mr2663097a91.39.1795005627059;
        Wed, 18 Nov 2026 04:40:27 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d19b6e18sm4257980a91.10.2026.11.18.04.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:40:26 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	nkapron@google.com,
	linux-usb@vger.kernel.org
Cc: Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com
Subject: [PATCH v8 3/4] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Wed, 18 Nov 2026 21:40:04 +0900
Message-ID: <20261118124005.2428068-4-yhlee@isslab.korea.ac.kr>
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

usbg_data_write_cmpl() copies se_cmd->data_length bytes out of the bounce
buffer into the command's scatter-gather list without checking how much the
host actually sent.  A BOT host can declare a larger OUT transfer than it
delivers and end the data stage with a short packet: req->actual is then
shorter than req->length, but the completion handler still commits the full
declared length.  The tail past req->actual is whatever was already in the
kmalloc'd bounce buffer, which is not zeroed, so bytes the host never sent
are written to the backing store and can be read back by the host.

Fail the command when req->actual does not match req->length instead of
committing that tail.  By the time usbg_data_write_cmpl() runs the OUT
data request has completed, so mark the command and skip the ep_out drain
in bot_send_bad_status() - there is nothing left on the wire, and draining
it re-arms ep_out for data the host already finished sending and wedges the
bulk pipe.  This mirrors how f_mass_storage stops draining once the host
ends the OUT stage.  A command rejected before its data stage still drains,
since the host has yet to send it.

On a dummy_hcd gadget, a WRITE(10) declaring 8192 bytes whose data stage
delivers 4000 and ends on a short packet is answered with a CSW status of
0, and reading the range back shows the 4000 bytes the host sent followed
by 4192 bytes it did not.  With this patch the command fails, the CSW
status is 1, and the range reads back unchanged.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/usb/gadget/function/f_tcm.c | 14 +++++++++++---
 drivers/usb/gadget/function/tcm.h   |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index f2e7a9ad77809a..970dba09d75e4a 100644
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
index e1d5a939161273..50764a33cdf366 100644
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

