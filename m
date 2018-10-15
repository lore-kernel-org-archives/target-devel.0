From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Oct 2018 15:51:36 +0000
Subject: [PATCH 3/6] target/core: Remove the SCF_COMPARE_AND_WRITE_POST flag
Message-Id: <20181015155139.143446-4-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Commit 057085e522f8 ("target: Fix race for SCF_COMPARE_AND_WRITE_POST
checking") removed the code that checks the SCF_COMPARE_AND_WRITE_POST flag.
Hence also remove the flag itself.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_sbc.c  | 6 ------
 include/target/target_core_base.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ebac2b49b9c6..f2c3b67dbb36 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -425,14 +425,8 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret = TCM_NO_SENSE;
 
-	/*
-	 * Only set SCF_COMPARE_AND_WRITE_POST to force a response fall-through
-	 * within target_complete_ok_work() if the command was successfully
-	 * sent to the backend driver.
-	 */
 	spin_lock_irq(&cmd->t_state_lock);
 	if (cmd->transport_state & CMD_T_SENT) {
-		cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
 		*post_ret = 1;
 
 		if (cmd->scsi_status = SAM_STAT_CHECK_CONDITION)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7a4ee7852ca4..e3bdb0550a59 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -138,7 +138,6 @@ enum se_cmd_flags_table {
 	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
-	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
 	SCF_ACK_KREF			= 0x00400000,
 	SCF_USE_CPUID			= 0x00800000,
-- 
2.19.0.605.g01d371f741-goog
