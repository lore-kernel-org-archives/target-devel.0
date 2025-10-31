Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000E933372F
	for <target-devel@vger.kernel.org>; Fri, 31 Oct 2025 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904443; cv=none; b=jSGp1h92qsuK23fYZXspl4biQr6+XHiAJ3muR1TChyRTXqNkdxhT3R/P8HZvjFCTeWJYi5XILQ+qCUrSlhnS/dxUFolr8OPjdU5aoezfFaVkqzweU7UpIQ/ktrlHWTiz64xuKXp+94Dic4sePVMxibcC2HszfeVaxcYaGLV4MVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904443; c=relaxed/simple;
	bh=Klmh3jjuYCOmOQGrka0ucLeEvTrFCcJ8wdqYdFBdeFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=om1kcH/cIv8kn7Lx5/HIAYWb5gRtui++/P94yzkSt5q0E+skm0HNMDavumNA8NEOk2Iu/bZ3Z/kyL7UStu+rZIP5Y771KFcGNrNUjbxx8gcNTp6aD2yZwzhKoVjcG29LZDy5B7xhuMymwsmZe0vzXyZm38PEhh5y65INrlRQSNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvXTNdmI; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvXTNdmI"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b62e7221351so1906490a12.1
        for <target-devel@vger.kernel.org>; Fri, 31 Oct 2025 02:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761904441; x=1762509241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cLNPmDkWzf8eEQQPMNYd08lwz6rZ0+F8xG5ehROMMhs=;
        b=JvXTNdmIPJz+aVSxwVU2BHYTppBGcdpr2jw9u/XeTLXNLe4jp5/2u62DISxIrP4Bmk
         85utbcL4pv8nn9ekW+BrcdUT15hCQ48ssKXnTwKcTIagUNmaZAuB1e6MCILUl6WJ3ilC
         ovlleLNBDzrx28pzU+78QFePsPVBIbVAUzNq159lnftK9vF6+4eqn06qVAGM4SZeIKE7
         FCs3OpZt4K8Uw4pe42BIeIgMWTEM4g+qNJ9Hdq+l3viiA99hkiZKqoJY2cuOYgsGpN50
         Y3+tpTMw8cRBxdNR3RCuE/2JMk6s5kQhyzYXYaaPkv7EwtZT6iGTmB9SVX4pZCF434uX
         jqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904441; x=1762509241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLNPmDkWzf8eEQQPMNYd08lwz6rZ0+F8xG5ehROMMhs=;
        b=pqxRm7Y3z00/HBMK8n7YngCOMt9NNlRtYASxtE4vLNjejJmsnW0K8rDy8gJF8Se/fz
         qf3wYpBr6QNPFNu4QDwN8vpSdW3poGJLH2MGekiiRV6ERuXo3KySm1p1QInMjo7u9wj/
         LYgp58T1tmU63HSQ9lzBkV7UXyHP1XvQMBL4pdUgTK4iRjmobIIMGgL8hs4WnU9DuFQN
         a7mvfY9nBh32FPEzm0TatdWgqLjq9U//kWEfyKXBpdujvWX7bKpZTfiFAvdW0D6/iunz
         lF0MWPJewrQrAJzRDHmoBnmSIo0fo3kzdGMQTS1ms+Xc8AcGWW9VVe0jtBDEIyykV/fM
         z33g==
X-Forwarded-Encrypted: i=1; AJvYcCXFXkCO/purBOgzSIMoGrRJP1J+vVts1qjOywdfMBlgJwBGk3mfal9WhDbh1gh1OduHlmyZiVmLJjNaAt8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2GsXwsCQ9FfqDxBEuity8kT+95KM97oZU+Yu2rLEqErxcscLi
	EJUwKVMeuyBbjRhXPOZRT/7uLbhSnPYT6SZwLsAXrHxA3CPhcICgAyqP
X-Gm-Gg: ASbGncv022pW272tUK/UcFbLz07XDckpo3jUfUadP2CXVbdBMC3ueHmT6O5mVp4xn7G
	WHnZncMaryVdYCYLcsHOCpPDgYfYz7eiOBLqVJ5iu6wrjdRmDDtX6S6WjobEN5FXpRZYZKHHm8u
	DEDuqQFDJv6pfpeAf9hovHfxyx+UXeiz8h7ESb8z5/kQCuC4UrJHk36EiUck/gOjxempPH7ZPlw
	SkkWH/NnZmyf0uopPAVbY570Cr4VjhoiSiQDXTqT4thcopHjF3Lxujq8iuxIm9WhUjEUKTnTD9R
	/Xb9FuD2IsXroF7fAa058IRwY4vEUJkm6XXOz/98cyhM7ttEvYEcae15Lzxei3oFA+8z2Rkb9OQ
	jiSFhROmaY2RawGgo7rqgrA1kqjCli4o67VCTUiFfZ5/3iOy8i0nOAxS7E86GDc2W/932IN82CC
	PpUKXf+/oGL4d/
X-Google-Smtp-Source: AGHT+IEaWtnPSkn8bEYuOq2PjxBQpign0Dr3z7sevrRCbVO/NKyO3H7xejdOk0+IGGRdzvycMwogmQ==
X-Received: by 2002:a17:902:f683:b0:295:34ba:7b0b with SMTP id d9443c01a7336-29534ba7bd4mr8072985ad.35.1761904441183;
        Fri, 31 Oct 2025 02:54:01 -0700 (PDT)
Received: from fedora ([2401:4900:1f32:68ad:2e67:289c:5dac:46fd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952699b791sm17746035ad.75.2025.10.31.02.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:54:00 -0700 (PDT)
From: Shi Hao <i.shihao.999@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	i.shihao.999@gmail.com
Subject: [PATCH] scsi: target: replace strncpy() with strscpy()
Date: Fri, 31 Oct 2025 15:23:48 +0530
Message-ID: <20251031095348.24775-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace strncpy function calls to more reliable function
like strscpy for safer null termination.

Earlier code had some strncpy functions still in use which could be
replaced with strscpy() since it always NULL terminates the destina
-tion buffer also it does not waste cycles padding with zeros unlike
strncpy(). In regard to this convert strncpy to strscpy to prevent
accidental buffer overreads and ensure null termination of destination
buffer.

No functional changes intended.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a76bdfe5528..9c255ed21789 100644
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

--
2.51.0

