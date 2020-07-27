From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 27 Jul 2020 18:13:50 +0000
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
Message-Id: <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
 <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
 <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
In-Reply-To: <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/27/20 9:26 AM, Bodo Stroesser wrote:
> On 2020-07-26 20:37, Mike Christie wrote:
>> On 7/26/20 6:02 AM, Bodo Stroesser wrote:
>>> On 2020-07-26 07:16, Mike Christie wrote:
>>>> On 7/15/20 11:04 AM, Bodo Stroesser wrote:
>>>>> Fix:
>>>>> After calling the aborted_task callback the core immediately
>>>>> releases the se_cmd that represents the ABORT_TASK. The woken
>>>>> up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
>>>>> and tl_cmd in case of aborted TMRs.
>>>>
>>>> The code and fix description below look ok. I didn't get the above part though. If we have TARGET_SCF_ACK_KREF set then doesn't the se_cmd and tl_cmd stay around until we do the target_put_sess_cmd in tcm_loop_issue_tmr?
>>>
>>> No. For an aborted ABORT_TASK, target_handle_abort is called.
>>> If tas is not set, it executes this code:
>>>
>>>          } else {
>>>                  /*
>>>                   * Allow the fabric driver to unmap any resources before
>>>                   * releasing the descriptor via TFO->release_cmd().
>>>                   */
>>>                  cmd->se_tfo->aborted_task(cmd);
>>>                  if (ack_kref)
>>>                          WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
>>>                  /*
>>>                   * To do: establish a unit attention condition on the I_T
>>>                   * nexus associated with cmd. See also the paragraph "Aborting
>>>                   * commands" in SAM.
>>>                   */
>>>          }
>>>
>>>          WARN_ON_ONCE(kref_read(&cmd->cmd_kref) = 0);
>>>
>>>          transport_lun_remove_cmd(cmd);
>>>
>>>          transport_cmd_check_stop_to_fabric(cmd);
>>>
>>> That means: no matter whether SCF_ACK_REF is set in the cmd or not:
>>> 1) fabric's aborted_task handler and a waiter woken up by aborted_task must not call target_put_sess_cmd.
>>> 2) a waiter woken up by aborted_task() must not access se_cmd (or tl_cmd) since target_handle_abort
>>>     might have released it completely meanwhile.
>>>
>>
>> Oh no, so xen has the same cmd lifetime issue as loop right?
> 
> To me it looks like xen uses nearly the same code like tcm_loop did before my patch.
> There is nothing wrong with that code regarding the cmd lifetim> The problem instead is, that the thread which started a TMR (ABORT_TASK) will sleep forever if that TMR itself is aborted by a further TMR (LUN_RESET).
> This is because tcm_loop_aborted_task() misses the complete() call.
>  
> But if we just add the complete() call to XXXX_aborted_task(), we run into trouble because what core expects from fabric handlers is different:
> 1) If core calls XXXX_queue_tm_rsp(), then fabric has to release one ref count only if SCF_ACK_REF is set. Otherwise it must not.
> 2) If core calls XXXX_aborted_task(), then fabric must not release ref count, no matter whether SCF_ACK_REF is set.

Maybe we agree.

I was calling #2 a cmd lifetime issue. At least loop, xen and iscsi think they can access the cmd after aborted_cmd. For loop/xen we just don't hit it, because we hit #1 first. For iscsi we are.

> 
> So I decided for my patch to no longer use TARGET_SCF_ACK_KREF, since then we can handle both situation the same way.
> After that it was a short step to move the data fields used by the thread after wakeup() from tl_cmd to stack, because then the woken up theqard has no need to access tl_cmd, which can be freed meanwhile.
> 
> I think, the same way to fix the problem would be fine for xen also, but I'm still wondering why the thread there does not call target_put_sess_cmd, but calls transport_generic_free_cmd.

For xen and #1 and #2 I agree we can do a similar fix as you did for xen.

I would really like to figure out if #2 is a regression and understand what happened so we don't make the same mistake again and also fix iscsi. The problem with iscsi though is every couple kernels has a bug in this code path so git bisect is being a pain.
