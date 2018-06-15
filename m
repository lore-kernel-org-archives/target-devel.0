From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:20 +0000
Subject: [PATCH 11/33] TCMU PR: add funcs to handle TCMU PR registrations
Message-Id: <20180615182342.6239-11-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a struct tcmu_pr_reg which contain Persistent
Reservation registrations information, also added two functions
tcmu_pr_info_reg_decode() and tcmu_pr_info_reg_encode() to handle
it.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8e61641f34ac..55f1ba98a688 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -228,6 +228,13 @@ struct tcmu_scsi2_rsv {
 	char it_nexus[TCMU_PR_IT_NEXUS_MAXLEN];
 	};
 
+struct tcmu_pr_reg {
+	struct list_head regs_node;
+	u64 key;	/* registered key */
+	/* I-T nexus for registration */
+	char it_nexus[TCMU_PR_IT_NEXUS_MAXLEN];
+};
+
 /*
  * To avoid dead lock the mutex lock order should always be:
  *
@@ -2080,6 +2087,50 @@ static int tcmu_pr_info_num_regs_encode(char *buf, size_t buf_remain,
 	return rc;
 }
 
+static int tcmu_pr_info_reg_decode(char *str, struct tcmu_pr_reg **_reg)
+{
+	struct tcmu_pr_reg *reg;
+	int rc;
+
+	if (!_reg) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg)
+		return -ENOMEM;
+
+	/* registration key and I-T nexus with space separator */
+	rc = sscanf(str, "0x%016llx %" __stringify(TCMU_PR_IT_NEXUS_MAXLEN)
+			 "s", &reg->key, reg->it_nexus);
+	if (rc != 2) {
+		pr_err("failed to parse PR reg: %s\n", str);
+		kfree(reg);
+		return -EINVAL;
+	}
+
+	pr_debug("processed pr_info reg: %s\n", str);
+	*_reg = reg;
+
+	return 0;
+}
+
+static int tcmu_pr_info_reg_encode(char *buf, size_t buf_remain,
+				   struct tcmu_pr_reg *reg)
+{
+	int rc;
+
+	rc = snprintf(buf, buf_remain, "0x%016llx %s\n", reg->key,
+		      reg->it_nexus);
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode PR registration\n");
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

