From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 02:42:23 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
In-Reply-To: <20201007145326.56850-3-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org

On 10/7/20 9:53 AM, Maurizio Lombardi wrote:
> The iscsit_release_commands_from_conn() function does the following
> operations:
> 
> 1) locks the cmd_lock spinlock
> 2) Scans the list of commands and sets the CMD_T_FABRIC_STOP flag
> 3) Releases the cmd_lock spinlock
> 4) Rescans the list again and clears the i_conn_node link of each command
> 
> If an abort task timer is fired between 3) and 4), it will find
> the CMD_T_FABRIC_STOP flag set and won't call list_del_init();
> therefore it may end up calling __iscsit_free_cmd() with a
> non-empty i_conn_node list, thus triggering the warning.
> 
> Considering that:
> 
> - we expect list_del_init() to be executed by
>   iscsit_release_commands_from_conn() when the CMD_T_FABRIC_STOP is set.
> - iscsit_aborted_task() is the only function that calls __iscsit_free_cmd()
>   directly, while all the other functions call iscsit_free_cmd().
> - the warning in __iscsit_free_cmd() is a duplicate (the same warning
>   can be found in iscsit_free_cmd().
> 

For iscsi, what does the last put on the cmd for a successful abort. Ignore this conn stop case.

If we abort a command successfully, the abort path does:

target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd

When we create the cmd we do transport_init_se_cmd and that sets the refcount=1. We do target_get_sess_cmd with ack_kref=true so that sets refcount=2.

On the abort completion path, target_handle_abort does target_put_sess_cmd (refcount=1 after), check_stop_free ends up doing a put (refcount=0 after).

If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:

1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:

target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd

The cmd is now freed.
3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
