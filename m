From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 20 Nov 2019 22:27:19 +0000
Subject: [PATCH v2 11/15] scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
Message-Id: <20191120222723.27779-12-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>

PORT UPDATE asynchronous event is generated on the host that issues PLOGI
ELS (in the case of higher WWPN). In that case, the event shouldn't be
handled as it sets unwanted DPC flags (i.e. LOOP_RESYNC_NEEDED) that
trigger link flap.

Ignore the event if the host has higher WWPN, but handle otherwise.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4eb88c3ee08e..bb6811b94683 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3920,6 +3920,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					vha->d_id.b24 = 0;
 					vha->d_id.b.al_pa = 1;
 					ha->flags.n2n_bigger = 1;
+					ha->flags.n2n_ae = 0;
 
 					id.b.al_pa = 2;
 					ql_dbg(ql_dbg_async, vha, 0x5075,
@@ -3930,6 +3931,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					    "Format 1: Remote login - Waiting for WWPN %8phC.\n",
 					    rptid_entry->u.f1.port_name);
 					ha->flags.n2n_bigger = 0;
+					ha->flags.n2n_ae = 1;
 				}
 				qla24xx_post_newsess_work(vha, &id,
 				    rptid_entry->u.f1.port_name,
@@ -3941,7 +3943,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			/* if our portname is higher then initiate N2N login */
 
 			set_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags);
-			ha->flags.n2n_ae = 1;
 			return;
 			break;
 		case TOPO_FL:
-- 
2.24.0
