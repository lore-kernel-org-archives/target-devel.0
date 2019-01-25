From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:52 +0000
Subject: [PATCH 10/16] target/iscsi: Remove an incorrect comment
Message-Id: <20190125183458.220477-11-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The single iscsit_start_nopin_response_timer() caller does not hold
any locks. Hence remove the comment above this function.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 86987da86dd6..762448e2f8b7 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -956,9 +956,6 @@ void iscsit_mod_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-/*
- *	Called with conn->nopin_timer_lock held.
- */
 void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
-- 
2.20.1.495.gaa96b0ce6b-goog
