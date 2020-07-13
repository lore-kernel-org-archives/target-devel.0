From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 13 Jul 2020 11:40:05 +0000
Subject: Re: [PATCH 2/8] scsi: target: Add tmr_notify backend function
Message-Id: <1cd113df-1140-5148-c41c-541e4d2ce1b9@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-3-bstroesser@ts.fujitsu.com>
 <5c163079-563c-e3e5-2a9c-478a310bd022@oracle.com>
In-Reply-To: <5c163079-563c-e3e5-2a9c-478a310bd022@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-07-12 01:27, Mike Christie wrote:
> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>> Target core is modified to call an optional backend
>> callback function if a TMR is received or commands
>> are aborted implicitly after a PR command was received.
>> The backend function takes as parameters the se_dev, the
>> type of the TMR, and the list of aborted commands.
>> If no commands were aborted, an empty list is supplied.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_tmr.c       | 16 +++++++++++++++-
>>   drivers/target/target_core_transport.c |  1 +
>>   include/target/target_core_backend.h   |  2 ++
>>   include/target/target_core_base.h      |  1 +
>>   4 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_tmr.c 
>> b/drivers/target/target_core_tmr.c
>> index b65d7a0a5df1..39d93357db65 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -116,6 +116,7 @@ void core_tmr_abort_task(
>>       struct se_tmr_req *tmr,
>>       struct se_session *se_sess)
>>   {
>> +    LIST_HEAD(aborted_list);
>>       struct se_cmd *se_cmd, *next;
>>       unsigned long flags;
>>       bool rc;
>> @@ -144,7 +145,7 @@ void core_tmr_abort_task(
>>           if (!rc)
>>               continue;
>> -        list_del_init(&se_cmd->state_list);
>> +        list_move_tail(&se_cmd->state_list, &aborted_list);
>>           se_cmd->state_active = false;
>>           spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>> @@ -157,6 +158,11 @@ void core_tmr_abort_task(
>>               WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
>>                       0);
>> +        if (dev->transport->tmr_notify)
>> +            dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
>> +                           &aborted_list);
>> +
>> +        list_del_init(&se_cmd->state_list);
>>           target_put_cmd_and_wait(se_cmd);
>>           printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
>> @@ -167,6 +173,9 @@ void core_tmr_abort_task(
>>       }
>>       spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>> +    if (dev->transport->tmr_notify)
>> +        dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
> 
> Is this needed? It seems like the backend can't do anything because 
> there isn't enough info.
> 
> I saw in tcmu_tmr_notify it looks when then happens we can still do 
> queue_tmr_ring, but there would be no commands. Was that intentional?

Yes, it is intentional. I see two purposes for backend tmr notification:

1) Allow backend (userspace) to cancel long running command execution if
    possible, which then makes the core more 'responsive' to TMRs

2) Tracing. If a userspace device emulation does tracing, it would be
    good to see an ABORT_TASK in trace even if core does not find the
    aborted cmd. The reason for this e.g. can be, that userspace and tcmu
    complete a command while initiator times out and sends ABORT_TASK.
    In that case ABORT_TASK in trace is helpful, because initiator will
    not accept the command completion but start some error handling.
    Without the ABORT_TASK entry the trace would not show the reason for
    error handling.
