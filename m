From: Mike Christie <mchristi@redhat.com>
Date: Wed, 06 Dec 2017 07:08:17 +0000
Subject: [RFC PATCH 1/3] target: add SAM_STAT_BUSY sense reason
Message-Id: <1512544099-7520-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Add SAM_STAT_BUSY sense_reason. The next patch will have
target_core_user return this value while it is temporarily
blocked and restarting.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 3 +++
 include/target/target_core_base.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 58caacd..74b646f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1774,6 +1774,9 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_OUT_OF_RESOURCES:
 		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
 		goto queue_status;
+	case TCM_LUN_BUSY:
+		cmd->scsi_status = SAM_STAT_BUSY;
+		goto queue_status;
 	case TCM_RESERVATION_CONFLICT:
 		/*
 		 * No SENSE Data payload for this case, set SCSI Status
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2c8d811..00482f9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -183,6 +183,7 @@ enum tcm_sense_reason_table {
 	TCM_TOO_MANY_SEGMENT_DESCS		= R(0x1b),
 	TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE	= R(0x1c),
 	TCM_INSUFFICIENT_REGISTRATION_RESOURCES	= R(0x1d),
+	TCM_LUN_BUSY				= R(0x1e),
 #undef R
 };
 
-- 
2.7.2

