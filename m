From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:32 +0000
Subject: [PATCH 23/33] TCMU PR: func to handle PR read keys but no regs
Message-Id: <20180615182342.6239-23-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When try to execute Persistent Reservation Read Keys,
but tcmu_pr_info_get() returns -ENODATA, this means there are no
registrations, so we should generate a fake empty struct
tcmu_pr_info, so that the code can keep running, but we don't
want to store it in the TCMU device, this is different from
tcmu_pr_info_init().

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c3adff826163..2fcdfc97ca75 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2829,6 +2829,23 @@ tcmu_execute_pr_register(struct se_cmd *cmd, u64 old_key,
 	return ret;
 }
 
+static int tcmu_pr_info_mock_empty(struct tcmu_pr_info **_pr_info)
+{
+	struct tcmu_pr_info *pr_info;
+
+	pr_info = kzalloc(sizeof(*pr_info), GFP_KERNEL);
+	if (!pr_info)
+		return -ENOMEM;
+
+	pr_info->vers = TCMU_PR_INFO_XATTR_VERS;
+	INIT_LIST_HEAD(&pr_info->regs);
+
+	*_pr_info = pr_info;
+	pr_debug("successfully initialized mock PR info\n");
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

