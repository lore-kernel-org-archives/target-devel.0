From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:15 +0000
Subject: [PATCH 06/33] TCMU PR: add decode/encode func for PR seq and ver
Message-Id: <20180615182342.6239-6-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added three functions, tcmu_pr_info_vers_seq_encode()
to encode PR sequence and version into a string,
tcmu_pr_info_vers_decode() and tcmu_pr_info_seq_decode() used
to decode them.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 62 +++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 26d8aee40719..ccb1607edd0a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -93,6 +93,8 @@
  */
 #define TCMU_GLOBAL_MAX_BLOCKS_DEF (512 * 1024)
 
+#define TCMU_PR_INFO_XATTR_VERS		1
+
 static u8 tcmu_kern_cmd_reply_supported;
 
 static struct device *tcmu_root_device;
@@ -1813,6 +1815,66 @@ tcmu_gen_it_nexus(struct se_session *se_sess,
 	return 0;
 }
 
+static int
+tcmu_pr_info_seq_decode(char *str, u32 *seq)
+{
+	int rc;
+
+	if (!seq) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	rc = sscanf(str, "0x%08x", seq);
+	if (rc != 1) {
+		pr_err("failed to decode PR info seqnum in: %s\n", str);
+		return -EINVAL;
+	}
+
+	pr_debug("processed pr_info seqnum: %u\n", *seq);
+
+	return 0;
+}
+
+static int
+tcmu_pr_info_vers_seq_encode(char *buf, size_t buf_remain, u32 vers, u32 seq)
+{
+	int rc;
+
+	rc = snprintf(buf, buf_remain, "0x%08x\n0x%08x\n",
+		      vers, seq);
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode PR vers and seq\n");
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
+static int
+tcmu_pr_info_vers_decode(char *str, u32 *vers)
+{
+	int rc;
+
+	if (!vers) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	rc = sscanf(str, "0x%08x", vers);
+	if (rc != 1) {
+		pr_err("failed to decode PR info version in: %s\n", str);
+		return -EINVAL;
+	}
+
+	if (*vers != TCMU_PR_INFO_XATTR_VERS) {
+		pr_err("unsupported PR info version: %u\n", *vers);
+		return -EINVAL;
+	}
+
+	pr_debug("processed pr_info version: %u\n", *vers);
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

