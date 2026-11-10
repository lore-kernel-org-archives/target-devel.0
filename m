Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303104;
	b=Rvn7BTnfxC4AsUbQX7o/fpvqDHcx6QTpPI0fGs5cvWTeaU1XwNGkdjUm4c/Zsz2CqhJm
	 5MXp0yXyQJVF9iu4pl9KxCYXSYBZiBZt4vmknf5R4iXgBivxkeQ0hMgZ/sTkOkl123uHR
	 b30VQIsBI4/De/CioD8+Qr9C9vbeboMY4HVKHdnFW2H3NzFEt8I3zlaMFMAoY8jrw1Luc
	 NRRtObOU2Amx4LsTtKRSbsW9Bvc1tZO/YlczY7zX+ViauhRyUaHWahgzU7cuNxwAoWm1a
	 a8yu4Ol0bkk7P6s/V+uYWSw8Y4ln0MOT81WdGzyFIJaU/rKlbvGd5zeAmFBN5gywXwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303104;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
	b=vQ7ZgjI30HHrdHikw7QCJpT7ZosvjeAjmmKFtNz8nnWynK+Hb6kcKf7OawSlGJT5pGHD
	 VAAqlMcsFh9MaswWewpqBb1Gpz91Dd6L1C4h3gKPqpJXoooYN56LisnaAWlVUv3kX8OF9
	 /hlGkAfFWIK1ni/pzdyvyEUN8PcynEo8D6U0v6F1mOywI4EpT4KogQYwtT3vaPtWPHbUp
	 HBCuPpTwvyZUeaV7Q4XvBoZcr1FYNxHgtsPlTMWPMxOnUERKmR1xhCWoZ3AbY06Ea4oWa
	 mSVk3/CbCaP7MjYpqahPfAFhkt77r6wnZz8L0MLZSM6JMPY104knWNhE5uw8949QEfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m6VpWtDm;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BDE606C649
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 09:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33BDE606C649
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m6VpWtDm
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so2980778eec.0
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794303103; x=1794907903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
        b=m6VpWtDmn0Dldk5emvFKnESyohulG8uw0ZwPMGdM/9S9v9cGrlFeN9gVlckf0Mv0qd
         3fEteFvJtcrNghTloBDMtkBU/VUpnBYwWJGrWgbJ0TaRfH1Gh067jvJyvnab4B+wgVrs
         59hh1V5259n5V2cFrmtphIhIRlYE7Ju3zRc+8t9Sy3bmJzvV6sEoFD3SH9SROk5LFspc
         qIRJ4gTKCCniqI0K3QDpfIEI87CwGTcMfHt8fp+LwWdqE+Ip5GlYa+1E6hy1pFyOGnfE
         VUwYg7oOCMTKdy4QI6YD6tLww1NgQkM2GoW7dN5f8M0DqdEBrD9z/jv8huYgv9A/vJbT
         Nm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794303103; x=1794907903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70d5HP/NDskHf8kArC44fYJ/2R1MLgLSjk60RYC7GPQ=;
        b=w4jSOAE/rkG0FOYy9a33gmffVJ5SAhIohMhJ/uLeY2uECfetJ8N+6LjPHAerC9R/u/
         iN4G0C6ZMYDXuKBFLNMulRBprOxb1CfjtF6kNKlAlcLfq5a0B8rIdkuBYZjlryLRE0te
         shEA1oeXPhGQIKV6noQyeWedOZBCEYYNL8U5ZnA8YpCiKZmJlav/JIK711ft/oCHXynJ
         W96B+bDQLkH0ByPhWvun077APhsrqvGSmME4TCS1Jl0ZNKD88gp266ALaGU3Zxp3yk9P
         FNVDN61LV9TRVi+EI8h2/FAR3r3wigi5dkZxN8/2UYLg0jNOGpGV21eEv4WVUkf+MJ0r
         KALw==
X-Forwarded-Encrypted: i=1; AL+hErEr+gk9YWM75t2/kWJmeb762kG0sfZuyvASi7ozk0/l33NUIzzqL3QT4Xw8W0OefC3MtuFZ62R8cuglOUY=@vger.kernel.org
X-Gm-Message-State: APuU4Z++a80v+KBU4nlcSRsoeqM1MYvfEKpsxZMSnkJmLrK5NLZcMx1X
	NVZi3QB9y295LhlMrQXlt1vzjHy71Mpv8FcDD0fE4aOKXy5NjjOM1LDrnsX2Q6Rv
X-Gm-Gg: AYBFou3qquUUnMuT0ZFynUi9fUMrAaFrT25PjQJMYQTL2Lm+CI8+WC1o/bLKP4AxIoV
	IYSKKMDRyw/PPh56TxlWuUX/Mo+243pNxNL1Fnnb04uS8SqMqPLj4xpWHpAN0pRCNmFsPhwBh4a
	rZnzAxA8LCMg5B2c2/4jplTUXxg/iV1hPd4Sk/4iohCOTAakeQ+2EvoRDxZTsxW2KRg/5AZe8Rk
	7lzvfQfXVCLDkmzLWy959skrEQmjlQmXygoenQhIyRagdmvHneO26XsgcbJ1G9CfjBKjKY2IcH1
	eT+3sYa6VJy2OEHxtHCEVhJA3r6lP109daI7yQPil1oZas6WNru5Uh/eKGOCdvdoipt7bgC+3h9
	a36wgxdl3hTxcmcVHKdixKyRQhkv80UqZCV0ne/1TIMvxNPvU9CwPvq+YV9UftyqKEeRL5eG8Ss
	fP9O25e5GEo2s2GxW55L6i1oeCDHWmLvz+RU4NH6d3WfPEte+40mFrmCVLYu3xLrAEzjxu/2Bcq
	3e4gcmjurrvLHK848m8NgSHinM7EbKLAagkulxKpwjrgbDNGDxDdbd1YfnRSOPhE7JbVEOMFEUv
	g8MixRkKYfKXSwELJkEsuae8QCAukt2VOLc3b4NyUHZIFcJ9IUePtP1fEr0=
X-Received: by 2002:a05:7300:da01:b0:351:29c8:643 with SMTP id 5a478bee46e88-3751f46823emr2583654eec.18.1794303103003;
        Tue, 10 Nov 2026 01:31:43 -0800 (PST)
Received: from homik.search.charter.net ([2603:8002:ad40:56f0:140f:bba5:1d89:57e3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751fe3261csm4840148eec.4.2026.11.10.01.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 01:31:42 -0800 (PST)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH] scsi: target: iscsi: Replace strlcat() with snprintf()
Date: Tue, 10 Nov 2026 01:31:37 -0800
Message-ID: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
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

In preparation for removing the deprecated strlcat() API[1], replace
the strlcat() call with snprintf() to construct the AuthMethod value
directly from param->value.

Since buf1 contains unmodified copy of param->value, formatting
original value and suffix together preserves the NUL-terminated
output, including partial or omitted ",None" suffixes when the
256-byte buffer is too small.

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 99772364c88e..aad82a37538f 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -624,7 +624,7 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 		none = strstr(buf1, NONE);
 		if (none)
 			goto out;
-		strlcat(buf1, "," NONE, sizeof(buf1));
+		snprintf(buf1, sizeof(buf1), "%s," NONE, param->value);
 		if (iscsi_update_param_value(param, buf1) < 0)
 			return -EINVAL;
 	}
-- 
2.43.0

