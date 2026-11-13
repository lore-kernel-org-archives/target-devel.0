Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559231;
	b=uxMkRNtvMk1/VEXLWzs0JnUZfmVGnxrXVuS4UFlLudq9m2jOBB1UgB1mu0Az1n5mxIfR
	 zYHsvue1XF/+NiK88nCem5Tkbn2LZdYgZO/QYBy2jZ0ywhEes0sjK8/Owit6e1Jpfc1hl
	 xIPEAzOz0JI17I9aPh/cpI2tUhvSGyjvxhlgddngx37KtEdOphpkH62Dm1VHe8G+8fAa6
	 6sA2OEq9LHAc3ARHy4QPH49Mm0IP2lAEOszCCO0AvBgyOWYwGkx68nEKZxZTcLG3vwhBW
	 AjuCr4XKMtuHoPLaljokIQEs1dPRLhUKrwbWV5THQ6Ow4+wMNaJSnRDsSzChr8lcPbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
	b=CvyxoUQhvydMx6Fjgqulxi9hyFiQWsWf2thz9ujxOc1DSzwN3QVX2WRPEVXXLOCK3rN3
	 u6aj4Hce4jlIKlrvW6h0MQCGWfphqz0EVA1mzzsgKV9NmJr79WuH4tcd3qYvhMk01IKnZ
	 /Ez/Mhfp0xTvfOqvjxpftdEXCwqcYaMHM6gnkiG7IusYSNvRz5pT+zVXFt8C2vBoV+nmQ
	 xTsYsFhQInvTUuSgcUX51CYH5eqUBrZ9QiSDU7hQEnKDtfn41w8op948kMIQbj5tTnH64
	 rC9RcG6I/k2RItheFlozetCAqrS+xomMf9Ulaq4eBI3R4eq9lXkvMaB8Ly24CffPlEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50769606A8B5
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 08:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50769606A8B5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so280654b3a.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 00:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559231; x=1795164031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=HFQ3NMFD/HeHqYJQZncUggUrOcMsaYsc6YJAUjDIsCZEZ99XBDbk8eKvWDF+Gnnrcd
         svJJ+NI70TLXlxc0n1QkUdGBFgOEAeAAGvKfgKVnZl+v92VHhDFwUFx4TBLOXVvLojUP
         LEeHLydP4SIxStMQasLl51rfhBqfGqbnVX/t31+VgC2V3srZjG78WS+xEx032q57Teu6
         Hwf4POH4kZXxDBFsy75EYAKphlXWF//aw+m68zUh5aRduOGg9nW4UfkfnUh2xIVQ42Nq
         UwxFv/yTP1Yf95db/kKvzRb8Yjd52tHxSyekeJBtDKAzgsZJobPigb34M/u+Vl2afuEP
         iaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559231; x=1795164031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=kQSEPhGsxwKEWJpsvrMb5W3AYjLcapGoDE7wlt0Tbc5pOFlXLKO60eji2kvrkObEwK
         4LnEmnPt3NBPeby8YnJd4aP7SyJzo3bppD94rl6E8gt6mnj+IpI73ptiWRllrILFgzJM
         ZLjyVhwL2e4TrOxp0lp4ubNMFIx+QyTIYFg3lR8QRP4i3YzcbwrvuZMjZJS4GPSPvuT5
         l5b7mym0eUjm6RWWJ2xJOLH5+x/gA1z8ZCgExEBpxUE5ePsBNbDBKSSYeQ3bILLThf95
         j7tiER2V2jO0AdbmAxCoWNsV8pOjZk1d/Vd7seovZX3Wp9WJ6EX0fGBlhozyMaDp49Rx
         W3xA==
X-Forwarded-Encrypted: i=1; AL+hErGXHCcgGqVBbBLFCFuFYayudFmikFMiGc8C3nRvradtuVZWe5vsBZ/aisSVXY4D++Fu075C4KvHR7GH8tY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8JSQf22ZWRgtb5Zi3NtI+BTa6JXGfyZY2R8wLjcVd7zJQWBm87
	bXHs9NiZFDU+ENjKwWB/wyNpg5Z6fnnDPp0/lAAtYj7LMNUd//DIEWpO
X-Gm-Gg: AYBFou2MYknmlB2Pj1HFrHDhpqeYG5uOPX0J3y1VWnTXVmFX5xNGxB2PjGZb8lp/Xjp
	Bu390IeeaOmM/0mQAkFqbokyWzne3QQ+3RbMdqPi60ANmNRtOphptAUIH2KiyjzQg8gNm35rJt2
	lF07V3RUAMjzKJg/Iw8UruOL477sb3bhasX3RAU39IOpH8W8Mz8pKVtdgseoIzylYO3PBhy+kic
	3hhm5susVsmgg+n3vxfOhFCr/HOUsvXU5JAqXBGcLbD3WOpdujtOOgUDQqTMJypSf/KKkQPFxQb
	cl8yhSruWIc5megYQWBicS/TbRMiEFLpyfs3VhcNNoAhtW5YH/rPax1wlHUJyIyVgPWfIxqvbtT
	PH6xj2iri0VcwTWjfD/mlgAj5yvQD9x6JiGI/t/+1RSCzJdRWvHAO6c2nAXwnu1MSrAU2nshEey
	vWpqoKFVL7+2CSuw79P/wcVGB5hYXrovDpaECXOYAkZzmkNm75Rwrg+XaPMPnI+qMg47Bs+CRQH
	+Ote8RVN+QPqc1p1tuqlH9MX9bdpvckivk7CLIM+2qTtiRSSd+iqBHJezFi6d6bdibFLZRjBLUA
	5MwsL83YFhYWIGO5MtCgwKKjFjkK2dU3AWdwsJZc5g==
X-Received: by 2002:a17:90b:4410:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b1b0b9a342mr1279723a91.63.1794559230508;
        Fri, 13 Nov 2026 00:40:30 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:29 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 2/3] scsi: target: Clear all control read scatterlist entries
Date: Fri, 13 Nov 2026 16:38:41 +0800
Message-ID: <20261113083848.1517595-3-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

__target_submit() only clears the first scatterlist entry of a control
read buffer supplied by a fabric driver. Control CDB handlers can leave
response bytes untouched, so later entries can retain stale kernel data
that is returned to the initiator.

Clear every supplied scatterlist entry before command execution. Use
sg_zero_buffer() so entries spanning multiple pages are handled as well.
Keep clearing the full entries, including any part beyond data_length,
as the existing code does for the first entry.

Fixes: 944981c7e106 ("target: Add control CDB READ payload zero work-around")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/target/target_core_transport.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30a..267f5e2cc8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1633,23 +1633,16 @@ static int __target_submit(struct se_cmd *cmd)
 	core_alua_check_nonop_delay(cmd);
 
 	if (cmd->t_data_nents != 0) {
-		/*
-		 * This is primarily a hack for udev and tcm loop which sends
-		 * INQUIRYs with a single page and expects the data to be
-		 * cleared.
-		 */
+		/* Control CDB handlers may leave response bytes untouched. */
 		if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		    cmd->data_direction == DMA_FROM_DEVICE) {
-			struct scatterlist *sgl = cmd->t_data_sg;
-			unsigned char *buf = NULL;
+			struct scatterlist *sg;
+			unsigned int i;
 
-			BUG_ON(!sgl);
+			BUG_ON(!cmd->t_data_sg);
 
-			buf = kmap_local_page(sg_page(sgl));
-			if (buf) {
-				memset(buf + sgl->offset, 0, sgl->length);
-				kunmap_local(buf);
-			}
+			for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i)
+				sg_zero_buffer(sg, 1, sg->length, 0);
 		}
 	}
 
-- 
2.43.0

