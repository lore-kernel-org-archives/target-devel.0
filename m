Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FB8423799
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 01:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856476; cv=none; b=RJ57QMFfGAy37iQ8v8/6E4qyTWhvALl04TngkMUC5lexKkzeDwDt6z5X6+hqeIfUqhb77nvvuQ4JmLKZgBr6c3GvZZU1TfixU8P6ww40lB3Sig1ZHFdwf7NLoz7k84uWLBjtQYqDIBCEcByxoilVS3KOmnCWgM3i7D1XiY7v5N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856476; c=relaxed/simple;
	bh=/69Sv47VBWsaTNMZuDaTDKZqe8kA0nRBFTZSsIuq/gc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F2UMSPm4NszY2/jYIa7M/CVXGIKbwhq+SSBAe5sIXt5hhBuJElIpA58op6WB/JqN8PFeGSATT6znEkpS7L1+2ElcGyENds6xo12Cwi3P2OauXrS9KlQdH7AK+KfANauCXzmfuOiTUiZm1XXKHqIw+KcOsFWev70Uk3TEhrZZlAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=GB6y6bhz; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="GB6y6bhz"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1400201a91.2
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 18:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791856474; x=1792461274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xjxQ0USZRooNIDC4VoMJ18fwWCMaS8NDpeUyYcJZJ7I=;
        b=GB6y6bhzq2hhHjLR25ibg0iTq6/TETz0n78zH1WRy0Q4EzgcSqksFCNV+NtmQUTW+j
         L2bz/w9BfFpNmOi2E+80GGM0XKkNjDLBmhoJfDaVRZwCnZ2BnaghCUtKLMrM+Qo0owCQ
         NkyBGh7l+0WwTiuvZ8kcFLaEOASTiRTeaXr2cM6NhuXG0+vb4MOW3rV5PQpEfhzwbTsU
         4PWrwXtS7iGjJQp8Jdz5om8/lBblFaI/HbfP9Ls0z0LSJ3celNLMfPN8S+agx39VMVqW
         9N8wYZdpk1uOu5oF9W1fq77LgaI619JkLagzUTGhkKXOBsaa45uDgvK1fAV4I3Yj/YHt
         LpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791856474; x=1792461274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjxQ0USZRooNIDC4VoMJ18fwWCMaS8NDpeUyYcJZJ7I=;
        b=K39O36UZij/QTDhdp3K5Pnxq7PBIpVI2jFoJ8JpDbSfVnPrbsKHH6sbnW4zj0l0Ugi
         WKoqezHOiouL+Uq/rQGaEvN4n9h3m3xkoJ6ncoNRROAQfuYkh8PTk9+kohqmVU3mw/Ja
         poy7/BDkfFINRYOifXEhEYh7gQD8ybCzN8z4xKFXa+GlKMSyNZOMQGdgZ/lOBcFe+oUF
         gD5JfouPUnegfBdquNkzm8/n7eGOHhiN84dw4SsvH2b6m7wbML7GM+GXQVaTzfTZlenf
         1Az3U3xpabsP9I+PLBZlmNbVBj+cZlbWAV+1i59tGwZT2nJWGdUVK+Nl7+uUKhGYiMQf
         tl6Q==
X-Forwarded-Encrypted: i=1; AKwUvByeuYfeQ7FNCpZwt7uQ2ex9pHMmfCI9BksO49bPwZFJH01Mjl8w4WHvKbQpRT3SZ9Yex8HFuk1orp4nZNw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLIXB6Br3WWvcOMTFf68UXTHReQbvWG0RVMoaJ0/AXzrmxVffB1
	FocxycuuUzwD7u4yDMFgGdYtcO0N3vPhB+mO9dgsD2elgkuFnQC1I6rOlASl05sqxJ0=
X-Gm-Gg: AYBFou1//paPXvQN2/RMPckzCvhqDJnTZaaHm6kRCfBXPEokBGIABLLaw1sD7Cp+54W
	h3xItyNhvBPtCVYbKFUaESN1MfsnvDCN5aqI3+FBSvGri9JYKSJynWaIM0kZxoArnkd5KElLMsJ
	eoV0Kl7enKuBMBTiKESgUTvZFfVqbUeAXg9eE+KHAolcE5tkg1IP07SSErcpc1CobGGld8yV7nA
	M5MENoV2ofY2wXSXn9/cfOBjI08pYqnKts2vjx3ma6yGbhx/Y0smwNZQhCnmoN3PiQR4DzEsE7S
	sbtptDQbdJfClKl5XnptM2VGZBzSBPIAoHF4ZfznH+G+jcD7hui8iykS3TwMWEOLjYrZgDEAXP7
	ZzoFrFPR2AFY/DYEucr+2gUdBVf2JMac6uVNUvAglZRlO1w8auqp1bQSCFxqw6MN5ZmYmoCtwvO
	+RdEajJlM6PIvhPWVH3Benp0De5HIgrRNjYXVkUde+yb9QQ9bXIzRMUtJ018/JXkfMZEeoTzwS2
	bd+dQ==
X-Received: by 2002:a17:90b:1d49:b0:3a8:5d57:a5eb with SMTP id 98e67ed59e1d1-3ab3ab5a60dmr7458025a91.15.1791856474526;
        Mon, 12 Oct 2026 18:54:34 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3781d581sm19057755a91.1.2026.10.12.18.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 18:54:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Tue, 13 Oct 2026 10:54:16 +0900
Message-ID: <20261013015416.2503787-1-yhlee@isslab.korea.ac.kr>
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

Fail the command when the data-out is short.  The OUT data phase is over
once this completion runs, so clear cmd->data_len unconditionally here:
otherwise a later BOT CHECK CONDITION - from the short write, or from any
WRITE that finishes its data phase and then fails in the backend - takes it
as outstanding data and queues an OUT request to drain a host that has
already stopped, wedging the bulk pipe.  Rate-limit the failure message,
which a host can now trigger at will.

There is no oops; poisoning the buffer and ending an 8192-byte write at
4096 bytes leaves 4096 stale bytes committed before the change, and after
it the command is aborted with nothing committed.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v3: clear cmd->data_len unconditionally once the data phase is over, not
    only on the short-write path, so a WRITE that finishes its data phase
    and then fails in the backend does not wedge the bulk pipe either.
v2: fail short data-out and clear cmd->data_len; rate-limit the message.

 drivers/usb/gadget/function/f_tcm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f39900a2..cf6a394c4196b 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1090,8 +1090,15 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 		return;
 	}
 
-	if (req->status) {
-		pr_err("%s() state %d transfer failed\n", __func__, cmd->state);
+	/* the OUT data phase is over; nothing left for the status phase to drain */
+	cmd->data_len = 0;
+
+	/* a short data-out left the buffer unwritten; don't commit stale data */
+	if (req->status || req->actual != req->length) {
+		struct usb_gadget *gadget = fuas_to_gadget(cmd->fu);
+
+		dev_err_ratelimited(&gadget->dev, "%s() state %d transfer failed\n",
+				    __func__, cmd->state);
 		goto cleanup;
 	}
 
-- 
2.43.0

