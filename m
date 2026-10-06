Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C5288C2D
	for <target-devel@vger.kernel.org>; Tue,  6 Oct 2026 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279298; cv=none; b=bjYg1/3odRgG5IIvQaEKh7RFsa0wXYTtctUCeFGAD7ikuci1OqE1jkHwFTVatWgaEs1yC8jhJ/YL4G+XPvhFBJLDFcliBnyzpSfoWb4ojndyRGOKkdyBA7gGOieLBya8rkaNl74skG8tglCsh5DJfbf8EDBEcsiAsi0buxcPrgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279298; c=relaxed/simple;
	bh=Cl7VqJEIWRMpNSC0QtvNARN8JpERw/rX/idDF/Zmv5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pWrHQCn5ADNFi4cEk6TD9wS/vUQ3ligx7wog3T35o2Gh1l+FvAd5tdUGadbX7XRxi/qWPhNxWf+UPQ5I7YY59wVz+hZmCtOvnLBgJ0Qgm45hwnMa1axj8UUguf0DQQ89a1mZqJ52M4ujSU/BaQM+7R84mOk7WIRiF0wj1ibv+hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsDuSiK8; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsDuSiK8"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a4a7eb86a4so504248a91.3
        for <target-devel@vger.kernel.org>; Tue, 06 Oct 2026 02:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279289; x=1791884089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1Ln/9VxN6ySADYGeFTkesQbRiqqtYrWtn23BhcT6ng=;
        b=PsDuSiK8LpLWFAl0h7xi4Sw9gwUoiV+y6g5DmMdu5irVKK2GdqJgk1PYIDetrcOy0M
         HYlxN9j292d2rFWx+kgbiv5p1HcfAEeIrKrK6rGQD/bef1Ip8qUst1al2A9fBxy1XoEn
         NufYUzsu5JIUCimJ3iNF1FygCZPYSBVlBA2lxH3BNrV7GnfNhaubi78yqJRxbaFbix62
         kWI2yKhpZaiICX9dRXoHCY4Hfm7NnfeUAE/wg9ImkjYkAMUC4Ezg6IOmhAGLISumC9Wp
         h8GoENvTJwuJwmXf6PznvMG8QdzoUB7gBfk8/n9p3V3REzsjNAOnqq9lk6w04xQqzFWO
         RxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279289; x=1791884089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1Ln/9VxN6ySADYGeFTkesQbRiqqtYrWtn23BhcT6ng=;
        b=0xnzYxfrStvfyIbgypb2REtQw/1JeaO69oPZM9kl0VHKFLw3DQlnuW6bvaERo8CUzT
         v+WA6lhlM7LroYF+S0XdWdkN8ZT8MMDYq/Ec/6nWTpSz10kYM9CXtgZzzhTXL5Jgnlff
         rKTuuzeJnhUeDm8csjgO5hsTMvKwUwGtTV7GMuESkk05LiAZkuHQR5a2WOPdb7U+9gqa
         RJwG+3CtdITu54xsjMEg6PKAcIEs7Ms9/e4ea6uadu/hrP9PVLPH67GNMOMNP4TK9k34
         bo5SWWVANFGr05bi+T6tz4tpSz3PeGTMcq8WESxuHmyZPabc4Sjoo1K3DlaZqYk+fG1V
         cFJQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8IQII6V+L1b1i+nQDm7zB+HXS1foC9gm30OFYwH8NgVJISeS+H4ibX5K9MLoYkZOm/QYL9HQOxU0l6lk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLomp6PSGFFSVSuak3G5ZwnQKmNdguVY/lq4UKAxUPg5KbFDCFR
	jbLQaC/Wi+04N7j+XprCq3m0ByquAtdrSkSwQpFjecGHd0T7txeNfcBM4+6YfdCj
X-Gm-Gg: AYBFou0eyGd3sduMCOiLf38xtv0OxdNpHe8e/uoIhwdocAAD2PgWQcPLwNDneyu7WWa
	DFMUy2EuQbVjkczCrcgtOq+ApodiSwhFGi1ONP5nx6Nnv0Z73iVelI/v/IRei5UUaAAvC66t76Y
	ie38hUWjJMMh81VbH+uVHASteIvmbJ8rEeLtMy9wUI5klJX33tBtuMv8bkRZgc31ZeA0rcn1Zsk
	WRH2TPwIlz7JFVLUG7girxWEizp36eenQOZyCMUbkmn0udxlSEECUpOkRoJaUfMaYkGvbKRTgpr
	WfsInhv0voKmD+ikves0hGrkcGFoLN2mQzfKOblzGEgxI1qenlwLviH0OZ33c7PJEtqviKLvjBa
	6+00o7SzvdQtmUXnxuVNMpujm8hr2bxGf7C9zRJOGlDBErAgn5Z7wPgliQ3nAJtN1kUL1/U1WOw
	0crY1nni5+XwMufJ7ari/+Q2PqF3+EcgLKeJ275IPQUJSP+kl1fEzChzjmvT+oulTDv8H0Tvo=
X-Received: by 2002:a17:90a:f94e:b0:3a4:c18c:b8a5 with SMTP id 98e67ed59e1d1-3a8737d4695mr500390a91.58.1791279288855;
        Tue, 06 Oct 2026 02:34:48 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:48 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 7/8] scsi: target: keep pscsi mode bytes inside the data sgs
Date: Tue,  6 Oct 2026 17:33:37 +0800
Message-Id: <20261006093338.27342-8-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pscsi_complete_cmd() writes the write-protect bit at a fixed header
offset.  MODE SENSE uses byte 2 and MODE SENSE (10) uses byte 3.  The
allocation length is allowed to be shorter than that header.  One byte
at page offset 4095 makes the store the next physical page.

On a tape device the same function then reads the MODE SELECT block
descriptor through sg_virt() of the first sg.  MODE SELECT needs byte
11 and MODE SELECT (10) needs byte 15.  A short first sg is not checked.

Read and write those bytes across the whole data sg list.  A header
that spans entries is still applied.  A buffer that ends first is left
unchanged.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_pscsi.c | 98 +++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fd1b82fc7290..0e37a44f1e30 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -21,6 +21,7 @@
 #include <linux/ratelimit.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
+#include <linux/highmem.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -585,6 +586,51 @@ static void pscsi_destroy_device(struct se_device *dev)
 	}
 }
 
+/*
+ * Copy @len bytes at data-buffer offset @off.  @to_sg writes @buf into
+ * the sg.  Stop when the command buffer or an sg runs out.
+ */
+static bool
+pscsi_copy_buf(struct se_cmd *cmd, unsigned int off, void *buf,
+	       unsigned int len, bool to_sg)
+{
+	struct scatterlist *sg;
+	unsigned int i, skip = off;
+	u8 *p = buf;
+
+	if (!len)
+		return true;
+	if (!cmd->t_data_nents || !cmd->t_data_sg || off >= cmd->data_length ||
+	    len > cmd->data_length - off)
+		return false;
+
+	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i) {
+		unsigned int take;
+		void *addr;
+
+		if (!len)
+			return true;
+		if (skip >= sg->length) {
+			skip -= sg->length;
+			continue;
+		}
+
+		take = min_t(unsigned int, len, sg->length - skip);
+		addr = kmap_local_page(sg_page(sg));
+		addr += sg->offset + skip;
+		if (to_sg)
+			memcpy(addr, p, take);
+		else
+			memcpy(p, addr, take);
+		kunmap_local(addr);
+		p += take;
+		len -= take;
+		skip = 0;
+	}
+
+	return !len;
+}
+
 static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			       unsigned char *req_sense, int valid_data)
 {
@@ -610,21 +656,13 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
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
+			unsigned char wp;
+			unsigned int wp_off = (cdb[0] == MODE_SENSE_10) ? 3 : 2;
 
-				transport_kunmap_data_sg(cmd);
+			if (pscsi_copy_buf(cmd, wp_off, &wp, 1, false) &&
+			    !(wp & 0x80)) {
+				wp |= 0x80;
+				pscsi_copy_buf(cmd, wp_off, &wp, 1, true);
 			}
 		}
 	}
@@ -643,28 +681,32 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 	 */
 	if (((cdb[0] == MODE_SELECT) || (cdb[0] == MODE_SELECT_10)) &&
 	     scsi_status == SAM_STAT_GOOD) {
-		unsigned char *buf;
+		unsigned char bdl_buf[2];
+		unsigned char bl[3];
 		u16 bdl;
 		u32 blocksize;
 
-		buf = sg_virt(&cmd->t_data_sg[0]);
-		if (!buf) {
-			pr_err("Unable to get buf for scatterlist\n");
-			goto after_mode_select;
+		if (cdb[0] == MODE_SELECT) {
+			if (!pscsi_copy_buf(cmd, 3, bdl_buf, 1, false))
+				goto after_mode_select;
+			bdl = bdl_buf[0];
+		} else {
+			if (!pscsi_copy_buf(cmd, 6, bdl_buf, 2, false))
+				goto after_mode_select;
+			bdl = get_unaligned_be16(bdl_buf);
 		}
 
-		if (cdb[0] == MODE_SELECT)
-			bdl = buf[3];
-		else
-			bdl = get_unaligned_be16(&buf[6]);
-
 		if (!bdl)
 			goto after_mode_select;
 
-		if (cdb[0] == MODE_SELECT)
-			blocksize = get_unaligned_be24(&buf[9]);
-		else
-			blocksize = get_unaligned_be24(&buf[13]);
+		if (cdb[0] == MODE_SELECT) {
+			if (!pscsi_copy_buf(cmd, 9, bl, 3, false))
+				goto after_mode_select;
+		} else {
+			if (!pscsi_copy_buf(cmd, 13, bl, 3, false))
+				goto after_mode_select;
+		}
+		blocksize = get_unaligned_be24(bl);
 
 		sd->sector_size = blocksize;
 	}
-- 
2.34.1

