From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:42 +0000
Subject: [PATCH 33/33] TCMU PR: enable PRO Clear for TCMU devices
Message-Id: <20180615182342.6239-33-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch would enable the passthrough Persist Reservation
clear operation routine for TCMU devices.

If dev->passthrough_pr is 1, both dev->transport->pr_ops
and dev->transport->pr_ops->pr_clear are not NULL,
core_scsi3_emulate_pro_clear() will call
dev->transport->pr_ops->pr_clear to passthrough PR clear
request to user space

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_pr.c   | 5 +++++
 drivers/target/target_core_user.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c668dfb84bf1..66bb52ab0209 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2719,6 +2719,11 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
 	u64 pr_res_mapped_lun = 0;
 	int calling_it_nexus = 0;
+
+	if (dev->transport->pr_ops && dev->transport->pr_ops->pr_read_keys
+	    && dev->passthrough_pr)
+		return dev->transport->pr_ops->pr_clear(cmd, res_key);
+
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c8d0ea330984..c417021f7099 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -4115,6 +4115,7 @@ static struct target_pr_ops tcmu_pr_ops = {
 	.pr_register		= tcmu_execute_pr_register,
 	.pr_reserve		= tcmu_execute_pr_reserve,
 	.pr_release		= tcmu_execute_pr_release,
+	.pr_clear		= tcmu_execute_pr_clear,
 };
 
 static struct target_backend_ops tcmu_ops = {
-- 
2.17.1

