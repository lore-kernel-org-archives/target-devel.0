Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745202;
	b=SP20l8tMi1vi0GKMITba6fnWncMNTRUHqZHN88MbUKFOl30URteFiQcol/CRolPudPu0
	 otP0gsI/yVbpDwoE+YsdRLN5W9xArTlf01ech/c+kGcp2gj9PqSUl7rxeS2hfdmrGp5wP
	 yFSqWkUQjr/XQa00KYTdPuVC/D9xvFcuDMSZl5suWbAm6zJ+DHSOEnepBlbjQmlVjbLyX
	 QZMzfBIV/yx5fU71g50aMLicRE6Ir0lxGWxI+hARqp6afYIg2mqb6jMYKmnI18MJihOSl
	 WTMTwbWayhl7Mx/B0YhwguPvCz1BbruGOLqtXYp1RdWjlIDy+W5n7n1hVl3O4Qd7u2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vMtDV7rOGp9GHf0YCHtgLarvT5GW2vxnwIEbixUsoT4=;
	b=YWXqeKiIkQl9VNDmf6JUJmBo2K63ksl/p9SxG7PEEY5vtI6qYmQef4H0xI1uW7UofTOd
	 j3Sb3MCHt8yxy6SOIoTslLgZy6Bir4Ew3GXYBzSwKdKXqoZ7cW5M9CnuBimr/OmVVHZnP
	 qm7J4ULxKPorxvCOE/rOcbo9rgwS66gaR6cbAHKnUMOfHs6VgE7L+RLKBDNzEUE9rMqPx
	 /JxkRrEoNotMMecr6wZ6Avc4qsyc/X/J+SiLyxaJfI4ECadIJcPJA3DwVN9tmJVExETVX
	 iaN1OG8lzwfJ/to9LhqaZN8kJA2jgipCvWn5NjRF4yBhxlXnKUlccul5992Tn/Lj3jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e8FODNei;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D9606A31A
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 12:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B0D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e8FODNei
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b37951a397so608292a91.0
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 04:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794745200; x=1795350000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vMtDV7rOGp9GHf0YCHtgLarvT5GW2vxnwIEbixUsoT4=;
        b=e8FODNeitMi8AkmSLQb+kOB+CQNYthu7VoVGdkmiYZ97b35+1SPwbACfCdEGL1sk4e
         ut1YLlAH7suj9MzxuNUcGxnvaFrSfPHvJrLKGZwDtGTRGjVneQe7P72a2hxI5LXmuLUz
         LFQVN9LPrl7PZKiYzWAHzGJHnDVFglYZZUY669BPvfDSBQoAGFdoUVWHcD0JTta4VX80
         CM4xCMeh6ecKHfg497xmesD5kwIdiYssww/ilnzv1MSqRigsoUVUHMaGLutehwxoPMGv
         0H1momRZLLE5l9+5mspzCgZXG/gQD/t5LysciU6ziwCG+8GUh0xAnF7m1aUN7L8yTZZs
         dhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794745200; x=1795350000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vMtDV7rOGp9GHf0YCHtgLarvT5GW2vxnwIEbixUsoT4=;
        b=HdFdw9UPqSYucdLWlMas/ob5e43ph++nqBZ0kjTJmpWFaaCzfZGu3z4O7M/FB2M0e9
         zbSkj3jwB0wKsSe0qAeMzHBePgnD2Anb+b3txadknqY0LRPFI7ZUYpu6BPjBn59wY3Ay
         /tfUFFV+qxMeavmXuxcSaKMUloljKgYfE2D3noPCirdEoHma6HVHTPRgi4oaqTOILv8f
         8fO89C0w/WYdvjn/GsbyJxj1PsWYWBUiN/t530eSLx3c44q0RZ5w8/f2EcLlubG/xXvu
         1SMVguCfcIBuA6nEAUGMjZnnWqGbZ1bN60PrggTs4f2pWkzF2GHiw1JY2gsrT5SezOqI
         UsXg==
X-Forwarded-Encrypted: i=1; AL+hErGUYEk+ZuQL8Rj77uMjacKOg9Eyxe8HZ05Rt1WIDKAL4lNyQmjb1qmRqd+sEKDNxT4zX1ccCxKJrYYCyn0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8LKJuvA3Es0qoqeI2wBTeEzn2T6SvmLkIoAYZ+cDjsKBs7LesN
	XviYCnremosM4lxvkfoHSbHSPVAKBiL/l89IugSUf0VJPIalJoN9eYFAnPKP1ftCiUYFPMav2Oq
	3FHeD74c=
X-Gm-Gg: AYBFou1/WEubUfQClqjk/g5YWBNHVu1pkTqidJzQBmiGgQUuEV2d/xLxfPVAVR2MuHA
	h94WESQN6zbHaeydaUVhNPDAGqov/dLX8ns/6KpbGDzXyTjQTLuPIhocJj62NJ9J/e5EMwF7mJB
	TrloVqPE1QuDlWHCfIJOotup413fttNJgbnLPnHrZOsSLD6MfefvddurPDB0/j16+SMoqy+jTsI
	DblTO58sm4JjrjKtd4elK49JzYcHmUpTJIaGD+yVehH0uVT5fdR/qj/1EOLvTRld8JV1KtrLJuv
	MS4JDzTDdmYWwL8PIIk1YzS+33D0RHa9gsv5SWaYmcIoJhPVsHUCM4/EUjG0DmYmF3NG9JrwSga
	rkXgsp05KpGleXUOh6uQNMnwy4lsDDjJVzDCeyDiY/lF6qAfhQ0FDanCVNF+fu9nSV1l4ECgXlL
	IwfL8Qe9F5gY2tj0JXuDPxgOUOHIxfjvu+UA+uYy7Tp6koY85Ii8B3XQAYo9Qu0ZKH2LvCPDAuy
	hppY4Gl/9EnV5O+EMe3plAGEvj+fFHEt+/qObYZs+7l/UGcVco8oKaEFLfblgkew5XCCEabTMck
	+u7wDK0XfXDbz78Tm5jytTATa//IHTaFyLBX15JQQa8KuLMpoyCgZWmPpA4mcwOn02k6FwtGOyj
	HkYR1ByXu9h49xxk2KSpEU3F03ZgZD7Ab/A1+/CsJjeazGgHUtDb1uZsESBI=
X-Received: by 2002:a17:90b:4b10:b0:3b0:cc6f:1046 with SMTP id 98e67ed59e1d1-3b1b0dce88cmr7411321a91.67.1794745200156;
        Sun, 15 Nov 2026 04:20:00 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d27d26sm17099781a91.13.2026.11.15.04.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 04:19:59 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Sun, 15 Nov 2026 21:19:43 +0900
Message-ID: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
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
   __mutex_lock+0x10e/0x24e0
   target_for_each_device+0x6c/0xc0
   transport_deregister_session+0x19c/0x250
   iscsit_close_session+0x20c/0x540
   call_timer_fn+0x15a/0x4b0
   __run_timer_base.part.0+0x5e3/0x930
   run_timer_softirq+0x12c/0x210
   handle_softirqs+0x1ff/0x8e0
   __irq_exit_rcu+0x153/0x1e0
   irq_exit_rcu+0x9/0x20
   sysvec_apic_timer_interrupt+0x6b/0x80
   </IRQ>

and, once per boot, this:

  WARNING: possible irq lock inversion dependency detected
  7.4.0-rc2-00563-g97d73c825122 #1 Not tainted
  --------------------------------------------------------
  swapper/0/0 just changed the state of lock:
  ffff88800ec14148 (&se_tpg->session_lock){+.-.}-{3:3}, at: iscsit_handle_time2retain_timeout+0x46/0x1a0
  but this lock took another, SOFTIRQ-unsafe lock in the past:
   (&tpg->tpg_state_lock){+.+.}-{3:3}
  Chain exists of:
    &se_tpg->session_lock --> &sess->conn_lock --> &tpg->tpg_state_lock

Move the body of the handler into a delayed work item on system_dfl_wq, so
that nothing in iscsi_target takes se_tpg->session_lock in softirq context
any more and the inversion goes away with the invalid sleep.
mod_delayed_work() and cancel_delayed_work() do not sleep, so
iscsit_start_time2retain_handler() and iscsit_stop_time2retain_timer() keep
calling them with se_tpg->session_lock held; cancel_delayed_work() does not
wait for a work that has already started running and need not, because
ISCSI_TF_STOP is set under se_tpg->session_lock and the work rechecks it
under the same lock before it touches the session, and the one thing left
to wait for - a work on its way out of that check - is waited for in
iscsit_close_session() before the session is freed, unless it is that work
itself and can_sleep is false.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Fixes: 80647a89eaf3f2 ("scsi: target: core: Release SPC-2 reservations when closing a session")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target.c       | 11 +++++++++--
 drivers/target/iscsi/iscsi_target_erl0.c  | 12 ++++++------
 drivers/target/iscsi/iscsi_target_erl0.h  |  2 +-
 drivers/target/iscsi/iscsi_target_login.c |  4 ++--
 include/target/iscsi/iscsi_target_core.h  |  3 ++-
 5 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e759..2cb9eb6711e739 100644
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
@@ -4535,6 +4535,13 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	/*
+	 * Wait for a Time2Retain work that was cancelled after it started
+	 * running; can_sleep is false only when that work is the caller.
+	 */
+	if (can_sleep)
+		cancel_delayed_work_sync(&sess->time2retain_work);
+
 	kfree(sess);
 	return 0;
 }
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 24db6b07493e62..9db833f3eeaec2 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -741,10 +741,10 @@ int iscsit_check_post_dataout(
 	}
 }
 
-void iscsit_handle_time2retain_timeout(struct timer_list *t)
+void iscsit_handle_time2retain_timeout(struct work_struct *work)
 {
-	struct iscsit_session *sess = timer_container_of(sess, t,
-							 time2retain_timer);
+	struct iscsit_session *sess = container_of(work, struct iscsit_session,
+						   time2retain_work.work);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
@@ -791,8 +791,8 @@ void iscsit_start_time2retain_handler(struct iscsit_session *sess)
 
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
 	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
-	mod_timer(&sess->time2retain_timer,
-		  jiffies + sess->sess_ops->DefaultTime2Retain * HZ);
+	mod_delayed_work(system_dfl_wq, &sess->time2retain_work,
+			 sess->sess_ops->DefaultTime2Retain * HZ);
 }
 
 int iscsit_stop_time2retain_timer(struct iscsit_session *sess)
@@ -811,7 +811,7 @@ int iscsit_stop_time2retain_timer(struct iscsit_session *sess)
 	sess->time2retain_timer_flags |= ISCSI_TF_STOP;
 	spin_unlock(&se_tpg->session_lock);
 
-	timer_delete_sync(&sess->time2retain_timer);
+	cancel_delayed_work(&sess->time2retain_work);
 
 	spin_lock(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 2a877d13977d24..66d5cb779aa8a1 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -12,7 +12,7 @@ extern void iscsit_set_dataout_sequence_values(struct iscsit_cmd *);
 extern int iscsit_check_pre_dataout(struct iscsit_cmd *, unsigned char *);
 extern int iscsit_check_post_dataout(struct iscsit_cmd *, unsigned char *, u8);
 extern void iscsit_start_time2retain_handler(struct iscsit_session *);
-extern void iscsit_handle_time2retain_timeout(struct timer_list *t);
+void iscsit_handle_time2retain_timeout(struct work_struct *work);
 extern int iscsit_stop_time2retain_timer(struct iscsit_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsit_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsit_conn *, int);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029684..c1e7891365ad45 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -248,8 +248,8 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
-	timer_setup(&sess->time2retain_timer,
-		    iscsit_handle_time2retain_timeout, 0);
+	INIT_DELAYED_WORK(&sess->time2retain_work,
+			  iscsit_handle_time2retain_timeout);
 
 	ret = ida_alloc(&sess_ida, GFP_KERNEL);
 	if (ret < 0) {
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 51ca80abacf7ba..486e1c1528c61d 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/socket.h>            /* struct sockaddr_storage */
 #include <linux/types.h>             /* u8 */
+#include <linux/workqueue.h>         /* struct delayed_work */
 #include <scsi/iscsi_proto.h>        /* itt_t */
 #include <target/target_core_base.h> /* struct se_cmd */
 
@@ -681,7 +682,7 @@ struct iscsit_session {
 	struct completion	reinstatement_comp;
 	struct completion	session_wait_comp;
 	struct completion	session_waiting_on_uc_comp;
-	struct timer_list	time2retain_timer;
+	struct delayed_work	time2retain_work;
 	struct iscsi_sess_ops	*sess_ops;
 	struct se_session	*se_sess;
 	struct iscsi_portal_group *tpg;
-- 
2.43.0

