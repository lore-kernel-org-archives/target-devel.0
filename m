Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDCA439F98
	for <target-devel@vger.kernel.org>; Mon, 31 Aug 2026 13:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182516; cv=none; b=ghD9O9lUjZJoJ4cvTZx6Cq3ycgKAYrvL7ETIeVUXFZJ694/DZJR4Syuqss88TTi/B8f+FohIo/YxSFkhTbI6cunNDdGrWVcSeb+fpMVvjm2QMQw9SI49HuDEMJx/lfABvZOq6NJEmYnxCCHn8DPkOInOdRJFgLDHqLp+tx0i+fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182516; c=relaxed/simple;
	bh=Z99y3W+Jp+BBxP0dT9ocAAQAdReiGw83GVMdtID0gnk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=LD9+oJFAcTHk9XPmK8wxQGJPst0OI6CEyYoFaLrLf7MRK7IyfnJ+bHgRgt7VWXg4DnM0FCZsq7Htekknp1/Xz26Lz4wUsbQZlMtG5wa/jyn8JFkrcmTDlXDof66qPUNyx9LtSqNsL4VPGkwa+b7n4SDIpxTJiS89ubyPQECNdvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ms5JCFAd; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ms5JCFAd"
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z99y3W+Jp+BBxP0dT9ocAAQAdReiGw83GVMdtID0gnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788182511; v=1; x=1788787311;
 b=ms5JCFAdnCK2sG1FBW8TbQSMrivPaJFIrsNdvt+gG4U1ZKNwz7Db7DW2+uBtOm9JqmFQqxCX
 1wuvH16Tet9mH1dDwx4xRWHElhl9X6Y7BPKzOMR2vjDX5WoFFOHAHZNG5M6JkAYnrmnGD5FM2td
 CwpURsBBq/MticoqeDem2UDk=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 06215eb84a0c848f;
	Mon, 31 Aug 2026 13:21:51 +0000
X-Mizu-Trace-ID: 06215eb84a0c848f
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 31 Aug 2026 13:21:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
TLS-Required: No
Subject: [PATCH] scsi: target: fix PRIN READ_FULL_STATUS buffer bounds check
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Tianchu Chen <flynnnchen@tencent.com>

core_scsi3_pri_read_full_status() writes one Full Status descriptor
per registered I_T nexus into the PRIN response buffer: a fixed
24-byte descriptor header followed by the variable-length
TransportID.  The overflow check, however, compares

	exp_desc_len + add_len > cmd->data_length

where exp_desc_len covers only the TransportID and add_len
accumulates only after completed descriptors, so it undershoots the actua=
l
write extent by a constant 32 bytes (the 8-byte PRIN header, since
off =3D add_len + 8, plus the 24-byte descriptor header), leading a
remotely-triggerable heap OOB-write.

The allocation length of the PERSISTENT RESERVE IN CDB is fully
controlled by the (possibly remote) initiator and truncates
cmd->data_length, so an initiator that registered itself can pick a
data_length in [desc_len, desc_len + 31] and make the first
descriptor write up to 32 bytes past the end of the command's data
buffer.

Base the check on the actual write offset instead, so the test
covers exactly what the loop is about to write (24-byte descriptor
header plus TransportID, matching add_desc_len =3D 24 + desc_len
below), as core_scsi3_pri_read_keys() already does. Same principle
as commit c58a252beb04c ("target: fix buffer offset in
core_scsi3_pri_read_full_status").

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: c66ac9db8d4ad ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/target/target_core_pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index 25b1bcacc0c8f..1d34887e9e845 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3990,7 +3990,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		exp_desc_len =3D target_get_pr_transport_id_len(se_nacl, pr_reg,
 					&format_code);
 		if (exp_desc_len < 0 ||
-		    exp_desc_len + add_len > cmd->data_length) {
+		    off + 24 + exp_desc_len > cmd->data_length) {
 			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
--=20
2.51.0
