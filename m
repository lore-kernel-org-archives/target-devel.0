From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:50 +0000
Subject: [PATCH 13/17] target/core: Avoid that LUN reset sporadically triggers data corruption
Message-Id: <20180917213554.987-14-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-1-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

If on an initiator system a LUN reset is issued while I/O is in
progress with queue depth > 1, avoid that data corruption occurs
as follows:
- The initiator submits a READ (a).
- The initiator submits a LUN reset before READ (a) completes.
- The target responds that the LUN reset succeeded after READ (a)
  has been marked as CMD_T_COMPLETE and before .queue_status() has
  been called.
- The initiator receives the LUN reset response and frees the
  tag used by READ (a).
- The initiator submits READ (b) and reuses the tag of READ (a).
- The initiator receives the response for READ (a) and interprets
  this as a completion for READ (b).
- The initiator receives the completion for READ (b) and discards
  it.

With the SRP initiator and target drivers and when running fio
concurrently with sg_reset -d it only takes a few minutes to
reproduce this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Fixes: commit febe562c20df ("target: Fix LUN_RESET active I/O handling for ACK_KREF")
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/target/target_core_tmr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2750a2c7b563..6e419396c1e4 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -90,7 +90,7 @@ static int target_check_cdb_and_preempt(struct list_head *list,
 	return 1;
 }
 
-static bool __target_check_io_state(struct se_cmd *se_cmd,
+static bool __target_check_io_state(struct se_cmd *se_cmd, u32 skip_flags,
 				    struct se_session *tmr_sess, int tas)
 {
 	struct se_session *sess = se_cmd->se_sess;
@@ -108,7 +108,7 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 	 * long as se_cmd->cmd_kref is still active unless zero.
 	 */
 	spin_lock(&se_cmd->t_state_lock);
-	if (se_cmd->transport_state & (CMD_T_COMPLETE | CMD_T_FABRIC_STOP)) {
+	if (se_cmd->transport_state & (skip_flags | CMD_T_FABRIC_STOP)) {
 		pr_debug("Attempted to abort io tag: %llu already complete or"
 			" fabric stop, skipping\n", se_cmd->tag);
 		spin_unlock(&se_cmd->t_state_lock);
@@ -165,7 +165,8 @@ void core_tmr_abort_task(
 		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
 			se_cmd->se_tfo->get_fabric_name(), ref_tag);
 
-		if (!__target_check_io_state(se_cmd, se_sess, 0))
+		if (!__target_check_io_state(se_cmd, CMD_T_COMPLETE, se_sess,
+					     0))
 			continue;
 
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
@@ -349,7 +350,7 @@ static void core_tmr_drain_state_list(
 			continue;
 
 		spin_lock(&sess->sess_cmd_lock);
-		rc = __target_check_io_state(cmd, tmr_sess, tas);
+		rc = __target_check_io_state(cmd, 0, tmr_sess, tas);
 		spin_unlock(&sess->sess_cmd_lock);
 		if (!rc)
 			continue;
-- 
2.18.0
