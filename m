From: Lee Duncan <lduncan@suse.com>
Date: Wed, 16 May 2018 01:25:24 +0000
Subject: [PATCH v4] target: transport should handle st FM/EOM/ILI reads
Message-Id: <20180516012524.5541-1-lduncan@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When a tape drive is exported via LIO using the pscsi module, a read that
requests more bytes per block than the tape can supply returns an empty
buffer. This is because the pscsi pass-through target module sees the
"ILI" illegal length bit set and thinks there is no reason to return
the data.

This is a long-standing transport issue, since it assumes that no data
need be returned under a check condition, which isn't always the case
for tape.

Add in a check for tape reads with the ILI, EOM, or FM bits set,
with a sense code of NO_SENSE, treating such cases as if the read
succeeded. The layered tape driver then "does the right thing" when
it gets such a response.

Changes from v3:
 - cleaned up comment
 - Added residual handling

Changes from v2:
 - Cleaned up subject line and bug text formatting
 - Removed unneeded inner braces
 - Removed ugly goto
 - Also updated the "queue full" path to handle this case

Changes from RFC:
 - Moved ugly code from transport to pscsi module
 - Added checking EOM and FM bits, as well as ILI
 - fixed malformed patch
 - Clarified description a bit

Signed-off-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>)
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_pscsi.c     | 26 ++++++++++++++++++--
 drivers/target/target_core_transport.c | 43 +++++++++++++++++++++++++++++-----
 include/target/target_core_base.h      |  1 +
 3 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0d99b242e82e..f31215b1d009 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -689,8 +689,29 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 	}
 after_mode_select:
 
-	if (scsi_status = SAM_STAT_CHECK_CONDITION)
+	if (scsi_status = SAM_STAT_CHECK_CONDITION) {
 		transport_copy_sense_to_cmd(cmd, req_sense);
+
+		/*
+		 * check for TAPE device reads with
+		 * FM/EOM/ILI set, so that we can get data
+		 * back despite framework assumption that a
+		 * check condition means there is no data
+		 */
+		if (sd->type = TYPE_TAPE &&
+		    cmd->data_direction = DMA_FROM_DEVICE) {
+			/*
+			 * is sense data valid, fixed format,
+			 * and have FM, EOM, or ILI set?
+			 */
+			if (req_sense[0] = 0xf0 &&	/* valid, fixed format */
+			    req_sense[2] & 0xe0 &&	/* FM, EOM, or ILI */
+			    (req_sense[2] & 0xf) = 0) { /* key=NO_SENSE */
+				pr_debug("Tape FM/EOM/ILI status detected. Treat as normal read.\n");
+				cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
+			}
+		}
+	}
 }
 
 enum {
@@ -1061,7 +1082,8 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 
 	switch (host_byte(result)) {
 	case DID_OK:
-		target_complete_cmd(cmd, scsi_status);
+		target_complete_cmd_with_length(cmd, scsi_status,
+			cmd->data_length - scsi_req(req)->resid_len);
 		break;
 	default:
 		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 74b646f165d4..791ff9ba2bc6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -779,7 +779,9 @@ EXPORT_SYMBOL(target_complete_cmd);
 
 void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
 {
-	if (scsi_status = SAM_STAT_GOOD && length < cmd->data_length) {
+	if ((scsi_status = SAM_STAT_GOOD ||
+	     cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
+	    length < cmd->data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			cmd->residual_count += cmd->data_length - length;
 		} else {
@@ -2084,12 +2086,24 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		goto queue_status;
 	}
 
-	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
+	/*
+	 * Check if we need to send a sense buffer from
+	 * the struct se_cmd in question. We do NOT want
+	 * to take this path of the IO has been marked as
+	 * needing to be treated like a "normal read". This
+	 * is the case if it's a tape read, and either the
+	 * FM, EOM, or ILI bits are set, but there is no
+	 * sense data.
+	 */
+	if (!(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
+	    cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
 		goto queue_status;
 
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
-		if (cmd->scsi_status)
+		/* queue status if not treating this as a normal read */
+		if (cmd->scsi_status &&
+		    !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
 			goto queue_status;
 
 		trace_target_cmd_complete(cmd);
@@ -2194,9 +2208,15 @@ static void target_complete_ok_work(struct work_struct *work)
 
 	/*
 	 * Check if we need to send a sense buffer from
-	 * the struct se_cmd in question.
+	 * the struct se_cmd in question. We do NOT want
+	 * to take this path of the IO has been marked as
+	 * needing to be treated like a "normal read". This
+	 * is the case if it's a tape read, and either the
+	 * FM, EOM, or ILI bits are set, but there is no
+	 * sense data.
 	 */
-	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
+	if (!(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
+	    cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		WARN_ON(!cmd->scsi_status);
 		ret = transport_send_check_condition_and_sense(
 					cmd, 0, 1);
@@ -2238,7 +2258,18 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
-		if (cmd->scsi_status)
+		/*
+		 * if this is a READ-type IO, but SCSI status
+		 * is set, then skip returning data and just
+		 * return the status -- unless this IO is marked
+		 * as needing to be treated as a normal read,
+		 * in which case we want to go ahead and return
+		 * the data. This happens, for example, for tape
+		 * reads with the FM, EOM, or ILI bits set, with
+		 * no sense data.
+		 */
+		if (cmd->scsi_status &&
+		    !(cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL))
 			goto queue_status;
 
 		atomic_long_add(cmd->data_length,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f9f5902af38..922a39f45abc 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -143,6 +143,7 @@ enum se_cmd_flags_table {
 	SCF_ACK_KREF			= 0x00400000,
 	SCF_USE_CPUID			= 0x00800000,
 	SCF_TASK_ATTR_SET		= 0x01000000,
+	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
 };
 
 /*
-- 
2.13.6

