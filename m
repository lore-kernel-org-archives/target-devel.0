From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 10 Sep 2020 15:50:40 +0000
Subject: [PATCH 2/3] scsi: target: tcmu: optimize queue_cmd_ring
Message-Id: <20200910155041.17654-3-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

queue_cmd_ring() needs to check whether there is enough space
in cmd ring and data area for the cmd to queue.

Currently the sequence is:
 1) calculate size the cmd will occupy on the ring
    based on estimation of needed iovs.
 2) check whether there is enough space on the ring based
    on size from 1)
 2) allocate buffers on data area
 3) calculate number of iovs the commands really needs
    while copying incoming data (if any) to data area.
 4) Re-calculate real size of cmd on ring, based on real number
    of iovs
 5) setup possible padding and cmd on the ring

In 1) we must not underestimate the cmd size, so we use max
possible number of iovs for the given IO data size. The
resulting overestimation can be really high, so this sequence
is not ideal. We can calculate the real number of iovs earliest
after data buffer allocation. Therefore I reworked the code to
implement the following sequence:
 A) allocate buffers on data area and calculate number of
    necessary iovs during this.
 B) calculate real size of cmd on ring based on number of iovs
 C) check whether there is enough space on the ring
 D) setup possible padding and cmd on the ring

The new sequence enforces to split of new function
tcmu_alloc_data_space from is_ring_space_avail. Using this
function queue_cmd_ring was changed according to the new sequence.
Further changes were necessary in routines called by
tcmu_alloc_data_space to allow calculating and returning the iov
count. In scatter_data_area counting of iovs is removed.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 184 +++++++++++++++++++++-----------------
 1 file changed, 102 insertions(+), 82 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index fa0c4a42e435..5587bd4d1060 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -493,15 +493,16 @@ static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
 		clear_bit(tcmu_cmd->dbi[i], udev->data_bitmap);
 }
 
-static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
-					struct tcmu_cmd *tcmu_cmd)
+static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
+				       struct tcmu_cmd *tcmu_cmd,
+				       int prev_dbi, int *iov_cnt)
 {
 	struct page *page;
 	int ret, dbi;
 
 	dbi = find_first_zero_bit(udev->data_bitmap, udev->dbi_thresh);
 	if (dbi = udev->dbi_thresh)
-		return false;
+		return -1;
 
 	page = radix_tree_lookup(&udev->data_blocks, dbi);
 	if (!page) {
@@ -525,24 +526,30 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 	set_bit(dbi, udev->data_bitmap);
 	tcmu_cmd_set_dbi(tcmu_cmd, dbi);
 
-	return true;
+	if (dbi != prev_dbi + 1)
+		*iov_cnt += 1;
+
+	return dbi;
 err_insert:
 	__free_page(page);
 err_alloc:
 	atomic_dec(&global_db_count);
-	return false;
+	return -1;
 }
 
-static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
-				  struct tcmu_cmd *tcmu_cmd)
+static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
+				 struct tcmu_cmd *tcmu_cmd, int dbi_cnt)
 {
-	int i;
+	/* start value of dbi + 1 must not be a valid dbi */
+	int dbi = -2;
+	int i, iov_cnt = 0;
 
-	for (i = tcmu_cmd->dbi_cur; i < tcmu_cmd->dbi_cnt; i++) {
-		if (!tcmu_get_empty_block(udev, tcmu_cmd))
-			return false;
+	for (i = 0; i < dbi_cnt; i++) {
+		dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, &iov_cnt);
+		if (dbi < 0)
+			return -1;
 	}
-	return true;
+	return iov_cnt;
 }
 
 static inline struct page *
@@ -639,13 +646,12 @@ static inline size_t head_to_end(size_t head, size_t size)
 	return size - head;
 }
 
-static inline void new_iov(struct iovec **iov, int *iov_cnt)
+static inline void new_iov(struct iovec **iov, bool first)
 {
 	struct iovec *iovec;
 
-	if (*iov_cnt != 0)
+	if (!first)
 		(*iov)++;
-	(*iov_cnt)++;
 
 	iovec = *iov;
 	memset(iovec, 0, sizeof(struct iovec));
@@ -668,8 +674,7 @@ static inline size_t iov_tail(struct iovec *iov)
 
 static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
-	unsigned int data_nents, struct iovec **iov,
-	int *iov_cnt, bool copy_data)
+	unsigned int data_nents, struct iovec **iov, bool copy_data)
 {
 	int i, dbi;
 	int block_remaining = 0;
@@ -677,6 +682,7 @@ static void scatter_data_area(struct tcmu_dev *udev,
 	size_t copy_bytes, to_offset, offset;
 	struct scatterlist *sg;
 	struct page *page;
+	bool first = true;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
@@ -707,8 +713,7 @@ static void scatter_data_area(struct tcmu_dev *udev,
 			 */
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
-			if (*iov_cnt != 0 &&
-			    to_offset = iov_tail(*iov)) {
+			if (!first && to_offset = iov_tail(*iov)) {
 				/*
 				 * Will append to the current iovec, because
 				 * the current block page is next to the
@@ -721,9 +726,10 @@ static void scatter_data_area(struct tcmu_dev *udev,
 				 * first time here or the current block page
 				 * is not next to the previous one.
 				 */
-				new_iov(iov, iov_cnt);
+				new_iov(iov, first);
 				(*iov)->iov_base = (void __user *)to_offset;
 				(*iov)->iov_len = copy_bytes;
+				first = false;
 			}
 
 			if (copy_data) {
@@ -815,13 +821,11 @@ static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
 }
 
 /*
- * We can't queue a command until we have space available on the cmd ring *and*
- * space available on the data area.
+ * We can't queue a command until we have space available on the cmd ring.
  *
  * Called with ring lock held.
  */
-static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-				size_t cmd_size)
+static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size)
 {
 	struct tcmu_mailbox *mb = udev->mb_addr;
 	size_t space, cmd_needed;
@@ -846,9 +850,22 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		       udev->cmdr_last_cleaned, udev->cmdr_size);
 		return false;
 	}
+	return true;
+}
+
+/*
+ * We have to allocate data buffers before we can queue a command.
+ * Returns -1 on error (not enough space) or number of needed iovs on success
+ *
+ * Called with ring lock held.
+ */
+static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+				  int *iov_bidi_cnt)
+{
+	int space, iov_cnt = 0, ret = 0;
 
-	if (!cmd || !cmd->dbi_cnt)
-		return true;
+	if (!cmd->dbi_cnt)
+		goto wr_iov_cnts;
 
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
@@ -857,10 +874,10 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 				(udev->max_blocks - udev->dbi_thresh) + space;
 
 		if (blocks_left < cmd->dbi_cnt) {
-			pr_debug("no data space: only %lu available, but ask for %zu\n",
+			pr_debug("no data space: only %lu available, but ask for %lu\n",
 					blocks_left * DATA_BLOCK_SIZE,
 					cmd->dbi_cnt * DATA_BLOCK_SIZE);
-			return false;
+			return -1;
 		}
 
 		udev->dbi_thresh += cmd->dbi_cnt;
@@ -868,7 +885,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			udev->dbi_thresh = udev->max_blocks;
 	}
 
-	return tcmu_get_empty_blocks(udev, cmd);
+	iov_cnt = tcmu_get_empty_blocks(udev, cmd,
+					cmd->dbi_cnt - cmd->dbi_bidi_cnt);
+	if (iov_cnt < 0)
+		return -1;
+
+	if (cmd->dbi_bidi_cnt) {
+		ret = tcmu_get_empty_blocks(udev, cmd, cmd->dbi_bidi_cnt);
+		if (ret < 0)
+			return -1;
+	}
+wr_iov_cnts:
+	*iov_bidi_cnt = ret;
+	return iov_cnt + ret;
 }
 
 static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
@@ -978,7 +1007,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_mailbox *mb = udev->mb_addr;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
-	int iov_cnt, cmd_id;
+	int iov_cnt, iov_bidi_cnt, cmd_id;
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
@@ -997,42 +1026,54 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		return -1;
 	}
 
+	if (!list_empty(&udev->qfull_queue))
+		goto queue;
+
+	if (data_length > udev->data_size) {
+		pr_warn("TCMU: Request of size %zu is too big for %zu data area\n",
+			data_length, udev->data_size);
+		*scsi_err = TCM_INVALID_CDB_FIELD;
+		return -1;
+	}
+
+	iov_cnt = tcmu_alloc_data_space(udev, tcmu_cmd, &iov_bidi_cnt);
+	if (iov_cnt < 0)
+		goto free_and_queue;
+
 	/*
 	 * Must be a certain minimum size for response sense info, but
 	 * also may be larger if the iov array is large.
-	 *
-	 * We prepare as many iovs as possbile for potential uses here,
-	 * because it's expensive to tell how many regions are freed in
-	 * the bitmap & global data pool, as the size calculated here
-	 * will only be used to do the checks.
-	 *
-	 * The size will be recalculated later as actually needed to save
-	 * cmd area memories.
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
+	base_command_size = tcmu_cmd_get_base_cmd_size(iov_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
-	if (!list_empty(&udev->qfull_queue))
-		goto queue;
-
-	if ((command_size > (udev->cmdr_size / 2)) ||
-	    data_length > udev->data_size) {
-		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
-			"cmd ring/data area\n", command_size, data_length,
-			udev->cmdr_size, udev->data_size);
+	if (command_size > (udev->cmdr_size / 2)) {
+		pr_warn("TCMU: Request of size %zu is too big for %u cmd ring\n",
+			command_size, udev->cmdr_size);
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
 	}
 
-	if (!is_ring_space_avail(udev, tcmu_cmd, command_size)) {
+	if (!is_ring_space_avail(udev, command_size))
 		/*
 		 * Don't leave commands partially setup because the unmap
 		 * thread might need the blocks to make forward progress.
 		 */
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
-		tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-		goto queue;
+		goto free_and_queue;
+
+	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
+	if (cmd_id < 0) {
+		pr_err("tcmu: Could not allocate cmd id.\n");
+
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+		*scsi_err = TCM_OUT_OF_RESOURCES;
+		return -1;
 	}
+	tcmu_cmd->cmd_id = cmd_id;
+
+	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
+		 tcmu_cmd, udev->name);
 
 	cmd_head = ring_insert_padding(udev, command_size);
 
@@ -1040,52 +1081,27 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	memset(entry, 0, command_size);
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
 
-	/* Handle allocating space from the data area */
+	/* prepare iov list and copy data to data area if necessary */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	iov = &entry->req.iov[0];
-	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction = DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
 	scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-			  se_cmd->t_data_nents, &iov, &iov_cnt,
-			  copy_to_data_area);
-	entry->req.iov_cnt = iov_cnt;
+			  se_cmd->t_data_nents, &iov, copy_to_data_area);
+	entry->req.iov_cnt = iov_cnt - iov_bidi_cnt;
 
 	/* Handle BIDI commands */
-	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		iov++;
 		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
-				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
-				  false);
+				  se_cmd->t_bidi_data_nents, &iov, false);
+		entry->req.iov_bidi_cnt = iov_bidi_cnt;
 	}
-	entry->req.iov_bidi_cnt = iov_cnt;
-
-	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
-	if (cmd_id < 0) {
-		pr_err("tcmu: Could not allocate cmd id.\n");
-
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		*scsi_err = TCM_OUT_OF_RESOURCES;
-		return -1;
-	}
-	tcmu_cmd->cmd_id = cmd_id;
-
-	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
-		 tcmu_cmd, udev->name);
 
 	tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out, &udev->cmd_timer);
 
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
-	/*
-	 * Recalaulate the command's base size and size according
-	 * to the actual needs
-	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
-						       entry->req.iov_bidi_cnt);
-	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
-
 	tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
 
 	/* All offsets relative to mb_addr, not start of entry! */
@@ -1104,6 +1120,10 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	return 0;
 
+free_and_queue:
+	tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
+	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
+
 queue:
 	if (add_to_qfull_queue(tcmu_cmd)) {
 		*scsi_err = TCM_OUT_OF_RESOURCES;
@@ -1138,7 +1158,7 @@ queue_tmr_ring(struct tcmu_dev *udev, struct tcmu_tmr *tmr)
 	cmd_size = round_up(sizeof(*entry) + id_list_sz, TCMU_OP_ALIGN_SIZE);
 
 	if (!list_empty(&udev->tmr_queue) ||
-	    !is_ring_space_avail(udev, NULL, cmd_size)) {
+	    !is_ring_space_avail(udev, cmd_size)) {
 		list_add_tail(&tmr->queue_entry, &udev->tmr_queue);
 		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
 			 tmr, udev->name);
-- 
2.12.3
