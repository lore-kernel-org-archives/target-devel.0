From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:47 +0000
Subject: [PATCH 10/17] target/core: Make it possible to wait from more than one context for command completio
Message-Id: <20180917213554.987-11-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality but makes the next patch
easier to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 69 ++++++++++++++++++++++----
 include/target/target_core_base.h      |  2 +-
 2 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 79fa79afcdc2..1fecd2bb53af 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1331,7 +1331,7 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
-	cmd->compl = NULL;
+	init_waitqueue_head(&cmd->release_wq);
 	spin_lock_init(&cmd->t_state_lock);
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
@@ -2649,6 +2649,47 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
+static void __target_put_cmd_and_wait(struct se_cmd *cmd, bool put)
+{
+	DEFINE_WAIT(wait);
+	long ret;
+
+	prepare_to_wait(&cmd->release_wq, &wait, TASK_UNINTERRUPTIBLE);
+	if (put)
+		target_put_sess_cmd(cmd);
+	for (;;) {
+		if (list_empty_careful(&wait.entry))
+			break;
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (list_empty_careful(&wait.entry)) {
+			set_current_state(TASK_RUNNING);
+			break;
+		}
+		ret = schedule_timeout(180 * HZ);
+		if (ret = 0)
+			target_show_cmd("still waiting for ", cmd);
+	}
+}
+
+/*
+ * Call target_put_sess_cmd() and wait until target_release_cmd_kref(@cmd) has
+ * finished.
+ */
+static void target_put_cmd_and_wait(struct se_cmd *cmd)
+{
+	__target_put_cmd_and_wait(cmd, true);
+}
+
+/*
+ * Wait until target_release_cmd_kref(@cmd) has finished. Calling this function
+ * is only safe if the release function does not free the memory allocated for
+ * @cmd. This is e.g. the case for the iSCSI target driver.
+ */
+static void target_wait_for_cmd(struct se_cmd *cmd)
+{
+	__target_put_cmd_and_wait(cmd, false);
+}
+
 /*
  * This function is called by frontend drivers after processing of a command
  * has finished.
@@ -2672,7 +2713,6 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
  */
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
-	DECLARE_COMPLETION_ONSTACK(compl);
 	int ret = 0;
 	bool aborted = false, tas = false;
 
@@ -2691,14 +2731,17 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
 	}
-	if (aborted)
-		cmd->compl = &compl;
-	if (!aborted || tas)
-		ret = target_put_sess_cmd(cmd);
 	if (aborted) {
 		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
-		wait_for_completion(&compl);
+		if (tas) {
+			target_put_cmd_and_wait(cmd);
+		} else {
+			WARN_ON_ONCE(!wait_for_tasks);
+			target_wait_for_cmd(cmd);
+		}
 		ret = 1;
+	} else {
+		ret = target_put_sess_cmd(cmd);
 	}
 	return ret;
 }
@@ -2759,9 +2802,16 @@ static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
-	struct completion *compl = se_cmd->compl;
+	struct wait_queue_head release_wq;
 	unsigned long flags;
 
+	init_waitqueue_head(&release_wq);
+	/*
+	 * No locking is required since we are in the release function and
+	 * adding to release_wq is only allowed while holding a reference.
+	 */
+	list_splice_init(&se_cmd->release_wq.head, &release_wq.head);
+
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
@@ -2770,8 +2820,7 @@ static void target_release_cmd_kref(struct kref *kref)
 
 	target_free_cmd_mem(se_cmd);
 	se_cmd->se_tfo->release_cmd(se_cmd);
-	if (compl)
-		complete(compl);
+	wake_up_all(&release_wq);
 
 	percpu_ref_put(&se_sess->cmd_count);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d084479fbe18..d93ec20710c2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -475,7 +475,7 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct list_head	se_cmd_list;
-	struct completion	*compl;
+	struct wait_queue_head	release_wq;
 	const struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
 	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
-- 
2.18.0
