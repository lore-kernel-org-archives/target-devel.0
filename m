From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 15 Jul 2020 18:24:19 +0000
Subject: Re: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
Message-Id: <a263f857-a582-d262-b347-20687502ee91@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
 <ea36fcc0-d01c-eba1-748f-d5cfa39fa105@oracle.com>
 <0f660dc9-40ee-75a4-2924-761769d9cd38@ts.fujitsu.com>
 <e4d54aed-88fa-eeed-fe9a-20e627c3841a@oracle.com>
 <980ec328-f604-556b-400a-1404c56e34ae@ts.fujitsu.com>
In-Reply-To: <980ec328-f604-556b-400a-1404c56e34ae@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/15/20 9:25 AM, Bodo Stroesser wrote:
> On 2020-07-14 19:43, Mike Christie wrote:
>> On 7/13/20 6:39 AM, Bodo Stroesser wrote:
>>> On 2020-07-12 02:49, Mike Christie wrote:
>>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>>
>>> ...
>>>
>>>>> @@ -137,11 +138,16 @@ void core_tmr_abort_task(
>>>>>           printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
>>>>>               se_cmd->se_tfo->fabric_name, ref_tag);
>>>>> -        if (!__target_check_io_state(se_cmd, se_sess,
>>>>> -                         dev->dev_attrib.emulate_tas))
>>>>> +        spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>>>> +        rc = __target_check_io_state(se_cmd, se_sess, 0);
>>>>> +        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>>>> +        if (!rc)
>>>>>               continue;
>>>>> -        spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>>>>> +        list_del_init(&se_cmd->state_list);
>>>>
>>>> Do we only want to do this if in the next patch tmr_notify can 
>>>> successfully accept the tmr?
>>>
>>> This change does not modify behavior of the core. Please see how
>>> core_tmr_drain_state_list() uses state_list to queue commands after
>>> successfully calling __target_check_io_state() for later call of 
>>> target_put_cmd_and_wait().
>>>
>>> This patch just unifies ABORT_TASK and LUN_RESET handling such,
>>> that in next patch we can call tmr_notify handler with a list of
>>> aborted commands in both cases. The list uses the state_list list_head
>>> in the se_cmd.
>>>
>>>>
>>>> If tmr_notify can't allocate memory for the abort case, we would 
>>>> delete it from the list. Later the initiator would send a LUN_RESET 
>>>> but core_tmr_drain_state_list won't see it and pass it to the 
>>>> tmr_notify call.
>>>>
>>>
>>> tmr_notify handler will not and must not modify the list of aborted
>>> cmds. So if backend just does nothing for whatever reason we will end
>>> up with the "old" behavior of the core as it was before the change.
>>>
>>> The general idea is to send info about received TMRs together with the
>>> list of aborted commands to the backend, to allow TMR tracing and
>>> canceling of aborted commands. But backend must not interfere with TMR
>>> processing in core.
>>
>> I don't think we are talking about the same thing.
> 
> Yeah, probably I misunderstood.
> 
>>
>> For the abort case, let's say tmr_notify fails.So for the tcmu case, 
>> the tmr does not get queued and userspace never knows about it.
> 
> True.
> 
> For the tcmu case tmr_notify can fail only if kmalloc(..., GFP_KERNEL)
> fails.
> 
>> The initiator then sends a LUN reset. For the reset, the tmr_notify 
>> call's list will be missing the command that got the abort, right?
> 
> Yes.
> 
> In core, the LUN RESET will wait in core_tmr_drain_tmr_list for the
> previous ABORT_TASK to complete, while the ABORT_TASK itself waits for
> the aborted command to complete in core_tmr_abort_task.
> 
> So, when LUN_RESET handling comes to calling core_tmr_drain_state_list,
> the aborted command will definitely already be done.
> 
>> How will the backend know to clean up that command during the LUN 
>> reset handling?
>>
> 
> It will not know, so core just has to wait until backend completes the
> aborted cmd - maybe after long time - just like it always did before my
> change.

Ah I see. When I made the original comment and was asking about if the 
callback was supposed to perform some of the TMF operations I was 
thinking we were going to change up a lot of this code.

I think your idea where it's more of a way to notify the modules and we 
are not changing any of this behavior is better since no one wants to 
get into that :)

Seems ok to me.
