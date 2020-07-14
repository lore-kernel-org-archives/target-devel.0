From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 14 Jul 2020 17:43:37 +0000
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
Message-Id: <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
 <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
In-Reply-To: <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/13/20 6:39 AM, Bodo Stroesser wrote:
> On 2020-07-12 02:49, Mike Christie wrote:
>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> 
> ...
> 
>>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>>           printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>>>               se_cmd->se_tfo->fabric_name, ref_tag);
>>> -        if (!__target_check_io_state(se_cmd, se_sess,
>>> -                         dev->dev_attrib.emulate_tas))
>>> +        spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>> +        rc = __target_check_io_state(se_cmd, se_sess, 0);
>>> +        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +        if (!rc)
>>>               continue;
>>> -        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +        list_del_init(&se_cmd->state_list);
>>
>> Do we only want to do this if in the next patch tmr_notify can 
>> successfully accept the tmr?
> 
> This change does not modify behavior of the core. Please see how
> core_tmr_drain_state_list() uses state_list to queue commands after
> successfully calling __target_check_io_state() for later call of 
> target_put_cmd_and_wait().
> 
> This patch just unifies ABORT_TASK and LUN_RESET handling such,
> that in next patch we can call tmr_notify handler with a list of
> aborted commands in both cases. The list uses the state_list list_head
> in the se_cmd.
> 
>>
>> If tmr_notify can't allocate memory for the abort case, we would 
>> delete it from the list. Later the initiator would send a LUN_RESET 
>> but core_tmr_drain_state_list won't see it and pass it to the 
>> tmr_notify call.
>>
> 
> tmr_notify handler will not and must not modify the list of aborted
> cmds. So if backend just does nothing for whatever reason we will end
> up with the "old" behavior of the core as it was before the change.
> 
> The general idea is to send info about received TMRs together with the
> list of aborted commands to the backend, to allow TMR tracing and
> canceling of aborted commands. But backend must not interfere with TMR
> processing in core.

I don't think we are talking about the same thing.

For the abort case, let's say tmr_notify fails. So for the tcmu case, 
the tmr does not get queued and userspace never knows about it. The 
initiator then sends a LUN reset. For the reset, the tmr_notify call's 
list will be missing the command that got the abort, right? How will the 
backend know to clean up that command during the LUN reset handling?

> 
>>> +        se_cmd->state_active = false;
>>> +
>>> +        spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>>           /*
>>>            * Ensure that this ABORT request is visible to the LU RESET
>>> @@ -159,7 +165,7 @@ void core_tmr_abort_task(
>>>           atomic_long_inc(&dev->aborts_complete);
>>>           return;
>>>       }
>>> -    spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>> +    spin_unlock_irqrestore(&dev->execute_task_lock, flags);
>>>       printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for 
>>> ref_tag: %lld\n",
>>>               tmr->ref_task_tag);
>>>
>>
