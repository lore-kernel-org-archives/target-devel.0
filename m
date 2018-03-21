From: Andrei Vagin <avagin@virtuozzo.com>
Date: Wed, 21 Mar 2018 18:16:09 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180321181608.GA8446@outlook.office365.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Mar 21, 2018 at 12:23:40AM -0700, Christoph Hellwig wrote:
> > I'm afraid this patch doesn't work, because we are not always allocate bvec,
> > sometimes we get it from bio. In this case, we have to call
> > blk_mq_complete_request after read_iter/write_iter.
> 
> The issue there is that we really need to NULL ->bvec after freeing it.
> Which normally is an anti-pattern but seems to be needed here (and warrants
> a comment).  Updated patch below:

At first, I thought so too, but if we look at the kasan output, we can
find that this bvec was allocated in bio_alloc_bioset().

[  102.640354] Allocated by task 691:
[  102.641024]  kasan_kmalloc+0xa0/0xd0
[  102.641718]  kmem_cache_alloc+0xca/0x2d0
[  102.642375]  mempool_alloc+0x117/0x2f0
[  102.642946]  bio_alloc_bioset+0x34d/0x4a0
[  102.643516]  mpage_alloc.isra.8+0x45/0x110
[  102.644082]  do_mpage_readpage+0xa70/0xc60
[  102.644664]  mpage_readpages+0x2d1/0x400
[  102.645209]  __do_page_cache_readahead+0x528/0x740
[  102.645873]  force_page_cache_readahead+0x10b/0x170
[  102.646560]  generic_file_read_iter+0xeb2/0x12f0
[  102.647198]  __vfs_read+0x2a9/0x3c0
[  102.647705]  vfs_read+0xb7/0x1b0
[  102.648161]  SyS_read+0xb6/0x140
[  102.648619]  do_syscall_64+0x193/0x470
[  102.649142]  entry_SYSCALL_64_after_hwframe+0x42/0xb7

[  102.650063] Freed by task 693:
[  102.650502]  __kasan_slab_free+0x136/0x180
[  102.651074]  kmem_cache_free+0xc6/0x310
[  102.651711]  bio_put+0xdb/0xf0
[  102.652146]  bio_endio+0x23b/0x400
[  102.652672]  blk_update_request+0x12a/0x660
[  102.653252]  blk_mq_end_request+0x26/0x80
[  102.653826]  flush_smp_call_function_queue+0x23d/0x350
[  102.654544]  smp_call_function_single_interrupt+0xdc/0x460

If we look at lo_rw_aio, we can find that bvec can be allocated or got
from bio. I think the problem with the second case.

static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
                     loff_t pos, bool rw)
{
...
        if (rq->bio != rq->biotail) {
		...
                bvec = kmalloc(sizeof(struct bio_vec) * segments,
GFP_NOIO);
		...
	} else {
		...
                bvec = __bvec_iter_bvec(bio->bi_io_vec,
bio->bi_iter);

BTW: I tried your patch and I still get the same kasan warning.


> 
> 
> From b8eed7302071023852c00f8296165c2e9bbc51f4 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 20 Mar 2018 09:35:55 +0100
> Subject: loop: remove loop_cmd refcounting
> 
> Instead of introducing an unneeded refcount free the bvec after calling
> into ->read_iter and ->write_iter, which follows the the normal read/write
> path conventions.
> 
> Fixes: 92d77332 ("block/loop: fix use after free")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 19 +++++++------------
>  drivers/block/loop.h |  1 -
>  2 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index ee62d2d517bf..9cb6078cd4f0 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -463,15 +463,6 @@ static void lo_complete_rq(struct request *rq)
>  	blk_mq_end_request(rq, cmd->ret < 0 ? BLK_STS_IOERR : BLK_STS_OK);
>  }
>  
> -static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
> -{
> -	if (!atomic_dec_and_test(&cmd->ref))
> -		return;
> -	kfree(cmd->bvec);
> -	cmd->bvec = NULL;

You can remove bvec from loop_cmd, it was only a place out of lo_rw_aio
where it is used.


> -	blk_mq_complete_request(cmd->rq);
> -}
> -
>  static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
>  {
>  	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
> @@ -479,7 +470,7 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
>  	if (cmd->css)
>  		css_put(cmd->css);
>  	cmd->ret = ret;
> -	lo_rw_aio_do_completion(cmd);
> +	blk_mq_complete_request(cmd->rq);
>  }
>  
>  static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
> @@ -527,7 +518,6 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>  		segments = bio_segments(bio);
>  	}
> -	atomic_set(&cmd->ref, 2);
>  
>  	iov_iter_bvec(&iter, ITER_BVEC | rw, bvec,
>  		      segments, blk_rq_bytes(rq));
> @@ -545,7 +535,12 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  	else
>  		ret = call_read_iter(file, &cmd->iocb, &iter);
>  
> -	lo_rw_aio_do_completion(cmd);
> +	/*
> +	 * Clear bvec to NULL as lo_rw_aio only allocates and sets it for
> +	 * the multiple bios per request case and we want a clean slate here.
> +	 */
> +	kfree(cmd->bvec);
> +	cmd->bvec = NULL;
>  	kthread_associate_blkcg(NULL);
>  
>  	if (ret != -EIOCBQUEUED)
> diff --git a/drivers/block/loop.h b/drivers/block/loop.h
> index 0f45416e4fcf..ba65848c7c33 100644
> --- a/drivers/block/loop.h
> +++ b/drivers/block/loop.h
> @@ -68,7 +68,6 @@ struct loop_cmd {
>  	struct kthread_work work;
>  	struct request *rq;
>  	bool use_aio; /* use AIO interface to handle I/O */
> -	atomic_t ref; /* only for aio */
>  	long ret;
>  	struct kiocb iocb;
>  	struct bio_vec *bvec;
> -- 
> 2.14.2
> 
