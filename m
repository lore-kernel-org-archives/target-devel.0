From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:19 +0000
Subject: [PATCH 10/33] TCMU PR: add funcs to handle PR registrations num
Message-Id: <20180615182342.6239-10-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added two functions: tcmu_pr_info_num_regs_decode()
and tcmu_pr_info_num_regs_encode() to handle the number of
Persistent Reservation registrations.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b72c61d81f98..8e61641f34ac 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2046,6 +2046,40 @@ static int tcmu_pr_info_rsv_encode(char *buf, size_t buf_remain,
 	return rc;
 }
 
+static int
+tcmu_pr_info_num_regs_decode(char *str, u32 *num_regs)
+{
+	int rc;
+
+	if (!num_regs) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	rc = sscanf(str, "0x%08x", num_regs);
+	if (rc != 1) {
+		pr_err("failed to parse PR num regs: %s\n", str);
+		return -EINVAL;
+	}
+	pr_debug("processed pr_info num_regs: %s\n", str);
+
+	return 0;
+}
+
+static int tcmu_pr_info_num_regs_encode(char *buf, size_t buf_remain,
+					u32 num_regs)
+{
+	int rc;
+
+	rc = snprintf(buf, buf_remain, "0x%08x\n", num_regs);
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode PR num_regs\n");
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

