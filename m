From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:56 +0000
Subject: [PATCH 09/20] target: Fold core_tmr_handle_tas_abort() into transport_cmd_finish_abort()
Message-Id: <20180622215307.8758-10-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

For the two calls to transport_cmd_finish_abort() outside
core_tmr_handle_tas_abort() it is guaranteed that CMD_T_TAS is not
set. Use this property to fold core_tmr_handle_tas_abort() into
transport_cmd_finish_abort(). This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_internal.h  |  2 +-
 drivers/target/target_core_tmr.c       | 16 +++-------------
 drivers/target/target_core_transport.c | 10 +++++++---
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index dead30b1d32c..0c6635587930 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,7 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-int	transport_cmd_finish_abort(struct se_cmd *, int);
+int	transport_cmd_finish_abort(struct se_cmd *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 08af053e7990..6d1179a7f043 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -75,16 +75,6 @@ void core_tmr_release_req(struct se_tmr_req *tmr)
 	kfree(tmr);
 }
 
-static int core_tmr_handle_tas_abort(struct se_cmd *cmd, int tas)
-{
-	bool send_tas = cmd->transport_state & CMD_T_TAS;
-
-	if (send_tas)
-		transport_send_task_abort(cmd);
-
-	return transport_cmd_finish_abort(cmd, !send_tas);
-}
-
 static int target_check_cdb_and_preempt(struct list_head *list,
 		struct se_cmd *cmd)
 {
@@ -183,7 +173,7 @@ void core_tmr_abort_task(
 		cancel_work_sync(&se_cmd->work);
 		transport_wait_for_tasks(se_cmd);
 
-		if (!transport_cmd_finish_abort(se_cmd, true))
+		if (!transport_cmd_finish_abort(se_cmd))
 			target_put_sess_cmd(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
@@ -281,7 +271,7 @@ static void core_tmr_drain_tmr_list(
 		cancel_work_sync(&cmd->work);
 		transport_wait_for_tasks(cmd);
 
-		if (!transport_cmd_finish_abort(cmd, 1))
+		if (!transport_cmd_finish_abort(cmd))
 			target_put_sess_cmd(cmd);
 	}
 }
@@ -370,7 +360,7 @@ static void core_tmr_drain_state_list(
 		cancel_work_sync(&cmd->work);
 		transport_wait_for_tasks(cmd);
 
-		if (!core_tmr_handle_tas_abort(cmd, tas))
+		if (!transport_cmd_finish_abort(cmd))
 			target_put_sess_cmd(cmd);
 	}
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 47318f64296d..3f95ddea6b1c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -688,23 +688,27 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 		percpu_ref_put(&lun->lun_ref);
 }
 
-int transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
+int transport_cmd_finish_abort(struct se_cmd *cmd)
 {
+	bool send_tas = cmd->transport_state & CMD_T_TAS;
 	bool ack_kref = (cmd->se_cmd_flags & SCF_ACK_KREF);
 	int ret = 0;
 
+	if (send_tas)
+		transport_send_task_abort(cmd);
+
 	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD)
 		transport_lun_remove_cmd(cmd);
 	/*
 	 * Allow the fabric driver to unmap any resources before
 	 * releasing the descriptor via TFO->release_cmd()
 	 */
-	if (remove)
+	if (!send_tas)
 		cmd->se_tfo->aborted_task(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return 1;
-	if (remove && ack_kref)
+	if (!send_tas && ack_kref)
 		ret = target_put_sess_cmd(cmd);
 
 	return ret;
-- 
2.17.1

