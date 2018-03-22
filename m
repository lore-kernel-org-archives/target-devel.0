From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2018 18:27:05 +0000
Subject: Re: [PATCH v2] target/file: add support of direct and async I/O
Message-Id: <1e4519f2-e983-0744-12de-8a2d1461c178@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180322065502.25569-1-avagin@openvz.org>
In-Reply-To: <20180322065502.25569-1-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 3/22/18 12:34 PM, Christoph Hellwig wrote:

>> DIF (PI) emulation doesn't work when a target uses async I/O, because
>> DIF metadata is saved in a separate file, and it is another non-trivial
>> task how to synchronize writing in two files, so that a following read
>> operation always returns a consisten metadata for a specified block.
> As said, this isn't really in any way aio specific.
>
>> +	int is_write = !(data_direction = DMA_FROM_DEVICE);
> 	bool is_write = data_direction != DMA_FROM_DEVICE;
>
>> +	if (is_write && (cmd->se_cmd_flags & SCF_FUA))
>> +		aio_cmd->iocb.ki_flags |= IOCB_DSYNC;
>> +
>> +	if (is_write)
>> +		ret = call_write_iter(file, &aio_cmd->iocb, &iter);
>> +	else
>> +		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
>> +
>> +	kfree(bvec);
> While this looks good to me this is the same pattern just said doesn't
> work in loop.  So it works here just fine?
>
> Otherwise this looks fine to me:
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
This patch created the helpers for f_op->read/write:
https://patchwork.kernel.org/patch/9580365/

That patch was queued up for 4.11 so I guess if anyone tried to port this patch
back they would hit issues if they didn't use f_op.

Reviewed-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>

-Bryant

