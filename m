From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 23:49:58 +0000
Subject: [PATCH-3.18.y 1/2] iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
Message-Id: <1515801798-32155-2-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1515801798-32155-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1515801798-32155-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Donald White <dew@datera.io>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit ae072726f6109bb1c94841d6fb3a82dde298ea85 upstream.

Since commit 59b6986dbf fixed a potential NULL pointer dereference
by allocating a se_tmr_req for ISCSI_TM_FUNC_TASK_REASSIGN, the
se_tmr_req is currently leaked by iscsit_free_cmd() because no
iscsi_cmd->se_cmd.se_tfo was associated.

To address this, treat ISCSI_TM_FUNC_TASK_REASSIGN like any other
TMR and call transport_init_se_cmd() + target_get_sess_cmd() to
setup iscsi_cmd->se_cmd.se_tfo with se_cmd->cmd_kref of 2.

This will ensure normal release operation once se_cmd->cmd_kref
reaches zero and target_release_cmd_kref() is invoked, se_tmr_req
will be released via existing target_free_cmd_mem() and
core_tmr_release_req() code.

Reported-by: Donald White <dew@datera.io>
Cc: Donald White <dew@datera.io>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9582f08..1850597 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1750,7 +1750,6 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct iscsi_tmr_req *tmr_req;
 	struct iscsi_tm *hdr;
 	int out_of_order_cmdsn = 0, ret;
-	bool sess_ref = false;
 	u8 function, tcm_function = TMR_UNKNOWN;
 
 	hdr			= (struct iscsi_tm *) buf;
@@ -1792,19 +1791,17 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 					     buf);
 	}
 
+	transport_init_se_cmd(&cmd->se_cmd, &lio_target_fabric_configfs->tf_ops,
+			      conn->sess->se_sess, 0, DMA_NONE,
+			      MSG_SIMPLE_TAG, cmd->sense_buffer + 2);
+
+	target_get_sess_cmd(&cmd->se_cmd, true);
+
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
 	 * LIO-Target $FABRIC_MOD
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-		transport_init_se_cmd(&cmd->se_cmd,
-				      &lio_target_fabric_configfs->tf_ops,
-				      conn->sess->se_sess, 0, DMA_NONE,
-				      MSG_SIMPLE_TAG, cmd->sense_buffer + 2);
-
-		target_get_sess_cmd(&cmd->se_cmd, true);
-		sess_ref = true;
-
 		switch (function) {
 		case ISCSI_TM_FUNC_ABORT_TASK:
 			tcm_function = TMR_ABORT_TASK;
@@ -1943,12 +1940,8 @@ attach:
 	 * For connection recovery, this is also the default action for
 	 * TMR TASK_REASSIGN.
 	 */
-	if (sess_ref) {
-		pr_debug("Handle TMR, using sess_ref=true check\n");
-		target_put_sess_cmd(&cmd->se_cmd);
-	}
-
 	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+	target_put_sess_cmd(&cmd->se_cmd);
 	return 0;
 }
 EXPORT_SYMBOL(iscsit_handle_task_mgt_cmd);
-- 
1.8.5.3

