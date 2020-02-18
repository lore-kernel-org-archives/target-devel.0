From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 18 Feb 2020 18:18:51 +0000
Subject: Re: [PATCH] scsi: target: fix unmap_zeroes_data boolean initialisation
Message-Id: <9ae08fa6-ebfe-4488-df32-5d34122c68bd@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200218180546.21313-1-ddiss@suse.de>
In-Reply-To: <20200218180546.21313-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2/18/20 10:05 AM, David Disseldorp wrote:
> The LIO unmap_zeroes_data device attribute is mapped to the LBPRZ flag in
> the READ CAPACITY (16) and Thin Provisioning VPD INQUIRY responses.
> It's exposed via configfs, where any write value is correctly validated
> via strtobool(), defaults to 0. However, when initialised via
> target_configure_unmap_from_queue() it takes the value of the device's
> max_write_zeroes_sectors queue limit, which is non-boolean.
> 
> Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_device.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 2d19f0e332b0..2c7ba2f7e13c 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -829,7 +829,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
>   	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
>   	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
>   								block_size;
> -	attrib->unmap_zeroes_data = (q->limits.max_write_zeroes_sectors);
> +	attrib->unmap_zeroes_data = !!(q->limits.max_write_zeroes_sectors);
>   	return true;
>   }
>   EXPORT_SYMBOL(target_configure_unmap_from_queue);

Hi David,

How about changing the datatype of unmap_zeroes_data from 'int' into 
'bool'? I think that change would have the same effect as this patch and 
additionally would make it clear that 'true' and 'false' are the only 
allowed variables for that struct member.

Thanks,

Bart.
