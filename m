From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 02 Feb 2018 14:15:54 +0000
Subject: [PATCH] target: move the rx hdr buffer out of the stack
Message-Id: <1517580954-3329-1-git-send-email-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When HeaderDigest is enabled on aarch64 machines target triggers
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

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |  4 +++-
 drivers/target/iscsi/iscsi_target_login.c | 28 +++++++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h  |  1 +
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9eb10d3..a3feb9e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3937,10 +3937,12 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
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
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 64c5a57..11aadeb 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -129,28 +129,41 @@ int iscsi_login_setup_crypto(struct iscsi_conn *conn)
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		pr_err("crypto_alloc_ahash() failed\n");
-		return -ENOMEM;
+		goto err_exit;
+	}
+
+	conn->conn_rx_buf = kmalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!conn->conn_rx_buf) {
+		pr_err("kmalloc() failed for conn_rx_buf\n");
+		goto err_free_ahash;
 	}
 
 	conn->conn_rx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!conn->conn_rx_hash) {
 		pr_err("ahash_request_alloc() failed for conn_rx_hash\n");
-		crypto_free_ahash(tfm);
-		return -ENOMEM;
+		goto err_free_rxbuf;
 	}
 	ahash_request_set_callback(conn->conn_rx_hash, 0, NULL, NULL);
 
 	conn->conn_tx_hash = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!conn->conn_tx_hash) {
 		pr_err("ahash_request_alloc() failed for conn_tx_hash\n");
-		ahash_request_free(conn->conn_rx_hash);
-		conn->conn_rx_hash = NULL;
-		crypto_free_ahash(tfm);
-		return -ENOMEM;
+		goto err_free_ahash_req;
 	}
 	ahash_request_set_callback(conn->conn_tx_hash, 0, NULL, NULL);
 
 	return 0;
+
+err_free_ahash_req:
+	ahash_request_free(conn->conn_rx_hash);
+	conn->conn_rx_hash = NULL;
+err_free_rxbuf:
+	kfree(conn->conn_rx_buf);
+	conn->conn_rx_buf = NULL;
+err_free_ahash:
+	crypto_free_ahash(tfm);
+err_exit:
+	return -ENOMEM;
 }
 
 static int iscsi_login_check_initiator_version(
@@ -1202,6 +1215,7 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		ahash_request_free(conn->conn_rx_hash);
 		crypto_free_ahash(tfm);
 	}
+	kfree(conn->conn_rx_buf);
 
 	free_cpumask_var(conn->conn_cpumask);
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index cf5f3ff..70ecbb7 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -584,6 +584,7 @@ struct iscsi_conn {
 	/* libcrypto RX and TX contexts for crc32c */
 	struct ahash_request	*conn_rx_hash;
 	struct ahash_request	*conn_tx_hash;
+	u8			*conn_rx_buf;
 	/* Used for scheduling TX and RX connection kthreads */
 	cpumask_var_t		conn_cpumask;
 	unsigned int		conn_rx_reset_cpumask:1;
-- 
Maurizio Lombardi

