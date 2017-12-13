From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:24 +0000
Subject: [PATCH 06/11] target: Simplify core_tmr_handle_tas_abort()
Message-Id: <20171213235029.581-7-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The code that can set CMD_T_TAS is executed by the same thread as
the thread that executes core_tmr_handle_tas_abort(). That means
that no locking is needed to check CMD_T_TAS from inside
core_tmr_handle_tas_abort(). This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_tmr.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index da8125dd3a4c..08af053e7990 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -77,21 +77,12 @@ void core_tmr_release_req(struct se_tmr_req *tmr)
 
 static int core_tmr_handle_tas_abort(struct se_cmd *cmd, int tas)
 {
-	unsigned long flags;
-	bool remove = true, send_tas;
-	/*
-	 * TASK ABORTED status (TAS) bit support
-	 */
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	send_tas = (cmd->transport_state & CMD_T_TAS);
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	bool send_tas = cmd->transport_state & CMD_T_TAS;
 
-	if (send_tas) {
-		remove = false;
+	if (send_tas)
 		transport_send_task_abort(cmd);
-	}
 
-	return transport_cmd_finish_abort(cmd, remove);
+	return transport_cmd_finish_abort(cmd, !send_tas);
 }
 
 static int target_check_cdb_and_preempt(struct list_head *list,
-- 
2.15.1

