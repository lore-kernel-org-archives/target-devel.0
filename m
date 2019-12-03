From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 03 Dec 2019 12:45:58 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191203124558.GA22805@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p>
 <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
 <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
 <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
In-Reply-To: <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>

On Mon, Dec 02, 2019 at 10:50:32PM -0500, Stephen Rust wrote:
> Hi,
> 
> Another datapoint.
> 
> I enabled "isert_debug" tracing and re-ran the test. Here is a small
> snippet of the debug data. FWIW, the "length of 76" in the "lkey
> mismatch" is a pattern that repeats quite often during the exchange.

That is because ISER_HEADERS_LEN is 76.

From our trace, 76 is bvec->bv_offset, is it possible that IO buffer
just follows the ISER HEADER suppose that iser applies zero-copy?

BTW, you may try the attached test patch. If the issue can be fixed by
this patch, that means it is really caused by un-aligned buffer, and
the iser driver needs to be fixed.

From 0368ee8a756384116fa1d0415f51389d438a6e40 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 3 Dec 2019 20:00:53 +0800
Subject: [PATCH] brd: handle un-aligned bvec->bv_len

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/brd.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c548a5a6c1a0..9ea1894c820d 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -190,13 +190,15 @@ static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
  * Copy n bytes from src to the brd starting at sector. Does not sleep.
  */
 static void copy_to_brd(struct brd_device *brd, const void *src,
-			sector_t sector, size_t n)
+			sector_t sector, unsigned off_in_sec, size_t n)
 {
 	struct page *page;
 	void *dst;
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
+	offset += off_in_sec;
+
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
@@ -207,7 +209,7 @@ static void copy_to_brd(struct brd_device *brd, const void *src,
 
 	if (copy < n) {
 		src += copy;
-		sector += copy >> SECTOR_SHIFT;
+		sector += (copy + off_in_sec) >> SECTOR_SHIFT;
 		copy = n - copy;
 		page = brd_lookup_page(brd, sector);
 		BUG_ON(!page);
@@ -222,13 +224,15 @@ static void copy_to_brd(struct brd_device *brd, const void *src,
  * Copy n bytes to dst from the brd starting at sector. Does not sleep.
  */
 static void copy_from_brd(void *dst, struct brd_device *brd,
-			sector_t sector, size_t n)
+			sector_t sector, unsigned off_in_sec, size_t n)
 {
 	struct page *page;
 	void *src;
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
+	offset += off_in_sec;
+
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
@@ -240,7 +244,7 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
 
 	if (copy < n) {
 		dst += copy;
-		sector += copy >> SECTOR_SHIFT;
+		sector += (copy + off_in_sec) >> SECTOR_SHIFT;
 		copy = n - copy;
 		page = brd_lookup_page(brd, sector);
 		if (page) {
@@ -257,7 +261,7 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
  */
 static int brd_do_bvec(struct brd_device *brd, struct page *page,
 			unsigned int len, unsigned int off, unsigned int op,
-			sector_t sector)
+			sector_t sector, unsigned int off_in_sec)
 {
 	void *mem;
 	int err = 0;
@@ -270,11 +274,11 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 
 	mem = kmap_atomic(page);
 	if (!op_is_write(op)) {
-		copy_from_brd(mem + off, brd, sector, len);
+		copy_from_brd(mem + off, brd, sector, off_in_sec, len);
 		flush_dcache_page(page);
 	} else {
 		flush_dcache_page(page);
-		copy_to_brd(brd, mem + off, sector, len);
+		copy_to_brd(brd, mem + off, sector, off_in_sec, len);
 	}
 	kunmap_atomic(mem);
 
@@ -287,6 +291,7 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	struct brd_device *brd = bio->bi_disk->private_data;
 	struct bio_vec bvec;
 	sector_t sector;
+	unsigned offset_in_sec = 0;
 	struct bvec_iter iter;
 
 	sector = bio->bi_iter.bi_sector;
@@ -296,12 +301,14 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
+		unsigned int secs = len >> SECTOR_SHIFT;
 
 		err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
-				  bio_op(bio), sector);
+				  bio_op(bio), sector, offset_in_sec);
 		if (err)
 			goto io_error;
-		sector += len >> SECTOR_SHIFT;
+		sector += secs;
+		offset_in_sec = len - (secs << SECTOR_SHIFT);
 	}
 
 	bio_endio(bio);
@@ -319,7 +326,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 	if (PageTransHuge(page))
 		return -ENOTSUPP;
-	err = brd_do_bvec(brd, page, PAGE_SIZE, 0, op, sector);
+	err = brd_do_bvec(brd, page, PAGE_SIZE, 0, op, sector, 0);
 	page_endio(page, op_is_write(op), err);
 	return err;
 }
-- 
2.20.1


Thanks,
Ming
