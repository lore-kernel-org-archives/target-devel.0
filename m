From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 10 Sep 2020 15:50:39 +0000
Subject: [PATCH 1/3] scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
Message-Id: <20200910155041.17654-2-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Simplify code by joining tcmu_cmd_get_data_length and
tcmu_cmd_get_block_cnt into tcmu_cmd_set_block_cnts.
The new function sets tcmu_cmd->dbi_cnt and also the new
field tcmu_cmd->dbi_bidi_cnt, which is needed for
further enhancements in following patches.
Simplyfy some code by using tcmu_cmd->dbi(_bidi)_cnt
instead of calculation from length.

Please note: the calculation of the number of dbis needed for
bidi was wrong. It was based on the length of the first bidi sg
only. I changed it to correctly sum up entier length of all
bidi sgs.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 53 +++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b7592350502..fa0c4a42e435 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -177,6 +177,7 @@ struct tcmu_cmd {
 	/* Can't use se_cmd when cleaning up expired cmds, because if
 	   cmd has been completed then accessing se_cmd is off limits */
 	uint32_t dbi_cnt;
+	uint32_t dbi_bidi_cnt;
 	uint32_t dbi_cur;
 	uint32_t *dbi;
 
@@ -558,25 +559,20 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
 
-static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
+static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 {
-	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
+	int i, len;
+	struct se_cmd *se_cmd = cmd->se_cmd;
+
+	cmd->dbi_cnt = DIV_ROUND_UP(se_cmd->data_length, DATA_BLOCK_SIZE);
 
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += round_up(se_cmd->t_bidi_data_sg->length,
-				DATA_BLOCK_SIZE);
+		for (i = 0, len = 0; i < se_cmd->t_bidi_data_nents; i++)
+			len += se_cmd->t_bidi_data_sg[i].length;
+		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, DATA_BLOCK_SIZE);
+		cmd->dbi_cnt += cmd->dbi_bidi_cnt;
 	}
-
-	return data_length;
-}
-
-static inline uint32_t tcmu_cmd_get_block_cnt(struct tcmu_cmd *tcmu_cmd)
-{
-	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
-
-	return data_length / DATA_BLOCK_SIZE;
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
@@ -593,8 +589,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd->se_cmd = se_cmd;
 	tcmu_cmd->tcmu_dev = udev;
 
-	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
+	tcmu_cmd_set_block_cnts(tcmu_cmd);
 	tcmu_cmd->dbi = kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
 				GFP_NOIO);
 	if (!tcmu_cmd->dbi) {
@@ -767,13 +762,12 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		data_sg = se_cmd->t_data_sg;
 		data_nents = se_cmd->t_data_nents;
 	} else {
-
 		/*
 		 * For bidi case, the first count blocks are for Data-Out
 		 * buffer blocks, and before gathering the Data-In buffer
-		 * the Data-Out buffer blocks should be discarded.
+		 * the Data-Out buffer blocks should be skipped.
 		 */
-		count = DIV_ROUND_UP(se_cmd->data_length, DATA_BLOCK_SIZE);
+		count = cmd->dbi_cnt - cmd->dbi_bidi_cnt;
 
 		data_sg = se_cmd->t_bidi_data_sg;
 		data_nents = se_cmd->t_bidi_data_nents;
@@ -827,11 +821,9 @@ static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
  * Called with ring lock held.
  */
 static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-		size_t cmd_size, size_t data_needed)
+				size_t cmd_size)
 {
 	struct tcmu_mailbox *mb = udev->mb_addr;
-	uint32_t blocks_needed = (data_needed + DATA_BLOCK_SIZE - 1)
-				/ DATA_BLOCK_SIZE;
 	size_t space, cmd_needed;
 	u32 cmd_head;
 
@@ -855,23 +847,23 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		return false;
 	}
 
-	if (!data_needed)
+	if (!cmd || !cmd->dbi_cnt)
 		return true;
 
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
-	if ((space * DATA_BLOCK_SIZE) < data_needed) {
+	if (space < cmd->dbi_cnt) {
 		unsigned long blocks_left  				(udev->max_blocks - udev->dbi_thresh) + space;
 
-		if (blocks_left < blocks_needed) {
+		if (blocks_left < cmd->dbi_cnt) {
 			pr_debug("no data space: only %lu available, but ask for %zu\n",
 					blocks_left * DATA_BLOCK_SIZE,
-					data_needed);
+					cmd->dbi_cnt * DATA_BLOCK_SIZE);
 			return false;
 		}
 
-		udev->dbi_thresh += blocks_needed;
+		udev->dbi_thresh += cmd->dbi_cnt;
 		if (udev->dbi_thresh > udev->max_blocks)
 			udev->dbi_thresh = udev->max_blocks;
 	}
@@ -990,7 +982,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
-	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
+	/* size of data buffer needed */
+	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
 
 	*scsi_err = TCM_NO_SENSE;
 
@@ -1031,7 +1024,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		return -1;
 	}
 
-	if (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
+	if (!is_ring_space_avail(udev, tcmu_cmd, command_size)) {
 		/*
 		 * Don't leave commands partially setup because the unmap
 		 * thread might need the blocks to make forward progress.
@@ -1145,7 +1138,7 @@ queue_tmr_ring(struct tcmu_dev *udev, struct tcmu_tmr *tmr)
 	cmd_size = round_up(sizeof(*entry) + id_list_sz, TCMU_OP_ALIGN_SIZE);
 
 	if (!list_empty(&udev->tmr_queue) ||
-	    !is_ring_space_avail(udev, NULL, cmd_size, 0)) {
+	    !is_ring_space_avail(udev, NULL, cmd_size)) {
 		list_add_tail(&tmr->queue_entry, &udev->tmr_queue);
 		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
 			 tmr, udev->name);
-- 
2.12.3
