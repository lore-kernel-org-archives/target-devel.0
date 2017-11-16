From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:18 +0000
Subject: [PATCH-4.1.y 6/7] Revert "target: Fix VERIFY and WRITE VERIFY command parsing"
Message-Id: <1510812859-15101-7-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 984a9d4c40bed351a92ed31f0723a710444295da upstream.

This reverts commit 0e2eb7d12eaa8e391bf5615d4271bb87a649caaa

  Author: Bart Van Assche <bart.vanassche@sandisk.com>
  Date:   Thu Mar 30 10:12:39 2017 -0700

      target: Fix VERIFY and WRITE VERIFY command parsing

This patch broke existing behaviour for WRITE_VERIFY because
it dropped the original SCF_SCSI_DATA_CDB assignment for
bytchk = 0 so target_cmd_size_check() no longer rejected
this case, allowing an overflow case to trigger an OOPs
in iscsi-target.

Since the short term and long term fixes are still being
discussed, revert it for now since it's late in the merge
window and try again in v4.13-rc1.

	drivers/target/target_core_sbc.c

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 71 +++++-----------------------------------
 1 file changed, 9 insertions(+), 62 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 8bf7a06..5de51c5 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -768,59 +768,6 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	return 0;
 }
 
-/**
- * sbc_parse_verify - parse VERIFY, VERIFY_16 and WRITE VERIFY commands
- * @cmd:     (in)  structure that describes the SCSI command to be parsed.
- * @sectors: (out) Number of logical blocks on the storage medium that will be
- *           affected by the SCSI command.
- * @bufflen: (out) Expected length of the SCSI Data-Out buffer.
- */
-static sense_reason_t sbc_parse_verify(struct se_cmd *cmd, int *sectors,
-				       u32 *bufflen)
-{
-	struct se_device *dev = cmd->se_dev;
-	u8 *cdb = cmd->t_task_cdb;
-	u8 bytchk = (cdb[1] >> 1) & 3;
-	sense_reason_t ret;
-
-	switch (cdb[0]) {
-	case VERIFY:
-	case WRITE_VERIFY:
-		*sectors = transport_get_sectors_10(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
-		break;
-	case VERIFY_16:
-		*sectors = transport_get_sectors_16(cdb);
-		cmd->t_task_lba = transport_lba_64(cdb);
-		break;
-	default:
-		WARN_ON_ONCE(true);
-		return TCM_UNSUPPORTED_SCSI_OPCODE;
-	}
-
-	if (sbc_check_dpofua(dev, cmd, cdb))
-		return TCM_INVALID_CDB_FIELD;
-
-	ret = sbc_check_prot(dev, cmd, cdb, *sectors, true);
-	if (ret)
-		return ret;
-
-	switch (bytchk) {
-	case 0:
-		*bufflen = 0;
-		break;
-	case 1:
-		*bufflen = sbc_get_size(cmd, *sectors);
-		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		break;
-	default:
-		pr_err("Unsupported BYTCHK value %d for SCSI opcode %#x\n",
-		       bytchk, cdb[0]);
-		return TCM_INVALID_CDB_FIELD;
-	}
-	return TCM_NO_SENSE;
-}
-
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -891,6 +838,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_10:
+	case WRITE_VERIFY:
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
@@ -905,12 +853,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
-	case WRITE_VERIFY:
-		ret = sbc_parse_verify(cmd, &sectors, &size);
-		if (ret)
-			return ret;
-		cmd->execute_cmd = sbc_execute_rw;
-		goto check_lba;
 	case WRITE_12:
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
@@ -1110,9 +1052,14 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case VERIFY:
 	case VERIFY_16:
-		ret = sbc_parse_verify(cmd, &sectors, &size);
-		if (ret)
-			return ret;
+		size = 0;
+		if (cdb[0] = VERIFY) {
+			sectors = transport_get_sectors_10(cdb);
+			cmd->t_task_lba = transport_lba_32(cdb);
+		} else {
+			sectors = transport_get_sectors_16(cdb);
+			cmd->t_task_lba = transport_lba_64(cdb);
+		}
 		cmd->execute_cmd = sbc_emulate_noop;
 		goto check_lba;
 	case REZERO_UNIT:
-- 
1.8.5.3

