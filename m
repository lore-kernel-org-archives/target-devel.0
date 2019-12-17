From: Aditya Pakki <pakki001@umn.edu>
Date: Tue, 17 Dec 2019 19:26:49 +0000
Subject: [PATCH] scsi: RDMA/srpt: Fix incorrect pointer dereference
Message-Id: <20191217192649.24212-1-pakki001@umn.edu>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Bart Van Assche <bvanassche@acm.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

In srpt_queue_response(), the rdma channel ch is first
dereferenced and then checked for NULL. This renders the
assertion ineffective. This patch removes the assertion and
avoids potential NULL pointer dereference.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 23c782e3d49a..bbc6729c81c0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2803,15 +2803,17 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	struct srpt_send_ioctx *ioctx  		container_of(cmd, struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
-	struct srpt_device *sdev = ch->sport->sdev;
 	struct ib_send_wr send_wr, *first_wr = &send_wr;
-	struct ib_sge sge;
 	enum srpt_command_state state;
+	struct srpt_device *sdev;
 	int resp_len, ret, i;
+	struct ib_sge sge;
 	u8 srp_tm_status;
 
-	BUG_ON(!ch);
+	if (WARN_ON(!ch))
+		return;
 
+	sdev = ch->sport->sdev;
 	state = ioctx->state;
 	switch (state) {
 	case SRPT_STATE_NEW:
-- 
2.20.1
