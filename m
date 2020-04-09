From: Mike Christie <mchristi@redhat.com>
Date: Thu, 09 Apr 2020 15:29:47 +0000
Subject: Re: [PATCH] target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Message-Id: <5E8F3F6B.3020408@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: martin.petersen@oracle.com

On 04/09/2020 05:10 AM, Bodo Stroesser wrote:
> In case command ring buffer becomes inconsistent, tcmu
> sets device flag TCMU_DEV_BIT_BROKEN.
> If the bit is set, tcmu rejects new commands from lio core
> with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer
> processes completions from the ring.
> The reset_ring attribute can be used to completely clean up
> the command ring, so after reset_ring the ring no longer is
> inconsistent.
> 
> Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN
> to allow normal processing.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_user.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 0b9dfa6b17bc..f769bb1e3735 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  	mb->cmd_tail = 0;
>  	mb->cmd_head = 0;
>  	tcmu_flush_dcache_range(mb, sizeof(*mb));
> +	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
>  
>  	del_timer(&udev->cmd_timer);
>  
> 

Acked-by: Mike Christie <mchristi@redhat.com>
