From: Lee Duncan <lduncan@suse.com>
Date: Thu, 03 May 2018 17:53:40 +0000
Subject: [PATCH RFC] target transport: allow st INI reads
Message-Id: <20180503175340.3863-1-lduncan@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When a tape drive is exported via LIO using the
pscsi module, a read that requests more bytes per block
than the tape can supply returns an empty buffer. This
is because the pscsi pass-through target module sees
the "ILI" illegal length bit set and thinks there
is no reason to return the data.

Add in a hack to check for tape reads with the INI
bit set, treating such cases as if there is no
sense data. The tape driver then "does the right
thing" when it gets the INI bit and that date.

NOTE: I'm not sure if this is the right place to effect
this change, nor if it's the right approach, so comments/
suggestions are welcomed!
---
 drivers/target/target_core_transport.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 836d552b0385..aafd64b514fe 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2187,7 +2187,25 @@ static void target_complete_ok_work(struct work_struct *work)
 	 * the struct se_cmd in question.
 	 */
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
+		struct se_device *dev = cmd->se_dev;
+		unsigned char *sense = cmd->sense_buffer;
+
 		WARN_ON(!cmd->scsi_status);
+
+		/*
+		 * hack: check for tape reads with the ILI (illegal
+		 * length indicator) set, and just pass those through
+		 */
+		if ((dev->transport->get_device_type(dev) = TYPE_TAPE) &&
+		    (cmd->scsi_status = SAM_STAT_CHECK_CONDITION) &&
+		    (cmd->data_direction = DMA_FROM_DEVICE)) {
+			if ((sense[0] = 0xf0) &&	/* 'valid' and 'fixed format' */
+			    (sense[2] & 0x20)) {	/* 'ILI' */
+				pr_debug("Tape ILI Bit detected. Treating as OK\n");
+				goto treat_as_normal_read;
+			}
+		}
+
 		ret = transport_send_check_condition_and_sense(
 					cmd, 0, 1);
 		if (ret)
-- 
2.13.6

