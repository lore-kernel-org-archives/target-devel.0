From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:53 +0000
Subject: [PATCH 16/17] target/core: Remove several state tests from the TMF code
Message-Id: <20180917213554.987-17-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Whether or not a session is being torn down does not affect whether
or not SCSI commands are in the task set. Hence remove the "tearing
down" checks from the TMF code. The TRANSPORT_ISTATE_PROCESSING
check is left out because it is now safe to wait for a command that
is in that state. The CMD_T_PRE_EXECUTE is left out because abort
processing is postponed until after commands have left the
pre-execute state since the patch that makes TMF processing
synchronous.

See also commit 1c21a48055a6 ("target: Avoid early CMD_T_PRE_EXECUTE
failures during ABORT_TASK").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_tmr.c       | 25 -------------------------
 drivers/target/target_core_transport.c |  2 --
 include/target/target_core_base.h      |  1 -
 3 files changed, 28 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 6e419396c1e4..7b22a62e4193 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -114,21 +114,6 @@ static bool __target_check_io_state(struct se_cmd *se_cmd, u32 skip_flags,
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
-	if (se_cmd->transport_state & CMD_T_PRE_EXECUTE) {
-		if (se_cmd->scsi_status) {
-			pr_debug("Attempted to abort io tag: %llu early failure"
-				 " status: 0x%02x\n", se_cmd->tag,
-				 se_cmd->scsi_status);
-			spin_unlock(&se_cmd->t_state_lock);
-			return false;
-		}
-	}
-	if (sess->sess_tearing_down) {
-		pr_debug("Attempted to abort io tag: %llu already shutdown,"
-			" skipping\n", se_cmd->tag);
-		spin_unlock(&se_cmd->t_state_lock);
-		return false;
-	}
 	se_cmd->transport_state |= CMD_T_ABORTED;
 
 	if ((tmr_sess != se_cmd->se_sess) && tas)
@@ -239,16 +224,6 @@ static void core_tmr_drain_tmr_list(
 			spin_unlock(&sess->sess_cmd_lock);
 			continue;
 		}
-		if (cmd->t_state = TRANSPORT_ISTATE_PROCESSING) {
-			spin_unlock(&cmd->t_state_lock);
-			spin_unlock(&sess->sess_cmd_lock);
-			continue;
-		}
-		if (sess->sess_tearing_down) {
-			spin_unlock(&cmd->t_state_lock);
-			spin_unlock(&sess->sess_cmd_lock);
-			continue;
-		}
 		cmd->transport_state |= CMD_T_ABORTED;
 		spin_unlock(&cmd->t_state_lock);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e76dace0ddb4..446cb458242f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2060,7 +2060,6 @@ void target_execute_cmd(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
-	cmd->transport_state &= ~CMD_T_PRE_EXECUTE;
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
@@ -2799,7 +2798,6 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
-	se_cmd->transport_state |= CMD_T_PRE_EXECUTE;
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
 	percpu_ref_get(&se_sess->cmd_count);
 out:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 833567125905..afac85fd00e7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -492,7 +492,6 @@ struct se_cmd {
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
-#define CMD_T_PRE_EXECUTE	(1 << 12)
 	spinlock_t		t_state_lock;
 	struct kref		cmd_kref;
 	struct completion	t_transport_stop_comp;
-- 
2.18.0
