From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 10 Sep 2020 15:50:41 +0000
Subject: [PATCH 3/3] scsi: target: tcmu: optimize scatter_data_area
Message-Id: <20200910155041.17654-4-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

scatter_data_area has two purposes:
 1) create the iovs for data area buffer of a SCSI cmd
 2) If there is data in DMA_TO_DEVICE direction, it copies
   the data from sg_list to data area buffer.
Both is done in a common loop.

In case of DMA_FROM_DEVICE data transfer, scatter_data_area is
called with parameter copy_data = false. But this flag is used
just to skip memcpy() for data, while radix_tree_lookup still
is called for every dbi of the area area buffer, and kmap and
kunmap are called for every page from sg_list and data_area as
well as flush_dcache_page() for the data area pages.
Since the only thing to do with copy_data = false would be to
set up the iovs, this is a noticeable overhead.
Therefore I reworked the iov creation in the main loop of
scatter_data_area providing the new function new_block_to_iov.
Based on this I created the short new function tcmu_setup_iovs
that only writes the iovs with no overhead.
This new function is now called instead of scatter_data_area
for bidi buffers and for data buffers in those cases, where
memcpy would have been skipped.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 139 +++++++++++++++++---------------------
 1 file changed, 63 insertions(+), 76 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5587bd4d1060..18798c5422c7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -181,6 +181,8 @@ struct tcmu_cmd {
 	uint32_t dbi_cur;
 	uint32_t *dbi;
 
+	uint32_t data_len_bidi;
+
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
@@ -579,9 +581,47 @@ static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 			len += se_cmd->t_bidi_data_sg[i].length;
 		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, DATA_BLOCK_SIZE);
 		cmd->dbi_cnt += cmd->dbi_bidi_cnt;
+		cmd->data_len_bidi = len;
 	}
 }
 
+static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+			    struct iovec **iov, int prev_dbi, int *remain)
+{
+	/* Get the next dbi */
+	int dbi = tcmu_cmd_get_dbi(cmd);
+	/* Do not add more than DATA_BLOCK_SIZE to iov */
+	int len = min_t(int, DATA_BLOCK_SIZE, *remain);
+
+	*remain -= len;
+	/*
+	 * The following code will gather and map the blocks to the same iovec
+	 * when the blocks are all next to each other.
+	 */
+	if (dbi != prev_dbi + 1) {
+		/* dbi is not next to previous dbi, so start new iov */
+		if (prev_dbi >= 0)
+			(*iov)++;
+		/* write offset relative to mb_addr */
+		(*iov)->iov_base = (void __user *)
+				(udev->data_off + dbi * DATA_BLOCK_SIZE);
+	}
+	(*iov)->iov_len += len;
+
+	return dbi;
+}
+
+static void tcmu_setup_iovs(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+			    struct iovec **iov, int data_length)
+{
+	/* start value of dbi + 1 must not be a valid dbi */
+	int dbi = -2;
+
+	/* We prepare the IOVs for DMA_FROM_DEVICE transfer direction */
+	while (data_length > 0)
+		dbi = new_block_to_iov(udev, cmd, iov, dbi, &data_length);
+}
+
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
@@ -646,45 +686,22 @@ static inline size_t head_to_end(size_t head, size_t size)
 	return size - head;
 }
 
-static inline void new_iov(struct iovec **iov, bool first)
-{
-	struct iovec *iovec;
-
-	if (!first)
-		(*iov)++;
-
-	iovec = *iov;
-	memset(iovec, 0, sizeof(struct iovec));
-}
-
 #define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
 
-/* offset is relative to mb_addr */
-static inline size_t get_block_offset_user(struct tcmu_dev *dev,
-		int dbi, int remaining)
-{
-	return dev->data_off + dbi * DATA_BLOCK_SIZE +
-		DATA_BLOCK_SIZE - remaining;
-}
-
-static inline size_t iov_tail(struct iovec *iov)
-{
-	return (size_t)iov->iov_base + iov->iov_len;
-}
-
-static void scatter_data_area(struct tcmu_dev *udev,
-	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
-	unsigned int data_nents, struct iovec **iov, bool copy_data)
+static void scatter_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
+			      struct iovec **iov)
 {
-	int i, dbi;
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	/* start value of dbi + 1 must not be a valid dbi */
+	int i, dbi = -2;
 	int block_remaining = 0;
+	int data_len = se_cmd->data_length;
 	void *from, *to = NULL;
-	size_t copy_bytes, to_offset, offset;
+	size_t copy_bytes, offset;
 	struct scatterlist *sg;
 	struct page *page;
-	bool first = true;
 
-	for_each_sg(data_sg, sg, data_nents, i) {
+	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
 		int sg_remaining = sg->length;
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
@@ -694,50 +711,19 @@ static void scatter_data_area(struct tcmu_dev *udev,
 					kunmap_atomic(to);
 				}
 
-				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+				/* get next dbi and add to IOVs */
+				dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
+						       &data_len);
 				page = tcmu_get_block_page(udev, dbi);
 				to = kmap_atomic(page);
+				block_remaining = DATA_BLOCK_SIZE;
 			}
 
-			/*
-			 * Covert to virtual offset of the ring data area.
-			 */
-			to_offset = get_block_offset_user(udev, dbi,
-					block_remaining);
-
-			/*
-			 * The following code will gather and map the blocks
-			 * to the same iovec when the blocks are all next to
-			 * each other.
-			 */
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
-			if (!first && to_offset = iov_tail(*iov)) {
-				/*
-				 * Will append to the current iovec, because
-				 * the current block page is next to the
-				 * previous one.
-				 */
-				(*iov)->iov_len += copy_bytes;
-			} else {
-				/*
-				 * Will allocate a new iovec because we are
-				 * first time here or the current block page
-				 * is not next to the previous one.
-				 */
-				new_iov(iov, first);
-				(*iov)->iov_base = (void __user *)to_offset;
-				(*iov)->iov_len = copy_bytes;
-				first = false;
-			}
-
-			if (copy_data) {
-				offset = DATA_BLOCK_SIZE - block_remaining;
-				memcpy(to + offset,
-				       from + sg->length - sg_remaining,
-				       copy_bytes);
-			}
+			offset = DATA_BLOCK_SIZE - block_remaining;
+			memcpy(to + offset, from + sg->length - sg_remaining,
+			       copy_bytes);
 
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
@@ -1010,7 +996,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	int iov_cnt, iov_bidi_cnt, cmd_id;
 	uint32_t cmd_head;
 	uint64_t cdb_off;
-	bool copy_to_data_area;
 	/* size of data buffer needed */
 	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
 
@@ -1084,17 +1069,19 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* prepare iov list and copy data to data area if necessary */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	iov = &entry->req.iov[0];
-	copy_to_data_area = (se_cmd->data_direction = DMA_TO_DEVICE
-		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-			  se_cmd->t_data_nents, &iov, copy_to_data_area);
+
+	if (se_cmd->data_direction = DMA_TO_DEVICE ||
+	    se_cmd->se_cmd_flags & SCF_BIDI)
+		scatter_data_area(udev, tcmu_cmd, &iov);
+	else
+		tcmu_setup_iovs(udev, tcmu_cmd, &iov, se_cmd->data_length);
+
 	entry->req.iov_cnt = iov_cnt - iov_bidi_cnt;
 
 	/* Handle BIDI commands */
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		iov++;
-		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
-				  se_cmd->t_bidi_data_nents, &iov, false);
+		tcmu_setup_iovs(udev, tcmu_cmd, &iov, tcmu_cmd->data_len_bidi);
 		entry->req.iov_bidi_cnt = iov_bidi_cnt;
 	}
 
-- 
2.12.3
