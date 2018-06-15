From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:35 +0000
Subject: [PATCH 26/33] TCMU PR: add PR ops function pointers
Message-Id: <20180615182342.6239-26-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a struct target_pr_ops contains TCMU
Persistent Reservation operation functions. Added a
"struct target_pr_ops" type pointer in target_backend_ops,
so that we can call TCMU PR functions from struct
target_backend_ops.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c    |  6 +++++
 include/target/target_core_backend.h | 36 ++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 09a341e935a9..ea3685106d35 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -3701,6 +3701,11 @@ static struct configfs_attribute *tcmu_action_attrs[] = {
 	NULL,
 };
 
+static struct target_pr_ops tcmu_pr_ops = {
+	.pr_read_keys		= tcmu_execute_pr_read_keys,
+	.pr_register		= tcmu_execute_pr_register,
+};
+
 static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
@@ -3717,6 +3722,7 @@ static struct target_backend_ops tcmu_ops = {
 	.get_device_type	= sbc_get_device_type,
 	.get_blocks		= tcmu_get_blocks,
 	.tb_dev_action_attrs	= tcmu_action_attrs,
+	.pr_ops			= &tcmu_pr_ops,
 };
 
 static void find_free_blocks(void)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 34a15d59ed88..36a820429cf4 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -51,11 +51,47 @@ struct target_backend_ops {
 	int (*init_prot)(struct se_device *);
 	int (*format_prot)(struct se_device *);
 	void (*free_prot)(struct se_device *);
+	struct target_pr_ops *pr_ops;
 
 	struct configfs_attribute **tb_dev_attrib_attrs;
 	struct configfs_attribute **tb_dev_action_attrs;
 };
 
+enum target_pr_check_type {
+	/* check for *any* SCSI2 reservations, including own */
+	TARGET_PR_CHECK_SCSI2_ANY,
+	/* check for conflicting SCSI2 or SCSI3 reservation */
+	TARGET_PR_CHECK_SCSI2_SCSI3,
+};
+
+struct target_pr_ops {
+	sense_reason_t (*check_conflict)(struct se_cmd *cmd,
+					 enum target_pr_check_type);
+	sense_reason_t (*scsi2_reserve)(struct se_cmd *cmd);
+	sense_reason_t (*scsi2_release)(struct se_cmd *cmd);
+	sense_reason_t (*reset)(struct se_device *dev);
+	sense_reason_t (*pr_register)(struct se_cmd *cmd, u64 old_key,
+				      u64 new_key, bool aptpl, bool all_tg_pt,
+				      bool spec_i_pt, bool ignore_existing);
+	sense_reason_t (*pr_reserve)(struct se_cmd *cmd, int type, u64 key);
+	sense_reason_t (*pr_release)(struct se_cmd *cmd, int type, u64 key);
+	sense_reason_t (*pr_clear)(struct se_cmd *cmd, u64 key);
+	sense_reason_t (*pr_preempt)(struct se_cmd *cmd, u64 old_key,
+				     u64 new_key, int type, bool abort);
+	sense_reason_t (*pr_register_and_move)(struct se_cmd *cmd, u64 old_key,
+					       u64 new_key, bool aptpl,
+					       int unreg);
+	sense_reason_t (*pr_read_keys)(struct se_cmd *cmd, unsigned char *buf,
+				       u32 buf_len);
+	sense_reason_t (*pr_read_reservation)(struct se_cmd *cmd,
+					      unsigned char *buf, u32 buf_len);
+	sense_reason_t (*pr_report_capabilities)(struct se_cmd *cmd,
+						 unsigned char *buf,
+						 u32 buf_len);
+	sense_reason_t (*pr_read_full_status)(struct se_cmd *cmd,
+					      unsigned char *buf, u32 buf_len);
+};
+
 struct sbc_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
 				     u32, enum dma_data_direction);
-- 
2.17.1

