From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 10 Jul 2020 10:48:14 +0000
Subject: [PATCH 5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
Message-Id: <20200710104817.19462-6-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

The new helper ring_insert_padding is split off from and then
called by queue_cmd_ring. It inserts a padding if necessary.
The new helper will in a further patch be used during writing
of TMR notifications to command ring.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 51 +++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 25c480fde9ee..7a27e838a7d3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -926,6 +926,34 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	return 0;
 }
 
+static uint32_t ring_insert_padding(struct tcmu_dev *dev, size_t cmd_size)
+{
+	struct tcmu_cmd_entry_hdr *hdr;
+	struct tcmu_mailbox *mb = dev->mb_addr;
+	uint32_t cmd_head = mb->cmd_head % dev->cmdr_size; /* UAM */
+
+	/* Insert a PAD if end-of-ring space is too small */
+	if (head_to_end(cmd_head, dev->cmdr_size) < cmd_size) {
+		size_t pad_size = head_to_end(cmd_head, dev->cmdr_size);
+
+		hdr = (void *) mb + CMDR_OFF + cmd_head;
+		tcmu_hdr_set_op(&hdr->len_op, TCMU_OP_PAD);
+		tcmu_hdr_set_len(&hdr->len_op, pad_size);
+		hdr->cmd_id = 0; /* not used for PAD */
+		hdr->kflags = 0;
+		hdr->uflags = 0;
+		tcmu_flush_dcache_range(hdr, sizeof(*hdr));
+
+		UPDATE_HEAD(mb->cmd_head, pad_size, dev->cmdr_size);
+		tcmu_flush_dcache_range(mb, sizeof(*mb));
+
+		cmd_head = mb->cmd_head % dev->cmdr_size; /* UAM */
+		WARN_ON(cmd_head != 0);
+	}
+
+	return cmd_head;
+}
+
 /**
  * queue_cmd_ring - queue cmd to ring or internally
  * @tcmu_cmd: cmd to queue
@@ -941,7 +969,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
 	size_t base_command_size, command_size;
-	struct tcmu_mailbox *mb;
+	struct tcmu_mailbox *mb = udev->mb_addr;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
 	int iov_cnt, cmd_id;
@@ -980,8 +1008,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	if (!list_empty(&udev->qfull_queue))
 		goto queue;
 
-	mb = udev->mb_addr;
-	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
 	if ((command_size > (udev->cmdr_size / 2)) ||
 	    data_length > udev->data_size) {
 		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
@@ -1001,24 +1027,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		goto queue;
 	}
 
-	/* Insert a PAD if end-of-ring space is too small */
-	if (head_to_end(cmd_head, udev->cmdr_size) < command_size) {
-		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
-
-		entry = (void *) mb + CMDR_OFF + cmd_head;
-		tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_PAD);
-		tcmu_hdr_set_len(&entry->hdr.len_op, pad_size);
-		entry->hdr.cmd_id = 0; /* not used for PAD */
-		entry->hdr.kflags = 0;
-		entry->hdr.uflags = 0;
-		tcmu_flush_dcache_range(entry, sizeof(entry->hdr));
-
-		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
-		tcmu_flush_dcache_range(mb, sizeof(*mb));
-
-		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-		WARN_ON(cmd_head != 0);
-	}
+	cmd_head = ring_insert_padding(udev, command_size);
 
 	entry = (void *) mb + CMDR_OFF + cmd_head;
 	memset(entry, 0, command_size);
-- 
2.12.3
