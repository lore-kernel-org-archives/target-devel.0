From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:56:59 +0000
Subject: [PATCH v3 10/13] scsi: qla2xxx: Send Notify ACK after N2N PLOGI
Message-Id: <20191125165702.1013-11-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Krishna Kant <krishna.kant@purestorage.com>, Alexei Potashnik <alexei@purestorage.com>, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

qlt_handle_login schedules session for deletion even if a login is in
progress. That causes login bouncing, i.e. a few logins are made before
it settles down.

Complete the first login by sending Notify Acknowledge IOCB via
qlt_plogi_ack_unref if the session is pending login completion.

Fixes: 9cd883f07a54 ("scsi: qla2xxx: Fix session cleanup for N2N")
Cc: Krishna Kant <krishna.kant@purestorage.com>
Cc: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <qutran@marvell.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index eeb069d52f3d..68c14143e50e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4803,6 +4803,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 
 	switch (sess->disc_state) {
 	case DSC_DELETED:
+	case DSC_LOGIN_PEND:
 		qlt_plogi_ack_unref(vha, pla);
 		break;
 
-- 
2.24.0
