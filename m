From: Greg Edwards <gedwards@ddn.com>
Date: Tue, 04 Sep 2018 17:19:10 +0000
Subject: [PATCH v5] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180904171910.21802-1-gedwards@ddn.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When T10 PI is enabled on a backing device for the iblock backstore, the
PI SGL for the entire command is attached to the first bio only.  This
works fine if the command is covered by a single bio, but can result in
ref tag errors in the client for the other bios in a multi-bio command,
e.g.

[   47.631236] sda: ref tag error at location 2048 (rcvd 0)
[   47.637658] sda: ref tag error at location 4096 (rcvd 0)
[   47.644228] sda: ref tag error at location 6144 (rcvd 0)

The command will be split into multiple bios if the number of data SG
elements exceeds BIO_MAX_PAGES (see iblock_get_bio()).

The bios may later be split again in the block layer on the host after
iblock_submit_bios(), depending on the queue limits of the backing
device.  The block and SCSI layers will pass through the whole PI SGL
down to the LLDD however that first bio is split up, but the LLDD may
only use the portion that corresponds to the data length (depends on the
LLDD, tested with scsi_debug).

Split the PI SGL across the bios in the command, so each bio's
bio_integrity_payload contains the protection information for the data
in the bio.  Use an sg_mapping_iter to keep track of where we are in PI
SGL, so we know where to start with the next bio.

Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
Changes from v4:
  * use %zu for size_t in pr_debug()

Changes from v3:
  * cast a size_t as unsigned long in a pr_debug() for 32-bit arches,
    turned up by the kbuild test robot

Changes from v2:
  * add back min(cmd->t_prot_nents, BIO_MAX_PAGES) for bio_integrity_alloc()
    from v1

Changes from v1:
  * expand commit message
  * use an sg_mapping_iter to track where we are in the PI SGL


 drivers/target/target_core_iblock.c | 54 ++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a5cb7b..d97624620aab 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -635,14 +635,15 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 }
 
 static int
-iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
+iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
+		 struct sg_mapping_iter *miter)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct blk_integrity *bi;
 	struct bio_integrity_payload *bip;
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-	struct scatterlist *sg;
-	int i, rc;
+	int rc;
+	size_t resid, len;
 
 	bi = bdev_get_integrity(ib_dev->ibd_bd);
 	if (!bi) {
@@ -650,31 +651,39 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return -ENODEV;
 	}
 
-	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_prot_nents);
+	bip = bio_integrity_alloc(bio, GFP_NOIO,
+			min_t(unsigned int, cmd->t_prot_nents, BIO_MAX_PAGES));
 	if (IS_ERR(bip)) {
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
-	bip->bip_iter.bi_size = (cmd->data_length / dev->dev_attrib.block_size) *
-			 dev->prot_length;
-	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
+	bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
-	for_each_sg(cmd->t_prot_sg, sg, cmd->t_prot_nents, i) {
+	resid = bip->bip_iter.bi_size;
+	while (resid > 0 && sg_miter_next(miter)) {
 
-		rc = bio_integrity_add_page(bio, sg_page(sg), sg->length,
-					    sg->offset);
-		if (rc != sg->length) {
+		len = min_t(size_t, miter->length, resid);
+		rc = bio_integrity_add_page(bio, miter->page, len,
+					    offset_in_page(miter->addr));
+		if (rc != len) {
 			pr_err("bio_integrity_add_page() failed; %d\n", rc);
+			sg_miter_stop(miter);
 			return -ENOMEM;
 		}
 
-		pr_debug("Added bio integrity page: %p length: %d offset; %d\n",
-			 sg_page(sg), sg->length, sg->offset);
+		pr_debug("Added bio integrity page: %p length: %zu offset: %lu\n",
+			  miter->page, len, offset_in_page(miter->addr));
+
+		resid -= len;
+		if (len < miter->length)
+			miter->consumed -= miter->length - len;
 	}
+	sg_miter_stop(miter);
 
 	return 0;
 }
@@ -686,12 +695,13 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct se_device *dev = cmd->se_dev;
 	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
 	struct iblock_req *ibr;
-	struct bio *bio, *bio_start;
+	struct bio *bio;
 	struct bio_list list;
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
 	unsigned bio_cnt;
-	int i, op, op_flags = 0;
+	int i, rc, op, op_flags = 0;
+	struct sg_mapping_iter prot_miter;
 
 	if (data_direction = DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -726,13 +736,17 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (!bio)
 		goto fail_free_ibr;
 
-	bio_start = bio;
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
 	refcount_set(&ibr->pending, 2);
 	bio_cnt = 1;
 
+	if (cmd->prot_type && dev->dev_attrib.pi_prot_type)
+		sg_miter_start(&prot_miter, cmd->t_prot_sg, cmd->t_prot_nents,
+			       op = REQ_OP_READ ? SG_MITER_FROM_SG :
+						   SG_MITER_TO_SG);
+
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		/*
 		 * XXX: if the length the device accepts is shorter than the
@@ -741,6 +755,12 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 */
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
+			if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
+				rc = iblock_alloc_bip(cmd, bio, &prot_miter);
+				if (rc)
+					goto fail_put_bios;
+			}
+
 			if (bio_cnt >= IBLOCK_MAX_BIO_PER_TASK) {
 				iblock_submit_bios(&list);
 				bio_cnt = 0;
@@ -762,7 +782,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-		int rc = iblock_alloc_bip(cmd, bio_start);
+		rc = iblock_alloc_bip(cmd, bio, &prot_miter);
 		if (rc)
 			goto fail_put_bios;
 	}
-- 
2.17.1
