From: Sagi Grimberg <sagi@grimberg.me>
Date: Thu, 27 Feb 2020 23:42:32 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <b021295a-cc41-d8e9-8605-cfbc77cead80@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


>>> Hi All,
>>> I observe connection errors almost immediately after I start iozone over iser
>>> luns. Atached are the connection error and hung task traces on initator and
>>> target respecively.
>>> Interestingly, I see connection errors only if LUN size is less than 512MB.
>>> In my case I could consistently reproduce the issue with 511MB LUN and 300MB
>>> lun size. Connections errors are not seen if I create 512MB or greated LUN.
>>
>> Can you share log output on the target to before hung tasks?
> 
> Sure, Attached are the target and initiator dmesg logs.
>>
>>> Further, after the connection errors, I noticed that the poll work queue is
>>> stuck and never processes drain CQE resulting in hung tasks on the target side.
>>
>> Is the drain CQE actually generated?
>>
> 
> Yes it is generated. I was able to track it with prints until queue_work() in
> ib_cq_completion_workqueue(). Work Function ib_cq_poll_work() is never getting
> scheduled. Therefore, I see drain CQE unpolled and hung task due to
> __ib_drain_sq() waiting forever for complete() to be called from drain CQE
> done() handler.

Hmm, that is interesting. This tells me that cq->work is probably
blocked by another completion invokation (which hangs), which means that
queuing the cq->work did not happen as workqueues are not re-entrant.

Looking at the code, nothing should be blocking in the isert ->done()
handlers, so its not clear to me how this can happen.

Would it be possible to run:
echo t > /proc/sysrq-trigger when this happens? I'd like to see where
that cq->work is blocking.

I'd also enable pr_debug on iscsi_traget.c

> 
>>> I tried changing the CQ poll workqueue to be UNBOUND but it did not fix the issue.
>>>
>>> Here is what my test does:
>>> Create 8 targets with 511MB lun each, login and format disks to ext3, mount the
>>> disks and run iozone over them.
>>> #iozone -a -I -+d -g 256m
>>
>> Does it happen specifically with iozone? or can dd/fio also
>> reproduce this issue? on which I/O pattern do you see the issue?
>>
> I see it with iozone. I am trying with fio, shall soon update.
> I see issue with at iosizes around 128k/256k block sizes of iozone. Its not
> consistent.
>>> I am not sure how LUN size could cause the connection errors. I appreciate any
>>> inputs on this.
>>
>> I imagine that a single LUN is enough to reproduce the issue?
>>
> 
> yes, attached is the target conf.
>> btw, I tried reproducing the issue with rxe (couldn't setup an iser
>> listener with siw) in 2 VMs on my laptop using lio to a file backend but
>> I cannot reproduce the issue..
> I see the issue quickly with 40G/25G links. I have not seen the issue on a 100G
> link. BTW i a trying iwarp(T6/t5)
> 
> Thanks for looking into it.
> 

 From the log, looks like the hang happens when the initiator tries to
login after the failure (trace starts in iscsi_target_do_login). and
looks like the target gave up on login timeout, but what is not
indicated is why did the initiator got a ping timeout in the
first place...
