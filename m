From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:56:55 +0000
Subject: [PATCH v3 06/13] scsi: qla2xxx: Allow PLOGI in target mode
Message-Id: <20191125165702.1013-7-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>

According to FC-LS-3 (Fibre Channel Link Services) 6.3.2.4
"N_Port Login - No Fabric present", if both parties in the point-to-point
connection know N_Port_Names of each other, Nx_Port with the highest
N_Port_name shall transmit PLOGI. The specification sets no restrictions
on the port role that should send PLOGI.

However, FCP-4 (Fibre Channel Protocol for SCSI, Fourth Version) 6.2
"Overview of Process Login and Process Logout", instructs that in
point-to-point topology, initiator shall send explicit PRLI ELS.

The change fixes stuck P2P login, when target WWPN is higher than
initiator WWPN.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index fcb309be50d9..b4283a3126d0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1527,8 +1527,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		}
 	}
 
-	/* for pure Target Mode. Login will not be initiated */
-	if (vha->host->active_mode = MODE_TARGET)
+	/* Target won't initiate port login if fabric is present */
+	if (vha->host->active_mode = MODE_TARGET && !N2N_TOPO(vha->hw))
 		return 0;
 
 	if (fcport->flags & FCF_ASYNC_SENT) {
@@ -1720,6 +1720,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
 				      struct event_arg *ea)
 {
+	/* for pure Target Mode, PRLI will not be initiated */
+	if (vha->host->active_mode = MODE_TARGET)
+		return;
+
 	ql_dbg(ql_dbg_disc, vha, 0x2118,
 	    "%s %d %8phC post PRLI\n",
 	    __func__, __LINE__, ea->fcport->port_name);
-- 
2.24.0
