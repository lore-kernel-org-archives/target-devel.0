From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:59 +0000
Subject: [PATCH 12/20] target: Simplify the code for waiting for command completion
Message-Id: <20180622215307.8758-13-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of embedding the completion that is used for waiting for
command completion in struct se_cmd, let the context that waits for
command completion allocate it. This makes it possible to have a
single code path for non-aborted and aborted commands in
target_release_cmd_kref() and avoids that transport_generic_free_cmd()
has to call cmd->se_tfo->release_cmd() directly. This patch does not
change any functionality. Note: transport_generic_free_cmd() only
waits until the se_cmd reference count has reached zero after it has
set both CMD_T_FABRIC_STOP and CMD_T_ABORTED.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 24 ++++++++----------------
 include/target/target_core_base.h      |  2 +-
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ebd54fc1f13a..cb48dbc2c9ba 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1309,7 +1309,7 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
-	init_completion(&cmd->cmd_wait_comp);
+	cmd->compl = NULL;
 	spin_lock_init(&cmd->t_state_lock);
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
@@ -2658,6 +2658,7 @@ static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
  */
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
+	DECLARE_COMPLETION_ONSTACK(compl);
 	int ret = 0;
 	bool aborted = false, tas = false;
 
@@ -2676,12 +2677,13 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
 	}
+	if (aborted)
+		cmd->compl = &compl;
 	if (!aborted || tas)
 		ret = target_put_sess_cmd(cmd);
 	if (aborted) {
 		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
-		wait_for_completion(&cmd->cmd_wait_comp);
-		cmd->se_tfo->release_cmd(cmd);
+		wait_for_completion(&compl);
 		ret = 1;
 	}
 	return ret;
@@ -2742,31 +2744,21 @@ static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct completion *compl = se_cmd->compl;
 	unsigned long flags;
-	bool fabric_stop;
 
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
 		if (list_empty(&se_sess->sess_cmd_list))
 			wake_up(&se_sess->cmd_list_wq);
-
-		spin_lock(&se_cmd->t_state_lock);
-		fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP) &&
-			      (se_cmd->transport_state & CMD_T_ABORTED);
-		spin_unlock(&se_cmd->t_state_lock);
-
-		if (fabric_stop) {
-			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-			target_free_cmd_mem(se_cmd);
-			complete(&se_cmd->cmd_wait_comp);
-			return;
-		}
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	}
 
 	target_free_cmd_mem(se_cmd);
 	se_cmd->se_tfo->release_cmd(se_cmd);
+	if (compl)
+		complete(compl);
 }
 
 /**
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 906c1fc485e4..ca59e065c1fd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -475,7 +475,7 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct list_head	se_cmd_list;
-	struct completion	cmd_wait_comp;
+	struct completion	*compl;
 	const struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
 	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
-- 
2.17.1

