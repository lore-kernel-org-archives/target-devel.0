From: Quinn Tran <qutran@marvell.com>
Date: Thu, 21 Nov 2019 00:03:01 +0000
Subject: RE: [EXT] [PATCH v2 10/15] scsi: qla2xxx: Don't defer relogin unconditonally
Message-Id: <BYAPR18MB27594A332DE1F7E0AC70B227D54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-11-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-11-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: "linux@yadro.com" <linux@yadro.com>, Himanshu Madhani <hmadhani@marvell.com>

Looks good.

Acked-by: Quinn Tran <qutran@marvell.com>


----------------------------------------------------------------------
qla2x00_configure_local_loop sets RELOGIN_NEEDED bit and calls qla24xx_fcport_handle_login to perform the login. This bit triggers a wake up of DPC later after a successful login.

The deferred call is not needed if login succeeds, and it's set in qla24xx_fcport_handle_login in case of errors, hence it should be safe to drop.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c index 096f41fe17d2..e984746e7428 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5050,7 +5050,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				memcpy(&ha->plogi_els_payld.data,
 				    (void *)ha->init_cb,
 				    sizeof(ha->plogi_els_payld.data));
-				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
--
2.24.0
