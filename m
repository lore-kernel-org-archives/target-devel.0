From: Bodo Stroesser <bostroesser@gmail.com>
Date: Mon, 19 Oct 2020 11:51:18 +0000
Subject: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
Message-Id: <20201019115118.11949-1-bostroesser@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>

This is made on top of the scsi-staging tree plus my previous
patch:
"scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel"

---

scatter_data_area and gather_data_area are not easy to understand,
since data is copied in nested loops over sg_list and tcmu dbi
list. Since sg list can contain only partly filled pages, the loop
has to be prepared to handle sg pages not matching dbi pages
1 by 1.

Existing implementation uses kmap_atomic()/kunmap_atomic() due to
performance reasons. But instead of using these calls strictly
nested for sg and dpi pages, the code holds the mappings in an
overlapping way, which indeed is a bug that would trigger on archs
using highmem.

The scatterlist lib contains the sg_miter_start/_next/_stop
functions which can be used to simplify such complicated loops.

The new code now processes the dbi list in the outer loop, while
sg list is handled by the inner one. That way the code can take
advantage of the sg_miter_* family calls.

Calling sg_miter_stop() after the end of the inner loop enforces
strict nesting of atomic kmaps.

Since the nested loops in scatter_/gather_data_area were very
similar, I replaced them by the new helper function
tcmu_copy_data().

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>

---

History:

v2: - Fixed a bug when userspace sends less read data than expected
      by SCSI cmd.
    - In function tcmu_copy_data changed type of param data_len
      and local variable block_remaining from int to size_t
    - Removed superfluous line feed in declaration of function
      tcmu_copy_data
---
 drivers/target/target_core_user.c | 168 +++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 91 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 954031c48830..a2cfd59a0375 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -642,14 +642,15 @@ static int handle_compat_iovec(struct tcmu_dev *udev, struct iovec **iov,
 #endif
 
 static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-			    struct iovec **iov, int prev_dbi, int *remain)
+			    struct iovec **iov, int prev_dbi, int len)
 {
 	/* Get the next dbi */
 	int dbi = tcmu_cmd_get_dbi(cmd);
+
 	/* Do not add more than DATA_BLOCK_SIZE to iov */
-	int len = min_t(int, DATA_BLOCK_SIZE, *remain);
+	if (len > DATA_BLOCK_SIZE)
+		len = DATA_BLOCK_SIZE;
 
-	*remain -= len;
 	/*
 	 * The following code will gather and map the blocks to the same iovec
 	 * when the blocks are all next to each other.
@@ -678,8 +679,8 @@ static void tcmu_setup_iovs(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	int dbi = -2;
 
 	/* We prepare the IOVs for DMA_FROM_DEVICE transfer direction */
-	while (data_length > 0)
-		dbi = new_block_to_iov(udev, cmd, iov, dbi, &data_length);
+	for (; data_length > 0; data_length -= DATA_BLOCK_SIZE)
+		dbi = new_block_to_iov(udev, cmd, iov, dbi, data_length);
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
@@ -748,67 +749,83 @@ static inline size_t head_to_end(size_t head, size_t size)
 
 #define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
 
+#define TCMU_SG_TO_DATA_AREA 1
+#define TCMU_DATA_AREA_TO_SG 2
+
+static inline void tcmu_copy_data(struct tcmu_dev *udev,
+				  struct tcmu_cmd *tcmu_cmd, uint32_t direction,
+				  struct scatterlist *sg, unsigned int sg_nents,
+				  struct iovec **iov, size_t data_len)
+{
+	/* start value of dbi + 1 must not be a valid dbi */
+	int dbi = -2;
+	size_t block_remaining, cp_len;
+	struct sg_mapping_iter sg_iter;
+	unsigned int sg_flags;
+	struct page *page;
+	void *data_page_start, *data_addr;
+
+	if (direction = TCMU_SG_TO_DATA_AREA)
+		sg_flags = SG_MITER_ATOMIC | SG_MITER_FROM_SG;
+	else
+		sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
+	sg_miter_start(&sg_iter, sg, sg_nents, sg_flags);
+
+	while (data_len) {
+		if (direction = TCMU_SG_TO_DATA_AREA)
+			dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
+					       data_len);
+		else
+			dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+		page = tcmu_get_block_page(udev, dbi);
+		if (direction = TCMU_DATA_AREA_TO_SG)
+			flush_dcache_page(page);
+		data_page_start = kmap_atomic(page);
+		block_remaining = DATA_BLOCK_SIZE;
+
+		while (block_remaining && data_len) {
+			if (!sg_miter_next(&sg_iter)) {
+				/* set length to 0 to abort outer loop */
+				data_len = 0;
+				pr_debug("tcmu_move_data: aborting data copy due to exhausted sg_list\n");
+				break;
+			}
+			cp_len = min3(sg_iter.length, block_remaining, data_len);
+
+			data_addr = data_page_start +
+				    DATA_BLOCK_SIZE - block_remaining;
+			if (direction = TCMU_SG_TO_DATA_AREA)
+				memcpy(data_addr, sg_iter.addr, cp_len);
+			else
+				memcpy(sg_iter.addr, data_addr, cp_len);
+
+			data_len -= cp_len;
+			block_remaining -= cp_len;
+			sg_iter.consumed = cp_len;
+		}
+		sg_miter_stop(&sg_iter);
+
+		kunmap_atomic(data_page_start);
+		if (direction = TCMU_SG_TO_DATA_AREA)
+			flush_dcache_page(page);
+	}
+}
+
 static void scatter_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 			      struct iovec **iov)
 {
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-	/* start value of dbi + 1 must not be a valid dbi */
-	int i, dbi = -2;
-	int block_remaining = 0;
-	int data_len = se_cmd->data_length;
-	void *from, *to = NULL;
-	size_t copy_bytes, offset;
-	struct scatterlist *sg;
-	struct page *page = NULL;
 
-	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
-		int sg_remaining = sg->length;
-		from = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0) {
-			if (block_remaining = 0) {
-				if (to) {
-					flush_dcache_page(page);
-					kunmap_atomic(to);
-				}
-
-				/* get next dbi and add to IOVs */
-				dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
-						       &data_len);
-				page = tcmu_get_block_page(udev, dbi);
-				to = kmap_atomic(page);
-				block_remaining = DATA_BLOCK_SIZE;
-			}
-
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
-			offset = DATA_BLOCK_SIZE - block_remaining;
-			memcpy(to + offset, from + sg->length - sg_remaining,
-			       copy_bytes);
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
-		}
-		kunmap_atomic(from - sg->offset);
-	}
-
-	if (to) {
-		flush_dcache_page(page);
-		kunmap_atomic(to);
-	}
+	tcmu_copy_data(udev, tcmu_cmd, TCMU_SG_TO_DATA_AREA, se_cmd->t_data_sg,
+		       se_cmd->t_data_nents, iov, se_cmd->data_length);
 }
 
-static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 			     bool bidi, uint32_t read_len)
 {
-	struct se_cmd *se_cmd = cmd->se_cmd;
-	int i, dbi;
-	int block_remaining = 0;
-	void *from = NULL, *to;
-	size_t copy_bytes, offset;
-	struct scatterlist *sg, *data_sg;
-	struct page *page;
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	struct scatterlist *data_sg;
 	unsigned int data_nents;
-	uint32_t count = 0;
 
 	if (!bidi) {
 		data_sg = se_cmd->t_data_sg;
@@ -819,46 +836,15 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		 * buffer blocks, and before gathering the Data-In buffer
 		 * the Data-Out buffer blocks should be skipped.
 		 */
-		count = cmd->dbi_cnt - cmd->dbi_bidi_cnt;
+		tcmu_cmd_set_dbi_cur(tcmu_cmd,
+				     tcmu_cmd->dbi_cnt - tcmu_cmd->dbi_bidi_cnt);
 
 		data_sg = se_cmd->t_bidi_data_sg;
 		data_nents = se_cmd->t_bidi_data_nents;
 	}
 
-	tcmu_cmd_set_dbi_cur(cmd, count);
-
-	for_each_sg(data_sg, sg, data_nents, i) {
-		int sg_remaining = sg->length;
-		to = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0 && read_len > 0) {
-			if (block_remaining = 0) {
-				if (from)
-					kunmap_atomic(from);
-
-				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_cmd_get_dbi(cmd);
-				page = tcmu_get_block_page(udev, dbi);
-				from = kmap_atomic(page);
-				flush_dcache_page(page);
-			}
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
-			if (read_len < copy_bytes)
-				copy_bytes = read_len;
-			offset = DATA_BLOCK_SIZE - block_remaining;
-			memcpy(to + sg->length - sg_remaining, from + offset,
-					copy_bytes);
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
-			read_len -= copy_bytes;
-		}
-		kunmap_atomic(to - sg->offset);
-		if (read_len = 0)
-			break;
-	}
-	if (from)
-		kunmap_atomic(from);
+	tcmu_copy_data(udev, tcmu_cmd, TCMU_DATA_AREA_TO_SG, data_sg,
+		       data_nents, NULL, read_len);
 }
 
 static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
-- 
2.12.3
