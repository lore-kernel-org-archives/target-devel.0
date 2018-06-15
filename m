From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:11 +0000
Subject: [PATCH 02/33] TCMU PR: add tcmu_dev_pr_info to store PR buffer
Message-Id: <20180615182342.6239-2-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a struct tcmu_dev_pr_info, which can help
store the string buffer we got from a TCMU device record (for
example, for RBD devices, the records should be stored in
their metadata). So that we can decode / encode them.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1dea66a851dd..1efc2800ca14 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -110,6 +110,14 @@ struct tcmu_nl_cmd {
 	int status;
 };
 
+/* This struct help to store the string buffer which contain
+ * Persistent Reservation info record from the device metadata.
+ */
+struct tcmu_dev_pr_info {
+	struct mutex pr_info_lock;
+	char *pr_info_buf;
+	};
+
 struct tcmu_dev {
 	struct list_head node;
 	struct kref kref;
@@ -165,6 +173,7 @@ struct tcmu_dev {
 	char dev_config[TCMU_CONFIG_LEN];
 
 	int nl_reply_supported;
+	struct tcmu_dev_pr_info pr_info;
 };
 
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
-- 
2.17.1

