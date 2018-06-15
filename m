From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:21 +0000
Subject: [PATCH 12/33] TCMU PR: add a function to free tcmu_pr_info
Message-Id: <20180615182342.6239-12-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_pr_info_free() which can
help free struct tcmu_pr_info.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 55f1ba98a688..09a4f97243b8 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2131,6 +2131,20 @@ static int tcmu_pr_info_reg_encode(char *buf, size_t buf_remain,
 	return rc;
 }
 
+static void
+tcmu_pr_info_free(struct tcmu_pr_info *pr_info)
+{
+	struct tcmu_pr_reg *reg;
+	struct tcmu_pr_reg *reg_n;
+
+	kfree(pr_info->scsi2_rsv);
+	kfree(pr_info->rsv);
+	list_for_each_entry_safe(reg, reg_n, &pr_info->regs, regs_node) {
+		kfree(reg);
+	}
+	kfree(pr_info);
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

