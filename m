From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:38 +0000
Subject: [PATCH 29/33] TCMU PR: enable PRO Reserve for TCMU devices
Message-Id: <20180615182342.6239-29-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch would enable the passthrough Persist Reservation
Reserve operation routine for TCMU devices.
If dev->passthrough_pr is 1, both dev->transport->pr_ops
and dev->transport->pr_ops->pr_register are not NULL,
core_scsi3_emulate_pro_reserve() will call
dev->transport->pr_ops->pr_reserve to passthrough data to
user space.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_pr.c   | 11 ++++++++++-
 drivers/target/target_core_user.c |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 0a06b8bb1134..d47ccbf05679 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2450,6 +2450,8 @@ static sense_reason_t
 core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 		u64 res_key)
 {
+	struct se_device *dev = cmd->se_dev;
+
 	switch (type) {
 	case PR_TYPE_WRITE_EXCLUSIVE:
 	case PR_TYPE_EXCLUSIVE_ACCESS:
@@ -2457,7 +2459,14 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
-		return core_scsi3_pro_reserve(cmd, type, scope, res_key);
+		if (dev->transport->pr_ops &&
+		    dev->transport->pr_ops->pr_register &&
+		    dev->passthrough_pr)
+			return dev->transport->pr_ops->pr_reserve(cmd, type,
+								  res_key);
+		else
+			return core_scsi3_pro_reserve(cmd, type, scope,
+						      res_key);
 	default:
 		pr_err("SPC-3 PR: Unknown Service Action RESERVE Type:"
 			" 0x%02x\n", type);
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8390b1d37873..e7daa76317bc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -3011,6 +3011,7 @@ tcmu_execute_pr_reserve(struct se_cmd *cmd, int type, u64 key)
 	sense_reason_t ret;
 	int retries = 0;
 
+	mutex_lock(&udev->pr_info.pr_info_lock);
 	udev->pr_info.pr_info_buf = kzalloc(TCMU_PR_INFO_XATTR_MAX_SIZE,
 					    GFP_KERNEL);
 	if (!udev->pr_info.pr_info_buf)
@@ -3127,6 +3128,7 @@ tcmu_execute_pr_reserve(struct se_cmd *cmd, int type, u64 key)
 	tcmu_pr_info_free(pr_info);
 	kfree(pr_xattr);
 	kfree(udev->pr_info.pr_info_buf);
+	mutex_unlock(&udev->pr_info.pr_info_lock);
 	return ret;
 }
 
-- 
2.17.1

