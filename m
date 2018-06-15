From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:34 +0000
Subject: [PATCH 25/33] TCMU PR: netlink support for passthrough PR info
Message-Id: <20180615182342.6239-25-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added netlink support for passthrough Persistent
Reservation information.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a89c866a755d..09a341e935a9 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -348,6 +348,7 @@ static struct nla_policy tcmu_attr_policy[TCMU_ATTR_MAX+1] = {
 	[TCMU_ATTR_CMD_STATUS]	= { .type = NLA_S32 },
 	[TCMU_ATTR_DEVICE_ID]	= { .type = NLA_U32 },
 	[TCMU_ATTR_SUPP_KERN_CMD_REPLY] = { .type = NLA_U8 },
+	[TCMU_ATTR_PR_INFO] = { .type = NLA_STRING },
 };
 
 static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
@@ -389,6 +390,16 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 		nl_cmd->status = rc;
 	}
 
+	if (completed_cmd = TCMU_CMD_GET_PR_INFO) {
+		if (!info->attrs[TCMU_ATTR_PR_INFO]) {
+			ret = -EINVAL;
+		} else {
+			nla_strlcpy(udev->pr_info.pr_info_buf,
+				    info->attrs[TCMU_ATTR_PR_INFO],
+				    TCMU_PR_INFO_XATTR_MAX_SIZE);
+		}
+	}
+
 	spin_unlock(&udev->nl_cmd_lock);
 	if (!is_removed)
 		 target_undepend_item(&dev->dev_group.cg_item);
@@ -413,6 +424,18 @@ static int tcmu_genl_reconfig_dev_done(struct sk_buff *skb,
 	return tcmu_genl_cmd_done(info, TCMU_CMD_RECONFIG_DEVICE);
 }
 
+static int tcmu_genl_get_pr_info_done(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	return tcmu_genl_cmd_done(info, TCMU_CMD_GET_PR_INFO);
+}
+
+static int tcmu_genl_set_pr_info_done(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	return tcmu_genl_cmd_done(info, TCMU_CMD_SET_PR_INFO);
+}
+
 static int tcmu_genl_set_features(struct sk_buff *skb, struct genl_info *info)
 {
 	if (info->attrs[TCMU_ATTR_SUPP_KERN_CMD_REPLY]) {
@@ -450,6 +473,18 @@ static const struct genl_ops tcmu_genl_ops[] = {
 		.policy	= tcmu_attr_policy,
 		.doit	= tcmu_genl_reconfig_dev_done,
 	},
+	{
+		.cmd	= TCMU_CMD_GET_PR_INFO_DONE,
+		.flags	= GENL_ADMIN_PERM,
+		.policy	= tcmu_attr_policy,
+		.doit	= tcmu_genl_get_pr_info_done,
+	},
+	{
+		.cmd	= TCMU_CMD_SET_PR_INFO_DONE,
+		.flags	= GENL_ADMIN_PERM,
+		.policy	= tcmu_attr_policy,
+		.doit	= tcmu_genl_set_pr_info_done,
+	},
 };
 
 /* Our generic netlink family */
-- 
2.17.1

