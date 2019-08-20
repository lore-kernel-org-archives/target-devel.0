From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 20 Aug 2019 14:02:35 +0000
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi device
Message-Id: <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
In-Reply-To: <20190820090429.1961085-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naohiro Aota <naohiro.aota@wdc.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K . Petersen" <martin.petersen@oracle.com>

On 8/20/19 2:04 AM, Naohiro Aota wrote:
> If there is no corresponding scsi_device for a LUN,
> tcm_loop_port_unlink() complains that it "Unable to locate struct
> scsi_device for " the device and keep %tl_tpg_port_count as is. However,
> such situation is legal when we delete a SCSI device using
> /sys/class/scsi_device/${lun}/device/delete. We can safely ignore the
> missing SCSI device case here.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 3305b47fdf53..0942f3bd7eec 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -654,16 +654,16 @@ static void tcm_loop_port_unlink(
>   
>   	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
>   				se_lun->unpacked_lun);
> -	if (!sd) {
> -		pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
> -		       0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
> -		return;
> +	if (sd) {
> +		/*
> +		 * Remove Linux/SCSI struct scsi_device by HCTL
> +		 */
> +		scsi_remove_device(sd);
> +		scsi_device_put(sd);
> +	} else {
> +		pr_debug("Unable to locate struct scsi_device for %d:%d:%llu\n",
> +			 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
>   	}
> -	/*
> -	 * Remove Linux/SCSI struct scsi_device by HCTL
> -	 */
> -	scsi_remove_device(sd);
> -	scsi_device_put(sd);
>   
>   	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);

The above patch looks wrong to me. I think this patch does not fix the 
reference leak present in the current code. Have you considered to 
modify tcm_loop_port_link() such that it saves the pointer returned by 
scsi_add_device() and to use that pointer in tcm_loop_port_unlink()?

Bart.
