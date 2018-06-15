From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:26 +0000
Subject: [PATCH 17/33] TCMU PR: add a function to append a new PR reg
Message-Id: <20180615182342.6239-17-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_pr_info_append_reg() which can
help to append a new Persistent Reservation registration to
struct tcmu_pr_info.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8d860b59d277..291b3ff4555d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2485,6 +2485,26 @@ static int tcmu_pr_info_init(struct tcmu_dev *udev,
 	return rc;
 }
 
+static int tcmu_pr_info_append_reg(struct tcmu_pr_info *pr_info,
+				   char *nexus, u64 key)
+{
+	struct tcmu_pr_reg *reg;
+
+	reg = kmalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg)
+		return -ENOMEM;
+
+	reg->key = key;
+	strlcpy(reg->it_nexus, nexus, ARRAY_SIZE(reg->it_nexus));
+
+	list_add_tail(&reg->regs_node, &pr_info->regs);
+	pr_info->num_regs++;
+
+	pr_debug("appended pr_info reg: 0x%llx\n", reg->key);
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

