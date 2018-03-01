From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:26 +0000
Subject: [PATCH 08/14] target: Simplify transport_generic_free_cmd() (1/2)
Message-Id: <20180301222632.31507-9-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Move identical code outside an if/else statement. This patch does
not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7eb55e6b5831..92682400995e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2602,9 +2602,6 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
 		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 			target_wait_free_cmd(cmd, &aborted, &tas);
-
-		if (!aborted || tas)
-			ret = target_put_sess_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
 			target_wait_free_cmd(cmd, &aborted, &tas);
@@ -2618,10 +2615,9 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
-
-		if (!aborted || tas)
-			ret = target_put_sess_cmd(cmd);
 	}
+	if (!aborted || tas)
+		ret = target_put_sess_cmd(cmd);
 	if (aborted) {
 		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		wait_for_completion(&cmd->cmd_wait_comp);
-- 
2.16.2

