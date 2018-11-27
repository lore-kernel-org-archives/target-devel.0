From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 23:52:04 +0000
Subject: [PATCH v2 10/10] target/core: Reduce the amount of code executed with a spinlock held
Message-Id: <20181127235204.186731-11-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Due to the "make ABORT and LUN RESET handling synchronous" patch,
cmd->work is only modified from the regular command execution path
and no longer asynchronously by the code that executes task management
functions. Since the regular command execution code is sequential per
command, no locking is required to manipulate cmd->work. Hence stop
protecting cmd->work manipulations with locking.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8ae787044eef..9e0bbb135e7b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -853,16 +853,12 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		break;
 	}
 
-	if (!success) {
-		INIT_WORK(&cmd->work, target_complete_failure_work);
-	} else {
-		INIT_WORK(&cmd->work, target_complete_ok_work);
-	}
-
 	cmd->t_state = TRANSPORT_COMPLETE;
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
+	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
+		  target_complete_failure_work);
 	if (cmd->se_cmd_flags & SCF_USE_CPUID)
 		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 	else
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
