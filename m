From: Varun Prakash <varun@chelsio.com>
Date: Wed, 01 Jul 2020 16:59:12 +0000
Subject: [PATCH] scsi: target: cxgbit: remove tx flow control code
Message-Id: <1593622032-3082-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Firmware does tx flow control so remove tx flow
control code from the driver.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit.h        |  1 -
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     |  2 --
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 24 ++++--------------------
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit.h b/drivers/target/iscsi/cxgbit/cxgbit.h
index c04cd08..4069033 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit.h
+++ b/drivers/target/iscsi/cxgbit/cxgbit.h
@@ -207,7 +207,6 @@ struct cxgbit_sock {
 	/* socket lock */
 	spinlock_t lock;
 	wait_queue_head_t waitq;
-	wait_queue_head_t ack_waitq;
 	bool lock_owner;
 	struct kref kref;
 	u32 max_iso_npdu;
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 493070c..518ded2 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1360,7 +1360,6 @@ cxgbit_pass_accept_req(struct cxgbit_device *cdev, struct sk_buff *skb)
 	cxgbit_sock_reset_wr_list(csk);
 	spin_lock_init(&csk->lock);
 	init_waitqueue_head(&csk->waitq);
-	init_waitqueue_head(&csk->ack_waitq);
 	csk->lock_owner = false;
 
 	if (cxgbit_alloc_csk_skb(csk)) {
@@ -1887,7 +1886,6 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 		if (csk->snd_una != snd_una) {
 			csk->snd_una = snd_una;
 			dst_confirm(csk->dst);
-			wake_up(&csk->ack_waitq);
 		}
 	}
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index fcdc421..9b3eb2e 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -284,18 +284,6 @@ void cxgbit_push_tx_frames(struct cxgbit_sock *csk)
 	}
 }
 
-static bool cxgbit_lock_sock(struct cxgbit_sock *csk)
-{
-	spin_lock_bh(&csk->lock);
-
-	if (before(csk->write_seq, csk->snd_una + csk->snd_win))
-		csk->lock_owner = true;
-
-	spin_unlock_bh(&csk->lock);
-
-	return csk->lock_owner;
-}
-
 static void cxgbit_unlock_sock(struct cxgbit_sock *csk)
 {
 	struct sk_buff_head backlogq;
@@ -325,20 +313,16 @@ static int cxgbit_queue_skb(struct cxgbit_sock *csk, struct sk_buff *skb)
 {
 	int ret = 0;
 
-	wait_event_interruptible(csk->ack_waitq, cxgbit_lock_sock(csk));
+	spin_lock_bh(&csk->lock);
+	csk->lock_owner = true;
+	spin_unlock_bh(&csk->lock);
 
 	if (unlikely((csk->com.state != CSK_STATE_ESTABLISHED) ||
 		     signal_pending(current))) {
 		__kfree_skb(skb);
 		__skb_queue_purge(&csk->ppodq);
 		ret = -1;
-		spin_lock_bh(&csk->lock);
-		if (csk->lock_owner) {
-			spin_unlock_bh(&csk->lock);
-			goto unlock;
-		}
-		spin_unlock_bh(&csk->lock);
-		return ret;
+		goto unlock;
 	}
 
 	csk->write_seq += skb->len +
-- 
2.0.2
