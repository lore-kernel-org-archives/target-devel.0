From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:16 +0000
Subject: [PATCH 08/11] target/iscsi: Modify iscsit_do_crypto_hash_buf() prototype
Message-Id: <20171031180319.19258-9-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Change the type of the last two arguments from u8 * into const void *
and void * respectively such that the u8 * casts can be left out
from the callers. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 41 +++++++++++++++----------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 37bc8a37401d..91fbada7cdc2 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -500,7 +500,7 @@ void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 EXPORT_SYMBOL(iscsit_aborted_task);
 
 static void iscsit_do_crypto_hash_buf(struct ahash_request *, const void *,
-				      u32, u32, u8 *, u8 *);
+				      u32, u32, const void *, void *);
 static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *);
 
 static int
@@ -521,7 +521,7 @@ iscsit_xmit_nondatain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, hdr,
 					  ISCSI_HDR_LEN, 0, NULL,
-					  (u8 *)header_digest);
+					  header_digest);
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
@@ -548,9 +548,8 @@ iscsit_xmit_nondatain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		if (conn->conn_ops->DataDigest) {
 			iscsit_do_crypto_hash_buf(conn->conn_tx_hash,
 						  data_buf, data_buf_len,
-						  padding,
-						  (u8 *)&cmd->pad_bytes,
-						  (u8 *)&cmd->data_crc);
+						  padding, &cmd->pad_bytes,
+						  &cmd->data_crc);
 
 			iov[niov].iov_base = &cmd->data_crc;
 			iov[niov++].iov_len = ISCSI_CRC_LEN;
@@ -595,7 +594,7 @@ iscsit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 		iscsit_do_crypto_hash_buf(conn->conn_tx_hash, cmd->pdu,
 					  ISCSI_HDR_LEN, 0, NULL,
-					  (u8 *)header_digest);
+					  header_digest);
 
 		iov[0].iov_len += ISCSI_CRC_LEN;
 		tx_size += ISCSI_CRC_LEN;
@@ -1408,13 +1407,9 @@ static u32 iscsit_do_crypto_hash_sg(
 	return data_crc;
 }
 
-static void iscsit_do_crypto_hash_buf(
-	struct ahash_request *hash,
-	const void *buf,
-	u32 payload_length,
-	u32 padding,
-	u8 *pad_bytes,
-	u8 *data_crc)
+static void iscsit_do_crypto_hash_buf(struct ahash_request *hash,
+	const void *buf, u32 payload_length, u32 padding,
+	const void *pad_bytes, void *data_crc)
 {
 	struct scatterlist sg[2];
 
@@ -1876,10 +1871,9 @@ static int iscsit_handle_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		}
 
 		if (conn->conn_ops->DataDigest) {
-			iscsit_do_crypto_hash_buf(conn->conn_rx_hash,
-					ping_data, payload_length,
-					padding, cmd->pad_bytes,
-					(u8 *)&data_crc);
+			iscsit_do_crypto_hash_buf(conn->conn_rx_hash, ping_data,
+						  payload_length, padding,
+						  cmd->pad_bytes, &data_crc);
 
 			if (checksum != data_crc) {
 				pr_err("Ping data CRC32C DataDigest"
@@ -2285,10 +2279,9 @@ iscsit_handle_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			goto reject;
 
 		if (conn->conn_ops->DataDigest) {
-			iscsit_do_crypto_hash_buf(conn->conn_rx_hash,
-					text_in, payload_length,
-					padding, (u8 *)&pad_bytes,
-					(u8 *)&data_crc);
+			iscsit_do_crypto_hash_buf(conn->conn_rx_hash, text_in,
+						  payload_length, padding,
+						  &pad_bytes, &data_crc);
 
 			if (checksum != data_crc) {
 				pr_err("Text data CRC32C DataDigest"
@@ -3976,9 +3969,9 @@ static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
 				return;
 			}
 
-			iscsit_do_crypto_hash_buf(conn->conn_rx_hash,
-					buffer, ISCSI_HDR_LEN,
-					0, NULL, (u8 *)&checksum);
+			iscsit_do_crypto_hash_buf(conn->conn_rx_hash, buffer,
+						  ISCSI_HDR_LEN, 0, NULL,
+						  &checksum);
 
 			if (digest != checksum) {
 				pr_err("HeaderDigest CRC32C failed,"
-- 
2.14.2

