From: Andrei Vagin <avagin@virtuozzo.com>
Date: Wed, 21 Mar 2018 20:25:41 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180321202539.GA29800@outlook.office365.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Mar 21, 2018 at 11:47:02AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 21, 2018 at 11:16:09AM -0700, Andrei Vagin wrote:
> > If we look at lo_rw_aio, we can find that bvec can be allocated or got
> > from bio. I think the problem with the second case.
> > 
> > static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
> >                      loff_t pos, bool rw)
> > {
> > ...
> >         if (rq->bio != rq->biotail) {
> > 		...
> >                 bvec = kmalloc(sizeof(struct bio_vec) * segments,
> > GFP_NOIO);
> > 		...
> > 	} else {
> > 		...
> >                 bvec = __bvec_iter_bvec(bio->bi_io_vec,
> > bio->bi_iter);
> 
> That is the local 'bvec' variable, not cmd->bvec which is only
> assigned to the kmalloc return value.
> 
> > BTW: I tried your patch and I still get the same kasan warning.
> 
> Strange, as the trace can't really happen with the patch applied.

In the trace, we see that bvec is accessed from iov_iter_revert(), but it
has been already released. This means than bvec was not allocated in
lo_rw_aio(). In the third trace, we can see that this bvec was released
in lo_rw_aio_complete()->bio_endio(). This means that we used bvec from
bio.

 [  101.436741] Freed by task 693:
[  101.437187]  __kasan_slab_free+0x136/0x180
[  101.437790]  kmem_cache_free+0xc6/0x310
[  101.438360]  bio_put+0xdb/0xf0
[  101.438844]  bio_endio+0x23b/0x400
[  101.439385]  blk_update_request+0x12a/0x660
[  101.440139]  blk_mq_end_request+0x26/0x80
[  101.440724]  __blk_mq_complete_request+0x30a/0x400
[  101.441406]  blk_mq_complete_request+0x110/0x160
[  101.442071]  lo_rw_aio_complete+0xbe/0x240
[  101.442664]  fuse_aio_complete+0x177/0x220


Bellow you can find traces from the kernel with two last patches.

[  101.335363] =================================
[  101.339372] BUG: KASAN: use-after-free in iov_iter_revert+0xa7/0x440
[  101.340612] Read of size 4 at addr ffff8800b95003d0 by task loop0/697

[  101.342050] CPU: 0 PID: 697 Comm: loop0 Not tainted 4.16.0-rc6-00035-g5b7b2f4a8aba #510
[  101.343481] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc26 04/01/2014
[  101.344762] Call Trace:
[  101.345140]  dump_stack+0xda/0x16f
[  101.345669]  ? _atomic_dec_and_lock+0x101/0x101
[  101.346394]  ? del_timer_sync+0xac/0xd0
[  101.347157]  print_address_description+0x6a/0x270
[  101.348014]  kasan_report+0x258/0x380
[  101.348671]  ? iov_iter_revert+0xa7/0x440
[  101.349511]  iov_iter_revert+0xa7/0x440
[  101.350362]  generic_file_read_iter+0xfd0/0x12f0
[  101.351224]  ? match_held_lock+0x7f/0x340
[  101.351958]  ? __save_stack_trace+0x82/0x100
[  101.352883]  ? filemap_range_has_page+0x1b0/0x1b0
[  101.353788]  ? ret_from_fork+0x3a/0x50
[  101.354716]  ? fuse_simple_request+0x1a7/0x280
[  101.355966]  ? save_stack+0x89/0xb0
[  101.356918]  ? find_held_lock+0x6d/0xd0
[  101.357735]  ? fuse_change_attributes+0x243/0x350
[  101.358676]  ? lock_downgrade+0x320/0x320
[  101.360030]  ? map_id_range_down+0x19a/0x1c0
[  101.361880]  ? do_raw_spin_unlock+0x147/0x220
[  101.363089]  ? do_raw_spin_trylock+0x100/0x100
[  101.363960]  ? do_raw_write_trylock+0x100/0x100
[  101.364816]  ? _raw_spin_unlock+0x24/0x30
[  101.365644]  ? fuse_change_attributes+0x32e/0x350
[  101.366567]  ? fuse_change_attributes_common+0x300/0x300
[  101.367539]  ? fuse_simple_request+0x1a7/0x280
[  101.368339]  ? fuse_simple_request+0x1a7/0x280
[  101.369173]  ? fuse_do_getattr+0x27b/0x6e0
[  101.369950]  ? fuse_dentry_revalidate+0x640/0x640
[  101.370822]  ? find_held_lock+0x6d/0xd0
[  101.371638]  ? lock_release+0x4f0/0x4f0
[  101.372351]  ? match_held_lock+0x7f/0x340
[  101.373130]  lo_rw_aio+0x942/0xd10
[  101.373841]  ? lo_rw_aio_complete+0x240/0x240
[  101.374665]  ? match_held_lock+0x7f/0x340
[  101.375413]  ? clear_buddies+0x42/0x210
[  101.376330]  ? debug_check_no_locks_freed+0x1b0/0x1b0
[  101.377266]  ? finish_task_switch+0x181/0x500
[  101.378099]  ? do_raw_spin_unlock+0x147/0x220
[  101.378872]  loop_queue_work+0x10aa/0x1900
[  101.379635]  ? _raw_spin_unlock_irq+0x29/0x40
[  101.380268]  ? _raw_spin_unlock_irq+0x29/0x40
[  101.380902]  ? finish_task_switch+0x181/0x500
[  101.381534]  ? finish_task_switch+0x10d/0x500
[  101.382165]  ? lo_compat_ioctl+0xe0/0xe0
[  101.382754]  ? set_load_weight+0x110/0x110
[  101.383503]  ? __switch_to_asm+0x34/0x70
[  101.384211]  ? __switch_to_asm+0x34/0x70
[  101.384920]  ? __switch_to_asm+0x40/0x70
[  101.385628]  ? __switch_to_asm+0x34/0x70
[  101.386713]  ? __switch_to_asm+0x40/0x70
[  101.387564]  ? __switch_to_asm+0x34/0x70
[  101.389006]  ? __switch_to_asm+0x40/0x70
[  101.389927]  ? __switch_to_asm+0x34/0x70
[  101.390752]  ? __switch_to_asm+0x40/0x70
[  101.391522]  ? __switch_to_asm+0x34/0x70
[  101.392687]  ? __switch_to_asm+0x40/0x70
[  101.394136]  ? __switch_to_asm+0x34/0x70
[  101.394955]  ? __switch_to_asm+0x40/0x70
[  101.395532]  ? __switch_to_asm+0x34/0x70
[  101.396092]  ? __switch_to_asm+0x40/0x70
[  101.396673]  ? __schedule+0x50e/0x11b0
[  101.397241]  ? mark_held_locks+0x1c/0x90
[  101.397896]  ? _raw_spin_unlock_irq+0x29/0x40
[  101.398839]  ? match_held_lock+0x7f/0x340
[  101.399564]  ? save_trace+0x1e0/0x1e0
[  101.400233]  ? finish_task_switch+0x181/0x500
[  101.401026]  ? finish_task_switch+0x10d/0x500
[  101.401818]  ? __switch_to_asm+0x34/0x70
[  101.402536]  ? __switch_to_asm+0x34/0x70
[  101.403255]  ? set_load_weight+0x110/0x110
[  101.403996]  ? __switch_to_asm+0x34/0x70
[  101.404730]  ? __switch_to_asm+0x34/0x70
[  101.405424]  ? __switch_to_asm+0x40/0x70
[  101.406150]  ? find_held_lock+0x6d/0xd0
[  101.406869]  ? kthread_worker_fn+0x229/0x520
[  101.407635]  ? lock_downgrade+0x320/0x320
[  101.408356]  ? do_raw_spin_unlock+0x147/0x220
[  101.409316]  ? do_raw_spin_trylock+0x100/0x100
[  101.409969]  ? rcu_note_context_switch+0x4e0/0x4e0
[  101.410729]  ? match_held_lock+0x7f/0x340
[  101.411440]  ? mark_held_locks+0x1c/0x90
[  101.412150]  ? _raw_spin_unlock_irq+0x29/0x40
[  101.412959]  kthread_worker_fn+0x272/0x520
[  101.413648]  ? kthread+0x1e0/0x1e0
[  101.414482]  ? find_held_lock+0x6d/0xd0
[  101.415400]  ? lock_downgrade+0x320/0x320
[  101.416319]  ? __schedule+0x11b0/0x11b0
[  101.417130]  ? do_raw_spin_unlock+0x147/0x220
[  101.417847]  ? do_raw_spin_trylock+0x100/0x100
[  101.418560]  ? __lockdep_init_map+0x98/0x2a0
[  101.419446]  ? __init_waitqueue_head+0xbe/0xf0
[  101.420333]  ? mark_held_locks+0x1c/0x90
[  101.421444]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[  101.422726]  ? loop_get_status64+0x100/0x100
[  101.423629]  kthread+0x1b7/0x1e0
[  101.424212]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  101.425137]  ret_from_fork+0x3a/0x50

[  101.426481] Allocated by task 699:
[  101.427260]  kasan_kmalloc+0xa0/0xd0
[  101.427986]  kmem_cache_alloc+0xca/0x2d0
[  101.428659]  mempool_alloc+0x117/0x2f0
[  101.429330]  bio_alloc_bioset+0x34d/0x4a0
[  101.430147]  mpage_alloc.isra.8+0x45/0x110
[  101.430652]  do_mpage_readpage+0xa70/0xc60
[  101.431158]  mpage_readpages+0x2d1/0x400
[  101.431688]  __do_page_cache_readahead+0x528/0x740
[  101.432381]  force_page_cache_readahead+0x10b/0x170
[  101.433091]  generic_file_read_iter+0xeb2/0x12f0
[  101.433763]  __vfs_read+0x2a9/0x3c0
[  101.434288]  vfs_read+0xb7/0x1b0
[  101.434759]  SyS_read+0xb6/0x140
[  101.435231]  do_syscall_64+0x193/0x470
[  101.435786]  entry_SYSCALL_64_after_hwframe+0x42/0xb7

[  101.436741] Freed by task 693:
[  101.437187]  __kasan_slab_free+0x136/0x180
[  101.437790]  kmem_cache_free+0xc6/0x310
[  101.438360]  bio_put+0xdb/0xf0
[  101.438844]  bio_endio+0x23b/0x400
[  101.439385]  blk_update_request+0x12a/0x660
[  101.440139]  blk_mq_end_request+0x26/0x80
[  101.440724]  __blk_mq_complete_request+0x30a/0x400
[  101.441406]  blk_mq_complete_request+0x110/0x160
[  101.442071]  lo_rw_aio_complete+0xbe/0x240
[  101.442664]  fuse_aio_complete+0x177/0x220
[  101.443241]  request_end+0x237/0x470
[  101.443814]  fuse_dev_do_write+0x1325/0x1910
[  101.444477]  fuse_dev_write+0x11d/0x180
[  101.445037]  do_iter_readv_writev+0x2a5/0x370
[  101.445663]  do_iter_write+0xd1/0x280
[  101.446187]  vfs_writev+0x145/0x230
[  101.446690]  do_writev+0xc0/0x1b0
[  101.447170]  do_syscall_64+0x193/0x470
[  101.447711]  entry_SYSCALL_64_after_hwframe+0x42/0xb7

[  101.448672] The buggy address belongs to the object at ffff8800b9500340
                which belongs to the cache bio-0 of size 200
[  101.450534] The buggy address is located 144 bytes inside of
                200-byte region [ffff8800b9500340, ffff8800b9500408)
[  101.452229] The buggy address belongs to the page:
[  101.452939] page:ffffea0002e54000 count:1 mapcount:0 mapping:0000000000000000 index:0xffff8800b95004c0 compound_mapcount: 0
[  101.454468] flags: 0x1fffc000008100(slab|head)
[  101.455149] raw: 001fffc000008100 0000000000000000 ffff8800b95004c0 0000000100150006
[  101.456525] raw: ffffea00045105a0 ffff8801198e2580 ffff880119a58700 0000000000000000
[  101.457560] page dumped because: kasan: bad access detected

[  101.458526] Memory state around the buggy address:
[  101.459174]  ffff8800b9500280: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  101.460319]  ffff8800b9500300: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[  101.461412] >ffff8800b9500380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  101.462647]                                                  ^
[  101.463898]  ffff8800b9500400: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  101.465217]  ffff8800b9500480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  101.466250] =================================
[  101.467443] Disabling lock debugging due to kernel taint


> In fact the ->bvec field isn't even needed, e.g. we should do something
> like this on top of the previous patch:

I said this in a previous mail ;)

> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 9cb6078cd4f0..0401fade3d60 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -477,7 +477,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		     loff_t pos, bool rw)
>  {
>  	struct iov_iter iter;
> -	struct bio_vec *bvec;
> +	struct bio_vec *bvec, *alloc_bvec = NULL;
>  	struct request *rq = cmd->rq;
>  	struct bio *bio = rq->bio;
>  	struct file *file = lo->lo_backing_file;
> @@ -491,10 +491,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  
>  		__rq_for_each_bio(bio, rq)
>  			segments += bio_segments(bio);
> -		bvec = kmalloc(sizeof(struct bio_vec) * segments, GFP_NOIO);
> -		if (!bvec)
> +		alloc_bvec = kmalloc_array(segments,
> +				sizeof(struct bio_vec), GFP_NOIO);
> +		if (!alloc_bvec)
>  			return -EIO;
> -		cmd->bvec = bvec;
>  
>  		/*
>  		 * The bios of the request may be started from the middle of
> @@ -502,11 +502,12 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
>  		 * API will take care of all details for us.
>  		 */
> +		bvec = alloc_bvec;
>  		rq_for_each_segment(tmp, rq, iter) {
>  			*bvec = tmp;
>  			bvec++;
>  		}
> -		bvec = cmd->bvec;
> +		bvec = alloc_bvec;
>  		offset = 0;
>  	} else {
>  		/*
> @@ -535,12 +536,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  	else
>  		ret = call_read_iter(file, &cmd->iocb, &iter);
>  
> -	/*
> -	 * Clear bvec to NULL as lo_rw_aio only allocates and sets it for
> -	 * the multiple bios per request case and we want a clean slate here.
> -	 */
> -	kfree(cmd->bvec);
> -	cmd->bvec = NULL;
> +	kfree(alloc_bvec);
>  	kthread_associate_blkcg(NULL);
>  
>  	if (ret != -EIOCBQUEUED)
> diff --git a/drivers/block/loop.h b/drivers/block/loop.h
> index ba65848c7c33..b8eef1977f64 100644
> --- a/drivers/block/loop.h
> +++ b/drivers/block/loop.h
> @@ -70,7 +70,6 @@ struct loop_cmd {
>  	bool use_aio; /* use AIO interface to handle I/O */
>  	long ret;
>  	struct kiocb iocb;
> -	struct bio_vec *bvec;
>  	struct cgroup_subsys_state *css;
>  };
>  
