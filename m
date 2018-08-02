From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:23 +0000
Subject: [PATCH 4/8] target: rename target_alloc_session
Message-Id: <1533229947-6277-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Rename target_alloc_session to target_setup_session to avoid confusion
with the other transport session allocation function that only allocates
the session and because the target_alloc_session does so much more. It
allocates the session, sets up the nacl and registers the session.

The next patch will then add a remove function to match the setup in
this one, so it should make sense for all drivers, except iscsi, to just
call those 2 functions to setup and remove a session.

iscsi will continue to be the odd driver.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Boot <bootc@bootc.net>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <qla2xxx-upstream@qlogic.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Juergen Gross <jgross@suse.com>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 6 +++---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       | 2 +-
 drivers/target/loopback/tcm_loop.c       | 2 +-
 drivers/target/sbp/sbp_target.c          | 2 +-
 drivers/target/target_core_transport.c   | 4 ++--
 drivers/target/tcm_fc/tfc_sess.c         | 2 +-
 drivers/usb/gadget/function/f_tcm.c      | 2 +-
 drivers/vhost/scsi.c                     | 2 +-
 drivers/xen/xen-scsiback.c               | 2 +-
 include/target/target_core_fabric.h      | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 07b3e1c..21435a7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2221,16 +2221,16 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	pr_debug("registering session %s\n", ch->sess_name);
 
 	if (sport->port_guid_tpg.se_tpg_wwn)
-		ch->sess = target_alloc_session(&sport->port_guid_tpg, 0, 0,
+		ch->sess = target_setup_session(&sport->port_guid_tpg, 0, 0,
 						TARGET_PROT_NORMAL,
 						ch->sess_name, ch, NULL);
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
-		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
+		ch->sess = target_setup_session(&sport->port_gid_tpg, 0, 0,
 					TARGET_PROT_NORMAL, i_port_id, ch,
 					NULL);
 	/* Retry without leading "0x" */
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
-		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
+		ch->sess = target_setup_session(&sport->port_gid_tpg, 0, 0,
 						TARGET_PROT_NORMAL,
 						i_port_id + 2, ch, NULL);
 	if (IS_ERR_OR_NULL(ch->sess)) {
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index fdda04e..1bdf937 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2233,7 +2233,7 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_tport *tport)
 		return -ENOMEM;
 	}
 
-	nexus->se_sess = target_alloc_session(&tport->se_tpg, 0, 0,
+	nexus->se_sess = target_setup_session(&tport->se_tpg, 0, 0,
 					      TARGET_PROT_NORMAL, name, nexus,
 					      NULL);
 	if (IS_ERR(nexus->se_sess)) {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index cfb5d60..b9ce4e7 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1539,7 +1539,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
-	se_sess = target_alloc_session(&tpg->se_tpg, num_tags,
+	se_sess = target_setup_session(&tpg->se_tpg, num_tags,
 				       sizeof(struct qla_tgt_cmd),
 				       TARGET_PROT_ALL, port_name,
 				       qlat_sess, tcm_qla2xxx_session_cb);
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index b2e7ff5..54b5b94 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -765,7 +765,7 @@ static int tcm_loop_make_nexus(
 	if (!tl_nexus)
 		return -ENOMEM;
 
-	tl_nexus->se_sess = target_alloc_session(&tl_tpg->tl_se_tpg, 0, 0,
+	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
 					name, tl_nexus, tcm_loop_alloc_sess_cb);
 	if (IS_ERR(tl_nexus->se_sess)) {
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index b61b79a..c4369b5 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -209,7 +209,7 @@ static struct sbp_session *sbp_session_create(
 	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
 	sess->guid = guid;
 
-	sess->se_sess = target_alloc_session(&tpg->se_tpg, 128,
+	sess->se_sess = target_setup_session(&tpg->se_tpg, 128,
 					     sizeof(struct sbp_target_request),
 					     TARGET_PROT_NORMAL, guid_str,
 					     sess, NULL);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8044b81..57fadec 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -416,7 +416,7 @@ void transport_register_session(
 EXPORT_SYMBOL(transport_register_session);
 
 struct se_session *
-target_alloc_session(struct se_portal_group *tpg,
+target_setup_session(struct se_portal_group *tpg,
 		     unsigned int tag_num, unsigned int tag_size,
 		     enum target_prot_op prot_op,
 		     const char *initiatorname, void *private,
@@ -458,7 +458,7 @@ target_alloc_session(struct se_portal_group *tpg,
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
 }
-EXPORT_SYMBOL(target_alloc_session);
+EXPORT_SYMBOL(target_setup_session);
 
 ssize_t target_show_dynamic_sessions(struct se_portal_group *se_tpg, char *page)
 {
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index c91979c..efd7d5e 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -239,7 +239,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	sess->tport = tport;
 	sess->port_id = port_id;
 
-	sess->se_sess = target_alloc_session(se_tpg, TCM_FC_DEFAULT_TAGS,
+	sess->se_sess = target_setup_session(se_tpg, TCM_FC_DEFAULT_TAGS,
 					     sizeof(struct ft_cmd),
 					     TARGET_PROT_NORMAL, &initiatorname[0],
 					     sess, ft_sess_alloc_cb);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 4f18317..ba7c5f6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1592,7 +1592,7 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 		goto out_unlock;
 	}
 
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 						     USB_G_DEFAULT_SESSION_TAGS,
 						     sizeof(struct usbg_cmd),
 						     TARGET_PROT_NORMAL, name,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c84a6ed..e936884 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1738,7 +1738,7 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index fd77ccf..2ffc7ed 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1521,7 +1521,7 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 		goto out_unlock;
 	}
 
-	tv_nexus->tvn_se_sess = target_alloc_session(&tpg->se_tpg,
+	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
 						     TARGET_PROT_NORMAL, name,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d0d0642..fbcc9a4 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -109,7 +109,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo);
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
-struct se_session *target_alloc_session(struct se_portal_group *,
+struct se_session *target_setup_session(struct se_portal_group *,
 		unsigned int, unsigned int, enum target_prot_op prot_op,
 		const char *, void *,
 		int (*callback)(struct se_portal_group *,
-- 
2.7.2

