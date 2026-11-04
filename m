Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755355;
	b=DxGITT7yMvaeXNDYL3kS7mUa8Ls/n/BT39IvscNnLj2IMUlZwS4wHtn7L+CuN03Gtz3A
	 xMG2J2UQYUZtoFaCoP9BdfChvA4BgfgOHkOAWk3tVPydxDbo7/CCXwUUK/pbBf3L3V2GU
	 cZo/x7aZb/S+wV2AyQo7BSedGO3juaZ0V9l6xJiiVkFd+DHWgJlin0ZltKyYn0X3WPfJZ
	 d8uLqwtX5kgRsdJxqy7wa3lDThs4QAvi36QySFZNagVg0dfbzevRZYPqt7zomCD5IT+lr
	 WVe+foKgSQeILx9hKYGNbr6iEyYlMOnWANVwKxXaE2yXAiu08IOQ44V8rC4KTbgY4Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
	b=PqhmSfFdPZRe4MmV0ixtFndPMS6t/ZfmNvk/5Vye3NU663HKJjm3NeNPEwY0qeDfcoK/
	 4kCEvp2U1wEttiQLYbVSEbSEoa57NfNBbqMmFcJ/LBvHkpHde/kQs1RYJGUZjq7ODGdgB
	 hvaL4PFdKtmJ3sNg5YJNDkqahEwHJKqkxH2hzmKWDJV+ZUSM+GK7nwZ77/jAdgMVhVt0W
	 CrsChbnUE9/BafZ5JcoeJpqnKsUTiGvhaoxpYYA9zzv4FQnX40MnNxdhhvb4Lk7lOecqp
	 ETDAskSQ9aKteFTtALtxy/wabHlrF+cOXUiayeGrKL3Y6kzMvWX/QLL1xkc5g+GWwhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QY3a6FxG;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432EB606A31B
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 01:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 432EB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QY3a6FxG
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso21848a91.2
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 17:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755352; x=1794360152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
        b=QY3a6FxGWEEGE0Gke5rLu5IpVBl4gWuFlimWmeG5zx1mMNskq5V77WjWyyzimEg8uY
         TJOV9SCzvRaSFGuOoF70o5cPppKTGFF2KIECNiVjFvJiXY1hZUrrqQD48Z0l25a1V7H5
         JHgvJfrH130y7YkWuO1yf5lUsfMVZamq5LXWQnf18HmS2Xf9QImZ7crpjUzRs3rBwHHy
         22BdLzCOLM4dhFNJ5Rwb4HePT/r/rk17BapFFcjw+5mrLaiNuN13zeexRTK46NFhQCJN
         f3zBmLyyv10UTuJ00qViyGH16PGlFU7U9QPLSybdWuni8i9E70v+h4OFvIcOsDhf4dt1
         S75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755352; x=1794360152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PJBuNB6AkmZaXTR0pd/HV7JvJHCCmg2tFqwhpuFbIGs=;
        b=OOiz5Fh/lg7co5ogEC1j9aRtM8diJmX5KsinQJM1+iQ56FDEY4ucNUVK5jvnZT9+Sz
         Ascp660KP29wRTxBszkQGHVwABoqh7BeZ4XjcYmi8CwSntFjn5ZYs0EMhIf8R/o69x0W
         B59PaoUp/Wbkkq5sKVerlACI1sUgY18xEJEBgUcOfJ9evWcgts8vQUVpjHbADSoHPZz+
         FR6py2U6RdcqPJkOsvhSo6T9u8ruzNIn9HlN2/a9AB++SxrpE50g0PebXvxWCV4HQmRh
         ExEeqDsj2ZqdXpwV746R4v0rPBA/sgGq+bUpn89DN8WstjL76Wfn/8GtQqsAg6NpMEsj
         ztRw==
X-Forwarded-Encrypted: i=1; AKwUvBx7RPjAJXJpcT3VkwY4aFmqZhtpvl3acvbvks2TzY9YBuD8vrjeGDVTvOuhGxpJp/MSu6oPuJtWlY52pro=@vger.kernel.org
X-Gm-Message-State: APuU4Z/o8/EUk+uxuf+Lgdz4kubbesbEw4jFBjAbx3C0IS1J/F96BHUv
	Mf1tMrWOJ4gXxjR2UQX37uudv0lQUwHyIUwOo8PngmzWcxe7QlwhFDkfgKa6fdNszxU=
X-Gm-Gg: AYBFou2KJ//3iOa0tlUGc41YUTrZ0qq6s6CW292qo1y3dqQLJF3YQFwA83z2pwGn35r
	TbPhBnaLqdt9QCk/g2ZM3CQkFvHzGb9d/yBQBRCo8YBEbRdvZ+lmQTgsuFNP6FdqS0XFIWc7x0f
	6zenveiJPEFI1MkEu102l3S13Xs5CtM0PnJssjR15DLcK+3fjhd9hixkAsA4OreSWy1q9Qo+b5M
	NnlMj+izf2v/uvsWceDEtzgH+nC7WdPFt862YtwmB/smt+zH2HkWcZURIldCkqLzZvOtospYR3l
	Pdw2X/MUR0EJX3aNjGQSjiC6Jy2RXYkReWo+rOHr3LJOHIKd6bavCkxqSVuDKsO2ZJVdnahmrg0
	CDJNlVtjGTKfELoyPZQ0VDMKKl2Xiu2AFLU6SKKhVvNr5bMlzSVGendQAuxRwr+vlE1fOnEfIxD
	O9ZDnzP6cvoB9/ZEOHzVR3sSx551Fl954BV+lLcNgMh/g7l8ozNGGwukUBk3DlR80y1VFoOqSxn
	IrCRlRyeqPFtV/d8SORC19y5tO5Zj78cE6FVF0wz9at2CXTQ+vq5cxxQYQnf7HTSd5b/kKdepkW
	CVnqC1+XHcYEdN62KBlFd8i7D4NCmjkCxd2Vktc8VSixHbQTePJkduGizztc1hlTOHxqKSzqbd1
	QkBqqZRQCCYPxMtMV3mU2wil8HthKK1fsS5rj
X-Received: by 2002:a17:90b:4b8c:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3ae897c853cmr12849266a91.10.1793755352365;
        Tue, 03 Nov 2026 17:22:32 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09452d89bsm678045a91.0.2026.11.03.17.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:22:31 -0800 (PST)
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
Subject: [PATCH v7 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 10:22:13 +0900
Message-ID: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
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

v6 -> v7

v6: https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr

v5: https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr

v4: https://lore.kernel.org/r/20261103032924.1073138-1-yhlee@isslab.korea.ac.kr

Sashiko v6 5/6 Medium: set removing in the same critical section that
clears the client data.  isert_remove_one() cleared the ib_client data and
took its device reference under device_list_mutex, and set the removing
flag only in a later section.  Between the two an isert_device_get() for
another device with the same node_guid still saw the departing device as
usable and raised its reference count.  5/6 now takes isert_conn_mutex
first and does the clear, the lookup, the reference, the completion and
the flag in one device_list_mutex section.  No path in the series holds
device_list_mutex while taking isert_conn_mutex.  Nothing else changed:
1/6 to 4/6 and 6/6 are the same commits as in v6.

Measured over soft-RoCE with KASAN.  Parking isert_remove_one() after its
lookup and connecting on a second device with the same node_guid gave the
departing device two more references on v6 in both runs and none on v7.
Everything else is unchanged from v6: 140 runs with no KASAN, no Oops, no
lockdep splat and no refcount warning on either side, the late-device
window building one device and no core warning in six of eighteen runs,
twenty link removals and re-adds leaving device_list empty, and the login
park finishing in eight seconds.  I still could not measure the namespace
move, for the reason given in v6.

Yehyeong Lee (6):
  IB/isert: do not publish connections being released on a second list
  IB/isert: drain the QP without holding isert_conn->mutex
  IB/isert: tear connections down from an ib_client on device removal
  IB/isert: drop the promotion reference when a connection errors out
  IB/isert: do not build a new isert_device for a device being removed
  IB/isert: only reinstate a connection that reached full feature phase

 drivers/infiniband/ulp/isert/ib_isert.c | 399 +++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |   9 +-
 2 files changed, 297 insertions(+), 111 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

