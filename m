Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8843B492
	for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419494; cv=none; b=T9Jwib3WSlYd27nJvUOw7EdwilJDa/ofX8iWnVEmFHHRRU6AZVVCz2AXC2zifVNDlrtY6coH3YFHwCxATEThvN5IcJ/n3fUnxGc8FlPOarL35Cqba/2ZO6Mg3CG+zISCzeN9rKYMoZu8lQ/irqsRvgsTvxFQrYb2S5E5kk3GYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419494; c=relaxed/simple;
	bh=QB9e6QYTLT37A6LTuNS/sb4KauOL1X5ahdqXD9i1vTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1aTJB+mHq5qpdMaLhrW00ZNu+HcyFwQw3BdXTTxya/6e+dYjL4v/WV2x/pdI6AdFavjezz0E+irtQMq1dVrwdW4vMotZMDsVvTw/h8XMHvbXf5SV68KOZicyAIXWKgm6UcipqZOjzFiPKHsQFy+vRlfifguGdU1xcfs1aNUz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=uo3T4GVU; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="uo3T4GVU"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc891373e0so24664955ad.2
        for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785419490; x=1786024290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G5jWHAkfCEMcKnx0C640iI/dheyfGkHjWmoTceE6bKc=;
        b=uo3T4GVU3p45165NdrOvHzCdF1ZY7+OQ1B8ajEsQEvHQg+pKxWgSndCRmvj1U6T9y9
         6Ye3R9CnX56eIx82gGd19EgzZEPMn6FSxxPjGktfke6XYpP7yagONplx1MoY/71ydbFT
         3UpW70J+nmvv5/T1rS87QNWgc/dKwqebH6tdRKzrE/aEZce1QG2jCdTmMiu/D8LC1DCp
         gEabf5dGdZ2C0Riw2JBV5Saqi20qOm3yauW/dQ8kHa39Xq5j4WM4sJAPfLs45gKNTL4j
         bSWH9/OYvLwYOvqzkTPpifysFW1ntAqvwrjw0lUikQfC0SU96t7FyTILYzjMIeo1k9YY
         n1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419490; x=1786024290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G5jWHAkfCEMcKnx0C640iI/dheyfGkHjWmoTceE6bKc=;
        b=hnyyw8o7UWoJE/WX7V/zR3MJRunpb/48Qz9UargZw9cmXSW7HmjNnzapIOS/QT7x4b
         SvHxOaEWkls6WCQaS2e0Pas3rupkoyjr2CXHAXJJLZuIswJk+5DqX6SSWMWsp+ty1B7d
         Pf8dADLUXzLuTT/63nhlx73xl3beP32vSzkptDTMD3J5/f+tjJt2y/nKb9LSjd53/UTJ
         7fwJ+lr4+zMW27uOr0GfPaKomVNeme7BFkMVLSwQkgBDESQrcOhRrsbNv7NezidLa4ys
         Wb4Wg4sy0ikVhiIie6aC2fI4DfC76139ExokUd3Sfd80PyK0wz+cdNElgD0KsywSSf4m
         8FTg==
X-Forwarded-Encrypted: i=1; AHgh+RoUnpExKbW6sj9+Q0SrP/36TMY2rgGX0jNdhD2L/ky+NZir4bLbKjQrWlRX95yA0b4X2pTxW+QQzrKqtMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0BIYKI1EDjjbuzHAWoA5mq5YMv6jLkH3N7WGAbIFDRt3JmrLx
	gwAVh704SgVf+UFmGD6SzYknfFOiQPpijmkn9RmptQqpMBgE09+lobQQeVysqrVSiYI=
X-Gm-Gg: AR+sD123bHtINQgssp8RVsUqMG82jOQFePHufO6pyMTzCYtI+RZkS08mj2V562pMK4+
	XNtcooGRoARxRLxV6DsiS34i/bK8ODP54PF01ECfUJ1F2sqovE9bEoSQ8l8juFrLltK+0/Sq9ZW
	2aT+/yyOWCoAVf2G/2tYLA5fBVngeisrsbHoKFpuK8opU1BM8SxaZiarnZWqVmaWAOS4skZA9tt
	1rYDr0ZxE77Uf2uMaJI1/CXxF3yTNC3FTnpEu4yuSoMM/OeAYQ2BDaEDiOhRGCtbucEH3/qTlHA
	RRweIeE9e7h77ZV5CSbIngPCUYH/tE+ExdZz+vXbEQHMj+Rrs5OTShPeCoSV4v3iusCe68/T9+w
	DOZszSemmH5m9XLFlYd//IyiSkS7RssnL3Yc+JnSfGk4LYy4UqhSixW9jT+BfsfYNkM2pkGwWUi
	CxiVmbCZHcAA3GjmhEOFEHMLMUQTz71l8fOM2ETzfXSJDs0PyPA6n+cstKyDED8fuOAFKP1lxq2
	iSjbVbv
X-Received: by 2002:a17:903:1b6e:b0:2cf:b330:e0e8 with SMTP id d9443c01a7336-2d035c1c815mr26373215ad.10.1785419489805;
        Thu, 30 Jul 2026 06:51:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c3721esm27804345ad.77.2026.07.30.06.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:51:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] IB/isert: reject full-feature PDUs that arrive before registration
Date: Thu, 30 Jul 2026 22:51:10 +0900
Message-ID: <20260730135110.1647384-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730135110.1647384-1-yhlee@isslab.korea.ac.kr>
References: <20260730135110.1647384-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The full-feature receive buffers are posted from isert_put_login_tx(),
which runs before __transport_register_session().  An initiator that does
not wait for the final Login Response can therefore still have a SCSI
command executed against an se_session whose se_tpg is NULL, with the same
oops as the previous patch.

Move the ISER_CONN_FULL_FEATURE transition into isert_get_rx_pdu(), where
it happens after the session has been registered, and reinstate the
connection on any PDU that arrives before it, the same call this function
already makes when a work completion fails.  The state is read without
isert_conn->mutex because isert_recv_done() runs on ib-comp-wq; the acquire
load pairs with the release store so that the session registration
preceding it is visible.

Measured over rxe with an initiator that fires SCSI commands into that
window without waiting for the Login Response, 400 login cycles per run:
the oops appeared in 7 of 10 runs with only the previous patch applied and
in 0 of 10 runs with this one on top.  The check fired 22 times across
those 10 runs, 16 in ISER_CONN_BOUND and 6 in ISER_CONN_TERMINATING, where
the reinstatement is a no-op because teardown has already latched.
Well-formed traffic is unaffected: 20 runs of a spec-conforming initiator,
400 login cycles each, pass with the check never firing.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v3: unmap login_tx_desc in isert_connect_release() (1/2); make the
    FULL_FEATURE store a release and the state check an acquire load, and
    log the value actually tested (2/2).  Both from Sashiko's review of v2.
    v2: https://lore.kernel.org/all/20260730063124.1554460-1-yhlee@isslab.korea.ac.kr/

Depends on 1/2 and must not be backported without it.

 drivers/infiniband/ulp/isert/ib_isert.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e117cd2e62c9..40290ab4bdb5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -956,11 +956,6 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
 			if (ret)
 				return ret;
 
-			/* Now we are in FULL_FEATURE phase */
-			mutex_lock(&isert_conn->mutex);
-			isert_conn->state = ISER_CONN_FULL_FEATURE;
-			mutex_unlock(&isert_conn->mutex);
-
 			/* Sent from isert_get_rx_pdu() after registration. */
 			isert_conn->login_rsp_pending = true;
 			return 0;
@@ -1327,6 +1322,7 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct iser_ctrl *iser_ctrl = isert_get_iser_hdr(rx_desc);
 	uint64_t read_va = 0, write_va = 0;
 	uint32_t read_stag = 0, write_stag = 0;
+	enum iser_conn_state state;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc, "recv");
@@ -1335,6 +1331,15 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
+	/* A full-feature PDU before registration is a protocol violation. */
+	state = smp_load_acquire(&isert_conn->state);
+	if (unlikely(state != ISER_CONN_FULL_FEATURE)) {
+		isert_err("PDU received in state %d, resetting connection\n",
+			  state);
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		return;
+	}
+
 	rx_desc->in_use = true;
 
 	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
@@ -2598,6 +2603,12 @@ static void isert_get_rx_pdu(struct iscsit_conn *conn)
 	/* The session is registered by now; see isert_put_login_tx(). */
 	if (isert_conn->login_rsp_pending) {
 		isert_conn->login_rsp_pending = false;
+
+		mutex_lock(&isert_conn->mutex);
+		/* Pairs with the acquire in isert_recv_done(). */
+		smp_store_release(&isert_conn->state, ISER_CONN_FULL_FEATURE);
+		mutex_unlock(&isert_conn->mutex);
+
 		if (isert_login_post_send(isert_conn,
 					  &isert_conn->login_tx_desc))
 			return;
-- 
2.43.0

