Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3DC42A15A
	for <target-devel@vger.kernel.org>; Fri, 17 Jul 2026 14:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299121; cv=none; b=TjOgkzS4srVfYBiUIiGCpOYOoOddDFc4t7BzZMzgj42UWWmRhxy7XmZRuXHqKfHd/Q5UynutehiGXpgJGIH2KYdP2zOT5H3FQ92dU49TGJWQf0y8FpiHiUuHf9YxqzaOVoMSruAfrSRfToDjlLRBOasWiaSNwgvvjeSJkWKsRO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299121; c=relaxed/simple;
	bh=ur+NlhkGIebs+18Ip0zCENq6uEXM/9f91BClCYzMG4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo26/WQtOG5qpa1QY1R8IWNqiXdaCEZkA49vMOAoHl4lI7XR5HB3qtWlKQQOZHMaoaUvzRHb2+Hf+PgOSv8OOQq86yRWxuaF/J0QbrKADUmcfnw6bEPTcpr1DiaMmLVkKVD2yExtzP+RcuOb28blgWftXDs3cBO7xW6jDEi5mLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V37HIJmK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V37HIJmK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784299118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DxRLVys35Nb9V2Le18o591jZut2syXfW+kHOM1qlLI=;
	b=V37HIJmKNw5cDzTHydU1aF2u+jUX58O9OrEJxwQzZ2y2oIPXKvwwm5Cr2h4r8h6cEXWOrJ
	913ozonVCWL26WZmZDv2T7+cn2FljkHVxp8kcOITLvMVphoyWf/99WIodiKVMFYW4ofqYQ
	kfH73qPzxMUOWNTgJ9eSouM8y1XjQyY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-f_9NRWzsNg2E1p-I0Pt0LA-1; Fri,
 17 Jul 2026 10:38:34 -0400
X-MC-Unique: f_9NRWzsNg2E1p-I0Pt0LA-1
X-Mimecast-MFC-AGG-ID: f_9NRWzsNg2E1p-I0Pt0LA_1784299113
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 547BE1955F7A;
	Fri, 17 Jul 2026 14:38:33 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC234195604E;
	Fri, 17 Jul 2026 14:38:31 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@arkamax.eu,
	michael.christie@oracle.com,
	target-devel@vger.kernel.org,
	loberman@redhat.com
Subject: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Fri, 17 Jul 2026 16:38:28 +0200
Message-ID: <20260717143828.76291-2-mlombard@redhat.com>
In-Reply-To: <20260717143828.76291-1-mlombard@redhat.com>
References: <20260717143828.76291-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

When a LUN_RESET aborts a WRITE command that is in the
TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and waits
for the frontend to finish processing.

If the initiator subsequently sends the remaining dataout PDUs,
__iscsit_check_dataout_hdr() catches the payload, stops the dataout timer
if the sequence is final and finally dumps the data.
However, the iSCSI target doesn't trigger the completion process for these
aborted commands. Because of this, the abort path hangs indefinitely in
target_put_cmd_and_wait(), leading to a deadlocked target worker thread.

Fix this by explicitly calling target_complete_cmd() when the final dataout
PDU is received for an aborted WRITE command. target_complete_cmd() detects
the CMD_T_ABORTED flag and cleanly routes the command into target_abort_work,
allowing the abort completion to successfully unblock.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210..124ff269b8e7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
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
-- 
2.55.0

