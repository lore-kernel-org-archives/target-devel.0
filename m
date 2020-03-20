From: Sagi Grimberg <sagi@grimberg.me>
Date: Fri, 20 Mar 2020 06:22:10 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <24e7c897-fcc1-1712-100f-9c36ba607729@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This seems the a possible root-cause...


> [11367.785938] kworker/5:1H    S    0   768      2 0x80004000
> [11367.786401] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [11367.786958] Call Trace:
> [11367.787446]  ? __schedule+0x31a/0x850
> [11367.787988]  schedule+0x36/0xc0
> [11367.788488]  iscsit_allocate_cmd+0x246/0x2c0 [iscsi_target_mod]
> [11367.789042]  ? finish_wait+0x80/0x80
> [11367.789564]  isert_allocate_cmd+0x1d/0x60 [ib_isert]
> [11367.790120]  isert_recv_done+0x282/0xa30 [ib_isert]
> [11367.790620]  __ib_process_cq+0x76/0xc0 [ib_core]
> [11367.791181]  ib_cq_poll_work+0x26/0x80 [ib_core]
> [11367.791697]  process_one_work+0x235/0x5d0
> [11367.792300]  worker_thread+0x3c/0x390
> [11367.792818]  ? process_one_work+0x5d0/0x5d0
> [11367.793366]  kthread+0x11f/0x140
> [11367.793850]  ? kthread_park+0x90/0x90
> [11367.794440]  ret_from_fork+0x24/0x30

The only way that the workqueue cannot process the drain completion
is if it is stuck. This appears to be the cq workqueue blocks on
a command allocation that apparently never completes.

The question is why does that happen only for 511MB luns, and
how come this allocation never completes...
