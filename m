Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216549;
	b=vSI0WqNYqhLfDrlyCVboWduQOLhZ5E1DhyXQzzE9cpMK8UsOHGyIDUjOM460dtb078YX
	 909uyzM6mOijXUzrQMpvR+LPnjrUwbi+CqlHkCI8H76lU2ejpd5TgbYuTJxf9Fy2SmfVC
	 b/HjrXt77uv37FkBVO6v0eyQtqBcWTc5D5yNAFcBKjNBymM9KvEQYXhG15IO4kKUCUzq0
	 089nouLTavN3uUNV+8590mkUHNSGFQHnKOJ5wPdcazbOa+r9ZUemHcpmXSJN9xm6I7U2u
	 Uda+EEX9tDHZCCb4/75k2VGzQ+dLlPEtsG85Ru6bNVxhj9q0HXHxUPtULSyykfHTDKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216549;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
	b=Vacev52+miCz3YYUzCejaW99vdLXbb+0PvoMbzVmmnmmEe/40YsLiZCi9+oa6eSrWvkU
	 QTmA3m8Ywf22IU4n5sBi5QdL6J399K8PpNgndbx2MWrln+BOXovmXRPAQAiwvdvsip5U4
	 xm2kMWbshEIH6jw84DWqJRgAwzTBsQ2phK+dDjHv4FOnV24gxh1PEKXkueFhSOsONUru/
	 CD0nFcX7N7OfCPdtYcM6LIwOJhpJRQtV5WP2DlGoa4Bwf3PIYvA6RZ2FoOEq2wohxSK1g
	 vLvc4Ts7qUXfxesAlVSInwpE640Z0FyXlnM/Jry7ZWoG3kh5sJmFnNacPKng5JAojLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VeDMrrGP;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666960A5BD4
	for <target-devel@vger.kernel.org>; Mon,  9 Nov 2026 09:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B666960A5BD4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VeDMrrGP
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so222919b3a.2
        for <target-devel@vger.kernel.org>; Mon, 09 Nov 2026 01:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216548; x=1794821348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
        b=VeDMrrGPFDw3Ukg5QkZBevZ7ryDTXO/KoaQ82CprffedrPD95w+liomfeUNXGv39YJ
         9kN7Hhc6Hf8N3Oiod/8nmzJYaV/5+Yf11Af/sPoWf8KYgri5UEBsnJYIJu555UFN8ary
         CbExgPkfvUymOFthnbocOVvddYtUO+O0kuDsAEItYBsXDfEeVIIRrdHxzvWXd0oeRVQT
         NHKCpB1U3Tf5aKrc0vropD+0vVgBo8KsAzUpqXIhAWn9ozX+40dvi5xp9CJ4+b5UcOj6
         OHhFzixk58HURo9bgAbQXfhCr4MrE01A3FnoHCKZlV6Sj2KoDT3Yz560DbdMA7kedj7C
         PHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216548; x=1794821348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
        b=vEXEQhDj8mfvAEXRrm5QvoEPFK0rg0yoJq0Xgd6ju6n+S5Ga7qTvcLNLB1ipBEtiWK
         OnN4X4B97JsudcCMvjbZK/qwBQGvEC2W0Pvf0QwBWLzC8gDottfi6DGQwJlWVwr0CSGK
         ZgdMmn+RKSb5f6XIoY4ft+JUagLbSjQm0MM3IPVRalCQGF0L3+YwvhGWX2Eqbjo3KjjT
         QlzvJNnCeMnASi0Ezz/JEJLj37ObdwAOJsSH53w13uvhyDkm6QKftEVjsvATPwVMVlTV
         HeSIUqqGpfMwEsGKOVvUYumTWGldXJ541Jncd36D/1Tn/W9XwUTj6EJHBRhT8dd47EuJ
         2qOw==
X-Forwarded-Encrypted: i=1; AL+hErG255j8fOrxY/DJAGoedogOWrlCe5HFeLngE+I4M8Q6aHaNJFumBta5axbSP7JMWCGQ8lgpWB8sgCsGdoE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/FksLW1ApOlbVuBzI65pc03caMDSL9fMqSzqT2rs55ohudKCh1
	ECpdGb9Z0PN1sckgoOFaAZyUGzQVybMsLE9QY2zoOlU4i9S+jVdXQk2uhvPdiYCk31o=
X-Gm-Gg: AYBFou1I2N8/1kZi9y1gM8MVJLcmot//nf5QqjIaqovt0QczBAsyXNPKoldjpv5X9ci
	GAu2BxtQvjF7niN7pHiOsTjOIidNcNE+OedzncDxu6nZOaakwYeCLVCDGaCHj/RCnijnI26VHHQ
	DJdxQZ1W9HiIZ/CglmhLjMPwn8TAMPyvhWdclg/7wrKAC6Cv+z8nQgC0bhn5wbcGVXYrj/RaFmY
	f3kP4r1VQpBVPA+U7LgQoGjdTvhmZWSJqfGrkq/Muq0ubjfTx6g8nSQTCfk4HgT3k6wKyQ7GDLb
	d58K7Y/DCdbcbwVC7Pr2SMFsncwfutDpUuLpoBtxgcJgy9Syw9yy3Orz+qSHYi+GQddQ7wVlSvo
	ntUTddoDx4SIZhLNf5WpAZJd5vv9zkJB/6VhZQfhLAAhRQyNjlaAU5oY6uVBgETO/Qzv49Twq/l
	XBB3VNIpcv6lijcy6gTQKXQqGaHQO6PWdzzjfIePIr/+7QAe4GdnN+EJuOlsL33rtkA6KWcLWQL
	dEl1qnHC9+KTD9Yn13psGgUJgzovzJS9llERZcqkPHVbFPCLS2lWYdo+yoEy3GCuQLxbaw0mF6Z
	Yj+5a2YCxsNMcvejyVi6kG4uddoYmQjo0UqaIGMXwWBFrMRncDIp9F2mSpQJhJ0=
X-Received: by 2002:a05:6a00:13a1:b0:890:bd5c:5710 with SMTP id d2e1a72fcca58-8b6717aef6dmr2691634b3a.41.1794216548030;
        Mon, 09 Nov 2026 01:29:08 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b648e55e85sm1103778b3a.17.2026.11.09.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:29:07 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 1/1] scsi: target: Skip zero-length protection SG allocation
Date: Mon,  9 Nov 2026 17:27:36 +0800
Message-ID: <20261109092744.822646-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109092744.822646-1-pkfxxxing@gmail.com>
References: <20261109092744.822646-1-pkfxxxing@gmail.com>
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

A READ(10) command with its TRANSFER LENGTH field set to zero, sent to a
LUN with protection information enabled, can select TARGET_PROT_DIN_STRIP
while leaving cmd->prot_length at zero. transport_generic_new_cmd() then
passes that zero length to target_alloc_sgl(). This reaches
sg_init_table() with no entries, so sg_init_marker() accesses an invalid
last entry and causes a target-side Oops, which can also lead to
use-after-free during subsequent iSCSI connection cleanup. A logged-in
iSCSI initiator can trigger this on a FILEIO LUN with protection
information enabled.

Require a nonzero protection length before allocating its SG list,
allowing commands with no protection payload to proceed without an
empty allocation.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 5835812f13e5 ("target: ensure se_cmd->t_prot_sg is allocated when required")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30..4cda1e610 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2841,7 +2841,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	int ret = 0;
 	bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
-	if (cmd->prot_op != TARGET_PROT_NORMAL &&
+	if (cmd->prot_length && cmd->prot_op != TARGET_PROT_NORMAL &&
 	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
 		ret = target_alloc_sgl(&cmd->t_prot_sg, &cmd->t_prot_nents,
 				       cmd->prot_length, true, false);

base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
