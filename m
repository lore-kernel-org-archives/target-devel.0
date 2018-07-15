From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:21 +0000
Subject: [PATCH 05/15] target: remove sess_get_index
Message-Id: <1531696591-8558-6-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

sess_get_index is meaninless for most drivers. For iscsi, it
is the same as the se_session->sid now and for fcoe it was just
the port id which would not work if multiple initiators
connected to the same target port. So just use the se_session sid
for all drivers and remove sess_get_index callout.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 Documentation/target/tcm_mod_builder.py      |  8 --------
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ---------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  7 -------
 drivers/target/iscsi/iscsi_target_configfs.c |  6 ------
 drivers/target/loopback/tcm_loop.c           |  6 ------
 drivers/target/sbp/sbp_target.c              |  6 ------
 drivers/target/target_core_configfs.c        |  4 ----
 drivers/target/target_core_stat.c            |  3 +--
 drivers/target/tcm_fc/tcm_fc.h               |  1 -
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/target/tcm_fc/tfc_sess.c             |  7 -------
 drivers/usb/gadget/function/f_tcm.c          |  6 ------
 drivers/vhost/scsi.c                         |  6 ------
 drivers/xen/xen-scsiback.c                   |  6 ------
 include/target/target_core_fabric.h          |  1 -
 16 files changed, 1 insertion(+), 88 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 94bf694..1befc88 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -294,7 +294,6 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "	.tpg_check_prod_mode_write_protect = " + fabric_mod_name + "_check_false,\n"
 	buf += "	.tpg_get_inst_index		= " + fabric_mod_name + "_tpg_get_inst_index,\n"
 	buf += "	.release_cmd			= " + fabric_mod_name + "_release_cmd,\n"
-	buf += "	.sess_get_index			= " + fabric_mod_name + "_sess_get_index,\n"
 	buf += "	.sess_get_initiator_sid		= NULL,\n"
 	buf += "	.write_pending			= " + fabric_mod_name + "_write_pending,\n"
 	buf += "	.write_pending_status		= " + fabric_mod_name + "_write_pending_status,\n"
@@ -465,13 +464,6 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 			buf += "}\n\n"
 			bufi += "void " + fabric_mod_name + "_release_cmd(struct se_cmd *);\n"
 
-		if re.search('sess_get_index\)\(', fo):
-			buf += "u32 " + fabric_mod_name + "_sess_get_index(struct se_session *se_sess)\n"
-			buf += "{\n"
-			buf += "	return 0;\n"
-			buf += "}\n\n"
-			bufi += "u32 " + fabric_mod_name + "_sess_get_index(struct se_session *);\n"
-
 		if re.search('write_pending\)\(', fo):
 			buf += "int " + fabric_mod_name + "_write_pending(struct se_cmd *se_cmd)\n"
 			buf += "{\n"
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 07b3e1c..73fee6a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3198,20 +3198,6 @@ static void srpt_close_session(struct se_session *se_sess)
 	srpt_disconnect_ch_sync(ch);
 }
 
-/**
- * srpt_sess_get_index - return the value of scsiAttIntrPortIndex (SCSI-MIB)
- * @se_sess: SCSI target session.
- *
- * A quote from RFC 4455 (SCSI-MIB) about this MIB object:
- * This object represents an arbitrary integer used to uniquely identify a
- * particular attached remote initiator port to a particular SCSI target port
- * within a particular SCSI target device within a particular SCSI instance.
- */
-static u32 srpt_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -3676,7 +3662,6 @@ static const struct target_core_fabric_ops srpt_template = {
 	.release_cmd			= srpt_release_cmd,
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
-	.sess_get_index			= srpt_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
 	.write_pending_status		= srpt_write_pending_status,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index fdda04e..c04e4bd 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3757,11 +3757,6 @@ static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
 	spin_unlock_bh(&vscsi->intr_lock);
 }
 
-static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
@@ -4060,7 +4055,6 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
 	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd			= ibmvscsis_release_cmd,
-	.sess_get_index			= ibmvscsis_sess_get_index,
 	.write_pending			= ibmvscsis_write_pending,
 	.write_pending_status		= ibmvscsis_write_pending_status,
 	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index cfb5d60..2516216 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -369,11 +369,6 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
-static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -1911,7 +1906,6 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.write_pending_status		= tcm_qla2xxx_write_pending_status,
@@ -1953,7 +1947,6 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.write_pending_status		= tcm_qla2xxx_write_pending_status,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 39af194..d58a6f9 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1355,11 +1355,6 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 	return cmd->i_state;
 }
 
-static u32 lio_sess_get_index(struct se_session *se_sess)
-{
-	return se_sess->sid;
-}
-
 static u32 lio_sess_get_initiator_sid(
 	struct se_session *se_sess,
 	unsigned char *buf,
@@ -1565,7 +1560,6 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.check_stop_free		= lio_check_stop_free,
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
-	.sess_get_index			= lio_sess_get_index,
 	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.write_pending_status		= lio_write_pending_status,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index b2e7ff5..c3b39b6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -532,11 +532,6 @@ static u32 tcm_loop_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static u32 tcm_loop_sess_get_index(struct se_session *se_sess)
-{
-	return 1;
-}
-
 static void tcm_loop_set_default_node_attributes(struct se_node_acl *se_acl)
 {
 	return;
@@ -1163,7 +1158,6 @@ static const struct target_core_fabric_ops loop_ops = {
 	.tpg_get_inst_index		= tcm_loop_get_inst_index,
 	.check_stop_free		= tcm_loop_check_stop_free,
 	.release_cmd			= tcm_loop_release_cmd,
-	.sess_get_index			= tcm_loop_sess_get_index,
 	.write_pending			= tcm_loop_write_pending,
 	.write_pending_status		= tcm_loop_write_pending_status,
 	.set_default_node_attributes	= tcm_loop_set_default_node_attributes,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index b61b79a..33b3b4b 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1727,11 +1727,6 @@ static void sbp_release_cmd(struct se_cmd *se_cmd)
 	sbp_free_request(req);
 }
 
-static u32 sbp_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int sbp_write_pending(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req = container_of(se_cmd,
@@ -2334,7 +2329,6 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.tpg_check_prod_mode_write_protect = sbp_check_false,
 	.tpg_get_inst_index		= sbp_tpg_get_inst_index,
 	.release_cmd			= sbp_release_cmd,
-	.sess_get_index			= sbp_sess_get_index,
 	.write_pending			= sbp_write_pending,
 	.write_pending_status		= sbp_write_pending_status,
 	.set_default_node_attributes	= sbp_set_default_node_attrs,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 93d3ff3..8239084 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -387,10 +387,6 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		pr_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
-	if (!tfo->sess_get_index) {
-		pr_err("Missing tfo->sess_get_index()\n");
-		return -EINVAL;
-	}
 	if (!tfo->write_pending) {
 		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index f0db91e..f18a1e5 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1307,8 +1307,7 @@ static ssize_t target_stat_iport_indx_show(struct config_item *item,
 
 	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->sess_get_index(se_sess));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 11d27b9..e92f8d0 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -143,7 +143,6 @@ extern unsigned int ft_debug_logging;
  */
 void ft_sess_put(struct ft_sess *);
 void ft_sess_close(struct se_session *);
-u32 ft_sess_get_index(struct se_session *);
 u32 ft_sess_get_port_name(struct se_session *, unsigned char *, u32);
 
 void ft_lport_add(struct fc_lport *, void *);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index e55c4d5..a7ae48e 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -440,7 +440,6 @@ static const struct target_core_fabric_ops ft_fabric_ops = {
 	.check_stop_free =		ft_check_stop_free,
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
-	.sess_get_index =		ft_sess_get_index,
 	.sess_get_initiator_sid =	NULL,
 	.write_pending =		ft_write_pending,
 	.write_pending_status =		ft_write_pending_status,
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index c91979c..95d4e9c 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -338,13 +338,6 @@ void ft_sess_close(struct se_session *se_sess)
 	synchronize_rcu();		/* let transport deregister happen */
 }
 
-u32 ft_sess_get_index(struct se_session *se_sess)
-{
-	struct ft_sess *sess = se_sess->fabric_sess_ptr;
-
-	return sess->port_id;	/* XXX TBD probably not what is needed */
-}
-
 u32 ft_sess_get_port_name(struct se_session *se_sess,
 			  unsigned char *buf, u32 len)
 {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 4f18317..76b5660 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1292,11 +1292,6 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 usbg_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 /*
  * XXX Error recovery: return != 0 if we expect writes. Dunno when that could be
  */
@@ -1728,7 +1723,6 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.tpg_check_prod_mode_write_protect = usbg_check_false,
 	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
-	.sess_get_index			= usbg_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
 	.write_pending_status		= usbg_write_pending_status,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c84a6ed..92746a1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -326,11 +326,6 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -2069,7 +2064,6 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
-	.sess_get_index			= vhost_scsi_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
 	.write_pending_status		= vhost_scsi_write_pending_status,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index fd77ccf..7c45245 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1381,11 +1381,6 @@ static void scsiback_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_cmd->se_sess, se_cmd);
 }
 
-static u32 scsiback_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int scsiback_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -1811,7 +1806,6 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.tpg_get_inst_index		= scsiback_tpg_get_inst_index,
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
-	.sess_get_index			= scsiback_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
 	.write_pending_status		= scsiback_write_pending_status,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index f61aa71..899da38 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -56,7 +56,6 @@ struct target_core_fabric_ops {
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
-	u32 (*sess_get_index)(struct se_session *);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
 	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-- 
2.7.2

