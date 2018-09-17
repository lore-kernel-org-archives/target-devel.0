From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:52 +0000
Subject: [PATCH 15/17] target/core: Remove the write_pending_status() callback function
Message-Id: <20180917213554.987-16-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Due to the patch that makes TMF handling synchronous the
write_pending_status() callback function is no longer called.
Hence remove it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Andy Grover <agrover@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
---
 Documentation/target/tcm_mod_builder.py      |  8 --------
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  9 ---------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 15 ---------------
 drivers/target/iscsi/iscsi_target_configfs.c | 13 -------------
 drivers/target/loopback/tcm_loop.c           |  6 ------
 drivers/target/sbp/sbp_target.c              |  6 ------
 drivers/target/target_core_configfs.c        |  4 ----
 drivers/target/target_core_xcopy.c           |  6 ------
 drivers/target/tcm_fc/tcm_fc.h               |  1 -
 drivers/target/tcm_fc/tfc_cmd.c              |  7 -------
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/usb/gadget/function/f_tcm.c          |  9 ---------
 drivers/vhost/scsi.c                         |  6 ------
 drivers/xen/xen-scsiback.c                   |  6 ------
 include/target/target_core_fabric.h          |  1 -
 16 files changed, 104 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 94bf6944bb1e..95d6e31f1e3a 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -297,7 +297,6 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "	.sess_get_index			= " + fabric_mod_name + "_sess_get_index,\n"
 	buf += "	.sess_get_initiator_sid		= NULL,\n"
 	buf += "	.write_pending			= " + fabric_mod_name + "_write_pending,\n"
-	buf += "	.write_pending_status		= " + fabric_mod_name + "_write_pending_status,\n"
 	buf += "	.set_default_node_attributes	= " + fabric_mod_name + "_set_default_node_attrs,\n"
 	buf += "	.get_cmd_state			= " + fabric_mod_name + "_get_cmd_state,\n"
 	buf += "	.queue_data_in			= " + fabric_mod_name + "_queue_data_in,\n"
@@ -479,13 +478,6 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 			buf += "}\n\n"
 			bufi += "int " + fabric_mod_name + "_write_pending(struct se_cmd *);\n"
 
-		if re.search('write_pending_status\)\(', fo):
-			buf += "int " + fabric_mod_name + "_write_pending_status(struct se_cmd *se_cmd)\n"
-			buf += "{\n"
-			buf += "	return 0;\n"
-			buf += "}\n\n"
-			bufi += "int " + fabric_mod_name + "_write_pending_status(struct se_cmd *);\n"
-
 		if re.search('set_default_node_attributes\)\(', fo):
 			buf += "void " + fabric_mod_name + "_set_default_node_attrs(struct se_node_acl *nacl)\n"
 			buf += "{\n"
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f37cbad022a2..015442c63209 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2607,14 +2607,6 @@ static int srpt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 	return ret;
 }
 
-static int srpt_write_pending_status(struct se_cmd *se_cmd)
-{
-	struct srpt_send_ioctx *ioctx;
-
-	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
-	return ioctx->state = SRPT_STATE_NEED_DATA;
-}
-
 /*
  * srpt_write_pending - Start data transfer from initiator to target (write).
  */
@@ -3691,7 +3683,6 @@ static const struct target_core_fabric_ops srpt_template = {
 	.sess_get_index			= srpt_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
-	.write_pending_status		= srpt_write_pending_status,
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
 	.queue_data_in			= srpt_queue_data_in,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index fac377320158..7f9ee6272dc3 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3795,11 +3795,6 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int ibmvscsis_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void ibmvscsis_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -4061,7 +4056,6 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.release_cmd			= ibmvscsis_release_cmd,
 	.sess_get_index			= ibmvscsis_sess_get_index,
 	.write_pending			= ibmvscsis_write_pending,
-	.write_pending_status		= ibmvscsis_write_pending_status,
 	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
 	.get_cmd_state			= ibmvscsis_get_cmd_state,
 	.queue_data_in			= ibmvscsis_queue_data_in,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2cedfd4f15a3..fc75f123b7ca 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -411,19 +411,6 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	return qlt_rdy_to_xfer(cmd);
 }
 
-static int tcm_qla2xxx_write_pending_status(struct se_cmd *se_cmd)
-{
-	unsigned long flags;
-	bool wp;
-
-	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
-	wp = se_cmd->t_state = TRANSPORT_WRITE_PENDING ||
-		se_cmd->t_state = TRANSPORT_COMPLETE_QF_WP;
-	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
-
-	return wp;
-}
-
 static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
 {
 	return;
@@ -1894,7 +1881,6 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
-	.write_pending_status		= tcm_qla2xxx_write_pending_status,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
@@ -1936,7 +1922,6 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
-	.write_pending_status		= tcm_qla2xxx_write_pending_status,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 95d0a22b2ad6..1ce137a43b86 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1394,18 +1394,6 @@ static int lio_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int lio_write_pending_status(struct se_cmd *se_cmd)
-{
-	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
-	int ret;
-
-	spin_lock_bh(&cmd->istate_lock);
-	ret = !(cmd->cmd_flags & ICF_GOT_LAST_DATAOUT);
-	spin_unlock_bh(&cmd->istate_lock);
-
-	return ret;
-}
-
 static int lio_queue_status(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1569,7 +1557,6 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.sess_get_index			= lio_sess_get_index,
 	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
-	.write_pending_status		= lio_write_pending_status,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
 	.get_cmd_state			= iscsi_get_cmd_state,
 	.queue_data_in			= lio_queue_data_in,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index bc8918f382e4..d71108abfc27 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -565,11 +565,6 @@ static int tcm_loop_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_loop_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
@@ -1165,7 +1160,6 @@ static const struct target_core_fabric_ops loop_ops = {
 	.release_cmd			= tcm_loop_release_cmd,
 	.sess_get_index			= tcm_loop_sess_get_index,
 	.write_pending			= tcm_loop_write_pending,
-	.write_pending_status		= tcm_loop_write_pending_status,
 	.set_default_node_attributes	= tcm_loop_set_default_node_attributes,
 	.get_cmd_state			= tcm_loop_get_cmd_state,
 	.queue_data_in			= tcm_loop_queue_data_in,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3d10189ecedc..fe13af057a55 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1754,11 +1754,6 @@ static int sbp_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int sbp_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void sbp_set_default_node_attrs(struct se_node_acl *nacl)
 {
 	return;
@@ -2335,7 +2330,6 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.release_cmd			= sbp_release_cmd,
 	.sess_get_index			= sbp_sess_get_index,
 	.write_pending			= sbp_write_pending,
-	.write_pending_status		= sbp_write_pending_status,
 	.set_default_node_attributes	= sbp_set_default_node_attrs,
 	.get_cmd_state			= sbp_get_cmd_state,
 	.queue_data_in			= sbp_queue_data_in,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f6b1549f4142..355b3ef292e9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -395,10 +395,6 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
 	}
-	if (!tfo->write_pending_status) {
-		pr_err("Missing tfo->write_pending_status()\n");
-		return -EINVAL;
-	}
 	if (!tfo->set_default_node_attributes) {
 		pr_err("Missing tfo->set_default_node_attributes()\n");
 		return -EINVAL;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 124495f953fa..e300a07d0e76 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -447,11 +447,6 @@ static int xcopy_pt_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int xcopy_pt_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int xcopy_pt_queue_data_in(struct se_cmd *se_cmd)
 {
 	return 0;
@@ -468,7 +463,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 	.release_cmd		= xcopy_pt_release_cmd,
 	.check_stop_free	= xcopy_pt_check_stop_free,
 	.write_pending		= xcopy_pt_write_pending,
-	.write_pending_status	= xcopy_pt_write_pending_status,
 	.queue_data_in		= xcopy_pt_queue_data_in,
 	.queue_status		= xcopy_pt_queue_status,
 };
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 11d27b93b413..b8ced4458118 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -158,7 +158,6 @@ void ft_release_cmd(struct se_cmd *);
 int ft_queue_status(struct se_cmd *);
 int ft_queue_data_in(struct se_cmd *);
 int ft_write_pending(struct se_cmd *);
-int ft_write_pending_status(struct se_cmd *);
 int ft_get_cmd_state(struct se_cmd *);
 void ft_queue_tm_resp(struct se_cmd *);
 void ft_aborted_task(struct se_cmd *);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index a183d4da7db2..f0529ba58f4c 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -184,13 +184,6 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
-int ft_write_pending_status(struct se_cmd *se_cmd)
-{
-	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
-
-	return cmd->write_data_len != se_cmd->data_length;
-}
-
 /*
  * Send TX_RDY (transfer ready).
  */
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index e55c4d537592..b32d5fc4a5ef 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -443,7 +443,6 @@ static const struct target_core_fabric_ops ft_fabric_ops = {
 	.sess_get_index =		ft_sess_get_index,
 	.sess_get_initiator_sid =	NULL,
 	.write_pending =		ft_write_pending,
-	.write_pending_status =		ft_write_pending_status,
 	.set_default_node_attributes =	ft_set_default_node_attr,
 	.get_cmd_state =		ft_get_cmd_state,
 	.queue_data_in =		ft_queue_data_in,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 106988a6661a..c8e4c840f88b 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1297,14 +1297,6 @@ static u32 usbg_sess_get_index(struct se_session *se_sess)
 	return 0;
 }
 
-/*
- * XXX Error recovery: return != 0 if we expect writes. Dunno when that could be
- */
-static int usbg_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void usbg_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -1731,7 +1723,6 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.sess_get_index			= usbg_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
-	.write_pending_status		= usbg_write_pending_status,
 	.set_default_node_attributes	= usbg_set_default_node_attrs,
 	.get_cmd_state			= usbg_get_cmd_state,
 	.queue_data_in			= usbg_send_read_response,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c24bb690680b..454323ba26ad 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -338,11 +338,6 @@ static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int vhost_scsi_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void vhost_scsi_set_default_node_attrs(struct se_node_acl *nacl)
 {
 	return;
@@ -2072,7 +2067,6 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.sess_get_index			= vhost_scsi_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
-	.write_pending_status		= vhost_scsi_write_pending_status,
 	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			= vhost_scsi_get_cmd_state,
 	.queue_data_in			= vhost_scsi_queue_data_in,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 14a3d4cbc2a7..803d49679bbc 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1404,11 +1404,6 @@ static int scsiback_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int scsiback_write_pending_status(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void scsiback_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -1824,7 +1819,6 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.sess_get_index			= scsiback_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
-	.write_pending_status		= scsiback_write_pending_status,
 	.set_default_node_attributes	= scsiback_set_default_node_attrs,
 	.get_cmd_state			= scsiback_get_cmd_state,
 	.queue_data_in			= scsiback_queue_data_in,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 792149993859..d1eb42c58ac4 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -64,7 +64,6 @@ struct target_core_fabric_ops {
 	u32 (*sess_get_initiator_sid)(struct se_session *,
 				      unsigned char *, u32);
 	int (*write_pending)(struct se_cmd *);
-	int (*write_pending_status)(struct se_cmd *);
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	int (*get_cmd_state)(struct se_cmd *);
 	int (*queue_data_in)(struct se_cmd *);
-- 
2.18.0
