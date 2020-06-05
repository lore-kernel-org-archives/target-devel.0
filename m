From: Pavel Zakharov <pavel.zakharov@delphix.com>
Date: Fri, 05 Jun 2020 21:12:37 +0000
Subject: iscsi-target: hang if connection closed when processing LUN resets
Message-Id: <21949F25-9DA7-4A5C-829E-B730365414AB@delphix.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Maurizio Lombardi <mlombard@redhat.com>, David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

This issue can be reproduced when running with a Windows initiator and is triggered by a 60 second disk IO timeout in Windows.

This happens when the device that backs the backstore is extremely slow for a short period of time. From my observation, if an iSCSI request takes more than 60 seconds, Windows will send a LUN RESET command to the target, followed by an iSCSI Login command 20 seconds later. If the LUN RESET has not completed by the time the iSCSI Login is received (due to very slow backend IO), there’s a very high chance this bug will be hit.

When an iSCSI Login request is received, the existing connection is closed, and so iscsit_release_commands_from_conn() is called. The logic for freeing commands in iscsit_release_commands_from_conn() will free an aborted command despite the command still being in the drain_tmr_list of core_tmr_drain_tmr_list(). When this command is finally processed by core_tmr_drain_tmr_list(), its cmd_kref is already at 0, so target_put_cmd_and_wait() will bring its cmd_kref to -1 and the function will never return. iscsit_release_commands_from_conn() will then be stuck waiting for the LUN reset command to be freed, and so the iSCSI connection will never be closed nor re-established.

When this issue is hit, we can see 3 hung tasks. I’ve inserted some functions in the stack as they were inlined by the compiler.

INFO: task kworker/0:2:93 blocked for more than 120 seconds.
      Tainted: P        W  OE     5.0.0-1020-azure #21~18.04.1-Ubuntu
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
kworker/0:2     D    0    93      2 0x80000000
Workqueue: events target_tmr_work [target_core_mod]
Call Trace:
 __schedule+0x2a2/0x870
 schedule+0x2c/0x70
 schedule_timeout+0x1db/0x360
 ? do_invalid_op+0x3b/0x50
 ? target_core_exit_configfs+0x136/0xaa1 [target_core_mod]
 ? invalid_op+0x14/0x20
 wait_for_completion+0xb4/0x130
 ? wake_up_q+0x80/0x80
 target_put_cmd_and_wait+0x72/0xa0 [target_core_mod]
 (core_tmr_drain_state_list)
 core_tmr_lun_reset+0x2fd/0x6b0 [target_core_mod]
 target_tmr_work+0xa8/0xf0 [target_core_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40


INFO: task kworker/4:1:210 blocked for more than 120 seconds.
      Tainted: P        W  OE     5.0.0-1020-azure #21~18.04.1-Ubuntu
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
kworker/4:1     D    0   210      2 0x80000000
Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
Call Trace:
 __schedule+0x2a2/0x870
 schedule+0x2c/0x70
 schedule_timeout+0x1db/0x360
 wait_for_completion+0xb4/0x130
 ? wake_up_q+0x80/0x80
 iscsit_stop_session+0x185/0x1a0 [iscsi_target_mod]
 iscsi_check_for_session_reinstatement+0x1d2/0x280 [iscsi_target_mod]
 iscsi_target_check_for_existing_instances+0x2f/0x40 [
 iscsi_target_do_login+0x2e6/0x5e0 [iscsi_target_mod]
 iscsi_target_do_login_rx+0x268/0x330 [iscsi_target_mod]
 ? iscsi_target_restore_sock_callbacks+0xd0/0xd0 [iscsi_target_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40


INFO: task iscsi_ttx:10910 blocked for more than 120 seconds.
      Tainted: P        W  OE     5.0.0-1020-azure #21~18.04.1-Ubuntu
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
iscsi_ttx       D    0 10910      2 0x80000084
Call Trace:
 __schedule+0x2a2/0x870
 schedule+0x2c/0x70
 schedule_timeout+0x1db/0x360
 ? iscsit_release_cmd+0x91/0xe0 [iscsi_target_mod]
 ? kfree+0x169/0x180
 wait_for_completion+0xb4/0x130
 ? wake_up_q+0x80/0x80
 transport_generic_free_cmd+0x8e/0x160 [target_core_mod]
 iscsit_free_cmd+0x43/0x90 [iscsi_target_mod]
 (iscsit_release_commands_from_conn)
 iscsit_close_connection+0x4f5/0x850 [iscsi_target_mod]
 iscsit_take_action_for_connection_exit+0x7f/0x110 [iscsi_target_mod]
 iscsi_target_tx_thread+0x166/0x1f0 [iscsi_target_mod]
 ? wait_woken+0x80/0x80
 kthread+0x121/0x140
 ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40

Given that the thread that is re-establishing the connection is stuck, but the initiator keeps attempting to establish a connection we’ll see the following messages printed every 20 seconds:
iSCSI Login timeout on Network Portal 0.0.0.0:3260
iSCSI Login negotiation failed.

It also generated a bunch of warnings. I’ve included the actual warning that was hit.

WARNING: CPU: 10 PID: 223 at /build/linux-azure-9v78ef/linux-azure-5.0.0/drivers/target/target_core_transport.c:790 target_handle_abort+0xe0/0x1a0 [target_core_mod]
WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0);
Call Trace:
 target_abort_work+0x15/0x20 [target_core_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40

WARNING: CPU: 2 PID: 280 at /build/linux-azure-9v78ef/linux-azure-5.0.0/drivers/target/target_core_transport.c:798 target_handle_abort+0xe7/0x1a0 [target_core_mod]
WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
Call Trace:
 target_abort_work+0x15/0x20 [target_core_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40

WARNING: CPU: 13 PID: 221 at /build/linux-azure-9v78ef/linux-azure-5.0.0/drivers/target/iscsi/iscsi_target_util.c:751 __iscsit_free_cmd+0x22a/0x270 [iscsi_target_mod]
WARN_ON(!list_empty(&cmd->i_conn_node));
Workqueue: target_completion target_abort_work [target_core_mod]
Call Trace:
 iscsit_aborted_task+0x72/0x80 [iscsi_target_mod]
 lio_aborted_task+0x2a/0x30 [iscsi_target_mod]
 target_handle_abort+0x4a/0x1a0 [target_core_mod]
 target_abort_work+0x15/0x20 [target_core_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40

WARNING: CPU: 1 PID: 95 at /build/linux-azure-9v78ef/linux-azure-5.0.0/drivers/target/iscsi/iscsi_target_util.c:727 iscsit_release_cmd+0xd4/0xe0 [iscsi_target_mod]
WARN_ON(!list_empty(&cmd->i_conn_node));
Workqueue: events target_tmr_work [target_core_mod]
Call Trace:
 lio_release_cmd+0x1e/0x50 [iscsi_target_mod]
 target_release_cmd_kref+0xfe/0x240 [target_core_mod]
 target_put_cmd_and_wait+0x6a/0xa0 [target_core_mod]
 core_tmr_lun_reset+0x2fd/0x6b0 [target_core_mod]
 target_tmr_work+0xa8/0xf0 [target_core_mod]
 process_one_work+0x1f7/0x3f0
 worker_thread+0x34/0x400
 kthread+0x121/0x140
 ? process_one_work+0x3f0/0x3f0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x1f/0x40

Note that some of those warnings are generated in a slightly different scenario, where the command is first processed by core_tmr_drain_tmr_list(), and then later is freed by iscsit_release_commands_from_conn(), at which point the cmd_kref will also be at -1, but no hang would occur. When multiple commands are aborted by LUN RESET, we’ll often see a combination of both scenarios at the same time, depending on how the commands are ordered in the 2 lists.

I’ve got a tentative fix for this issue, which seems to solve that problem, but I haven’t yet tested a few scenarios:
1. I’ve been running with ERL=0. ERL=2 might behave somewhat differently.
2. I’m not sure what would happen if there’s several LUN RESETS /ABORT TASKS happening at the same time, or if there are multiple LUNs being reset.
3. I haven’t tested with persistent reservation.
4. Although I have emulate_tas=1, CMD_T_TAS is not set because of a condition in __target_check_io_state() that also checks for tmr_sess != se_cmd->se_sess which returned false in my tests.

In the meanwhile, I’d like to know what folks think about the tentative fix:

From ebb0af5b1d71944ae98e6589cadd98af2fb15904 Mon Sep 17 00:00:00 2001
From: Pavel Zakharov <pavel.zakharov@delphix.com>
Date: Fri, 5 Jun 2020 16:02:17 -0400
Subject: [PATCH] cmd_kref leak prevents reestablishing iSCSI connection

When a LUN_RESET TMR is being processed and an iSCSI connection is closed
at the same time, cmd_kref goes to -1 causing multiple issues, that
culminate in several threads hanging, which prevents the closed iSCSI
connection from being re-established.

Signed-off-by: Pavel Zakharov <pavel.zakharov@delphix.com>
---
 drivers/target/iscsi/iscsi_target.c | 46 ++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..68806e8f3d43 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -483,9 +483,7 @@ EXPORT_SYMBOL(iscsit_queue_rsp);
 void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	spin_lock_bh(&conn->cmd_lock);
-	if (!list_empty(&cmd->i_conn_node) &&
-	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
-		list_del_init(&cmd->i_conn_node);
+	list_del_init(&cmd->i_conn_node);
 	spin_unlock_bh(&conn->cmd_lock);
 
 	__iscsit_free_cmd(cmd, true);
@@ -4056,7 +4054,8 @@ int iscsi_target_rx_thread(void *arg)
 
 static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 {
-	LIST_HEAD(tmp_list);
+	LIST_HEAD(tmp_cmd_list);
+	LIST_HEAD(tmp_tmr_list);
 	struct iscsi_cmd *cmd = NULL, *cmd_tmp = NULL;
 	struct iscsi_session *sess = conn->sess;
 	/*
@@ -4065,9 +4064,9 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	 * has been reset -> returned sleeping pre-handler state.
 	 */
 	spin_lock_bh(&conn->cmd_lock);
-	list_splice_init(&conn->conn_cmd_list, &tmp_list);
+	list_splice_init(&conn->conn_cmd_list, &tmp_cmd_list);
 
-	list_for_each_entry(cmd, &tmp_list, i_conn_node) {
+	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_cmd_list, i_conn_node) {
 		struct se_cmd *se_cmd = &cmd->se_cmd;
 
 		if (se_cmd->se_tfo != NULL) {
@@ -4075,11 +4074,44 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			spin_unlock_irq(&se_cmd->t_state_lock);
 		}
+
+		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+			list_move_tail(&cmd->i_conn_node, &tmp_tmr_list);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_list, i_conn_node) {
+	/*
+	 * We must wait for TMRs to be processed first. Any commands that were
+	 * aborted by those TMRs will have been freed and removed from the
+	 * tmp_cmd_list once we have finished traversing tmp_tmr_list.
+	 */
+	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_tmr_list, i_conn_node) {
+		struct se_cmd *se_cmd = &cmd->se_cmd;
+
+		spin_lock_bh(&conn->cmd_lock);
 		list_del_init(&cmd->i_conn_node);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsit_increment_maxcmdsn(cmd, sess);
+		iscsit_free_cmd(cmd, true);
+	}
+
+	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_cmd_list, i_conn_node) {
+		struct se_cmd *se_cmd = &cmd->se_cmd;
+
+		/*
+		 * We shouldn't be freeing any aborted commands here. Those
+		 * commands should be freed by iscsit_aborted_task, and the
+		 * last reference will be released by target_put_cmd_and_wait,
+		 * called from core_tmr_drain_tmr_list or core_tmr_abort_task.
+		 */
+		spin_lock_irq(&se_cmd->t_state_lock);
+		WARN_ON(se_cmd->transport_state & CMD_T_ABORTED);
+		spin_unlock_irq(&se_cmd->t_state_lock);
+
+		spin_lock_bh(&conn->cmd_lock);
+		list_del_init(&cmd->i_conn_node);
+		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
 		iscsit_free_cmd(cmd, true);
-- 
2.21.1 (Apple Git-122.3)
