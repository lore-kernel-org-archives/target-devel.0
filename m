From: David Disseldorp <ddiss@suse.de>
Date: Mon, 05 Nov 2018 17:55:23 +0000
Subject: Re: [PATCH] target/core: Make it safe to pass NULL as third argument to compare_and_write_callback()
Message-Id: <20181105185523.725d91d6@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181105172317.248955-1-bvanassche@acm.org>
In-Reply-To: <20181105172317.248955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Bart,

On Mon,  5 Nov 2018 09:23:17 -0800, Bart Van Assche wrote:

> Fixes: aa73237dcb2d ("scsi: target/core: Always call transport_complete_callback() upon failure")
...
> This patch fixes a bug that was introduced during the merge window. Please consider
> this patch for a v4.20-rc<n> kernel.
> 
>  drivers/target/target_core_sbc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 1ac1f7d2e6c9..7c8433e32906 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -480,7 +480,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>  	if (cmd->scsi_status) {
>  		pr_debug("compare_and_write_callback: non zero scsi_status:"
>  			" 0x%02x\n", cmd->scsi_status);
> -		*post_ret = 1;
> +		if (post_ret)
> +			*post_ret = 1;
>  		if (cmd->scsi_status = SAM_STAT_CHECK_CONDITION)
>  			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		goto out;

IIUC, this still leaves compare_and_write_post() with a potential NULL
post_ret deref. My preference would be to just go back to having the
unused variable provided by the transport_generic_request_failure()
caller.

Cheers, David
