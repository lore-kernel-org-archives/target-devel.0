From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:28 +0000
Subject: [PATCH 19/33] TCMU PR: add functions to unregister a reg
Message-Id: <20180615182342.6239-19-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added four functions: tcmu_pr_info_clear_reg() would
delete a registration from a struct tcmu_pr_info,
tcmu_pr_info_rsv_clear() would clear the reservation,
tcmu_is_rsv_holder() would check whether the registration is a
reservation holder. Then tcmu_pr_info_unregister_reg() would
call the functions above to unregister the registration.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 75 +++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5d0da54072cd..a6e951f04065 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -41,6 +41,7 @@
 #include <target/target_core_backend.h>
 
 #include <linux/target_core_user.h>
+#include "target_core_pr.h"
 
 /*
  * Define a shared-memory interface for LIO to pass SCSI commands and
@@ -2539,6 +2540,80 @@ tcmu_execute_pr_register_new(struct tcmu_pr_info *pr_info, u64 old_key,
 	return ret;
 }
 
+static bool tcmu_is_rsv_holder(struct tcmu_pr_rsv *rsv,
+			       struct tcmu_pr_reg *reg, bool *rsv_is_all_reg)
+{
+	if (!rsv || !reg) {
+		WARN_ON(1);
+		return false;
+	}
+	if ((rsv->type = PR_TYPE_WRITE_EXCLUSIVE_ALLREG)
+	    || (rsv->type = PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
+		/* any registeration is a reservation holder */
+		if (rsv_is_all_reg)
+			*rsv_is_all_reg = true;
+		return true;
+	}
+
+	if (rsv_is_all_reg)
+		*rsv_is_all_reg = false;
+
+	if ((rsv->key = reg->key)
+	    && !strncmp(rsv->it_nexus, reg->it_nexus,
+			ARRAY_SIZE(rsv->it_nexus))) {
+		return true;
+	}
+
+	return false;
+}
+
+static void tcmu_pr_info_clear_reg(struct tcmu_pr_info *pr_info,
+				   struct tcmu_pr_reg *reg)
+{
+	list_del(&reg->regs_node);
+	pr_info->num_regs--;
+
+	pr_debug("deleted pr_info reg: 0x%llx\n", reg->key);
+
+	kfree(reg);
+}
+
+static void tcmu_pr_info_rsv_clear(struct tcmu_pr_info *pr_info)
+{
+	kfree(pr_info->rsv);
+	pr_info->rsv = NULL;
+
+	pr_debug("pr_info rsv cleared\n");
+}
+
+static int tcmu_pr_info_unregister_reg(struct tcmu_pr_info *pr_info,
+				       struct tcmu_pr_reg *reg)
+{
+	struct tcmu_pr_rsv *rsv;
+	bool all_reg = false;
+
+	rsv = pr_info->rsv;
+	if (rsv && tcmu_is_rsv_holder(rsv, reg, &all_reg)) {
+		/*
+		 * If the persistent reservation holder is more than one I_T
+		 * nexus, the reservation shall not be released until the
+		 * registrations for all persistent reservation holder I_T
+		 * nexuses are removed.
+		 */
+		if (!all_reg || (pr_info->num_regs = 1)) {
+			pr_warn("implicitly releasing PR of type %d",
+				rsv->type);
+			pr_warn("on unregister I_T Nexus %s\n",
+				reg->it_nexus);
+			tcmu_pr_info_rsv_clear(pr_info);
+		}
+	}
+
+	tcmu_pr_info_clear_reg(pr_info, reg);
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

