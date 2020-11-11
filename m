From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 11 Nov 2020 14:58:42 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
In-Reply-To: <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, m.lombardi85@gmail.com



Dne 11. 11. 20 v 3:16 Mike Christie napsal(a):
> Hey, I tested this out and I do not think this will happen. We will get stuck waiting on the TMF completion for the affected cmd/cmds.
> 
> In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get moved to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is set, and iscsit_release_commands_from_conn will would put it back onto the conn_cmd_list. But then it will see the ABORT on the list. We will then wait on the ABORT in:
> 
> iscsit_release_commands_from_conn -> iscsit_free_cmd -> transport_generic_free_cmd.

Hi Mike,

I'm not sure if I understood this part.

The commands are moved to the tmp_list;
we check for CMD_T_ABORTED and eventually move the commands from tmp_list back to conn_cmd_list
because it's the abort task the one that should do the cleanup.

iscsit_release_commands_from_conn() then scans the tmp_list and calls iscsit_free_cmd()... but not against
those commands with CMD_T_ABORTED flag set because we just moved them back to conn_cmd_list
and aren't linked to tmp_list anymore.

Am I missing something?

Maurizio
