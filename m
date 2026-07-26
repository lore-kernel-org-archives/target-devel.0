Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A938A701
	for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785076952; cv=none; b=nCrd1ezWRKnq6fhzRRw05iWCJ4T9C5binXYOW9zek7XA2wSkEns2HCEQSe89AZchU5tqwGa6rQ40V0Xo6FluCGY0z+2JcIIPo1fJyLdByADpZfOlD4dAumTSsiJ2dL6ehjC4opUkzlDaCTfyXtVTEivvKU5Ob3+wD4WI3pJvw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785076952; c=relaxed/simple;
	bh=f/paM7suSS+f6oqLin8Ijxovb9ymBdcOgA9NDthSdM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XPH13GQIYxod8vS+U7/EfZ9EwCKsVLeU+csFXkhFP3wtiI0HsZ5nhJwgmQ8eAi/5feUqJjrajK02u3Jy+NMClUV/jIM8GsvzxF56A622MdP2/3Cu6BxouX5qcEdO4G0VUtg5WHZ+YtsI4LX7fU4Kwh3tHed1++UQAXvsQ6TxmJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dRcQtRVB; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dRcQtRVB"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so20143105ad.1
        for <target-devel@vger.kernel.org>; Sun, 26 Jul 2026 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785076947; x=1785681747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVIM60jDgtsURD9RrVDGNNVCDHm1+dh+aaxp3nCQ6c0=;
        b=dRcQtRVB/yLECSGriWfHgnL7w8staoB70p0idxNkxy5VLb5z4b27wG9rEk5jgdwizg
         lZDUXMHIZjRXAZiBQ98eX8TG6hXpQy3WzXWntTLn0umQ4W/VCBrB9Uu9C4qRDg6c0yrn
         cpXfv4b9LL5EOIB/xHipNq6JYio76UcuPvren8xCAFUmXGONSYYOE1Vh9Q2LX+sGPqDu
         CG0HF5ci58KeE/hYbBqYxcBHPZYu1TEPsbaJhL9b+dxT/VpXGTInbKyMRNA6Tc5+VDPp
         foumoQN1KdEpvYZF9AIWr+8LFYYDFKjPE+/NkTM1qAz36RlbuxQs2H8yhd1DlRDYNV86
         6z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785076947; x=1785681747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVIM60jDgtsURD9RrVDGNNVCDHm1+dh+aaxp3nCQ6c0=;
        b=b9Y5gTKeK6aRkkRV4uOqI9eMKkogHK/PBFJyvdy3of7kUMQwpe3XJtuLhX5vAMI/I2
         VM9ozrEBXPEr3ZvYpH6kgS6GPt4+6hKoFrcKLpsehfDxEp1aUJqWVq1YCx8D2+Ptyo31
         +5WOBUP7MaYWGSoI6/YYLpGwve+obFspGq044uKUjdrqSjkhqT9gsHPXJtjxTcPUrAtr
         GAJD09mI2J5cqnbUTOSu9wnf5GML6kLwfYMsUvlNeKzSW4coEvzjzs89/bb3V8/r3uvq
         9HLYnm4AZdZjMrJr2PL/3Cd7j4CsyewzBO7x5hgmBdYnsaa9PvzyHqHJ7TC+Nb+n+KiT
         LLgw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3qOhGNP5RmmTJIsQcpMsP4fF3M++L6dYzNi40UAMsdyrcW8IJ+JqQmlWolvxfddOR8dhD1HgGY2N1Aaw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjwBiJYOpftXTQ8B2K4Qo8AwbmFVtttN39kfSKd6fWysHJLtIJ
	m/GYBNNo5lcoEQrqz99uIxfiEFh/RDgDlMMMzUqA8D/1ueGNb4j7s5VQ9bWHsO674lg=
X-Gm-Gg: AR+sD12OY1hGfv2g2MB8Cc6Ni1+3t+ItXyLITZwdrR1xU51lPqoqGivZAyshr6kMY8e
	yFQ6iOV1AKqGIh6xdVGaENLNDppsD0sFqU2a4zQxmqti6YsN2/eeb42tX/612zo8ClNHS2FjCMK
	jsKqungNc/HbACDJhro4KWUbONNz3C3X5tlGj56LF1/VCKsT2sW6wKoXLWjKg45mwAoPIiWnbKK
	r4mdmvVhe1fWC5BuGDLcOpGW3voGYIx7eTzt3ia26QbMrrEMTAtnTk02/TYcqNLe+erk/6DBLqn
	8/IhY6FEwDQJbepvW2clnPxCEfkqaX7860K4RIyMz3+reF7FXbioztsIAGaaF1+oCC1eBrcf9tT
	pvgNNZuEsjRhzOeRNaKQhpPNFRpO6vsRV54YnMRNQXQUw6YDsMGusToN5fqmHdygyyk6pY/7O/N
	8AMmp5mvQBiqiS/cNQUCezhdaG
X-Received: by 2002:a17:903:46cc:b0:2c6:9f66:d573 with SMTP id d9443c01a7336-2cfde67beebmr50345595ad.2.1785076947402;
        Sun, 26 Jul 2026 07:42:27 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7f8e73sm20624625ad.72.2026.07.26.07.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 07:42:27 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: nab@linux-iscsi.org,
	michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] IB/isert: post full-feature receive buffers after session registration
Date: Sun, 26 Jul 2026 23:42:13 +0900
Message-ID: <20260726144213.933544-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_put_login_tx() posts the full-feature receive buffers and then
sends the final Login Response on the same call:

	isert_alloc_rx_descriptors()
	isert_post_recvm(isert_conn, ISERT_QP_MAX_RECV_DTOS)
	isert_conn->state = ISER_CONN_FULL_FEATURE
	isert_login_post_send()

iscsi_post_login_handler() only runs after that, and it is what calls
__transport_register_session(), which sets se_sess->se_tpg.  An
initiator that sends a SCSI command as soon as it sees the Login
Response can therefore have that command received, executed and
completed before the session is registered, and target_complete()
dereferences a NULL se_sess->se_tpg:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
  Workqueue: ib-comp-wq ib_cq_poll_work
  RIP: 0010:target_complete_cmd_with_sense.part.0+0x17d/0xc90
  Call Trace:
   fd_execute_rw
   __target_execute_cmd
   iscsit_execute_cmd
   iscsit_sequence_cmd
   isert_recv_done
   __ib_process_cq
   ib_cq_poll_work

The command reaches the backend because transport_lookup_cmd_lun() does
not need se_tpg on the mapped-LUN path; it uses se_sess->se_node_acl,
which iscsit sets much earlier in iscsi_target_locate_portal().

iscsit's own RX thread does not have this problem: it is started at the
same point but waits on conn->rx_login_comp, which is completed at the
end of iscsi_post_login_handler(), after __transport_register_session().
isert takes its PDUs from the completion queue instead, and
isert_recv_done() has no connection-state check.

Post the receive buffers from isert_get_rx_pdu() instead.  That callback
is invoked by iscsi_target_rx_thread() only after the same rx_login_comp
wait, so the buffers become available to the HCA only once the session
is registered.  isert_recv_done() runs on ib-comp-wq and cannot wait
there itself.  The allocation stays in isert_put_login_tx() so that a
memory allocation failure still cannot happen after the final Login
Response has been sent.

rx_descs can legitimately be NULL in isert_get_rx_pdu(): the login
timeout timer sets login->login_failed from timer context, so
isert_put_login_tx() can skip the allocation branch while
iscsi_target_do_login() still returns 1 and the connection reaches
TARG_CONN_STATE_LOGGED_IN.  Return early in that case, which matches the
existing behaviour of not posting at all on that path.

Reproduced with soft-RoCE (rdma_rxe) under KASAN using an initiator that
issues a WRITE immediately after login, 400 login cycles per run.
Unpatched: 9 of 10 runs oopsed.  Patched: 0 of 10.  A build carrying a
diagnostic that reports the NULL without faulting recorded 16 hits
across 9 of 15 runs unpatched and 0 across 15 runs patched; the two sets
were run alternately in a single session.

Not covered by that testing: discovery sessions over iSER, MC/S
(non-zero TSIH) logins, ERL=2 connection recovery, and real HCAs, where
RNR behaviour differs from soft-RoCE.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
This replaces "scsi: target: Fix NULL se_tpg dereference in
target_complete()" (target-devel, Message-ID
20260725165818.769963-1-yhlee@isslab.korea.ac.kr), which guarded the
symptom in target core.  That patch is being withdrawn.

 drivers/infiniband/ulp/isert/ib_isert.c | 36 +++++++++++++++++++++----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750a..b055513a7bd8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -943,15 +943,18 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
+			/*
+			 * Allocate here, but do not post yet: the receive
+			 * buffers are posted from isert_get_rx_pdu() once the
+			 * session has been registered.  Allocating early keeps
+			 * the original property that a memory allocation
+			 * failure cannot happen after the final Login Response
+			 * has been sent.
+			 */
 			ret = isert_alloc_rx_descriptors(isert_conn);
 			if (ret)
 				return ret;
 
-			ret = isert_post_recvm(isert_conn,
-					       ISERT_QP_MAX_RECV_DTOS);
-			if (ret)
-				return ret;
-
 			/* Now we are in FULL_FEATURE phase */
 			mutex_lock(&isert_conn->mutex);
 			isert_conn->state = ISER_CONN_FULL_FEATURE;
@@ -2585,8 +2588,31 @@ static void isert_free_conn(struct iscsit_conn *conn)
 
 static void isert_get_rx_pdu(struct iscsit_conn *conn)
 {
+	struct isert_conn *isert_conn = conn->context;
 	struct completion comp;
 
+	/*
+	 * Post the full-feature receive buffers here rather than from
+	 * isert_put_login_tx().  iscsi_target_rx_thread() only calls us after
+	 * waiting on conn->rx_login_comp, which iscsi_post_login_handler()
+	 * completes after __transport_register_session().  Posting them in
+	 * isert_put_login_tx() - before the final Login Response goes on the
+	 * wire - lets the initiator's first command be received and executed
+	 * against an se_session whose se_tpg is still NULL.
+	 *
+	 * On failure just return: iscsi_target_rx_thread() sets
+	 * transport_failed and tears the connection down.
+	 *
+	 * rx_descs can be NULL here: the login error path completes
+	 * rx_login_comp without ever reaching the login_complete branch that
+	 * allocates them.
+	 */
+	if (!isert_conn->rx_descs)
+		return;
+
+	if (isert_post_recvm(isert_conn, ISERT_QP_MAX_RECV_DTOS))
+		return;
+
 	init_completion(&comp);
 
 	wait_for_completion_interruptible(&comp);
-- 
2.43.0

