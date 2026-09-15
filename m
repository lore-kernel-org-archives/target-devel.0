Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFD472796
	for <target-devel@vger.kernel.org>; Tue, 15 Sep 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463755; cv=none; b=eDVi1JTKpjFlXpA3gi8Em3KYKNiMvZRKhp8KfO7xSqCsi8IiG7rernbbUD5gkD5kPqPVrRtJajNvGZPgvZcRsV6vS1bWvzvD8wTOQ78R5iJ9BMH779n+0VhynQmPL53iSSSM0MxveSl6IwIli3yn05N+xcwzrg9/wrvvdfl/qGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463755; c=relaxed/simple;
	bh=Hlr9Ut/EovEIElNh/ZcSjW6ek2j9qSFL+qKjDzPgPE0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YJf4XGoMIOerIB8AMlZliiHOkn34fAam+hSFnNOnTWfxAfJyGrOHgcoOfA+rLoE2dZA4oQyjFSVkbHU+UpuJmmj6kEyTlFkurBRCYDdUoM0+LS+mBH/HfG/+a0raQU3uaqvOesvQo/4KjHdsa8dWsLtexxcKdFCLqEsmvaT/UTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ggcircuit.com; spf=pass smtp.mailfrom=ggcircuit.com; dkim=pass (1024-bit key) header.d=ggcircuit.com header.i=@ggcircuit.com header.b=ZxIDr+HQ; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ggcircuit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ggcircuit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ggcircuit.com header.i=@ggcircuit.com header.b="ZxIDr+HQ"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5309a20a55bso29385511cf.1
        for <target-devel@vger.kernel.org>; Tue, 15 Sep 2026 02:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ggcircuit.com; s=google; t=1789463751; x=1790068551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iLK542vtUaly/RpbeUB/EH4PBRh7qkRiR6AHFszoPZg=;
        b=ZxIDr+HQnoLwlj+DTWhlKIjsu0gm5LRR0iYr5bxOTRTwYzQd9cfr/HlpDet/fOAqQU
         SbPmI2qZ4hR4BmNw56cZ21DfwF5tRB9CDHzLA4M3cCIy4++Cfod/YDvEbHY+O0rwneOv
         8HymReQUZMy5+qMP6Gh6Z/fRVivOmmLJGy2r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789463751; x=1790068551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLK542vtUaly/RpbeUB/EH4PBRh7qkRiR6AHFszoPZg=;
        b=XOfX1E17jWdgx+lORJylT6eJNR7+Rp0oQ1ZTt5RsaV7WGuFHE35POihWtkh7dg/PP2
         zmQejQURG2s8higO0qWAJydOPqWcPakurZUL0dB3hFYR7R/pCGZznyzJU7jrWbp5UOaL
         lM+A18jFUODnMPCeIBvPBzzUqfC+GnQNAIqvLneXohIX7M8O2Qjc311VAgDIRhrYYy2N
         KZ5xXt/5NlVdun0g3JjHflcOlihKcLSUX1ksCNeMkV0qLPm3OlQ9wl4Jh1UzUYxknz60
         cfO7PjxfEpGRCRJop5BRFZoeAzRE/7Eqz72XDSWATb6FWg6+fwHuQcHt4e/H0JEThZ1t
         9jIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxMW4viKcR22uiq2qwndysq/Zu/7cAK3a2Jxkcai9c5XKiN9j8RYeM3Vwn8OuBgFTSZm50+bI3nyoxccv8=@vger.kernel.org
X-Gm-Message-State: AFuF++kNnGEWcXBNDqxKXQqQKLV5bjnRXFq6kHXH/ieR7CHXwrgSIytk
	5qfa1xQJkbziAKOPdKM4GVtpRBNZiGAKDvWmtCRPb3Va5lIS8tSemlVanVMLhHQKwwM=
X-Gm-Gg: AYBFou2HgxtSZL02ZbacaOWIXUF9a+JJC495dszkrWiiBUpWpG4OV3982zX9fYdD4ZI
	JYzQXwHYxnPbzNzn5y1HGlLFVeSpLR4Bi4uNZIacwk6aJItPPixae/JC+E4uPIIJWXdd13A2njJ
	rULhZe+kkEofoOYKB9cN7mpBLtG8oJUMD3p+IygavaJAKpbgU3nJiZmkDbZvnbeMXf/4BdjJy2r
	Zf5sMvj5W7+dFgTsB3iYnS1GoT569lSWlvjIdb2C0pOgbMG2E+QTlTJRclmcaTEzjULlDg9qntz
	Oj9FNFxtkmdNSMtWbVaOp3Hp2tvBwZAB2jwmmCO2p8ZUNmtE3o7EtLgE7GRE8jS8K4gk/fjaMmo
	9XX2Bd8BDNDz/ertn/vVsFbWNzGSQXwNXuI07USj4a/liV9jm+7DbI0LuSkNqWILd8ACTcuObDP
	eraoSUwamq24pQhii7uAHa1wHbeR1GYTkcslnaxZwzsFZognaRBNHmpH0bIA9eFlZfbeAU3MJ5U
	wVXhZgkENWvyQ8dWdioF+DUFt3qxV+EzBUxyPgOp7e7se3QA5pnTtvh7WvOSG8HvcHdVway0E8u
	t3C7teKAwpytcMXmUA==
X-Received: by 2002:ac8:5a09:0:b0:52f:acf2:110c with SMTP id d75a77b69052e-5310cf1b729mr102021661cf.3.1789463750713;
        Tue, 15 Sep 2026 02:15:50 -0700 (PDT)
Received: from dcf96c429d24.ec2.internal (ec2-52-87-229-18.compute-1.amazonaws.com. [52.87.229.18])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d35a9sm116773406d6.41.2026.09.15.02.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:15:50 -0700 (PDT)
From: Dmitriy Polomoshnov <dmitriy.polomoshnov@ggcircuit.com>
To: stable@vger.kernel.org
Cc: mlombard@redhat.com,
	martin.petersen@oracle.com,
	loberman@redhat.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	jonatan.rueda@ggcircuit.com,
	jacob.pitcher@ggcircuit.com
Subject: [PATCH 6.1.y] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Tue, 15 Sep 2026 09:14:56 +0000
Message-Id: <20260915091456.8-1-dmitriy.polomoshnov@ggcircuit.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d5869dae5080e976d4b03cc33eb7ceb527f242bf upstream.

When a LUN_RESET aborts a WRITE command that is in the
TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
waits for the frontend to finish processing.

If the initiator subsequently sends the remaining dataout PDUs,
__iscsit_check_dataout_hdr() catches the payload, stops the dataout
timer if the sequence is final and finally dumps the data. However, the
iSCSI target doesn't trigger the completion process for these aborted
commands. Because of this, the abort path hangs indefinitely in
target_put_cmd_and_wait(), leading to a deadlocked target worker thread.

Fix this by explicitly calling target_complete_cmd() when the final
dataout PDU is received for an aborted WRITE command.
target_complete_cmd() detects the CMD_T_ABORTED flag and cleanly routes
the command into target_abort_work, allowing the abort completion to
successfully unblock.

[ dpolomoshnov: 6.1 does not reach the target_complete_cmd() declaration
  through the headers iscsi_target.c already includes, so a straight
  cherry-pick fails to build with "implicit declaration of function
  'target_complete_cmd'". Added the target_core_backend.h include.
  No other change from upstream. ]

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Dmitriy Polomoshnov <dmitriy.polomoshnov@ggcircuit.com>
---
Reproduced on Debian bookworm, kernel 6.1.187-1 (6.1.0-53-amd64), with a
16 MB fileio backstore and a scripted initiator:

  Login -> WRITE_10 8 KB (InitialR2T=Yes, ImmediateData=No,
  MaxOutstandingR2T=1) -> receive R2T -> TMF LOGICAL UNIT RESET ->
  DataOut with F=1

Three tasks are then left in uninterruptible sleep and never recover:

  kworker    target_tmr_work -> core_tmr_lun_reset -> target_put_cmd_and_wait
  iscsi_ttx  iscsit_close_connection -> iscsit_free_cmd ->
             transport_generic_free_cmd -> __transport_wait_for_tasks
  iscsi_np   iscsi_target_do_login -> iscsi_check_for_session_reinstatement ->
             iscsit_stop_session -> iscsit_cause_connection_reinstatement

Only a reboot clears it; hung_task fires at 120 s.

  stock 6.1.187-1 module                    5 of 5 runs hang
  self-built unpatched, same srcversion     3 of 3 runs hang
  self-built patched                        0 of 6 runs hang

The unpatched rebuild has the same srcversion as Debian's shipped module,
so only this patch differs between the last two rows.

5.10.223-1 behaves the same, 5 of 5. 6.12.94-1 did not hold the hang in 13
runs even though the completion call is missing there too, so something in
6.12 appears to release the command by another path. I have not identified
it.

Hit in production on iSCSI diskless-boot servers, where it takes the machine
out until rebooted.

Please also consider the commit for the other longterm trees. 6.6.y and
6.12.y already include target_core_backend.h, so the unmodified upstream
commit applies there. 5.10.y and 5.15.y do not include it, so they need
the same added include as this patch; I have only built 6.1.y and 6.12.y,
so treat the other three as untested.

 drivers/target/iscsi/iscsi_target.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -25,6 +25,7 @@
 #include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
+#include <target/target_core_backend.h>
 
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
@@ -1568,8 +1569,10 @@
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
+			    --cmd->outstanding_r2ts < 1) {
 				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+			}
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
