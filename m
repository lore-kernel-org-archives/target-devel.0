From: David Disseldorp <ddiss@suse.de>
Date: Fri, 23 Nov 2018 17:36:13 +0000
Subject: [PATCH 3/3] target: replace fabric_ops.name with fabric_alias
Message-Id: <20181123173613.4547-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

iscsi_target_mod is the only LIO fabric where fabric_ops.name differs
from the fabric_ops.fabric_name string.
fabric_ops.name is used when matching target/$fabric ConfigFS create
paths, so rename it .fabric_alias and fallback to target/$fabric vs
.fabric_name comparison if .fabric_alias isn't initialised.
iscsi_target_mod is the only fabric module to set .fabric_alias . All
other fabric modules rely on .fabric_name matching and can drop the
duplicate string.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  1 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  2 --
 drivers/target/iscsi/iscsi_target_configfs.c |  2 +-
 drivers/target/loopback/tcm_loop.c           |  1 -
 drivers/target/sbp/sbp_target.c              |  1 -
 drivers/target/target_core_configfs.c        | 30 +++++++++++++++++-----------
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/usb/gadget/function/f_tcm.c          |  1 -
 drivers/vhost/scsi.c                         |  1 -
 drivers/xen/xen-scsiback.c                   |  1 -
 include/target/target_core_fabric.h          | 12 ++++++++---
 12 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 657d728da40c..41ee1f263bd6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3673,7 +3673,6 @@ static struct configfs_attribute *srpt_wwn_attrs[] = {
 
 static const struct target_core_fabric_ops srpt_template = {
 	.module				= THIS_MODULE,
-	.name				= "srpt",
 	.fabric_name			= "srpt",
 	.tpg_get_wwn			= srpt_get_fabric_wwn,
 	.tpg_get_tag			= srpt_get_tag,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 6e1c3e65f37b..cc9cae469c4b 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -4039,7 +4039,6 @@ static struct configfs_attribute *ibmvscsis_tpg_attrs[] = {
 
 static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.module				= THIS_MODULE,
-	.name				= "ibmvscsis",
 	.fabric_name			= "ibmvscsis",
 	.max_data_sg_nents		= MAX_TXU / PAGE_SIZE,
 	.tpg_get_wwn			= ibmvscsis_get_fabric_wwn,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index ff8735effe28..fc312a5eab75 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1910,7 +1910,6 @@ static struct configfs_attribute *tcm_qla2xxx_wwn_attrs[] = {
 
 static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.module				= THIS_MODULE,
-	.name				= "qla2xxx",
 	.fabric_name			= "qla2xxx",
 	.node_acl_size			= sizeof(struct tcm_qla2xxx_nacl),
 	/*
@@ -1959,7 +1958,6 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 
 static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.module				= THIS_MODULE,
-	.name				= "qla2xxx_npiv",
 	.fabric_name			= "qla2xxx_npiv",
 	.node_acl_size			= sizeof(struct tcm_qla2xxx_nacl),
 	.tpg_get_wwn			= tcm_qla2xxx_get_fabric_wwn,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5c9e98ee42de..39a700a41f6e 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1544,7 +1544,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 
 const struct target_core_fabric_ops iscsi_ops = {
 	.module				= THIS_MODULE,
-	.name				= "iscsi",
+	.fabric_alias			= "iscsi",
 	.fabric_name			= "iSCSI",
 	.node_acl_size			= sizeof(struct iscsi_node_acl),
 	.tpg_get_wwn			= lio_tpg_get_endpoint_wwn,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 962845224c19..b0991e86587f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1144,7 +1144,6 @@ static struct configfs_attribute *tcm_loop_wwn_attrs[] = {
 
 static const struct target_core_fabric_ops loop_ops = {
 	.module				= THIS_MODULE,
-	.name				= "loopback",
 	.fabric_name			= "loopback",
 	.tpg_get_wwn			= tcm_loop_get_endpoint_wwn,
 	.tpg_get_tag			= tcm_loop_get_tag,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index f5830bb4ef5a..08cee13dfb9a 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2318,7 +2318,6 @@ static struct configfs_attribute *sbp_tpg_attrib_attrs[] = {
 
 static const struct target_core_fabric_ops sbp_ops = {
 	.module				= THIS_MODULE,
-	.name				= "sbp",
 	.fabric_name			= "sbp",
 	.tpg_get_wwn			= sbp_get_fabric_wwn,
 	.tpg_get_tag			= sbp_get_tag,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ae6c44c48f75..0e8449be5115 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -172,7 +172,10 @@ static struct target_fabric_configfs *target_core_get_fabric(
 
 	mutex_lock(&g_tf_lock);
 	list_for_each_entry(tf, &g_tf_list, tf_list) {
-		if (!strcmp(tf->tf_ops->name, name)) {
+		const char *cmp_name = tf->tf_ops->fabric_alias;
+		if (!cmp_name)
+			cmp_name = tf->tf_ops->fabric_name;
+		if (!strcmp(cmp_name, name)) {
 			atomic_inc(&tf->tf_access_cnt);
 			mutex_unlock(&g_tf_lock);
 			return tf;
@@ -249,7 +252,7 @@ static struct config_group *target_core_register_fabric(
 		return ERR_PTR(-EINVAL);
 	}
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
-			" %s\n", tf->tf_ops->name);
+			" %s\n", tf->tf_ops->fabric_name);
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
@@ -282,7 +285,7 @@ static void target_core_deregister_fabric(
 		" tf list\n", config_item_name(item));
 
 	pr_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric:"
-			" %s\n", tf->tf_ops->name);
+			" %s\n", tf->tf_ops->fabric_name);
 	atomic_dec(&tf->tf_access_cnt);
 
 	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
@@ -342,19 +345,22 @@ EXPORT_SYMBOL(target_undepend_item);
 
 static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 {
-	if (!tfo->name) {
-		pr_err("Missing tfo->name\n");
-		return -EINVAL;
-	}
-	if (strlen(tfo->name) >= TARGET_FABRIC_NAME_SIZE) {
-		pr_err("Passed name: %s exceeds TARGET_FABRIC"
-			"_NAME_SIZE\n", tfo->name);
-		return -EINVAL;
+	if (tfo->fabric_alias) {
+		if (strlen(tfo->fabric_alias) >= TARGET_FABRIC_NAME_SIZE) {
+			pr_err("Passed alias: %s exceeds "
+				"TARGET_FABRIC_NAME_SIZE\n", tfo->fabric_alias);
+			return -EINVAL;
+		}
 	}
 	if (!tfo->fabric_name) {
 		pr_err("Missing tfo->fabric_name\n");
 		return -EINVAL;
 	}
+	if (strlen(tfo->fabric_name) >= TARGET_FABRIC_NAME_SIZE) {
+		pr_err("Passed name: %s exceeds "
+			"TARGET_FABRIC_NAME_SIZE\n", tfo->fabric_name);
+		return -EINVAL;
+	}
 	if (!tfo->tpg_get_wwn) {
 		pr_err("Missing tfo->tpg_get_wwn()\n");
 		return -EINVAL;
@@ -486,7 +492,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
 
 	mutex_lock(&g_tf_lock);
 	list_for_each_entry(t, &g_tf_list, tf_list) {
-		if (!strcmp(t->tf_ops->name, fo->name)) {
+		if (!strcmp(t->tf_ops->fabric_name, fo->fabric_name)) {
 			BUG_ON(atomic_read(&t->tf_access_cnt));
 			list_del(&t->tf_list);
 			mutex_unlock(&g_tf_lock);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 8b884246a9be..1ce49518d440 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -422,7 +422,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 
 static const struct target_core_fabric_ops ft_fabric_ops = {
 	.module =			THIS_MODULE,
-	.name =				"fc",
 	.fabric_name =			"fc",
 	.node_acl_size =		sizeof(struct ft_node_acl),
 	.tpg_get_wwn =			ft_get_fabric_wwn,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 1a03f4975dab..34f5982cab78 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1713,7 +1713,6 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 
 static const struct target_core_fabric_ops usbg_ops = {
 	.module				= THIS_MODULE,
-	.name				= "usb_gadget",
 	.fabric_name			= "usb_gadget",
 	.tpg_get_wwn			= usbg_get_fabric_wwn,
 	.tpg_get_tag			= usbg_get_tag,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 37e003649ba1..a08472ae5b1b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2284,7 +2284,6 @@ static struct configfs_attribute *vhost_scsi_wwn_attrs[] = {
 
 static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.module				= THIS_MODULE,
-	.name				= "vhost",
 	.fabric_name			= "vhost",
 	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
 	.tpg_get_tag			= vhost_scsi_get_tpgt,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ffde280c3ecd..c9e23a126218 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1805,7 +1805,6 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 
 static const struct target_core_fabric_ops scsiback_ops = {
 	.module				= THIS_MODULE,
-	.name				= "xen-pvscsi",
 	.fabric_name			= "xen-pvscsi",
 	.tpg_get_wwn			= scsiback_get_fabric_wwn,
 	.tpg_get_tag			= scsiback_get_tag,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index a0b41110d266..0a1595f3c5a1 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -8,10 +8,16 @@
 
 struct target_core_fabric_ops {
 	struct module *module;
-	const char *name;
 	/*
-	 * fabric_name is used for the ALUA state path and is stored on disk
-	 * with PR state.
+	 * XXX: Special case for iscsi/iSCSI...
+	 * If non-null, fabric_alias is used for matching target/$fabric
+	 * ConfigFS paths. If null, fabric_name is used for this (see below).
+	 */
+	const char *fabric_alias;
+	/*
+	 * fabric_name is used for matching target/$fabric ConfigFS paths
+	 * without a fabric_alias (see above). It's also used for the ALUA state
+	 * path and is stored on disk with PR state.
 	 */
 	const char *fabric_name;
 	size_t node_acl_size;
-- 
2.13.7
