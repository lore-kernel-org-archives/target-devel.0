From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:06 +0000
Subject: [PATCH 19/20] target: Fix handling of removed LUNs
Message-Id: <20180622215307.8758-20-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Send a valid ASC / ASCQ combination back to the initiator if a SCSI
command is received after a LUN has been removed. This patch fixes
the following call trace:

WARNING: CPU: 0 PID: 4 at drivers/target/target_core_transport.c:3131 translate_sense_reason+0x164/0x190 [target_core_mod]
Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
RIP: 0010:translate_sense_reason+0x164/0x190 [target_core_mod]
Call Trace:
transport_send_check_condition_and_sense+0x95/0x1c0 [target_core_mod]
transport_generic_request_failure+0x102/0x270 [target_core_mod]
transport_generic_new_cmd+0x138/0x340 [target_core_mod]
transport_handle_cdb_direct+0x2f/0x80 [target_core_mod]
target_submit_cmd_map_sgls+0x212/0x2a0 [target_core_mod]
srpt_handle_new_iu+0x244/0x680 [ib_srpt]
__ib_process_cq+0x6d/0xc0 [ib_core]
ib_cq_poll_work+0x18/0x50 [ib_core]
process_one_work+0x20b/0x6a0
worker_thread+0x35/0x380
kthread+0x117/0x130
ret_from_fork+0x24/0x30

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_transport.c | 23 +++++++++++++++----
 drivers/target/target_core_ua.c        | 31 +++++++++++++++-----------
 drivers/target/target_core_ua.h        |  3 ++-
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a71cfae46805..7261561e87cc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3170,12 +3170,23 @@ static const struct sense_info sense_info_table[] = {
 	},
 };
 
+/**
+ * translate_sense_reason - translate a sense reason into T10 key, asc and ascq
+ * @cmd: SCSI command in which the resulting sense buffer or SCSI status will
+ *   be stored.
+ * @reason: LIO sense reason code. If this argument has the value
+ *   TCM_CHECK_CONDITION_UNIT_ATTENTION, try to dequeue a unit attention. If
+ *   dequeuing a unit attention fails due to multiple commands being processed
+ *   concurrently, set the command status to BUSY.
+ *
+ * Return: 0 upon success or -EINVAL if the sense buffer is too small.
+ */
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
 	const struct sense_info *si;
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
-	u8 asc, ascq;
+	u8 key, asc, ascq;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
 	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
@@ -3184,9 +3195,13 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 		si = &sense_info_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
+	key = si->key;
 	if (reason = TCM_CHECK_CONDITION_UNIT_ATTENTION) {
-		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
-		WARN_ON_ONCE(asc = 0);
+		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
+						       &ascq)) {
+			cmd->scsi_status = SAM_STAT_BUSY;
+			return;
+		}
 	} else if (si->asc = 0) {
 		WARN_ON_ONCE(cmd->scsi_asc = 0);
 		asc = cmd->scsi_asc;
@@ -3199,7 +3214,7 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
-	scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
+	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
 	if (si->add_sector_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index be25eb807a5f..9399b38339f9 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -202,10 +202,13 @@ void core_scsi3_ua_release_all(
 	spin_unlock(&deve->ua_lock);
 }
 
-void core_scsi3_ua_for_check_condition(
-	struct se_cmd *cmd,
-	u8 *asc,
-	u8 *ascq)
+/*
+ * Dequeue a unit attention from the unit attention list. This function
+ * returns true if the dequeuing succeeded and if *@key, *@asc and *@ascq have
+ * been set.
+ */
+bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
+				       u8 *ascq)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *deve;
@@ -214,23 +217,23 @@ void core_scsi3_ua_for_check_condition(
 	struct se_ua *ua = NULL, *ua_p;
 	int head = 1;
 
-	if (!sess)
-		return;
+	if (WARN_ON_ONCE(!sess))
+		return false;
 
 	nacl = sess->se_node_acl;
-	if (!nacl)
-		return;
+	if (WARN_ON_ONCE(!nacl))
+		return false;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
 	if (!deve) {
 		rcu_read_unlock();
-		return;
-	}
-	if (!atomic_read(&deve->ua_count)) {
-		rcu_read_unlock();
-		return;
+		*key = ILLEGAL_REQUEST;
+		*asc = 0x25; /* LOGICAL UNIT NOT SUPPORTED */
+		*ascq = 0;
+		return true;
 	}
+	*key = UNIT_ATTENTION;
 	/*
 	 * The highest priority Unit Attentions are placed at the head of the
 	 * struct se_dev_entry->ua_list, and will be returned in CHECK_CONDITION +
@@ -273,6 +276,8 @@ void core_scsi3_ua_for_check_condition(
 		(dev->dev_attrib.emulate_ua_intlck_ctrl != 0) ? "Reporting" :
 		"Releasing", dev->dev_attrib.emulate_ua_intlck_ctrl,
 		cmd->orig_fe_lun, cmd->t_task_cdb[0], *asc, *ascq);
+
+	return head = 0;
 }
 
 int core_scsi3_ua_clear_for_request_sense(
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index b0f4205a96cd..76487c9be090 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -37,7 +37,8 @@ extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
 extern int core_scsi3_ua_allocate(struct se_dev_entry *, u8, u8);
 extern void target_ua_allocate_lun(struct se_node_acl *, u32, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
-extern void core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *);
+extern bool core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *,
+					      u8 *);
 extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
 						u8 *, u8 *);
 
-- 
2.17.1

