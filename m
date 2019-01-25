From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:46 +0000
Subject: [PATCH 04/16] target/core: Inline transport_lun_remove_cmd()
Message-Id: <20190125183458.220477-5-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Remove the code that clears .se_lun from
transport_cmd_check_stop_to_fabric() such that the
transport_lun_remove_cmd() call can be moved into
target_release_cmd_kref(). Because this guarantees that
transport_lun_remove_cmd() will be called exactly once, it is
safe to change the cmpxchg() call into a test of
se_cmd.lun_ref_active. Inline transport_lun_remove_cmd() because
it is not worth to keep it as a separate function.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 31 +++-----------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b25d27e8ca20..6471ede00336 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -664,11 +664,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 
 	target_remove_from_state_list(cmd);
 
-	/*
-	 * Clear struct se_cmd->se_lun before the handoff to FE.
-	 */
-	cmd->se_lun = NULL;
-
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -696,17 +691,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	return cmd->se_tfo->check_stop_free(cmd);
 }
 
-static void transport_lun_remove_cmd(struct se_cmd *cmd)
-{
-	struct se_lun *lun = cmd->se_lun;
-
-	if (!lun)
-		return;
-
-	if (cmpxchg(&cmd->lun_ref_active, true, false))
-		percpu_ref_put(&lun->lun_ref);
-}
-
 static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -797,8 +781,6 @@ static void target_handle_abort(struct se_cmd *cmd)
 
 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) = 0);
 
-	transport_lun_remove_cmd(cmd);
-
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -1711,7 +1693,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 
-	transport_lun_remove_cmd(se_cmd);
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }
 
@@ -1902,7 +1883,6 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		goto queue_full;
 
 check_stop:
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2200,7 +2180,6 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
@@ -2295,7 +2274,6 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (ret)
 			goto queue_full;
 
-		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
 		return;
 	}
@@ -2321,7 +2299,6 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
-			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2357,7 +2334,6 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;
 
-			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2393,7 +2369,6 @@ static void target_complete_ok_work(struct work_struct *work)
 		break;
 	}
 
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
@@ -2720,9 +2695,6 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		 */
 		if (cmd->state_active)
 			target_remove_from_state_list(cmd);
-
-		if (cmd->se_lun)
-			transport_lun_remove_cmd(cmd);
 	}
 	if (aborted)
 		cmd->free_compl = &compl;
@@ -2794,6 +2766,9 @@ static void target_release_cmd_kref(struct kref *kref)
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 	unsigned long flags;
 
+	if (se_cmd->lun_ref_active)
+		percpu_ref_put(&se_cmd->se_lun->lun_ref);
+
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
-- 
2.20.1.495.gaa96b0ce6b-goog
