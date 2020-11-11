From: Michael Christie <michael.christie@oracle.com>
Date: Wed, 11 Nov 2020 15:37:51 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <5D26782D-1249-4A2C-8BF9-7176D5B85F55@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
 <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
In-Reply-To: <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, m.lombardi85@gmail.com



> On Nov 11, 2020, at 8:58 AM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> 
> 
> 
> Dne 11. 11. 20 v 3:16 Mike Christie napsal(a):
>> Hey, I tested this out and I do not think this will happen. We will get stuck waiting on the TMF completion for the affected cmd/cmds.
>> 
>> In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get moved to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is set, and iscsit_release_commands_from_conn will would put it back onto the conn_cmd_list. But then it will see the ABORT on the list. We will then wait on the ABORT in:
>> 
>> iscsit_release_commands_from_conn -> iscsit_free_cmd -> transport_generic_free_cmd.
> 
> Hi Mike,
> 
> I'm not sure if I understood this part.
> 
> The commands are moved to the tmp_list;
> we check for CMD_T_ABORTED and eventually move the commands from tmp_list back to conn_cmd_list
> because it's the abort task the one that should do the cleanup.

I’m not sure what you mean here. Are you saying both CMD1’s se_cmd and the ABORT’s se_cmd will have the CMD_T_ABORTED bit set and will both go through the aborted_task callout?


> 
> iscsit_release_commands_from_conn() then scans the tmp_list and calls iscsit_free_cmd()... but not against
> those commands with CMD_T_ABORTED flag set because we just moved them back to conn_cmd_list
> and aren't linked to tmp_list anymore.
> 
> Am I missing something?


If you have a SCSI READ/WRITE se_cmd (CMD1 in my example) and a ABORT se_cmd (ABORT TMF in my example) on the conn_cmd_list, then the ABORT’s se_cmd would not have the CMD_T_ABORTED bit set, right? If so, what sets it?

If the SCSI R/W has the CMD_T_ABORTED bit set, we move it it back to the conn_cmd_list and the abort code path cleans it up. But then we still have the ABORT’s se_cmd on the tmp_list. We will then call 

transport_generic_free_cmd(wait_for_tasks=true) -> __transport_wait_for_tasks(fabric_stop=true)

And wait for the ABORT to complete, and the ABORT does not complete until the last ref on the command it’s aborting completes.

If you have a LUN RESET in the mix like:

[CMD1 -> ABORT TMF -> LUN RESET TMF]

Then CMD1 and the ABORT could have their CMD_T_ABORTED bit set. core_tmr_drain_tmr_list would call __target_check_io_state during the RESET processing. However, in this case, the LUN RESET’s se_cmd would not have the bit set, so we would end up waiting like I described for that to complete. In that case though the RESET waits for the cmds and tmfs it is cleaning up.
