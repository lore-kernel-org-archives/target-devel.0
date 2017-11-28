From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:37 +0000
Subject: [PATCH 11/15] tcmu: prep queue_cmd_ring to be used by unmap wq
Message-Id: <1511894441-8626-12-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

In the next patches we will call queue_cmd_ring from the submitting
context and also the completion path. This changes the queue_cmd_ring
return code so in the next patches we can return a sense_reason_t
and also signal if a command was requeued.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 42 +++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8d0dc47..68d1d72 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -776,8 +776,16 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	return 0;
 }
 
-static sense_reason_t
-tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
+/**
+ * queue_cmd_ring - queue cmd to ring or internally
+ * @tcmu_cmd: cmd to queue
+ * @scsi_err: TCM error code if failure (-1) returned.
+ *
+ * Returns:
+ * -1 we cannot queue internally or to the ring.
+ *  0 success
+ */
+static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
@@ -791,8 +799,12 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	bool copy_to_data_area;
 	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
 
-	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	*scsi_err = TCM_NO_SENSE;
+
+	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
+		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		return -1;
+	}
 
 	/*
 	 * Must be a certain minimum size for response sense info, but
@@ -819,7 +831,8 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 			"cmd ring/data area\n", command_size, data_length,
 			udev->cmdr_size, udev->data_size);
 		mutex_unlock(&udev->cmdr_lock);
-		return TCM_INVALID_CDB_FIELD;
+		*scsi_err = TCM_INVALID_CDB_FIELD;
+		return -1;
 	}
 
 	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
@@ -845,7 +858,8 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 		finish_wait(&udev->wait_cmdr, &__wait);
 		if (!ret) {
 			pr_warn("tcmu: command timed out\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			return -1;
 		}
 
 		mutex_lock(&udev->cmdr_lock);
@@ -902,7 +916,9 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 		mutex_unlock(&udev->cmdr_lock);
-		return TCM_OUT_OF_RESOURCES;
+
+		*scsi_err = TCM_OUT_OF_RESOURCES;
+		return -1;
 	}
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
@@ -933,27 +949,23 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 		mod_timer(&udev->timeout, round_jiffies_up(jiffies +
 			  msecs_to_jiffies(udev->cmd_time_out)));
 
-	return TCM_NO_SENSE;
+	return 0;
 }
 
 static sense_reason_t
 tcmu_queue_cmd(struct se_cmd *se_cmd)
 {
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t ret;
+	sense_reason_t scsi_ret;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	ret = tcmu_queue_cmd_ring(tcmu_cmd);
-	if (ret != TCM_NO_SENSE) {
-		pr_err("TCMU: Could not queue command\n");
-
+	if (queue_cmd_ring(tcmu_cmd, &scsi_ret) < 0)
 		tcmu_free_cmd(tcmu_cmd);
-	}
 
-	return ret;
+	return scsi_ret;
 }
 
 static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
-- 
1.8.3.1

