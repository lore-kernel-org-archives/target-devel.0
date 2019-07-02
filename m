From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Jul 2019 15:30:31 +0000
Subject: [PATCH 2/2] target/core: Use REQ_OP_WRITE_SAME to implement WRITE SAME
Message-Id: <20190702153031.3832-3-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use blkdev_submit_write_same() instead of open-coding it.

Note: as one can see in target_alloc_sgl(), the target core sets the
offset in a scatter/gather list to zero for all allocated pages.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_iblock.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b5ed9c377060..c8e64fe87f7f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -465,6 +465,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
 	sector_t sectors = target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd));
+	struct blk_plug plug;
+	int ret;
 
 	if (cmd->prot_op) {
 		pr_err("WRITE_SAME: Protection information with IBLOCK"
@@ -481,6 +483,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+	/* 1. Use REQ_OP_WRITE_ZEROES if supported and if appropriate. */
 	if (bdev_write_zeroes_sectors(bdev)) {
 		if (!iblock_execute_zero_out(bdev, cmd))
 			return 0;
@@ -491,6 +494,20 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
+	/* 2. Try REQ_OP_WRITE_SAME. */
+	blk_start_plug(&plug);
+	ret = blkdev_submit_write_same(bdev, block_lba, sectors, GFP_KERNEL,
+				       sg_page(sg), iblock_bio_done, cmd);
+	blk_finish_plug(&plug);
+	if (ret = 0)
+		return 0;
+	if (ret != -EOPNOTSUPP)
+		goto fail;
+
+	/*
+	 * 3. If neither REQ_OP_WRITE_SAME nor REQ_OP_WRITE_ZEROES are
+	 * supported, use REQ_OP_WRITE.
+	 */
 	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE, 0);
 	if (!bio)
 		goto fail_free_ibr;
-- 
2.22.0.410.gd8fdbe21b5-goog
