From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 07 Nov 2019 21:54:58 +0000
Subject: [PATCH] target/core: Document target_cmd_size_check()
Message-Id: <20191107215458.64242-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since it is nontrivial to derive the meaning of the size argument from
the code, add a documentation header above target_cmd_size_check().

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d7d4004f83f9..ba7a01bcad7c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1243,6 +1243,19 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
 	return TCM_NO_SENSE;
 }
 
+/**
+ * target_cmd_size_check - Check whether there will be a residual.
+ * @cmd: SCSI command.
+ * @size: Data buffer size derived from CDB. The data buffer size provided by
+ *   the SCSI transport driver is available in @cmd->data_length.
+ *
+ * Compare the data buffer size from the CDB with the data buffer limit from the transport
+ * header. Set @cmd->residual_count and SCF_OVERFLOW_BIT or SCF_UNDERFLOW_BIT if necessary.
+ *
+ * Note: target drivers set @cmd->data_length by calling transport_init_se_cmd().
+ *
+ * Return: TCM_NO_SENSE
+ */
 sense_reason_t
 target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 {
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog
