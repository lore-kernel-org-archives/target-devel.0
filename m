From: Viacheslav Dubeyko <slava@dubeyko.com>
Date: Mon, 16 Mar 2020 13:07:17 +0000
Subject: [PATCH] scsi: target: core: add task tag to trace events
Message-Id: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, v.dubeiko@yadro.com, rostedt@goodmis.org, mingo@redhat.com, r.bolshakov@yadro.com, k.shelekhin@yadro.com

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Date: Tue, 10 Mar 2020 17:04:41 +0300
Subject: [PATCH] scsi: target: core: add task tag to trace events

Trace events target_sequencer_start and target_cmd_complete
(include/trace/events/target.h) are ready to show NAA identifier,
LUN ID, and many other important command details in the system log:

TP_printk("%s -> LUN %03u %s data_length %6u  CDB %s  (TA:%s C:%02x)",

However, it's still hard to identify command on the initiator
and command on the target in the real life output of system log.
For that purpose SCSI provides a command identifier or
task tag (term used in previous standards). This patch adds
tag ID in the system log's output:

TP_printk("%s -> LUN %03u tag %#llx %s data_length %6u  CDB %s  (TA:%s C:%02x)",

kworker/1:1-35    [001] ....  1392.989452: target_sequencer_start:
naa.5001405ec1ba6364 -> LUN 001 tag 0x1
SERVICE_ACTION_IN_16 data_length     32
CDB 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00  (TA:SIMPLE C:00)

kworker/1:1-35    [001] ....  1392.989456: target_cmd_complete:
naa.5001405ec1ba6364 <- LUN 001 tag 0x1 status GOOD (sense len 0) 
SERVICE_ACTION_IN_16 data_length     32
CDB 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00  (TA:SIMPLE C:00)

Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>

diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 50fea660c0f8..7f4525d12aeb 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -136,6 +136,7 @@ TRACE_EVENT(target_sequencer_start,
 
 	TP_STRUCT__entry(
 		__field( unsigned int,	unpacked_lun	)
+		__field( unsigned long long,	tag	)
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
@@ -145,6 +146,7 @@ TRACE_EVENT(target_sequencer_start,
 
 	TP_fast_assign(
 		__entry->unpacked_lun	= cmd->orig_fe_lun;
+		__entry->tag		= cmd->tag;
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
@@ -152,9 +154,9 @@ TRACE_EVENT(target_sequencer_start,
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
 	),
 
-	TP_printk("%s -> LUN %03u %s data_length %6u  CDB %s  (TA:%s C:%02x)",
+	TP_printk("%s -> LUN %03u tag %#llx %s data_length %6u  CDB %s  (TA:%s C:%02x)",
 		  __get_str(initiator), __entry->unpacked_lun,
-		  show_opcode_name(__entry->opcode),
+		  __entry->tag, show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
 		  scsi_command_size(__entry->cdb) <= 16 ?
@@ -171,6 +173,7 @@ TRACE_EVENT(target_cmd_complete,
 
 	TP_STRUCT__entry(
 		__field( unsigned int,	unpacked_lun	)
+		__field( unsigned long long,	tag	)
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
@@ -183,6 +186,7 @@ TRACE_EVENT(target_cmd_complete,
 
 	TP_fast_assign(
 		__entry->unpacked_lun	= cmd->orig_fe_lun;
+		__entry->tag		= cmd->tag;
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
@@ -194,8 +198,9 @@ TRACE_EVENT(target_cmd_complete,
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
 	),
 
-	TP_printk("%s <- LUN %03u status %s (sense len %d%s%s)  %s data_length %6u  CDB %s  (TA:%s C:%02x)",
+	TP_printk("%s <- LUN %03u tag %#llx status %s (sense len %d%s%s)  %s data_length %6u  CDB %s  (TA:%s C:%02x)",
 		  __get_str(initiator), __entry->unpacked_lun,
+		  __entry->tag,
 		  show_scsi_status_name(__entry->scsi_status),
 		  __entry->sense_length, __entry->sense_length ? " / " : "",
 		  __print_hex(__entry->sense_data, __entry->sense_length),
-- 
2.17.1
