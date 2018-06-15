From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:27 +0000
Subject: [PATCH 18/33] TCMU PR: add a function to register a new IT Nexus
Message-Id: <20180615182342.6239-18-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_execute_pr_register_new() which
can help to register an unregistered I_T Nexus.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 291b3ff4555d..5d0da54072cd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2505,6 +2505,40 @@ static int tcmu_pr_info_append_reg(struct tcmu_pr_info *pr_info,
 	return 0;
 }
 
+/* handle PR registration for a currently unregistered I_T nexus */
+static sense_reason_t
+tcmu_execute_pr_register_new(struct tcmu_pr_info *pr_info, u64 old_key,
+			     u64 new_key, char *it_nexus,
+			     bool ignore_existing)
+{
+	sense_reason_t ret;
+	int rc;
+
+	pr_debug("PR registration for unregistered nexus: %s\n", it_nexus);
+	if (!ignore_existing && (old_key != 0)) {
+		ret = TCM_RESERVATION_CONFLICT;
+		goto out;
+	}
+	if (new_key = 0) {
+		ret = TCM_NO_SENSE;
+		goto out;
+	}
+	/*
+	 * Register the I_T nexus on which the command was received with
+	 * the value specified in the SERVICE ACTION RESERVATION KEY
+	 * field.
+	 */
+	rc = tcmu_pr_info_append_reg(pr_info, it_nexus, new_key);
+	if (rc < 0) {
+		ret = TCM_OUT_OF_RESOURCES;
+		goto out;
+	}
+
+	ret = TCM_NO_SENSE;
+out:
+	return ret;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

