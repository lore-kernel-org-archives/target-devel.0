From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 10 Jul 2020 16:26:52 +0000
Subject: [PATCH] scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
Message-Id: <20200710162652.26814-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

This PATCH is a re-send of the RFC PATCH I submitted 1 week ago.
I modified the RFC PATCH slightly to make it compile for IA32 and
X86_64 with and without CONFIG_COMPAT. Additionally I changed it
to support CONFIG_COMPAT for X86_64 only, since I wasn't able to
find out what field sizes and offsets if struct tcmu_cmd_entry
userspace programs on other archs would expect in compat mode.

This patch is made on top of Martin's for-next tree plus my PATCH
series "scsi: target: tcmu: Add TMR notification for tcmu"

---

When using tcmu it might happen, that userspace application cannot
be built as 64 bit program even on a 64 bit host due to existing
32 bit libraries that must be used, e.g. for compression, encryption,
deduplication, ...

Currently this only works with manual changes in userspace include
file target_core_user.h due to a missing padding field in
struct tcmu_cmd_entry. Additionally one has to change uio.h because
32-bit userspace interprets struct iovec to have 8 byte size while
64-bit kernel creates it with 16 byte size.

This patch adds CONFIG_COMPAT support for X86_64 in tcmu to avoid
header file editing.

During mmap() of the command ring and data area of tcmu_dev's
uio device, tcmu checks and saves the value returned from
in_compat_syscall(). That way it allows multiple tasks to mmap()
only if they are of same type (32-/64-bit).

During SCSI command processing tcmu now creates tcmu_cmd_entry
records according to the saved type of the userspace program.

Offset and size of data fields in tcmu_cmd_entry differ between
32-bit and 64-bit only in the req part.
The field cdb_off (__u64) is on a 4-byte boundary in 32-bit, while
in 64-bit it is on the next 8-byte boundary.
The same is true for the start of the "struct iovec iov[]" array.
It also contains 8 vs. 16 byte per array entry in 32-bit vs 64-bit
mode.

Since differences are not too many, I mostly inserted changes into
existing code where necessary instead of writing a full set of
compat_* functions.

This patch is tested on x86_64.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 170 +++++++++++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a8294f525124..57a49108c54e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -24,6 +24,15 @@
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
+
+#if defined(CONFIG_COMPAT) && defined(CONFIG_X86_64)
+#define TCMU_COMPAT
+#endif
+
+#ifdef TCMU_COMPAT
+#include <linux/compat.h>
+#endif
+
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_backend.h>
@@ -136,6 +145,11 @@ struct tcmu_dev {
 	uint32_t max_blocks;
 	size_t ring_size;
 
+#ifdef TCMU_COMPAT
+	bool compat;
+	bool new_open;
+#endif
+
 	struct mutex cmdr_lock;
 	struct list_head qfull_queue;
 	struct list_head tmr_queue;
@@ -193,6 +207,30 @@ struct tcmu_tmr {
 	uint32_t tmr_cmd_cnt;
 	int16_t tmr_cmd_ids[0];
 };
+#ifdef TCMU_COMPAT
+struct tcmu_compat_cmd_entry {
+	struct tcmu_cmd_entry_hdr hdr;
+
+	union {
+		struct {
+			__u32 iov_cnt;
+			__u32 iov_bidi_cnt;
+			__u32 iov_dif_cnt;
+			__u64 cdb_off;
+			__u64 __pad1;
+			__u64 __pad2;
+			struct compat_iovec iov[0];
+		} __packed req;
+		struct {
+			__u8 scsi_status;
+			__u8 __pad1;
+			__u16 __pad2;
+			__u32 read_len;
+			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
+		} rsp;
+	};
+} __packed;
+#endif
 
 /*
  * To avoid dead lock the mutex lock order should always be:
@@ -671,6 +709,26 @@ static inline size_t iov_tail(struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
+#ifdef TCMU_COMPAT
+static inline void compat_new_iov(struct iovec **iov, int *iov_cnt)
+{
+	struct compat_iovec **c_iov = (struct compat_iovec **)iov;
+
+	if (*iov_cnt != 0)
+		(*c_iov)++;
+	(*iov_cnt)++;
+
+	memset(*c_iov, 0, sizeof(struct compat_iovec));
+}
+
+static inline size_t compat_iov_tail(struct iovec *iov)
+{
+	struct compat_iovec *c_iov = (struct compat_iovec *)iov;
+
+	return (size_t)c_iov->iov_base + c_iov->iov_len;
+}
+#endif
+
 static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
 	unsigned int data_nents, struct iovec **iov,
@@ -705,13 +763,41 @@ static void scatter_data_area(struct tcmu_dev *udev,
 			to_offset = get_block_offset_user(udev, dbi,
 					block_remaining);
 
+			copy_bytes = min_t(size_t, sg_remaining,
+					block_remaining);
+			if (copy_data) {
+				offset = DATA_BLOCK_SIZE - block_remaining;
+				memcpy(to + offset,
+				       from + sg->length - sg_remaining,
+				       copy_bytes);
+			}
+			sg_remaining -= copy_bytes;
+			block_remaining -= copy_bytes;
+
 			/*
 			 * The following code will gather and map the blocks
 			 * to the same iovec when the blocks are all next to
 			 * each other.
 			 */
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
+#ifdef TCMU_COMPAT
+			if (udev->compat) {
+				struct compat_iovec *c_iov;
+
+				if (*iov_cnt != 0 &&
+				    to_offset = compat_iov_tail(*iov)) {
+					c_iov = (struct compat_iovec *)*iov;
+					c_iov->iov_len += copy_bytes;
+				} else {
+					compat_new_iov(iov, iov_cnt);
+					c_iov = (struct compat_iovec *)*iov;
+					c_iov->iov_base +						(compat_uptr_t)to_offset;
+					c_iov->iov_len = copy_bytes;
+				}
+				continue;
+			}
+#endif
+
 			if (*iov_cnt != 0 &&
 			    to_offset = iov_tail(*iov)) {
 				/*
@@ -730,16 +816,6 @@ static void scatter_data_area(struct tcmu_dev *udev,
 				(*iov)->iov_base = (void __user *)to_offset;
 				(*iov)->iov_len = copy_bytes;
 			}
-
-			if (copy_data) {
-				offset = DATA_BLOCK_SIZE - block_remaining;
-				memcpy(to + offset,
-				       from + sg->length - sg_remaining,
-				       copy_bytes);
-			}
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
 		}
 		kunmap_atomic(from - sg->offset);
 	}
@@ -879,8 +955,15 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return tcmu_get_empty_blocks(udev, cmd);
 }
 
-static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
+static inline size_t tcmu_cmd_get_base_cmd_size(struct tcmu_dev *tcmu_dev,
+						size_t iov_cnt)
 {
+#ifdef TCMU_COMPAT
+	if (tcmu_dev->compat) {
+		return max(offsetof(struct tcmu_compat_cmd_entry, req.iov[iov_cnt]),
+				sizeof(struct tcmu_compat_cmd_entry));
+	}
+#endif
 	return max(offsetof(struct tcmu_cmd_entry, req.iov[iov_cnt]),
 			sizeof(struct tcmu_cmd_entry));
 }
@@ -1016,7 +1099,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	 * The size will be recalculated later as actually needed to save
 	 * cmd area memories.
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
+	base_command_size = tcmu_cmd_get_base_cmd_size(udev, tcmu_cmd->dbi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	if (!list_empty(&udev->qfull_queue))
@@ -1049,7 +1132,15 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	/* Handle allocating space from the data area */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	iov = &entry->req.iov[0];
+#ifdef TCMU_COMPAT
+	if (udev->compat) {
+		struct compat_iovec *c_iov;
+
+		c_iov = &((struct tcmu_compat_cmd_entry *)entry)->req.iov[0];
+		iov = (struct iovec *)c_iov;
+	} else
+#endif
+		iov = &entry->req.iov[0];
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction = DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
@@ -1061,7 +1152,12 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* Handle BIDI commands */
 	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		iov++;
+#ifdef TCMU_COMPAT
+		if (udev->compat)
+			iov = (struct iovec *)((struct compat_iovec *)iov + 1);
+		else
+#endif
+			iov++;
 		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
 				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
 				  false);
@@ -1089,7 +1185,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	 * Recalaulate the command's base size and size according
 	 * to the actual needs
 	 */
-	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
+	base_command_size = tcmu_cmd_get_base_cmd_size(udev, entry->req.iov_cnt +
 						       entry->req.iov_bidi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
@@ -1098,7 +1194,14 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
-	entry->req.cdb_off = cdb_off;
+
+#ifdef TCMU_COMPAT
+	if (udev->compat)
+		((struct tcmu_compat_cmd_entry *)entry)->req.cdb_off = cdb_off;
+	else
+#endif
+		entry->req.cdb_off = cdb_off;
+
 	tcmu_flush_dcache_range(entry, command_size);
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
@@ -1730,6 +1833,8 @@ static const struct vm_operations_struct tcmu_vm_ops = {
 	.fault = tcmu_vma_fault,
 };
 
+static void __tcmu_reset_ring(struct tcmu_dev *, u8);
+
 static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
@@ -1743,6 +1848,23 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
+#ifdef TCMU_COMPAT
+	mutex_lock(&udev->cmdr_lock);
+	if (udev->new_open) {
+		if (in_compat_syscall() != udev->compat) {
+			udev->compat = !udev->compat;
+			__tcmu_reset_ring(udev, 1);
+		}
+		udev->new_open = false;
+	} else if (in_compat_syscall() != udev->compat) {
+		mutex_unlock(&udev->cmdr_lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&udev->cmdr_lock);
+
+	pr_debug("mmap() successful on %s, compat = %d\n", udev->name, udev->compat);
+#endif
+
 	return 0;
 }
 
@@ -1753,6 +1875,9 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 	/* O_EXCL not supported for char devs, so fake it? */
 	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
 		return -EBUSY;
+#ifdef TCMU_COMPAT
+	udev->new_open = true;
+#endif
 
 	udev->inode = inode;
 	kref_get(&udev->kref);
@@ -2210,14 +2335,12 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+static void __tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
 	int i;
 
-	mutex_lock(&udev->cmdr_lock);
-
 	idr_for_each_entry(&udev->commands, cmd, i) {
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
 			  cmd->cmd_id, udev->name,
@@ -2266,7 +2389,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	tcmu_remove_all_queued_tmr(udev);
 
 	run_qfull_queue(udev, false);
+}
 
+static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+{
+	mutex_lock(&udev->cmdr_lock);
+	__tcmu_reset_ring(udev, err_level);
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-- 
2.12.3
