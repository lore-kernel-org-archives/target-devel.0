From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:51 +0000
Subject: [PATCH 09/16] RDMA/srpt: Fix a credit leak for aborted commands
Message-Id: <20190125183458.220477-10-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Make sure that the next time a response is sent to the initiator that the
credit it had allocated for the aborted request gets freed.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 131e6abc674e ("target: Add TFO->abort_task for aborted task resources release") # v3.15
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d426e01905f9..1a039f16d315 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2870,8 +2870,19 @@ static void srpt_queue_tm_rsp(struct se_cmd *cmd)
 	srpt_queue_response(cmd);
 }
 
+/*
+ * This function is called for aborted commands if no response is sent to the
+ * initiator. Make sure that the credits freed by aborting a command are
+ * returned to the initiator the next time a response is sent by incrementing
+ * ch->req_lim_delta.
+ */
 static void srpt_aborted_task(struct se_cmd *cmd)
 {
+	struct srpt_send_ioctx *ioctx = container_of(cmd,
+				struct srpt_send_ioctx, cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
+
+	atomic_inc(&ch->req_lim_delta);
 }
 
 static int srpt_queue_status(struct se_cmd *cmd)
-- 
2.20.1.495.gaa96b0ce6b-goog
