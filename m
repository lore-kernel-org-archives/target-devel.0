Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19EC30EF88
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775404040; cv=none; b=m03QO89XLrL5An29XSD+aXzqUxouug4224mcs/TLyMptQqo0GTvtWpp20BsHifJeo0IrVchI3usvfbI9YxTYIRXOQKdGYeS/KMLk4o6Ihzg8zwNmhpCla0QzRvubY7UG3qqa3jtO7Z4C/9wXtD/ip3xGguYwld5DVc3vrdD+RKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775404040; c=relaxed/simple;
	bh=KWjggx/Mo8aB0ehD/VPw1reu36vBVKSRmD0eNEQxans=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l41XqMaRsQMJmv5FWXOe25OgAE8dO9GFpqoo+zUMCtDfMoam6xvtP/6jS6vYKEQ6wk2xtBdNNV36nzJzE3EOUp4VdjFkuG1J2vVjuJer8nKadKk4vcOAHacNlHPickVmKzW4/T1wX5/SNFv9UT8t0f8ejB6ehEk2yQkxtgVhIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zd4S+xCk; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zd4S+xCk"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43cfb723793so1996339f8f.2
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775404037; x=1776008837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XH7TDXoqdU7pa9wJu9hwxRZR79gQhjpwL8M/TgWuJUE=;
        b=Zd4S+xCkv2+2r48Oop1q1sasntl4tbOG1hiUUapIgrMmTYNCJOfCsmZ6Ncu2M8dwUg
         6vgM4QSK/GYVBUCbJTEAPvueC8HtpFz2jkhmKXxLGwpZP7/FoVnJw9LgVDVUCM702Qbi
         5bS445jbT+3GzqyfgNgnEqN9SjmuD2rp3LtH0C3vBT9IyW7DisLwhdzJHEsU8kZIsH7a
         IRZPz0jDiXW4v2GXsimIVKySO3SIFVXvMiQKlSzAi5I9wyis2r8lp6hovKA/B8WSqeDp
         aaoCstI7gsUxxtSJo8QoTx+HgQRCKr34Ft6eHyn9TUOCdx+WLmgRLiZJfV+6pZss/apB
         T6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775404037; x=1776008837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XH7TDXoqdU7pa9wJu9hwxRZR79gQhjpwL8M/TgWuJUE=;
        b=R4uJFxcWJ2aKir9SXWnjsl7qsAvY+RQvtP0bAMJonjE8eKgtHu7RdkMb64FXyMnDZF
         E8ViTNc55iH1twu79wdimXpielp17KVZ7OjQ1guecoo424KkHaSEHPE6L4RkMTMkxesd
         tsxAvX5J3IUX/S38Cgq84M+sPO76ePYzNyqR2IDupkNuJyAUHtaPoKmnnYfzKYRKRR8A
         UEUWgy6+61Oy2jEWpcdjv0hgGfz+wOQco8Ebu9LfUtIn2QQTfim4pOfizZKkIIbf5jym
         1vlf/lUKVwHpVg5/yHcEZ/12VtEpipomRibEgsIldJAq+ViYHwhaBadx5dd1No59IGcj
         8Urg==
X-Forwarded-Encrypted: i=1; AJvYcCUFYXQjlJZUXXTKL/whAcc07yKUj8/3bLTmSlO6znbnom1ruBOfv98UHb6IC9dF9IdqLIB2qUYshZfk+S0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsDtF4zAbalCLpsAwbZGCbwVOM1RMLS0XueuTMI1si6DjCJIzA
	U4+zYqtygE3QUM4hwZ8CieyIRcvlRjOF7ajOnIznRQ5K73KCAqi6o7IX
X-Gm-Gg: AeBDievpasN+U64NhvZHWoORJbr72AGRg4D3GBj+zAMYRNdGCrkp8M04dKIxnaVdFgr
	AfUM4szHMSmkea63BUzw0B+o+wZZu9rgGJcuymwsEwts0LHP5QPqxEdQx6qmNN3DhaNP0dWzctz
	0C9bVoH2MGXlJux3Sd85N4VBd+RPnQ6sgJ63O2caG02ePQ5YMCqLqX5uPhFG1Itz7Y3TqHzIZBc
	GsvS8+GnvBR6RSnLIK4A2yODYhGZwfIf4WeKYOk1e9TPKmB0UEjpFb21sqp6xQQ3fCf0JOE7ZoE
	sdV8v3bfjmly50PTduP9Y2mQLaMhZ0rR2Q6C3MT53XsPf7eGRZWd+HUDeihlQKzkPEAE2AsekiJ
	5ZgogdUpperoKsgiQi96jwu7r5BgFXxfQFzNMVAhGXrWxE2jje3p2VSnOHqqM4/a8F15WZnoZBd
	OXrYGJMCr5rUPobuj67Ck9D8xP2xmMZJR/7m4YNhl6YaQjDk7/onsBv6ij1q/EizMuAFS3e7Msu
	ugprC9vyr49E9gj5ksNBkg=
X-Received: by 2002:a05:6000:2389:b0:43c:fa77:f71a with SMTP id ffacd0b85a97d-43d2929d761mr15340536f8f.15.1775404037129;
        Sun, 05 Apr 2026 08:47:17 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2c50a7sm34399150f8f.15.2026.04.05.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 08:47:16 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] target/iscsi: use get_random_u32() where appropriate
Date: Sun,  5 Apr 2026 16:47:15 +0100
Message-ID: <20260405154715.4683-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the typed random integer helpers instead of
get_random_bytes() when filling a single integer variable.
The helpers return the value directly, require no pointer
or size argument, and better express intent.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 75c37c8866c8..81e28e567a01 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -102,7 +102,7 @@ static void iscsit_create_random_array(u32 *array, u32 count)
 
 	for (i = 0; i < count; i++) {
 redo:
-		get_random_bytes(&j, sizeof(u32));
+		j = get_random_u32();
 		j = (1 + (int) (9999 + 1) - j) % count;
 		for (k = 0; k < i + 1; k++) {
 			j |= 0x80000000;
-- 
2.53.0

