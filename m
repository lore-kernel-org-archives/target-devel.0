Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E41368291
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853160; cv=none; b=UP64hMwZal4g/268Z3k9kF5h9EEABWAxOl8EQl0NPhyyyWO/LeyrnY46doOiskKAnAtYFtmPX4+Kb5Nz76gTqlCTqShdr9vtsGIdIzZS5bp4wW7C83lJByHX5wyr90cAvnDYPnS8P3CyTZgSHx4MFkdY9oZq41FC/fenj+x1tnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853160; c=relaxed/simple;
	bh=7D0ueLF5U0UC1KdmFom1A5HOnKTONJlWgvjZkLkoPEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U7qpoTMKhSH5u3gJRgOTTrNSUU4xzmqdCpUjlrHCh39FCKgUP5gmVYKsN4UlgLsaczP4oSbOOx0EhxSFCxYtWKjDJm9ZHNnRypzeOdKvr09Oe6eVCTHd1J6U0GyjhSx7w3f8m/3+0JW/0y+tp1g4fq9ZINZ8HxAUJUTX+BYKvmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=jYv90Qb3; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="jYv90Qb3"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e60f9af6e6so20431785ad.3
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 17:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791853157; x=1792457957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KD/O0ovUlmAuZHc6X9wXGWv7XROc25F1YO2O1JLs2oM=;
        b=jYv90Qb3V8IYczVtrMAn0qtBmM0TuNKlRGrB2CJQYO6A5aTycKQVnHCNCojteZElFK
         ccpx9tLMDiNFuha3hGDHEBhEB7+fO2FLwbnh80d+ROil2ja6VqAmefFq8eAhaeKMxiJg
         TB515+dhw0YEeKK7jc31aKOr24HPlq8QbYFURTZrOCXuDdCT8IPjWvmc+x/nKpWfSaWv
         i3w2c6yoAfLPJJeiQzIY1l7PHpVqDc2+xpy9WrfSQ8T4iKVB4lLQUKijxy4jc2Efiey3
         mSFUFSj+4R6s/X/eDXbNRV8b3RIT2iX3KT3kgP9FPgH7CGV2WYkNQByK3ffbaiST0g0o
         N4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853157; x=1792457957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KD/O0ovUlmAuZHc6X9wXGWv7XROc25F1YO2O1JLs2oM=;
        b=RWKk31BhAZQ9Qmh6Z9/M7BsF6Dyaf2dOyz13JsHFgunLaw3q3a86njGugt9nKbtClH
         wtfn5/IhTl2x+JoWmievE2KaoYE7Y5zHLFa7d9jcyPzghf56tzyAeZ+qSzLTJ7pAHMFS
         kNLgpTeJUAg2OwM34595wvKF8VsqOGH46Zoh3CvhVLFGyY9v2zu5OyDCi635GwBKuUUN
         zcUeXl1K4nmmME69hNqdqdEwR6lLAqsfe7S4+41l4BdvFbc+iVzU8C40p/dxT2lQayYt
         RrP0gDR3b0fB6uD9UXH3Not92ljkzw8DD7Z5zVLMAk6NuwwmnppCaF1U+VJ72Vhjq2q3
         BVnQ==
X-Forwarded-Encrypted: i=1; AKwUvBzisePhY96SquZ8FJ6RWjzmO+7CVzckUa26M+rWy/FoHT+kHO8u/yatlzGZiSSJ+wBNw+WEOrU66+qrlEA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJX991QgPYIY1yu4m964YDP8V4VEo7n9EgLN6uQqvniq135lPDj
	KEQR8mzLM/zNRa+cfiy3uf7lxFElRhFsVJS1yB8rQszIJqCIIHaFVsttCWWbjNjq2yk=
X-Gm-Gg: AYBFou30pJ6F1Q/6bJsmPR+Uq6NzUHgAmwstkDkTS19j691V54ClJz5MgjSaXvJGYPy
	8kydbeMeaQipKu+6Fbb1GWT8WgcqJN5bob0aoJwVD6H6KgyAu293MwaFX+lRkmbyMQHNz82huXe
	mGUWVQXRy4NScwo9+KCtSAKnxSKVt/TfaFde9ORCI+5Ye4Z3CYjPh3A7RZUgvYXI1wulS1mFtRy
	W7HLfw7CaV8mvIgIGxphsGKYRZ3+bocNkMmoGZe3IqwzwtZwVbgE2+zHBFaM9CV5fTSaTRKDfAV
	iDAN8DI6lDCrAsykchte79Ak4UAjdRd9EGolxmqFh1fuzsHuJ/hIzrnwu31bQgS9WfNTdUhwDpc
	AdkiTONqbtfYzA0kcyO4DY/j/nBzz6AiqMUGVGFCRuUPeSqZZxjOGJqW9FhUFOJ5BvwbD5Qzaei
	Wbs7HTWVhv9rKmUQ2vXMC0W7ms0hnDLJsYqNlwqH4mMTf/adl1MJ9XsKaepxfiXvnR+Z0E5vn8J
	URiAA==
X-Received: by 2002:a17:902:e888:b0:2e8:4078:84e5 with SMTP id d9443c01a7336-2e842cd449fmr90537535ad.20.1791853157038;
        Mon, 12 Oct 2026 17:59:17 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e1643sm49225935ad.70.2026.10.12.17.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 17:59:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Tue, 13 Oct 2026 09:58:54 +0900
Message-ID: <20261013005854.2470384-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

usbg_data_write_cmpl() commits the WRITE buffer to the backend as soon as
the OUT request completes successfully, looking only at req->status and
never at req->actual.  A host that declares an 8192-byte WRITE but ends the
data-out after 4096 bytes still reaches target_execute_cmd() with the full
length.

The buffer is not zeroed (transport_generic_new_cmd() leaves zero_flag
clear for a data CDB), so the bytes that never arrived keep the previous
page contents, which the backend writes to the device for the host to read
back. The target core refuses a WRITE whose declared length is wrong, but
it does not see a data phase that simply falls short.

Fail the command when the data-out is short.  The OUT data phase is over at
this point, so clear cmd->data_len too: otherwise the BOT status phase
treats it as outstanding WRITE data and queues another OUT request to drain
a host that has already stopped, wedging the bulk pipe.  Rate-limit the
failure message, which a host can now trigger at will.

There is no oops; poisoning the buffer and ending an 8192-byte write at
4096 bytes leaves 4096 stale bytes committed before the change, and after
it the command is aborted with nothing committed.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: on a short data-out also clear cmd->data_len so the BOT status phase
    does not queue an OUT drain for a host that already stopped (would
    wedge the bulk pipe, reported by Sashiko); rate-limit the failure log.

 drivers/usb/gadget/function/f_tcm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f39900a2..cbe64f934724e 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1090,8 +1090,14 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 		return;
 	}
 
-	if (req->status) {
-		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
+	/* a short data-out left the buffer unwritten; don't commit stale data */
+	if (req->status || req->actual != req->length) {
+		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
+
+		/* the OUT data phase is over; nothing left for the status phase to drain */
+		cmd->data_len = 0;
+		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
+				    __func__, cmd->state);
 		goto cleanup;
 	}
 
-- 
2.43.0

