Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794727892;
	b=j2HEW7GSOI4rNLzQibTn/Zy/uE//5aFGMhYDhD5L0021BRNDPejjmjqhQy15EC/+PAeU
	 7kPtnRM13wq0OroX2YiSVecUa7pTBGvgyVPk9IThYc1mMVzUgZodBbAKc5epE8ySkKAiA
	 9f3YvsJTXGi1N8OS7PQQzMFs9Hd6eiZLBguCX68dc6R5USDuPMNidBoMBDQG3HDTeSwB7
	 YySIYaaqUssvjxklderJymWe2ZUvd/stMtOxOi27En7NYULuyVdAWpfVtAJJVEdduAIS0
	 Uf+vLifwOep0g8TwdkPkWa12+voMhy610u/SkD/H5J2Hi5Z70KzAaoTe/+/ST1XVtnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727892;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
	b=AyCeFta908E0yfHuCitU2djQgk2gOY20yT7RYIM0GQBgU+xEtSkom1JbGX6kn/jJaLsQ
	 nUyf6T9Aq2sxUj3wWE197nLSCzjmdsYTx3mqpK/ngBPZSifQr0E9Eu5sJ7l9/Nj8aJM1E
	 39FClQdXKCkByDVjkB/jnGTE9AR3nGHFYi+ipxpZI89rwyUf6fsCypHf/AwNgqop0J9BY
	 F2mo7kfkTXLa0/l0TtZ+SpMhV47sA5g0kRO8CcE4rjBlA1B9RTTubEv5kHGckL90IrsTV
	 OhMJZjUUhAeRon1s68aJSkrqfYEUtsZpfgu1EL/IwiAH5ns8UhmUWDcoKQR4/53C4SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3P0aCTQ;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB72606A329
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 07:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AB72606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3P0aCTQ
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b155f50c24so3542364a91.3
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 23:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794727891; x=1795332691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
        b=y3P0aCTQn4WSyqVN5zkxPbnkLqEDzHMHWf2Ar9oDoYglX075SKR/QrPhxSRKsu+JLb
         VG6aayabQVF6xbKnfaAXPknVHtTyL++LrdvGQJynFMEr2Eitam8S8KBSktTTQuUACzbP
         eRurKT0vNOsRlXljLI9u1PfFG9pdCHA2csRYllNf/hr5bJzscbk4PlX1JvW6A+1YAGgL
         rfbXHlA5LKWHSvYXX9qN1UE3xoUitxFTKdUgsupyk4nL2yQDnkmsEIUInFiNbs8woD2C
         Sc9EAb5kpp+64cahJCWIu/3eohf3hhxg1ifoCOUu+9MZo6+V4DOcHGg972RWOCJdntRQ
         PTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794727891; x=1795332691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sa+akLds93BeVY1vzyQ/uvngZ/sCGwFCpoLktGOe6rI=;
        b=lOaTUToWuxcHnVUt7CPCK4McLL1wueS0Cin2BUOe9c9WbgD95RPg06bxU8CBg1gUzl
         juwjbEkZqtE+vhM7EPpsgQ4HJ55/Fbkz24XAiT8+AD4cmeRvUR0KzUatOB/O2jgUpgki
         XpTdu4l3gnUXG7fvEX1A3DhMBVsgQzc/1dejIljxPJ89x8UTrgo8nhqp1141mJ7z5TKh
         L/O8lVJuwzcmTjvihJAexUkTPm++iVDrRiL8TW9ockPc10KlnmNWzVoBki+lc7wo98H4
         LSOR5XNIMPbBUCYU6/OKAl+sovZip9gxrhy4tJTr9vQ57XPrUqBSjYwUEfJ4mT6zZBT5
         yiTg==
X-Forwarded-Encrypted: i=1; AL+hErEA4BQmuV4riunhW7/pSMkC52GUpos04fwlE6ovviWIf/2sPFNxjzz91hJ+t2hx8MpKb0m44JLIVYLl/HM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/vS7ACin/NepZl6ZOJm//W7nvUJne5Z7FDbQ7QzD6UiHYObaDL
	En3N0V2NtnOW5sgRZ7i9w3DYgKK9cGFs+d2L79szN6Ip5d284ODaQBVH
X-Gm-Gg: AYBFou0RWt6M3Y/ztf3jCGhIhrMRiBq8afu1rVaiA3OYQMiZ2ZWwpVee7Zp/1fdgwKs
	d1q/M+kC5NoTnbJ/Kq3Zymi9hFYdHTYAnrJq5X8IZJVAWMSSEiwWoiSW+pkB6FEJrz/k2nUhWGU
	3ESCfngSUSBvbpAJ2ycc6W1JAtTyM47D04bAlYe1UQbDT772yr0EObpOvbuNB47RIlJExzOdF6b
	ffjY3jZ020PJ5y2Kw4KLqvFhiq7Rt6wBvhqWGwZlChH7tfTpbDPL4V08qzJ12OBd0iC2nHn/tRZ
	+0WgrKiZN01eN8x0WqY0ZYkuLszR+Np2yHO/liJBComcGx1Of4/jKJs6YRI98EdBr6YwJpugqCB
	goBgOyfOV8Oq4MA2uChibZGD0SqBDz9xTvUVzkvui2A6+BMJCmh8yk5VNsnrljZFzJchCWaoYD8
	HalufGoZIyDeNt43yeXEiDs+ZItSgT4Hl3LPjTRhHNM4r+U9M5F2R7hXYkBVhyp/7XapR6nusBL
	e/t0lXPiFSNY9lf0TZa1IMikKwIyGa5JDFSoNYJMqvRUhVPdRJT/xPfNzr1Ab9ELFtJeMvG9Fyw
	Rwyu2aC3WxQrqpPBVSIh+1THblPr012zKmM3q13YGOvsv5nDg2UhV1Pptly12iLd7mjudkw3wjk
	1n1L8fq/oq4l9/FR4J4fv5kWhTVLWhlUFpsZ3gBtMlbpxFzn8MMu5afvZO4lH5TjPDAOcEBfrM5
	5qxzOyPM/ZvNJJUE32ARf8Y1nNwZBIDs8Kc/TOkbFQXFjN4O6ZlkvI4OR9e9QPEGJgmxEbHs9tR
	a7zSXR6z3TxgkfUzFXOks/7VyjonvWfUPcqrvv79BGuOUTOuvgrFC7k42Ry64O+
X-Received: by 2002:a17:90a:f947:b0:3ad:eb4c:26fb with SMTP id 98e67ed59e1d1-3b1b0b553a4mr7578914a91.23.1794727890800;
        Sat, 14 Nov 2026 23:31:30 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce55c1sm16837463a91.3.2026.11.14.23.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 23:31:30 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: queue login_work under sk_callback_lock
Date: Sun, 15 Nov 2026 18:00:03 +1030
Message-Id: <20261115073003.9927-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
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

iscsi_target_sk_state_change() drops sk_callback_lock before queueing
conn->login_work:

	write_unlock_bh(&sk->sk_callback_lock);
	orig_state_change(sk);
	if (!state)
		schedule_delayed_work(&conn->login_work, 0);

Racing this, iscsi_target_do_login_rx() can take its err: path, which
restores the socket callbacks, calls cancel_delayed_work() and then
frees conn. The cancel does not help: the callback read conn from
sk->sk_user_data before the unlock, so clearing it changes nothing, and
cancel_delayed_work() cannot cancel a queueing that has not happened
yet. Nor can the err: path wait for it, being itself login_work.

The callback can therefore queue login_work after the cancel has run,
and conn is freed with that work still linked on a worker pool's list.
The core then unlinks it, reading the list pointers out of the freed
object and writing through them:

  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report
  Read of size 8 at addr ffff88800d94c440 by task kworker/1:2/32
  Call Trace:
   move_linked_works+0xa7/0x2a0
   assign_work+0x168/0x3c0
   worker_thread+0x3f2/0xd10
  Freed by task 32:
   kfree+0x179/0x530
   iscsi_target_do_login_rx+0x3b7/0x7e0
  Last potentially related work creation:
   queue_delayed_work_on+0x80/0x90
   tcp_fin+0x238/0x470

CONFIG_DEBUG_LIST catches it there; without it the unlink proceeds.

The window is a couple of microseconds against an idle target, but it
widens to milliseconds while many logins are in flight. An
unauthenticated initiator looping logins against 64 portals faulted an
unmodified 6.12.117 once in 19577 attempts, on a stock config with no
sanitizers, that time inside iscsi_target_do_login_rx() itself:
conn->tpg read back as NULL from the freed conn, and tpg_state_lock is
at offset 0x1c. An unprivileged local user reaching the portal on
loopback hits it far more often, about once per 258 attempts.

Either path oopses in a kworker. With panic_on_oops set the machine goes
down with it. No credentials are needed: the race is in login negotiation,
so any host able to reach the portal can trigger it.

iscsi_target_sk_data_ready() already queues login_work while holding
sk_callback_lock. Doing the same here makes the read of conn and the
queueing atomic against iscsi_target_restore_sock_callbacks(), which
clears sk->sk_user_data under the same lock. Either the work is queued
first and the following cancel_delayed_work() finds it, or the clear
happens first and the callback returns at the !conn check without
queueing. orig_state_change() is still called after the unlock.

With the patch applied that local reproducer makes 11212 attempts without
a fault.

Fixes: 25cdda95fda7 ("iscsi-target: Fix initial login PDU asynchronous socket close OOPs")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed15..85531d6 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -715,12 +715,12 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 		pr_debug("iscsi_target_sk_state_change got failed state\n");
 		set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		state = test_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
+		if (!state)
+			schedule_delayed_work(&conn->login_work, 0);
 		write_unlock_bh(&sk->sk_callback_lock);
 
 		orig_state_change(sk);
 
-		if (!state)
-			schedule_delayed_work(&conn->login_work, 0);
 		return;
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
