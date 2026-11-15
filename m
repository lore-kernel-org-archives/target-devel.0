Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733171;
	b=gS1Zw1SIvdeRQTeXgdC3WzNRu4kb0/RZqVzdEjH8W6mFsJjBk1QY7eTnUDegvyhg4XAy
	 0NE+ggRISxE2l+TtPKztA8AOFOMvgVHNRJaJzk8NQcspXOh+iyrJj1f0FHkADcT73AYxL
	 WTqyQIzPwGTExC/6MpBMwRHGqvA+8utFff3v1C5NYEeW8uX4PHArcl6PpUDTLoFWiCHix
	 g6Q1iY0ouljaeYj2CY5gR4vgWznK5ylP0EugE/g0a6Kn9bjvZYKu5VdkqkcYsRgmDSqlW
	 TwMK5Ax+7EUiIBJnrh6ZNKFPYVaJh4BrnuGUEsPFMPgLTDLrazT7DaoiQ4GQ6sbuYYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733171;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
	b=Ny3bEZrPYdTKrndQ+GcbYL7mCnTgPcko9nePvXwSJ1mVagY3aoErxoMBD0F0DSlI8uzC
	 l4dnTAgwSWS+cWr/IwIqiqiLbivX4SrPIAyUt0JixwbHBcu4QzLElUmSgXtbomAdxjhjX
	 b2QImrRZHz1OxWsG3KTmrszE8jiKhR3662pIrTQJHXiFzEgnlBx74uERYC5BEUXqkDXaV
	 idSTQJgEqxS/fnzIORo/GSnDosHhq1jo/WuaopSvaLxxoECEZ5FD1AI5RrSENcJ69jo4v
	 t84O9EEI8Gip+x9FjQm2C/jRJ8ygV6d6tGN1aXrFoRLM1B0G/WeOc/2i535wpANDnvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i90xKGzE;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B938A606A31A
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 08:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B938A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i90xKGzE
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so908761a12.3
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733170; x=1795337970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
        b=i90xKGzE+Tp3hLUZQfiRTmtiGnVbak69A05wCd0MR5g4YSOFoo/9aGCDiFrYikMGuD
         lMBogwWW6V1oVGLg62FWVoooUkgxiPsZApgVtNa94uR66gDwyM8qJlsCFxUizEss9QQk
         4UwUFhT66nYMW7nVdU3EzpHMf6YsjPXp4yhynHqStlVFZq5U43pXyyPy3Qi0qGX4pIGi
         8uHI2kOgGPfOLj2Mctz/wxU9WBmAL7AVJnaYiwtq+NlFpNEheooJY9aDZYaXtAdEexuJ
         6QdVzCrxMg+M+QDsOKyhXcbZlxZmAtNdy/LcDY8h7zZ1DDEQwPi+GVzAfL5GwN4IvxG+
         14xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733170; x=1795337970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RetYn0BIqzHeFHXhT42j9H/gxZJ9ddxXCM6J09DUuKI=;
        b=j1s1hINqZVeulaAKMm8aWJI3/UzsQQS7gtdtur95/BG2VSJm0P3UuskOaXkm5OM3fZ
         2nps9l4TABa5Qyi768TDTe9+3TxzLW2FTTa8mFtgovh2/kf+rCaa7q0dhSNnthgtRmcj
         scVQ30Bpf6pF6IcYa3Y7AiHMmUHrtrONalaxPp6f0/8Wma3gNuE5zXTifQgBkHzWFs3V
         Obt9b895kqiDmypfj9ct8bncn36IHd5QrMwo/EmqRPnffZJE/YK+LWvA2WkVTatOhH4Q
         ZDY6EX+DIMUdzuJ2qGVDG1Or3O7n8ULGv/ixeA/LotrkgtYcIsdBcV1YtxIPp8nMFiWV
         +w4Q==
X-Forwarded-Encrypted: i=1; AL+hErHOCsplhvlvhI33HpVeanVjQQ4yKIVWi9oRkjnxIPIYk3nMZlL4pko8RZxA8+zXaFst+9XxXBxSOVCJ5Ik=@vger.kernel.org
X-Gm-Message-State: APuU4Z8SKbOF81JpW6O+MPvMO6EeeeGqJ94pxemUysGCjyMn6PmzqaYn
	6KYKqNIQ/dycps+FHk+UIkC7MtGNUm8efoAlny9DQngqV4NKhQm8nyMF2jQQ/9L0eOfA08wc
X-Gm-Gg: AYBFou3qvtoHq5mhgeKgYM5hqg1esAeD3A4U79OfhOuWt5/E7HC0rvOpkDrmmTtpZhQ
	PqIicM87T4Um1iJCA3iKssmWNsg7alg49ReLhO/+I7o5MHik9wZ88OtUil2aHlIYBf6ApGaodNa
	0ZiQpgB8lgb70ReD0ETTiNvl8oaT1dV3+eTbriQejRy4L7gsWSsAOso9H/esCwuqm3+/QKrR01G
	/A1D0GaksPilt9RtV3eZ4G7MjFVO7S/MZj0UKfngG9fOJ16blGSkN6OPqh3hbMMkZGpqRdpnVgx
	Rx9Ls7sKUg36M7gD+oZiawdat3OcBgbwvvgfEIU9VBm3RhncP3ldy7PqBA55Bfb2iK3IzWyx2HS
	af6mFSRg/cMqTbgyvbz8loKI89zMjudKCa+/yysUHvzGiwPVmqJBN6k9WW7dheuxSIFjw+zAtBd
	I7VO70GBzBRuoqCXU0dtdPY4WK/s80A57KDlP8PFaFafvp8rJA4u1mQatcRUvH2pLouTExRczPb
	kE+qnqgR/M3EbZ8VGH56jWQRul6VU7gAmQbrSalUHcjwsb988KjPl6iZByCbe2AQlDooLigP9EH
	jQ0ziDPZzQ9GHStwbImRkOg9avNdEFTSgg2vdoFzC0ospkuaxyOlkH13CFpz8tDhvkU2UQKvEmM
	JGFOGrpI/ArpDfYY2JV+iDy4SsXP4kjBXKKzuvIAmtvLFFG4+kLIr83SmoTJBERWzlv3V41HPlO
	Oz665HCtRvUGxPNNQn5cDQ/J3RXShs7A8uKT5GCub3DsPohpkeGhn1Mmy5N08giz23snVlUAW4i
	MknIAPRnDoSaNC9ndFqa/3p5JqUvgFlyq+ZRZJS5NqMmXhc0omttWFLidpMNhksBnt21R4LgTEl
	mWmeR54xDg==
X-Received: by 2002:a17:90b:3f46:b0:3b1:8301:95c0 with SMTP id 98e67ed59e1d1-3b1b0b95db4mr5779358a91.61.1794733169887;
        Sun, 15 Nov 2026 00:59:29 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:29 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: target: iscsi: don't attach a connection to a closing session
Date: Sun, 15 Nov 2026 19:27:45 +1030
Message-Id: <3ae0ce68449390d9e3893e5328367c4db3818f96.1794732723.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794732723.git.danjwade95@gmail.com>
References: <cover.1794732723.git.danjwade95@gmail.com>
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

iscsi_login_non_zero_tsih_s2() finds a session on tpg_sess_list, skips it
if it is already marked for teardown, and takes a usage count it holds
across the whole login negotiation.  That skip is sampled once, before
the negotiation, and never re-evaluated.

If the session's last connection goes away while the login is still
negotiating, iscsit_close_connection() sees ->nconn reach zero, commits
to the free under ->conn_lock and calls iscsit_close_session(), which
sleeps in iscsit_check_session_usage_count() on the reference the login
holds.  iscsi_post_login_handler() then attaches the new connection,
arms its NOP-In timer and drops that reference, which is what releases the
free.  conn->sess is left dangling and the timer walks the freed session:

  BUG: KASAN: slab-use-after-free in iscsit_allocate_cmd+0x6de/0x780
   iscsit_handle_nopin_timeout <- call_timer_fn <- run_timer_softirq
  Freed by task ...: kfree <- iscsit_close_session
                     <- iscsit_close_connection
                     <- iscsit_take_action_for_connection_exit

MaxConnections does not prevent this.
iscsi_login_post_auth_non_zero_tsih() tests
(atomic_read(&sess->nconn) + 1) > MaxConnections after the reference is
taken, and ->nconn is 0 here, so (0 + 1) > 1 is false even at the
default of 1.

iscsit_close_connection() tests ->nconn under sess->conn_lock and
iscsi_post_login_handler() attaches under the same lock, so publishing the
close decision in that critical section and re-testing it in the one that
attaches makes the two mutually exclusive.  ->session_close is already
that flag: only ever set, never cleared, and the logout and explicit close
branches already require it.  Set it in the ERL=0 fall-back branch too and
refuse the login when it is set, dropping only the reference the login
took so iscsit_close_session() can finish the free it committed to.

The refused connection is torn down here because its kthreads were started
before the final login response went out.

Tested on mainline with KASAN: unpatched, the reproducer produces the
report above and then a general protection fault; with the series applied
the login is refused and it no longer triggers.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c       |  6 ++++
 drivers/target/iscsi/iscsi_target_login.c | 41 +++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e..ee7df7f2723 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4431,6 +4431,12 @@ int iscsit_close_connection(
 	 */
 	if (!atomic_read(&sess->session_reinstatement) &&
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
+		/*
+		 * Publish the close decision under ->conn_lock so a non-leading
+		 * login attaching in iscsi_post_login_handler() sees it.  The
+		 * branches below already require ->session_close.
+		 */
+		atomic_set(&sess->session_close, 1);
 		spin_unlock_bh(&sess->conn_lock);
 		complete_all(&sess->session_wait_comp);
 		iscsit_close_session(sess, true);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index f4df5518171..de0cd95aff0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -660,6 +660,33 @@ void iscsit_stop_kthreads(struct iscsit_conn *conn)
 	spin_unlock(&iscsit_global->ts_bitmap_lock);
 }
 
+/*
+ * Drop a connection whose kthreads are already running but that must not enter
+ * full feature phase.  conn->sess must not be touched once this returns.
+ */
+static void iscsi_post_login_fail_conn(struct iscsit_conn *conn)
+{
+	/*
+	 * iscsi_target_tx_thread() only leaves cleanup to this context while
+	 * conn_state is TARG_CONN_STATE_IN_LOGIN; otherwise it would reach
+	 * iscsit_close_connection() and walk the session being refused.
+	 */
+	conn->conn_state = TARG_CONN_STATE_IN_LOGIN;
+	iscsit_stop_kthreads(conn);
+	iscsit_dec_conn_usage_count(conn);
+
+	if (conn->sock) {
+		sock_release(conn->sock);
+		conn->sock = NULL;
+	}
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+	if (conn->conn_transport->iscsit_free_conn)
+		conn->conn_transport->iscsit_free_conn(conn);
+
+	iscsit_free_conn(conn);
+}
+
 void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsit_conn *conn,
@@ -690,6 +717,20 @@ void iscsi_post_login_handler(
 		conn->param_list = NULL;
 
 		spin_lock_bh(&sess->conn_lock);
+		/*
+		 * The skip filter in iscsi_login_non_zero_tsih_s2() sampled this
+		 * before the negotiation.  Re-test under the lock that serialises
+		 * against the ->nconn test in iscsit_close_connection().
+		 */
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			pr_err("iSCSI session is closing, failing login on CID: %u\n",
+			       conn->cid);
+			iscsi_post_login_fail_conn(conn);
+			/* Last access to @sess: this lets close_session() free it. */
+			iscsit_dec_session_usage_count(sess);
+			return;
+		}
 		atomic_set(&sess->session_continuation, 0);
 		if (sess->session_state == TARG_SESS_STATE_FAILED) {
 			pr_debug("Moving to"
-- 
2.39.0.windows.2

