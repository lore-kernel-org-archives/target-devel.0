Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A1D18AFE
	for <target-devel@vger.kernel.org>; Tue,  2 Jun 2026 03:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780370217; cv=none; b=nk5150BwMun2/KxxdfXSD2fIDX9akVbQbEHZ8+KOGvRu47zB9gswWmcp8E7y+1xE5OSbuvqPdxsrlB0aOGDFI4140SII9yckzbnvV0cKjFa+mNMVbmUrB2n/ZXOXF46tPuxL9N4Nohwg2jkQhW5CtlOsYIzQcGF6xwzeKbPRioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780370217; c=relaxed/simple;
	bh=cLRlkManztla3hkrQwphKDvEJLPU7dof2kesfO+g/bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mWJOn8WGdexzBolfFevTCuP7dHzayee973VnE844iRsUbeHSgpEmDjujuImsMMfUk5eZJ73Lbp6mr6X6Jzxbe70eLZHv4bLClFlkCdHVpFCkHS/I6UBdeL8Z48rFRMd7UWBwb+sGPpgTIwzVBKqAt0Mr5GnOCTNjlbXWWzG1jyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hF5NBcro; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hF5NBcro"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8cceaa6f75bso59899086d6.0
        for <target-devel@vger.kernel.org>; Mon, 01 Jun 2026 20:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780370216; x=1780975016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2rvp4uMJYJLjkVFMFUq0IQ2nbL1Lu2+k0H7Lh2NiUUU=;
        b=hF5NBcro3Bp0segdLi6nKgC8nt1tqTxB8gvDcvi11c/UA9xyW+EBPotcymZDjzfSTp
         9NYZ2qcCs8X3qVb+14o4+aSYiS7TS0LVjZT55V8sHPUyEV0Y3h5ntCXfA1uYX2j4cUpk
         OvjNyNVaA/oD/R0LYFhnjhaPkYwehvVKbBQuUxIU9wltmjPAq1g/MxFL4ka9eGWVPEcq
         XA9n3tCIKEw16NvkGjoys+lNlLpKbyeEOpyBN6HMN8skvj5Oo6AkYuqbwXY28iZt9Xwx
         uHMLnM6Q7cvGV0WOnATsQBU+dfJ+PFGxcZERq+6eYNU3XKyTA6+V7NnfeUelt7aYxk1h
         IWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370216; x=1780975016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rvp4uMJYJLjkVFMFUq0IQ2nbL1Lu2+k0H7Lh2NiUUU=;
        b=fjbeDLK1sVGfu+JJNTdBM5VpWIOOUXrfDOYEX0n8BJB/hV6xqOP87H297XEuC33nmX
         NsFBVxVlTE4AEjlsepNBdu1jdhLPZ0fcXycvBsd5DC4LH1AU2OM+AL6UylVa20vGJaNx
         K76eHzW2aN2jxK5RcBq4lm9EQOrFD8R35QYyzUGVlqBIRDc8/6safYzI6dHheuK2X/uH
         uIFzFfSA/v0osk5lf50mDr4kkdY3ePzrZqR72lSfJ9F5Ox1TJmVRbix2nLdmmzKbBMVU
         t3r1kDHgLdu0frdkJJL1FBVuxUmRC4pieMl0hKul7IIrdmU+Oi4Y98J1upVoG4NzIXOO
         5VxQ==
X-Gm-Message-State: AOJu0YyxiObhpCEyz6NlWYJoBpjaA5JIP+cJWRs7KREimq9oiSR2oSx2
	7MDvnAerw8hBJua6uAOx80p7wR5tBGrJg0IJFyGK8kGSeMOo9stUGGnTErIn+C6l
X-Gm-Gg: Acq92OFsZ+aawy4podzthOR8rtf8BnaWnDE67i568QHiuzcW4zUL9C5/eQPqiqpSJUn
	dPBRwTHWqk6PAMH6vYmx+tD9/eg3ozb+gbg5ZhBvj/Yn+WnMf58yS+rwK7ZYODoepDxpA7C1Vej
	6Bo0yJsuXHhmbqyQrjQqDxXi2dv/D7k/XgpjdFkX43hHckV8TjXDhfxEnxnHqs/d6o4vUgeNkNb
	ugUI+tosW3IX2tVYS7qedgjusrtZ2oj6nYj09pw6+pO1l1AJ9kegUGxxwqBYwP6hqr3dwT+6DQm
	m/jbhvOm03wwqR70UieXyOvWeGp0mv4SAW6GAvy2NkLsKyt3Iy8+ba20yPQYHjXVl7bOWIg2I49
	DSpzQYRStXQft5LJ4VClck0k7ZPAjfE5yxl5jmWtDKpB7+J1cnlpoE+r36+j0ehPzq009BAGCc5
	ozWnDkKORxSg95z+vqW2b0+0p6EF9or6tk1t9I+BI9MmQb2nL99JzcWqo0cCp9JCtvznsGyd8n3
	4izL/cO54Gkdmj5YA7uqV0k2w==
X-Received: by 2002:a05:6214:5404:b0:8bd:de6d:c340 with SMTP id 6a1803df08f44-8ccefd9355bmr243183826d6.26.1780370215578;
        Mon, 01 Jun 2026 20:16:55 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea231e12sm108881986d6.41.2026.06.01.20.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:16:55 -0700 (PDT)
From: Jeremy Erazo <mendozayt13@gmail.com>
To: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: validate ECDB AHS length
Date: Tue,  2 Jun 2026 03:16:54 +0000
Message-ID: <20260602031654.3462944-1-mendozayt13@gmail.com>
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

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
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

