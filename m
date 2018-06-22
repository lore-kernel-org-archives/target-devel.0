From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:02 +0000
Subject: [PATCH 15/20] target: Remove second argument from fabric_make_tpg()
Message-Id: <20180622215307.8758-16-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since most target drivers do not use the second fabric_make_tpg()
argument ("group") and since it is trivial to derive the group pointer
from the wwn pointer, do not pass the group pointer to fabric_make_tpg().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  2 --
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 12 ++++--------
 drivers/target/iscsi/iscsi_target_configfs.c |  6 ++----
 drivers/target/loopback/tcm_loop.c           |  6 ++----
 drivers/target/sbp/sbp_target.c              |  6 ++----
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/tcm_fc/tfc_conf.c             |  5 +----
 drivers/usb/gadget/function/f_tcm.c          |  8 +++-----
 drivers/vhost/scsi.c                         |  4 +---
 drivers/xen/xen-scsiback.c                   |  4 +---
 include/target/target_core_fabric.h          |  2 +-
 12 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3081c629a7f7..07b3e1c583bd 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3597,11 +3597,9 @@ static struct configfs_attribute *srpt_tpg_attrs[] = {
 /**
  * srpt_make_tpg - configfs callback invoked for mkdir /sys/kernel/config/target/$driver/$port/$tpg
  * @wwn: Corresponds to $driver/$port.
- * @group: Not used.
  * @name: $tpg.
  */
 static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
-					     struct config_group *group,
 					     const char *name)
 {
 	struct srpt_port *sport = wwn->priv;
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index c3a76af9f5fa..fdda04e5cf94 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3928,7 +3928,6 @@ static void ibmvscsis_drop_tport(struct se_wwn *wwn)
 }
 
 static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
-						  struct config_group *group,
 						  const char *name)
 {
 	struct ibmvscsis_tport *tport diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7732e9336d43..cfb5d6067f9f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1049,10 +1049,8 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
 	NULL,
 };
 
-static struct se_portal_group *tcm_qla2xxx_make_tpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *tcm_qla2xxx_make_tpg(struct se_wwn *wwn,
+						    const char *name)
 {
 	struct tcm_qla2xxx_lport *lport = container_of(wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
@@ -1171,10 +1169,8 @@ static struct configfs_attribute *tcm_qla2xxx_npiv_tpg_attrs[] = {
         NULL,
 };
 
-static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(struct se_wwn *wwn,
+							 const char *name)
 {
 	struct tcm_qla2xxx_lport *lport = container_of(wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0bc346b2c27c..1fcd9bc7189d 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1090,10 +1090,8 @@ static struct configfs_attribute *lio_target_tpg_attrs[] = {
 
 /* Start items for lio_target_tiqn_cit */
 
-static struct se_portal_group *lio_target_tiqn_addtpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
+						      const char *name)
 {
 	struct iscsi_portal_group *tpg;
 	struct iscsi_tiqn *tiqn;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 60d5b918c4ac..4c8a97711291 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -983,10 +983,8 @@ static struct configfs_attribute *tcm_loop_tpg_attrs[] = {
 
 /* Start items for tcm_loop_naa_cit */
 
-static struct se_portal_group *tcm_loop_make_naa_tpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *tcm_loop_make_naa_tpg(struct se_wwn *wwn,
+						     const char *name)
 {
 	struct tcm_loop_hba *tl_hba = container_of(wwn,
 			struct tcm_loop_hba, tl_hba_wwn);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 42b21f2ac8b0..b61b79ac98ff 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2006,10 +2006,8 @@ static void sbp_pre_unlink_lun(
 		pr_err("unlink LUN: failed to update unit directory\n");
 }
 
-static struct se_portal_group *sbp_make_tpg(
-		struct se_wwn *wwn,
-		struct config_group *group,
-		const char *name)
+static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
+					    const char *name)
 {
 	struct sbp_tport *tport  		container_of(wwn, struct sbp_tport, tport_wwn);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index e1416b007aa4..1fa436e865f9 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -841,7 +841,7 @@ static struct config_group *target_fabric_make_tpg(
 		return ERR_PTR(-ENOSYS);
 	}
 
-	se_tpg = tf->tf_ops->fabric_make_tpg(wwn, group, name);
+	se_tpg = tf->tf_ops->fabric_make_tpg(wwn, name);
 	if (!se_tpg || IS_ERR(se_tpg))
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 42ee91123dca..e55c4d537592 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -223,10 +223,7 @@ static int ft_init_nodeacl(struct se_node_acl *nacl, const char *name)
 /*
  * local_port port_group (tpg) ops.
  */
-static struct se_portal_group *ft_add_tpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *ft_add_tpg(struct se_wwn *wwn, const char *name)
 {
 	struct ft_lport_wwn *ft_wwn;
 	struct ft_tpg *tpg;
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 5003e857dce7..4f183176b0b4 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1344,10 +1344,8 @@ static int usbg_init_nodeacl(struct se_node_acl *se_nacl, const char *name)
 	return 0;
 }
 
-static struct se_portal_group *usbg_make_tpg(
-	struct se_wwn *wwn,
-	struct config_group *group,
-	const char *name)
+static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
+					     const char *name)
 {
 	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
 			tport_wwn);
@@ -1380,7 +1378,7 @@ static struct se_portal_group *usbg_make_tpg(
 			goto unlock_dep;
 	} else {
 		ret = configfs_depend_item_unlocked(
-			group->cg_subsys,
+			wwn->wwn_group.cg_subsys,
 			&opts->func_inst.group.cg_item);
 		if (ret)
 			goto unlock_dep;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ebaf831285ea..c84a6edd4c25 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1912,9 +1912,7 @@ static struct configfs_attribute *vhost_scsi_tpg_attrs[] = {
 };
 
 static struct se_portal_group *
-vhost_scsi_make_tpg(struct se_wwn *wwn,
-		   struct config_group *group,
-		   const char *name)
+vhost_scsi_make_tpg(struct se_wwn *wwn, const char *name)
 {
 	struct vhost_scsi_tport *tport = container_of(wwn,
 			struct vhost_scsi_tport, tport_wwn);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 764dd9aa0131..fd77ccfc7d6e 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1732,9 +1732,7 @@ static void scsiback_port_unlink(struct se_portal_group *se_tpg,
 }
 
 static struct se_portal_group *
-scsiback_make_tpg(struct se_wwn *wwn,
-		   struct config_group *group,
-		   const char *name)
+scsiback_make_tpg(struct se_wwn *wwn, const char *name)
 {
 	struct scsiback_tport *tport = container_of(wwn,
 			struct scsiback_tport, tport_wwn);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 84a681b6e5ca..f61aa716cfe1 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -79,7 +79,7 @@ struct target_core_fabric_ops {
 	void (*fabric_drop_wwn)(struct se_wwn *);
 	void (*add_wwn_groups)(struct se_wwn *);
 	struct se_portal_group *(*fabric_make_tpg)(struct se_wwn *,
-				struct config_group *, const char *);
+						   const char *);
 	void (*fabric_drop_tpg)(struct se_portal_group *);
 	int (*fabric_post_link)(struct se_portal_group *,
 				struct se_lun *);
-- 
2.17.1

