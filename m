From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 20 Mar 2018 08:47:01 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180320084701.GA4241@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Mar 20, 2018 at 12:54:58AM -0700, Andrei Vagin wrote:
> commit 92d773324b7edbd36bf0c28c1e0157763aeccc92
> Author: Shaohua Li <shli@fb.com>
> Date:   Fri Sep 1 11:15:17 2017 -0700
> 
>     block/loop: fix use after free
>     
>     lo_rw_aio->call_read_iter->
>     1       aops->direct_IO
>     2       iov_iter_revert
>     lo_rw_aio_complete could happen between 1 and 2, the bio and bvec
> could
>     be freed before 2, which accesses bvec.
>     
>     Signed-off-by: Shaohua Li <shli@fb.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> This commit looks reasonable, doesn't it? In out case, bvec-s are
> freed from the callback too.

It looks completely bogus, but it papers over a valid issue. The
iovec/bvec passed to ->read_iter/->write_iter is caller allocated
and freed, so we should always free it after the calls.  The actual
I/O completion is separate from that.  Below is the real fix for the
loop driver:

---
From 101f857c5b67492cfd75212d104699813f1bd345 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Mar 2018 09:35:55 +0100
Subject: loop: remove loop_cmd refcounting

Instead of introducing an unneeded refcount free the bvec after calling
into ->read_iter and ->write_iter, which follows the the normal read/write
path conventions.

Fixes: 92d77332 ("block/loop: fix use after free")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 14 ++------------
 drivers/block/loop.h |  1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ee62d2d517bf..2578a39640b8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -463,15 +463,6 @@ static void lo_complete_rq(struct request *rq)
 	blk_mq_end_request(rq, cmd->ret < 0 ? BLK_STS_IOERR : BLK_STS_OK);
 }
 
-static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
-{
-	if (!atomic_dec_and_test(&cmd->ref))
-		return;
-	kfree(cmd->bvec);
-	cmd->bvec = NULL;
-	blk_mq_complete_request(cmd->rq);
-}
-
 static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
@@ -479,7 +470,7 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 	if (cmd->css)
 		css_put(cmd->css);
 	cmd->ret = ret;
-	lo_rw_aio_do_completion(cmd);
+	blk_mq_complete_request(cmd->rq);
 }
 
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
@@ -527,7 +518,6 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
 		segments = bio_segments(bio);
 	}
-	atomic_set(&cmd->ref, 2);
 
 	iov_iter_bvec(&iter, ITER_BVEC | rw, bvec,
 		      segments, blk_rq_bytes(rq));
@@ -545,7 +535,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	else
 		ret = call_read_iter(file, &cmd->iocb, &iter);
 
-	lo_rw_aio_do_completion(cmd);
+	kfree(cmd->bvec);
 	kthread_associate_blkcg(NULL);
 
 	if (ret != -EIOCBQUEUED)
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 0f45416e4fcf..ba65848c7c33 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -68,7 +68,6 @@ struct loop_cmd {
 	struct kthread_work work;
 	struct request *rq;
 	bool use_aio; /* use AIO interface to handle I/O */
-	atomic_t ref; /* only for aio */
 	long ret;
 	struct kiocb iocb;
 	struct bio_vec *bvec;
-- 
2.14.2

