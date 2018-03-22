From: Andrei Vagin <avagin@virtuozzo.com>
Date: Thu, 22 Mar 2018 21:19:42 +0000
Subject: Re: [PATCH v2] target/file: add support of direct and async I/O
Message-Id: <20180322211941.GB2809@outlook.office365.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180322065502.25569-1-avagin@openvz.org>
In-Reply-To: <20180322065502.25569-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Mar 22, 2018 at 10:34:34AM -0700, Christoph Hellwig wrote:
> > 
> > DIF (PI) emulation doesn't work when a target uses async I/O, because
> > DIF metadata is saved in a separate file, and it is another non-trivial
> > task how to synchronize writing in two files, so that a following read
> > operation always returns a consisten metadata for a specified block.
> 
> As said, this isn't really in any way aio specific.
> 
> > +	int is_write = !(data_direction = DMA_FROM_DEVICE);
> 
> 	bool is_write = data_direction != DMA_FROM_DEVICE;
> 
> > +	if (is_write && (cmd->se_cmd_flags & SCF_FUA))
> > +		aio_cmd->iocb.ki_flags |= IOCB_DSYNC;
> > +
> > +	if (is_write)
> > +		ret = call_write_iter(file, &aio_cmd->iocb, &iter);
> > +	else
> > +		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
> > +
> > +	kfree(bvec);
> 
> While this looks good to me this is the same pattern just said doesn't
> work in loop.  So it works here just fine?

Yes, it works here, because a bvec array is always allocated from our
code, so we fully controll its livetime. This way doesn't work in loop,
because sometimes we get a bvec array from bio, so its lifetime depeends
on bio, so we have to gurantee that bio will not be released while we are
using the bvec array.

Thank you for the help with this patch.

> 
> Otherwise this looks fine to me:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
