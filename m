From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 12 Jul 2020 00:49:23 +0000
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
Message-Id: <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> This patch modifies core_tmr_abort_task() to use same looping
> and locking scheme as core_tmr_drain_state_list() does.
> 
> This frees the state_list element in se_cmd for later use
> by tmr notification handling.
> 
> Note: __target_check_io_state() now is called with param 0
> instead of dev->dev_attrib.emulate_tas, because tas is not
> relevant since we always get ABRT on same session like the
> aborted command.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_tmr.c | 22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 89c84d472cd7..b65d7a0a5df1 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -116,14 +116,15 @@ void core_tmr_abort_task(
>   	struct se_tmr_req *tmr,
>   	struct se_session *se_sess)
>   {
> -	struct se_cmd *se_cmd;
> +	struct se_cmd *se_cmd, *next;
>   	unsigned long flags;
> +	bool rc;
>   	u64 ref_tag;
>   
> -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> +	spin_lock_irqsave(&dev->execute_task_lock, flags);
> +	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
>   
> -		if (dev != se_cmd->se_dev)
> +		if (se_sess != se_cmd->se_sess)
>   			continue;
>   
>   		/* skip task management functions, including tmr->task_cmd */
> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>   		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>   			se_cmd->se_tfo->fabric_name, ref_tag);
>   
> -		if (!__target_check_io_state(se_cmd, se_sess,
> -					     dev->dev_attrib.emulate_tas))
> +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> +		rc = __target_check_io_state(se_cmd, se_sess, 0);
> +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		if (!rc)
>   			continue;
>   
> -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +		list_del_init(&se_cmd->state_list);

Do we only want to do this if in the next patch tmr_notify can 
successfully accept the tmr?

If tmr_notify can't allocate memory for the abort case, we would delete 
it from the list. Later the initiator would send a LUN_RESET but 
core_tmr_drain_state_list won't see it and pass it to the tmr_notify call.

> +		se_cmd->state_active = false;
> +
> +		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
>   		/*
>   		 * Ensure that this ABORT request is visible to the LU RESET
> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>   		atomic_long_inc(&dev->aborts_complete);
>   		return;
>   	}
> -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>   
>   	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
>   			tmr->ref_task_tag);
> 
