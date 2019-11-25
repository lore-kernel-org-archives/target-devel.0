From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:56:51 +0000
Subject: [PATCH v3 02/13] scsi: qla2xxx: Use explicit LOGO in target mode
Message-Id: <20191125165702.1013-3-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>, Himanshu Madhani <hmadhani@marvell.com>, Roman Bolshakov <r.bolshakov@yadro.com>

From: Quinn Tran <qutran@marvell.com>

Target makes implicit LOGO on session teardown. LOGO ELS is not send on
the wire and initiator is not aware that target no longer wants talking
to it. Initiator keeps sending I/O requests, target responds with
BA_RJT, they time out and then initiator sends ABORT TASK (ABTS-LS).

Current behaviour incurs unneeded I/O timeout and can be fixed for some
initiators by making explicit LOGO on session deletion.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c    | 16 ++++++++++++----
 drivers/scsi/qla2xxx/qla_target.c  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 460f443f6471..2edd9f7b3074 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2401,6 +2401,7 @@ typedef struct fc_port {
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
+	unsigned int explicit_logout:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..c5a7736c45be 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2405,11 +2405,19 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 static void
 qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
+	u16 control_flags = LCF_COMMAND_LOGO;
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
-	logio->control_flags -	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
-	if (!sp->fcport->keep_nport_handle)
-		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
+
+	if (sp->fcport->explicit_logout) {
+		control_flags |= LCF_EXPL_LOGO|LCF_FREE_NPORT;
+	} else {
+		control_flags |= LCF_IMPL_LOGO;
+
+		if (!sp->fcport->keep_nport_handle)
+			control_flags |= LCF_FREE_NPORT;
+	}
+
+	logio->control_flags = cpu_to_le16(control_flags);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 51b275a575a5..f94afb3fe448 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1104,6 +1104,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
+	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index bab2073c1f72..abe7f79bb789 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -350,6 +350,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
 }
 
-- 
2.24.0
