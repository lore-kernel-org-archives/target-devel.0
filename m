From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 21 Mar 2018 07:23:40 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180321072340.GA29587@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

> I'm afraid this patch doesn't work, because we are not always allocate bvec,
> sometimes we get it from bio. In this case, we have to call
> blk_mq_complete_request after read_iter/write_iter.

The issue there is that we really need to NULL ->bvec after freeing it.
Which normally is an anti-pattern but seems to be needed here (and warrants
a comment).  Updated patch below:


From b8eed7302071023852c00f8296165c2e9bbc51f4 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Mar 2018 09:35:55 +0100
Subject: loop: remove loop_cmd refcounting

Instead of introducing an unneeded refcount free the bvec after calling
into ->read_iter and ->write_iter, which follows the the normal read/write
path conventions.

Fixes: 92d77332 ("block/loop: fix use after free")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 19 +++++++------------
 drivers/block/loop.h |  1 -
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ee62d2d517bf..9cb6078cd4f0 100644
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
@@ -545,7 +535,12 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	else
 		ret = call_read_iter(file, &cmd->iocb, &iter);
 
-	lo_rw_aio_do_completion(cmd);
+	/*
+	 * Clear bvec to NULL as lo_rw_aio only allocates and sets it for
+	 * the multiple bios per request case and we want a clean slate here.
+	 */
+	kfree(cmd->bvec);
+	cmd->bvec = NULL;
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

