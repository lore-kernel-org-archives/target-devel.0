From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Thu, 11 Oct 2018 13:05:59 +0000
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with active signals
Message-Id: <F43269BA-4D7B-486C-87C6-0FB48FF890EA@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
 <5BBE2FBF.7080804@redhat.com>
 <1539237365.6150.32.camel@haakon3.daterainc.com>
In-Reply-To: <1539237365.6150.32.camel@haakon3.daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Bart Van Assche <bvanassche@acm.org>



> On Oct 11, 2018, at 12:56 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> 
> Hello MNC & Co,
> 
> On Wed, 2018-10-10 at 11:58 -0500, Mike Christie wrote:
>> On 10/09/2018 10:23 PM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>> 
>>> With the addition of commit 00d909a107 in v4.19-rc, it incorrectly assumes no
>>> signals will be pending for task_struct executing the normal session shutdown
>>> and I/O quiesce code-path.
>>> 
> 
> <SNIP>
> 
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>>> index 86c0156..fc3093d2 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -2754,7 +2754,7 @@ static void target_release_cmd_kref(struct kref *kref)
>>> 	if (se_sess) {
>>> 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>>> 		list_del_init(&se_cmd->se_cmd_list);
>>> -		if (list_empty(&se_sess->sess_cmd_list))
>>> +		if (se_sess->sess_tearing_down && list_empty(&se_sess->sess_cmd_list))
>> 
>> I think there is another issue with 00d909a107 and ibmvscsi_tgt.
>> 
>> The problem is that ibmvscsi_tgt never called
>> target_sess_cmd_list_set_waiting. It only called
>> target_wait_for_sess_cmds. So before 00d909a107 there was a bug in that
>> driver and target_wait_for_sess_cmds never did what was intended because
>> sess_wait_list would always be empty.
>> 
>> With 00d909a107, we no longer need to call
>> target_sess_cmd_list_set_waiting to wait for outstanding commands, so
>> for ibmvscsi_tgt will now wait for commands like we wanted. However, the
>> commit added a WARN_ON that is hit if target_sess_cmd_list_set_waiting
>> is not called, so we could hit that.
>> 
>> So I think we need to add a target_sess_cmd_list_set_waiting call in
>> ibmvscsi_tgt to go along with your patch chunk above and make sure we do
>> not trigger the WARN_ON.
>> 
> 
> Nice catch.  :)
> 
> With target_wait_for_sess_cmd() usage pre 00d909a107 doing a list-splice
> in target_sess_cmd_list_set_waiting(), this particular usage in
> ibmvscsi_tgt has always been list_empty(&sess->sess_wait_list) = true
> (eg: no se_cmd I/O is quiesced, because no se_cmd in sess_wait_list)
> since commit 712db3eb in 4.9.y code.
> 
> That said, ibmvscsi_tgt usage is very similar to vhost/scsi in the
> respect individual /sys/kernel/config/target/$FABRIC/$WWN/$TPGT/
> endpoints used by VMs do not remove their I_T nexus while the VM is
> active.
> 
> So AFAICT, ibmvscsi_tgt doesn't strictly need target_sess_wait_for_cmd()
> at all if this is true.
> 

VMs do not remove the I_T nexus while the VM is active, so we can remove
the target_wait_for_sess_cmd() call. 

-Bryant
