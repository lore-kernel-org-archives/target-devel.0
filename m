From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Mon, 02 Oct 2017 17:59:38 +0000
Subject: [PATCH] ibmvscsis: Fix write_pending failure path
Message-Id: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>

From: "Bryant G. Ly" <bgly@us.ibm.com>

For write_pending if the queue is down or client failed
then return -EIO so that LIO can properly process the
completed command. Prior we returned 0 since LIO could
not handle it properly. Now with:
target: Fix unknown fabric callback queue-full errors
that patch addresses LIO's ability to handle things right.

Signed-off-by: Bryant G. Ly <bgly@us.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 1f75d0380516f..fe5b9d7bc06df 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3767,7 +3767,7 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	 */
 	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
 		pr_err("write_pending failed since: %d\n", vscsi->flags);
-		return 0;
+		return -EIO;
 	}
 
 	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
-- 
2.13.5 (Apple Git-94)

