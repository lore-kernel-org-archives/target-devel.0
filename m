From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 24 May 2018 16:49:41 +0000
Subject: [RESEND] TCMUser: add read length support
Message-Id: <5b06ed25.3Xi5BduJFP9OUO6V%bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This is patch version 3.

Generally target core and TCMUser seem to work fine for tape devices and
media changers.
But there is at least one situation, where TCMUser is not able to support
sequential access device emulation correctly.

The situation is when an initiator sends a SCSI READ CDB with a length that is
greater than the length of the tape block to read. We can distinguish two
subcases:

A) The initiator sent the READ CDB with the SILI bit being set.
   In this case the sequential access device has to transfer the data from the
   tape block (only the length of the tape block) and transmit a good status.
   The current interface between TCMUser and the userspace does not support
   reduction of the read data size by the userspace program.

   The patch below fixes this subcase by allowing the userspace program to
   specify a reduced data size in read direction.

B) The initiator sent the READ CDB with the SILI bit not being set.
   In this case the sequential access device has to transfer the data from the
   tape block as in A), but additionally has to transmit CHECK CONDITION with
   the ILI bit set and NO SENSE in the sensebytes. The information field in
   the sensebytes must contain the residual count.

   With the below patch a user space program can specify the real read data
   length and appropriate sensebytes.
   TCMUser then uses the se_cmd flag SCF_TREAT_READ_AS_NORMAL, to force target
   core to transmit the real data size and the sensebytes.
   Note: the flag SCF_TREAT_READ_AS_NORMAL is introduced by Lee Duncan's
   patch "[PATCH v4] target: transport should handle st FM/EOM/ILI reads" from
   Tue, 15 May 2018 18:25:24 -0700.

This patch was created for kernel 4.15.9.


Changes from RFC:
- patch now uses SCF_TREAT_READ_AS_NORMAL to fix B) also.
- comment changed accordingly

Changes from V2:
- Cleaned up code according to review
- Userspace can set read_len for data in only, not for bidi.
- read_len from userspace no longer is checked implicitly by
  gather_data_area(), but the check is done explicitly
  in tcmu_handle_completion(). Now code is easier to understand.
  

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Acked-by: Mike Christie <mchristi@redhat.com>

---
 include/uapi/linux/target_core_user.h |    4 ++-
 drivers/target/target_core_user.c     |   44 +++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 9 deletions(-)

--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -43,6 +43,7 @@
 #define TCMU_MAILBOX_VERSION 2
 #define ALIGN_SIZE 64 /* Should be enough for most CPUs */
 #define TCMU_MAILBOX_FLAG_CAP_OOOC (1 << 0) /* Out-of-order completions */
+#define TCMU_MAILBOX_FLAG_CAP_READ_LEN (1 << 1) /* Read data length */
 
 struct tcmu_mailbox {
 	__u16 version;
@@ -70,6 +71,7 @@ struct tcmu_cmd_entry_hdr {
 	__u16 cmd_id;
 	__u8 kflags;
 #define TCMU_UFLAG_UNKNOWN_OP 0x1
+#define TCMU_UFLAG_READ_LEN   0x2
 	__u8 uflags;
 
 } __packed;
@@ -118,7 +120,7 @@ struct tcmu_cmd_entry {
 			__u8 scsi_status;
 			__u8 __pad1;
 			__u16 __pad2;
-			__u32 __pad3;
+			__u32 read_len;
 			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
 		} rsp;
 	};
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -576,7 +576,7 @@ static int scatter_data_area(struct tcmu
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-			     bool bidi)
+			     bool bidi, uint32_t read_len)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	int i, dbi;
@@ -609,7 +609,7 @@ static void gather_data_area(struct tcmu
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
 		to = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0) {
+		while (sg_remaining > 0 && read_len > 0) {
 			if (block_remaining = 0) {
 				if (from)
 					kunmap_atomic(from);
@@ -621,6 +621,8 @@ static void gather_data_area(struct tcmu
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
+			if (read_len < copy_bytes)
+				copy_bytes = read_len;
 			offset = DATA_BLOCK_SIZE - block_remaining;
 			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from + offset,
@@ -628,8 +630,11 @@ static void gather_data_area(struct tcmu
 
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
+			read_len -= copy_bytes;
 		}
 		kunmap_atomic(to - sg->offset);
+		if (read_len = 0)
+			break;
 	}
 	if (from)
 		kunmap_atomic(from);
@@ -947,6 +952,8 @@ static void tcmu_handle_completion(struc
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
+	bool read_len_valid = false;
+	uint32_t read_len = se_cmd->data_length;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
@@ -961,13 +968,28 @@ static void tcmu_handle_completion(struc
 		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
 			cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
-	} else if (entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION) {
+		goto done;
+	}
+
+	if (se_cmd->data_direction = DMA_FROM_DEVICE &&
+	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
+		read_len_valid = true;
+		if (entry->rsp.read_len < read_len)
+			read_len = entry->rsp.read_len;
+	}
+
+	if (entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION) {
 		transport_copy_sense_to_cmd(se_cmd, entry->rsp.sense_buffer);
-	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		if (!read_len_valid )
+			goto done;
+		else
+			se_cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
+	}
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		/* Get Data-In buffer before clean up */
-		gather_data_area(udev, cmd, true);
+		gather_data_area(udev, cmd, true, read_len);
 	} else if (se_cmd->data_direction = DMA_FROM_DEVICE) {
-		gather_data_area(udev, cmd, false);
+		gather_data_area(udev, cmd, false, read_len);
 	} else if (se_cmd->data_direction = DMA_TO_DEVICE) {
 		/* TODO: */
 	} else if (se_cmd->data_direction != DMA_NONE) {
@@ -975,7 +997,13 @@ static void tcmu_handle_completion(struc
 			se_cmd->data_direction);
 	}
 
-	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
+done:
+	if (read_len_valid) {
+		pr_debug("read_len = %d\n", read_len);
+		target_complete_cmd_with_length(cmd->se_cmd,
+					entry->rsp.scsi_status, read_len);
+	} else
+		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
 	cmd->se_cmd = NULL;
@@ -1532,7 +1560,7 @@ static int tcmu_configure_device(struct
 	/* Initialise the mailbox of the ring buffer */
 	mb = udev->mb_addr;
 	mb->version = TCMU_MAILBOX_VERSION;
-	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC;
+	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC | TCMU_MAILBOX_FLAG_CAP_READ_LEN;
 	mb->cmdr_off = CMDR_OFF;
 	mb->cmdr_size = udev->cmdr_size;
 
