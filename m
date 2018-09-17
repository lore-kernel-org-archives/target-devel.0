From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:54 +0000
Subject: [PATCH 17/17] target/core: Simplify the LUN RESET implementation
Message-Id: <20180917213554.987-18-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Due to the task management handling rework it is safe to wait for
a TMF that is not in the active state. Hence remove the CMD_T_ACTIVE
test from core_tmr_drain_tmr_list(). Additionally, call
__target_check_io_state() instead of open coding it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_tmr.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7b22a62e4193..909dc9847110 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -217,23 +217,13 @@ static void core_tmr_drain_tmr_list(
 			continue;
 
 		spin_lock(&sess->sess_cmd_lock);
-		spin_lock(&cmd->t_state_lock);
-		if (!(cmd->transport_state & CMD_T_ACTIVE) ||
-		     (cmd->transport_state & CMD_T_FABRIC_STOP)) {
-			spin_unlock(&cmd->t_state_lock);
-			spin_unlock(&sess->sess_cmd_lock);
-			continue;
-		}
-		cmd->transport_state |= CMD_T_ABORTED;
-		spin_unlock(&cmd->t_state_lock);
+		rc = __target_check_io_state(cmd, 0, sess, 0);
+		spin_unlock(&sess->sess_cmd_lock);
 
-		rc = kref_get_unless_zero(&cmd->cmd_kref);
 		if (!rc) {
 			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
-			spin_unlock(&sess->sess_cmd_lock);
 			continue;
 		}
-		spin_unlock(&sess->sess_cmd_lock);
 
 		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
 	}
-- 
2.18.0
