From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 21 Mar 2018 18:47:02 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180321184702.GA11249@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Mar 21, 2018 at 11:16:09AM -0700, Andrei Vagin wrote:
> If we look at lo_rw_aio, we can find that bvec can be allocated or got
> from bio. I think the problem with the second case.
> 
> static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>                      loff_t pos, bool rw)
> {
> ...
>         if (rq->bio != rq->biotail) {
> 		...
>                 bvec = kmalloc(sizeof(struct bio_vec) * segments,
> GFP_NOIO);
> 		...
> 	} else {
> 		...
>                 bvec = __bvec_iter_bvec(bio->bi_io_vec,
> bio->bi_iter);

That is the local 'bvec' variable, not cmd->bvec which is only
assigned to the kmalloc return value.

> BTW: I tried your patch and I still get the same kasan warning.

Strange, as the trace can't really happen with the patch applied.
In fact the ->bvec field isn't even needed, e.g. we should do something
like this on top of the previous patch:

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9cb6078cd4f0..0401fade3d60 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -477,7 +477,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		     loff_t pos, bool rw)
 {
 	struct iov_iter iter;
-	struct bio_vec *bvec;
+	struct bio_vec *bvec, *alloc_bvec = NULL;
 	struct request *rq = cmd->rq;
 	struct bio *bio = rq->bio;
 	struct file *file = lo->lo_backing_file;
@@ -491,10 +491,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 
 		__rq_for_each_bio(bio, rq)
 			segments += bio_segments(bio);
-		bvec = kmalloc(sizeof(struct bio_vec) * segments, GFP_NOIO);
-		if (!bvec)
+		alloc_bvec = kmalloc_array(segments,
+				sizeof(struct bio_vec), GFP_NOIO);
+		if (!alloc_bvec)
 			return -EIO;
-		cmd->bvec = bvec;
 
 		/*
 		 * The bios of the request may be started from the middle of
@@ -502,11 +502,12 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
 		 * API will take care of all details for us.
 		 */
+		bvec = alloc_bvec;
 		rq_for_each_segment(tmp, rq, iter) {
 			*bvec = tmp;
 			bvec++;
 		}
-		bvec = cmd->bvec;
+		bvec = alloc_bvec;
 		offset = 0;
 	} else {
 		/*
@@ -535,12 +536,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	else
 		ret = call_read_iter(file, &cmd->iocb, &iter);
 
-	/*
-	 * Clear bvec to NULL as lo_rw_aio only allocates and sets it for
-	 * the multiple bios per request case and we want a clean slate here.
-	 */
-	kfree(cmd->bvec);
-	cmd->bvec = NULL;
+	kfree(alloc_bvec);
 	kthread_associate_blkcg(NULL);
 
 	if (ret != -EIOCBQUEUED)
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index ba65848c7c33..b8eef1977f64 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -70,7 +70,6 @@ struct loop_cmd {
 	bool use_aio; /* use AIO interface to handle I/O */
 	long ret;
 	struct kiocb iocb;
-	struct bio_vec *bvec;
 	struct cgroup_subsys_state *css;
 };
 
