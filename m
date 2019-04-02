From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:10 +0000
Subject: [PATCH 06/11] target/core: Make the XCOPY setup code easier to read by inlining two functions
Message-Id: <20190402195815.254796-7-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The target_xcopy_setup_pt_port() and target_xcopy_init_pt_lun() functions
obfuscate what is really going on. Hence inline these two functions. This
patch does not change any functionality.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_xcopy.c | 50 ++++++++++++++----------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 39f4490a3ebe..e59a896ac58a 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -505,31 +505,20 @@ void target_xcopy_release_pt(void)
 		destroy_workqueue(xcopy_wq);
 }
 
-static void target_xcopy_setup_pt_port(
-	struct xcopy_pt_cmd *xpt_cmd,
-	struct xcopy_op *xop,
-	bool remote_port)
-{
-	struct se_cmd *ec_cmd = xop->xop_se_cmd;
-	struct se_cmd *pt_cmd = &xpt_cmd->se_cmd;
-
-	if (!remote_port) {
-		pt_cmd->se_lun = ec_cmd->se_lun;
-		pt_cmd->se_dev = ec_cmd->se_dev;
-	}
-}
-
-static void target_xcopy_init_pt_lun(struct se_device *se_dev,
-		struct se_cmd *pt_cmd, bool remote_port)
-{
-	if (remote_port) {
-		pt_cmd->se_lun = &se_dev->xcopy_lun;
-		pt_cmd->se_dev = se_dev;
-	}
-
-	pt_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
-}
-
+/*
+ * target_xcopy_setup_pt_cmd - set up a pass-through command
+ * @xpt_cmd:	 Data structure to initialize.
+ * @xop:	 Describes the XCOPY operation received from an initiator.
+ * @se_dev:	 Backend device to associate with @xpt_cmd if
+ *		 @remote_port = true.
+ * @cdb:	 SCSI CDB to be copied into @xpt_cmd.
+ * @remote_port: If false, use the LUN through which the XCOPY command has
+ *		 been received. If true, use @se_dev->xcopy_lun.
+ * @alloc_mem:	 Whether or not to allocate an SGL list.
+ *
+ * Set up a SCSI command (READ or WRITE) that will be used to execute an
+ * XCOPY command.
+ */
 static int target_xcopy_setup_pt_cmd(
 	struct xcopy_pt_cmd *xpt_cmd,
 	struct xcopy_op *xop,
@@ -541,12 +530,19 @@ static int target_xcopy_setup_pt_cmd(
 	struct se_cmd *cmd = &xpt_cmd->se_cmd;
 	sense_reason_t sense_rc;
 	int ret = 0, rc;
+
 	/*
 	 * Setup LUN+port to honor reservations based upon xop->op_origin for
 	 * X-COPY PUSH or X-COPY PULL based upon where the CDB was received.
 	 */
-	target_xcopy_init_pt_lun(se_dev, cmd, remote_port);
-	target_xcopy_setup_pt_port(xpt_cmd, xop, remote_port);
+	if (remote_port) {
+		cmd->se_lun = &se_dev->xcopy_lun;
+		cmd->se_dev = se_dev;
+	} else {
+		cmd->se_lun = xop->xop_se_cmd->se_lun;
+		cmd->se_dev = xop->xop_se_cmd->se_dev;
+	}
+	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
 	cmd->tag = 0;
 	sense_rc = target_setup_cmd_from_cdb(cmd, cdb);
-- 
2.21.0.196.g041f5ea1cf98
