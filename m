From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Jun 2018 18:32:12 +0000
Subject: Re: [PATCH 04/14] target: Make the session shutdown code also wait for commands that are being abort
Message-Id: <5B1EC02C.80003@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-5-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-5-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/01/2018 04:26 PM, Bart Van Assche wrote:
> Target drivers must call target_sess_cmd_list_set_waiting() and
> target_wait_for_sess_cmds() before freeing a session. Since freeing
> a session is only safe after all commands that are associated with
> a session have finished, make target_wait_for_sess_cmds() also wait
> for commands that are being aborted. Instead of setting a flag in
> each pending command from target_sess_cmd_list_set_waiting() and
> waiting in target_wait_for_sess_cmds() on a per-command completion,
> only set a per-session flag in the former function and wait on
> a per-session completion in the latter function. This change is
> safe because once a SCSI initiator system has submitted a command
> a target system is always allowed to execute it to completion. See
> also commit 0f4a943168f3 ("target: Fix remote-port TMR ABORT +
> se_cmd fabric stop").
> 
> This patch is based on the following two patches:
> * Bart Van Assche, target: Simplify session shutdown code, February 19, 2015
>   (https://github.com/bvanassche/linux/commit/8df5463d7d7619f2f1b70cfe5172eaef0aa52815).
> * Christoph Hellwig, target: Rework session shutdown code, December 7, 2015
>   (http://thread.gmane.org/gmane.linux.scsi.target.devel/10695).
> 

Hey Bart,

I think the patch looks ok bug/behavior wise. I was just wondering why
there is the difference between iscsi and the rest of the target drivers.

It looks like with this patch iscsi is the only driver that can do a
transport_generic_free_cmd call with wait_for_tasks=true when something
like a iscsi connection is stopped, so it is the only one that now uses
the CMD_T_FABRIC_STOP bit and all the related code.

It looks like all other drivers do something like you mention above and
do a target_sess_cmd_list_set_waiting+target_wait_for_sess_cmds sequence.

Is the only reason for this due to the struct se_session mapping to a
struct iscsi_session and we might need to wait on commands in a specific
connection in a session or was there some other race/TMF type of issue?



