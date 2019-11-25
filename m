From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:56:58 +0000
Subject: [PATCH v3 09/13] scsi: qla2xxx: Configure local loop for N2N target
Message-Id: <20191125165702.1013-10-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

qla2x00_configure_local_loop initializes PLOGI payload for PLOGI ELS
using Get Parameters mailbox command.

In the case when the driver is running in target mode, the topology is
N2N and the target port has higher WWPN, LOCAL_LOOP_UPDATE bit is
cleared too early and PLOGI payload is not initialized by the Get
Parameters command. That causes a failure of ELS IOCB carrying the
PLOGI with 0x15 aka Data Underrun error.

LOCAL_LOOP_UPDATE has to be set to initialize PLOGI payload.

Fixes: 48acad099074 ("scsi: qla2xxx: Fix N2N link re-connect")
Acked-by: Quinn Tran <qutran@marvell.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4283a3126d0..bc3695dc9b9e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4936,14 +4936,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
-	} else if (ha->current_topology = ISP_CFG_N) {
-		clear_bit(RSCN_UPDATE, &flags);
-		if (qla_tgt_mode_enabled(vha)) {
-			/* allow the other side to start the login */
-			clear_bit(LOCAL_LOOP_UPDATE, &flags);
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		}
-	} else if (ha->current_topology = ISP_CFG_NL) {
+	} else if (ha->current_topology = ISP_CFG_NL ||
+		   ha->current_topology = ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
-- 
2.24.0
