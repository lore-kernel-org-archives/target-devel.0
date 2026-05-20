Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4410339844
	for <target-devel@vger.kernel.org>; Wed, 20 May 2026 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296015; cv=none; b=CJGBSG3wQmcbrTlM9eDZmzG2IngTqzOdjt7fVeoZOKQbLwM/CZG248I1R6dz8RfoTu43WXuzw723SobKSF0D5GwGCCuac0D7cc7nlO7IbtUHStlHx4dEZnfKqYlN92IDTvvFAKYOopcpzbbk33xY121xDtm45TPdJ5sQKMCNN/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296015; c=relaxed/simple;
	bh=OqrZM/EZQoDxpdqsw83Tctk6QvpP+RDSvRPve3kZib4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSyMDnFIZOaymQsU01kupGZGkdWGkBywNWL3xhvdGVOnomleo5gtvsuxwk+h97afO8LLqHKYWPXkiPaKjjTOkRPWqHKAuLVo13fLvkfmHPoPfxgKiR5XzZHJaotQyXW7uYIRFdxIwlsuyMhhvCCssqIDPMSwrOkMMZ4DL8wBPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkU4GBL/; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkU4GBL/"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so8644636a12.2
        for <target-devel@vger.kernel.org>; Wed, 20 May 2026 09:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779296011; x=1779900811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKcl0f+YiSx0kT0A06n+DmaHMn0z0MjpQEGjfw2KSV8=;
        b=JkU4GBL/LH8SDTqhqu2PMj/k2XBBu/ZymgoIeyqLDzs6PDk+Rjb8URfzCw/X4fEo4Y
         mjzq4W6gOob6o8+/kl3IAwkel7yQDIg+Ohu+KCBSsciZ6ewBj8U9ieMmGdOyFf9DgZxT
         uPR1MU23R1mOWxe74+LzQLz0KcAZnj7mIKtXgOfRz8R/LKaIn4nNuvFUb8JM9TZ5g3me
         BXbRy6vnk2N7wScACVRVHEUX5jRVj5CLu1Pf2x8/QIKw+YLf3guPazizAtlQQIbKjlzR
         aUD++Oztv4iRHkPIyckIwwwLik0fdmIOZqrFGBKPHavtt2ZKY+VnPTNa3Tkb91Oh+8Wm
         sjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779296011; x=1779900811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kKcl0f+YiSx0kT0A06n+DmaHMn0z0MjpQEGjfw2KSV8=;
        b=hBc2PQOC2LrIHO6MzSGPapXY3BxHHwROT5I3IZRWHuiBq49NVxn6Rqa4+2xVoONb0G
         MgG5ySyg+vOh7taAMZuW7EKRth/b8D2tNeYkE1v0CZ4jfEomJrKjFstZPz8OXr/GUAWH
         DulSHNn67Vp1CwNFrFeqBFnNM6nEk01hXoOKghjPS5yzHztGCBIysoE8PicBw3yaFSZ1
         hvMvDavVhb6xhnRVEAQWGgT3+tFs6Df/SF1SYGucHxoy86+kP3cue1BVlZHmGXPHvKFZ
         YEpks8ttG86x6ohIp9Aigf0a5Eh0lBL8ag0Vvz0LfynauSImCbCTg84dgGricQg9yhib
         AVdw==
X-Forwarded-Encrypted: i=1; AFNElJ/pivG/eLjm0I70WtcTxOMCPdStaIROCUrU02DHX8csEYlRgrjOw9bp8LLJR7vRpdCZ2p7r4VC3KFZm25w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTFkqj14blYjnySTCZzPSchbCLtuB7XPHrrpLQoQMSrq4QjX3L
	YfKMlw62yGw2FaMGCWh18Ue4l+4SBQjxIWDcRsmz/3lHMSDaxYCJ8x/6NORVth+87YI=
X-Gm-Gg: Acq92OGIZ2qgzfQLsvHFsilXp3A4rajb+Sfw9Ks0w78BiOejjrEq+sbUxiBMc2F6hUe
	G3MixlD7F1l4C58CYyLa5PwOgxES5BdMy8NJtwAlYCieiNn3J9bdmJ/osz8lDrKU0gUI40U/MDW
	moVIMd5dx+K04tITcN3CisSac88Exfi9CSj1DSyJNQi3lZ0uPWZ9AO+iWQ8J3cmWVKpRe4a8o9m
	m9C4+jbJZj2zjgKhKUQvZIlQqb6Dt2j4ZKpEqd5xQVCdcnLw/ZBdPsJgjI4m/lYJ3yLvg1ZdfQT
	xxn2zcVll4uCN/sxrIBUHtrQ6tiGeOlsQnmXvBmIaZLEozNkkPASwZ4bFdPX9VIjK4Ju8kTBhyZ
	MA97ZEoPEfKGHftg51KSoAUi2H1btVgLLjxRoponuCg2S4cZxaySfxXWyiLrVGx/smrUA3GOT1D
	DjC4chqFcog3Hmx4nSefD+zKvj7IL8iJk0VITrVngzhmv5uYUJLraf+qB8IWUzo/MeBjnbCu6um
	uuh4ENfrkiNANMGMu2XEoQ15e4PGMDVJWFUCUeG38K8Np06w4upvmn8QR4FQ62NRjtD3CWEo9FN
	RE6sfOOLVMqiUsD9v5vbyUVxgfgG
X-Received: by 2002:aa7:d14f:0:b0:674:7363:3e91 with SMTP id 4fb4d7f45d1cf-683bce9cec6mr9495273a12.12.1779296010835;
        Wed, 20 May 2026 09:53:30 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6831187ecb7sm7966009a12.29.2026.05.20.09.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 09:53:29 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	mlombard@arkamax.eu,
	ddiss@suse.de,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	hossu.alexandru@gmail.com
Subject: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Wed, 20 May 2026 18:52:59 +0200
Message-ID: <20260520165259.272808-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260518121811.385350-1-hossu.alexandru@gmail.com>
References: 
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

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
v3: strip trailing '=' before length check to handle padded encodings
    (reported by Maurizio Lombardi)
v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp

 drivers/target/iscsi/iscsi_target_auth.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a..00487d0 100644
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
-- 
2.54.0

