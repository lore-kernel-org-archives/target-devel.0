Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975264;
	b=bV3roHglLRxXCETG1Xt8OIilZxB44q4fvww+Nd29sqfTTKkI2gRdJ9UDREmOxHkzQ4aA
	 /sRXupai+i2vloxsMBOUI77JKZ8mjSLqAhvAweOZUqBpC6ZGUT2fVHog0edi3rz7QlPjl
	 I7jJGRygJjXEgJyPVnbY7E8E/nQ6mFfPiADFdsVHjpXxt3C7w2AbvFg1qcnLOq/wMyheQ
	 BstazvhOU+oUDCzAJ/Ne9KpH+r1lIr2b+yZ53IZP5eYQego8a2fH+Bpi+7cgqPk/IFrNv
	 /z7vYpHwp8ZU2+PlE46nMPMMhxagDmsEpi7IVf/4D8UjkY001+Xp8BiBm0OijvNQ9Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
	b=A6WdlPs7xpX3sarXycrQnEvvbvGmMhDKjmalUmIQK32mSyQazgwDgdRpajSu9mT0YjdS
	 6uUTKr7F1fIgCQsg+SgS1EdRR/Tyb23VmR2Lo2FeWKlktxB0hVOVDiKUyW/pnpjDS4VNu
	 PA/KdT8rrGfiWJvznfhrr/RCuLck7T7eFHKCCN8rDpSo8QxOD6JP0LFbYRRdTyVI+HIoE
	 B4gaOiYagRvxs45XA0u/lu14CFlqJivJrGNRF830ZUQg0eowUu3M/z1u9I3OyM6f24DdD
	 9D+/GOndeD/+tjEStEfiVhhXt0tmnkSQQZt/JlrHWh+SYTEx5sLHeQra5/tEp9XfI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qBlEGefP;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C00606A325
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 04:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39C00606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qBlEGefP
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2efe591a1f6so2091965ad.2
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 20:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975264; x=1795580064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
        b=qBlEGefPmzChhdk0wNPA0p/UMgkFWQY21sNi/8IIGLyKp08m7l7KyB/r1ZoAMbwJ4h
         OVaEPgUZPnbF5xccC6AtlcqDtNel9exmin8wCetQDe5cfvhQA2TgwvA6HgREL2iUVA44
         YbdPrhppCtu0FldSSeDZqfe3ArqeoPadec5UaOkkzA64/uEfgaR2/9Xq4atKkX79C9T6
         1CygKU93tyPuzT1CgJQcuCUOZd6QQ7UfTd8rBG6CwG7kGJhvzZXikXc3O6lPShULdirE
         JO7/HaBhRt4xfx47cPymltMF0hxGIstjslClU+fZ3JDAegB4rhSOSPqgEdGey7O2Y9lC
         At0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975264; x=1795580064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zlP9NFMxivD/7WnoRl1Q8FAK7P9MLDGYvNDfsD3fEW4=;
        b=qqa3Ky2pK8matdGDGrO954wvKvSlTivKA/2Dw4eixqPzXupDE0RbdTBBLLDvBmiwgM
         5335Ksj2rQ4VBthgncPGIsH4ZyWEEQqnGrDeeFOtvuCeAwn1ykIqePeXKQK4r98O6onl
         w3bcUIO7EMTf69n2MYNpQMNLMA3pEakyoweL8ImOCb6txmsrFQFdVMoXxoaByiaeA3Dy
         +Od/1NIxin6Rb3sHznNgLyQxifXr4KcCjyqSjaTfwPFrchfi1GmpVwiLH3fcSVoDxpbJ
         2N6ABwDw6B3SeXJl9EFesVz5jlp99hSURrOA6MMnv+nvy8OfvVnE1Y8baEtFIDDbHTVM
         WxOQ==
X-Forwarded-Encrypted: i=1; AL+hErEaVdz7A5kiJddz9FTyYVq8JQFgQQJW/j4ZmveHLVHJJATG77rwGRuE2fDrAOIBQEaiw/PRwCl0IC2Ue34=@vger.kernel.org
X-Gm-Message-State: APuU4Z+8rJBaEeuvsOGUWo2N5ilmYioZNK5ExD8wXIS1HBm6YlBb/lHL
	0ivho3zJMXjr+MCI05c8k+IEBqPoJNLNmzUVb/edKJE7wNONa0wVKqcu
X-Gm-Gg: AZFdTZdKWhrSOa6+rbPcNZd53u3ZPLXrspPKrw+Zao4aDXuZG1u4aAt741TtzrQoq0b
	RuHV3auAOVK2/+OrS1dR6q+7kQ9Lix585CDs7TL37BrZMWkyRjBrOm1N5uznmExP3NnofiErO8R
	vkUbZKuO3BYBPNOJmPAe6BFFwv1w4TVFVa7zs9ZjQxpLXcDTU1XPvJ8JjOzIm9UESZxrFfPECiD
	SPCHNGyHtICiFTAvywsE92p5kvv6QYi+jr19voNohVy92yec1Hsf3KhhP0UYLS8e8StCnJycxAt
	3VKi0RLHitpBOugSwpc8IeXoQpU1dErm+Km0sWVHDKx6XBdh2m9ghWTbWDncNwxFfQyMKdEhIbI
	JCwm5SSGKRC4d1ESbAvZaKHZwMslcoZ4wpLLRtaIFcxEtM2AwkiG1L++cocF8OLFULR20cUqQ6L
	89lbdpcTPhTRIBcyCDZj3HFSLiaPWx1PEHeq1YE8dcQbtrr6RmpzVMmMSz2mtNRxHSZKMAsLEsz
	drdbEafe70AS4Jntu/T8vh2zfr/noFpIH2bSfiY96SomnJjLsImkWUbH+KSKGVWwbkpTl9EcrbY
	CyYx2IxXxHQEj0nGRLP7pQ==
X-Received: by 2002:a17:903:186:b0:2ef:e547:e0cd with SMTP id d9443c01a7336-2eff740bb69mr14953535ad.31.1794975263568;
        Tue, 17 Nov 2026 20:14:23 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:23 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 7/8] scsi: target: keep pscsi mode bytes inside the data sgs
Date: Wed, 18 Nov 2026 12:13:10 +0800
Message-Id: <20261118041311.19011-8-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
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

pscsi_complete_cmd() updates the write-protect byte without checking
that the response is long enough to contain it. MODE SENSE (6) needs
byte 2 and MODE SENSE (10) needs byte 3. A shorter allocation can make
the access run past the command buffer.

On tape devices, MODE SELECT reads the block descriptor through
sg_virt() of the first sg. The block length ends at byte 11 for
MODE SELECT (6) and byte 15 for MODE SELECT (10), but neither the
command length nor the first sg's length is checked.

Use the sg copy helpers to access the write-protect byte and copy the
required MODE SELECT prefix into a local buffer. Check both the command
length and the number of bytes copied before using the fields. This
also handles headers and descriptors split across sg entries.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_pscsi.c | 37 ++++++++++++++----------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fd1b82fc72902..ccf5933da7f0d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -21,6 +21,7 @@
 #include <linux/ratelimit.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -610,21 +611,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 		bool read_only = target_lun_is_rdonly(cmd);
 
 		if (read_only) {
-			unsigned char *buf;
-
-			buf = transport_kmap_data_sg(cmd);
-			if (!buf) {
-				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			} else {
-				if (cdb[0] == MODE_SENSE_10) {
-					if (!(buf[3] & 0x80))
-						buf[3] |= 0x80;
-				} else {
-					if (!(buf[2] & 0x80))
-						buf[2] |= 0x80;
-				}
-
-				transport_kunmap_data_sg(cmd);
+			unsigned char wp;
+			unsigned int wp_off = (cdb[0] == MODE_SENSE_10) ? 3 : 2;
+
+			if (cmd->data_length > wp_off && cmd->t_data_sg &&
+			    sg_pcopy_to_buffer(cmd->t_data_sg, cmd->t_data_nents,
+					       &wp, 1, wp_off) == 1 &&
+			    !(wp & 0x80)) {
+				wp |= 0x80;
+				sg_pcopy_from_buffer(cmd->t_data_sg,
+						     cmd->t_data_nents, &wp, 1,
+						     wp_off);
 			}
 		}
 	}
@@ -643,15 +640,15 @@ after_mode_sense:
 	 */
 	if (((cdb[0] == MODE_SELECT) || (cdb[0] == MODE_SELECT_10)) &&
 	     scsi_status == SAM_STAT_GOOD) {
-		unsigned char *buf;
+		unsigned char buf[16];
+		unsigned int len = cdb[0] == MODE_SELECT ? 12 : 16;
 		u16 bdl;
 		u32 blocksize;
 
-		buf = sg_virt(&cmd->t_data_sg[0]);
-		if (!buf) {
-			pr_err("Unable to get buf for scatterlist\n");
+		if (cmd->data_length < len || !cmd->t_data_sg ||
+		    sg_copy_to_buffer(cmd->t_data_sg, cmd->t_data_nents,
+				      buf, len) != len)
 			goto after_mode_select;
-		}
 
 		if (cdb[0] == MODE_SELECT)
 			bdl = buf[3];
