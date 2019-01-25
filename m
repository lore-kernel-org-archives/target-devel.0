From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:49 +0000
Subject: [PATCH 07/16] RDMA/srpt: Fix handling of TMF submission failure
Message-Id: <20190125183458.220477-8-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If submitting a TMF to the target core fails, send the "FUNCTION
REJECTED" response to the initiator.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4fc901d1c0c1..0dc2df925f76 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1581,11 +1581,9 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 			       TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
-		goto fail;
+		cmd->se_tfo->queue_tm_rsp(cmd);
 	}
 	return;
-fail:
-	transport_send_check_condition_and_sense(cmd, 0, 0); // XXX:
 }
 
 /**
-- 
2.20.1.495.gaa96b0ce6b-goog
