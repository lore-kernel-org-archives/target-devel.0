From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Apr 2020 19:14:20 +0000
Subject: [RFC PATCH 06/12] target: drop sess_get_initiator_sid
Message-Id: <20200420191426.17055-7-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

sess_get_initiator_sid is no longer used. Drop it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  2 --
 drivers/target/iscsi/iscsi_target_configfs.c | 13 -------------
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/usb/gadget/function/f_tcm.c          |  1 -
 drivers/vhost/scsi.c                         |  1 -
 drivers/xen/xen-scsiback.c                   |  1 -
 include/target/target_core_fabric.h          |  6 ------
 8 files changed, 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index caeb32e..4dd2a41 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3847,7 +3847,6 @@ static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
 	.sess_get_index			= srpt_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 42a4025..dc1bddd 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1833,7 +1833,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
@@ -1873,7 +1872,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 42b369f..f640e7a 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1349,18 +1349,6 @@ static u32 lio_sess_get_index(struct se_session *se_sess)
 	return sess->session_index;
 }
 
-static u32 lio_sess_get_initiator_sid(
-	struct se_session *se_sess,
-	unsigned char *buf,
-	u32 size)
-{
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
-	/*
-	 * iSCSI Initiator Session Identifier from RFC-3720.
-	 */
-	return snprintf(buf, size, "%6phN", sess->isid);
-}
-
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1542,7 +1530,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
 	.sess_get_index			= lio_sess_get_index,
-	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
 	.get_cmd_state			= iscsi_get_cmd_state,
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 1a38c98..870b7bb 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -427,7 +427,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
 	.sess_get_index =		ft_sess_get_index,
-	.sess_get_initiator_sid =	NULL,
 	.write_pending =		ft_write_pending,
 	.set_default_node_attributes =	ft_set_default_node_attr,
 	.get_cmd_state =		ft_get_cmd_state,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index e282eb9..88319b9 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1722,7 +1722,6 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
 	.sess_get_index			= usbg_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
 	.set_default_node_attributes	= usbg_set_default_node_attrs,
 	.get_cmd_state			= usbg_get_cmd_state,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index bc377ee..7ad7a92 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2310,7 +2310,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
 	.sess_get_index			= vhost_scsi_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
 	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			= vhost_scsi_get_cmd_state,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 0855a77f..6f9b4f7 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1831,7 +1831,6 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
 	.sess_get_index			= scsiback_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
 	.set_default_node_attributes	= scsiback_set_default_node_attrs,
 	.get_cmd_state			= scsiback_get_cmd_state,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6b8a6bc..0c1720d 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -67,12 +67,6 @@ struct target_core_fabric_ops {
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
 	u32 (*sess_get_index)(struct se_session *);
-	/*
-	 * Used only for SCSI fabrics that contain multi-value TransportIDs
-	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-	 */
-	u32 (*sess_get_initiator_sid)(struct se_session *,
-				      unsigned char *, u32);
 	int (*write_pending)(struct se_cmd *);
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	int (*get_cmd_state)(struct se_cmd *);
-- 
1.8.3.1
