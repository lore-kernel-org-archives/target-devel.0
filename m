From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:57 +0000
Subject: [PATCH 15/16] target/iscsi: Simplify iscsit_dump_data_payload()
Message-Id: <20190125183458.220477-16-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use a single loop to dump immediate data, padding and digest
instead of using separate rx_data() calls for each type of data.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 41 ++++++------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index c27335c29640..e02e1aaf63c5 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -48,14 +48,20 @@ int iscsit_dump_data_payload(
 	u32 buf_len,
 	int dump_padding_digest)
 {
-	char *buf, pad_bytes[4];
+	char *buf;
 	int ret = DATAOUT_WITHIN_COMMAND_RECOVERY, rx_got;
-	u32 length, padding, offset = 0, size;
+	u32 length, offset = 0, size;
 	struct kvec iov;
 
 	if (conn->sess->sess_ops->RDMAExtensions)
 		return 0;
 
+	if (dump_padding_digest) {
+		buf_len = ALIGN(buf_len, 4);
+		if (conn->conn_ops->DataDigest)
+			buf_len += ISCSI_CRC_LEN;
+	}
+
 	length = min(buf_len, OFFLOAD_BUF_SIZE);
 
 	buf = kzalloc(length, GFP_ATOMIC);
@@ -75,41 +81,12 @@ int iscsit_dump_data_payload(
 		rx_got = rx_data(conn, &iov, 1, size);
 		if (rx_got != size) {
 			ret = DATAOUT_CANNOT_RECOVER;
-			goto out;
+			break;
 		}
 
 		offset += size;
 	}
 
-	if (!dump_padding_digest)
-		goto out;
-
-	padding = ((-buf_len) & 3);
-	if (padding != 0) {
-		iov.iov_len = padding;
-		iov.iov_base = pad_bytes;
-
-		rx_got = rx_data(conn, &iov, 1, padding);
-		if (rx_got != padding) {
-			ret = DATAOUT_CANNOT_RECOVER;
-			goto out;
-		}
-	}
-
-	if (conn->conn_ops->DataDigest) {
-		u32 data_crc;
-
-		iov.iov_len = ISCSI_CRC_LEN;
-		iov.iov_base = &data_crc;
-
-		rx_got = rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
-		if (rx_got != ISCSI_CRC_LEN) {
-			ret = DATAOUT_CANNOT_RECOVER;
-			goto out;
-		}
-	}
-
-out:
 	kfree(buf);
 	return ret;
 }
-- 
2.20.1.495.gaa96b0ce6b-goog
