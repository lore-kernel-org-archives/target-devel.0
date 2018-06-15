From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:40 +0000
Subject: [PATCH 31/33] TCMU PR: enable PRO Release for TCMU devices
Message-Id: <20180615182342.6239-31-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch would enable the passthrough Persist Reservation
Release operation routine for TCMU devices.
If dev->passthrough_pr is 1, both dev->transport->pr_ops
and dev->transport->pr_ops->pr_release are not NULL,
core_scsi3_emulate_pro_release() will call
dev->transport->pr_ops->pr_release to passthrough PR release
request to user space

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_pr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d47ccbf05679..c668dfb84bf1 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2554,6 +2554,15 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	sense_reason_t ret = 0;
 
+	if (dev->transport->pr_ops && dev->transport->pr_ops->pr_register
+	    && dev->passthrough_pr) {
+		if (scope != PR_SCOPE_LU_SCOPE) {
+			pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+			return TCM_INVALID_PARAMETER_LIST;
+		}
+		return dev->transport->pr_ops->pr_release(cmd, type, res_key);
+	}
+
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
2.17.1

