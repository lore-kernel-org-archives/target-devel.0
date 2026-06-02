Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C0123ED6A
	for <target-devel@vger.kernel.org>; Tue,  2 Jun 2026 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780429609; cv=none; b=MCQ95LW90xwjf6GUExrqFR058IrUvw5D7isi99a5FlnUM8DgS4GzMC453S7RF8xm7CzbGw73JQkGv0tGSDKQNoUnwdAHN0qIPqP9OMhQIq4TiYqgXoUn16vTsPspJq3IV7OISQNEFUDf7A1//7UKjRPjj4eYl8BeJE2qRuy+ntY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780429609; c=relaxed/simple;
	bh=D6UZDnyjlzb1tjCGRTyvdU0cKpyDRuOWJ7z+8lBC1rs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E9c3B9XDWPHqmYb3FkEZm3JlHkUPWxPYa8FbQEpn0j8UzOaPBQis79lpxsswBBGG+07dZWgfA7Qt5p8Y4pgddnOy2wjq8nZJIfI3xBTJShpaJ2Noxqab9+vudehWqKzw21xsSUKdn2NUGgBGh5sVY2xfrzb2XrBMwXQ07a8vLUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cl90eKqR; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cl90eKqR"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-516de78c4dcso109644661cf.2
        for <target-devel@vger.kernel.org>; Tue, 02 Jun 2026 12:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780429608; x=1781034408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HZT0cZ8sVMgpqU3LQqdB6NvntMdy3q7IleXIHtXo8Wk=;
        b=Cl90eKqRJ2hhwSo6IFVI9UE3drHZjG5skEklbrMBSCsFqdjsHX6OSvdZWBST7ck2DQ
         srSkFJi/POfKBIyYXjWm6QwvxN0F+VZTOn4m3EVH9WMyEOJioIunXpSMDadqf0503Ecm
         Qp1zlFyy9fLY3mnZlq3XTojUZVmEmd1KE4DxKfWrouDaj6v2Mz4cXYkuwKww6VOqIZJ/
         905djg9WeD7GbvrQ8zO4i4/vEED1d24Fd/3IV40kp7mr9T3W9m1ZT4Ki+tenYT/QscOO
         Uwf9gOsSbfJkIxWsLV42WsG6rzw/nnRD7T7VvzLHbiHjS9dS5TcmoWmWDzDMVN8Mydry
         n30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780429608; x=1781034408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZT0cZ8sVMgpqU3LQqdB6NvntMdy3q7IleXIHtXo8Wk=;
        b=LcXDTnXHaew8R58SUJKdvtclrXbTscGNS1Z1jJjiKMHbonnh+1lkhk2DbEzd0RIE9w
         O4WKp5TFR0m255D90dgrYwX/cah44q/1zY0UBDmxJjEs+8B9Z/54WL0oS9T1vkgvQWV4
         1aapgtzGvKEI/T9uNuIL57Bn5rkD6t4p4LueBjuEtLADKnJZQbJ8SMJ7/EcHzHax1rhq
         bYToQvaD+h7wPxqwZ4Gdvs7bt9PR4gUpPMLi/Hu6jTcZQRvDYMej+ou31++u/KzBZiPc
         9oBgjSEPOHcS4tVRE4iO9G3SU/FuPDWZrJcBZlDYbxJ4EFXawSxIN8WnHvsEiQ2IC6Fq
         gj7w==
X-Forwarded-Encrypted: i=1; AFNElJ+TAAiY1Q2fatVXvUgMcVF/psninoTAaAOTIrFF8keRAiDikzAbmohsv1Mrzn1+xK3oe2RrXkGjTlxA0Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+FKyf9tgcnzHVJTuzpH2RpDL+s5HXj80gy0AkquqdFqcbXzQu
	jJ3obbxt5OKWWodbDqrL1bEVwVxAxkmUEiyrlxvE3nWdBpP5o4PAHXNF/h2r5dnN
X-Gm-Gg: Acq92OEfqrP2xd/bhrbih3HTh611/MmVbLIn5RsRwN1dqozI3lqXUl1qHNT6MBXpULe
	s0qw7mUNYXC54MB/PCSCeFI4zVGUOQ1aeuvbeHWN3xO7qPMzGD+J7VPOg1T3EqF4Dl9d3IP+Hi+
	xKf3E8zvKCqjZxTzQd4N6eSKqzs7N7DTRUbvelt0D/y7f9fAGGbs4/5iMiyrZ2ZrKwKRBI5OeKd
	s/eJ13wQ40bW82aoigm2QInuZFu0ZtI9kKuik7dgwzQSl06YWvqJFl1dPz1z4snk3ocJa9M6NgA
	3M2CGHDtOzp3vVwh8iAVuTUTnm8xu2kGFjUfgllquqFn941ak9JtCskpaDN3sTjv4WdbHQ7UNjZ
	1Dkae/fRMtfZzXHSS+LKs0If/cMB2DU9GSc+/7hsZtUhP9VWSiKhFirqp0XWfQmokgKsXPPPk5h
	60ZpQTzgkEBDbvZTA/EgiPl7jFP7cBhjBiUlAd6I7qGg06vm2nEmucu86s5nZRT9yDuwT1R2y+K
	Cp+8FdaIivSs7j3a8nQKT8XTpmQ+pY=
X-Received: by 2002:a05:622a:1304:b0:517:64b8:5a1f with SMTP id d75a77b69052e-517786efdc8mr7448531cf.35.1780429607484;
        Tue, 02 Jun 2026 12:46:47 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775d8100fsm7136801cf.14.2026.06.02.12.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 12:46:46 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Sagi Grimberg <sagi@grimberg.me>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] IB/isert: reject login PDUs shorter than ISER_HEADERS_LEN
Date: Tue,  2 Jun 2026 15:46:42 -0400
Message-ID: <20260602194642.2273217-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

In drivers/infiniband/ulp/isert/ib_isert.c, isert_login_recv_done()
computes the login request payload length as wc->byte_len minus
ISER_HEADERS_LEN with no lower bound, and login_req_len is a signed int.
A remote iSER initiator can post a login Send work request carrying
fewer than ISER_HEADERS_LEN (76) bytes, so the subtraction underflows
and login_req_len becomes negative.

isert_rx_login_req() then reads that negative length back into a signed
int, takes size = min(rx_buflen, MAX_KEY_VALUE_PAIRS), and because the
min() is signed it keeps the negative value; the value is then passed as
the memcpy() length and sign-extended to a multi-gigabyte size_t. The
copy into the 8192-byte login->req_buf runs far out of bounds and
faults, crashing the target node. The login phase precedes iSCSI
authentication, so no credentials are required to reach this path.

Reject any login PDU shorter than ISER_HEADERS_LEN before the
subtraction, mirroring the existing early return on a failed work
completion, so login_req_len can never go negative. The upper bound was
already safe: a posted login buffer cannot deliver more than
ISER_RX_PAYLOAD_SIZE, so the difference stays at or below
MAX_KEY_VALUE_PAIRS and the existing min() clamps it; only the missing
lower bound needs to be added.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---

Impact: a remote, pre-auth iSER initiator can crash an iSER-enabled LIO
target by sending a single login PDU shorter than ISER_HEADERS_LEN,
underflowing login_req_len to a negative value that drives an
out-of-bounds memcpy.

Analysis
========

Tree: mainline a1f173eb51db (7.1-rc4 line), x86_64.

ISER_HEADERS_LEN is sizeof(struct iser_ctrl) (28, __packed) plus
sizeof(struct iscsi_hdr) (48) = 76. login_req_len is a signed int
(ib_isert.h). For a received login Send with wc->byte_len in 1..75,
isert_login_recv_done() stores wc->byte_len - ISER_HEADERS_LEN, which
underflows to a negative int. isert_rx_login_req() reads it back as
int rx_buflen, computes size = min(rx_buflen, MAX_KEY_VALUE_PAIRS)
(MAX_KEY_VALUE_PAIRS is 8192; the min is signed so size stays
negative), and calls memcpy(login->req_buf, isert_get_data(rx_desc),
size). login->req_buf is an 8192-byte kzalloc in the iSCSI target login
path. The negative size sign-extends to a multi-gigabyte size_t at
memcpy(), so the copy runs out of bounds of req_buf and faults.

Conditions: an RDMA transport plus an iSER-enabled LIO target. iSER is
enabled per portal (targetcli enable_iser); a plain iSCSI-over-TCP
target does not load this path. RoCEv2 and iWARP transports are
routable, so the initiator need not share the target's L2 segment;
RoCEv1 and native InfiniBand require an adjacent initiator. The
malformed login Send is accepted during the login phase, before iSCSI
authentication, so no credentials are required.

The upper bound is already safe: a posted login receive buffer cannot
deliver more than ISER_RX_PAYLOAD_SIZE, so wc->byte_len - 76 stays at
or below MAX_KEY_VALUE_PAIRS and the existing min() clamps it. Only the
missing lower bound is added here. The initiator-side iSER receive path
rejects short receives; the target login path had no equivalent floor.

With the patch, a login Send shorter than ISER_HEADERS_LEN is dropped
in isert_login_recv_done() (the new early return logs "login request
length N is too short") and login_req_len is left untouched, so the
downstream min()/memcpy() length stays within the 8192-byte buffer; a
well-formed login (wc->byte_len >= 76) is unaffected. The defect is
identified by static analysis of the cited code paths; the path can be
exercised by driving a short login Send at an rxe-backed iSER LIO
target under KASAN.

 drivers/infiniband/ulp/isert/ib_isert.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 348005e71891c..a849a420be421 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1383,6 +1383,12 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_desc->dma_addr,
 			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
+	if (unlikely(wc->byte_len < ISER_HEADERS_LEN)) {
+		isert_err("login request length %u is too short\n",
+			  wc->byte_len);
+		return;
+	}
+
 	isert_conn->login_req_len = wc->byte_len - ISER_HEADERS_LEN;
 
 	if (isert_conn->conn) {
-- 
2.53.0

