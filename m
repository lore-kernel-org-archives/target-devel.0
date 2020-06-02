From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 02 Jun 2020 23:26:33 +0000
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
Message-Id: <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
In-Reply-To: <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>



On 6/2/20 5:37 PM, Sudhakar Panneerselvam wrote:
>>
>> You should follow the coding style in the rest of the code. Do "/*" then
>> start your text or do it all on one line if it fits:
>>
>> /*
>>    * Copy the CDB here to allow trace_target_cmd_complete() to
> 
> Thanks, I will fix this.
> 
>>
>>
>>> +	 * print the cdb to the trace buffers.
>>> +	 */
>>> +	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned
>> int)TCM_MAX_COMMAND_SIZE));
>>
>> Use 80 char cols like you did in the rest of the patch and the other code.
> 
> I recently noticed that 80 char limitation was relaxed from mainline by commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144. The new limit is 100 char. I was confused whether to stick to 80 or the new limit. Let me know.
> 

I would normally stick with what's in the existing code, because it 
still says that the preferred limit is 80. For cases where readbility is 
an issue then I would go up to 100.


>>
>>> +	return ret;
>>>    }
>>>    EXPORT_SYMBOL(target_cmd_init_cdb);
>>>
>>> @@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
>>>    	struct se_device *dev = cmd->se_dev;
>>>    	sense_reason_t ret;
>>>
>>> -	target_cmd_init_cdb(cmd, cdb);
>>> -
>>>    	ret = dev->transport->parse_cdb(cmd);
>>>    	if (ret = TCM_UNSUPPORTED_SCSI_OPCODE)
>>>    		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x,
>> sending CHECK_CONDITION.\n",
>>> @@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd
>> *se_cmd, struct se_session *se_sess
>>>    	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
>>>    				data_length, data_dir, task_attr, sense);
>>>
>>
>> This should maybe be in transport_init_se_cmd. It might be useful there
>> for the tmr case, if we wanted to add a trace point there too.
>>
>> At least a comment and some cleanup, because it's not obvious why we set
>> it here then also set it again in transport_lookup_cmd_lun.
> 
> Yes, I thought of initializing the cdb in transport_init_se_cmd() but realized later that TMR requests are transport level entities and hence they don't have an associated cdb with them. So, in future if we want to trace tmr request, then we may have to introduce new set of trace functions that do not reference cdb. What do you think?

I'm just talking about the LUN value and not the cdb here. In my opinion 
it's just a matter of initializing fields in transport_init_se_cmd that 
we later reference instead of having the initializations scattered 
around in multiple places.

I'm not talking about having a common trace function for the tmr and non 
tmr paths.

Also, for the cdb case the init in the target_cmd_init_cdb seems nice to 
me, because it's clear that is where we are setting up the cdb related 
fields.


> 
>>
>>
>>> +	se_cmd->orig_fe_lun = unpacked_lun; > +	rc >> target_cmd_init_cdb(se_cmd, cdb);
>>> +	if (rc) {
>>> +		transport_send_check_condition_and_sense(se_cmd, rc, 0);
>>
>> Can we do this before doing a get() on the cmd? If the fabric module is
>> such that it does a put() on the cmd (the callers using SCF_ACK_KREF) in
>> its cmd clean up path, then we would end up with unbalanced
>> sess->cmd_count and cmd refcounts.
>>
>> Maybe move this to after target_get_sess_cmd().
> 
> I moved it before target_get_sess_cmd() because if target_get_sess_cmd() fails then we have NULL pointer dereference issue again. For instance, the sequence

Yeah, that's why I noticed the issue :) You didn't update the 
target_get_sess_cmd failure path to do 
transport_send_check_condition_and_sense even though you moved the cdb 
init before the get() call, so the code looked off.


>    vhost_scsi_submission_wor >       target_submit_cmd_map_sgls
>         target_get_sess_cmd() -- Suppose this fails
>       transport_send_check_condition_and_sense >          trace_target_cmd_complete -- NULL ptr derefence.
> 
> Still thinking how to address both these issues together.
> 

Maybe you need a new trace call for the case where we can't fully 
initialize the cmd. It could be used for cases like where 
transport_generic_new_cmd is used directly but fails, the 
transport_handle_queue_full case, and your case where we fail during the 
initial setup.
