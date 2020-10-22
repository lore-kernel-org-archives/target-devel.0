From: Anastasia Kovaleva <a.kovaleva@yadro.com>
Date: Thu, 22 Oct 2020 17:20:11 +0000
Subject: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <20201022172011.42367-4-a.kovaleva@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Anastasia Kovaleva <a.kovaleva@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>

According to FCP-4 (9.4.2):

  If the command requested that data beyond the length specified by the
  FCP_DL field be transferred, then the device server shall set the
  FCP_RESID_OVER bit (see 9.5.8) to one in the FCP_RSP IU and:

  a) process the command normally except that data beyond the FCP_DL
  count shall not be requested or transferred;

  b) transfer no data and return CHECK CONDITION status with the sense
  key set to ILLEGAL REQUEST and the additional sense code set to INVALID
  FIELD IN COMMAND INFORMATION UNIT; or

  c) may transfer data and return CHECK CONDITION status with the sense
  key set to ABORTED COMMAND and the additional sense code set to
  INVALID FIELD IN COMMAND INFORMATION UNIT.

TCM follows b) and transfers no data for residual writes but returns
INVALID FIELD IN CDB instead of INVALID FIELD IN COMMAND INFORMATION
UNIT.

Change the ASCQ to INVALID FIELD IN COMMAND INFORMATION UNIT to meet the
standart.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 8 +++++++-
 include/target/target_core_base.h      | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8cb3012721d8..b225dab4deb9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1331,7 +1331,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
 				pr_err_ratelimited("Rejecting underflow/overflow"
 						   " for WRITE data CDB\n");
-				return TCM_INVALID_CDB_FIELD;
+				return TCM_INVALID_FIELD_IN_COMMAND_IU;
 			}
 			/*
 			 * Some fabric drivers like iscsi-target still expect to
@@ -1904,6 +1904,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_UNSUPPORTED_TARGET_DESC_TYPE_CODE:
 	case TCM_TOO_MANY_SEGMENT_DESCS:
 	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
+	case TCM_INVALID_FIELD_IN_COMMAND_IU:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
@@ -3240,6 +3241,11 @@ static const struct sense_info sense_info_table[] = {
 		.asc = 0x55,
 		.ascq = 0x04, /* INSUFFICIENT REGISTRATION RESOURCES */
 	},
+	[TCM_INVALID_FIELD_IN_COMMAND_IU] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x0e,
+		.ascq = 0x03, /* INVALID FIELD IN COMMAND INFORMATION UNIT */
+	},
 };
 
 /**
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 549947d407cf..01296d62ba5e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -187,6 +187,7 @@ enum tcm_sense_reason_table {
 	TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE	= R(0x1c),
 	TCM_INSUFFICIENT_REGISTRATION_RESOURCES	= R(0x1d),
 	TCM_LUN_BUSY				= R(0x1e),
+	TCM_INVALID_FIELD_IN_COMMAND_IU         = R(0x1f),
 #undef R
 };
 
-- 
2.24.3 (Apple Git-128)
