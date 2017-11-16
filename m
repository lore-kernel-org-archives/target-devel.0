From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:29:49 +0000
Subject: [PATCH-3.10.y 1/3] target/iscsi: Fix iSCSI task reassignment handling
Message-Id: <1510813791-16082-2-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510813791-16082-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510813791-16082-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Moshe David <mdavid@infinidat.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

commit 59b6986dbfcdab96a971f9663221849de79a7556 upstream.

Allocate a task management request structure for all task management
requests, including task reassignment. This change avoids that the
se_tmr->response assignment dereferences an uninitialized se_tmr
pointer.

Reported-by: Moshe David <mdavid@infinidat.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Moshe David <mdavid@infinidat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 19 +++++++------------
 include/target/target_core_base.h   |  1 +
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d74da95..e80ae5d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1746,7 +1746,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct iscsi_tm *hdr;
 	int out_of_order_cmdsn = 0, ret;
 	bool sess_ref = false;
-	u8 function;
+	u8 function, tcm_function = TMR_UNKNOWN;
 
 	hdr			= (struct iscsi_tm *) buf;
 	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
@@ -1792,10 +1792,6 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 * LIO-Target $FABRIC_MOD
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-
-		u8 tcm_function;
-		int ret;
-
 		transport_init_se_cmd(&cmd->se_cmd,
 				      &lio_target_fabric_configfs->tf_ops,
 				      conn->sess->se_sess, 0, DMA_NONE,
@@ -1832,15 +1828,14 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		}
-
-		ret = core_tmr_alloc_req(&cmd->se_cmd, cmd->tmr_req,
-					 tcm_function, GFP_KERNEL);
-		if (ret < 0)
-			return iscsit_add_reject_cmd(cmd,
+	}
+	ret = core_tmr_alloc_req(&cmd->se_cmd, cmd->tmr_req, tcm_function,
+				 GFP_KERNEL);
+	if (ret < 0)
+		return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 
-		cmd->tmr_req->se_tmr_req = cmd->se_cmd.se_tmr_req;
-	}
+	cmd->tmr_req->se_tmr_req = cmd->se_cmd.se_tmr_req;
 
 	cmd->iscsi_opcode	= ISCSI_OP_SCSI_TMFUNC;
 	cmd->i_state		= ISTATE_SEND_TASKMGTRSP;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8e27143..0d54f60 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -214,6 +214,7 @@ enum tcm_tmreq_table {
 	TMR_LUN_RESET		= 5,
 	TMR_TARGET_WARM_RESET	= 6,
 	TMR_TARGET_COLD_RESET	= 7,
+	TMR_UNKNOWN		= 0xff,
 };
 
 /* fabric independent task management response values */
-- 
1.8.5.3

