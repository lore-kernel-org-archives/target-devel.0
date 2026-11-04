Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765009;
	b=gtZnC349HGpI2G1gJCrrl2b8wDnP2Cq469ufOegWVDWkQOQXGl+l5ZyoS1NPQYdH7YgL
	 nARo6DF36Ov1sZNSn8ylncIBQIKNm+q4KMo1T+sxlq0KHvJWwSnXLSrJnfhZTJ3Zk+lNM
	 s5Cjdqr+7fkkGfV9+KN9aqGFBSs5IrzPz78Kj89PjriWVWNERh1SXEvcLAXnGhCzW6xvu
	 lXpt1NyQjNbJHJr2QAyA3qLbAtFUZaJEfNlEVcDYbWpzvSZMY9d6rjVKQDGvoteFneHnr
	 Zdn+DEER024oS92z4BCo6RR4mEqlUQzQ07SYwT36qXOXU87PH0vRRu/+9t89QcfpD5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765009;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uVO0ATVYaNQI+EncMhcZY+hQpMSCbrKORYIzp0e8Fxo=;
	b=2ograiVi913UX+lxMqJtgkVjDMuOAWUCamEVon4tInvVqEx+8pQRsa0GY7E4svanpY7m
	 Ems2S3Mkru1rgX+6q6cvUPjQAx0qltClO14h08RoaABAMPgcNe+mAK/x37DfepSBpRH6B
	 NDEutG/PWI/BFBTwNiQUDyWb7HY1RtSpBBAETVYEyJHKEAO5suNqVieHbCL0Emf+H8c4F
	 GqJJGcT4ZTD/z4I3p4+IVD6Z3X5vtWhxKS+14zSuSSowDrLEQG5XlZeUxLgJeG62XtTUK
	 x4X1Y0QLHOuN1luwHD3rZfzrDPX5vkpKD5mmClx3XRomvIXSk/NDhd9doi6HnNtISfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q6pgKRIG;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1AF606A326
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 04:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F1AF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q6pgKRIG
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc758830601so192948a12.2
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 20:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765007; x=1794369807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uVO0ATVYaNQI+EncMhcZY+hQpMSCbrKORYIzp0e8Fxo=;
        b=q6pgKRIGVs23kkRuTIYr9QhOlbQDHJB60MwPmju5tiRpCPGXHb7qMn/Ea9cFxf5gbt
         9HSGBOGceQrODY7XDQ3kNaGjWJgPhxBvnCFAvNq8f08Kes0SQIHqKzfCs31ktS9kIKZM
         f+7AdKb73OiqrK3Vwnh7du8MaCV9xgts1u+E8+gFM0b5WjGZNwULU2SqvpHJw7O0d4bW
         OvPS5lUDnrg8dAKkI9rRtap775X5X39EoAxL8S+vmys/HiD9iTz0ykQZFZ8f6UxF2wb4
         HuZI7c37/JTFZow5ubQ6YRl3QRqQCzmU5SlT6n1HF7iyS01FvrkYxbYT+4HTXM2py3dr
         VwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765007; x=1794369807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uVO0ATVYaNQI+EncMhcZY+hQpMSCbrKORYIzp0e8Fxo=;
        b=a0Nqf+QHxx8rOtReCs0U4uhJSX7sRlymQKt9B8AtREiOVb+LM/rgIngP2mGpwWnaMY
         BqNiZdG/miLEqbEKgLjxgyJEFWJ3t+k2MK1cN8q5mr6Cfp0g5c+U6E759hQ6uC8pK+PU
         nxmGNSIHd3XPJkQOqcELKciXbgMAl6vtRM7jaK1vSmDo2FtWNJUgmalyrynbTPZ/hJnk
         VT3hxApND9zcskR7u14lDQaX0uiJLZYbCsEC5T1oC9MODXPrbF0Om54w5Mql3X9iVBsS
         kJYzUhnyn80whA8YQLcDrKiBtbxqL5Z6Vp0mlEB2VsiiOqIwsd3aFT0XltEIsmm6m+rQ
         Ebjw==
X-Forwarded-Encrypted: i=1; AKwUvBwSLl/frkBpQHgnMxHZCPSYnWzItN/XTEbf895/R/McvkZTnIjJM7Opy+fetkQgaD/HLn/jydUubtlZqEE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8oPV69cz7ybYSV1YHGlE9XLlxpjwgQTOdYaprUXdMycr/0fGlI
	q8J3o4Ct4HlKjjzbujtieGQ2gn3y/r1GERc2fyF6/UBGETUnbbf80GAoNtCOiK7lF9I=
X-Gm-Gg: AYBFou08/mAaOr/F+AfJGx1+AxwyABf3XhyWrhKDPzUOpRftq4YBbhnOZmVpiVNBLVo
	oJ84XUqd3gxiDmm4P2kSQfiiTH4MWwMy0w2WjcOY6BgLTLXWfaVXm4rrZ5p0K0HMz7a/AOwLsBZ
	NO9S5NuchlEN9N0ynrdsofA0RVG1ZEMPq57hd9+kjcXMAl3RpDNJOzpfkqu5NmZSiUjhax4KN/5
	ekZ07FxSouSIZydae6IWWc+2B3SS/sWctNTbDe322gPXy6DtbxawA3TDSqQTP226TWBQf/Nx4pp
	gp0iSsDLNBOaCqVux6PqwDMblKk8jmnPgpjT4+aNR6uymnYZGt2GHJsZ8butETnEpTzkjru3f0s
	I/+ZVxKDSVzdBVcxtXEfrTx9hH86Uahyte9S/+eRAe+41eS0V6J44H5azbu4LgxCL8ZhpxLODg6
	+ku8CkDARuKsE8laHD2XBSqHqeIxq9S15qSC6vW5bNcZOR6VvoCTJMvBmrxmOkfKtrbBDRfi1KS
	oTuDu5mWfwxupFVUldfM3Q8LfBVzUZW8q/zWbS+pODq14F+BMx1Ma+0HO7DFwL+DTZMSV2ZkqCI
	PxFt5oBNgCNoXpPQEpat2PBCcBNPFs3eIreFgc7ukpN7VpxnF1nqWYX/kV5NcAYTR5x33aAz+T4
	99gkNcqJf0r+AKGFo+NH6ePUFk8FR29jgQmFj
X-Received: by 2002:a17:90a:ec90:b0:3a8:10e2:ad08 with SMTP id 98e67ed59e1d1-3ae8982cdc6mr12861901a91.48.1793765006712;
        Tue, 03 Nov 2026 20:03:26 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm1817053a91.1.2026.11.03.20.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:03:26 -0800 (PST)
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
Subject: [PATCH v8 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 13:03:11 +0900
Message-ID: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
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
against the handler_mutex rdma_destroy_id() needs.  3/6 moves the teardown
into an ib_client callback, as nvmet-rdma did in f1d4ef7d8883, and gives
every connection one owner.  1/6 and 2/6 are older problems; 4/6, 5/6 and
6/6 close three holes the walk makes visible.

v7 -> v8

v7: https://lore.kernel.org/r/20261104012219.1759523-1-yhlee@isslab.korea.ac.kr

v6: https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr

v5: https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr

v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr

Sashiko v7 3/6 High: isert_connect_error() clears cm_id after
ib_drain_qp() again, as before the series.  Before the drain the QP can
still take an event, and isert_qp_event_callback() dereferences cm_id.

Sashiko v7 5/6 High: isert_device_get() matches the ib_device pointer
instead of node_guid, the same key isert_remove_one() uses.  Two devices
can share a node_guid, and the PD and the DMA mappings belong to one of
them.

Measured over soft-RoCE with KASAN, 114 runs.  A test-only event delivered
to isert_qp_event_callback() before the drain oopsed in rdma_notify() nine
times over two runs of 3/6 as it was in v7 and not once in two runs of
this series.  A connect on a second device sharing a node_guid failed
rdma_create_qp() twice in both runs before 5/6 and not at all after it.
The cells v7 passed are unchanged: no KASAN, no Oops, no lockdep splat and
no refcount warning on either side, device_list empty after twenty link
removals and re-adds, and the login park finishing in eight seconds.  I
still could not measure the namespace move, for the reason given in v6.

Yehyeong Lee (6):
  IB/isert: do not publish connections being released on a second list
  IB/isert: drain the QP without holding isert_conn->mutex
  IB/isert: tear connections down from an ib_client on device removal
  IB/isert: drop the promotion reference when a connection errors out
  IB/isert: do not build a new isert_device for a device being removed
  IB/isert: only reinstate a connection that reached full feature phase

 drivers/infiniband/ulp/isert/ib_isert.c | 395 +++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 294 insertions(+), 110 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

