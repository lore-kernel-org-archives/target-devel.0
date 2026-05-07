Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591C43FBEA9
	for <target-devel@vger.kernel.org>; Thu,  7 May 2026 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164400; cv=none; b=J8y5+elHsEexbt1rzt9gUBapTFUTQZvdwyV0bJfKBwua+X08EaeJPkbfCyeNXO00waYajvHuTU/CGBOTF6Va+rQ7xsuwXwZ0xYmFgywbpXzTgihpRuzw2mX/bRY7l7kFT+iWWycDwRa7CYaZfmGygmMcsqA6lW07MsMKNnvT7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164400; c=relaxed/simple;
	bh=/n+7llmepQAvJ5J8m7gmaT9JZWY/jvh+7hnDojvXqTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VQMCkcbDoRs0EE3PJky0ljyifvp5BFMZoaN4jnr2mxIJPoy7VGUPFwD9LDkx/AZZPSdG6TfCXNfzaYo99dnLYzHzAdYT04lAWRBTVrKw8utlLMFlRiQhO9i2iuRPAK9S5mTga7QyDdSJB4tj+9p3kvywJ1CTus72A9aiEU7YpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qiMsEF8L; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qiMsEF8L"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-902deb2412fso96762985a.3
        for <target-devel@vger.kernel.org>; Thu, 07 May 2026 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778164398; x=1778769198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5kzcSdsCpo5Y3mn41POdySZcZFAGaT53MIAxz0TRGE0=;
        b=qiMsEF8L1E88iiuA5BvbiIgz8FiS+bFiAP4TF+bxCN5utzEYD0M4/OpGHvpMsOBo8u
         OEspr1NQCQoVplh+6Uw3fcKghu/ULNj1DOtozo+9PCHS2UQLdWexGIuVRUr5d7LrYGal
         a/mCmXVfsyUKkrX9w3jSFZeqHwWWzVfDwkAU8kJarTboXO7xiAwus5W0XbFAFZiD9vaC
         JykfBYLaV7fSg1EyG4LKkh9KjXl1Zw21ClOeOTBeywStGjjerJLQwi/J16xnxdvghj2M
         vr7AXA5JQ178AqePauHy9qFLiQm09boHMTdvQ+/cJn/byeCkCwD5RJ752SgEqIw6vd3m
         /ViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778164398; x=1778769198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kzcSdsCpo5Y3mn41POdySZcZFAGaT53MIAxz0TRGE0=;
        b=bd3qH0sGonOmVpqGcPvjjapsXRElBCPtQRpvncR/iUpT/ESbcxSomJY4SGJHEKBM+M
         pPiQpW0AEXhuAHEGHJt7VJfuKCJUfo8sBU5N6fy4PohwoED7fkomwzeior3jUyk7NVVi
         Xi9Pq6hNSkxQbZxyh1xAZ+TTmcNKg6/ynSSKp5dedmK7axsLkFyzSVIOgWfd/eaWwQ1Y
         zvh8ZcEF59vUde7qfy/jsgzSq4tpnU6tIRQX2zjj36xgRl52cOBYTzh5D9nRrgitb2Fr
         DZOWMmzSU28w7D7FsC1RiB6OzANb6AWbM2jcvSnHzuJes+MffVEAu3hz/HNn9OTWT1+i
         YWmA==
X-Forwarded-Encrypted: i=1; AFNElJ9EwLXVsQNqd8nbpTTEALXXcRqwlk7Spa83HLYmQx8DSP8W2fGOlT4UgOiBwTIAXDfHqYj+NIUXAzBa8O0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy8O6y6GA6dT3Wcj/uN0MlJUAiNDIm+liZn8jHIDtkmF4n7KA7
	ks96fXwzjnBIYjD8ZhwuaplD04OMaDuwGQ9akSgeR0qpjELn0sPXhkYK
X-Gm-Gg: AeBDievTCjIo8p9octmCN5DECAtsnnyidDEOLR0q6c8DWhyojdLwAaFs4UzO9urpJCN
	bxarVY255EGGAK8HVbb/9SMd+04tnQLiWzPAa/eeN7QxOQYC/wg6qrb1fSPHYQSujPzYTtC56bw
	nItuQc9DyUD7ID+IXlUlXg6dNWMUVXk++dnbXF/iAyI9SIVHjKDbTZrPrlIwm5Usiem5/12X92e
	JKiKWWJPCBkj0GUPBv/yDWanGkv8OhT5VdyrdkhYoH5Vl/q2fvvplsrnBJJgIOPppdnyBrDDMcs
	sL945uAAg5DnQE8DeKk56H0y5ZcrxCmUtj76pCtx8QVKKDqdqo9D3LWshfJlREZ9xMmf7fKHewD
	Rpwdbv+pOJZ7C19CEQKfj754IJzVz865O2dAO5VNUo6siJKvYBzOm6A381a/eXcJ1LwGBzg9Ube
	klo9jEBIQ9829rxj/YE8qUwUWRF6wPPbRpkrA8aZjixeGC/ijjXiIb5nwWfveDhAkpjI0KwEV/Q
	9Ds41aHmGk/TKxpFQmwdBBhvg==
X-Received: by 2002:a05:622a:59ce:b0:50f:bd51:f1d2 with SMTP id d75a77b69052e-514621d1bfdmr103573311cf.50.1778164397873;
        Thu, 07 May 2026 07:33:17 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b80a4dsm175420501cf.24.2026.05.07.07.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 07:33:17 -0700 (PDT)
From: "Jeremy Erazo (Devel Group)" <mendozayt13@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jeremy Erazo (Devel Group)" <mendozayt13@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: validate ECDB AHS length
Date: Thu,  7 May 2026 14:25:59 +0000
Message-ID: <20260507142559.2373177-1-mendozayt13@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

iscsit_setup_scsi_cmd() processes the Extended-CDB Additional Header
Segment (AHS) of a SCSI Command PDU without bounding AHSLength,
despite the long-standing "FIXME; Add checks for AdditionalHeaderSegment"
comment a few lines above in the same function.

A SCSI Command PDU sent after iSCSI Login with hlength=1,
ahstype=ISCSI_AHSTYPE_CDB and ahslength=0 reaches:

    cdb = kmalloc(0 + 15, GFP_KERNEL);             /* 15-byte alloc  */
    memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);         /* 16 -> 15       */
    memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
           be16_to_cpu(ecdb_ahdr->ahslength) - 1); /* (size_t)-1     */

On CONFIG_FORTIFY_SOURCE=y kernels the first memcpy is rejected by
__fortify_panic() because the declared destination size is 15:

    memcpy: detected buffer overflow: 16 byte write of buffer size 15
    kernel BUG at lib/string_helpers.c:1044!
    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
    RIP: 0010:__fortify_panic+0xd/0xf
    Call Trace:
     iscsit_setup_scsi_cmd.cold+0x8c/0x224
     iscsit_get_rx_pdu+0x9ec/0x1740
     iscsi_target_rx_thread+0xf7/0x1f0
     kthread+0x1b4/0x200
    Kernel panic - not syncing: Fatal exception

On kernels without CONFIG_FORTIFY_SOURCE the first memcpy fits in the
kmalloc-16 slab object and execution reaches the second memcpy whose
size argument has wrapped to (size_t)-1.

Reproduced on Linux 7.0 with a malformed Command PDU sent after a
completed iSCSI Login.  The trigger is reachable post-Login by any
initiator that successfully logged in (anonymous on demo-mode targets,
authenticated on CHAP-protected targets).  No claim of RCE, LPE or
controlled write is made.

Validate, before any dereference and any allocation:

  - the AHS area received from the socket holds at least the 4-byte
    iscsi_ecdb_ahdr header,
  - AHSLength is at least 1 (RFC 7143 §10.2.2.3 minimum for the ECDB
    AHS, which carries one reserved byte),
  - the declared AHSLength does not exceed the AHS bytes that were
    actually received.

Reported-by: Jeremy Erazo (trexnegr0) <mendozayt13@gmail.com>
Signed-off-by: Jeremy Erazo (Devel Group) <mendozayt13@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target.c | 33 +++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e80449f6c..de291eb6f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1100,6 +1100,16 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	cdb = hdr->cdb;
 
 	if (hdr->hlength) {
+		u16 ahslen;
+		unsigned int ahs_area_bytes = hdr->hlength * 4;
+
+		/* The AHS area must hold at least the iscsi_ecdb_ahdr
+		 * header before any of its fields may be dereferenced.
+		 */
+		if (ahs_area_bytes < sizeof(struct iscsi_ecdb_ahdr))
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+
 		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
 		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
 			pr_err("Additional Header Segment type %d not supported!\n",
@@ -1108,14 +1118,29 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
 		}
 
-		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
-			      GFP_KERNEL);
+		/* Per RFC 7143 §10.2.2.3 AHSLength counts the bytes of
+		 * the AHS that follow the AHSType/AHSLength fields; for
+		 * the ECDB AHS it includes one reserved byte, so the
+		 * smallest legal value is 1.  Rejecting 0 prevents the
+		 * "ahslen - 1" memcpy size below from underflowing to
+		 * (size_t)-1, and ensures the kmalloc(ahslen + 15) below
+		 * is at least ISCSI_CDB_SIZE (16) so the first memcpy
+		 * does not overflow.  Also reject any AHSLength larger
+		 * than the AHS bytes that actually reached us.
+		 */
+		ahslen = be16_to_cpu(ecdb_ahdr->ahslength);
+		if (ahslen < 1 ||
+		    ahslen - 1 > ahs_area_bytes -
+				 offsetof(struct iscsi_ecdb_ahdr, ecdb))
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+
+		cdb = kmalloc(ahslen + 15, GFP_KERNEL);
 		if (cdb == NULL)
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
-		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
-		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
+		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, ahslen - 1);
 	}
 
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :

base-commit: a293ec25d59dd96309058c70df5a4dd0f889a1e4
-- 
2.53.0

