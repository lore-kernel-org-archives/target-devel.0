From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 12 Oct 2018 02:18:01 +0000
Subject: Re: [PATCH 1/2] sched/wait: Add wait_event_lock_irq_timeout for TASK_UNINTERRUPTIBLE usage
Message-Id: <91f50300-5e36-73a5-379d-9c82004947bb@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-2-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1539141790-13557-2-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>

On 10/9/18 8:23 PM, Nicholas A. Bellinger wrote:
> Short of reverting commit 00d909a107 for v4.19, target-core needs a
> wait_event_t marco can be executed using TASK_UNINTERRUPTIBLE to
> function correctly with existing fabric drivers that expect to run
> with signals pending during session shutdown and active se_cmd I/O
> quiesce.
> 
> The most notable is iscsi-target/iser-target, while ibmvscsi_tgt invokes
> session shutdown logic from userspace via configfs attribute that could
> also potentially have signals pending.
> 
> So go ahead and introduce wait_event_lock_irq_timeout() to achieve this,
> and update + rename __wait_event_lock_irq_timeout() to make it accept
> 'state' as a parameter.
> 
> Fixes: 00d909a107 ("scsi: target: Make the session shutdown code also wait for commands that are being aborted")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
