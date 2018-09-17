From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:46 +0000
Subject: [PATCH 09/17] target/core: Always call transport_complete_callback() upon failure
Message-Id: <20180917213554.987-10-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Call transport_complete_callback() not only if COMPARE AND WRITE fails but
also if XDWRITEREAD fails. This makes the code more systematic.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_sbc.c       |  6 +++++-
 drivers/target/target_core_transport.c | 11 +++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4719e6a98430..c155e12ae8b9 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -360,6 +360,10 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 	unsigned int offset;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int i, count;
+
+	if (!success)
+		return 0;
+
 	/*
 	 * From sbc3r22.pdf section 5.48 XDWRITEREAD (10) command
 	 *
@@ -431,7 +435,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	 * sent to the backend driver.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
-	if (cmd->transport_state & CMD_T_SENT) {
+	if (success) {
 		cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
 		*post_ret = 1;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ec3cb16b9e0e..79fa79afcdc2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1793,7 +1793,7 @@ EXPORT_SYMBOL(target_submit_tmr);
 void transport_generic_request_failure(struct se_cmd *cmd,
 		sense_reason_t sense_reason)
 {
-	int ret = 0, post_ret = 0;
+	int ret = 0;
 
 	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
 		 sense_reason);
@@ -1804,13 +1804,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	 */
 	transport_complete_task_attr(cmd);
 
-	/*
-	 * Handle special case for COMPARE_AND_WRITE failure, where the
-	 * callback is expected to drop the per device ->caw_sem.
-	 */
-	if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
-	     cmd->transport_complete_callback)
-		cmd->transport_complete_callback(cmd, false, &post_ret);
+	if (cmd->transport_complete_callback)
+		cmd->transport_complete_callback(cmd, false, NULL);
 
 	if (transport_check_aborted_status(cmd, 1))
 		return;
-- 
2.18.0
