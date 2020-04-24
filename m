From: Hou Pu <houpu@bytedance.com>
Date: Fri, 24 Apr 2020 12:35:27 +0000
Subject: [PATCH v3 1/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <20200424123528.17627-2-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424123528.17627-1-houpu@bytedance.com>
In-Reply-To: <20200424123528.17627-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, Hou Pu <houpu@bytedance.com>

iscsi_target_sk_data_ready() could be invoked indirectly
by iscsi_target_do_login_rx() from workqueue like following:

iscsi_target_do_login_rx()
  iscsi_target_do_login()
    iscsi_target_do_tx_login_io()
      iscsit_put_login_tx()
        iscsi_login_tx_data()
          tx_data()
            sock_sendmsg_nosec()
              tcp_sendmsg()
                release_sock()
                  sk_backlog_rcv()
                    tcp_v4_do_rcv()
                      tcp_data_ready()
                        iscsi_target_sk_data_ready()

At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
and iscsi_target_sk_data_ready will not read data
from the socket. And some iscsi initiator(i.e. libiscsi)
will wait forever for a reply.

LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
doing the receive and before writing to the socket in
iscsi_target_do_login_rx.

But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
by sk_state_change to do login cleanup if a socket was closed
at login time. It is supposed to be cleared after the login
pdu is successfully processed and replied.

So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
the transmit part so that sk_state_change could work well
and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
could also work.

While at here, use login_flags more efficient.

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 30 ++++++++++++++++++++++++++----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771b51d4..4cfa742e61df 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0)
 		goto err;
 
+	/*
+	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
+	 * could be trigger again after this.
+	 *
+	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
+	 * process a login pdu, so that sk_state_chage could do login
+	 * cleanup as needed if the socket is closed. If a delayed work is
+	 * ongoing (LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
+	 * sk_state_change will leave the cleanup to the delayed work or
+	 * it will schedule a delayed work to do cleanup.
+	 */
+	if (conn->sock) {
+		struct sock *sk = conn->sock->sk;
+
+		write_lock_bh(&sk->sk_callback_lock);
+		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
+		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
+		write_unlock_bh(&sk->sk_callback_lock);
+	}
+
 	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
 			conn, current->comm, current->pid);
 
@@ -629,7 +649,8 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0) {
 		goto err;
 	} else if (!rc) {
-		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
+		if (iscsi_target_sk_check_and_clear(conn,
+						    LOGIN_FLAGS_WRITE_ACTIVE))
 			goto err;
 	} else if (rc = 1) {
 		iscsi_target_nego_release(conn);
@@ -670,9 +691,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	state = __iscsi_target_sk_check_close(sk);
 	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
 
-	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
-		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change"
-			 " conn: %p\n", conn);
+	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
+	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
+		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
+			 " sk_state_change conn: %p\n", conn);
 		if (state)
 			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 591cd9e4692c..844bef255e89 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -566,10 +566,11 @@ struct iscsi_conn {
 	struct socket		*sock;
 	void			(*orig_data_ready)(struct sock *);
 	void			(*orig_state_change)(struct sock *);
-#define LOGIN_FLAGS_READ_ACTIVE		1
-#define LOGIN_FLAGS_CLOSED		2
-#define LOGIN_FLAGS_READY		4
-#define LOGIN_FLAGS_INITIAL_PDU		8
+#define LOGIN_FLAGS_READY		0
+#define LOGIN_FLAGS_INITIAL_PDU		1
+#define LOGIN_FLAGS_READ_ACTIVE		2
+#define LOGIN_FLAGS_WRITE_ACTIVE	3
+#define LOGIN_FLAGS_CLOSED		4
 	unsigned long		login_flags;
 	struct delayed_work	login_work;
 	struct iscsi_login	*login;
-- 
2.11.0
