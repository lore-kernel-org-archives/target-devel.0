From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:18 +0000
Subject: [PATCH 09/33] TCMU PR: add func to handle PR type, key, IT nexus
Message-Id: <20180615182342.6239-9-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch add two functions: tcmu_pr_info_rsv_decode() and
tcmu_pr_info_rsv_encode() to handle Persistent Reservations type,
key and IT_Nexus. This patch added a struct tcmu_pr_rsv to
store such information as well.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 72 +++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ef79de7622b6..b72c61d81f98 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -95,6 +95,7 @@
 
 #define TCMU_PR_INFO_XATTR_VERS		1
 #define TCMU_PR_INFO_XATTR_VAL_SCSI2_RSV_ABSENT		"No SPC-2 Reservation holder"
+#define TCMU_PR_INFO_XATTR_VAL_SCSI3_RSV_ABSENT		"No SPC-3 Reservation holder"
 
 #define TCMU_PR_IT_NEXUS_MAXLEN		484
 
@@ -123,6 +124,22 @@ struct tcmu_dev_pr_info {
 	char *pr_info_buf;
 	};
 
+/*
+ * Persistent reservation info. This structure is converted to and from a
+ * string in a TCMU device storage (for example, if we use a RBD, we store such
+ * a string in it's metadata) which contain PR information.
+ */
+struct tcmu_pr_rsv {
+	u64 key;	/* registered key */
+	/*
+	 * I-T nexus for reservation. Separate to reg, so that all_tg_pt flag
+	 * can be supported in future.
+	 */
+	char it_nexus[TCMU_PR_IT_NEXUS_MAXLEN];
+	int type;		/* PR_TYPE */
+	/* scope is always PR_SCOPE_LU_SCOPE */
+	};
+
 struct tcmu_dev {
 	struct list_head node;
 	struct kref kref;
@@ -1974,6 +1991,61 @@ tcmu_pr_info_gen_encode(char *buf, size_t buf_remain, u32 gen)
 	return rc;
 }
 
+static int tcmu_pr_info_rsv_decode(char *str, struct tcmu_pr_rsv **_rsv)
+{
+	struct tcmu_pr_rsv *rsv;
+	int rc;
+
+	if (!_rsv) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	if (!strncmp(str, TCMU_PR_INFO_XATTR_VAL_SCSI3_RSV_ABSENT,
+		     sizeof(TCMU_PR_INFO_XATTR_VAL_SCSI3_RSV_ABSENT))) {
+		/* no reservation. Ensure pr_info->rsv is NULL */
+		rsv = NULL;
+	} else {
+		rsv = kzalloc(sizeof(*rsv), GFP_KERNEL);
+		if (!rsv)
+			return -ENOMEM;
+
+		/* reservation key, I-T nexus and type with space separators */
+		rc = sscanf(str, "0x%016llx %"
+			    __stringify(TCMU_PR_IT_NEXUS_MAXLEN)
+			    "s 0x%08x", &rsv->key, rsv->it_nexus, &rsv->type);
+		if (rc != 3) {
+			pr_err("failed to parse PR rsv: %s\n", str);
+			kfree(rsv);
+			return -EINVAL;
+		}
+	}
+
+	pr_debug("processed pr_info rsv: %s\n", str);
+	*_rsv = rsv;
+	return 0;
+}
+
+static int tcmu_pr_info_rsv_encode(char *buf, size_t buf_remain,
+				   struct tcmu_pr_rsv *rsv)
+{
+	int rc;
+
+	if (!rsv) {
+		/* no reservation */
+		rc = snprintf(buf, buf_remain, "%s\n",
+			      TCMU_PR_INFO_XATTR_VAL_SCSI3_RSV_ABSENT);
+	} else {
+		rc = snprintf(buf, buf_remain, "0x%016llx %s 0x%08x\n",
+			      rsv->key, rsv->it_nexus, rsv->type);
+	}
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode PR reservation\n");
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

