Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794950038;
	b=MJ7jTF/9Rbby+ZR3IFrxBwyVvaqmulnIrw3nric+zn/Zw70iK+o0m8XjJdRtVZ3ojlns
	 1ll27OhOgbyMvbwf6jP/Ls2CfeBBglITxLf8sEAs8IWpKaZLEGatvlj1AgwGQsffgtCXn
	 BEVT6uS9kffiH9Fp9opcLKKEqCXX377nsyQ+jZhl1weyjt+AfcqpmHodhu/XssZXQPvMx
	 PkhdGWKv5RaJSJZu2++O+5ka3cngPs0+lHfSkJVYKvDO2iIqkTuhIw+lsH5zwPIhZYfYu
	 tvl0FVnaESw9XD4b2sW1L+FLY+SQn4g/EujSW9oeAnkdFml+Kf2cq3ca+bCo61Ten8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794950038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fB9kMdXFZP2PpIyp56/HTrHHC0ZOIzB1XwdTDxTm85Q=;
	b=axXotoaMglV/UCsF+L/D9SchmmW0DZphisSAKe2du330zVeGhjP6Oyr89OD1LyLeoc61
	 aEM05snqbSIfoZTPj1IX+PRgnf0eBDHvv9CCNSSZ/E4/bwo5L43RrbBNAAC+8lgAKUtae
	 2kSy0mCOO/nrh6URhwq4FfLtt23UgYE9UjogVCTQ6TbyhxVafUi3JO+Y0gGVSMD6WCI9A
	 2CW22ebh8ohQc7FQyt0vkMwn+H26mKFnCpiUL3Ac+aHooU5suXSfMTmU6J7iYA6TRQVK8
	 ka8eWCZcYrcJwRMatLfMoKBVK23g1jxu4Hbq2cPjoYG5I0gy7I1G/N1yVT2kp1KWLUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bpbb5y4O;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A204C606A32A
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 21:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A204C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=bpbb5y4O
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso237172a12.2
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794950036; x=1795554836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fB9kMdXFZP2PpIyp56/HTrHHC0ZOIzB1XwdTDxTm85Q=;
        b=bpbb5y4OaklgTpbqkACtS+gUVO/LPsmDc/a2QMkLfxt+O2GWfbrNVeN1fgEOtlvG74
         Y29t+eBMx/76K8m6UXSo01YeYmmo/3RYIAlGi+oeRJi7GTeMAnfjXyldQnHNsHri/MGE
         f3I0Mg2tiN4lHrm4j17seo2CrZ0T+nCIBNcvmVp5Ytd2q1bJ+PrIVzzfzODxdYBvtlAX
         SNIwGzO0B+Aiomj5jUUxWDCrlxLQqIQeGNjmh24qbqeq8buQaKlrAEwQ8dD0srf7alct
         BBWfRZrPD84KMW0y6ohvEtlDyPhBDmCR6m4cV4noBrJ1eTpCCKLrdqAjNCur8ETrNE27
         jjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950036; x=1795554836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fB9kMdXFZP2PpIyp56/HTrHHC0ZOIzB1XwdTDxTm85Q=;
        b=1DeE/hiTT8yvySBKnWqV1tfyoXgVCm0o5ggn2JnZvQj/rIMIdlm2G/O0tYMHQxmqsz
         C+8DvaL1b4N2hAGiOYyuRrFGvlAqMQcYDuIKfzbDH68yXenSTf6ZELWdKlYptuNExs9H
         GvIpRjhbpPRHQGfw2lpFRSCkFHGPO+8+jiJJqQ98GcEXtog7olOYfFxArljx8o4jVTeD
         CFvO15mTanIQGoWTPOI+ae/HZAdOZWeqgxBvtMm2WY0Jj4qlXTHYFcGWF6XDYutpzw96
         9A2DnkF+HI5vlpJwXlYBz4kgYI6XpJiqVfCDiFGMu8iCm+yFnY9xc6pe9/64U6FuinCS
         iqJQ==
X-Forwarded-Encrypted: i=1; AL+hErGpNIbFZXaS5CEMeVA1CdysZeKp4QXaL3Bw6Bxk3Boppoueq/ZNss0KzolccPsfQpTnT8O1KZvk2gBrALo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9NAot+bvXQxMjThzD0kDHnQ8CbNCX5HR0ARE7eWJt+IPzxy9Hg
	Fg8R0I77SQkADh0zuE9Rycu/ntKb1FyzRdPSLNDR2fHk5nsYUbRM7cJjvmJ5PctFYM4=
X-Gm-Gg: AZFdTZfQDQVGBa+EfcP5PqB8uGGMNLCZPNjTvX0yk8XP8C3hi/eMEzjtfF1AcfiMmSS
	uvblPhTni4NgG+/67lKtbtSGvybDwLvG3Ul100gLH11GMtzVCJoUMPL09J4tjhRahlrsdG0I440
	NaULqT/itWmKwG/II/C/Vk0YHKAw+TCvw1BaMi9zQdnyBa79MdFfJSnXUveqHeNbMdjsMQWqBaR
	N49eBE0N0M/XmIkeVdwAcbF1AZZyppyNVOgKKb2hEA3yzm9PNlyamknYSZz6jv36q/6MrCey2ri
	oZnkgSOsb1mHldbP5CeugA27J+XwMUTSF/80MGSuKejQry0/xoLTfwzsxbe8sg3tSBa6Bu82/iU
	mIGK6xBTpWGx/ZZ/8ORfItcQl69QD+Pums3oLr2VVlEOCi6kLcJ+mBgp0CwTcVSj3aSTXrldJcu
	Yxo/MMpW+2HLy6SppbtCYyzkvvNIAd7EEdule/yG6ivMlho0ftjWDEEGhEokbVFPdYPnGMO2VnL
	VB01hjW0NwWzP9UvhbXaSIA9UWRIf0QIqdCaZRKUT9nzQ2Z6+QlHNansdrkFkZkqtKoyeAu+EPk
	8Ol5lKXF0by7hRO0ve+Prqb6UtIQk4AnOpF1KSbtEMAD1P8a0I7BAEHr6XV702Rne92RyGbk6OR
	BV60lZOFGRJVQTLfvWlUrC7PU2bq+yIBrUU9YwA==
X-Received: by 2002:a17:90b:5390:b0:3ac:8446:c1b5 with SMTP id 98e67ed59e1d1-3b3d0765f4amr646287a91.31.1794950035587;
        Tue, 17 Nov 2026 13:13:55 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d187dc82sm693125a91.6.2026.11.17.13.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:13:55 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Wed, 18 Nov 2026 06:13:46 +0900
Message-ID: <20261117211346.2132827-1-yhlee@isslab.korea.ac.kr>
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

iscsit_handle_time2retain_timeout() is a timer callback, so it runs in
timer softirq context, and from there it closes the session:

	iscsit_handle_time2retain_timeout()	<- timer softirq
	  iscsit_close_session(sess, false)
	    transport_deregister_session()
	      target_for_each_device(target_release_res, se_sess)
	        mutex_lock(&device_mutex)

transport_deregister_session() has walked the device list under
device_mutex since commit 80647a89eaf3f2 ("scsi: target: core: Release
SPC-2 reservations when closing a session").  The can_sleep argument that
the handler passes as false only guards iscsit_check_session_usage_count();
the transport_deregister_session() call below it runs either way.

The callback also takes se_tpg->session_lock in softirq context, and it is
the only code that does, which makes that lock SOFTIRQ-safe.
iscsit_start_time2retain_handler() takes tpg->tpg_state_lock with plain
spin_lock() under it, so lockdep reports an inversion as well.  Both the
softirq acquisition and the plain spin_lock() are as old as the driver,
commit e48354ce078c ("iscsi-target: Add iSCSI fabric support for target
v4.1").

An initiator needs nothing but a session to get there: log in, then send a
Logout with reason CLOSE_CONNECTION.  iscsit_close_connection() leaves
session_fall_back_to_erl0 clear for a Logout, so instead of closing the
session it arms the Time2Retain handler, which runs DefaultTime2Retain
seconds later because the session is never resumed.  Three such logouts on
a KASAN + PROVE_LOCKING + DEBUG_ATOMIC_SLEEP guest give three of these:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
  preempt_count: 101, expected: 0
  RCU nest depth: 0, expected: 0
  INFO: lockdep is turned off.
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.4.0-rc2-00563-g97d73c825122 #1 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x80/0xa0
   __might_resched+0x31c/0x520
   ? __pfx___might_resched+0x10/0x10
   __mutex_lock+0x10e/0x24e0
   ? target_for_each_device+0x6c/0xc0
   ? __irq_work_queue_local+0x18e/0x370
   ? __pfx___irq_work_queue_local+0x10/0x10
   ? lock_acquire+0x2c8/0x300
   ? __pfx___mutex_lock+0x10/0x10
   ? lock_release+0x1de/0x280
   ? vprintk_emit+0x2dd/0x3d0
   ? __pfx_vprintk_emit+0x10/0x10
   ? target_for_each_device+0x6c/0xc0
   target_for_each_device+0x6c/0xc0
   ? __pfx_target_for_each_device+0x10/0x10
   ? __pfx_target_release_res+0x10/0x10
   ? trace_hardirqs_on+0x18/0x160
   transport_deregister_session+0x19c/0x250
   ? iscsit_check_session_usage_count+0xa4/0xd0
   ? __local_bh_enable_ip+0xa7/0x120
   iscsit_close_session+0x20c/0x540
   ? __pfx_iscsit_handle_time2retain_timeout+0x10/0x10
   call_timer_fn+0x15a/0x4b0
   ? __pfx_call_timer_fn+0x10/0x10
   ? lock_acquire+0x18d/0x300
   ? __run_timer_base.part.0+0x5d4/0x930
   ? lock_release+0xc6/0x280
   ? timer_recalc_next_expiry+0x6e/0x210
   ? lockdep_hardirqs_on_prepare+0xa9/0x190
   ? __pfx_iscsit_handle_time2retain_timeout+0x10/0x10
   __run_timer_base.part.0+0x5e3/0x930
   ? __pfx___run_timer_base.part.0+0x10/0x10
   ? __lock_acquire+0x570/0x1b00
   ? find_held_lock+0x2b/0x80
   ? clockevents_program_event+0x1b8/0x860
   ? lock_release+0xc6/0x280
   run_timer_softirq+0x12c/0x210
   ? __pfx_run_timer_softirq+0x10/0x10
   ? lock_acquire+0x18d/0x300
   ? lockdep_hardirqs_on_prepare+0xa9/0x190
   handle_softirqs+0x1ff/0x8e0
   ? __irq_exit_rcu+0x1b8/0x1e0
   ? __pfx_handle_softirqs+0x10/0x10
   __irq_exit_rcu+0x153/0x1e0
   irq_exit_rcu+0x9/0x20
   sysvec_apic_timer_interrupt+0x6b/0x80
   </IRQ>

and, once per boot, this:

  WARNING: possible irq lock inversion dependency detected
  7.4.0-rc2-00563-g97d73c825122 #1 Not tainted
  --------------------------------------------------------
  swapper/0/0 just changed the state of lock:
  ffff88800ec7c148 (&se_tpg->session_lock){+.-.}-{3:3}, at: iscsit_handle_time2retain_timeout+0x46/0x1a0
  but this lock took another, SOFTIRQ-unsafe lock in the past:
   (&tpg->tpg_state_lock){+.+.}-{3:3}
  and interrupts could create inverse lock ordering between them.
  other info that might help us debug this:
  Chain exists of:
    &se_tpg->session_lock --> &sess->conn_lock --> &tpg->tpg_state_lock

Keep the timer and move only its body into a work item, so that nothing in
iscsi_target takes se_tpg->session_lock in softirq context any more and the
invalid sleep goes away with the inversion.  Arming and stopping do not
change: mod_timer() queues on the timer base of the CPU that arms it, which
a caller holding a spinlock with softirqs disabled cannot let expire under
itself, and iscsit_stop_time2retain_timer() still ends in
timer_delete_sync().

What a stop can no longer wait for is the work.  Every caller holds
se_tpg->session_lock with softirqs disabled, so it must not sleep in
cancel_work_sync(), and a work that has started but not yet taken that lock
would outlive the stop: ISCSI_TF_STOP does not hold it back, because a
later iscsit_start_time2retain_handler() clears the flag again and the work
would then close a session that has been resumed.  So the expiry itself is
handed over.  The timer sets ->time2retain_fired, the work takes it back
under se_tpg->session_lock and returns without it, and a stop clears it.
Only an expiry that no stop has overtaken closes a session.

iscsit_close_session() must leave neither behind.  The stop above can
return before deleting the timer - on ISCSI_TF_EXPIRED it is the work
itself that is closing the session - so delete it there, which also waits
for a callback that has set the flag but not yet queued the work.  Then
cancel the work: wait for it where this may sleep; where it may not, it is
that work, and because a work never runs twice at once the only one it can
have is queued, which a non-sync cancel drops.

What the restart in iscsit_close_session() does when a session usage count
is held is unchanged and still wrong: iscsit_start_time2retain_handler()
returns without arming anything because ISCSI_TF_RUNNING is still set.
Waiting for the count instead is not an answer either, because the thread
that closes the session waits on the same single completion.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Fixes: 80647a89eaf3f2 ("scsi: target: core: Release SPC-2 reservations when closing a session")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---

Notes:
    v2 -> v3, from the Sashiko review of v2:
    - Delete the Time2Retain timer in iscsit_close_session() before cancelling
      the work.  A work from an earlier expiry can take ->time2retain_fired
      from a timer that was stopped, re-armed and has expired again, and then
      free the session while that second callback is still between its
      atomic_set() and its queue_work(); the stop inside
      iscsit_close_session() returns early on ISCSI_TF_EXPIRED, so nothing
      waited for the callback.
    Link: https://lore.kernel.org/all/20261117114920.1955697-1-yhlee@isslab.korea.ac.kr/

 drivers/target/iscsi/iscsi_target.c       | 14 ++++++++++++--
 drivers/target/iscsi/iscsi_target_erl0.c  | 20 ++++++++++++++++----
 drivers/target/iscsi/iscsi_target_erl0.h  |  1 +
 drivers/target/iscsi/iscsi_target_login.c |  1 +
 include/target/iscsi/iscsi_target_core.h  |  3 +++
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e759..181d8b12b6c9b1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4504,8 +4504,8 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	/*
 	 * If any other processes are accessing this session pointer we must
-	 * wait until they have completed.  If we are in an interrupt (the
-	 * time2retain handler) and contain and active session usage count we
+	 * wait until they have completed.  If we are the Time2Retain work
+	 * (can_sleep is false) and contain and active session usage count we
 	 * restart the timer and exit.
 	 */
 	if (iscsit_check_session_usage_count(sess, can_sleep)) {
@@ -4535,6 +4535,16 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	/*
+	 * Neither the Time2Retain timer nor its work may outlive the session;
+	 * a work never runs twice at once, so this work finds a queued one.
+	 */
+	timer_delete_sync(&sess->time2retain_timer);
+	if (can_sleep)
+		cancel_work_sync(&sess->time2retain_work);
+	else
+		cancel_work(&sess->time2retain_work);
+
 	kfree(sess);
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 24db6b07493e62..036ddc1002f6ca 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -741,15 +741,17 @@ int iscsit_check_post_dataout(
 	}
 }
 
-void iscsit_handle_time2retain_timeout(struct timer_list *t)
+void iscsit_time2retain_work(struct work_struct *work)
 {
-	struct iscsit_session *sess = timer_container_of(sess, t,
-							 time2retain_timer);
+	struct iscsit_session *sess = container_of(work, struct iscsit_session,
+						   time2retain_work);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	spin_lock_bh(&se_tpg->session_lock);
-	if (sess->time2retain_timer_flags & ISCSI_TF_STOP) {
+	/* A stop after the timer fired takes ->time2retain_fired back. */
+	if (!atomic_xchg(&sess->time2retain_fired, 0) ||
+	    (sess->time2retain_timer_flags & ISCSI_TF_STOP)) {
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
@@ -769,6 +771,15 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 	iscsit_close_session(sess, false);
 }
 
+void iscsit_handle_time2retain_timeout(struct timer_list *t)
+{
+	struct iscsit_session *sess = timer_container_of(sess, t,
+							 time2retain_timer);
+
+	atomic_set(&sess->time2retain_fired, 1);
+	queue_work(system_dfl_wq, &sess->time2retain_work);
+}
+
 void iscsit_start_time2retain_handler(struct iscsit_session *sess)
 {
 	int tpg_active;
@@ -814,6 +825,7 @@ int iscsit_stop_time2retain_timer(struct iscsit_session *sess)
 	timer_delete_sync(&sess->time2retain_timer);
 
 	spin_lock(&se_tpg->session_lock);
+	atomic_set(&sess->time2retain_fired, 0);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
 	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
 			sess->sid);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 2a877d13977d24..f0e157b0a2f5c3 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -13,6 +13,7 @@ extern int iscsit_check_pre_dataout(struct iscsit_cmd *, unsigned char *);
 extern int iscsit_check_post_dataout(struct iscsit_cmd *, unsigned char *, u8);
 extern void iscsit_start_time2retain_handler(struct iscsit_session *);
 extern void iscsit_handle_time2retain_timeout(struct timer_list *t);
+void iscsit_time2retain_work(struct work_struct *work);
 extern int iscsit_stop_time2retain_timer(struct iscsit_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsit_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsit_conn *, int);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029684..fda04eb15d3a27 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -250,6 +250,7 @@ static int iscsi_login_zero_tsih_s1(
 
 	timer_setup(&sess->time2retain_timer,
 		    iscsit_handle_time2retain_timeout, 0);
+	INIT_WORK(&sess->time2retain_work, iscsit_time2retain_work);
 
 	ret = ida_alloc(&sess_ida, GFP_KERNEL);
 	if (ret < 0) {
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 51ca80abacf7ba..5cc688b3f7d148 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/socket.h>            /* struct sockaddr_storage */
 #include <linux/types.h>             /* u8 */
+#include <linux/workqueue.h>         /* struct work_struct */
 #include <scsi/iscsi_proto.h>        /* itt_t */
 #include <target/target_core_base.h> /* struct se_cmd */
 
@@ -682,6 +683,8 @@ struct iscsit_session {
 	struct completion	session_wait_comp;
 	struct completion	session_waiting_on_uc_comp;
 	struct timer_list	time2retain_timer;
+	struct work_struct	time2retain_work;
+	atomic_t		time2retain_fired;
 	struct iscsi_sess_ops	*sess_ops;
 	struct se_session	*se_sess;
 	struct iscsi_portal_group *tpg;
-- 
2.43.0

