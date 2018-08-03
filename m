From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 03 Aug 2018 08:48:00 +0000
Subject: [PATCH RESEND v2] target: move the rx hdr buffer out of the stack
Message-Id: <1533286080-13099-1-git-send-email-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When HeaderDigest is enabled on aarch64 machines, target triggers
a lot of failed crc checksum errors:

example of output in dmesg:
[  154.495031] HeaderDigest CRC32C failed, received 0x60571c8d, computed 0x288c3ab9
[  154.583821] Got unknown iSCSI OpCode: 0xff
[  162.979857] HeaderDigest CRC32C failed, received 0x0712e57c, computed 0x288c3ab9
...

The problem is that the iscsit_get_rx_pdu() function uses
a stack buffer as input for the scatterlist crypto library.
This should be avoided on kernels >= 4.9 because stack buffers
may not be directly mappable to struct page when the
CONFIG_VMAP_STACK option is enabled.

This patch modifies the code so the buffer will be allocated on the heap
and adds a pointer to it in the iscsi_conn structure.

v2: allocate conn_rx_buf in iscsi_target_login_thread()
    and fix a memory leak

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |  6 +++++-
 drivers/target/iscsi/iscsi_target_login.c | 15 +++++++++++++++
 include/target/iscsi/iscsi_target_core.h  |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8e22379..149fa91 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3913,10 +3913,12 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
 static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
 {
 	int ret;
-	u8 buffer[ISCSI_HDR_LEN], opcode;
+	u8 *buffer, opcode;
 	u32 checksum = 0, digest = 0;
 	struct kvec iov;
 
+	buffer = conn->conn_rx_buf;
+
 	while (!kthread_should_stop()) {
 		/*
 		 * Ensure that both TX and RX per connection kthreads
@@ -4211,6 +4213,8 @@ int iscsit_close_connection(
 		crypto_free_ahash(tfm);
 	}
 
+	kfree(conn->conn_rx_buf);
+
 	free_cpumask_var(conn->conn_cpumask);
 
 	kfree(conn->conn_ops);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 9950178..4e8974a5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1203,6 +1203,8 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		crypto_free_ahash(tfm);
 	}
 
+	kfree(conn->conn_rx_buf);
+
 	free_cpumask_var(conn->conn_cpumask);
 
 	kfree(conn->conn_ops);
@@ -1262,6 +1264,15 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		/* Get another socket */
 		return 1;
 	}
+
+	/* Allocate buffer for iscsit_get_rx_pdu() */
+	conn->conn_rx_buf = kmalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!conn->conn_rx_buf) {
+		pr_err("Could not allocate memory for conn_rx_buf\n");
+		kfree(conn);
+		return 1;
+	}
+
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 
@@ -1270,6 +1281,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
 
 	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
+		kfree(conn->conn_rx_buf);
 		kfree(conn);
 		return 1;
 	}
@@ -1278,6 +1290,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	if (rc = -ENOSYS) {
 		complete(&np->np_restart_comp);
 		iscsit_put_transport(conn->conn_transport);
+		kfree(conn->conn_rx_buf);
 		kfree(conn);
 		conn = NULL;
 		goto exit;
@@ -1288,6 +1301,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			spin_unlock_bh(&np->np_thread_lock);
 			complete(&np->np_restart_comp);
 			iscsit_put_transport(conn->conn_transport);
+			kfree(conn->conn_rx_buf);
 			kfree(conn);
 			conn = NULL;
 			/* Get another socket */
@@ -1295,6 +1309,7 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		}
 		spin_unlock_bh(&np->np_thread_lock);
 		iscsit_put_transport(conn->conn_transport);
+		kfree(conn->conn_rx_buf);
 		kfree(conn);
 		conn = NULL;
 		goto out;
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index cf5f3ff..3e9c525 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -584,6 +584,8 @@ struct iscsi_conn {
 	/* libcrypto RX and TX contexts for crc32c */
 	struct ahash_request	*conn_rx_hash;
 	struct ahash_request	*conn_tx_hash;
+	/* Used as buffer for iscsit_get_rx_pdu */
+	u8			*conn_rx_buf;
 	/* Used for scheduling TX and RX connection kthreads */
 	cpumask_var_t		conn_cpumask;
 	unsigned int		conn_rx_reset_cpumask:1;
-- 
1.8.3.1

