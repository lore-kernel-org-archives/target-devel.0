From: David Disseldorp <ddiss@suse.de>
Date: Wed, 03 Jan 2018 12:25:24 +0000
Subject: Re: [RFC PATCH] target: enable discard if supported by underlying block device
Message-Id: <20180103132524.46098356@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20171219134517.17296-1-ddiss@suse.de>
In-Reply-To: <20171219134517.17296-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Ping, any thoughts on this one? I think it makes sense to enable unmap
in this case.

Cheers, David

On Tue, 19 Dec 2017 14:45:17 +0100, David Disseldorp wrote:

> The initial commit of LIO (v4.0.0-rc6) came with support for SCSI UNMAP
> disabled. This was justified in the LIO wiki with:
>   Many SATA SSDs have issues handling UNMAP properly, so it is disabled
>   per default in LIO.
> Since this time, some critical discard bugs have been fixed, e.g.
> f3f5da624e0a ("block: Do a full clone when splitting discard bios").
> 
> Block layer backed logical units are capable of deferring to the block
> layer when determining UNMAP attributes, but this logic currently leaves
> the emulate_tpu (UNMAP) and emulate_tpws (WRITE_SAME with UNMAP=1) flags
> disabled.
> With this change, emulate_tpu and emulate_tpws are set for block layer
> backed logical units based on underlying block device discard support.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index e8dd6da164b2..65dab7c2460a 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -856,6 +856,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
>  	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
>  								block_size;
>  	attrib->unmap_zeroes_data = (q->limits.max_write_zeroes_sectors);
> +	attrib->emulate_tpu = 1;
> +	attrib->emulate_tpws = 1;
>  	return true;
>  }
>  EXPORT_SYMBOL(target_configure_unmap_from_queue);

