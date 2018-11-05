From: David Disseldorp <ddiss@suse.de>
Date: Mon, 05 Nov 2018 19:09:14 +0000
Subject: Re: [PATCH] target/core: Avoid that a kernel oops can be triggered when an XCOPY command fails
Message-Id: <20181105200914.7607f159@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181105184011.94041-1-bvanassche@acm.org>
In-Reply-To: <20181105184011.94041-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon,  5 Nov 2018 10:40:11 -0800, Bart Van Assche wrote:

> Fixes: aa73237dcb2d ("scsi: target/core: Always call transport_complete_callback() upon failure")
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: David Disseldorp <ddiss@suse.de>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_transport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index e31e4fc31aa1..2cfd61d62e97 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1778,7 +1778,7 @@ EXPORT_SYMBOL(target_submit_tmr);
>  void transport_generic_request_failure(struct se_cmd *cmd,
>  		sense_reason_t sense_reason)
>  {
> -	int ret = 0;
> +	int ret = 0, post_ret;
>  
>  	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
>  		 sense_reason);
> @@ -1790,7 +1790,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
>  	transport_complete_task_attr(cmd);
>  
>  	if (cmd->transport_complete_callback)
> -		cmd->transport_complete_callback(cmd, false, NULL);
> +		cmd->transport_complete_callback(cmd, false, &post_ret);
>  
>  	if (transport_check_aborted_status(cmd, 1))
>  		return;

Reviewed-by: David Disseldorp <ddiss@suse.de>
