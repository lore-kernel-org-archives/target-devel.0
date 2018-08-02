From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:21 +0000
Subject: [PATCH 2/8] iscsi target: have iscsit_start_nopin_timer call __iscsit_start_nopin_timer
Message-Id: <1533229947-6277-3-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Just have iscsit_start_nopin_timer grab the lock and call
__iscsit_start_nopin_timer.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/iscsi/iscsi_target_util.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 8cfcf90..49be1e4 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1053,26 +1053,8 @@ void __iscsit_start_nopin_timer(struct iscsi_conn *conn)
 
 void iscsit_start_nopin_timer(struct iscsi_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
-	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
-	/*
-	 * NOPIN timeout is disabled..
-	 */
-	if (!na->nopin_timeout)
-		return;
-
 	spin_lock_bh(&conn->nopin_timer_lock);
-	if (conn->nopin_timer_flags & ISCSI_TF_RUNNING) {
-		spin_unlock_bh(&conn->nopin_timer_lock);
-		return;
-	}
-
-	conn->nopin_timer_flags &= ~ISCSI_TF_STOP;
-	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
-	mod_timer(&conn->nopin_timer, jiffies + na->nopin_timeout * HZ);
-
-	pr_debug("Started NOPIN Timer on CID: %d at %u second"
-			" interval\n", conn->cid, na->nopin_timeout);
+	__iscsit_start_nopin_timer(conn);
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-- 
2.7.2

