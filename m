Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA6833554F
	for <target-devel@vger.kernel.org>; Mon, 18 May 2026 23:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148273; cv=none; b=oZPv4svRLrLvceb4+dq2MRsvlC1uOr47kbHyZ9avoV77/SweZL06Wqq6h4EtsoyVEk7obOVdpSpA+q5cxymKE/SE1r9opjZXebov+LokYa0AFSsondzf3fzVDIaQsEkTDQ9igBz6YVEwZdMv9gxiB0i7szMqohgY3oAPA3CMATE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148273; c=relaxed/simple;
	bh=QZTNJBwcxlSR1s5+g7hU+ux3gb0rozt/TN57Pvqn538=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTwoe3JUgHpBia7QEhsRemV5JD+xswypENm3gu7Ha1FcJcFaCsA2Bsl+Ljr1hDrmjylwh+yfosEl0aIOBYzjdXEZMNVYqMGx4vXPFRQSkKH+nlMykXmJuGCxIwqhjsGleAMNeKD/oDLcpm71b/J25TG7FIuT7vIH3GV8I4nnSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkHko9ir; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkHko9ir"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67be871ed3fso6670989a12.1
        for <target-devel@vger.kernel.org>; Mon, 18 May 2026 16:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779148270; x=1779753070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8DlE+6jvZdiiNMn1OqACkTYheqqIJEpS4FWOTKGk4M=;
        b=fkHko9irbYkcZffZyG5xvAyDjWQ+satbceYT91V8ojTCkJRJlq4LXsSPHGrE4A0j+r
         yJ6JthZ3BiBTN2YQh0fuPqZcC1RWcTk0xK+3+oCiPSVJhZ7wVZoJqcbi88krDQLKBgq/
         WZIctzMkPG1h4bJz6L7WG1nj7mW1FImXqU7BZGWsW2PLOI2wkfH9kCvm3BXFuxHT9onD
         fS2767ZDOL/kGf4jum4QWhPcno8BGZ22Bafo4Mi6wfK1Dw3pSBJ2fl+KK+s7hDDSzCkp
         VI8Km27i0E7YHG1oOPODvPeYYPAvbAbGhpoi6Zh9j4NVgPaIFpn3QdpwIPuw/NAlj6Yg
         lJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779148270; x=1779753070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T8DlE+6jvZdiiNMn1OqACkTYheqqIJEpS4FWOTKGk4M=;
        b=XXmhCnYvjtx4V1KF2DmbvBGaKQhLsPwmMYpOx1npQfN1p2S7QUIINnf5Als5ZVcZJ2
         FE0dydw2+AZGFqXMNFPEc9txFDZSz/MjX9BEqYNzuKGsLoQBBkPKIf1gEHDnWtgcJ6F4
         HArDGpsPcn/8WO4jy5x1bPSceWGDT3p5+7Ek4VGqeCcsiDPgLVA3B3RoelajBbBVtlQH
         cli/zLdP/Eog4+H/TbcPpRovfdYW0grIRzFD/kDLqEDV08Y87xAwhC7wcNIZo2uyBBbB
         q9uklP5lcj3UUNIdc2AjRKh0CEi6i5KD7Choen9DKs9jk2JX8lRvNPKVfsu+7KsbQHYM
         +RlA==
X-Forwarded-Encrypted: i=1; AFNElJ8nlYOKFugpPEX6PPto0OwD3Xqq0W9HChUbNTZAnVpVKxpybBNkTd1rhBNAYtXRG5JxeC6nhuLo6tcPYFY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOzoMOpqxajQidEP3pkptqpqVkyTMGjH3JwSLM2Y9oYSaC3hQG
	e40UM6FU+JjHKy620a2AaeBAfAA52+Oo05ljwvf/S+cXXGFy60ixiO9+0WvvMzlr
X-Gm-Gg: Acq92OEtPAM8hcVyHUjkJJaouSltDlo54BHgCBfvewdUZ+pg868b9+84YYVK0tM1JpK
	IoDa7v6GmWUYKZ89pWk6a474FGCaN41YI1BiGfHuXJotjp2OWakj+1YZ+bnNgJi6ffiCF6EuTQ1
	RtMdqR8B+DReWUlfFF1iHhTHFRl3PGTlN3wcNwA83EYm35Ryb5He4dMbxt8LlcgCQ176X9zFZgx
	8SJvOW8rSwJCKNW+iItvj9NoBKprEdQaGiWd2YRs/EnhYfT1OPF9rdDq05f8hF2/+7ZrDgtv8fj
	D3V0DgMxLJdQ+HcH25YOjyhIGU74TQtMOyhDvIbvNZZZrFjtWAO9o/7k79tbHDbPIPOgJ33GYX8
	7YhRrh7jVc+3pd5VtKrNC/tFNirZ2kQCFtNp9G7pbc6d66jhCnQlqtmp1/Us2QbnxzRm6kSdKyS
	jwT9bLaGbeV/nCKkw6FKjzsdK7X7phda6Y4bY48oYCwMcWUPW9y7BhS8z0Wx2dnKFjBcDz9K9rb
	TBfbUZ5V4A2tVsjpTWHyj3djuFiIaDp+mXkNRou7d7UC+6h8WMi11agHiDJBbuSblsd1iEuEi5D
	ooccb/J0jPCiHkMC9MR8uAo56nWc
X-Received: by 2002:a17:906:5193:20b0:bd4:7cec:1066 with SMTP id a640c23a62f3a-bd517acd5e6mr680008466b.44.1779148269993;
        Mon, 18 May 2026 16:51:09 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4ec6548sm621858266b.62.2026.05.18.16.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 16:51:09 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	hossu.alexandru@gmail.com
Subject: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Tue, 19 May 2026 01:50:40 +0200
Message-ID: <20260518235040.48647-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260518121811.385350-1-hossu.alexandru@gmail.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
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

DIV_ROUND_UP(digest_size * 4, 3) is the maximum number of base64
characters that can decode to exactly digest_size bytes, matching the
convention used in base64.h BASE64_CHARS().

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp

 drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a..50eeded 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -341,6 +341,10 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		if (strlen(chap_r) > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
-- 
2.54.0

