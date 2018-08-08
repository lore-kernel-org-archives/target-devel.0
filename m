From: Greg Edwards <gedwards@ddn.com>
Date: Wed, 08 Aug 2018 19:31:40 +0000
Subject: [PATCH] target/iblock: split T10 PI SGL across command bios
Message-Id: <20180808193140.1463-1-gedwards@ddn.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When T10 PI is enabled on a backing device for the iblock backstore, the
PI SGL for the entire command is attached to the first bio only.  This
works fine if the command is covered by a single bio, but results in
integrity verification errors for the other bios in a multi-bio command.

Split the PI SGL across the bios in the command, so each bip contains
the protection information for the data in the bio.  In a multi-bio
command, store where we left off in the PI SGL so we know where to start
with the next bio.

Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
This patch depends on commit 359f642700f2 ("block: move
bio_integrity_{intervals,bytes} into blkdev.h") in Jens' block for-next branch.

 drivers/target/target_core_iblock.c | 60 +++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a5cb7b..d3ab83282f61 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -635,7 +635,8 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 }
 
 static int
-iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
+iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
+		 struct scatterlist **sgl, unsigned int *skip)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct blk_integrity *bi;
@@ -643,6 +644,7 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct scatterlist *sg;
 	int i, rc;
+	unsigned int size, nr_pages, len, off;
 
 	bi = bdev_get_integrity(ib_dev->ibd_bd);
 	if (!bi) {
@@ -650,32 +652,52 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return -ENODEV;
 	}
 
-	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_prot_nents);
+	nr_pages = min_t(unsigned int, cmd->t_prot_nents, BIO_MAX_PAGES);
+	bip = bio_integrity_alloc(bio, GFP_NOIO, nr_pages);
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
+	size = bip->bip_iter.bi_size;
+	for_each_sg(*sgl, sg, nr_pages, i) {
 
-		rc = bio_integrity_add_page(bio, sg_page(sg), sg->length,
-					    sg->offset);
-		if (rc != sg->length) {
+		len = sg->length - *skip;
+		off = sg->offset + *skip;
+
+		if (*skip)
+			*skip = 0;
+
+		if (len > size) {
+			len = size;
+			*skip = len;
+		}
+
+		rc = bio_integrity_add_page(bio, sg_page(sg), len, off);
+		if (rc != len) {
 			pr_err("bio_integrity_add_page() failed; %d\n", rc);
 			return -ENOMEM;
 		}
 
 		pr_debug("Added bio integrity page: %p length: %d offset; %d\n",
-			 sg_page(sg), sg->length, sg->offset);
+			 sg_page(sg), len, off);
+
+		size -= len;
+		if (!size)
+			break;
 	}
 
+	if (*skip = 0)
+		*sgl = sg_next(sg);
+	else
+		*sgl = sg;
+
 	return 0;
 }
 
@@ -686,12 +708,12 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct se_device *dev = cmd->se_dev;
 	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
 	struct iblock_req *ibr;
-	struct bio *bio, *bio_start;
+	struct bio *bio;
 	struct bio_list list;
-	struct scatterlist *sg;
+	struct scatterlist *sg, *sg_prot = cmd->t_prot_sg;
 	u32 sg_num = sgl_nents;
-	unsigned bio_cnt;
-	int i, op, op_flags = 0;
+	unsigned int bio_cnt, skip = 0;
+	int i, rc, op, op_flags = 0;
 
 	if (data_direction = DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -726,7 +748,6 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (!bio)
 		goto fail_free_ibr;
 
-	bio_start = bio;
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
@@ -741,6 +762,13 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 */
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
+			if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
+				rc = iblock_alloc_bip(cmd, bio, &sg_prot,
+						      &skip);
+				if (rc)
+					goto fail_put_bios;
+			}
+
 			if (bio_cnt >= IBLOCK_MAX_BIO_PER_TASK) {
 				iblock_submit_bios(&list);
 				bio_cnt = 0;
@@ -762,7 +790,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-		int rc = iblock_alloc_bip(cmd, bio_start);
+		rc = iblock_alloc_bip(cmd, bio, &sg_prot, &skip);
 		if (rc)
 			goto fail_put_bios;
 	}
-- 
2.17.1

