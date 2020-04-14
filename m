From: Mike Christie <mchristi@redhat.com>
Date: Tue, 14 Apr 2020 05:15:14 +0000
Subject: [RFC PATCH 5/5] target: drop sess_get_index
Message-Id: <20200414051514.7296-6-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

LIO now handles session id allocation so drop the callout.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ---------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  7 -------
 drivers/target/iscsi/iscsi_target_configfs.c |  6 ------
 drivers/target/loopback/tcm_loop.c           |  6 ------
 drivers/target/sbp/sbp_target.c              |  6 ------
 drivers/target/target_core_configfs.c        |  4 ----
 drivers/target/target_core_stat.c            |  5 +----
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/target/tcm_fc/tfc_sess.c             |  7 -------
 drivers/usb/gadget/function/f_tcm.c          |  6 ------
 drivers/vhost/scsi.c                         |  6 ------
 drivers/xen/xen-scsiback.c                   |  6 ------
 include/target/target_core_fabric.h          |  1 -
 14 files changed, 1 insertion(+), 81 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a4f4a55..3c7af9a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3353,20 +3353,6 @@ static void srpt_close_session(struct se_session *se_sess)
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
@@ -3843,7 +3829,6 @@ static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
 	.release_cmd			= srpt_release_cmd,
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
-	.sess_get_index			= srpt_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index bf5dd4c..ac74986 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3739,11 +3739,6 @@ static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
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
@@ -4034,7 +4029,6 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
 	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd			= ibmvscsis_release_cmd,
-	.sess_get_index			= ibmvscsis_sess_get_index,
 	.write_pending			= ibmvscsis_write_pending,
 	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
 	.get_cmd_state			= ibmvscsis_get_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 27f968f..80fbb55 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -377,11 +377,6 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	tcm_qla2xxx_put_sess(sess);
 }
 
-static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -1852,7 +1847,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
@@ -1892,7 +1886,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index e9e06bb..c4cdea5 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1342,11 +1342,6 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
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
@@ -1542,7 +1537,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.check_stop_free		= lio_check_stop_free,
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
-	.sess_get_index			= lio_sess_get_index,
 	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6e2ebe9..c806085 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -512,11 +512,6 @@ static u32 tcm_loop_get_inst_index(struct se_portal_group *se_tpg)
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
@@ -1138,7 +1133,6 @@ static ssize_t tcm_loop_wwn_version_show(struct config_item *item, char *page)
 	.tpg_get_inst_index		= tcm_loop_get_inst_index,
 	.check_stop_free		= tcm_loop_check_stop_free,
 	.release_cmd			= tcm_loop_release_cmd,
-	.sess_get_index			= tcm_loop_sess_get_index,
 	.write_pending			= tcm_loop_write_pending,
 	.set_default_node_attributes	= tcm_loop_set_default_node_attributes,
 	.get_cmd_state			= tcm_loop_get_cmd_state,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 43aaf35..043842f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1708,11 +1708,6 @@ static void sbp_release_cmd(struct se_cmd *se_cmd)
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
@@ -2309,7 +2304,6 @@ static ssize_t sbp_tpg_attrib_max_logins_per_lun_store(struct config_item *item,
 	.tpg_check_prod_mode_write_protect = sbp_check_false,
 	.tpg_get_inst_index		= sbp_tpg_get_inst_index,
 	.release_cmd			= sbp_release_cmd,
-	.sess_get_index			= sbp_sess_get_index,
 	.write_pending			= sbp_write_pending,
 	.set_default_node_attributes	= sbp_set_default_node_attrs,
 	.get_cmd_state			= sbp_get_cmd_state,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3fd08c5..638060f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -399,10 +399,6 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
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
index 237309d..2aeb843 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1264,7 +1264,6 @@ static ssize_t target_stat_iport_indx_show(struct config_item *item,
 	struct se_lun_acl *lacl = iport_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
 
 	spin_lock_irq(&nacl->nacl_sess_lock);
@@ -1274,10 +1273,8 @@ static ssize_t target_stat_iport_indx_show(struct config_item *item,
 		return -ENODEV;
 	}
 
-	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->sess_get_index(se_sess));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 1a38c98..ff18e0a 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -426,7 +426,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	.check_stop_free =		ft_check_stop_free,
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
-	.sess_get_index =		ft_sess_get_index,
 	.sess_get_initiator_sid =	NULL,
 	.write_pending =		ft_write_pending,
 	.set_default_node_attributes =	ft_set_default_node_attr,
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4973052..5102be5 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -325,13 +325,6 @@ void ft_sess_close(struct se_session *se_sess)
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
index 9363130..7d016e2 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1287,11 +1287,6 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 usbg_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void usbg_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -1715,7 +1710,6 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.tpg_check_prod_mode_write_protect = usbg_check_false,
 	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
-	.sess_get_index			= usbg_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
 	.set_default_node_attributes	= usbg_set_default_node_attrs,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d3db74c..e2ddbc3 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -340,11 +340,6 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
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
@@ -2290,7 +2285,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
-	.sess_get_index			= vhost_scsi_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
 	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 057d8a1..cd37c59 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1392,11 +1392,6 @@ static void scsiback_release_cmd(struct se_cmd *se_cmd)
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
@@ -1813,7 +1808,6 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.tpg_get_inst_index		= scsiback_tpg_get_inst_index,
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
-	.sess_get_index			= scsiback_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
 	.set_default_node_attributes	= scsiback_set_default_node_attrs,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 9815dbf..6060eb3 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -66,7 +66,6 @@ struct target_core_fabric_ops {
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
-	u32 (*sess_get_index)(struct se_session *);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
 	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-- 
1.8.3.1
