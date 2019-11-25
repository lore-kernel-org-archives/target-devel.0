From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:57:00 +0000
Subject: [PATCH v3 11/13] scsi: qla2xxx: Don't defer relogin unconditonally
Message-Id: <20191125165702.1013-12-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Himanshu Madhani <hmadhani@marvell.com>, Quinn Tran <qutran@marvell.com>, Hannes Reinecke <hare@suse.de>

qla2x00_configure_local_loop sets RELOGIN_NEEDED bit and calls
qla24xx_fcport_handle_login to perform the login. This bit triggers
a wake up of DPC later after a successful login.

The deferred call is not needed if login succeeds, and it's set in
qla24xx_fcport_handle_login in case of errors, hence it should be safe
to drop.

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Acked-by: Quinn Tran <qutran@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bc3695dc9b9e..31551e8ac5df 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5054,7 +5054,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
-- 
2.24.0
