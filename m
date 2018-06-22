From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:57 +0000
Subject: [PATCH 10/20] target: Simplify transport_generic_free_cmd() (1/2)
Message-Id: <20180622215307.8758-11-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Move identical code outside an if/else statement. This patch does
not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3f95ddea6b1c..65995532d02b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2664,9 +2664,6 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
 		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 			target_wait_free_cmd(cmd, &aborted, &tas);
-
-		if (!aborted || tas)
-			ret = target_put_sess_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
 			target_wait_free_cmd(cmd, &aborted, &tas);
@@ -2680,10 +2677,9 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 
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
2.17.1

