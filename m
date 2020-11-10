From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 10 Nov 2020 23:08:04 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <4e336e71-2739-186d-1f8a-5a2f406aebdb@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <d7107857-ef7a-3c88-8146-a5e7abce5ce6@oracle.com>
 <840cb2fe-5642-78d0-e700-d3652021cb5d@redhat.com>
In-Reply-To: <840cb2fe-5642-78d0-e700-d3652021cb5d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, m.lombardi85@gmail.com

On 11/10/20 3:29 PM, Maurizio Lombardi wrote:
> 
> 
> Dne 28. 10. 20 v 21:37 Mike Christie napsal(a):
>>>
>>> Possible solutions that I can think of:
>>>
>>> - Make iscsit_release_commands_from_conn() wait for the abort task to finish
>>
>> Yeah you could set a completion in there then have aborted_task do the complete() call maybe?
>>
> 
> We could do something like this, what do you think?
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 067074ef50818..ffd3dbc53a42f 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -490,13 +490,16 @@ EXPORT_SYMBOL(iscsit_queue_rsp);
>   
>   void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   {
> +	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
> +
>   	spin_lock_bh(&conn->cmd_lock);
> -	if (!list_empty(&cmd->i_conn_node) &&
> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
> +	if (!list_empty(&cmd->i_conn_node))
>   		list_del_init(&cmd->i_conn_node);
>   	spin_unlock_bh(&conn->cmd_lock);
>   
>   	__iscsit_free_cmd(cmd, true);
> +	if (se_cmd && se_cmd->abrt_task_compl)
> +		complete(se_cmd->abrt_task_compl);
>   }
>   EXPORT_SYMBOL(iscsit_aborted_task);
>   
> @@ -4080,6 +4083,7 @@ int iscsi_target_rx_thread(void *arg)
>   
>   static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>   {
> +	DECLARE_COMPLETION_ONSTACK(compl);
>   	LIST_HEAD(tmp_list);
>   	struct iscsi_cmd *cmd = NULL, *cmd_tmp = NULL;
>   	struct iscsi_session *sess = conn->sess;
> @@ -4096,8 +4100,24 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>   
>   		if (se_cmd->se_tfo != NULL) {
>   			spin_lock_irq(&se_cmd->t_state_lock);
> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
> +				/*
> +				 * LIO's abort path owns the cleanup for this,
> +				 * so put it back on the list and let
> +				 * aborted_task handle it.
> +				 */
> +				list_move_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
> +				WARN_ON_ONCE(se_cmd->abrt_task_compl);
> +				se_cmd->abrt_task_compl = &compl;
> +			}
>   			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>   			spin_unlock_irq(&se_cmd->t_state_lock);
> +
> +			if (se_cmd->abrt_task_compl) {
> +				spin_unlock_bh(&conn->cmd_lock);
> +				wait_for_completion(&compl);
> +				spin_lock_bh(&conn->cmd_lock);

You can still hit your freed conn race I think. The aborted_task callout 
is not the last time we are referencing the iscsi cmd and conn. That 
code path still has to do the release_cmd callout for example. Once we 
get past this wait_for_completion the abort code path could be still 
running. If this iscsit_release_commands_from_conn completes first then 
we can hit your case where we free the conn before the abort code path 
has done release_cmd and we could hit that cmd->conn->sess reference.

I think if you do the complete in iscsit_release_cmd then we would not 
hit that issue.

There might be a second issue though. What happens if aborted_task ran 
first and deleted the cmd from the conn_cmd_list. It would then be 
running while iscsit_release_commands_from_conn is running. We would 
then not do the wait_for_completion above.


> +			}
>   		}
>   	}
>   	spin_unlock_bh(&conn->cmd_lock);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index db53a0d649da7..5611e6c00f18c 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1391,6 +1391,7 @@ void transport_init_se_cmd(
>   	init_completion(&cmd->t_transport_stop_comp);
>   	cmd->free_compl = NULL;
>   	cmd->abrt_compl = NULL;
> +	cmd->abrt_task_compl = NULL;
>   	spin_lock_init(&cmd->t_state_lock);
>   	INIT_WORK(&cmd->work, NULL);
>   	kref_init(&cmd->cmd_kref);
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 549947d407cfd..25cc451930281 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -491,6 +491,7 @@ struct se_cmd {
>   	struct list_head	se_cmd_list;
>   	struct completion	*free_compl;
>   	struct completion	*abrt_compl;
> +	struct completion	*abrt_task_compl;

This should be on the iscsi cmd since only iscsi uses it.

>   	const struct target_core_fabric_ops *se_tfo;
>   	sense_reason_t		(*execute_cmd)(struct se_cmd *);
>   	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
> 
