Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236237;
	b=4+i5QmC1nEZn0EvMxUfztddET0lVUADQtTOMT74HFJp+VyATPBlWbH1Bqivw9NVDmsGR
	 j2HMyxGkd57B+feT0zOu22LeVQPYvH5okKmdC4frM2YAJtdfvVUTcZiwC3KvJiv0YQ4T1
	 71MBi6mLHG7L1KPuw+m7qnPXKFpVFwPnB0WS2bSGmUc9bZi2vd509luAt5atfuqhpeN4e
	 nuEQe4WqsZ/CNUXtPyOZjVXW74GHHKluSAnE9JeVtn7WQsB5fy6vCEvVyWqpAU1+4cRH2
	 BSIOiMO91Gf6BA7whhGNbPxDqv5skYGwqe/GUKjBH3PtqbRoFncqZ/hjCK+zTpZhjXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Sender:From:To:Cc:
	 In-Reply-To:References:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=WnGcSIDD8xsihnvux7kQF612pALMJnteuiV/uKYZ0Nc=;
	b=vzKyOKKM/tju7b05Bxr5EEEe1wJ4SpKDat0Jddx4BmH8PX2hwytZBSNdKJbT/hbuFphm
	 vYg33biHpA75JmFATjHriQzLr14Wf42TJNimhQJVBPN0oWbvSCYBj1UJLOykzz/mHv3Jt
	 aOF5EgNuSo4N6qAlEwmuuw7OjT5aE0nWfPixnexiPk0qmAZWcPzLXM+djZqCUnzaxykUv
	 EfTU29uOQ5jOvw6RRjL74eQsmZnunKPwf2UTVnIUyWkmv9XuB0L94N8kb1+gFLadh/SQA
	 a06rU7OjDOacYgWTikReAcXfekoZCJQXeko5UvrC50xrhRYfFBl1SEhBJJtPFYIWJwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWDoxDB;
	arc=none smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBCF606A325
	for <target-devel@vger.kernel.org>; Mon,  9 Nov 2026 14:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FBCF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWDoxDB
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b305d38bafso6373127b3.3
        for <target-devel@vger.kernel.org>; Mon, 09 Nov 2026 06:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794236235; x=1794841035; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:references:in-reply-to:cc:to:from:sender:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WnGcSIDD8xsihnvux7kQF612pALMJnteuiV/uKYZ0Nc=;
        b=sgWDoxDB9GBkZ5cRKpqIm9Car53R0jvltFnT3c93vi7tnQMMfsvSx8ddfcb2gmfwe9
         gK8kJUSV5QcvTGlLUq/i8fzhND/XKrxbI/VWOXEl6YPFn4HCEre2ftX4gwtD4ww5EoVZ
         JMqXr0sWdOG7hUu+1z3yq9fUMO9Bf1qQlCz2xDvnRFwIJu1UhPhSufztgH/UfDDfZqNk
         rlpLPs330hEvuM55M0W6DNIl7xL60CJEpcn3PfuOpTQn+tkDnUJcCMaJw/CHlERZiLd3
         ZVMnSQEqed7CVjyJwY6g6N7Fc7Yu/l6seM2eY+mqzEERpH9BvhxQ6Ud85AVLQGZ/uK96
         CZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794236235; x=1794841035;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:references:in-reply-to:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WnGcSIDD8xsihnvux7kQF612pALMJnteuiV/uKYZ0Nc=;
        b=Whp4PjTQngD4HEuIbGFxtVskxtPw9HK5yT0FLc4eC0VH82J2+kM+COmORtSKb+9qqH
         uoCzJn7pCDvTGqFyhRCKZc8dVJs/uDFkor4rlwbcEV8X3bBSiZlcakv1j6bN59lm+f8y
         Ot8nKTUjvNl6M+39pwtWm0D0aduN7DXVXgEpCj95996Hrqn7icYayTwFywpXmSmpijhM
         9YjGGSSHco9Khhw6yW4z14O663O6i9D/i8IBt1ZFoqANPQrdEFOij2Ydi7sS2em5WexW
         c7PRUt05kjYehdZFl4MESTokNyHTTqaTqEIDsKOnNy1KHgO9a2ZGiZ0GadoDXQZZm2w7
         fmZQ==
X-Gm-Message-State: APuU4Z+RTA0eI9TEgjf8Hltxtl1232YPk941qP4JStX+dzCGzF3WK7yd
	BfJQZyJSfRv3S2mfuk79tHdOGOYnWIGZD/FbTX3aRP5ZsOo1hitsppLq
X-Gm-Gg: AYBFou2l0BvQsfD5XA1HYt2++z1+QwmvfGXUn1H5Z+ZS6Q8nN2Cpdqs+h6+TUwsR4k+
	B86i+YVVi1VxTYZHvkkPS3FtSesPeaGBLbHvOQ0HYFCHzA7ICPmPuK+AYE3hxfFDKtL/nuWGsXY
	x9lk5a/NH7ngYgqDbxhaD6dmo76IlXkHWr4Ecqy5f8vOfva74+O6cKu+xH1LlJKbetWnJHXHfES
	kpe4hIEfnjMJMUQM8TNKFutU/wtY4PKYQWAIdqaOW/HgycmrJ78bDEtFiqutOkYvNFEmDyqvQsU
	0GPogDxTKlSEcSq/gRjJMg65ldBoqXTVkWMbdEbTmlvFNC4U0CTzfdiYuJ3BKP+bNZkROJbOnjv
	/oP2NQm2tYYQXxZLYZOeoQpcWDDRqOOMHG8whT0GSpyye2bOnUJ5X/qzLFEl6YtB9Eht7Igr4rf
	uUPB0DwEvlhLGJqpWbTcvf1XqpAw21kWqYcWGoIJl6wF7WF4NOaZLGE6H2KSVrofEgJrPNoQD9R
	29mm1XZw+Nuv0U8TgnF4ZyVubfzGdVuoiixtSUfyIYJvzGSQPvK5J2ba8BugPOFhcurol8TzmNS
	ieb1kV00/V0+JK6/SFXv79MziXaixWCp+5HKW+p23Fq/qFAUG1RQEqBB7Ul2UyMfwhxuqOiY5w=
	=
X-Received: by 2002:a05:690c:399:b0:8b3:90db:a7d3 with SMTP id 00721157ae682-8b390dbcf9emr105627b3.40.1794236235307;
        Mon, 09 Nov 2026 06:57:15 -0800 (PST)
Received: from nb-x1-03 ([181.120.144.175])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b36bbe8ce7sm37040637b3.25.2026.11.09.06.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 06:57:14 -0800 (PST)
Sender: Ciro Iriarte <ciro.iriarte@gmail.com>
From: Ciro Iriarte <ciro.iriarte+software@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <591ac67a-fa1e-4395-9573-2d9405cfe0b6@gmail.com>
References: <591ac67a-fa1e-4395-9573-2d9405cfe0b6@gmail.com>
Subject: [PATCH v2] scsi: target: compare all six ISID bytes when identifying a nexus
Date: Mon, 09 Nov 2026 11:31:01 -0300
Message-ID: <8b1ac7d9-b0e4-42ac-b8a2-c4c70cccdddc@gmail.com>
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

lio_sess_get_initiator_sid() reports the ISID as twelve hex digits, and
iSCSI TransportIDs carry the same digits. __transport_register_session(),
__core_scsi3_do_alloc_registration() and
core_scsi3_alloc_aptpl_registration() turn that text into
sess_bin_isid and pr_reg_bin_isid with get_unaligned_be64(), which takes
the first eight characters, i.e. the first four ISID bytes.

open-iscsi ISIDs start with 00023d00 and differ only in the qualifier in
the last two bytes, so every session of one initiator gets the same
binary ISID. target_scsi2_reservation_check() and
target_scsi3_pr_reservation_check() then treat any session of the
reservation holder's initiator as the holder:

- after RESERVE(6) on one session, another session of the same
  initiator can still write;
- with a Write Exclusive persistent reservation, another session that
  is not registered, or registered but not the holder, can still write.

Reproduced with two open-iscsi sessions (ifaces default and if2) to a
ramdisk LUN: on v6.12.113 every TEST UNIT READY, READ(10) and WRITE(10)
the test sent from the second session completed with GOOD, under
RESERVE(6) and under each persistent reservation type, whether or not
that session was registered.

Convert all six bytes. Text that is not exactly twelve hex digits keeps
the old conversion of its first eight characters, now copied into a
zeroed buffer so that a shorter string, such as an initiator_sid written
to res_aptpl_metadata, is not read past its end.

An all-zero ISID now converts to 0, which
target_scsi2_reservation_reserve() took to mean "no ISID". Set
DRF_SPC2_RESERVATIONS_WITH_ISID when the fabric reports ISIDs instead.
Also update the TransportID parser comment that referred to the
get_unaligned_be64() read.

With distinct ISIDs, target_scsi3_pr_reservation_check() now sets
isid_mismatch for the holder initiator's other sessions, and
core_scsi3_pr_seq_non_holder() treated every such session as
unregistered: DEF_PR_REG_ACTIVE is kept per se_dev_entry, which all
sessions of the initiator share, so it cannot tell them apart. A
session that registered its own key would then get RESERVATION
CONFLICT for writes under a Registrants Only or All Registrants
reservation, and for PREEMPT, CLEAR and RELEASE. Look up that session's
own registration with core_scsi3_locate_pr_reg() instead.

With this patch, TEST UNIT READY and WRITE(10) from the second session
under RESERVE(6) return RESERVATION CONFLICT. Under Write Exclusive,
WRITE(10) from the second session conflicts whether or not it is
registered, and READ(10) is allowed. Under the Registrants Only and All
Registrants types, WRITE(10) from the second session conflicts until it
registers, as does READ(10) under the Exclusive Access types; once
registered it has access and can PREEMPT the holder.

Initiators that relied on the old behaviour, reserving through one
session and writing through another without registering it, will now
see RESERVATION CONFLICT, as SPC requires.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Signed-off-by: Ciro Iriarte <ciro.iriarte+software@gmail.com>
---
v2:
- core_scsi3_pr_seq_non_holder(): on an ISID mismatch, look up the
  session's own registration instead of treating it as unregistered.
  v1 made that path reachable for the holder initiator's other sessions,
  so a registered second session got RESERVATION CONFLICT under the
  Registrants Only / All Registrants types and for PREEMPT, CLEAR and
  RELEASE (Sashiko review). Re-tested on v6.12.113 with types 1, 5-8
  and PREEMPT/RELEASE/CLEAR from the second session.
- Fixes: now points at c66ac9db8d4a, which added the get_unaligned_be64()
  conversion; e48354ce078c only made it reachable (Sashiko review).
- Reworded the TransportID parser comment.

v1: https://lore.kernel.org/r/591ac67a-fa1e-4395-9573-2d9405cfe0b6@gmail.com
 drivers/target/target_core_fabric_lib.c |  9 ++---
 drivers/target/target_core_pr.c         | 46 ++++++++++++++++++++++---
 drivers/target/target_core_pr.h         |  1 +
 drivers/target/target_core_transport.c  |  2 +-
 4 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index ad024009d..ccfeba645 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -372,10 +372,11 @@ static bool iscsi_parse_pr_out_transport_id(
 			return false;
 		}
 		/*
-		 * The registration code reads the ISID as a C string,
-		 * and its first 8 bytes with get_unaligned_be64(), so
-		 * require 8 bytes after the separator and a NUL inside
-		 * the rest of the descriptor.
+		 * The registration code reads the ISID as a C string, so
+		 * require a NUL inside the rest of the descriptor.  Keep the
+		 * existing minimum of 8 bytes after the separator: a valid
+		 * ISID is twelve hex digits, and target_isid_to_bin() falls
+		 * back to the first eight characters of anything else.
 		 */
 		if (buf + tid_len - p < 8 || !memchr(p, '\0', buf + tid_len - p)) {
 			pr_err("Incomplete or unterminated ISID in iSCSI Initiator port TransportID\n");
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index ca1a2802a..0f2ff9d42 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -19,6 +19,7 @@
 #include <linux/fcntl.h>
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
+#include <linux/hex.h>
 #include <scsi/scsi_proto.h>
 #include <linux/unaligned.h>
 
@@ -30,6 +31,28 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+/*
+ * lio_sess_get_initiator_sid() prints the six ISID bytes as twelve hex
+ * digits, and iSCSI TransportIDs carry the same digits.  Convert all six
+ * bytes: reading the first eight digits as a big-endian u64 keeps only the
+ * first four ISID bytes, so two sessions of one initiator that differ only
+ * in the qualifier, the usual case, would compare equal.  Text in any other
+ * format keeps the old conversion of its first eight characters, without
+ * reading past the end of a shorter string.
+ */
+u64 target_isid_to_bin(const char *isid)
+{
+	u8 bin[6];
+	char raw[8] = {};
+
+	if (strnlen(isid, 2 * sizeof(bin) + 1) == 2 * sizeof(bin) &&
+	    !hex2bin(bin, isid, sizeof(bin)))
+		return get_unaligned_be48(bin);
+
+	memcpy(raw, isid, strnlen(isid, sizeof(raw)));
+	return get_unaligned_be64(raw);
+}
+
 /*
  * Used for Specify Initiator Ports Capable Bit (SPEC_I_PT)
  */
@@ -285,7 +308,11 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	dev->reservation_holder = sess;
 	dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS;
-	if (sess->sess_bin_isid != 0) {
+	/*
+	 * An all-zero ISID converts to 0, so test whether the fabric has
+	 * ISIDs rather than the value.
+	 */
+	if (tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
@@ -323,7 +350,18 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			 * RESERVATION CONFLICT on some CDBs */
 
 	if (isid_mismatch) {
-		registered_nexus = 0;
+		struct t10_pr_registration *pr_reg;
+
+		/*
+		 * Another I_T nexus of the holder's initiator.  DEF_PR_REG_ACTIVE
+		 * is shared by all of its sessions, so look for a registration
+		 * made through this one.
+		 */
+		pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, nacl, se_sess);
+		if (pr_reg) {
+			registered_nexus = 1;
+			core_scsi3_put_pr_reg(pr_reg);
+		}
 	} else {
 		struct se_dev_entry *se_deve;
 
@@ -674,7 +712,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	 * save it to the registration now.
 	 */
 	if (isid != NULL) {
-		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		pr_reg->pr_reg_bin_isid = target_isid_to_bin(isid);
 		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
 		pr_reg->isid_present_at_reg = 1;
 	}
@@ -866,7 +904,7 @@ int core_scsi3_alloc_aptpl_registration(
 	 * SCSI Initiator Port, restore it now.
 	 */
 	if (isid != NULL) {
-		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		pr_reg->pr_reg_bin_isid = target_isid_to_bin(isid);
 		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
 		pr_reg->isid_present_at_reg = 1;
 	}
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index b793c9963..4debfe4be 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -72,6 +72,7 @@ extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
+u64 target_isid_to_bin(const char *isid);
 
 extern sense_reason_t target_scsi3_emulate_pr_in(struct se_cmd *);
 extern sense_reason_t target_scsi3_emulate_pr_out(struct se_cmd *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30..4629c9343 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -419,7 +419,7 @@ void __transport_register_session(
 			memset(&buf[0], 0, PR_REG_ISID_LEN);
 			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
 					&buf[0], PR_REG_ISID_LEN);
-			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
+			se_sess->sess_bin_isid = target_isid_to_bin(buf);
 		}
 
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
-- 
2.55.0

