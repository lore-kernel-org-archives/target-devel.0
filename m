From: Varun Prakash <varun@chelsio.com>
Date: Wed, 01 Jul 2020 16:58:10 +0000
Subject: [PATCH] scsi: target: cxgbit: check connection state before issuing hardware command
Message-Id: <1593621970-3026-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Current code does not check connection state before issuing
header/data digest offload and DDP page size setup hardware
command.

Add a connection state check to issue hardware command only
if connection is in established state.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index a2b5c79..493070c 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1485,6 +1485,26 @@ u32 cxgbit_send_tx_flowc_wr(struct cxgbit_sock *csk)
 	return flowclen16;
 }
 
+static int
+cxgbit_send_tcb_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
+{
+	spin_lock_bh(&csk->lock);
+	if (unlikely(csk->com.state != CSK_STATE_ESTABLISHED)) {
+		spin_unlock_bh(&csk->lock);
+		pr_err("%s: csk 0x%p, tid %u, state %u\n",
+		       __func__, csk, csk->tid, csk->com.state);
+		__kfree_skb(skb);
+		return -1;
+	}
+
+	cxgbit_get_csk(csk);
+	cxgbit_init_wr_wait(&csk->com.wr_wait);
+	cxgbit_ofld_send(csk->com.cdev, skb);
+	spin_unlock_bh(&csk->lock);
+
+	return 0;
+}
+
 int cxgbit_setup_conn_digest(struct cxgbit_sock *csk)
 {
 	struct sk_buff *skb;
@@ -1510,10 +1530,8 @@ int cxgbit_setup_conn_digest(struct cxgbit_sock *csk)
 				(dcrc ? ULP_CRC_DATA : 0)) << 4);
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->ctrlq_idx);
 
-	cxgbit_get_csk(csk);
-	cxgbit_init_wr_wait(&csk->com.wr_wait);
-
-	cxgbit_ofld_send(csk->com.cdev, skb);
+	if (cxgbit_send_tcb_skb(csk, skb))
+		return -1;
 
 	ret = cxgbit_wait_for_reply(csk->com.cdev,
 				    &csk->com.wr_wait,
@@ -1545,10 +1563,8 @@ int cxgbit_setup_conn_pgidx(struct cxgbit_sock *csk, u32 pg_idx)
 	req->val = cpu_to_be64(pg_idx << 8);
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, csk->ctrlq_idx);
 
-	cxgbit_get_csk(csk);
-	cxgbit_init_wr_wait(&csk->com.wr_wait);
-
-	cxgbit_ofld_send(csk->com.cdev, skb);
+	if (cxgbit_send_tcb_skb(csk, skb))
+		return -1;
 
 	ret = cxgbit_wait_for_reply(csk->com.cdev,
 				    &csk->com.wr_wait,
-- 
2.0.2
