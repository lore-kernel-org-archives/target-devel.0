Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600310;
	b=iIpgGnzRffYkh0LQyhIeD3f+LI6Ydm3uEjQ9oHj6q9lWhwhRzQgXxZB1ij9QmaPdWjX5
	 uKg9aE4H5hSlYKXzNsTi48uuffvgpYsObFPLKhCXcrJ3uQoqcQ0kAViSPhqcV81MTei6L
	 Y4jLHf2hKwpZyZ6yNXoy7XyPqgSitb7bpWKb/GrrsuYljP3RFfcyLdHmhlLjI99zHIa3c
	 SCy7SQAft0oqwJu4pJ7NTQMrmr6RL7fIvdFBbKuVYXwxxhJN8rL0dm/+/1BKcQigsXbOE
	 9MqHidCyC/+5oRs8Zdt+7RWy48H/Pw8JPSW6uTkgLoLwcP/ppBz/ESB+ZRQFKe1C6ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600310;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
	b=1cyJpEH/xTuLo3SHJUdAWkCPzdiHLVnsDT9FGbhPYaVvH4vvVDxLn6aqTMRpajt/Xhr/
	 8WPxqcun3IB7/DJP0srKH8uX5gyEXHfJ3HSGNry9phNejjvMI8/RknkT1vjRxfINumYsl
	 i4umJrFOi3v/Ap9zvPU7kZrcObSxWkRrE6WEYXhuj420Iwjtej2z7nTCgi5LtSKZv29Ry
	 uGWAXGgtO1fNLeyzwO+jYqMT1xP2UK61VLMmhz8k630y6SROOPm9d5Gc8og8n1/iNZxL3
	 54bpQZ3GVHaXKF7BLhdmEyq+klvTbttg9HTDkNT8e/SohLt8O9ZEgXUnAH+fVT8zSuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Fp7ohFFT;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C8606A327
	for <target-devel@vger.kernel.org>; Mon,  2 Nov 2026 06:18:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E2C8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Fp7ohFFT
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adf5f6833cso1330314a91.0
        for <target-devel@vger.kernel.org>; Sun, 01 Nov 2026 22:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600310; x=1794205110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
        b=Fp7ohFFTYx3vv3aTjSalkr6sHXZ0b4pV0DGR0eIjTY4elFQ03NCEMwX4xjjMbFXvVU
         Om0z2/vPLfSQ3WNb9YuqTbRAi17IGUEqhDIeQuE6nlx27sRpsn+ttImW0j6QG7XpZguW
         EMjNKSOGaRMxpfGmnUPREZskN17b9836h/9n8KXybQzAvZultF92AB+C0xmBR2W7xGHy
         G7dkTQnxtSuCKTaHstfIo8lpWKtbY5F5aP0qbUIGxIZz0Rb0DNJQI4qiIQSrSbO+wCaJ
         jmtuzBcdCgZw16ZEYLz9jPum+QUxtk9JjMZJMXctsGBAIDmT7icMZTB171lZ4Ai+y4GY
         hVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600310; x=1794205110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
        b=zD0Y1tEPc+2hXur6V1TDnFYSljOTp9he8IRvCWBKi8u/ba7gwL814sT44L3Bvp644z
         SFPJFq2fyeLyji6SRw9zLkdUdBCMvQsvBGjfYrNW2O7E9bCUP9BX91PW33Mhf8Un5Rml
         P/38g6jygQbEw4sYc67sy29OsJIjhNP2qFpv051BQ3HW1UVfczxy0DgroPGk40cuiDsn
         O+H55f0xYh6aNclj1OdrhWvP+lJGWltIGa4KyPNgp3Y+wOCvxJYNLvu9aK2LXYmOLP0W
         BfEtThfl9cuvN6AFjHGnal3T52QIKLIarJOpD6WRhDqWT3R/SPG1KU4Mew8CSG1dlxh9
         c2fg==
X-Forwarded-Encrypted: i=1; AKwUvBwqjv2p7iXrrno2tCv+J/nGonEUb+EisDA6TK66+KVGdm3pcHNN3oFCzJtSdqACHTkByKwch/V2mHzTAYM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ET39Zih9Ka5cJ/GmDTuVkO1SI3t0FfcWN+pP06AKBxvh+FtDJ
	6oPAkkFRVU+xC7bB+xAUNKOlMspuF4n0J1m0BCce6x1x2/2YzbKGJvjaXHuvDh+FO5k=
X-Gm-Gg: AYBFou2O+RVF5bbGTsYGp4Sdrz0/i2nItlxrLBflvTnZpIAMT2DtWsqlfIkbiQg0QrY
	RUh9wG2IvKIXOIk8bxKv1KzRy2V0hcJjsOp1XjFZWEQuq2q4We0rBBZ7PdMCOUxqWS6skUWpXJB
	jpWRw/oIIXTbTY+3N/FuRMIUJLRJU3FgexmLgHrnvlAwTuIl04zgccyQsv+KgkciWTtiGe94pOH
	dmymBXFf9oEgSBFNOBKTRgJ8FyP77JiUoEKRM1DTijnKQWTSoWP36ZYzvs6L0l+rmmZEFWfiyAN
	7MN5HGNXKvWcIQ4wm4jAqtGsAodDhuI82+1GmFMODaPq0Q+mF3kGuBpmTE6P0wPLa9WkMN+FF4a
	O7imCNbQbx9QyyBB1mbEOXORyGTzkk5QWm3aWoEr89VhZltGH3wD/HdLU6zlcgYbCdM+DV0wawF
	feAYKPG+kYXMB7rJ/Pn3iBcSjbjYcjBn7j3tcuXIe9W3BaWxko91cSo6V3iUfjVsz9OAlwJymU4
	08K6VNLcN1/ZORcZxhxAQKjFFD5VZp3qm9mtP2zP9vm4vJMcEAMzk+jDYNsjTTywhlWorhaW3wR
	Jt6LE77njN5JHuUm2pOoLlBq25eLZ4DYIkE+3pB7LKQ50CwWQEAKb6uWywLIrafDvgKaGJjNF1b
	OpQxZfOxl43BPrW1A/DC/voVoMXMY8kNxYyKvutl0F9XxwC1cXQ2raaJAJq0=
X-Received: by 2002:a17:90b:4f8a:b0:3a4:ca46:840f with SMTP id 98e67ed59e1d1-3ae896f8655mr7224057a91.8.1793600309684;
        Sun, 01 Nov 2026 22:18:29 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17211751a91.9.2026.11.01.22.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:18:29 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] IB/isert: tear connections down from an ib_client on device removal
Date: Mon,  2 Nov 2026 15:18:19 +0900
Message-ID: <20261102061819.617254-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-184744@kernel.org>
References: <20261026060505.409476-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-184744@kernel.org>
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

Thanks for the review.  All four are real.  v3 closes three of them and
most of the fourth; what is left of the fourth is below:

  https://lore.kernel.org/r/20261102061608.617186-1-yhlee@isslab.korea.ac.kr

The isert_free_np() race is a separate patch, 1/2, because it predates
this work.  Keeping isert_np->mutex over the release loop would have
brought back the deadlock commit 691b0480933f fixed, so 1/2 takes the
connections off isert_np one at a time, which empties isert_conn->node
before the mutex is dropped.

The isert_connected_handler() race was mine.  Both handlers used to be
reached only from isert_cma_handler(), which the CM serialises per cm_id,
so the two critical sections were safe until isert_remove_one() started
calling the teardown without that mutex.  2/2 now keeps isert_conn->mutex
across the state store and the list move.

ISER_CONN_INIT is marked by the teardown and released by
isert_connected_handler(), which refuses to promote a connection that is
already terminating.  Releasing it from the walk would race
isert_connect_error() for the single reference the connection holds.

For the racing connects I could reproduce the half where a connection the
walk has passed is promoted afterwards, and the same change closes it.  A
connect request arriving during the removal I could not reproduce on
soft-RoCE.  While isert_remove_one() is still running, the code refuses
it: isert_connect_request() now fills both lists in one isert_conn_mutex
section and returns -ENODEV when the device is already going away.

Your third ground stays open, and I should say so plainly rather than
claim the window is closed.  Once isert_remove_one() has returned the
isert_device is gone, so a connect request that arrives before
cma_remove_one() tears the listener down makes isert_device_get() create a
fresh one, with removing clear, and the connection stays in
ISER_CONN_INIT.  cma_process_remove() raises DEVICE_REMOVAL on that cm_id,
isert_teardown_conn() only marks the connection, and no further rdma_cm
event can reach it, because cma_send_device_removal_put() has set the id
to RDMA_CM_DEVICE_REMOVAL and cma_ib_handler() drops every non-timewait
event for an id that is not in RDMA_CM_CONNECT.
The cm_id is never destroyed, so cma_process_remove() blocks in
wait_for_completion(&cma_dev->comp).  The unpatched code blocks in the
same case, in wait_event_interruptible(), so this is not a regression and
not a memory-safety problem.  I have not reproduced it.  I would rather
leave it to a follow-up patch than widen this one.
