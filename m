From: Mike Christie <mchristi@redhat.com>
Date: Tue, 19 Dec 2017 10:03:57 +0000
Subject: [PATCH 4/5] target core: add device action configfs files
Message-Id: <1513677838-6675-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch adds a new group of files that are to be used to
have the kernel module execution some action. The next patch
will have target_core_user use the group/files to be able to block
a device and to reset its memory buffer used to pass commands
between user/kernel space.

This type of file is different from the existing device attributes
in that they may be write only and when written to they result in
the kernel module executing some function. These need to be
separate from the normal device attributes which get/set device
values so userspace can continue to loop over all the attribs and
get/set them during initialization.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_configfs.c | 6 ++++++
 drivers/target/target_core_internal.h | 1 +
 include/target/target_core_backend.h  | 1 +
 include/target/target_core_base.h     | 1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 72b1cd1..3f4bf12 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1197,6 +1197,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 EXPORT_SYMBOL(passthrough_attrib_attrs);
 
 TB_CIT_SETUP_DRV(dev_attrib, NULL, NULL);
+TB_CIT_SETUP_DRV(dev_action, NULL, NULL);
 
 /* End functions for struct config_item_type tb_dev_attrib_cit */
 
@@ -2940,6 +2941,10 @@ static struct config_group *target_core_make_subdev(
 
 	config_group_init_type_name(&dev->dev_group, name, &tb->tb_dev_cit);
 
+	config_group_init_type_name(&dev->dev_action_group, "action",
+			&tb->tb_dev_action_cit);
+	configfs_add_default_group(&dev->dev_action_group, &dev->dev_group);
+
 	config_group_init_type_name(&dev->dev_attrib.da_group, "attrib",
 			&tb->tb_dev_attrib_cit);
 	configfs_add_default_group(&dev->dev_attrib.da_group, &dev->dev_group);
@@ -3200,6 +3205,7 @@ static void target_core_call_delhbafromtarget(
 void target_setup_backend_cits(struct target_backend *tb)
 {
 	target_core_setup_dev_cit(tb);
+	target_core_setup_dev_action_cit(tb);
 	target_core_setup_dev_attrib_cit(tb);
 	target_core_setup_dev_pr_cit(tb);
 	target_core_setup_dev_wwn_cit(tb);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 9384d19..4529554 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -17,6 +17,7 @@ struct target_backend {
 
 	struct config_item_type tb_dev_cit;
 	struct config_item_type tb_dev_attrib_cit;
+	struct config_item_type tb_dev_action_cit;
 	struct config_item_type tb_dev_pr_cit;
 	struct config_item_type tb_dev_wwn_cit;
 	struct config_item_type tb_dev_alua_tg_pt_gps_cit;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index b6b3fb4..34a15d5 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -53,6 +53,7 @@ struct target_backend_ops {
 	void (*free_prot)(struct se_device *);
 
 	struct configfs_attribute **tb_dev_attrib_attrs;
+	struct configfs_attribute **tb_dev_action_attrs;
 };
 
 struct sbc_ops {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 00482f9..9f9f590 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -809,6 +809,7 @@ struct se_device {
 	/* T10 SPC-2 + SPC-3 Reservations */
 	struct t10_reservation	t10_pr;
 	struct se_dev_attrib	dev_attrib;
+	struct config_group	dev_action_group;
 	struct config_group	dev_group;
 	struct config_group	dev_pr_group;
 	struct se_dev_stat_grps dev_stat_grps;
-- 
1.8.3.1

