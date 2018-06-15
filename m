From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:29 +0000
Subject: [PATCH 20/33] TCMU PR: add a func to register an existing reg
Message-Id: <20180615182342.6239-20-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_execute_pr_register_existing()
which will handle Persistent Reservation registration for a
currently registered IT_Nexus.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a6e951f04065..4b426a9061b1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2614,6 +2614,40 @@ static int tcmu_pr_info_unregister_reg(struct tcmu_pr_info *pr_info,
 	return 0;
 }
 
+/* handle PR registration for a currently registered I_T nexus */
+static sense_reason_t
+tcmu_execute_pr_register_existing(struct tcmu_pr_info *pr_info,
+				  u64 old_key, u64 new_key, char *it_nexus,
+				  struct tcmu_pr_reg *existing_reg,
+				  bool ignore_existing)
+{
+	sense_reason_t ret;
+	int rc;
+
+	pr_debug("PR registration for registered nexus: %s\n", it_nexus);
+
+	if (!ignore_existing && (old_key != existing_reg->key)) {
+		ret = TCM_RESERVATION_CONFLICT;
+		goto out;
+	}
+
+	if (new_key = 0) {
+		/* unregister */
+		rc = tcmu_pr_info_unregister_reg(pr_info, existing_reg);
+		if (rc < 0) {
+			ret = TCM_OUT_OF_RESOURCES;
+			goto out;
+		}
+	} else {
+		/* update key */
+		existing_reg->key = new_key;
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

