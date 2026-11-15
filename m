Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739237;
	b=iWu/A8iUDEiKQYbxlT2Olw4zkniBE8M9NAkgMTCovzCCHWYCk/z+62mlx61z+o83vsDZ
	 T49ETdLuCbTsuxSEc1dBapcthM6dzfJzmLHJDKfA1mfC8VUyQw4YMClTh2dwh1I2R0InU
	 XbPdMu2uVeKcWq/d1G1PdHWD7dKUj4EZJSql5eE2BSM/9/urNqf2udpHoS5UomYOKwxJD
	 sOgrKl/3ehswwXAygmVpoq7nOhlBJ1voN3TZ8Ur05iJFmTAGVNqop0NlA6iZFCv/dKuIc
	 AMkRq3CYN53rvfDKbtuxLiKMSw/SbWfqE0xK0EDXfdTkvhhIrb4y2ha6LVzlrbtrV2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/1IWe8gInvdcuTWrTU6z/g4cIXLgMuNATfLiV9YVy2E=;
	b=16NAD0xBocuRleJkKHVqjfiLwjiVnhUHODjt2IhLJRbnFVOY2JSIPGQLPDy2q8XV1W/t
	 YougmJdDk4YNvtHhs9m8i8TxTaXOKDkMfiVAbAEVBZtRP3wUZNpEYtJ5fHzqf8/6PeLX5
	 A0GRWkVosOEfr/S0ctkUTJzNLYl/7MibTW/bK7p9s+CPzjfP5NHyvsQySVeRrrqIE21UD
	 wowN6uWFc1j0jqwCYN1P8O+JNJlYEYGV+ttdUdXy7OgdfoPy4AL5QSy7XHhdSMv8eRZRo
	 Ok5mO0indQ+5VsqQivQokcgMEenFaeaPCCmIpb4oYwu8S47wwTqe/2OFgwQYAmrnXVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDnUNxt4;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCB606A891
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 10:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51CCB606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDnUNxt4
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ed06b725fdso23746855ad.0
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 02:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739237; x=1795344037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1IWe8gInvdcuTWrTU6z/g4cIXLgMuNATfLiV9YVy2E=;
        b=bDnUNxt42MdUo2Zb7O3parBP6QMgnfGLe6YXHTjpJsRspFxZCnpuf83r66u7yrijlm
         9dC9mpJPJlCavJ3ol0iy5DkMTH6GjUTCkQnp1it0HWW2CFsR4LnDKgaKjJeOZBHHEwtq
         9/iodWhctkEkGuPTc+D5vwIX/9DwDKGRjmTMRzqs2aUtj+ISZcPOD/3gzCl/i/pcf7iL
         n34Mu9MLjgQU+A2fmFDZCz1QPt23LEDapIbUELpxyaAad6esSyE72ksv3LAy2ZgqRUhm
         wPJ7DCijhfP7zkbGF7hZ7y3Uq0v9v5WVzh0DKXj5YHroojhYt2iTReytLhw+2rV39vI9
         qo1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739237; x=1795344037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/1IWe8gInvdcuTWrTU6z/g4cIXLgMuNATfLiV9YVy2E=;
        b=xxnYnLiLggsO/CYU+PWpxorVnHJF9LfdeQ+ea1l41iwqB2eLChIBwY0/tRiil0+eTV
         YB+7lytTNHms6lmvoLWqRkuQlFwxeXc8233LmaddVEaOUO9I0mFe6pAzrgUyS1aD8dpw
         S2HUX5ympgJjqTGkc3Kw/0WfKNoS4D3bpuFMLW56sRdv8/dXZ1XBT7xpSEZfzRUWFw4H
         PezcCT/Ng+mK42FFelSLAtg6tsU+BuZYwi/geLxdKrKQaDh8cAUPQ9buJ5ynpZtjt+ZT
         T63fO2vhCOiH8PUu4Mm7epoUKcNYeq1VVrHSz0kmXEFUAqTzyHYLdacgvGV0nUn/X2CM
         vdGQ==
X-Forwarded-Encrypted: i=1; AL+hErE0bkbNHhosxCEyoizMIFbWz7HzcBnwSvT4AKVxAncem31wmJbskEfPmUEI99Zr21oG1nnlvv/9dts30+k=@vger.kernel.org
X-Gm-Message-State: APuU4Z8mH+f8Pf7XEQwLc67gHhCvXaPUv4t11KtA/GvKivLj2vYuYnE5
	j45Mr0lP8gC0QNUfip6m04+qI6yBZi3DCSXLjePIM1DcKSWr6qULnQS4
X-Gm-Gg: AYBFou2uBF6W8LVkLshaTlwXm3FrxApDLPQ0lykAXWS62OLY4yJ4eqZuOvLgAV4FIml
	txfWBd+JDcJKTBLKDH6JvdYWYmuIlC+xxcnhj0TLGvQlF7jv5XqenTrpMEOKbI9OAXsJ8/DtjIq
	Zq+riypDiRk+QWDTeIAp58tG1DD7O7OpwGfX5j3LSk/RaTYq0N1ji6WvzhBSj4T1yaraJbldYh3
	YsaS3VTqDH+x0NjIlSs0c4JdGeH3UqKqp7sci44x364Uxy7//YzfNXAe6z2/gHp0kqEZXdEl9Yo
	HuSqJAORk1iE+4AOXZXKRNZXAwhX4GspVWOwa3iwZLdH4yT+jD0IFNZK4ZlGVtsLulpY/M6wC2p
	sk/4+6dZH4eF3H18b0eM3AZFN9EMCrc1YdN+ZxpsuERXkvNV59AvP1hKkHqUb7l2T92xucvvCfw
	wFf8Wj3h02GeeRYClpSKc4GPXFssFwqruUpqZ+v6JkwG4O5b+j9YfaRBthYWh9N0EK5yO70Dh2G
	U5Zo4SvdIf+QGKMshQSIQEB8ht7pb9x/i4+DWMMldIOOteDVsdi2iTvwLO7D03JONUnh4X0SCcp
	/diaAbJb8DbYQzuyhI1PWEkMb6vnvAh/VvlteQrNBCREMSZN7TEaSFdx5kovToBUvNv6OPNybYV
	hPjraxMVMwx+bL1FoJ1k2FlMD37CIdl3jP0BrJT6vBdp/uUGHytXMifWdH5K6khmeggVEZDPF2q
	C2C8w6w4Ho1UD73hJ2S4b48tArOqGBr0+UY9Jl8bE6co0wUgrKtfRtZ/KWbl6vmztS8ENv+fb8M
	dVZ61BASwP83jQ9IHSr/o0B0O8qzqosXnIHP5yZ4qpOedCLDk6axH1N0tMERqtc9w==
X-Received: by 2002:a17:903:f8c:b0:2e8:6540:11b6 with SMTP id d9443c01a7336-2ee0de633a5mr51336935ad.37.1794739236503;
        Sun, 15 Nov 2026 02:40:36 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:36 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: target: iscsi: don't attach a connection to a closing session
Date: Sun, 15 Nov 2026 21:10:06 +1030
Message-Id: <35c3a401f78f153f5f36cec7072c83da11902664.1794739041.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794739041.git.danjwade95@gmail.com>
References: <cover.1794739041.git.danjwade95@gmail.com>
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
branches already require it.  Set it in the ERL=0 fall-back branch too.

Re-test there everything iscsi_login_non_zero_tsih_s2() tested, not just
->session_close: iscsit_handle_time2retain_timeout() reaches
iscsit_close_session() with only ISCSI_TF_EXPIRED set, and the multi
connection ERL=0 path with only ->session_fall_back_to_erl0.  The timer
flag needs se_tpg->session_lock, which the zero_tsih path in this function
already holds across its own attach.

conn_state is published inside both attach critical sections instead of
up front.  At the gate the connection is therefore still
TARG_CONN_STATE_IN_LOGIN, so iscsi_target_tx_thread() leaves the cleanup
to this context rather than entering iscsit_close_connection() to wait on
a conn_usage_count the refusal is about to drop.  Every reader of
conn_state that walks sess_conn_list holds sess->conn_lock, so none
observes an attached connection that is not yet LOGGED_IN.

The refused connection is torn down here because its kthreads were started
before the final login response went out.

Tested on mainline with KASAN and lockdep: unpatched, the reproducer
produces the report above and then a general protection fault; with the
series applied the login is refused, it no longer triggers, lockdep is
silent and the target stays usable.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c       |  6 +++
 drivers/target/iscsi/iscsi_target_login.c | 56 +++++++++++++++++++++--
 2 files changed, 59 insertions(+), 3 deletions(-)

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
index f4df5518171..556ae5d2d50 100644
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
+	 * The login is refused before conn_state leaves
+	 * TARG_CONN_STATE_IN_LOGIN, so iscsi_target_tx_thread() still leaves
+	 * the cleanup to this context and cannot be inside
+	 * iscsit_close_connection() waiting on conn_usage_count.
+	 */
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
@@ -676,9 +703,6 @@ void iscsi_post_login_handler(
 	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_SUCCESS,
 			ISCSI_LOGIN_STATUS_ACCEPT);
 
-	pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
-	conn->conn_state = TARG_CONN_STATE_LOGGED_IN;
-
 	iscsi_set_connection_parameters(conn->conn_ops, conn->param_list);
 	/*
 	 * SCSI Initiator -> SCSI Target Port Mapping
@@ -689,7 +713,28 @@ void iscsi_post_login_handler(
 		iscsi_release_param_list(conn->param_list);
 		conn->param_list = NULL;
 
+		spin_lock_bh(&se_tpg->session_lock);
 		spin_lock_bh(&sess->conn_lock);
+		/*
+		 * iscsi_login_non_zero_tsih_s2() sampled these before the
+		 * negotiation and never looked again.  Re-test all of them under
+		 * the lock that serialises against the ->nconn test in
+		 * iscsit_close_connection(), and before this connection reaches
+		 * sess_conn_list or TARG_CONN_STATE_LOGGED_IN.
+		 */
+		if (atomic_read(&sess->session_close) ||
+		    atomic_read(&sess->session_fall_back_to_erl0) ||
+		    atomic_read(&sess->session_logout) ||
+		    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
+			spin_unlock_bh(&sess->conn_lock);
+			spin_unlock_bh(&se_tpg->session_lock);
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
@@ -707,7 +752,10 @@ void iscsi_post_login_handler(
 		pr_debug("Incremented iSCSI Connection count to %d"
 			" from node: %s\n", atomic_read(&sess->nconn),
 			sess->sess_ops->InitiatorName);
+		pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
+		conn->conn_state = TARG_CONN_STATE_LOGGED_IN;
 		spin_unlock_bh(&sess->conn_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 
 		iscsi_post_login_start_timers(conn);
 		/*
@@ -755,6 +803,8 @@ void iscsi_post_login_handler(
 	pr_debug("Incremented iSCSI Connection count to %d from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
+	pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
+	conn->conn_state = TARG_CONN_STATE_LOGGED_IN;
 	spin_unlock_bh(&sess->conn_lock);
 
 	sess->sid = tpg->sid++;
-- 
2.39.0.windows.2

