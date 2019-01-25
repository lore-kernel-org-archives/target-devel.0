From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:58 +0000
Subject: [PATCH 16/16] target/iscsi: Simplify iscsit_handle_text_cmd()
Message-Id: <20190125183458.220477-17-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Treat text_in and padding as a single buffer instead of two
buffers.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 408d77eb717c..e14ac29209c8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2240,28 +2240,25 @@ iscsit_handle_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	rx_size = payload_length;
 	if (payload_length) {
 		u32 checksum = 0, data_crc = 0;
-		u32 padding = 0, pad_bytes = 0;
+		u32 padding = 0;
 		int niov = 0, rx_got;
-		struct kvec iov[3];
+		struct kvec iov[2];
 
-		text_in = kzalloc(payload_length, GFP_KERNEL);
+		rx_size = ALIGN(payload_length, 4);
+		text_in = kzalloc(rx_size, GFP_KERNEL);
 		if (!text_in)
 			goto reject;
 
 		cmd->text_in_ptr = text_in;
 
-		memset(iov, 0, 3 * sizeof(struct kvec));
+		memset(iov, 0, sizeof(iov));
 		iov[niov].iov_base	= text_in;
-		iov[niov++].iov_len	= payload_length;
+		iov[niov++].iov_len	= rx_size;
 
-		padding = ((-payload_length) & 3);
-		if (padding != 0) {
-			iov[niov].iov_base = &pad_bytes;
-			iov[niov++].iov_len  = padding;
-			rx_size += padding;
+		padding = rx_size - payload_length;
+		if (padding)
 			pr_debug("Receiving %u additional bytes"
 					" for padding.\n", padding);
-		}
 		if (conn->conn_ops->DataDigest) {
 			iov[niov].iov_base	= &checksum;
 			iov[niov++].iov_len	= ISCSI_CRC_LEN;
@@ -2273,9 +2270,9 @@ iscsit_handle_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			goto reject;
 
 		if (conn->conn_ops->DataDigest) {
-			iscsit_do_crypto_hash_buf(conn->conn_rx_hash, text_in,
-						  payload_length, padding,
-						  &pad_bytes, &data_crc);
+			iscsit_do_crypto_hash_buf(conn->conn_rx_hash,
+						  text_in, rx_size, 0, NULL,
+						  &data_crc);
 
 			if (checksum != data_crc) {
 				pr_err("Text data CRC32C DataDigest"
-- 
2.20.1.495.gaa96b0ce6b-goog
