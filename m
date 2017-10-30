From: Mike Christie <mchristi@redhat.com>
Date: Mon, 30 Oct 2017 03:44:39 +0000
Subject: [PATCH 19/19] target: return SAM_STAT_TASK_SET_FULL for TCM_OUT_OF_RESOURCES
Message-Id: <1509335079-5276-20-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

TCM_OUT_OF_RESOURCES is getting translated to
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE which seems like a heavy
error when we just cannot allocate a resource that may be
allocatable later. This has us translate TCM_OUT_OF_RESOURCES
to SAM_STAT_TASK_SET_FULL instead.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 836d552..a3b264b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1772,8 +1772,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
 		break;
 	case TCM_OUT_OF_RESOURCES:
-		sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		break;
+		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
+		goto queue_status;
 	case TCM_RESERVATION_CONFLICT:
 		/*
 		 * No SENSE Data payload for this case, set SCSI Status
@@ -1795,11 +1795,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 					       cmd->orig_fe_lun, 0x2C,
 					ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 		}
-		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto queue_full;
-		goto check_stop;
+
+		goto queue_status;
 	default:
 		pr_err("Unknown transport error for CDB 0x%02x: %d\n",
 			cmd->t_task_cdb[0], sense_reason);
@@ -1816,6 +1813,11 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
+queue_status:
+	trace_target_cmd_complete(cmd);
+	ret = cmd->se_tfo->queue_status(cmd);
+	if (!ret)
+		goto check_stop;
 queue_full:
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
-- 
1.8.3.1

