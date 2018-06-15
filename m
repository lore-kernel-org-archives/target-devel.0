From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:17 +0000
Subject: [PATCH 08/33] TCMU PR: add functions to handle PR generation
Message-Id: <20180615182342.6239-8-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added two functions: tcmu_pr_info_gen_encode()
and tcmu_pr_info_gen_decode() to encode/decode the generations of
Persistent Reservations

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 50723ac0ed22..ef79de7622b6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1940,6 +1940,40 @@ tcmu_pr_info_scsi2_rsv_encode(char *buf, size_t buf_remain,
 	return rc;
 }
 
+static int
+tcmu_pr_info_gen_decode(char *str, u32 *gen)
+{
+	int rc;
+
+	if (!gen) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	rc = sscanf(str, "0x%08x", gen);
+	if (rc != 1) {
+		pr_err("failed to parse PR gen: %s\n", str);
+		return -EINVAL;
+	}
+
+	pr_debug("processed pr_info generation: %s\n", str);
+
+	return 0;
+}
+
+static int
+tcmu_pr_info_gen_encode(char *buf, size_t buf_remain, u32 gen)
+{
+	int rc;
+
+	rc = snprintf(buf, buf_remain, "0x%08x\n", gen);
+	if ((rc < 0) || (rc >= buf_remain)) {
+		pr_err("failed to encode PR gen\n");
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

