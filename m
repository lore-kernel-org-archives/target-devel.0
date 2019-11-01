From: Saurav Girepunje <saurav.girepunje@gmail.com>
Date: Fri, 01 Nov 2019 12:47:03 +0000
Subject: [PATCH] scsi: ibmvscsi_tgt: Remove unneeded variable rc
Message-Id: <20191101120407.GA9369@saurav>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mikecyr@linux.ibm.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: saurav.girepunje@hotmail.com

Variable rc is not modified in ibmvscsis_srp_i_logout function.
So remove unneeded variable rc.

Issue found using coccicheck tool.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 7f9535392a93..09a4dbd0a9e5 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2353,7 +2353,6 @@ static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
 {
 	struct iu_entry *iue = cmd->iue;
 	struct srp_i_logout *log_out = &vio_iu(iue)->srp.i_logout;
-	long rc = ADAPT_SUCCESS;
 
 	if ((vscsi->debit > 0) || !list_empty(&vscsi->schedule_q) ||
 	    !list_empty(&vscsi->waiting_rsp)) {
@@ -2369,7 +2368,7 @@ static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
 		ibmvscsis_post_disconnect(vscsi, WAIT_IDLE, 0);
 	}
 
-	return rc;
+	return ADAPT_SUCCESS;
 }
 
 /* Called with intr lock held */
-- 
2.20.1
