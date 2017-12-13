From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:27 +0000
Subject: [PATCH 09/11] target: Simplify transport_generic_free_cmd() (2/2)
Message-Id: <20171213235029.581-10-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since target_wait_free_cmd() skips TMFs with no associated LUN,
it is safe to call that function for such commands. Use this to
simplify transport_generic_free_cmd(). The only functional change
in this patch is that CMD_T_FABRIC_STOP gets set for TMFs with no
associated LUN by transport_generic_free_cmd().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6beab4b89414..7bf2248e9664 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2634,12 +2634,10 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 	int ret = 0;
 	bool aborted = false, tas = false;
 
-	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
-		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-			target_wait_free_cmd(cmd, &aborted, &tas);
-	} else {
-		if (wait_for_tasks)
-			target_wait_free_cmd(cmd, &aborted, &tas);
+	if (wait_for_tasks)
+		target_wait_free_cmd(cmd, &aborted, &tas);
+
+	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD) {
 		/*
 		 * Handle WRITE failure case where transport_generic_new_cmd()
 		 * has already added se_cmd to state_list, but fabric has
-- 
2.15.1

