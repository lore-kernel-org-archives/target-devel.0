From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 19:10:56 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <5B2BF840.8000904@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 12:53 PM, Bart Van Assche wrote:
> On Wed, 2018-06-20 at 20:32 -0500, Mike Christie wrote:
>> > I was in the middle of fixing up the sense key value issue in the patch
>> > like we discussed before (use illegal request instead of unit
>> > attention), but it looks like there was another bug. If we have 2
>> > commands going to the same device and they run target_scsi3_ua_check and
>> > see ua_count=1 TCM_CHECK_CONDITION_UNIT_ATTENTION is returned for both.
>> > They then call core_scsi3_ua_for_check_condition and one of them
>> > deallocates a UA dropping ua_count=0. The second command then runs the
>> > !atomic_read(&deve->ua_count) check and sees the other command has
>> > decremented it. Or the second one might have passed the ua_count check
>> > in core_scsi3_ua_for_check_condition and it runs the loop but nothing is
>> > found since the first command has already removed it. We then return
>> > bogus asc/ascq values.
>> > 
>> > In the attached patch I just return busy status for this race case. It
>> > seemed easier than trying to add more locking and error handling.
>> > 
>> > Some notes/questions on some of the code the patch touched though.
>> > 
>> > If translate_sense_reason failed due to a short buffer it returned
>> > -EINVAL. transport_send_check_condition_and_sense would then end up
>> > calling transport_handle_queue_full/transport_complete_qf and that would
>> > just end up failing the command with
>> > TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE. Do you know if that long journey
>> > intended or just an accident?
>> > 
>> > In this patch I fixed that so it just translated the error to
>> > TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE immediately. If the patch is ok
>> > and we meant to return that error code for the short buffer then I can
>> > break that out into another patch.
> Hello Mike,
> 
> That's an interesting observation. However, I think that the race described
> above can be fixed with fewer code changes. Can you have a look at the three
> attached (untested) patches?
> 
> Regarding translate_sense_reason() failing due to a short buffer: I don't
> think that the current behavior in case of a short sense buffer is correct.
> It's probably better to return a sense buffer that is incomplete and with
> correct KEY / ASC / ASCQ values instead of modifying these values. How
> about changing the code at the end of translate_sense_reason() as follows?
> 
> 	if (si->add_sector_info)
> 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
> 						  cmd->scsi_sense_length,
> 						  cmd->bad_sector) < 0);
> 
> 	return 0;

Agree.

> 
> @@ -3156,9 +3167,13 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
>  		si = &sense_info_table[(__force int)
>  				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
>  
> +	key = si->key;
>  	if (reason = TCM_CHECK_CONDITION_UNIT_ATTENTION) {
> -		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
> -		WARN_ON_ONCE(asc = 0);
> +		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
> +						       &ascq)) {
> +			cmd->scsi_status = SAM_STAT_BUSY;

Here is another question I had about this code path.

If you hit this case do you need to undo the setting of the
SCF_SENT_CHECK_CONDITION bit done in
transport_send_check_condition_and_sense or does the check for that bit
need to be fixed up.

With the code addition above we have this path setting
SCF_SENT_CHECK_CONDITION so
iscsit_check_task_reassign_expdatasn/iscsit_task_reassign_complete_scsi_cmnd/
transport_send_task_abort would see the CC bit set and return.

If transport_generic_request_failure is passed TCM_LUN_BUSY which gets
translate to SAM_STAT_BUSY then
iscsit_check_task_reassign_expdatasn/iscsit_task_reassign_complete_scsi_cmnd/transport_send_task_abort
would not see the CC bit is set and those functions would not return
right away.

It seems like
iscsit_check_task_reassign_expdatasn/iscsit_task_reassign_complete_scsi_cmnd/
transport_send_task_abort want the same behavior for both check
conditions and commands that completed with non good status, so it
should be checking for the CC bit set and also if non good status has
been returned.


>  	 * The highest priority Unit Attentions are placed at the head of the
> @@ -244,6 +246,7 @@ void core_scsi3_ua_for_check_condition(
>  		 * clearing it.
>  		 */
>  		if (dev->dev_attrib.emulate_ua_intlck_ctrl != 0) {
> +			*key = UNIT_ATTENTION;


Is the key already set to UNIT_ATTENTION here?


Seems nice!
