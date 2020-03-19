From: Sagi Grimberg <sagi@grimberg.me>
Date: Thu, 19 Mar 2020 21:05:25 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <1d236e48-d76e-e7be-53a5-a1e6426a26b5@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 3/19/20 10:45 AM, Potnuri Bharat Teja wrote:
> On Tuesday, March 03/10/20, 2020 at 17:31:51 +0530, Potnuri Bharat Teja wrote:
>> On Wednesday, March 03/04/20, 2020 at 23:56:12 +0530, Potnuri Bharat Teja wrote:
>>> On Friday, February 02/28/20, 2020 at 05:12:32 +0530, Sagi Grimberg wrote:
>>>>
>>>>>>> Hi All,
>>>>>>> I observe connection errors almost immediately after I start iozone over iser
>>>>>>> luns. Atached are the connection error and hung task traces on initator and
>>>>>>> target respecively.
>>>>>>> Interestingly, I see connection errors only if LUN size is less than 512MB.
>>>>>>> In my case I could consistently reproduce the issue with 511MB LUN and 300MB
>>>>>>> lun size. Connections errors are not seen if I create 512MB or greated LUN.
>>>>>>
>>>>>> Can you share log output on the target to before hung tasks?
>>>>>
>>>>> Sure, Attached are the target and initiator dmesg logs.
>>>>>>
>>>>>>> Further, after the connection errors, I noticed that the poll work queue is
>>>>>>> stuck and never processes drain CQE resulting in hung tasks on the target side.
>>>>>>
>>>>>> Is the drain CQE actually generated?
>>>>>>
>>>>>
>>>>> Yes it is generated. I was able to track it with prints until queue_work() in
>>>>> ib_cq_completion_workqueue(). Work Function ib_cq_poll_work() is never getting
>>>>> scheduled. Therefore, I see drain CQE unpolled and hung task due to
>>>>> __ib_drain_sq() waiting forever for complete() to be called from drain CQE
>>>>> done() handler.
>>>>
>>>> Hmm, that is interesting. This tells me that cq->work is probably
>>>> blocked by another completion invokation (which hangs), which means that
>>>> queuing the cq->work did not happen as workqueues are not re-entrant.
>>>>
>>>> Looking at the code, nothing should be blocking in the isert ->done()
>>>> handlers, so its not clear to me how this can happen.
>>>>
>>>> Would it be possible to run:
>>>> echo t > /proc/sysrq-trigger when this happens? I'd like to see where
>>>> that cq->work is blocking.
>>>>
>>> Attached file t_sysrq-trigger_and_dmesg.txt is the triggered output. Please let
>>> me know if that is timed correctly as I triggered it a little after login timeout.
>>> I'll try getting a better one meanwhile.
>>>> I'd also enable pr_debug on iscsi_traget.c
>>>>
>>> Attached files are with debug enabled:
>>> tgt_discovery_and_login_dmesg.txt -> dmesg just after login for reference
>>> tgt_IO_511MB_8target_1lun_each_iozone_dmesg_untill_hang.txt -> dmesg untill connection error.
>>>
>>> Please let me know if there is anything that I could check.
>>
> Hi All,
> any suggestions on what to check?
> 
> I tried limiting max_data_sg_nnets to 32 as T6 has relatively lower resources
> and I dont see the issue with the patch.
> 
> Though the visible effect is at the workqueue, I think there is something to do
> iscsi/iser flow control mechanism, which is failing and overwhelming the target.
> I am not sure how to verify this exactly. I appreciate any suggestions on the debug.

Can you check what threads are blocking on?

When the hang happens, run echo t > /proc/sysrq-trigger. I'd like to
understand what is preventing the workqueue from running...
