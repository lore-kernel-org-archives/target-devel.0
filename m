From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Apr 2020 19:14:23 +0000
Subject: [RFC PATCH 09/12] target: move session setup cb to fabric ops
Message-Id: <20200420191426.17055-10-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

This moves the target_setup_session callback to the fabric ops. It also
adds a new session callback called when the session is freed. This will
be useful in the next patch for fabric mods that add session_attrs
and so we can cleanup from failures in target_setup_session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |  6 +++---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  8 +++++---
 drivers/target/loopback/tcm_loop.c       |  8 ++++----
 drivers/target/sbp/sbp_target.c          |  2 +-
 drivers/target/target_core_transport.c   | 11 ++++++-----
 drivers/target/tcm_fc/tcm_fc.h           |  2 ++
 drivers/target/tcm_fc/tfc_conf.c         |  1 +
 drivers/target/tcm_fc/tfc_sess.c         |  7 +++----
 drivers/usb/gadget/function/f_tcm.c      |  8 ++++----
 drivers/vhost/scsi.c                     |  8 ++++----
 drivers/xen/xen-scsiback.c               |  8 ++++----
 include/target/target_core_fabric.h      |  7 ++++---
 13 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4dd2a41..59a6b9b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2325,7 +2325,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						&tpid, ch->sess_name, ch, NULL);
+						&tpid, ch->sess_name, ch);
 	}
 	mutex_unlock(&sport->port_guid_id.mutex);
 
@@ -2335,13 +2335,13 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 					tag_size, TARGET_PROT_NORMAL, &tpid,
-					i_port_id, ch, NULL);
+					i_port_id, ch);
 		if (!IS_ERR_OR_NULL(ch->sess))
 			break;
 		/* Retry without leading "0x" */
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						&tpid, i_port_id + 2, ch, NULL);
+						&tpid, i_port_id + 2, ch);
 	}
 	mutex_unlock(&sport->port_gid_id.mutex);
 
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index dba9ec0..23ffcd8 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2229,7 +2229,7 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_tport *tport)
 
 	nexus->se_sess = target_setup_session(&tport->se_tpg, 0, 0,
 					      TARGET_PROT_NORMAL, &tpid, name,
-					      nexus, NULL);
+					      nexus);
 	if (IS_ERR(nexus->se_sess)) {
 		rc = PTR_ERR(nexus->se_sess);
 		goto transport_init_fail;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index dc1bddd..d864d13 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1389,8 +1389,8 @@ static void tcm_qla2xxx_free_session(struct fc_port *sess)
 	target_remove_session(se_sess);
 }
 
-static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
-				  struct se_session *se_sess, void *p)
+static int tcm_qla2xxx_init_session(struct se_portal_group *se_tpg,
+				    struct se_session *se_sess, void *p)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -1467,7 +1467,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	se_sess = target_setup_session(&tpg->se_tpg, num_tags,
 				       sizeof(struct qla_tgt_cmd),
 				       TARGET_PROT_ALL, &tpid, port_name,
-				       qlat_sess, tcm_qla2xxx_session_cb);
+				       qlat_sess);
 	if (IS_ERR(se_sess))
 		return PTR_ERR(se_sess);
 
@@ -1832,6 +1832,7 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
+	.init_session			= tcm_qla2xxx_init_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
@@ -1871,6 +1872,7 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
+	.init_session			= tcm_qla2xxx_init_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 7593a53..7025b7e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -713,8 +713,8 @@ static ssize_t tcm_loop_tpg_attrib_fabric_prot_type_store(
 
 /* Start items for tcm_loop_nexus_cit */
 
-static int tcm_loop_alloc_sess_cb(struct se_portal_group *se_tpg,
-				  struct se_session *se_sess, void *p)
+static int tcm_loop_init_sess(struct se_portal_group *se_tpg,
+			      struct se_session *se_sess, void *p)
 {
 	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
 					struct tcm_loop_tpg, tl_se_tpg);
@@ -761,8 +761,7 @@ static int tcm_loop_make_nexus(
 
 	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					&tpid, name, tl_nexus,
-					tcm_loop_alloc_sess_cb);
+					&tpid, name, tl_nexus);
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
 		kfree(tl_nexus);
@@ -1165,6 +1164,7 @@ static ssize_t tcm_loop_wwn_version_show(struct config_item *item, char *page)
 	.queue_status			= tcm_loop_queue_status,
 	.queue_tm_rsp			= tcm_loop_queue_tm_rsp,
 	.aborted_task			= tcm_loop_aborted_task,
+	.init_session			= tcm_loop_init_sess,
 	.fabric_make_wwn		= tcm_loop_make_scsi_hba,
 	.fabric_drop_wwn		= tcm_loop_drop_scsi_hba,
 	.fabric_make_tpg		= tcm_loop_make_naa_tpg,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 9a3121d..20f8b3b 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -204,7 +204,7 @@ static struct sbp_session *sbp_session_create(
 	sess->se_sess = target_setup_session(&tpg->se_tpg, 128,
 					     sizeof(struct sbp_target_request),
 					     TARGET_PROT_NORMAL, &tpid,
-					     guid_str, sess, NULL);
+					     guid_str, sess);
 	if (IS_ERR(sess->se_sess)) {
 		pr_err("failed to init se_session\n");
 		ret = PTR_ERR(sess->se_sess);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d3248d4..7aa830e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -434,9 +434,7 @@ struct se_session *
 target_setup_session(struct se_portal_group *tpg,
 		     unsigned int tag_num, unsigned int tag_size,
 		     enum target_prot_op prot_op, struct t10_transport_id *tpid,
-		     const char *initiatorname, void *private,
-		     int (*callback)(struct se_portal_group *,
-				     struct se_session *, void *))
+		     const char *initiatorname, void *private)
 {
 	struct se_session *sess;
 	int rc;
@@ -469,8 +467,8 @@ struct se_session *
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
-	if (callback != NULL) {
-		rc = callback(tpg, sess, private);
+	if (tpg->se_tpg_tfo->init_session) {
+		rc = tpg->se_tpg_tfo->init_session(tpg, sess, private);
 		if (rc)
 			goto free_sess;
 	}
@@ -612,6 +610,9 @@ void transport_free_session(struct se_session *se_sess)
 
 void __target_free_session(struct se_session *se_sess)
 {
+	if (se_sess->tfo && se_sess->tfo->free_session)
+		se_sess->tfo->free_session(se_sess);
+
 	kfree(se_sess->acl_name);
 	target_free_transport_id(se_sess->tpid);
 
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 2ff716d..ce07b3e 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -129,6 +129,8 @@ struct ft_cmd {
 /*
  * Session ops.
  */
+
+int ft_sess_init(struct se_portal_group *, struct se_session *, void *);
 void ft_sess_put(struct ft_sess *);
 void ft_sess_close(struct se_session *);
 u32 ft_sess_get_index(struct se_session *);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 870b7bb..7983554 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -426,6 +426,7 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	.check_stop_free =		ft_check_stop_free,
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
+	.init_session =			ft_sess_init,
 	.sess_get_index =		ft_sess_get_index,
 	.write_pending =		ft_write_pending,
 	.set_default_node_attributes =	ft_set_default_node_attr,
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index f261756..7357c38 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -186,8 +186,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	return NULL;
 }
 
-static int ft_sess_alloc_cb(struct se_portal_group *se_tpg,
-			    struct se_session *se_sess, void *p)
+int ft_sess_init(struct se_portal_group *se_tpg, struct se_session *se_sess,
+		 void *p)
 {
 	struct ft_sess *sess = p;
 	struct ft_tport *tport = sess->tport;
@@ -235,8 +235,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	sess->se_sess = target_setup_session(se_tpg, TCM_FC_DEFAULT_TAGS,
 					     sizeof(struct ft_cmd),
 					     TARGET_PROT_NORMAL, &tpid,
-					     &initiatorname[0], sess,
-					     ft_sess_alloc_cb);
+					     &initiatorname[0], sess);
 	if (IS_ERR(sess->se_sess)) {
 		int rc = PTR_ERR(sess->se_sess);
 		kfree(sess);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 88319b9..eab61c6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1551,8 +1551,8 @@ static ssize_t tcm_usbg_tpg_nexus_show(struct config_item *item, char *page)
 	return ret;
 }
 
-static int usbg_alloc_sess_cb(struct se_portal_group *se_tpg,
-			      struct se_session *se_sess, void *p)
+static int usbg_init_sess(struct se_portal_group *se_tpg,
+			  struct se_session *se_sess, void *p)
 {
 	struct usbg_tpg *tpg = container_of(se_tpg,
 				struct usbg_tpg, se_tpg);
@@ -1589,8 +1589,7 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 						     USB_G_DEFAULT_SESSION_TAGS,
 						     sizeof(struct usbg_cmd),
 						     TARGET_PROT_NORMAL, &tpid,
-						     name, tv_nexus,
-						     usbg_alloc_sess_cb);
+						     name, tv_nexus);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 #define MAKE_NEXUS_MSG "core_tpg_check_initiator_node_acl() failed for %s\n"
 		pr_debug(MAKE_NEXUS_MSG, name);
@@ -1730,6 +1729,7 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.queue_tm_rsp			= usbg_queue_tm_rsp,
 	.aborted_task			= usbg_aborted_task,
 	.check_stop_free		= usbg_check_stop_free,
+	.init_session			= usbg_init_sess,
 
 	.fabric_make_wwn		= usbg_make_tport,
 	.fabric_drop_wwn		= usbg_drop_tport,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7ad7a92..51392ab 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1898,8 +1898,8 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
 	NULL,
 };
 
-static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
-			       struct se_session *se_sess, void *p)
+static int vhost_scsi_init_nexus(struct se_portal_group *se_tpg,
+				 struct se_session *se_sess, void *p)
 {
 	struct vhost_scsi_cmd *tv_cmd;
 	unsigned int i;
@@ -1983,8 +1983,7 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg, char *name)
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					&tpid, (unsigned char *)name, tv_nexus,
-					vhost_scsi_nexus_cb);
+					&tpid, (unsigned char *)name, tv_nexus);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
@@ -2317,6 +2316,7 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.queue_status			= vhost_scsi_queue_status,
 	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
 	.aborted_task			= vhost_scsi_aborted_task,
+	.init_session			= vhost_scsi_init_nexus,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 6f9b4f7..1d8c0c2 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1497,8 +1497,8 @@ static ssize_t scsiback_tpg_param_alias_store(struct config_item *item,
 	NULL,
 };
 
-static int scsiback_alloc_sess_cb(struct se_portal_group *se_tpg,
-				  struct se_session *se_sess, void *p)
+static int scsiback_init_sess(struct se_portal_group *se_tpg,
+			      struct se_session *se_sess, void *p)
 {
 	struct scsiback_tpg *tpg = container_of(se_tpg,
 				struct scsiback_tpg, se_tpg);
@@ -1549,8 +1549,7 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg, char *name)
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
 						     TARGET_PROT_NORMAL, &tpid,
-						     name, tv_nexus,
-						     scsiback_alloc_sess_cb);
+						     name, tv_nexus);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
 		ret = -ENOMEM;
@@ -1838,6 +1837,7 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.queue_status			= scsiback_queue_status,
 	.queue_tm_rsp			= scsiback_queue_tm_rsp,
 	.aborted_task			= scsiback_aborted_task,
+	.init_session			= scsiback_init_sess,
 	/*
 	 * Setup callers for generic logic in target_core_fabric_configfs.c
 	 */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index be43180..509edcf 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -77,6 +77,9 @@ struct target_core_fabric_ops {
 
 	/* Optional session management and sysfs callouts */
 	const struct attribute_group *session_attrs;
+	int (*init_session)(struct se_portal_group *, struct se_session *,
+			    void *);
+	void (*free_session)(struct se_session *);
 
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
@@ -126,9 +129,7 @@ struct target_core_fabric_ops {
 struct t10_transport_id *target_cp_transport_id(struct t10_transport_id *);
 struct se_session *target_setup_session(struct se_portal_group *,
 		unsigned int, unsigned int, enum target_prot_op prot_op,
-		struct t10_transport_id *, const char *, void *,
-		int (*callback)(struct se_portal_group *,
-				struct se_session *, void *));
+		struct t10_transport_id *, const char *, void *);
 void target_remove_session(struct se_session *);
 
 int transport_init_session(struct se_session *se_sess);
-- 
1.8.3.1
