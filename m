From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Mon, 08 Oct 2018 04:31:54 +0000
Subject: Re: [PATCH 07/17] target/core: Use system workqueues for TMF
Message-Id: <1538973114.14891.28.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-8-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-8-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
> A quote from SAM-5: "The order in which task management requests
> are processed is not specified by the SCSI architecture model.
> The SCSI architecture model does not require in-order delivery of
> such task management requests or processing by the task manager
> in the order received. To guarantee the processing order of task
> management requests referencing sent to a specific logical unit,
> an application client should not have more than one such task
> management request pending to that logical unit." 

The important part is:

"The order in which task management requests are processed is not
specified by the SCSI architecture model."

And the specific bit:

".. the application client should not have more than one such task
management request pending to that logical unit."

This wording from SAM is alone not justification changing default target
behavior.  

> This means that
> it is safe to use the system workqueues instead of tmr_wq for
> processing TMFs. An intended side effect of this patch is that it
> enables concurrent processing of TMFs.
> 

This patch enables N number of TMRs to be processed in-flight to a
single se_device, using the global bounded system_wq with unlimited
max_active.

For users with ~1K /sys/kernel/config/target/core/$HBA/$DEV/
configurations, I don't see how this can possibly be beneficial.

There has never been a host environment that requires execution of N
TMRs in parallel, because as you pointed out above, the application
client should not have more than one TMR pending.

Also, I'm not aware of any hosts that have outstanding issues with the
long-standing default behavior in mainline of using a per se_device
workqueue with WQ_UNBOUNDED + max_active=1.

That said, allowing N TMRs to be executed for every device, with NO way
to control it's usage dynamically in the field for users is not
acceptable.

So what is the practical use-case..?
