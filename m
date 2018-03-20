From: Andrei Vagin <avagin@virtuozzo.com>
Date: Tue, 20 Mar 2018 07:54:58 +0000
Subject: Re: [PATCH] [RFC] target/file: add support of direct and async I/O
Message-Id: <20180320075456.GA11151@outlook.office365.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180309004259.16052-1-avagin@openvz.org>
In-Reply-To: <20180309004259.16052-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, Mar 16, 2018 at 12:50:27AM -0700, Christoph Hellwig wrote:
> > DIF (PI) emulation doesn't work when a target uses async I/O, because
> > DIF metadata is saved in a separate file, and it is another non-trivial
> > task how to synchronize writing in two files, so that a following read
> > operation always returns a consisten metadata for a specified block.
> 
> There literally is no way to do that, even without aio.  The file
> DIF implementation should probably regarded as an early bringup /
> prototype tool, not something really usable.
> 
> > +static void cmd_rw_aio_do_completion(struct target_core_file_cmd *cmd)
> > +{
> > +	if (!atomic_dec_and_test(&cmd->ref))
> > +		return;
> 
> There is no need for reference counting.  If the read_iter/write iter
> method returns -EIOCBQUEUED the completion callback needs to complete
> the I/O and free the structure, else the method caller.

I was near to send a final version, but I decided to investigate how a
reference counter was appeared in drivers/block/loop.c:

commit 92d773324b7edbd36bf0c28c1e0157763aeccc92
Author: Shaohua Li <shli@fb.com>
Date:   Fri Sep 1 11:15:17 2017 -0700

    block/loop: fix use after free
    
    lo_rw_aio->call_read_iter->
    1       aops->direct_IO
    2       iov_iter_revert
    lo_rw_aio_complete could happen between 1 and 2, the bio and bvec
could
    be freed before 2, which accesses bvec.
    
    Signed-off-by: Shaohua Li <shli@fb.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

This commit looks reasonable, doesn't it? In out case, bvec-s are
freed from the callback too.

> 
> > +	if (!(fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE))
> > +		aio_cmd->iocb.ki_flags |= IOCB_DIRECT;
> 
> aio without IOCB_DIRECT doesn't make any sense. But the WCE flag
> really has nothing to do with buffers vs direct I/O anyway.
> 
> > +	if (is_write)
> > +		ret = call_write_iter(file, &aio_cmd->iocb, &iter);
> > +	else
> > +		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
> 
> Please call the methods directly instead of through the wrappers.
> 
> > +
> >  static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
> >  		    u32 block_size, struct scatterlist *sgl,
> >  		    u32 sgl_nents, u32 data_length, int is_write)
> > @@ -536,6 +626,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> >  	struct file *pfile = fd_dev->fd_prot_file;
> >  	sense_reason_t rc;
> >  	int ret = 0;
> > +	int aio = fd_dev->fbd_flags & FDBD_HAS_ASYNC_IO;
> >  	/*
> >  	 * We are currently limited by the number of iovecs (2048) per
> >  	 * single vfs_[writev,readv] call.
> > @@ -550,7 +641,11 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> >  	 * Call vectorized fileio functions to map struct scatterlist
> >  	 * physical memory addresses to struct iovec virtual memory.
> >  	 */
> > -	if (data_direction = DMA_FROM_DEVICE) {
> > +	if (aio) {
> 
> fd_execute_rw shares basically no code with the aio case.  I'd rather
> have a very high level wrapper here:
> 
> static sense_reason_t
> fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> 		enum dma_data_direction data_direction)
> {
> 	if (FD_DEV(cmd->se_dev)->fbd_flags & FDBD_HAS_ASYNC_IO)
> 		return fd_execute_rw_aio(cmd, sgl, sgl_nents, dma_direction);
> 	return fd_execute_rw_buffered(cmd, sgl, sgl_nents, dma_direction);
> }
> 
> and keep the code separate.
> 
