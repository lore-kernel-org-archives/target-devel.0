From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:14 +0000
Subject: [PATCH 10/11] target/iscsi: Make iscsit_map_iovec() more robust
Message-Id: <20190402195815.254796-11-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Make the code for mapping an iovec more robust by checking the
bounds of the allocated iovec. This patch avoids that the following
crash occurs if a map attempt is made that exceeds the bounds of
the iovec that is being mapped:

BUG: unable to handle kernel NULL pointer dereference at 00000000
00000014
RIP: 0010:iscsit_map_iovec+0x120/0x190 [iscsi_target_mod]
Call Trace:
 iscsit_get_rx_pdu+0x8a2/0xe00 [iscsi_target_mod]
 iscsi_target_rx_thread+0x6e/0xa0 [iscsi_target_mod]
 kthread+0x109/0x140

Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c | 50 +++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8cdea25f1377..f01cdae54277 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -573,7 +573,8 @@ iscsit_xmit_nondatain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	return 0;
 }
 
-static int iscsit_map_iovec(struct iscsi_cmd *, struct kvec *, u32, u32);
+static int iscsit_map_iovec(struct iscsi_cmd *cmd, struct kvec *iov, int nvec,
+			    u32 data_offset, u32 data_length);
 static void iscsit_unmap_iovec(struct iscsi_cmd *);
 static u32 iscsit_do_crypto_hash_sg(struct ahash_request *, struct iscsi_cmd *,
 				    u32, u32, u32, u8 *);
@@ -604,7 +605,8 @@ iscsit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			 *header_digest);
 	}
 
-	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1],
+	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[iov_count],
+				   cmd->orig_iov_data_count - (iov_count + 2),
 				   datain->offset, datain->length);
 	if (iov_ret < 0)
 		return -1;
@@ -886,13 +888,10 @@ EXPORT_SYMBOL(iscsit_reject_cmd);
  * Map some portion of the allocated scatterlist to an iovec, suitable for
  * kernel sockets to copy data in/out.
  */
-static int iscsit_map_iovec(
-	struct iscsi_cmd *cmd,
-	struct kvec *iov,
-	u32 data_offset,
-	u32 data_length)
+static int iscsit_map_iovec(struct iscsi_cmd *cmd, struct kvec *iov, int nvec,
+			    u32 data_offset, u32 data_length)
 {
-	u32 i = 0;
+	u32 i = 0, orig_data_length = data_length;
 	struct scatterlist *sg;
 	unsigned int page_off;
 
@@ -901,9 +900,12 @@ static int iscsit_map_iovec(
 	 */
 	u32 ent = data_offset / PAGE_SIZE;
 
+	if (!data_length)
+		return 0;
+
 	if (ent >= cmd->se_cmd.t_data_nents) {
 		pr_err("Initial page entry out-of-bounds\n");
-		return -1;
+		goto overflow;
 	}
 
 	sg = &cmd->se_cmd.t_data_sg[ent];
@@ -913,7 +915,12 @@ static int iscsit_map_iovec(
 	cmd->first_data_sg_off = page_off;
 
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
+		u32 cur_len;
+
+		if (WARN_ON_ONCE(!sg || i >= nvec))
+			goto overflow;
+
+		cur_len = min_t(u32, data_length, sg->length - page_off);
 
 		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
 		iov[i].iov_len = cur_len;
@@ -927,6 +934,16 @@ static int iscsit_map_iovec(
 	cmd->kmapped_nents = i;
 
 	return i;
+
+overflow:
+	pr_err("offset %d + length %d overflow; %d/%d; sg-list:\n",
+	       data_offset, orig_data_length, i, nvec);
+	for_each_sg(cmd->se_cmd.t_data_sg, sg,
+		    cmd->se_cmd.t_data_nents, i) {
+		pr_err("[%d] off %d len %d\n",
+		       i, sg->offset, sg->length);
+	}
+	return -1;
 }
 
 static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
@@ -1576,8 +1593,8 @@ iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	rx_size += payload_length;
 	iov = &cmd->iov_data[0];
 
-	iov_ret = iscsit_map_iovec(cmd, iov, be32_to_cpu(hdr->offset),
-				   payload_length);
+	iov_ret = iscsit_map_iovec(cmd, iov, cmd->orig_iov_data_count - 2,
+				   be32_to_cpu(hdr->offset), payload_length);
 	if (iov_ret < 0)
 		return -1;
 
@@ -1597,6 +1614,7 @@ iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		rx_size += ISCSI_CRC_LEN;
 	}
 
+	WARN_ON_ONCE(iov_count > cmd->orig_iov_data_count);
 	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
 	iscsit_unmap_iovec(cmd);
@@ -1862,6 +1880,7 @@ static int iscsit_handle_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			rx_size += ISCSI_CRC_LEN;
 		}
 
+		WARN_ON_ONCE(niov > ARRAY_SIZE(cmd->iov_misc));
 		rx_got = rx_data(conn, &cmd->iov_misc[0], niov, rx_size);
 		if (rx_got != rx_size) {
 			ret = -1;
@@ -2267,6 +2286,7 @@ iscsit_handle_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			rx_size += ISCSI_CRC_LEN;
 		}
 
+		WARN_ON_ONCE(niov > ARRAY_SIZE(iov));
 		rx_got = rx_data(conn, &iov[0], niov, rx_size);
 		if (rx_got != rx_size)
 			goto reject;
@@ -2581,8 +2601,9 @@ static int iscsit_handle_immediate_data(
 
 	BUG_ON(cmd->write_data_done > cmd->se_cmd.data_length);
 	rx_size = min(cmd->se_cmd.data_length - cmd->write_data_done, length);
-	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data, cmd->write_data_done,
-				   rx_size);
+	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data,
+				   cmd->orig_iov_data_count - 2,
+				   cmd->write_data_done, rx_size);
 	if (iov_ret < 0)
 		return IMMEDIATE_DATA_CANNOT_RECOVER;
 
@@ -2618,6 +2639,7 @@ static int iscsit_handle_immediate_data(
 		rx_size += ISCSI_CRC_LEN;
 	}
 
+	WARN_ON_ONCE(iov_count > cmd->orig_iov_data_count);
 	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
 	iscsit_unmap_iovec(cmd);
-- 
2.21.0.196.g041f5ea1cf98
