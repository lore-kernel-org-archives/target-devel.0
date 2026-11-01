Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793496380;
	b=vEKdQeCge6yBnpW/XyB7RgqByfEohtQaGYtBo/Ve/pDtxvikYe7YOcUeRcC4lWREpAj3
	 8SQj0dX+2Kgk5TZFf1Luhwb8zbMz9Yor18wRlQvNzcaMKNir71KX+zEgHkzpn7Sq18z9b
	 Yf4JsMayLAYJH+QtEnvbNxM9uNuCD2lKNnUbYnMskUK0fYWeAvF9z3XbdkaZDbITlnoy3
	 84F1gSmRpKM06oLKLHQhbKbhtOcI+0aUGhlcI0AyZMS4bXjSaMbWD83gYMv7A92uChz4f
	 xdl6gZsTOhlyCZg0w6IoSUz6jm845/7JRBRe1qFrH4Zb/tOXF6bSMSVshNT+09+pW1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793496380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Sender:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
	b=OM3FOYEJlrxO9KFnlC9lBOWz+ysJe1UBhcYNu08x8JikxIOwy6YwHCDDn5MKAMnktROP
	 GTaR064xXTzANmp8cqaQ2vy0VimyGYvbJOEzw4//OUGoi0zNUHFz7bd1E2ZbgxYmcMybu
	 3gzsBtgDhResRtdoZv/Sekludqs4EozxbBmFf6He+JBQoEb0Hbxm4sqAvzADzQL9+qo5v
	 Lo26MlghtpYNzOW8dy89bvKpFzOFTQwl8JcJKasFqYfNVOpRSavwJ00YwEmpeDHax+jnK
	 u9wiLG5nVQLWe/hNRVvUt+Tgf3SCBULLJrSEJww8UGO9d5uyJ2OCLD9NNYOShTWS7tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NZdzdKzz;
	arc=none smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34D6606A31A
	for <target-devel@vger.kernel.org>; Sun,  1 Nov 2026 01:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A34D6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NZdzdKzz
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7cc0892f92cso602484137.3
        for <target-devel@vger.kernel.org>; Sat, 31 Oct 2026 18:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793496379; x=1794101179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
        b=NZdzdKzzFe070I/A4X0Fc37wFboISxd+dXeprLXL93hPsdzyrxnOaSYC/oKSwdpRBm
         lpn3m96r40JJqJzs89RLwlSccm9pWzFYp/Emofr0XL3WgAQ7UlSHV8dfA3KNYpWvX+lK
         wgkjgGR/8jfPobWkC/VnLPZHmkOS7JyCD9b6AoIPE87MXiquya17jytSlyBh0lS9Ii1z
         6eLpAa4nDORZ9DmL5U0qabmWsvJ8r2n242dLo565TSVzWBbaeWkXZ5M9gghEhvX8eIpS
         UsRLUsJh2hAj96GuQY74YSZnzPsQcWumuMikix9nioU3RlzSJdu7NLcjsL+Pz7CBOjdj
         7fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793496379; x=1794101179;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
        b=d3sAk5XXRokA8+3AObmg++gDwZQITGOA2psGqjDQMxiNo/yCGs7ClclBij8Orfntgk
         Thjg407C2SIZXyIMyNGKrA1AsQZ2VXjTXfUH02NkKg20UnmtP035xV9nDVvGWKzaJzze
         TizZFuPC5ouyYtssUrh+13OmmvSHlHZiGkD5DFLphezHpn96HRUsI0/zcMXQ9qh7+LOc
         pWnazLNTtm7Yr4wa/2ogfj98Ve7wVcScIIE2fNpbnpKlHHgGDhnjw2NS9NApJYRRDWEn
         xUhzpmKwcHgg7Bd22ZT6Z07dh8sRQd2ZfvyCjBM3vUS8zm83wtwxi/1en2nropioJ3f8
         BeUA==
X-Gm-Message-State: AFq9FYIEwOCjc0wI/WaXANJ9PGuUEglFuRXy6mILYp1BZMQY79dcBdHm
	aA3O/jnJfrOm9A+EbpbZhhrxrQYJWQYQ3jzr5mMQdgcsFODzyGROD8iFsAD/6gxi
X-Gm-Gg: AYBFou1grP3AbWc2iWngfr1u8bAP/Rx+Drv+NlTJbN6xKuSckbNy1A7k4WBiwWAtTb/
	9VvxE1UyE8un7GE744xrotqzBkCAG8qeWpZgAeuHZl7GHD3vnhD6szcMSFfxVSRlKblKuGm3665
	YxjhpY/BrriRFGfpfc2JKdl5wmunOSz/uCh3v6xn6eJfwyY12bLBJ7+zYcjPSOvBY6/DoAOlWy5
	9W07z3yqEEPd41r4gRn+sWdhe/Hle7nCDDUuwvA0cvIl+MX84LIhSr+cJOYeoUucr3/m0eZyT5Z
	P4/87rSDu7KVO8p+PkNj1QJYfWyqA+rPFyuTmfGSAq33C6IcOHQR0Y6ywqNHvuyoGKK/JC25y7d
	WU1o1W3vdGTj2q1h07l3U3370UIh6qnl392WmmgCJ4sws//Te9eo8vkAe+otWhxiQ/ePOYLlPQm
	1/7iMfA3OYhMjD7XeFdzhfUyXrcuqyTwBbRJJN8eqByxJyC9Y4YZUEtupSIGPmCkrVYTO3a/XbK
	t1RQgyQhwiGfxwMLFt+eT3tLUculOQESBqyRHa1zlnmr71jq2rmlWK5FMT8yoZFAR+GAGlQ775T
	4FWfHlpR6+nesGDRV+UrdkVf1M6z8HgISvtGlcAEChyXPaCPTMevDcDzSkF+kVmX++6AXfPOdQ=
	=
X-Received: by 2002:a05:6102:3309:b0:785:c39b:6a1 with SMTP id ada2fe7eead31-7d072636f57mr2626543137.6.1793496378542;
        Sat, 31 Oct 2026 18:26:18 -0700 (PDT)
Received: from nb-x1-03 ([181.120.144.175])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm7089367137.3.2026.10.31.18.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:26:18 -0700 (PDT)
Sender: Ciro Iriarte <ciro.iriarte@gmail.com>
From: Ciro Iriarte <ciro.iriarte+software@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] scsi: target: core: Parse APTPL res_type and res_scope as hex
Date: Sat, 31 Oct 2026 22:21:39 -0300
Message-ID: <ea903e6c-09b5-4a11-80e8-6e1387f39ef5@gmail.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

core_scsi3_update_aptpl_buf() saves the reservation holder's type and
scope to the APTPL metadata file as zero-padded hex ("res_type=%02x",
"res_scope=%02x"), but target_pr_res_aptpl_metadata_store() reads them
back with "%d" tokens and match_int(), which parse with base 0. A
leading zero selects octal, so match_token() parses only the "0" of
"res_type=08", the trailing "8" makes the token not match, and the field
is ignored as unknown. An Exclusive Access - All Registrants holder
(type 0x8) is left with type 0 and the write fails with -EINVAL and

  Illegal PR type: 0x00 for reservation holder

Userspace that restores APTPL state by writing the saved records back
to pr/res_aptpl_metadata (rtslib-fb does this when it recreates a
storage object) therefore loses every type 8 reservation across a
target restart, and with rtslib the storage object creation fails. The
other valid types (1, 3, 5, 6, 7) and scope 0 only work because their
octal and decimal values coincide.

Keep the on-disk format and parse both fields as hex. The valid type
and scope values have the same hex and decimal representation, so
records written in decimal by hand keep working.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Signed-off-by: Ciro Iriarte <ciro.iriarte+software@gmail.com>
---
 drivers/target/target_core_configfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a9560..a45bb3d56 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2126,8 +2126,8 @@ static match_table_t tokens = {
 	{Opt_initiator_sid, "initiator_sid=%s"},
 	{Opt_sa_res_key, "sa_res_key=%s"},
 	{Opt_res_holder, "res_holder=%d"},
-	{Opt_res_type, "res_type=%d"},
-	{Opt_res_scope, "res_scope=%d"},
+	{Opt_res_type, "res_type=%x"},
+	{Opt_res_scope, "res_scope=%x"},
 	{Opt_res_all_tg_pt, "res_all_tg_pt=%d"},
 	{Opt_mapped_lun, "mapped_lun=%u"},
 	{Opt_target_fabric, "target_fabric=%s"},
@@ -2229,13 +2229,13 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			res_holder = arg;
 			break;
 		case Opt_res_type:
-			ret = match_int(args, &arg);
+			ret = match_hex(args, &arg);
 			if (ret)
 				goto out;
 			type = (u8)arg;
 			break;
 		case Opt_res_scope:
-			ret = match_int(args, &arg);
+			ret = match_hex(args, &arg);
 			if (ret)
 				goto out;
 			break;
-- 
2.55.0

