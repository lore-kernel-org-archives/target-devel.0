From: Quinn Tran <qutran@marvell.com>
Date: Wed, 20 Nov 2019 23:06:14 +0000
Subject: RE: [EXT] [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for N2N target
Message-Id: <BYAPR18MB2759EA9C77A9CD0807F43AC0D54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-9-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-9-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: "linux@yadro.com" <linux@yadro.com>, Himanshu Madhani <hmadhani@marvell.com>

qla2x00_configure_local_loop initializes PLOGI payload for PLOGI ELS using Get Parameters mailbox command.

In the case when the driver is running in target mode, the topology is N2N and the target port has higher WWPN, LOCAL_LOOP_UPDATE bit is cleared too early and PLOGI payload is not initialized by the Get Parameters command. That causes a failure of ELS IOCB carrying the PLOGI with 0x15 aka Data Underrun error.

LOCAL_LOOP_UPDATE has to be set to initialize PLOGI payload.

Fixes: 48acad099074 ("scsi: qla2xxx: Fix N2N link re-connect")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c index 12391815be06..096f41fe17d2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4932,14 +4932,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
-	} else if (ha->current_topology == ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology == ISP_CFG_NL) {
+	} else if (ha->current_topology == ISP_CFG_NL ||
+		   ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
--
2.24.0

QT: ACK.
