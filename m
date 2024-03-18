Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F5F59B79
	for <target-devel@vger.kernel.org>; Mon, 18 Mar 2024 22:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799686; cv=none; b=YPAL/p0WbOg0CdGYGq7gR7Gqpmrfx6ck3DRv+namU8QOn+RYy1m4I4bnuircEI7ltqf5gGG+6csFxBviZsMHEjLojI0z+pCYio7kxqb3gc6MnmYGRADkJDVBrXsl1uG9lH6JdPiI9QAEmOL8Tv1L3DRiXieUgoGiaYdoD5lkODQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799686; c=relaxed/simple;
	bh=8sSU/nXOVaTUrxt2iL4oXf9XEJw7qJGFB8M6brZiaUI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NPT2fUflxP/lqAufiojSZdvzowLlp2SoNqqNkO56zclY6GS4eIOOPgEzN86D1nJ4pgMnRf4LgyijNdPB915G00QnFw2joz/CRbwmt57dFk+c2a7Qm0/TBQssvkyWKNfUkGrLu5os6/Bm0vClULvNAj6R+lF8na0kpVT/hCqhyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wp3ntPOD; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wp3ntPOD"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7cbfd9f04e3so231378039f.0
        for <target-devel@vger.kernel.org>; Mon, 18 Mar 2024 15:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710799683; x=1711404483; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wl+YEObNF5jUVaY8QBV97LtH6p2YMlOabTAyUwaF4rY=;
        b=Wp3ntPODHkyF5Jl1wxhGV35ctcYLm2wbSzgW97Gku5uHIssx5h7tJ6JfimYKDFIdG4
         B1J55vZ8h0knTrvWugaerSD6dO1o8qxXOGIPKxWgxcScdeiDDogyPAG+AekCthBgmpRp
         cB+AHgmiBVfW4yFFQvDJsB7FupuPWRSWwM6eyZZveV+L4MkAhvL+qRtK/SMVa3LsJ0uI
         lymyrM8WV7JU42+0W34/OaL5gfhKoGK2W3vc/8/Fk/XwvqpMpgAcNvoL3VMuz0NdT+bg
         cqbthnrsJTlAwqwDAk/MTGlhXlPuqXzx5rWIbTf5IA446jYkvg9QMgkKPMnoehcu/WGH
         7HiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799683; x=1711404483;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wl+YEObNF5jUVaY8QBV97LtH6p2YMlOabTAyUwaF4rY=;
        b=m8Z0OF8eL/o+jZjaNvNFmXiGFg4xTrmjVzDO3BvsO0GdM85VqdX+hzuZyp4xEeji0t
         Se6CKSzacqLWdF+u9od7/oZUNrf4KbJur/X2VbEGI0MVjLpgjcmCB4kxpDoyQxnpLZfb
         GqY4UwaHv1RxA7xnayMkhRWKr6J2GrG5kdWs4ylwMFuYS7siKBqQMHFYFWZughZpslqu
         7As/iNAxZZ23+RZ21PjY0rBh/9Vb84Yao6xGIwZATNk0WRNkahF9bZs7oaelCQa8rFuD
         OITQ14muEJnR/4BPguknLXMU/9ThQvHEEbHVlUm0RYTzCD8YYC7MO4ApY8nXCbNZmUHy
         j/qg==
X-Forwarded-Encrypted: i=1; AJvYcCVcuA6kN7XFE3ARnslyOT3ydxfFBfFovfzY68h5+zmIyhRB9XBnIDAVybgcfKDip2KP2cee0HMWD8bZJEP3cZPXHyoQiuJX6kkMClj0
X-Gm-Message-State: AOJu0YwQ3xPE62Z5UgT6Ew55t8ukUQiLwyGvbWaBiqRhaSObnmSbf6k+
	O0lCzjNq7P8LwvuwyqXOUE00nWQeCZqOXLGYGBXE3XmVd7BknwBOCg0lWf+X5NSZkFotK3CVQdt
	uGUxlZNYx3jCGjCDmbIwGYw==
X-Google-Smtp-Source: AGHT+IGPo1ty8ABBFYT2U90iQtfMKa/TblLUJSl5kNLDYgsFtkX4DwwFNIMofYowsjLzN/AITEX2RoloAWykuDWUuQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6602:1491:b0:7c8:264d:5e98 with
 SMTP id a17-20020a056602149100b007c8264d5e98mr41333iow.0.1710799683679; Mon,
 18 Mar 2024 15:08:03 -0700 (PDT)
Date: Mon, 18 Mar 2024 22:07:50 +0000
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIADW7+GUC/y2NQQrCMBAAv1L27EJSE1C/IlJCum33koTdpSilf
 zeIp2EuMwcoCZPCYzhAaGflWrr4ywB5S2Ul5Lk7jG4M7upvqCYltw/OwjuJoiVZyf6YchWaTFL RVsUwo79HF2Og7AJBjzahhd+/4fN1nl+qx69CgAAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1710799682; l=2858;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=8sSU/nXOVaTUrxt2iL4oXf9XEJw7qJGFB8M6brZiaUI=; b=OEbAyG7DwUzX78dcvhoYXw1WfM1MXn+uwhR8Pl5NHBMijevu9EXe1FKB6bvnpLFpfTyBfs256
 hAZDn/EmeRfCJENhPedcD67Xu1m0s2MWz/3odklFXGzJYmRuB/0rAM7
X-Mailer: b4 0.12.3
Message-ID: <20240318-strncpy-drivers-target-target_core_transport-c-v1-1-a086b9a0d639@google.com>
Subject: [PATCH] scsi: target: core: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect p_buf to be NUL-terminated based on the callsites using these
transport_dump_* methods because they use the destination buf with C-string
APIs like strlen() and sprintf().

		memset(buf, 0, VPD_TMP_BUF_SIZE);			\
		transport_dump_vpd_ident_type(vpd, buf, VPD_TMP_BUF_SIZE); \
		if (len + strlen(buf) >= PAGE_SIZE)			\
			break;						\
		len += sprintf(page+len, "%s", buf);			\

We also do not require the NUL-padding behavior that strncpy() provides
because we are manually setting the entire buffer to NUL, rendering any
future padding redundant.

Let's use strscpy() as it guarantees NUL-termination and doesn't
NUL-pad ( and isn't deprecated :>] ). Note that we can't use the more
idiomatic strscpy() usage of strscpy(dest, src, sizeof(dest)) because
the size of the destination buffer is not known to the compiler. We also
can't use the new 2-arg version of strscpy() from Commit e6584c3964f2f
("string: Allow 2-argument strscpy()")

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 73d0d6133ac8..3311eb87df6d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1112,7 +1112,7 @@ void transport_dump_vpd_proto_id(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 }
@@ -1162,7 +1162,7 @@ int transport_dump_vpd_assoc(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 
@@ -1222,7 +1222,7 @@ int transport_dump_vpd_ident_type(
 	if (p_buf) {
 		if (p_buf_len < strlen(buf)+1)
 			return -EINVAL;
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	} else {
 		pr_debug("%s", buf);
 	}
@@ -1276,7 +1276,7 @@ int transport_dump_vpd_ident(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 

---
base-commit: bf3a69c6861ff4dc7892d895c87074af7bc1c400
change-id: 20240318-strncpy-drivers-target-target_core_transport-c-1950554ec04e

Best regards,
--
Justin Stitt <justinstitt@google.com>

