From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Jul 2019 15:30:30 +0000
Subject: [PATCH 1/2] block: Add blkdev_submit_write_same()
Message-Id: <20190702153031.3832-2-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Add an asynchronous version of blkdev_issue_write_same().

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-lib.c        | 37 ++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |  3 +++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5f2c429d4378..f0cd9400d98a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -187,7 +187,8 @@ static int __blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
  * @page:	page containing data
  *
  * Description:
- *    Issue a write same request for the sectors in question.
+ *    Issue a write same request for the sectors in question and wait until it
+ *    has finished.
  */
 int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 				sector_t nr_sects, gfp_t gfp_mask,
@@ -209,6 +210,40 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
 
+/**
+ * blkdev_submit_write_same - queue a write same operation
+ * @bdev:	target blockdev
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @page:	page containing data
+ * @bi_end_io:  will be called upon completion
+ * @bi_private: will be stored in the bio->bi_private field of the bio passed
+ *		to @bi_end_io.
+ *
+ * Description:
+ *    Submit a write same request asynchronously for the sectors in question.
+ *    @bi_end_io will be called upon request completion.
+ */
+int blkdev_submit_write_same(struct block_device *bdev, sector_t sector,
+			     sector_t nr_sects, gfp_t gfp_mask,
+			     struct page *page, bio_end_io_t bi_end_io,
+			     void *bi_private)
+{
+	struct bio *bio = NULL;
+	int ret;
+
+	ret = __blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask, page,
+					&bio);
+	if (ret)
+		return ret;
+	bio->bi_end_io = bi_end_io;
+	bio->bi_private = bi_private;
+	submit_bio(bio);
+	return 0;
+}
+EXPORT_SYMBOL(blkdev_submit_write_same);
+
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned flags)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1aafeb923e7b..3d627e0a72c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1184,6 +1184,9 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
+extern int blkdev_submit_write_same(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, struct page *page,
+		bio_end_io_t bi_end_io, void *bi_private);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
 
-- 
2.22.0.410.gd8fdbe21b5-goog
