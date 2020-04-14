From: Mike Christie <mchristi@redhat.com>
Date: Tue, 14 Apr 2020 05:15:12 +0000
Subject: [RFC PATCH 3/5] target: add target_setup_session sysfs support
Message-Id: <20200414051514.7296-4-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

This adds a session dir per session for users of target_setup_session.

TODO: drivers like tcm_qla2xxx allocate resources in the
target_setup_session setup callback. I added a second callback
to release those resources in the error path or when all users
have drop their references.

I have not implemented the free_cb for tcm_qlaxxx, vhost, etc.

Drivers like elx that will want to export session level attrs
can also use the new callback to release their session resources
when all references have been dropped.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |  8 +++--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  4 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  3 +-
 drivers/target/Makefile                  |  1 +
 drivers/target/loopback/tcm_loop.c       |  3 +-
 drivers/target/sbp/sbp_target.c          |  4 +--
 drivers/target/target_core_transport.c   | 57 ++++++++++++++++++++++++++------
 drivers/target/tcm_fc/tfc_sess.c         |  2 +-
 drivers/usb/gadget/function/f_tcm.c      |  3 +-
 drivers/vhost/scsi.c                     |  4 +--
 drivers/xen/xen-scsiback.c               |  4 ++-
 include/target/target_core_base.h        |  1 +
 include/target/target_core_fabric.h      |  7 ++--
 13 files changed, 73 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9855274..a4f4a55 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2320,7 +2320,8 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						ch->sess_name, ch, NULL);
+						ch->sess_name, NULL, ch, NULL,
+						NULL);
 	}
 	mutex_unlock(&sport->port_guid_id.mutex);
 
@@ -2330,13 +2331,14 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 					tag_size, TARGET_PROT_NORMAL, i_port_id,
-					ch, NULL);
+					NULL, ch, NULL, NULL);
 		if (!IS_ERR_OR_NULL(ch->sess))
 			break;
 		/* Retry without leading "0x" */
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						i_port_id + 2, ch, NULL);
+						i_port_id + 2, NULL, ch, NULL,
+						NULL);
 	}
 	mutex_unlock(&sport->port_gid_id.mutex);
 
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d9e94e8..bf5dd4c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2223,8 +2223,8 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_tport *tport)
 	}
 
 	nexus->se_sess = target_setup_session(&tport->se_tpg, 0, 0,
-					      TARGET_PROT_NORMAL, name, nexus,
-					      NULL);
+					      TARGET_PROT_NORMAL, name, NULL,
+					      nexus, NULL, NULL);
 	if (IS_ERR(nexus->se_sess)) {
 		rc = PTR_ERR(nexus->se_sess);
 		goto transport_init_fail;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 1f0a185..27f968f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1484,7 +1484,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	se_sess = target_setup_session(&tpg->se_tpg, num_tags,
 				       sizeof(struct qla_tgt_cmd),
 				       TARGET_PROT_ALL, port_name,
-				       qlat_sess, tcm_qla2xxx_session_cb);
+				       NULL, qlat_sess, tcm_qla2xxx_session_cb,
+				       NULL);
 	if (IS_ERR(se_sess))
 		return PTR_ERR(se_sess);
 
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4a7246e..1b7949d 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -5,6 +5,7 @@ target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
 				   target_core_fabric_configfs.o \
 				   target_core_fabric_lib.o \
+				   target_core_sysfs.o \
 				   target_core_hba.o \
 				   target_core_pr.o \
 				   target_core_alua.o \
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3305b47..6e2ebe9 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -742,7 +742,8 @@ static int tcm_loop_make_nexus(
 
 	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					name, tl_nexus, tcm_loop_alloc_sess_cb);
+					name, NULL, tl_nexus, tcm_loop_alloc_sess_cb,
+					NULL);
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
 		kfree(tl_nexus);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9f..43aaf35 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -198,8 +198,8 @@ static struct sbp_session *sbp_session_create(
 
 	sess->se_sess = target_setup_session(&tpg->se_tpg, 128,
 					     sizeof(struct sbp_target_request),
-					     TARGET_PROT_NORMAL, guid_str,
-					     sess, NULL);
+					     TARGET_PROT_NORMAL, guid_str, NULL,
+					     sess, NULL, NULL);
 	if (IS_ERR(sess->se_sess)) {
 		pr_err("failed to init se_session\n");
 		ret = PTR_ERR(sess->se_sess);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fba059c..2462eca 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -414,15 +414,35 @@ void transport_register_session(
 }
 EXPORT_SYMBOL(transport_register_session);
 
+/**
+ * target_setup_session - alloc and add a session to lio core
+ * @tpg: parent tpg
+ * @tag_num: if non-zero max num in-flight commands.
+ * @tag_size: if tag_num is non-zero, fabric driver's per cmd data in bytes.
+ * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ * @fabric_attrs: opt fabric driver session level attrs.
+ * @private: if setup_cb is non-NULL private will be passed to setup_cb.
+ * @setup_cb: opt function called before session has been added to lio core.
+ * @free_cb: function called during removal when all user refs have dropped.
+ *
+ * If the caller passes in a setup_cb that allocates resource a free_cb is
+ * required to free those resource during session removal.
+ *
+ * If the caller passes in fabric_attrs a free_cb is required, so resources
+ * it may access are freed when all users have dropped their references.
+ */
 struct se_session *
 target_setup_session(struct se_portal_group *tpg,
 		     unsigned int tag_num, unsigned int tag_size,
 		     enum target_prot_op prot_op,
-		     const char *initiatorname, void *private,
-		     int (*callback)(struct se_portal_group *,
-				     struct se_session *, void *))
+		     const char *initiatorname,
+		     struct attribute_group *fabric_attrs, void *private,
+		     int (*setup_cb)(struct se_portal_group *,
+				     struct se_session *, void *),
+		     void (*free_cb)(struct se_session *))
 {
 	struct se_session *sess;
+	int rc;
 
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
@@ -439,23 +459,35 @@ struct se_session *
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_session;
 	}
+
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
-	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+	if (setup_cb) {
+		rc = setup_cb(tpg, sess, private);
+		if (rc)
+			goto free_session;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
+
+	rc = target_sysfs_add_session(tpg, sess, fabric_attrs);
+	if (rc)
+		goto fabric_free_session;
+	sess->fabric_free_cb = free_cb;
+
 	return sess;
+
+fabric_free_session:
+	if (free_cb)
+		free_cb(sess);
+free_session:
+	transport_free_session(sess);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -549,6 +581,8 @@ void __target_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
 
+	if (se_sess->fabric_free_cb)
+		se_sess->fabric_free_cb(se_sess);
 	/*
 	 * Drop the se_node_acl->nacl_kref obtained from within
 	 * core_tpg_get_initiator_node_acl().
@@ -639,6 +673,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4fd6a1d..4973052 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -230,7 +230,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	sess->se_sess = target_setup_session(se_tpg, TCM_FC_DEFAULT_TAGS,
 					     sizeof(struct ft_cmd),
 					     TARGET_PROT_NORMAL, &initiatorname[0],
-					     sess, ft_sess_alloc_cb);
+					     NULL, sess, ft_sess_alloc_cb, NULL);
 	if (IS_ERR(sess->se_sess)) {
 		int rc = PTR_ERR(sess->se_sess);
 		kfree(sess);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 3650493..9363130 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1583,7 +1583,8 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 						     USB_G_DEFAULT_SESSION_TAGS,
 						     sizeof(struct usbg_cmd),
 						     TARGET_PROT_NORMAL, name,
-						     tv_nexus, usbg_alloc_sess_cb);
+						     NULL, tv_nexus,
+						     usbg_alloc_sess_cb, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 #define MAKE_NEXUS_MSG "core_tpg_check_initiator_node_acl() failed for %s\n"
 		pr_debug(MAKE_NEXUS_MSG, name);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7653667..d3db74c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1964,8 +1964,8 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name, tv_nexus,
-					vhost_scsi_nexus_cb);
+					(unsigned char *)name, NULL, tv_nexus,
+					vhost_scsi_nexus_cb, NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 75c0a2e..057d8a1 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1531,7 +1531,9 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
 						     TARGET_PROT_NORMAL, name,
-						     tv_nexus, scsiback_alloc_sess_cb);
+						     NULL, tv_nexus,
+						     scsiback_alloc_sess_cb,
+						     NULL);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
 		ret = -ENOMEM;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3bc2498..783cca2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -628,6 +628,7 @@ struct se_session {
 	struct kobject		kobj;
 	int			sid;
 	struct attribute_group	*fabric_attrs;
+	void (*fabric_free_cb)(struct se_session *);
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 5948b87..9815dbf 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -127,9 +127,10 @@ struct target_core_fabric_ops {
 
 struct se_session *target_setup_session(struct se_portal_group *,
 		unsigned int, unsigned int, enum target_prot_op prot_op,
-		const char *, void *,
-		int (*callback)(struct se_portal_group *,
-				struct se_session *, void *));
+		const char *, struct attribute_group *, void *,
+		int (*setup_cb)(struct se_portal_group *,
+				struct se_session *, void *),
+		void (*free_cb)(struct se_session *));
 void target_remove_session(struct se_session *);
 
 int transport_init_session(struct se_session *se_sess);
-- 
1.8.3.1
