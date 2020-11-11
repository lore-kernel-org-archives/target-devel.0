From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 11 Nov 2020 02:16:12 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
In-Reply-To: <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org

On 10/28/20 12:09 PM, Maurizio Lombardi wrote:
> 
> 
> Dne 27. 10. 20 v 21:03 Michael Christie napsal(a):
>>
>>
>>> On Oct 27, 2020, at 12:54 PM, Mike Christie <michael.christie@oracle.com> wrote:
>>>
>>> On 10/27/20 8:49 AM, Maurizio Lombardi wrote:
>>>> Hello Mike,
>>>>
>>>> Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
>>>>> If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:
>>>>>
>>>>> 1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
>>>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:
>>>>>
>>>>> target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd
>>>>>
>>>>> The cmd is now freed.
>>>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
>>>>>
>>>>>
>>>>
>>>> Thanks for the review!
>>>>
>>>> There are definitely some problems with task aborts and commands' refcounting *
>>>> but this is a different bug than the one this patch is trying to solve (a race to list_del_init());
>>>> unless you are saying that abort tasks should never be executed when the connection
>>>> is going down and we have to prevent such cases from happening at all.
>>>
>>> Yeah, I think if we prevent the race then we fix the refcount issue and your issue.
>>> Here is a patch that is only compile tested:
>>>
>>>  From 209709bcedd9a6ce6003e6bb86f3ebf547dca6af Mon Sep 17 00:00:00 2001
>>> From: Mike Christie <michael.christie@oracle.com>
>>> Date: Tue, 27 Oct 2020 12:30:53 -0500
>>> Subject: [PATCH] iscsi target: fix cmd abort vs fabric stop race
>>>
>>> The abort and cmd stop paths can race where:
>>>
>>> 1. thread1 runs iscsit_release_commands_from_conn and sets
>>> CMD_T_FABRIC_STOP.
>>> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It
>>> then returns from the aborted_task callout and we finish
>>> target_handle_abort and do:
>>>
>>> target_handle_abort -> transport_cmd_check_stop_to_fabric ->
>>> lio_check_stop_free -> target_put_sess_cmd
>>>
>>> The cmd is now freed.
>>> 3. thread1 now finishes iscsit_release_commands_from_conn and runs
>>> iscsit_free_cmd while accessing a command we just released.
>>>
>>> In __target_check_io_state we check for CMD_T_FABRIC_STOP and set the
>>> CMD_T_ABORTED if the driver is not cleaning up the cmd because of
>>> a session shutdown. However, iscsit_release_commands_from_conn only
>>> sets the CMD_T_FABRIC_STOP and does not check to see if the abort path
>>> has claimed completion ownership of the command.
>>>
>>> This adds a check in iscsit_release_commands_from_conn so only the
>>> abort or fabric stop path cleanup the command.
>>> ---
>>> drivers/target/iscsi/iscsi_target.c | 13 +++++++++++--
>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>> index f77e5ee..85027d3 100644
>>> --- a/drivers/target/iscsi/iscsi_target.c
>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>> @@ -483,8 +483,7 @@ int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>>> void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>>> {
>>> 	spin_lock_bh(&conn->cmd_lock);
>>> -	if (!list_empty(&cmd->i_conn_node) &&
>>> -	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
>>> +	if (!list_empty(&cmd->i_conn_node))
>>> 		list_del_init(&cmd->i_conn_node);
>>> 	spin_unlock_bh(&conn->cmd_lock);
>>>
>>> @@ -4088,6 +4087,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>>>
>>> 		if (se_cmd->se_tfo != NULL) {
>>> 			spin_lock_irq(&se_cmd->t_state_lock);
>>> +			if (se_cmd->transport_state & CMD_T_ABORTED) {
>>> +				/*
>>> +				 * LIO's abort path owns the cleanup for this,
>>> +				 * so put it back on the list and let
>>> +				 * aborted_task handle it.
>>> +				 */
>>> +				list_add_tail(&cmd->i_conn_node,
>>> +					      &conn->conn_cmd_list);
>>
>>
>> That should have been a move from the tmp list back to the conn_cmd_list.
> 
> Nice, it looks simple and I will test it.
> I am a bit worried there could be other possible race conditions.
> 
> Example:
> 
> thread1: connection is going to be closed,
> iscsit_release_commands_from_conn() finds a command that is about
> to be aborted, re-adds it to conn_cmd_list and proceeds.
> iscsit_close_connection() decreases the conn usage count and finally calls iscsit_free_conn(conn)
> that destroys the conn structure.
> 
> thread2: iscsit_aborted_task() gets called and tries to lock the conn->cmd_lock spinlock, dereferencing
> an invalid pointer.

Hey, I tested this out and I do not think this will happen. We will get 
stuck waiting on the TMF completion for the affected cmd/cmds.

In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get moved 
to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is set, 
and iscsit_release_commands_from_conn will would put it back onto the 
conn_cmd_list. But then it will see the ABORT on the list. We will then 
wait on the ABORT in:

iscsit_release_commands_from_conn -> iscsit_free_cmd -> 
transport_generic_free_cmd.

The abort at this time would be waiting on CMD1 in 
target_put_cmd_and_wait in target_core_tmr.c. Eventually CMD1 completes, 
aborted_task is run and the cmd is released. target_release_cmd_kref 
will then do complete on abort_compl. The abort will then wake from 
target_put_cmd_and_wait and will complete. We will then return from 
transport_generic_free_cmd for the abort.

A LUN RESET should work similarly but we would be waiting on the cmds 
and aborts and then the LUN RESET would complete.
