From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 20:32:13 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <5B2C0B4D.1080806@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 03:25 PM, Bart Van Assche wrote:
> On Thu, 2018-06-21 at 14:10 -0500, Mike Christie wrote:
>>>
>>> @@ -3156,9 +3167,13 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
>>>  		si = &sense_info_table[(__force int)
>>>  				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
>>>  
>>> +	key = si->key;
>>>  	if (reason = TCM_CHECK_CONDITION_UNIT_ATTENTION) {
>>> -		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
>>> -		WARN_ON_ONCE(asc = 0);
>>> +		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
>>> +						       &ascq)) {
>>> +			cmd->scsi_status = SAM_STAT_BUSY;
>>
>> Here is another question I had about this code path.
>>
>> If you hit this case do you need to undo the setting of the
>> SCF_SENT_CHECK_CONDITION bit done in
>> transport_send_check_condition_and_sense or does the check for that bit
>> need to be fixed up.
>>
>> With the code addition above we have this path setting
>> SCF_SENT_CHECK_CONDITION so
>> iscsit_check_task_reassign_expdatasn/iscsit_task_reassign_complete_scsi_cmnd/
>> transport_send_task_abort would see the CC bit set and return.
> 
> Hello Mike,
> 
> Have you noticed that patch 1/3 that was attached to my previous e-mail
> moves the code that sets the SCF_SENT_CHECK_CONDITION flag inside

I am not seeing that. I saw SCF_EMULATED_TASK_SENSE was moved but not
SCF_SENT_CHECK_CONDITION. The latter is set a little earlier in
transport_send_check_condition_and_sense.

> translate_sense_reason() and past the point where SAM_STAT_BUSY is returned?
> 
