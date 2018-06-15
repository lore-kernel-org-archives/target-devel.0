From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:16 +0000
Subject: [PATCH 07/33] TCMU PR: add functions to handle SCSI2 Reservation
Message-Id: <20180615182342.6239-7-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added two functions: tcmu_pr_info_scsi2_rsv_encode()
and tcmu_pr_info_scsi2_rsv_decode() to encode and decode SCSI2
Reservations.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 65 +++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ccb1607edd0a..50723ac0ed22 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -94,6 +94,9 @@
 #define TCMU_GLOBAL_MAX_BLOCKS_DEF (512 * 1024)
 
 #define TCMU_PR_INFO_XATTR_VERS		1
+#define TCMU_PR_INFO_XATTR_VAL_SCSI2_RSV_ABSENT		"No SPC-2 Reservation holder"
+
+#define TCMU_PR_IT_NEXUS_MAXLEN		484
 
 static u8 tcmu_kern_cmd_reply_supported;
 
@@ -200,6 +203,14 @@ struct tcmu_cmd {
 #define TCMU_CMD_BIT_EXPIRED 0
 	unsigned long flags;
 };
+
+/*
+ * I-T nexus for SCSI2 (RESERVE/RELEASE) reservation.
+ */
+struct tcmu_scsi2_rsv {
+	char it_nexus[TCMU_PR_IT_NEXUS_MAXLEN];
+	};
+
 /*
  * To avoid dead lock the mutex lock order should always be:
  *
@@ -1875,6 +1886,60 @@ tcmu_pr_info_vers_decode(char *str, u32 *vers)
 	return 0;
 }
 
+static int
+tcmu_pr_info_scsi2_rsv_decode(char *str, struct tcmu_scsi2_rsv **_scsi2_rsv)
+{
+	struct tcmu_scsi2_rsv *scsi2_rsv;
+
+	if (!_scsi2_rsv) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	if (!strncmp(str, TCMU_PR_INFO_XATTR_VAL_SCSI2_RSV_ABSENT,
+		     sizeof(TCMU_PR_INFO_XATTR_VAL_SCSI2_RSV_ABSENT))) {
+		scsi2_rsv = NULL;
+	} else {
+		size_t n;
+
+		scsi2_rsv = kzalloc(sizeof(*scsi2_rsv), GFP_KERNEL);
+		if (!scsi2_rsv)
+			return -ENOMEM;
+
+		n = strlcpy(scsi2_rsv->it_nexus, str,
+			    TCMU_PR_IT_NEXUS_MAXLEN);
+		if (n >= TCMU_PR_IT_NEXUS_MAXLEN) {
+			kfree(scsi2_rsv);
+			return -EINVAL;
+		}
+	}
+
+	pr_debug("processed pr_info SCSI2 rsv: %s\n", str);
+
+	*_scsi2_rsv = scsi2_rsv;
+	return 0;
+}
+
+static int
+tcmu_pr_info_scsi2_rsv_encode(char *buf, size_t buf_remain,
+			      struct tcmu_scsi2_rsv *scsi2_rsv)
+{
+	int rc;
+
+	if (!scsi2_rsv) {
+		/* no reservation */
+		rc = snprintf(buf, buf_remain, "%s\n",
+			      TCMU_PR_INFO_XATTR_VAL_SCSI2_RSV_ABSENT);
+	} else {
+		rc = snprintf(buf, buf_remain, "%s\n", scsi2_rsv->it_nexus);
+	}
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode SCSI2 reservation\n");
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

