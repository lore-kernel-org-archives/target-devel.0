From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 26 Jul 2020 18:37:10 +0000
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
Message-Id: <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
In-Reply-To: <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/26/20 6:02 AM, Bodo Stroesser wrote:
> On 2020-07-26 07:16, Mike Christie wrote:
>> On 7/15/20 11:04 AM, Bodo Stroesser wrote:
>>> Fix:
>>> After calling the aborted_task callback the core immediately
>>> releases the se_cmd that represents the ABORT_TASK. The woken
>>> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
>>> and tl_cmd in case of aborted TMRs.
>>
>> The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?
> 
> No. For an aborted ABORT_TASK, target_handle_abort is called.
> If tas is not set, it executes this code:
> 
>         } else {
>                 /*
>                  * Allow the fabric driver to unmap any resources before
>                  * releasing the descriptor via TFO->release_cmd().
>                  */
>                 cmd->se_tfo->aborted_task(cmd);
>                 if (ack_kref)
>                         WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
>                 /*
>                  * To do: establish a unit attention condition on the I_T
>                  * nexus associated with cmd. See also the paragraph "Aborting
>                  * commands" in SAM.
>                  */
>         }
> 
>         WARN_ON_ONCE(kref_read(&cmd->cmd_kref) = 0);
> 
>         transport_lun_remove_cmd(cmd);
> 
>         transport_cmd_check_stop_to_fabric(cmd);
> 
> That means: no matter whether SCF_ACK_REF is set in the cmd or not:
> 1) fabric's aborted_task handler and a waiter woken up by aborted_task must not call target_put_sess_cmd.
> 2) a waiter woken up by aborted_task() must not access se_cmd (or tl_cmd) since target_handle_abort
>    might have released it completely meanwhile.
> 

Oh no, so xen has the same cmd lifetime issue as loop right?

And, it looks like iscsi has an issue too. I can hit both of those WARNs.

I'm ok with your patch, but is there a way to fix this in core for everyone?

It seems like something that must have worked at some point for everyone, but we broke. I'll try to get some time today and git bisect this to see if it's a regression.
