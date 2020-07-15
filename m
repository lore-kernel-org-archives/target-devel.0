From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 15 Jul 2020 16:04:03 +0000
Subject: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
Message-Id: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

If an ABORT_TASK TMR is aborted by a LUN_RESET, core calls
tcm_loop's aborted_task fabric callback for the ABORT_TASK.

The aborted_task callback is not prepared to handle aborted TMRs,
but is an empty function which is ok for aborted SCSI cmds only.
So it does not wake up tcm_loop_issue_tmr() sleeping in
wait_for_completion(). Therefore scmd_eh_abort_handler
hangs forever and we get the following messages:

INFO: task kworker/u48:1:31216 blocked for more than 3932 seconds.
      Tainted: G           OE     5.8.0-rc1+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u48:1   D    0 31216      2 0x00004000
Workqueue: scsi_tmf_14 scmd_eh_abort_handler [scsi_mod]
Call Trace:
 __schedule+0x2aa/0x6d0
 schedule+0x42/0xb0
 schedule_timeout+0x1ba/0x280
 ? __queue_work+0x13b/0x3d0
 ? kmem_cache_alloc_trace+0x1e6/0x200
 wait_for_completion+0x7f/0xd0
 tcm_loop_issue_tmr.isra.10+0xc1/0x110 [tcm_loop]
 tcm_loop_abort_task+0x3d/0x50 [tcm_loop]
 scmd_eh_abort_handler+0x91/0x230 [scsi_mod]
 process_one_work+0x166/0x370
 worker_thread+0x49/0x3e0
 ? rescuer_thread+0x320/0x320
 kthread+0xfc/0x130
 ? kthread_bind+0x10/0x10
 ret_from_fork+0x22/0x30

Fix:
After calling the aborted_task callback the core immediately
releases the se_cmd that represents the ABORT_TASK. The woken
up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
and tl_cmd in case of aborted TMRs.

So I changed aborted_task and queue_tm_rsp to transfer result
code from se_cmd to tcm_loop_issue_tmr's stack and added the
missing wake_up() to aborted_task.
Now tcm_loop_issue_tmr after waking up no longer accesses se_cmd
and tl_cmd. Therefore tcm_loop_issue_tmr no longer needs to call
target_put_sess_cmd and flag TARGET_SCF_ACK_KREF is no longer
needed in se_cmd.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/loopback/tcm_loop.c | 39 ++++++++++++++++++++++----------------
 drivers/target/loopback/tcm_loop.h |  4 +++-
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e117a2..0968bc8b6640 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -199,6 +199,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_cmd *tl_cmd;
 	int ret = TMR_FUNCTION_FAILED, rc;
+	DECLARE_COMPLETION_ONSTACK(compl);
 
 	/*
 	 * Locate the tl_nexus and se_sess pointers
@@ -213,26 +214,23 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	if (!tl_cmd)
 		return ret;
 
-	init_completion(&tl_cmd->tmr_done);
+	tl_cmd->is_tmr = true;
+	tl_cmd->tmr_done = &compl;
+	tl_cmd->tmr_result = &ret;
 
 	se_cmd = &tl_cmd->tl_se_cmd;
 	se_sess = tl_tpg->tl_nexus->se_sess;
 
 	rc = target_submit_tmr(se_cmd, se_sess, tl_cmd->tl_sense_buf, lun,
-			       NULL, tmr, GFP_KERNEL, task,
-			       TARGET_SCF_ACK_KREF);
-	if (rc < 0)
-		goto release;
-	wait_for_completion(&tl_cmd->tmr_done);
-	ret = se_cmd->se_tmr_req->response;
-	target_put_sess_cmd(se_cmd);
+			       NULL, tmr, GFP_KERNEL, task, 0);
+	if (rc < 0) {
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+		return ret;
+	}
 
-out:
-	return ret;
+	wait_for_completion(tl_cmd->tmr_done);
 
-release:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
-	goto out;
+	return ret;
 }
 
 static int tcm_loop_abort_task(struct scsi_cmnd *sc)
@@ -590,13 +588,22 @@ static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 
-	/* Wake up tcm_loop_issue_tmr(). */
-	complete(&tl_cmd->tmr_done);
+	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
+	*tl_cmd->tmr_result = se_cmd->se_tmr_req->response;
+	complete(tl_cmd->tmr_done);
 }
 
 static void tcm_loop_aborted_task(struct se_cmd *se_cmd)
 {
-	return;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+
+	if (!tl_cmd->is_tmr)
+		return;
+
+	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
+	*tl_cmd->tmr_result = TMR_FUNCTION_REJECTED;
+	complete(tl_cmd->tmr_done);
 }
 
 static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..e7615b9f5ed1 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -17,7 +17,9 @@ struct tcm_loop_cmd {
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
 	struct work_struct work;
-	struct completion tmr_done;
+	struct completion *tmr_done;
+	bool is_tmr;
+	int *tmr_result;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.12.3
