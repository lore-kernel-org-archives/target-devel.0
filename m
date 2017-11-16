From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:17 +0000
Subject: [PATCH-4.1.y 5/7] iscsi-target: Always wait for kthread_should_stop() before kthread exit
Message-Id: <1510812859-15101-6-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Jiang Yi <jiangyilism@gmail.com>

From: Jiang Yi <jiangyilism@gmail.com>

commit 5e0cf5e6c43b9e19fc0284f69e5cd2b4a47523b0 upstream.

There are three timing problems in the kthread usages of iscsi_target_mod:

 - np_thread of struct iscsi_np
 - rx_thread and tx_thread of struct iscsi_conn

In iscsit_close_connection(), it calls

 send_sig(SIGINT, conn->tx_thread, 1);
 kthread_stop(conn->tx_thread);

In conn->tx_thread, which is iscsi_target_tx_thread(), when it receive
SIGINT the kthread will exit without checking the return value of
kthread_should_stop().

So if iscsi_target_tx_thread() exit right between send_sig(SIGINT...)
and kthread_stop(...), the kthread_stop() will try to stop an already
stopped kthread.

This is invalid according to the documentation of kthread_stop().

(Fix -ECONNRESET logout handling in iscsi_target_tx_thread and
 early iscsi_target_rx_thread failure case - nab)

Signed-off-by: Jiang Yi <jiangyilism@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c       | 28 ++++++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_erl0.c  |  6 +++++-
 drivers/target/iscsi/iscsi_target_erl0.h  |  2 +-
 drivers/target/iscsi/iscsi_target_login.c |  4 ++++
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index ee24b76..89d0194 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3964,6 +3964,8 @@ int iscsi_target_tx_thread(void *arg)
 {
 	int ret = 0;
 	struct iscsi_conn *conn = arg;
+	bool conn_freed = false;
+
 	/*
 	 * Allow ourselves to be interrupted by SIGINT so that a
 	 * connection recovery / failure event can be triggered externally.
@@ -3989,12 +3991,14 @@ get_immediate:
 			goto transport_err;
 
 		ret = iscsit_handle_response_queue(conn);
-		if (ret = 1)
+		if (ret = 1) {
 			goto get_immediate;
-		else if (ret = -ECONNRESET)
+		} else if (ret = -ECONNRESET) {
+			conn_freed = true;
 			goto out;
-		else if (ret < 0)
+		} else if (ret < 0) {
 			goto transport_err;
+		}
 	}
 
 transport_err:
@@ -4004,8 +4008,13 @@ transport_err:
 	 * responsible for cleaning up the early connection failure.
 	 */
 	if (conn->conn_state != TARG_CONN_STATE_IN_LOGIN)
-		iscsit_take_action_for_connection_exit(conn);
+		iscsit_take_action_for_connection_exit(conn, &conn_freed);
 out:
+	if (!conn_freed) {
+		while (!kthread_should_stop()) {
+			msleep(100);
+		}
+	}
 	return 0;
 }
 
@@ -4112,6 +4121,7 @@ int iscsi_target_rx_thread(void *arg)
 	u32 checksum = 0, digest = 0;
 	struct iscsi_conn *conn = arg;
 	struct kvec iov;
+	bool conn_freed = false;
 	/*
 	 * Allow ourselves to be interrupted by SIGINT so that a
 	 * connection recovery / failure event can be triggered externally.
@@ -4123,7 +4133,7 @@ int iscsi_target_rx_thread(void *arg)
 	 */
 	rc = wait_for_completion_interruptible(&conn->rx_login_comp);
 	if (rc < 0 || iscsi_target_check_conn_state(conn))
-		return 0;
+		goto out;
 
 	if (conn->conn_transport->transport_type = ISCSI_INFINIBAND) {
 		struct completion comp;
@@ -4208,7 +4218,13 @@ int iscsi_target_rx_thread(void *arg)
 transport_err:
 	if (!signal_pending(current))
 		atomic_set(&conn->transport_failed, 1);
-	iscsit_take_action_for_connection_exit(conn);
+	iscsit_take_action_for_connection_exit(conn, &conn_freed);
+out:
+	if (!conn_freed) {
+		while (!kthread_should_stop()) {
+			msleep(100);
+		}
+	}
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 959a14c..6011644 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -930,8 +930,10 @@ static void iscsit_handle_connection_cleanup(struct iscsi_conn *conn)
 	}
 }
 
-void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn)
+void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn, bool *conn_freed)
 {
+	*conn_freed = false;
+
 	spin_lock_bh(&conn->state_lock);
 	if (atomic_read(&conn->connection_exit)) {
 		spin_unlock_bh(&conn->state_lock);
@@ -942,6 +944,7 @@ void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn)
 	if (conn->conn_state = TARG_CONN_STATE_IN_LOGOUT) {
 		spin_unlock_bh(&conn->state_lock);
 		iscsit_close_connection(conn);
+		*conn_freed = true;
 		return;
 	}
 
@@ -955,6 +958,7 @@ void iscsit_take_action_for_connection_exit(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->state_lock);
 
 	iscsit_handle_connection_cleanup(conn);
+	*conn_freed = true;
 }
 
 /*
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 21acc9a..42673fb 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -9,7 +9,7 @@ extern int iscsit_stop_time2retain_timer(struct iscsi_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsi_conn *, int);
 extern void iscsit_fall_back_to_erl0(struct iscsi_session *);
-extern void iscsit_take_action_for_connection_exit(struct iscsi_conn *);
+extern void iscsit_take_action_for_connection_exit(struct iscsi_conn *, bool *);
 extern int iscsit_recover_from_unknown_opcode(struct iscsi_conn *);
 
 #endif   /*** ISCSI_TARGET_ERL0_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index ee3a4bb..0e75ea8 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1510,5 +1510,9 @@ int iscsi_target_login_thread(void *arg)
 			break;
 	}
 
+	while (!kthread_should_stop()) {
+		msleep(100);
+	}
+
 	return 0;
 }
-- 
1.8.5.3

