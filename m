From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:30 +0000
Subject: [PATCH 12/14] target: Remove second argument from fabric_make_tpg()
Message-Id: <20180301222632.31507-13-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since most target drivers do not use the second fabric_make_tpg()
argument ("group") and since it is trivial to derive the group pointer
from the wwn pointer, do not pass the group pointer to fabric_make_tpg().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
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
index 0373b7c40902..86bfa5dd9a26 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3340,11 +3340,9 @@ static struct configfs_attribute *srpt_tpg_attrs[] = {
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
index aadfeaac3898..20b8d8632c2c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1024,10 +1024,8 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
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
@@ -1146,10 +1144,8 @@ static struct configfs_attribute *tcm_qla2xxx_npiv_tpg_attrs[] = {
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
index 9cd4ffe76c07..6106c5f4cc41 100644
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
index fb1003921d85..0e44ef033d7c 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2005,10 +2005,8 @@ static void sbp_pre_unlink_lun(
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
index da81cf16b850..be2f4a4e4085 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1343,10 +1343,8 @@ static int usbg_init_nodeacl(struct se_node_acl *se_nacl, const char *name)
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
@@ -1379,7 +1377,7 @@ static struct se_portal_group *usbg_make_tpg(
 			goto unlock_dep;
 	} else {
 		ret = configfs_depend_item_unlocked(
-			group->cg_subsys,
+			wwn->wwn_group.cg_subsys,
 			&opts->func_inst.group.cg_item);
 		if (ret)
 			goto unlock_dep;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7ad57094d736..e27606289f63 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1909,9 +1909,7 @@ static struct configfs_attribute *vhost_scsi_tpg_attrs[] = {
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
index 7bc88fd43cfc..bd73901e0112 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1733,9 +1733,7 @@ static void scsiback_port_unlink(struct se_portal_group *se_tpg,
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
index b297aa0d9651..d975275985a4 100644
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
2.16.2

