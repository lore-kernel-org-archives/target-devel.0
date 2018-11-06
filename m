From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 17:17:14 +0000
Subject: [PATCH 06/10] target/core: Make it possible to wait from more than one context for command completio
Message-Id: <20181106171718.89594-7-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality but makes the patch that
makes TMF handling synchronous easier to read.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 14 +++++++++-----
 include/target/target_core_base.h      |  3 ++-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cf76d3709683..7b77520a2b35 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1327,7 +1327,8 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
-	cmd->compl = NULL;
+	cmd->free_compl = NULL;
+	cmd->abrt_compl = NULL;
 	spin_lock_init(&cmd->t_state_lock);
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
@@ -2688,7 +2689,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 			transport_lun_remove_cmd(cmd);
 	}
 	if (aborted)
-		cmd->compl = &compl;
+		cmd->free_compl = &compl;
 	if (!aborted || tas)
 		ret = target_put_sess_cmd(cmd);
 	if (aborted) {
@@ -2755,7 +2756,8 @@ static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
-	struct completion *compl = se_cmd->compl;
+	struct completion *free_compl = se_cmd->free_compl;
+	struct completion *abrt_compl = se_cmd->abrt_compl;
 	unsigned long flags;
 
 	if (se_sess) {
@@ -2766,8 +2768,10 @@ static void target_release_cmd_kref(struct kref *kref)
 
 	target_free_cmd_mem(se_cmd);
 	se_cmd->se_tfo->release_cmd(se_cmd);
-	if (compl)
-		complete(compl);
+	if (free_compl)
+		complete(free_compl);
+	if (abrt_compl)
+		complete(abrt_compl);
 
 	percpu_ref_put(&se_sess->cmd_count);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 67130841d421..bff51baee7e0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -474,7 +474,8 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct list_head	se_cmd_list;
-	struct completion	*compl;
+	struct completion	*free_compl;
+	struct completion	*abrt_compl;
 	const struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
 	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
-- 
2.19.1.930.g4563a0d9d0-goog
