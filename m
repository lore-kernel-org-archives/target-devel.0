From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 20 Nov 2019 22:27:12 +0000
Subject: [PATCH v2 04/15] scsi: qla2xxx: Change discovery state before PLOGI
Message-Id: <20191120222723.27779-5-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>, stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>

When a port sends PLOGI, discovery state should be changed to login
pending, otherwise RELOGIN_NEEDED bit is set in
qla24xx_handle_plogi_done_event(). RELOGIN_NEEDED triggers another
PLOGI, and it never goes out of the loop until login timer expires.

Fixes: 8777e4314d397 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Fixes: 8b5292bcfcacf ("scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag")
Cc: Quinn Tran <qutran@marvell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4f3da968163e..fcb309be50d9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -533,6 +533,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	return qla2x00_post_work(vha, e);
 }
 
-- 
2.24.0
