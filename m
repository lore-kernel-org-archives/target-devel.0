From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:09 +0000
Subject: [PATCH 05/11] target/core: Simplify LUN initialization in XCOPY implementation
Message-Id: <20190402195815.254796-6-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Other than removing a few pr_debug() statements, this patch does not
change any functionality.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_xcopy.c | 43 +++---------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d97be766e4ac..39f4490a3ebe 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -513,53 +513,16 @@ static void target_xcopy_setup_pt_port(
 	struct se_cmd *ec_cmd = xop->xop_se_cmd;
 	struct se_cmd *pt_cmd = &xpt_cmd->se_cmd;
 
-	if (xop->op_origin = XCOL_SOURCE_RECV_OP) {
-		/*
-		 * Honor destination port reservations for X-COPY PUSH emulation
-		 * when CDB is received on local source port, and READs blocks to
-		 * WRITE on remote destination port.
-		 */
-		if (!remote_port) {
-			pt_cmd->se_lun = ec_cmd->se_lun;
-			pt_cmd->se_dev = ec_cmd->se_dev;
-
-			pr_debug("Honoring local SRC port from ec_cmd->se_dev:"
-				" %p\n", pt_cmd->se_dev);
-			pt_cmd->se_lun = ec_cmd->se_lun;
-			pr_debug("Honoring local SRC port from ec_cmd->se_lun: %p\n",
-				pt_cmd->se_lun);
-		}
-	} else {
-		/*
-		 * Honor source port reservation for X-COPY PULL emulation
-		 * when CDB is received on local desintation port, and READs
-		 * blocks from the remote source port to WRITE on local
-		 * destination port.
-		 */
-		if (!remote_port) {
-			pt_cmd->se_lun = ec_cmd->se_lun;
-			pt_cmd->se_dev = ec_cmd->se_dev;
-
-			pr_debug("Honoring local DST port from ec_cmd->se_dev:"
-				" %p\n", pt_cmd->se_dev);
-			pt_cmd->se_lun = ec_cmd->se_lun;
-			pr_debug("Honoring local DST port from ec_cmd->se_lun: %p\n",
-				pt_cmd->se_lun);
-		}
+	if (!remote_port) {
+		pt_cmd->se_lun = ec_cmd->se_lun;
+		pt_cmd->se_dev = ec_cmd->se_dev;
 	}
 }
 
 static void target_xcopy_init_pt_lun(struct se_device *se_dev,
 		struct se_cmd *pt_cmd, bool remote_port)
 {
-	/*
-	 * Don't allocate + init an pt_cmd->se_lun if honoring local port for
-	 * reservations.  The pt_cmd->se_lun pointer will be setup from within
-	 * target_xcopy_setup_pt_port()
-	 */
 	if (remote_port) {
-		pr_debug("Setup emulated se_dev: %p from se_dev\n",
-			pt_cmd->se_dev);
 		pt_cmd->se_lun = &se_dev->xcopy_lun;
 		pt_cmd->se_dev = se_dev;
 	}
-- 
2.21.0.196.g041f5ea1cf98
