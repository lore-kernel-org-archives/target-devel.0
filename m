From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:22 +0000
Subject: [PATCH 04/14] target: Make the session shutdown code also wait for commands that are being aborted
Message-Id: <20180301222632.31507-5-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Target drivers must call target_sess_cmd_list_set_waiting() and
target_wait_for_sess_cmds() before freeing a session. Since freeing
a session is only safe after all commands that are associated with
a session have finished, make target_wait_for_sess_cmds() also wait
for commands that are being aborted. Instead of setting a flag in
each pending command from target_sess_cmd_list_set_waiting() and
waiting in target_wait_for_sess_cmds() on a per-command completion,
only set a per-session flag in the former function and wait on
a per-session completion in the latter function. This change is
safe because once a SCSI initiator system has submitted a command
a target system is always allowed to execute it to completion. See
also commit 0f4a943168f3 ("target: Fix remote-port TMR ABORT +
se_cmd fabric stop").

This patch is based on the following two patches:
* Bart Van Assche, target: Simplify session shutdown code, February 19, 2015
  (https://github.com/bvanassche/linux/commit/8df5463d7d7619f2f1b70cfe5172eaef0aa52815).
* Christoph Hellwig, target: Rework session shutdown code, December 7, 2015
  (http://thread.gmane.org/gmane.linux.scsi.target.devel/10695).

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_tmr.c       |  5 +-
 drivers/target/target_core_transport.c | 84 +++++++++++-----------------------
 include/target/target_core_base.h      |  3 +-
 3 files changed, 29 insertions(+), 63 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 9c7bc1ca341a..da8125dd3a4c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -142,7 +142,7 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 			return false;
 		}
 	}
-	if (sess->sess_tearing_down || se_cmd->cmd_wait_set) {
+	if (sess->sess_tearing_down) {
 		pr_debug("Attempted to abort io tag: %llu already shutdown,"
 			" skipping\n", se_cmd->tag);
 		spin_unlock(&se_cmd->t_state_lock);
@@ -187,7 +187,6 @@ void core_tmr_abort_task(
 		if (!__target_check_io_state(se_cmd, se_sess, 0))
 			continue;
 
-		list_del_init(&se_cmd->se_cmd_list);
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
 		cancel_work_sync(&se_cmd->work);
@@ -259,7 +258,7 @@ static void core_tmr_drain_tmr_list(
 			spin_unlock(&sess->sess_cmd_lock);
 			continue;
 		}
-		if (sess->sess_tearing_down || cmd->cmd_wait_set) {
+		if (sess->sess_tearing_down) {
 			spin_unlock(&cmd->t_state_lock);
 			spin_unlock(&sess->sess_cmd_lock);
 			continue;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f649cf0bed75..ad975e038b10 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -237,8 +237,8 @@ struct se_session *transport_init_session(enum target_prot_op sup_prot_ops)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
-	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
+	init_waitqueue_head(&se_sess->cmd_list_wq);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -2664,20 +2664,23 @@ static void target_release_cmd_kref(struct kref *kref)
 
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+		if (likely(!list_empty(&se_cmd->se_cmd_list))) {
+			list_del(&se_cmd->se_cmd_list);
+			if (list_empty(&se_sess->sess_cmd_list))
+				wake_up(&se_sess->cmd_list_wq);
+		}
 
 		spin_lock(&se_cmd->t_state_lock);
 		fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP) &&
 			      (se_cmd->transport_state & CMD_T_ABORTED);
 		spin_unlock(&se_cmd->t_state_lock);
 
-		if (se_cmd->cmd_wait_set || fabric_stop) {
-			list_del_init(&se_cmd->se_cmd_list);
+		if (fabric_stop) {
 			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 			target_free_cmd_mem(se_cmd);
 			complete(&se_cmd->cmd_wait_comp);
 			return;
 		}
-		list_del_init(&se_cmd->se_cmd_list);
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	}
 
@@ -2800,77 +2803,42 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-/* target_sess_cmd_list_set_waiting - Flag all commands in
- *         sess_cmd_list to complete cmd_wait_comp.  Set
- *         sess_tearing_down so no more commands are queued.
+/**
+ * target_sess_cmd_list_set_waiting - Set sess_tearing_down so no new commands are queued.
  * @se_sess:	session to flag
  */
 void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd, *tmp_cmd;
 	unsigned long flags;
-	int rc;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	if (se_sess->sess_tearing_down) {
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-		return;
-	}
 	se_sess->sess_tearing_down = 1;
-	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
-
-	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				 &se_sess->sess_wait_list, se_cmd_list) {
-		rc = kref_get_unless_zero(&se_cmd->cmd_kref);
-		if (rc) {
-			se_cmd->cmd_wait_set = 1;
-			spin_lock(&se_cmd->t_state_lock);
-			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
-			spin_unlock(&se_cmd->t_state_lock);
-		} else
-			list_del_init(&se_cmd->se_cmd_list);
-	}
-
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
 EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
-/* target_wait_for_sess_cmds - Wait for outstanding descriptors
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
  * @se_sess:    session to wait for active I/O
  */
 void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd, *tmp_cmd;
-	unsigned long flags;
-	bool tas;
-
-	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_wait_list, se_cmd_list) {
-		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
-			" %d\n", se_cmd, se_cmd->t_state,
-			se_cmd->se_tfo->get_cmd_state(se_cmd));
-
-		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
-		tas = (se_cmd->transport_state & CMD_T_TAS);
-		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
-
-		if (!target_put_sess_cmd(se_cmd)) {
-			if (tas)
-				target_put_sess_cmd(se_cmd);
-		}
-
-		wait_for_completion(&se_cmd->cmd_wait_comp);
-		pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
-			" fabric state: %d\n", se_cmd, se_cmd->t_state,
-			se_cmd->se_tfo->get_cmd_state(se_cmd));
-
-		se_cmd->se_tfo->release_cmd(se_cmd);
-	}
-
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	WARN_ON(!list_empty(&se_sess->sess_cmd_list));
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+	struct se_cmd *cmd;
+	int ret;
 
+	WARN_ON_ONCE(!se_sess->sess_tearing_down);
+
+	spin_lock_irq(&se_sess->sess_cmd_lock);
+	do {
+		ret = wait_event_interruptible_lock_irq_timeout(
+				se_sess->cmd_list_wq,
+				list_empty(&se_sess->sess_cmd_list),
+				se_sess->sess_cmd_lock, 180 * HZ);
+		list_for_each_entry(cmd, &se_sess->sess_cmd_list, se_cmd_list)
+			target_show_cmd("session shutdown: still waiting for ",
+					cmd);
+	} while (ret <= 0);
+	spin_unlock_irq(&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f9f5902af38..b9fb73f2dcbb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -442,7 +442,6 @@ struct se_cmd {
 	u8			scsi_asc;
 	u8			scsi_ascq;
 	u16			scsi_sense_length;
-	unsigned		cmd_wait_set:1;
 	unsigned		unknown_data_length:1;
 	bool			state_active:1;
 	u64			tag; /* SAM command identifier aka task tag */
@@ -604,8 +603,8 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
-	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
+	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct percpu_ida	sess_tag_pool;
 };
-- 
2.16.2

