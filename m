From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:13 +0000
Subject: [PATCH 09/11] target/iscsi: Handle too large immediate data buffers correctly
Message-Id: <20190402195815.254796-10-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since target_alloc_sgl() and iscsit_allocate_iovecs() allocate
buffer space for se_cmd.data_length bytes and since that number
can be smaller than the iSCSI Expected Data Transfer Length
(EDTL), ensure that the iSCSI target driver does not attempt to
receive more bytes than what fits in the receive buffer. Always
receive the full immediate data buffer such that the iSCSI target
driver does not attempt to parse immediate data as an iSCSI PDU.

Note: the current code base only calls iscsit_get_dataout() if
the size of the immediate data buffer does not exceed the buffer
size derived from the SCSI CDB. See also target_cmd_size_check().

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c      | 27 +++++++++++++++++++++---
 drivers/target/iscsi/iscsi_target_util.c |  1 +
 include/target/iscsi/iscsi_target_core.h |  1 +
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 828697015759..8cdea25f1377 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1568,9 +1568,11 @@ iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 {
 	struct kvec *iov;
 	u32 checksum, iov_count = 0, padding = 0, rx_got = 0, rx_size = 0;
-	u32 payload_length = ntoh24(hdr->dlength);
+	u32 payload_length;
 	int iov_ret, data_crc_failed = 0;
 
+	payload_length = min_t(u32, cmd->se_cmd.data_length,
+			       ntoh24(hdr->dlength));
 	rx_size += payload_length;
 	iov = &cmd->iov_data[0];
 
@@ -2575,14 +2577,33 @@ static int iscsit_handle_immediate_data(
 	u32 checksum, iov_count = 0, padding = 0;
 	struct iscsi_conn *conn = cmd->conn;
 	struct kvec *iov;
+	void *overflow_buf = NULL;
 
-	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data, cmd->write_data_done, length);
+	BUG_ON(cmd->write_data_done > cmd->se_cmd.data_length);
+	rx_size = min(cmd->se_cmd.data_length - cmd->write_data_done, length);
+	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data, cmd->write_data_done,
+				   rx_size);
 	if (iov_ret < 0)
 		return IMMEDIATE_DATA_CANNOT_RECOVER;
 
-	rx_size = length;
 	iov_count = iov_ret;
 	iov = &cmd->iov_data[0];
+	if (rx_size < length) {
+		/*
+		 * Special case: length of immediate data exceeds the data
+		 * buffer size derived from the CDB.
+		 */
+		overflow_buf = kmalloc(length - rx_size, GFP_KERNEL);
+		if (!overflow_buf) {
+			iscsit_unmap_iovec(cmd);
+			return IMMEDIATE_DATA_CANNOT_RECOVER;
+		}
+		cmd->overflow_buf = overflow_buf;
+		iov[iov_count].iov_base = overflow_buf;
+		iov[iov_count].iov_len = length - rx_size;
+		iov_count++;
+		rx_size = length;
+	}
 
 	padding = ((-length) & 3);
 	if (padding != 0) {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5b26bc23016a..fae85bfd790e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -737,6 +737,7 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->pdu_list);
 	kfree(cmd->seq_list);
 	kfree(cmd->tmr_req);
+	kfree(cmd->overflow_buf);
 	kfree(cmd->iov_data);
 	kfree(cmd->text_in_ptr);
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 24c398f4a68f..a49d37140a64 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -473,6 +473,7 @@ struct iscsi_cmd {
 	struct timer_list	dataout_timer;
 	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
 	struct kvec		*iov_data;
+	void			*overflow_buf;
 	/* Iovecs for miscellaneous purposes */
 #define ISCSI_MISC_IOVECS			5
 	struct kvec		iov_misc[ISCSI_MISC_IOVECS];
-- 
2.21.0.196.g041f5ea1cf98
