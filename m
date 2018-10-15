From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Oct 2018 15:51:39 +0000
Subject: [PATCH 6/6] target/core: Always call transport_complete_callback() upon failure
Message-Id: <20181015155139.143446-7-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

COMPARE AND WRITE command execution starts with a call of
sbc_compare_and_write(). That function locks the caw_sem member in the
backend device data structure and submits a read request to the backend
driver. Upon successful completion of the read compare_and_write_callback()
gets called. That last function compares the data that has been read. If it
matches transport_complete_callback is set to compare_and_write_post and a
write request is submitted. compare_and_write_post() submits a write request
to the backend driver.

XDWRITEREAD command execution starts with sbc_execute_rw() submitting a
read to the backend device. Upon successful completion of the read the
xdreadwrite_callback() gets called. That function xors the data that has
been read with the data in the data-out buffer and stores the result in
the data-in buffer.

Call transport_complete_callback() not only if COMPARE AND WRITE fails but
also if XDWRITEREAD fails. This makes the code more systematic. Make sure
that the callback functions handle (cmd, false, NULL) argument triples fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_sbc.c       |  6 +++++-
 drivers/target/target_core_transport.c | 11 +++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 3d3568a037b1..1ac1f7d2e6c9 100644
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
@@ -426,7 +430,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	sense_reason_t ret = TCM_NO_SENSE;
 
 	spin_lock_irq(&cmd->t_state_lock);
-	if (cmd->transport_state & CMD_T_SENT) {
+	if (success) {
 		*post_ret = 1;
 
 		if (cmd->scsi_status = SAM_STAT_CHECK_CONDITION)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 468e1ca8a833..f66d7a03c651 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1778,7 +1778,7 @@ EXPORT_SYMBOL(target_submit_tmr);
 void transport_generic_request_failure(struct se_cmd *cmd,
 		sense_reason_t sense_reason)
 {
-	int ret = 0, post_ret = 0;
+	int ret = 0;
 
 	pr_debug("-----[ Storage Engine Exception; sense_reason %d\n",
 		 sense_reason);
@@ -1789,13 +1789,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
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
2.19.0.605.g01d371f741-goog
