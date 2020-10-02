From: Mike Christie <michael.christie@oracle.com>
Date: Fri, 02 Oct 2020 17:58:47 +0000
Subject: Re: [PATCH] scsi: target: core: Add CONTROL field for trace events
Message-Id: <af5c5b31-299a-a780-01ab-7a8b62b0edfd@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200929125957.83069-1-r.bolshakov@yadro.com>
In-Reply-To: <20200929125957.83069-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com

On 9/29/20 7:59 AM, Roman Bolshakov wrote:
> trace-cmd report doesn't show events from target subsystem because
> scsi_command_size() leaks through event format string:
> 
>   [target:target_sequencer_start] function scsi_command_size not defined
>   [target:target_cmd_complete] function scsi_command_size not defined
> 
> Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
> help because an expression is used inside TP_printk(). trace-cmd event
> parser doesn't understand minus sign inside [ ]:
> 
>   Error: expected ']' but read '-'
> 
> Rather than duplicating kernel code in plugin_scsi.c, it's better to
> provide a dedicated field for CONTROL byte.
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  include/scsi/scsi_common.h    |  7 +++++++
>  include/trace/events/target.h | 12 ++++++------
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 731ac09ed231..5b567b43e1b1 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -25,6 +25,13 @@ scsi_command_size(const unsigned char *cmnd)
>  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
>  }
>  
> +static inline unsigned char
> +scsi_command_control(const unsigned char *cmnd)
> +{
> +	return (cmnd[0] = VARIABLE_LENGTH_CMD) ?
> +		cmnd[1] : cmnd[COMMAND_SIZE(cmnd[0]) - 1];
> +}
> +
>  /* Returns a human-readable name for the device */
>  extern const char *scsi_device_type(unsigned type);
>  
> diff --git a/include/trace/events/target.h b/include/trace/events/target.h
> index 77408edd29d2..67fad2677ed5 100644
> --- a/include/trace/events/target.h
> +++ b/include/trace/events/target.h
> @@ -141,6 +141,7 @@ TRACE_EVENT(target_sequencer_start,
>  		__field( unsigned int,	opcode		)
>  		__field( unsigned int,	data_length	)
>  		__field( unsigned int,	task_attribute  )
> +		__field( unsigned char,	control		)
>  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
>  		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
>  	),
> @@ -151,6 +152,7 @@ TRACE_EVENT(target_sequencer_start,
>  		__entry->opcode		= cmd->t_task_cdb[0];
>  		__entry->data_length	= cmd->data_length;
>  		__entry->task_attribute	= cmd->sam_task_attr;
> +		__entry->control	= scsi_command_control(cmd->t_task_cdb);
>  		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
>  		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
>  	),
> @@ -160,9 +162,7 @@ TRACE_EVENT(target_sequencer_start,
>  		  __entry->tag, show_opcode_name(__entry->opcode),
>  		  __entry->data_length, __print_hex(__entry->cdb, 16),
>  		  show_task_attribute_name(__entry->task_attribute),
> -		  scsi_command_size(__entry->cdb) <= 16 ?
> -			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> -			__entry->cdb[1]
> +		  __entry->control
>  	)
>  );
>  
> @@ -178,6 +178,7 @@ TRACE_EVENT(target_cmd_complete,
>  		__field( unsigned int,	opcode		)
>  		__field( unsigned int,	data_length	)
>  		__field( unsigned int,	task_attribute  )
> +		__field( unsigned char,	control		)
>  		__field( unsigned char,	scsi_status	)
>  		__field( unsigned char,	sense_length	)
>  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
> @@ -191,6 +192,7 @@ TRACE_EVENT(target_cmd_complete,
>  		__entry->opcode		= cmd->t_task_cdb[0];
>  		__entry->data_length	= cmd->data_length;
>  		__entry->task_attribute	= cmd->sam_task_attr;
> +		__entry->control	= scsi_command_control(cmd->t_task_cdb);
>  		__entry->scsi_status	= cmd->scsi_status;
>  		__entry->sense_length	= cmd->scsi_status = SAM_STAT_CHECK_CONDITION ?
>  			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
> @@ -208,9 +210,7 @@ TRACE_EVENT(target_cmd_complete,
>  		  show_opcode_name(__entry->opcode),
>  		  __entry->data_length, __print_hex(__entry->cdb, 16),
>  		  show_task_attribute_name(__entry->task_attribute),
> -		  scsi_command_size(__entry->cdb) <= 16 ?
> -			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> -			__entry->cdb[1]
> +		  __entry->control
>  	)
>  );
>  

I'm not an expert on the tracing side of the code, but the target/scsi
parts look ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
