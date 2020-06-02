From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 02 Jun 2020 22:00:23 +0000
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
Message-Id: <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com



On 6/2/20 1:33 PM, Sudhakar Panneerselvam wrote:
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index f2f7c5b818cc..4282fa98ff35 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1412,6 +1412,9 @@ void transport_init_se_cmd(
>   sense_reason_t
>   target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>   {
> +	sense_reason_t ret;
> +
> +	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
>   	/*
>   	 * Ensure that the received CDB is less than the max (252 + 8) bytes
>   	 * for VARIABLE_LENGTH_CMD
> @@ -1420,7 +1423,8 @@ void transport_init_se_cmd(
>   		pr_err("Received SCSI CDB with command_size: %d that"
>   			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
>   			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
> -		return TCM_INVALID_CDB_FIELD;
> +		ret = TCM_INVALID_CDB_FIELD;
> +		goto err;
>   	}
>   	/*
>   	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
> @@ -1435,10 +1439,10 @@ void transport_init_se_cmd(
>   				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
>   				scsi_command_size(cdb),
>   				(unsigned long)sizeof(cmd->__t_task_cdb));
> -			return TCM_OUT_OF_RESOURCES;
> +			ret = TCM_OUT_OF_RESOURCES;
> +			goto err;
>   		}
> -	} else
> -		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
> +	}
>   	/*
>   	 * Copy the original CDB into cmd->
>   	 */
> @@ -1446,6 +1450,13 @@ void transport_init_se_cmd(
>   
>   	trace_target_sequencer_start(cmd);
>   	return 0;
> +
> +err:
> +	/* Copy the CDB here to allow trace_target_cmd_complete() to

You should follow the coding style in the rest of the code. Do "/*" then 
start your text or do it all on one line if it fits:

/*
  * Copy the CDB here to allow trace_target_cmd_complete() to


> +	 * print the cdb to the trace buffers.
> +	 */
> +	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned int)TCM_MAX_COMMAND_SIZE));

Use 80 char cols like you did in the rest of the patch and the other code.

> +	return ret;
>   }
>   EXPORT_SYMBOL(target_cmd_init_cdb);
>   
> @@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
>   	struct se_device *dev = cmd->se_dev;
>   	sense_reason_t ret;
>   
> -	target_cmd_init_cdb(cmd, cdb);
> -
>   	ret = dev->transport->parse_cdb(cmd);
>   	if (ret = TCM_UNSUPPORTED_SCSI_OPCODE)
>   		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
> @@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
>   				data_length, data_dir, task_attr, sense);
>   

This should maybe be in transport_init_se_cmd. It might be useful there 
for the tmr case, if we wanted to add a trace point there too.

At least a comment and some cleanup, because it's not obvious why we set 
it here then also set it again in transport_lookup_cmd_lun.


> +	se_cmd->orig_fe_lun = unpacked_lun; > +	rc = target_cmd_init_cdb(se_cmd, cdb);
> +	if (rc) {
> +		transport_send_check_condition_and_sense(se_cmd, rc, 0);

Can we do this before doing a get() on the cmd? If the fabric module is 
such that it does a put() on the cmd (the callers using SCF_ACK_KREF) in 
its cmd clean up path, then we would end up with unbalanced 
sess->cmd_count and cmd refcounts.

Maybe move this to after target_get_sess_cmd().


> +		return 0;
> +	}
> +
>   	if (flags & TARGET_SCF_USE_CPUID)
>   		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
>   	else
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index bd3ed6ce7571..fdd8234906b6 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
>   	}
>   	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>   
> +	if (target_cmd_init_cdb(cmd, cdb))
> +		return -EINVAL;
> +
>   	cmd->tag = 0;
>   	if (target_setup_cmd_from_cdb(cmd, cdb))
>   		return -EINVAL;
> 
