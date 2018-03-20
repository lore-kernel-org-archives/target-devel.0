From: Andrei Vagin <avagin@virtuozzo.com>
Date: Tue, 20 Mar 2018 20:41:01 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180320204100.GA31300@outlook.office365.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Mar 20, 2018 at 01:47:01AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 20, 2018 at 12:54:58AM -0700, Andrei Vagin wrote:
> > commit 92d773324b7edbd36bf0c28c1e0157763aeccc92
> > Author: Shaohua Li <shli@fb.com>
> > Date:   Fri Sep 1 11:15:17 2017 -0700
> > 
> >     block/loop: fix use after free
> >     
> >     lo_rw_aio->call_read_iter->
> >     1       aops->direct_IO
> >     2       iov_iter_revert
> >     lo_rw_aio_complete could happen between 1 and 2, the bio and bvec
> > could
> >     be freed before 2, which accesses bvec.
> >     
> >     Signed-off-by: Shaohua Li <shli@fb.com>
> >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> > This commit looks reasonable, doesn't it? In out case, bvec-s are
> > freed from the callback too.
> 
> It looks completely bogus, but it papers over a valid issue. The
> iovec/bvec passed to ->read_iter/->write_iter is caller allocated
> and freed, so we should always free it after the calls.  The actual
> I/O completion is separate from that.  Below is the real fix for the
> loop driver:

I'm afraid this patch doesn't work, because we are not always allocate bvec,
sometimes we get it from bio. In this case, we have to call
blk_mq_complete_request after read_iter/write_iter.

[  102.559165] =================================
[  102.560396] BUG: KASAN: use-after-free in iov_iter_revert+0xa7/0x440
[  102.561331] Read of size 4 at addr ffff880111704850 by task loop0/690

[  102.562501] CPU: 1 PID: 690 Comm: loop0 Not tainted 4.16.0-rc6-00030-gcf309ac88b27-dirty #503
[  102.563768] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc26 04/01/2014
[  102.564999] Call Trace:
[  102.565370]  dump_stack+0xda/0x16f
[  102.565857]  ? _atomic_dec_and_lock+0x101/0x101
[  102.566508]  ? del_timer_sync+0xac/0xd0
[  102.567203]  print_address_description+0x6a/0x270
[  102.567963]  kasan_report+0x258/0x380
[  102.568572]  ? iov_iter_revert+0xa7/0x440
[  102.569243]  iov_iter_revert+0xa7/0x440
[  102.569879]  generic_file_read_iter+0xfd0/0x12f0
[  102.570646]  ? match_held_lock+0x7f/0x340
[  102.571257]  ? __save_stack_trace+0x82/0x100
[  102.571909]  ? filemap_range_has_page+0x1b0/0x1b0
[  102.572562]  ? ret_from_fork+0x3a/0x50
[  102.573102]  ? fuse_simple_request+0x1a7/0x280
[  102.573760]  ? save_stack+0x89/0xb0
[  102.574305]  ? find_held_lock+0x6d/0xd0
[  102.574985]  ? fuse_change_attributes+0x243/0x350
[  102.576072]  ? lock_downgrade+0x320/0x320
[  102.576855]  ? map_id_range_down+0x19a/0x1c0
[  102.577685]  ? do_raw_spin_unlock+0x147/0x220
[  102.578657]  ? do_raw_spin_trylock+0x100/0x100
[  102.579464]  ? do_raw_write_trylock+0x100/0x100
[  102.580304]  ? _raw_spin_unlock+0x24/0x30
[  102.581014]  ? fuse_change_attributes+0x32e/0x350
[  102.581854]  ? fuse_change_attributes_common+0x300/0x300
[  102.582810]  ? fuse_simple_request+0x1a7/0x280
[  102.583600]  ? fuse_simple_request+0x1a7/0x280
[  102.584415]  ? fuse_do_getattr+0x27b/0x6e0
[  102.585149]  ? fuse_dentry_revalidate+0x640/0x640
[  102.585913]  ? find_held_lock+0x6d/0xd0
[  102.586763]  ? lock_release+0x4f0/0x4f0
[  102.587634]  ? match_held_lock+0x7f/0x340
[  102.588854]  lo_rw_aio+0x928/0xd20
[  102.589517]  ? save_trace+0x1e0/0x1e0
[  102.590141]  ? lo_compat_ioctl+0xe0/0xe0
[  102.590888]  ? clear_buddies+0x42/0x210
[  102.591650]  ? debug_check_no_locks_freed+0x1b0/0x1b0
[  102.592611]  ? finish_task_switch+0x181/0x500
[  102.593496]  ? do_raw_spin_unlock+0x147/0x220
[  102.594387]  loop_queue_work+0x10aa/0x1900
[  102.595191]  ? _raw_spin_unlock_irq+0x29/0x40
[  102.596229]  ? _raw_spin_unlock_irq+0x29/0x40
[  102.597865]  ? finish_task_switch+0x181/0x500
[  102.599310]  ? finish_task_switch+0x1d5/0x500
[  102.600118]  ? lo_rw_aio+0xd20/0xd20
[  102.600760]  ? set_load_weight+0x110/0x110
[  102.601465]  ? __switch_to_asm+0x34/0x70
[  102.602165]  ? __switch_to_asm+0x34/0x70
[  102.602867]  ? __switch_to_asm+0x40/0x70
[  102.603571]  ? __switch_to_asm+0x34/0x70
[  102.604279]  ? __switch_to_asm+0x40/0x70
[  102.604982]  ? __switch_to_asm+0x34/0x70
[  102.605856]  ? __switch_to_asm+0x40/0x70
[  102.606698]  ? __switch_to_asm+0x34/0x70
[  102.607473]  ? __switch_to_asm+0x34/0x70
[  102.608206]  ? __switch_to_asm+0x40/0x70
[  102.608980]  ? __switch_to_asm+0x34/0x70
[  102.609877]  ? __switch_to_asm+0x40/0x70
[  102.610632]  ? __switch_to_asm+0x34/0x70
[  102.611368]  ? __switch_to_asm+0x40/0x70
[  102.612074]  ? __schedule+0x50e/0x11b0
[  102.612791]  ? mark_held_locks+0x1c/0x90
[  102.613503]  ? _raw_spin_unlock_irq+0x29/0x40
[  102.614282]  ? match_held_lock+0x7f/0x340
[  102.615001]  ? save_trace+0x1e0/0x1e0
[  102.615661]  ? finish_task_switch+0x181/0x500
[  102.616434]  ? finish_task_switch+0x10d/0x500
[  102.617203]  ? __switch_to_asm+0x34/0x70
[  102.617902]  ? __switch_to_asm+0x34/0x70
[  102.618609]  ? set_load_weight+0x110/0x110
[  102.619350]  ? __switch_to_asm+0x34/0x70
[  102.620136]  ? __switch_to_asm+0x34/0x70
[  102.620859]  ? __switch_to_asm+0x40/0x70
[  102.621584]  ? find_held_lock+0x6d/0xd0
[  102.622328]  ? kthread_worker_fn+0x229/0x520
[  102.623033]  ? lock_downgrade+0x320/0x320
[  102.623683]  ? do_raw_spin_unlock+0x147/0x220
[  102.624443]  ? do_raw_spin_trylock+0x100/0x100
[  102.625550]  ? rcu_note_context_switch+0x4e0/0x4e0
[  102.626597]  ? match_held_lock+0x7f/0x340
[  102.627390]  ? mark_held_locks+0x1c/0x90
[  102.628016]  ? _raw_spin_unlock_irq+0x29/0x40
[  102.628732]  kthread_worker_fn+0x272/0x520
[  102.629429]  ? kthread+0x1e0/0x1e0
[  102.630110]  ? find_held_lock+0x6d/0xd0
[  102.630847]  ? lock_downgrade+0x320/0x320
[  102.631554]  ? __schedule+0x11b0/0x11b0
[  102.632222]  ? do_raw_spin_unlock+0x147/0x220
[  102.633128]  ? do_raw_spin_trylock+0x100/0x100
[  102.634013]  ? __lockdep_init_map+0x98/0x2a0
[  102.634845]  ? __init_waitqueue_head+0xbe/0xf0
[  102.635703]  ? mark_held_locks+0x1c/0x90
[  102.636315]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[  102.637063]  ? loop_get_status64+0x100/0x100
[  102.637695]  kthread+0x1b7/0x1e0
[  102.638243]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  102.639212]  ret_from_fork+0x3a/0x50

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

[  102.655537] The buggy address belongs to the object at ffff8801117047c0
                which belongs to the cache bio-0 of size 200
[  102.657169] The buggy address is located 144 bytes inside of
                200-byte region [ffff8801117047c0, ffff880111704888)
[  102.658773] The buggy address belongs to the page:
[  102.659459] page:ffffea000445c100 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
[  102.660947] flags: 0x2fffc000008100(slab|head)
[  102.661724] raw: 002fffc000008100 0000000000000000 0000000000000000 0000000100150015
[  102.662833] raw: dead000000000100 dead000000000200 ffff880119a58700 0000000000000000
[  102.663908] page dumped because: kasan: bad access detected

[  102.664948] Memory state around the buggy address:
[  102.665626]  ffff880111704700: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.666814]  ffff880111704780: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[  102.668278] >ffff880111704800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  102.669706]                                                  ^
[  102.670707]  ffff880111704880: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.672119]  ffff880111704900: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[  102.673514] =================================


> 
> ---
> From 101f857c5b67492cfd75212d104699813f1bd345 Mon Sep 17 00:00:00 2001
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
>  drivers/block/loop.c | 14 ++------------
>  drivers/block/loop.h |  1 -
>  2 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index ee62d2d517bf..2578a39640b8 100644
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
> @@ -545,7 +535,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  	else
>  		ret = call_read_iter(file, &cmd->iocb, &iter);
>  
> -	lo_rw_aio_do_completion(cmd);
> +	kfree(cmd->bvec);
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
