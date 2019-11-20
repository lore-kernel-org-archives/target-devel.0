From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 20 Nov 2019 22:27:21 +0000
Subject: [PATCH v2 13/15] scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
Message-Id: <20191120222723.27779-14-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>

qla24xx_els_dcmd_iocb() performs LOGO and might be invoked in contexts where it
is prohibited to sleep. The new wait parameter provides a way to use the
function in such context, similarly to qla24xx_els_dcmd2_iocb().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 481c05dbea06..35c703ec59ad 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -828,7 +828,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 
 	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
 
-	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
+	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did, true);
 	return count;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5b163ad85c34..df0f3421e3bb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -43,7 +43,7 @@ extern void qla2x00_clear_loop_id(fc_port_t *fcport);
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
-extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
+extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t, bool);
 extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
 extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 53ccbd6b71ed..12b37b711ae8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2562,7 +2562,7 @@ static void qla2x00_els_dcmd_sp_done(srb_t *sp, int res)
 
 int
 qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
-    port_id_t remote_did)
+    port_id_t remote_did, bool wait)
 {
 	srb_t *sp;
 	fc_port_t *fcport = NULL;
@@ -2601,6 +2601,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
 	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
+	if (wait)
+		sp->flags = SRB_WAKEUP_ON_COMP;
 	sp->done = qla2x00_els_dcmd_sp_done;
 	sp->free = qla2x00_els_dcmd_sp_free;
 
@@ -2637,9 +2639,14 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    sp->name, sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
-	wait_for_completion(&elsio->u.els_logo.comp);
+	if (wait) {
+		wait_for_completion(&elsio->u.els_logo.comp);
+	} else {
+		goto done;
+	}
 
 	sp->free(sp);
+done:
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 68c14143e50e..0f2bc4cd562f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -932,7 +932,7 @@ qlt_send_first_logo(struct scsi_qla_host *vha, qlt_port_logo_t *logo)
 
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	res = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id);
+	res = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id, true);
 
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	list_del(&logo->list);
-- 
2.24.0
