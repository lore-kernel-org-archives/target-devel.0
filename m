Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F27230B508
	for <target-devel@vger.kernel.org>; Thu, 21 May 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376315; cv=none; b=LOHhyP0G/s/Yd3UbXqQe4yoOvlorlyZGalS97VsjqcwkU03cCj93P+BMX/qAvbJM0+P5mlJwmsaTiwmDvDS2NhPzJTR9Uhgti2Nyqs06wwp+gsiq8GPtLA7NK3VtpC0da+w7Gs0Z/6ErfMoPIbWawLGzuJTv31ueoQ6oPB8qw/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376315; c=relaxed/simple;
	bh=RU6oU5V9Jd55+3BhZdYaEx6qEvtKNNlahl3xWR6s8Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uH9Qjaf3l+lRIxtxholNW71laRMP4HLrAxA7mdqU+nwaapOs5VvS0/8CAzU3IsrUPlkJOb2OVmQFZ3x6gfDI3GmzGFIO6HMZ1clRE1etlc4u+jo73UuRK4mfrq2pmhFpdYg6fB5eQcYHW+zcEH1+pvHuBxNiKra8jI8MJUEvx2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sPQKIZbk; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sPQKIZbk"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso13346671a12.2
        for <target-devel@vger.kernel.org>; Thu, 21 May 2026 08:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779376312; x=1779981112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7tUwlivnxdHdof7RvuWQ2n+t4BjAy5qaJWU1MgyZM/w=;
        b=sPQKIZbko+1GhnUwrlZA854tY9cal++hxEWrT3N9sG4EeAiXUDWQw/P3tdTO4b+5Kz
         dD3mm9ALgzWtRFVERTRuB/jggsCFUlVZzz/rFjU2E3j2eGnkIHblc/Fr1cxBq1RlHxwl
         a9Igg2pxZ/cwgTlsrpCP/Rtg8r1vhJFF1zcHbHHwBrjf9Oi2/jCv8tIvNIJUWuTyXjNd
         3AkRZJtwsfgPu1pAPFcgsgRnxU4xX5rGQUEeZCKX86290f7jlLK/SdvAzMZkpLe1p0nk
         8vcmq5yhpaM5th6qj6ED+XWB67M20z0BFbUgJfe9G8wVdBWTdsdF2nd/wT9NZUQ820vI
         LbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779376312; x=1779981112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tUwlivnxdHdof7RvuWQ2n+t4BjAy5qaJWU1MgyZM/w=;
        b=dXmJ2+mtcPkTB4MXTv6Hei11YfjYJacIR4uljie83KVnj0Rv9oBG/B4KV00HGvnJqN
         dGDR+knv2YRo/gXXJOneQl7Op/GxQ7tTxEtzdl9PzhiLvE2mjIgQqH/uwU2hI/C/+Ha3
         X/7LddT91DfL8ctJIxoJ30Eoc62LakkneMQID6fxHF59qD2m0eN7TFkc3MpuFDYZ5vJl
         VT2O3OCm78ecyH2GhkLsaY0aaUALRkjtWkzd9uX0RqprvoqQVpD80+hZfZeI7Ru5MJTS
         wb2/ISFMwFqO8/ViA5o4aHLTcl6ce49l1oJmEbU7Wg3sHhMAuKa+KWZd9+UPbyC36Ijx
         hb/A==
X-Forwarded-Encrypted: i=1; AFNElJ9yq41+DV3T3ch112yqs30MhJy8WFqgvQJmtz3bszZDPhuzJ9LAYxbWvLO8UTIxk26d/QvBTqjptD0HPOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm26r+fudADBN4frgGP+BJ9f4nl5a+MaQmmQpGVXOpfgYFbgk+
	ec6XPHb/s0JAZOa1m6rPR0UtJdQnaHIM9lrMyyLX5Hr4n5fBQ8Y0HEXW
X-Gm-Gg: Acq92OHlKqIWFK+Fk7YpB10cL5fYQN+vbBbfSzqRKnTFvQ64Ws/nc/ZoeSErJ3M67vj
	zW890pSNGW9AoH5Ot3cofW62uOGVoZ/y73P1OULmv6fOo3OzywVMyIjz4TB3Lgi12yl/HLqpTrm
	OFmVs5Z6aiaq+CPm8Mr/kuQwQqtTxFPZ//iV7uukKZf9PUd4mT9tOYw5dGa+hjlnvm76xkUWXWI
	RYnmmWPi2bQ8WRVsaKnwru6hbMjSb0o/PZnSQyOHybOukkt3xadoZ7HmNQT+GkH3hxpox+50RdK
	+ZhdtJMGPBloyJYKSk0fSXl8i00JDTAbhpH+LjghVKq+pfojaWaw/E6ES4uo4ZQokEhvt5WGxbu
	fxhLAq61tJ8Kw0ysNaywV6EaxyAJRF0Q3CEDnzQ9KZWYf1gsTy0Q6J9wMBhMm7oijX7XjELvprk
	W6ts4Iyln8zd+Pnd/2VxnH8P5DIFJ18r8UtTJI2aQdxs13j3ntJuHw7RVfxz3ftf6j1jWPGz6by
	oIh241zFJ2JFuUPHTWorybx3/3XmBH21WxAsxX6VQjgM84VQJVH8H7mpGawa8L0C2EWbXgo7tFO
	5gxhpnNjndPrQZIj2YE/LPz7FXzj
X-Received: by 2002:a17:907:784:b0:bcb:98cf:1a82 with SMTP id a640c23a62f3a-bdc12f8637fmr174232466b.14.1779376312188;
        Thu, 21 May 2026 08:11:52 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bdc8aef5459sm59846966b.59.2026.05.21.08.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:11:51 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	mlombard@arkamax.eu,
	ddiss@suse.de,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	hossu.alexandru@gmail.com
Subject: [PATCH v4] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Thu, 21 May 2026 17:11:21 +0200
Message-ID: <20260521151121.808477-1-hossu.alexandru@gmail.com>
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
up front. Apply the same approach to the BASE64 branch: strip trailing
base64 padding characters, then reject any input whose data length
exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.

Stripping trailing '=' before the comparison handles both padded and
unpadded encodings. chap_base64_decode() already returns early on '=',
so the full original string is still passed to the decoder unchanged.

The mutual CHAP path decodes CHAP_C into initiatorchg_binhex, which is
kzalloc(CHAP_CHALLENGE_STR_LEN). extract_param() caps initiatorchg at
CHAP_CHALLENGE_STR_LEN characters, so at most CHAP_CHALLENGE_STR_LEN-1
base64 characters reach the decoder. The maximum decoded size,
DIV_ROUND_UP((CHAP_CHALLENGE_STR_LEN-1) * 3, 4), is less than
CHAP_CHALLENGE_STR_LEN, so no overflow is possible there. A comment is
added at the call site to document this.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
v4: add comment in mutual CHAP BASE64 path explaining why no overflow
    check is needed there (David Disseldorp)
v3: strip trailing '=' before length check to handle padded encodings
    (Maurizio Lombardi)
v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp

v3: https://lore.kernel.org/r/20260520165259.272808-1-hossu.alexandru@gmail.com
v2: https://lore.kernel.org/r/20260519015100.837422-1-hossu.alexandru@gmail.com
v1: https://lore.kernel.org/r/20260518121811.385350-1-hossu.alexandru@gmail.com

 drivers/target/iscsi/iscsi_target_auth.c | 19 ++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a28e97..a3ad2d244dbe 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -340,13 +340,22 @@ static int chap_server_compute_hash(
 			goto out;
 		}
 		break;
-	case BASE64:
+	case BASE64: {
+		size_t r_len = strlen(chap_r);
+
+		while (r_len > 0 && chap_r[r_len - 1] == '=')
+			r_len--;
+		if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
 			goto out;
 		}
 		break;
+	}
 	default:
 		pr_err("Could not find CHAP_R\n");
 		goto out;
@@ -473,6 +482,14 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		/*
+		 * No overflow check needed: initiatorchg_binhex is
+		 * CHAP_CHALLENGE_STR_LEN bytes and extract_param() caps
+		 * initiatorchg at CHAP_CHALLENGE_STR_LEN characters, so
+		 * the decoded output is at most DIV_ROUND_UP(
+		 * (CHAP_CHALLENGE_STR_LEN - 1) * 3, 4) bytes, which is
+		 * less than CHAP_CHALLENGE_STR_LEN.
+		 */
 		initiatorchg_len = chap_base64_decode(initiatorchg_binhex,
 						      initiatorchg,
 						      strlen(initiatorchg));
--
2.54.0

