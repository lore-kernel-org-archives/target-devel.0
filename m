Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142973F9299
	for <target-devel@vger.kernel.org>; Mon, 18 May 2026 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106717; cv=none; b=GF12Ao/3cxIapggHVPDNu5zLTqBzxAFS+dD80GBemdOANLrAcHAK7L+SucfS18+26sRMuiP6F3PcODrR685g8CtwNAUo7Cl/diLD6gVD46J436iU3UWtyb17PjlWxKHbGz2RZojbnZjLSzJMonGL+kcrIZTuRuBV1SVYRaF9ooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106717; c=relaxed/simple;
	bh=4Uh3eQNG1AzQ8+Z/3G2EaHP2yuu8tI/1ewQgpcXwoSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uyZPOKBl9/267iTbi3F0tM1hVESQpkGWreKeN8B1Iaoc6Fyfik9ybHK39OjzsW108kZOyt81SmagmOlH2yO0brIn5H1EikPNxsXtws5b+qfkjU3K4go5kL778FMPpTA58xcMUAhCozATFEkB0vuqe4REGBlyhd6883nNn3H++Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNHR5HHi; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNHR5HHi"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd5047a2a4cso376436966b.3
        for <target-devel@vger.kernel.org>; Mon, 18 May 2026 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779106714; x=1779711514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sUmwK/E8k0/+bmmnitAn3thbhE/x2wsT2IrX01fre1Y=;
        b=XNHR5HHiAin54LUGTCXqPOGiCVfjzXfUfv9IkxU8pnXfYfY96DkGw8aQG3nXhzEAwj
         +eczCJmsg+NQNbCg5opZN6BLAJ8SQZYVjg4kVN3Wf/rQtZpVLe4nKk3KC1quH0WTOC5m
         rzZ1FYohAIrjDCC0Owln6/cl3cL6ctTHJORLoSorM5Cm/lDaPc9eeQJICOx6kR7FgJLf
         SGTFvW87eXDavUi7+PjVduuhLlVJVSCxyV8cKsCtjnXhFQZJgZMieC4AtaouvRx7eSNh
         uxVW0kzDTgaZWHkhhxva82iiisMLRiR3Um7WVtEO9fsqzAh+//ByPsopqn3YutA9Wr9O
         0pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779106714; x=1779711514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUmwK/E8k0/+bmmnitAn3thbhE/x2wsT2IrX01fre1Y=;
        b=nzPwWHh02//CX1wtbXnMqtXW2pVQrZ3pvK0BJaGrp753onOGGJiVUYgfzfTTRnkEx5
         OFVzLyAjEAkCJLMouIF2AY9tlZP3nUXR7LWafzPrgMKx56+kO0FVwVNJrUJnNvqnuDFI
         vuDFPBDNj/w3G/7cMYHpOQGJGNs86QrK4FH7viLv1KjcqfirZnumWF3edceucLcCCqTr
         5HO40mwJGk+cDs/FCxNw7tYO0qN7LjX2Oh2f5pWngMHFvLRobWiQRuazsCfziA2Ulh8/
         /JC156xOgwZEpK+LjSqUjMrNjTVLBlbLLrDs6enZr/aMmldZWLpZb8KSIJP8t+0D668F
         YyRg==
X-Forwarded-Encrypted: i=1; AFNElJ+QZgWEHDSIsyXklAKDzvfy3Ukor79nA7vhqTr6aGLQhJgItzrkbldD3ZCnpITeCQMddvxrgBhj+7sD/uU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfWFGWoYTo13uS7f/GKsUY5G5r22M5bb8+sMxBWxIScve+K7na
	b3+ObDl4YZELQMpxAlispMT0yf/Z/29PLKZ9oracmMQ4jFVSpzbkei2L
X-Gm-Gg: Acq92OGeCx8b+dn36RV4LXirRFtwjLnNmM+oBjoC1rNk7ALx1KdsaLvozIi18Ntg9BZ
	c+kHqDENxo5baoI/XKZdgLMp3MbWd/t0I92ssvv8ZfikIVr2mcv24ePIlyFDgjN1dd1QQ7wty1H
	TVa6w5zQAwli8o4U7iz3wRwDzoEhUNIuNsGB3l4T/xRpiq2FXY7IgEeiKlymP9voAVOjnnTE602
	dVzd625eXrto6PNZ5jP1SsYolL8QXDs+YusPr6lAxo+gh65YF0xhG0UDqeTMHpkIWQbJZzQd9Dv
	GRxODzntQpSp4AYIR7pwLZV/0cGcHQm0159vjlgJrg6t83f5lwczqetbDltTlabyRZSkWGtcZtx
	A+lLAbx9fVG37SCeveRXFzU8h2I5o0OoymBcgA9MUveCy9Tos6f9WUaIFmEUJL2eNG4/QXqVJyi
	1ErcicNRRPsnx0+0vHpVHC3hk6HLPXfPaBoOcHQkGhtAjxoXM+sPr+Ygv173ExJRBMlV6zPBnC3
	LZz3zjT5Mum9DbI2nqNI5kEqU76mNLye3IDdv0OJ1UaeEBfUonazPviil807GAUKHOTP2hwAEom
	u1adEUHoJfQYDVixavXZk/GW/g4V
X-Received: by 2002:a17:906:5189:10b0:bd4:f814:efe8 with SMTP id a640c23a62f3a-bd5177ee44amr557710666b.18.1779106714108;
        Mon, 18 May 2026 05:18:34 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c631e2sm547638066b.28.2026.05.18.05.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:18:33 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	hossu.alexandru@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Mon, 18 May 2026 14:18:11 +0200
Message-ID: <20260518121811.385350-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chap_server_compute_hash() allocates client_digest as
kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
passes chap_r directly to chap_base64_decode() without checking whether
the input length could produce more than digest_size bytes of output.

chap_base64_decode() writes to the destination unconditionally as long
as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
the "0b" prefix stripped by extract_param(), up to 127 base64 characters
can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
(digest_size=32) this overflows client_digest by 63 bytes; for MD5
(digest_size=16) the overflow is 79 bytes.

The length check at line 344 fires after the write has already happened.

The HEX branch in the same switch statement already validates the length
up front. Apply the same approach to the BASE64 branch: reject any input
whose maximum decoded length exceeds digest_size before calling the
decoder.

The formula (digest_size * 4 + 2) / 3 is the ceiling of digest_size *
4/3, i.e. the maximum number of base64 characters that can decode to
exactly digest_size bytes.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a..653be1a 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -341,6 +341,10 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		if (strlen(chap_r) > (chap->digest_size * 4 + 2) / 3) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
-- 
2.54.0

