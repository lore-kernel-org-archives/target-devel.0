From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:11 +0000
Subject: [PATCH 03/11] target: Inline transport_put_cmd()
Message-Id: <20171031180319.19258-4-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since all transput_put_cmd() does is to call target_put_sess_cmd(),
inline transport_put_cmd() into its callers. Leave out the BUG_ON()
statement because if cmd->se_tfo = NULL then cmd->cmd_kref is 0
and kref_put() will complain anyway. Notes:
- transport_init_se_cmd() initializes both .se_tfo and .cmd_kref.
- The only target driver that does not call transport_init_se_cmd()
  for all commands is the iSCSI target driver. See also
  iscsi_target_rx_opcode().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e6a2817c8239..8c0dbb048aa7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -67,7 +67,6 @@ static void transport_complete_task_attr(struct se_cmd *cmd);
 static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev, int err, bool write_pending);
-static int transport_put_cmd(struct se_cmd *cmd);
 static void target_complete_ok_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
@@ -668,7 +667,7 @@ int transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return 1;
 	if (remove && ack_kref)
-		ret = transport_put_cmd(cmd);
+		ret = target_put_sess_cmd(cmd);
 
 	return ret;
 }
@@ -2352,22 +2351,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	cmd->t_bidi_data_nents = 0;
 }
 
-/**
- * transport_put_cmd - release a reference to a command
- * @cmd:       command to release
- *
- * This routine releases our reference to the command and frees it if possible.
- */
-static int transport_put_cmd(struct se_cmd *cmd)
-{
-	BUG_ON(!cmd->se_tfo);
-	/*
-	 * If this cmd has been setup with target_get_sess_cmd(), drop
-	 * the kref and call ->release_cmd() in kref callback.
-	 */
-	return target_put_sess_cmd(cmd);
-}
-
 void *transport_kmap_data_sg(struct se_cmd *cmd)
 {
 	struct scatterlist *sg = cmd->t_data_sg;
@@ -2603,7 +2586,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 			target_wait_free_cmd(cmd, &aborted, &tas);
 
 		if (!aborted || tas)
-			ret = transport_put_cmd(cmd);
+			ret = target_put_sess_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
 			target_wait_free_cmd(cmd, &aborted, &tas);
@@ -2619,7 +2602,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 			transport_lun_remove_cmd(cmd);
 
 		if (!aborted || tas)
-			ret = transport_put_cmd(cmd);
+			ret = target_put_sess_cmd(cmd);
 	}
 	/*
 	 * If the task has been internally aborted due to TMR ABORT_TASK
-- 
2.14.2

