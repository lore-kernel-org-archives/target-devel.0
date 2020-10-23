From: David Disseldorp <ddiss@suse.de>
Date: Fri, 23 Oct 2020 20:57:20 +0000
Subject: [PATCH 2/5] scsi: target: rename struct sense_info to sense_detail
Message-Id: <20201023205723.17880-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201023205723.17880-1-ddiss@suse.de>
In-Reply-To: <20201023205723.17880-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, David Disseldorp <ddiss@suse.de>

This helps distinguish it from the SCSI sense INFORMATION field.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_transport.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0a5f60..caa3a7b34826 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3094,14 +3094,14 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-struct sense_info {
+struct sense_detail {
 	u8 key;
 	u8 asc;
 	u8 ascq;
 	bool add_sector_info;
 };
 
-static const struct sense_info sense_info_table[] = {
+static const struct sense_detail sense_detail_table[] = {
 	[TCM_NO_SENSE] = {
 		.key = NOT_READY
 	},
@@ -3261,39 +3261,39 @@ static const struct sense_info sense_info_table[] = {
  */
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
-	const struct sense_info *si;
+	const struct sense_detail *sd;
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
 	u8 key, asc, ascq;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
-	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
-		si = &sense_info_table[r];
+	if (r < ARRAY_SIZE(sense_detail_table) && sense_detail_table[r].key)
+		sd = &sense_detail_table[r];
 	else
-		si = &sense_info_table[(__force int)
+		sd = &sense_detail_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	key = si->key;
+	key = sd->key;
 	if (reason = TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
 						       &ascq)) {
 			cmd->scsi_status = SAM_STAT_BUSY;
 			return;
 		}
-	} else if (si->asc = 0) {
+	} else if (sd->asc = 0) {
 		WARN_ON_ONCE(cmd->scsi_asc = 0);
 		asc = cmd->scsi_asc;
 		ascq = cmd->scsi_ascq;
 	} else {
-		asc = si->asc;
-		ascq = si->ascq;
+		asc = sd->asc;
+		ascq = sd->ascq;
 	}
 
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
-	if (si->add_sector_info)
+	if (sd->add_sector_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
 							cmd->bad_sector) < 0);
-- 
2.26.2
