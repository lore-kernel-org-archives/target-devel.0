From: Sagi Grimberg <sagi@grimberg.me>
Date: Wed, 26 Feb 2020 18:22:03 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <d655f85f-d910-a77b-1672-0fbb919e5d9a@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


> Hi All,
> I observe connection errors almost immediately after I start iozone over iser
> luns. Atached are the connection error and hung task traces on initator and
> target respecively.
> Interestingly, I see connection errors only if LUN size is less than 512MB.
> In my case I could consistently reproduce the issue with 511MB LUN and 300MB
> lun size. Connections errors are not seen if I create 512MB or greated LUN.

Can you share log output on the target to before hung tasks?

> Further, after the connection errors, I noticed that the poll work queue is
> stuck and never processes drain CQE resulting in hung tasks on the target side.

Is the drain CQE actually generated?

> I tried changing the CQ poll workqueue to be UNBOUND but it did not fix the issue.
> 
> Here is what my test does:
> Create 8 targets with 511MB lun each, login and format disks to ext3, mount the
> disks and run iozone over them.
> #iozone -a -I -+d -g 256m

Does it happen specifically with iozone? or can dd/fio also reproduce 
this issue? on which I/O pattern do you see the issue?

> I am not sure how LUN size could cause the connection errors. I appreciate any
> inputs on this.

I imagine that a single LUN is enough to reproduce the issue?

btw, I tried reproducing the issue with rxe (couldn't setup an iser
listener with siw) in 2 VMs on my laptop using lio to a file backend but
I cannot reproduce the issue..
