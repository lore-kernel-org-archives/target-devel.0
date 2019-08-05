From: Mike Christie <mchristi@redhat.com>
Date: Mon, 05 Aug 2019 16:33:26 +0000
Subject: Re: [PATCH] scsi: target/tcm_loop: update upper limit of LUN
Message-Id: <5D485A56.9070208@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190805062313.343221-1-naohiro.aota@wdc.com>
In-Reply-To: <20190805062313.343221-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/05/2019 01:23 AM, Naohiro Aota wrote:
> targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
> 65535. On the other hand, the kernel driver is limiting max_lun to 0.
> 
> This limitation causes an actual problem when you delete a loopback device
> (using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
> /sys/class/scsi_host/host${h}/scan). You can delete the device, but cannot
> rescan it because its LUN is larger than the max_lun and so the scan
> request results in -EINVAL error in scsi_scan_host_selected().

How are you kicking off this rescan?

Just to make sure I understood you, does the initial LU have LUN 0, you
delete that, then are you creating another LU with a LUN value that is
not 0?

Is it rtslib that is giving the new LU a LUN that is not 0?

> 
> This commit fix the upper limit to be as same as rtslib-fb allows.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>  drivers/target/loopback/tcm_loop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 3305b47fdf53..3db541ad727d 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -336,10 +336,10 @@ static int tcm_loop_driver_probe(struct device *dev)
>  	 */
>  	*((struct tcm_loop_hba **)sh->hostdata) = tl_hba;
>  	/*
> -	 * Setup single ID, Channel and LUN for now..
> +	 * Setup single ID, and Channel for now..
>  	 */
>  	sh->max_id = 2;
> -	sh->max_lun = 0;
> +	sh->max_lun = 65536;
>  	sh->max_channel = 0;
>  	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>  
> 
