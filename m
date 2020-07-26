From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 26 Jul 2020 18:38:21 +0000
Subject: Re: [PATCH v3 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Message-Id: <283dd5a6-b925-a33a-f481-f4b7bff2517b@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/26/20 10:35 AM, Bodo Stroesser wrote:
> This patch series is made on top of Martin's for-next branch.
> 
> ChangeLog:
> 
> v2: in patch "scsi: target: tcmu: Implement tmr_notify callback"
>     changed new comment's style from "// ..." to "/* ... */"
>     and correctly use "/** " for function doc.
> 
> V3:
>  - Patch 1 "scsi: target: Modify core_tmr_abort_task()":
>    fixed wrong spin_lock handling. Nested calls to
>    spin_lock_irqsave and spin_lock_irqrestore used the same
>    flags field. Inner pair replaced by spin_lock / spin_unlock
>     
>  - Patches 5,7,8:
>    "scsi: target: tcmu: Factor out new helper ring_insert_padding"
>    "scsi: target: tcmu: Implement tmr_notify callback"
>    "scsi: target: tcmu: Make TMR notification optional"
>    New definitions of struct tcmu_dev *dev renamed to *udev.
> 
>  - Patch 8 "scsi: target: tcmu: Make TMR notification optional"
>    Spacing fixed at function definition.
> 
> ---
> 
> TCM/LIO core handles TMRs without involving backends.
> But TMR completion message is sent to initiator only after
> commands aborted by the TMR are completed by the backend.
> Especially in case of tcmu backend, if userspace executes long
> running commands and therefore initiator sends ABORT_TASK on
> timeout, the ABORT itself can time out if core still waits for
> userspace/tcmu to complete the command.
> 
> It would be very helpful for userspace to get a notification
> about received TMR and which commands were aborted by that TMR.
> Then userspace can decide whether to cancel command processing,
> and it can send command completion earlier than it would without
> TMR notification.
> It is also helpful for userspace traces and device emulation to
> get notification about TMR events.
> 
> So this patch series in the first two patches implements in
> core the usage of a new optional backend callback for TMR
> notifications. The core calls it before core waits for
> completion of aborted commands (params: se_dev, TMR type,
> and list of se_cmds aborted by this TMR).
> Of course other backends than tcmu can use this part of the
> series also to implement their own TMR notification if
> necessary.
> 
> The further six patches implement the TMR notify callback for
> tcmu. The new configFS attribute tmr_notification allows to
> switch on TMR messages on the cmd ring. The default of the
> attribute is the old behavior without TMR info on the ring, but
> with following changes:
>  - if tcmu receives an already aborted command, it immediately
>    rejects it. So it will never appear in userspace.
>  - if tcmu finds, that according to TMR notification a cmd on
>    the qfull_queue was aborted, tcmu removes it from qfull_queue
>    and completes it immediately. So userspace will not 'see'
>    those commands.
> 
> When attribute tmr_notification is set to 1, tcmu additionally
> prepares a list of cmd_ids from those commands, that are aborted
> by the TMR and are active in cmd ring (not timed out).
> This list together with the TMR type is either immediately
> written to cmd ring (new TMR entry type) or queued in a separate
> tmr queue if ring space is too small.
> TMRs in the tmr queue do not time out. If ring space becomes
> available, tcmu moves TMRs from tmr queue to ring with higher
> priority than cmds from qfull queue.
> 
> This mechanism makes sure that userspace receives TMR
> notifications as early as possible. Userspace can use the
> list of cmd_ids attached to the TMR notification to identify
> aborted commands from its list of received and not yet completed
> commands. In case userspace has meanwhile completed some of the
> cmd_ids on the list, it can just ignore these cmd_ids.
> A possible new command having the same cmd_id as one of the
> aborted commands will always appear on the ring after the TMR
> notification.
> 

Thanks for all the work on this.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
