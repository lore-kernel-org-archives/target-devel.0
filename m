Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56C54908C0
	for <target-devel@vger.kernel.org>; Fri,  4 Sep 2026 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526281; cv=none; b=tgjm+rDTmbaFZZB8uyFsVuakUDryP6qvT8HlJR5rKIAFsCSCc1TsyBj2oI2bo62kmCYTTdU+MpL3mLM6l8TZBsaIWn0mk7FkxHr5R0lxlyOblELNIMyRygY99Ql6yepeSVmO1H0bPbE3m8Z0JVik71+/VwIBkRLau+w6jpdN4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526281; c=relaxed/simple;
	bh=qrxYd+dt37Pe1GMjqFV/nYaWaKAThqfGvMluiNGMYeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xtk72eZWPNRGxjg6vFF5h5FEEPIKD4D32XduB1mZjvBeR1B+W+vqV/PLlz4f9sTz58YgHRn2GK9r4TQ6s3kU7sZ/U6nShPfo+kiatEtKrIg5Y8c69o+OrbDzYHiLV26CSnfNBO0Jh5c91wqfmK+kLYK1ffSFm3AZrQmC//NbnhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O8fx5Zle; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O8fx5Zle"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6b1b9c3af5cso790738eaf.2
        for <target-devel@vger.kernel.org>; Fri, 04 Sep 2026 05:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526278; x=1789131078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=01VUs/XTkap+IEnmurcqlPrtlSflSCjekh84gJJmzvg=;
        b=O8fx5ZleThtQvYu2iR09o2z2jAYjWIJZtL0MSQFi56VBCZkv2doiixmOgisWV9MJj6
         Mjh7xbeJhMg98snmgaNaF1ny+c6LUhQUhUQRp1oX6/0lKcCwaomZBq9oX8tL3cfxLg0s
         bOCXjXiPMXzL24pFyoh7wTcMzbVdEu22BdoVp9P+QvxQ9s+XwY/fKYxtK2bYd/wnSd/Q
         rI7vQ/tbgjTXb+//qj4Sga7Rn2Xf7MjfHE1I7DWbSSo+9+aVrwH4qy18Kbsh6UqmEnIU
         e0U8HKlOFhi8e33qQlvDunNHCB7sZtA3cqnLZiU1eYX4MIzNoNgQpHZMso8ceBb0B86o
         488A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526278; x=1789131078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=01VUs/XTkap+IEnmurcqlPrtlSflSCjekh84gJJmzvg=;
        b=Hfp6hZII+fzW/6pPRayJn+yUOwUS+N0bGOOBPZnilcZM7RXXA013Qzq9L/Y9LG/FXz
         AjusDHqk090fadc8k0AEWRfHQKv6qPJROOCjnZi08G+TH5ZcsahdhtKlo8aGnymDfPlq
         PMdB7omLrKcl2rEkiJVRTGd4qS4zGmzsRSSQQ0ynXJTAvRjwVDKNnqYNnqqT1Tteswxb
         3b1RFmNTCViJZZvDjgd+/nZSYlo6dyHvVbzV0tp7Q+ff7dlvJBjojeWKlS+eMzM3dJyQ
         jnq749HsFQAE7rH+inR4bwZEGkJO8Bh3N3L2tLcFZfehAwf0bsV3h1unFgkphdDWSS90
         uQFA==
X-Forwarded-Encrypted: i=1; AKwUvBwryBLf5LQpKRULRd3cInOd1pumpzK9wEoIIJTAiLhFf4QsNTAxOnuzx/Gt88HMw3arQ+X9n+Fd5A/G3wY=@vger.kernel.org
X-Gm-Message-State: AFuF++l2q6EDJegI5NURPs3hgZ9zaaiZAdb3Ljva9nYgQmKSHNjaZxQR
	wckbYh7DuLIE1sIv9d+oHgXJ0zQ3MJH25G4q9KuVzEX0VW11mDtySQYz
X-Gm-Gg: AYBFou0TwCj/vz4DlyF3kQaTgf9xZTv+KC9qKjNzE8bOx7VVCPP2k5LI54hRBTL+lTk
	Gpi9ZFjAkydCQwS130Rc8xKrMY8Qa3IzP5B1gVV494vnMGvgPKmWoi7qgm3UAZVpf1XEITeYnyf
	s423H04nCLWGV4R7J1CL53rNnt8hphEOhL1IYzBF2I0CeqQQLW8g330YQQm3ZsNUB3SyuR+Pjwu
	qPdAE19nn1P7x0RsPDR9uIr8Ri7qmD6y8hSpkvQRerbSZ+pDaVF/lWKH8K+KElWUst7FASxeCXI
	Zv3iFrwhwJwBTswPunZehg8ndQW3R60Mwjb5RrWmwjijUif7XFC9jOGMqxv708xfo7CTqoIUfIZ
	hW3ny+/oC6EGLp1PS2q9GBp/6MhKTJX/FOZeBrC3FwGCjYKPwewvj/sMspkITPA7XBKSLcu4uW6
	UYaxgK2TYWrYUXlfF6BXoj83nBRmlF0BnSTOs2siy/IxDmgUF9X3S613qTXhNnzYCSz1UpTOq8L
	GHGXCwtFArycjh15upb98mtgQ==
X-Received: by 2002:a4a:e84a:0:b0:6b1:4a71:775a with SMTP id 006d021491bc7-6b6fcbde97emr3668982eaf.19.1788526277676;
        Fri, 04 Sep 2026 05:51:17 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432424d27asm9649360c88.2.2026.09.04.05.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:51:17 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] target: fix typos in comments
Date: Fri,  4 Sep 2026 18:21:08 +0530
Message-ID: <20260904125113.11494-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c       | 4 ++--
 drivers/target/iscsi/iscsi_target_erl0.c  | 4 ++--
 drivers/target/iscsi/iscsi_target_login.c | 4 ++--
 drivers/target/iscsi/iscsi_target_tmr.c   | 2 +-
 drivers/target/iscsi/iscsi_target_tpg.c   | 2 +-
 drivers/target/target_core_pr.c           | 2 +-
 drivers/target/target_core_transport.c    | 4 ++--
 drivers/target/tcm_fc/tfc_io.c            | 2 +-
 include/target/iscsi/iscsi_target_core.h  | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210..7f0f513ca95a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -108,7 +108,7 @@ void iscsit_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
 
 /*
  * Note that IQN formatting is expected to be done in userspace, and
- * no explict IQN format checks are done here.
+ * no explicit IQN format checks are done here.
  */
 struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 {
@@ -4545,7 +4545,7 @@ static void iscsit_logout_post_handler_closesession(
 	/*
 	 * Traditional iscsi/tcp will invoke this logic from TX thread
 	 * context during session logout, so clear tx_thread_active and
-	 * sleep if iscsit_close_connection() has not already occured.
+	 * sleep if iscsit_close_connection() has not already occurred.
 	 *
 	 * Since iser-target invokes this logic from it's own workqueue,
 	 * always sleep waiting for RX/TX thread shutdown to complete
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 24db6b07493e..38c1574a855d 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -343,7 +343,7 @@ static int iscsit_dataout_check_datasn(
 
 	/*
 	 * Considering the target has no method of re-requesting DataOUT
-	 * by DataSN, if we receieve a greater DataSN than expected we
+	 * by DataSN, if we receive a greater DataSN than expected we
 	 * assume the functions for DataPDUInOrder=[Yes,No] below will
 	 * handle it.
 	 *
@@ -394,7 +394,7 @@ static int iscsit_dataout_pre_datapduinorder_yes(
 
 	/*
 	 * For DataSequenceInOrder=Yes: If the offset is greater than the global
-	 * DataPDUInOrder=Yes offset counter in struct iscsit_cmd a protcol error has
+	 * DataPDUInOrder=Yes offset counter in struct iscsit_cmd a protocol error has
 	 * occurred and fail the connection.
 	 *
 	 * For DataSequenceInOrder=No: If the offset is greater than the per
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index aafc94bcb635..790928012ce0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -548,7 +548,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	 * We use the original ExpStatSN sent in the first login request
 	 * to acknowledge commands for the failed connection.
 	 *
-	 * Also note that an explict logout may have already been sent,
+	 * Also note that an explicit logout may have already been sent,
 	 * but the response may not be sent due to additional connection
 	 * loss.
 	 */
@@ -1261,7 +1261,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	} else {
 		/*
 		 * Add a new connection to an existing session.
-		 * We check for a non-existant session in
+		 * We check for a non-existent session in
 		 * iscsi_login_non_zero_tsih_s2() below based
 		 * on ISID/TSIH, but wait until after authentication
 		 * to check for connection reinstatement, etc.
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 620de3910599..aa73cc0f504b 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -450,7 +450,7 @@ static int iscsit_task_reassign_complete(
 /*
  *	Handles special after-the-fact actions related to TMRs.
  *	Right now the only one that its really needed for is
- *	connection recovery releated TASK_REASSIGN.
+ *	connection recovery related TASK_REASSIGN.
  */
 int iscsit_tmr_post_handler(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 {
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 99772364c88e..db140bb48def 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -308,7 +308,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
 	}
 	/*
 	 * Make sure that AuthMethod does not contain None as an option
-	 * unless explictly disabled.  Set the default to CHAP if authentication
+	 * unless explicitly disabled.  Set the default to CHAP if authentication
 	 * is enforced (as per default), and remove the NONE option.
 	 */
 	param = iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 25b1bcacc0c8..3cd23ea321ae 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3655,7 +3655,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	}
 	/*
 	 * If the backend device has been configured to force APTPL metadata
-	 * write-out, go ahead and propigate aptpl=1 down now.
+	 * write-out, go ahead and propagate aptpl=1 down now.
 	 */
 	if (dev->dev_attrib.force_pr_aptpl)
 		aptpl = 1;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe94594916..14c60afb16f2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1869,7 +1869,7 @@ EXPORT_SYMBOL_GPL(target_submit_prep);
  * This may only be called from process context, and also currently
  * assumes internal allocation of fabric payload buffer by target-core.
  *
- * It also assumes interal target core SGL memory allocation.
+ * It also assumes internal target core SGL memory allocation.
  *
  * This function must only be used by drivers that do their own
  * sync during shutdown and does not use target_stop_session. If there
@@ -3505,7 +3505,7 @@ static const struct sense_detail sense_detail_table[] = {
 		 * REGISTER AND MOVE service actionis attempted,
 		 * but there are insufficient device server resources to complete the
 		 * operation, then the command shall be terminated with CHECK CONDITION
-		 * status, with the sense key set to ILLEGAL REQUEST,and the additonal
+		 * status, with the sense key set to ILLEGAL REQUEST,and the additional
 		 * sense code set to INSUFFICIENT REGISTRATION RESOURCES.
 		 */
 		.key = ILLEGAL_REQUEST,
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 45329284f52f..9568042b200c 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -248,7 +248,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		 * header is posted in receive queue.
 		 *
 		 * If "Sequence Initiative (TSI)" bit is not set, means error
-		 * condition w.r.t. DDP, hence drop the packet and let explict
+		 * condition w.r.t. DDP, hence drop the packet and let explicit
 		 * ABORTS from other end of exchange timer trigger the recovery.
 		 */
 		if (f_ctl & FC_FC_SEQ_INIT)
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 51ca80abacf7..ccaa28c3abad 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -57,7 +57,7 @@ struct sock;
 #define TA_CACHE_DYNAMIC_ACLS		0
 /* Enabled by default in demo mode (generic_node_acls=1) */
 #define TA_DEMO_MODE_WRITE_PROTECT	1
-/* Disabled by default in production mode w/ explict ACLs */
+/* Disabled by default in production mode w/ explicit ACLs */
 #define TA_PROD_MODE_WRITE_PROTECT	0
 #define TA_DEMO_MODE_DISCOVERY		1
 #define TA_DEFAULT_ERL			0
-- 
2.48.1

