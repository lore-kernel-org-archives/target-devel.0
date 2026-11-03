Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710822;
	b=L8YWt+xgZl9hVOpQn8QAG8ONZk95x3LbcrGL8Odau5rjYkRiD2IVtyyMPnNok3HVb53B
	 tLLMIl0SeKZTGVdhm+ATmS902GsEb4LMOeEioGaBsL9vC+d9h1kjYawhbW3S7ZAN7wTma
	 5O3wgePSiiGDk+dlkVQAEc4mh4ogtRJj3heGROjtKoF+Gu2x+cfaKjrDu2+/wuF677RFo
	 5VoN51djtTGu6RkIyczWXvH8e6LdJn5vI0V1595/H3cInX9pKc3EWODAKfpLU/N6Sdedk
	 tPyIusGgxftnfFJmXy6J2GUZtjtWw7nf+hGvRSHi17z7TRHsmq3ZHMa6gpLiHrUxccQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710822;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BbsthUcH6RMTf08/pwvouxwtu/eP2PPkhDBbmB5Ln7s=;
	b=H68pqJmkYtB17nktsB5FG2GaWj6xGgihMTu3/RmGNphxBkJT+4WWGMrt/eMe7MSvwFPJ
	 o34M/stXqHrtzWW9X6hhzQWH95VqgeKb35ag6i2K7jBAtCLaOzyVs1j4u30NidoavZtkO
	 1ulRB5MkNI/rgzytMANEoaMBW1Je4ojyLKdsjlAiUOgYGGw1bUcwlaHksFvMbVoFiRlKY
	 soz2rxKzpwXffjXeriGnoSRyP6q8tkx596t49mD6bm5/wf9riLbTQ+R++2N5ST6KzCZkw
	 p5TLiub3XeWBztrbR2OhAj1zYcjlfAI008o8974uq017+kOJ/oFEd6NH5S5hGr1e4pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oAjH1ZKn;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65505606A327
	for <target-devel@vger.kernel.org>; Tue,  3 Nov 2026 13:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65505606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oAjH1ZKn
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36a315ed211so776746eec.0
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 05:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793710820; x=1794315620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BbsthUcH6RMTf08/pwvouxwtu/eP2PPkhDBbmB5Ln7s=;
        b=oAjH1ZKn6wTySY2nbMWWWqQPMptHJelubTqNlspvs8725hkLJV3O8Cj0wo3A9M1u3Y
         /pAcm9c820eFfGOFsdFEvm4a67mTdH4tTeq17q5lUEvB0ExMldRJKgcxy6bzi8+MHq15
         qXkpsFZXbSXGE0JIk+996NFig/CuS+aXCcnx9tPtvEncsMl4CJ93jdGrO1Ldrbb+akup
         VN626w7rVpm9vtJotTqFB1/QOQed8bnSk4c2UhNlHj/Cbp9Mv8UGEVgFIJ+fg4o/9kjb
         GCfbWyFHRGm9LXxSXsM9w6pWBzb2TNUOQQPFcCaiHAvU6M9NLvVYVCuJC56vvzh97Tk+
         GhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793710820; x=1794315620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BbsthUcH6RMTf08/pwvouxwtu/eP2PPkhDBbmB5Ln7s=;
        b=cnxoKjB8SD7aBLZDAFeageoOYrq8Upbi8KwqSSGPv1PrqQxqjZeHTlpfBxpuFvx9el
         CJxAL4YxdX0DpPZQsOf4bmD3a3p0aDdzkox60rmwYW1bRh3nTBUv/QmXwSPSV/TSv9gV
         YLPg+Kyv2OrvoVnlixxJ431H1gwV5ASBM4fQNqQqjs3cPc3R+WuIfhlkK6ZroxoAe25/
         6rBnMZmnVmN0IpLe+WPzmJ/lOf0skQNZ7vzwbS3m1OZTj3UkaY4a/k2hjDchS4ZDCi96
         +PkLVPsX18e+MVhU6ns0aJpUCEr40rsSMAF91hsVOK5xs8d2jGMkuDxg+BM7f7peFarH
         KTNg==
X-Forwarded-Encrypted: i=1; AKwUvByS6Z2N/qXQhWwXHGdllqA1vApjiiE+gPdf5xdsfYF1Q/SGSYcEuHHo9MVrQWWTtERw1IoZoAodwfeOIXs=@vger.kernel.org
X-Gm-Message-State: APuU4Z8FqSlbdQQsJy8UrTKrk8zI1bGPxjPwYiG2SVjn+5cwZuTNRM5n
	oUZn+CA6AhjA9qT6X4UE7mVRt+YRO+hjGBK5D9DG/H58ug6g1vY3zeG0Wh/Xl7Bs6uE=
X-Gm-Gg: AYBFou0VvLymoBeQMgNR7jV2et5vZdhoXPgUMbd+Ju7GiaJfFmzvDmMccj2251CW4rw
	0A/fs/lV9Rclj6OdqAQwLDrY3xi9lTeZRxenKiBXT2QqGZEL0fNmX8hkww6CU9+/qk9VFFgGrBj
	ZGkUS1wRMgw/5h1XpRzyUXLSKNgTemIOzFAmWr7D6G1b5v+ECg7TGjtmqKPL75ENo57tEDTlFDu
	TyAIOMWdrKcb+mv5CL4e+bBEAaggTQoRzMevY5sBcNUviIqKplsFFdv88T5Uxb6ugA3Xwz+HHsh
	3WtQdcldnUqcw5M2RqcPdVaQjiQUYvbg0JGbvsvfncFgBnChK4ttLpQASFwSsFKt9OR/DAYH8/b
	tHsdMKinpD0G4Fy05Ry+V12GN38ggauYBDP/vyMI0O12uF8HoE8NKAuE32i7vtKyTOc/gjzY6Tg
	tQ6uEqmgSsVffwA7ua1XfzmaoiDGQveIb9J/gG32e9w5WfxoUa8506ymRYQoZAn5pXFuZw2H9H+
	xLnpaX5yp8K9wk4yODH0h4H3yqzrFc30YLv7tPEgdHw8vMIHSSTl/wr6bto1z+S5mTnVNyROp50
	7Mewo8gXnt45sAN/RFTYDrlpkXhFq0u5jkR/nfIN21He1u49b4RAWGTL57VuiLQxmnVpzY6EEeS
	hI/CwOlWe3sey2QHSkvWMBOTfIFH1Qmh93jMc9g==
X-Received: by 2002:a05:693c:4088:b0:36a:2f6c:490e with SMTP id 5a478bee46e88-36a30009ecemr25851381eec.6.1793710819910;
        Tue, 03 Nov 2026 05:00:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm50806107eec.3.2026.11.03.05.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:00:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v5 0/5] IB/isert: fix the device removal use-after-free
Date: Tue,  3 Nov 2026 21:59:50 +0900
Message-ID: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RDMA_CM_EVENT_DEVICE_REMOVAL callback in ib_isert waits for the
connection it was handed to reach ISER_CONN_DOWN and then frees it, a
use-after-free against isert_connect_release(), and the wait deadlocks
against the handler_mutex rdma_destroy_id() needs.  3/5 moves the teardown
into an ib_client callback, as nvmet-rdma did in f1d4ef7d8883, and gives
every connection one owner.  1/5 and 2/5 are older problems; 4/5 and 5/5
close two holes the walk makes visible.

v4 -> v5

v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr

The critical point on 1/3 was the skipped drain.  v4 checked ownership
first and returned without draining, so a posted login receive could
complete after kfree().  1/5 drains before it takes the connection, the
order mainline already uses.  I did not reproduce the failure: with
isert_free_np() parked inside its take window and a reject arriving on the
connection it held, two runs of v4 and two of v5 both reported nothing.

The high point on 2/3 was isert_accept_np() taking the connection while the
drain ran outside isert_conn->mutex.  2/5 empties isert_conn->node under
isert_np->mutex before it terminates, so only that owner drains; if
accept_np got there first the node is already empty, and the handler
rereads the state under the same lock and hands the connection to iscsi.
That is the same race as the teardown against accept_np below, and I did
not reproduce it either.  The low point, the kdoc, is a Return: line on
isert_conn_terminate() now.

The critical point on 3/3 was ib_destroy_qp() after accept, and iWARP.  v5
has no post-accept error path left to destroy a QP on.  iWARP I could not
measure: a siw portal cannot listen here, because enabling iser adds a
child np at the parent portal's address and siw binds a TCP socket to it.

A high point on 3/3 was the walk against isert_connect_error(), with the
leaked promotion reference.  isert_conn->cm_id was written with no lock, so
the walk could call rdma_disconnect(NULL), and a promoted connection that
errored out leaked a reference.  The owner clears cm_id under
isert_conn->mutex now and 4/5 drops that reference.  A REJ after the RTU is
the cell for both; the INIT-only half I could not open alone, because the
device whose removal opens it must carry the reject.

A high point on 3/3 was the teardown against isert_accept_np().  isert_np
is reference counted now and the teardown runs on a reference taken under
isert_conn_mutex.  Nothing faulted in over forty window entries a run, so
that one is not reproduced.

The last high point on 3/3 was the late isert_device.  5/5 refuses
isert_device_get() for a device being removed and keeps a marker until
isert_exit(), measured with a CONNECT_REQUEST parked before the lookup.

Measured on soft-RoCE, three runs a side unless noted.  The nine cells v4
already passed report no KASAN, no lockdep splat and no refcount warning on
either side, login and I/O eighteen runs a side.  A REJ delivered to eight
promoted connections faulted the v4 removal walk every run and returned no
isert_device reference, where v5 finished it in fifteen seconds.  Over nine
runs a side the late-device window opened four times on v4, each of those
building one and taking ten or eleven core warnings, and twice on v5, which
built none.  1/5 alone took twenty-two use-after-frees to none, 2/5 alone
ten hung tasks to none, and PROVE_LOCKING gave no splat in twenty single
runs.

Yehyeong Lee (5):
  IB/isert: do not publish connections being released on a second list
  IB/isert: drain the QP without holding isert_conn->mutex
  IB/isert: tear connections down from an ib_client on device removal
  IB/isert: drop the promotion reference when a connection errors out
  IB/isert: do not build a new isert_device for a device being removed

 drivers/infiniband/ulp/isert/ib_isert.c | 420 ++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 319 insertions(+), 110 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

