From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 01 Nov 2020 18:59:34 +0000
Subject: [PATCH 8/8] tcm loop: allow queues, can queue and cmd per lun to be settable
Message-Id: <1604257174-4524-9-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Make can_queue, nr_hw_queues and cmd_per_lun settable by the user
instead of hard coding them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e..badba43 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -46,6 +46,15 @@
 
 static int tcm_loop_queue_status(struct se_cmd *se_cmd);
 
+static unsigned int tcm_loop_nr_hw_queues = 1;
+module_param_named(nr_hw_queues, tcm_loop_nr_hw_queues, uint, 0644);
+
+static unsigned int tcm_loop_can_queue = 1024;
+module_param_named(can_queue, tcm_loop_can_queue, uint, 0644);
+
+static unsigned int tcm_loop_cmd_per_lun = 1024;
+module_param_named(cmd_per_lun, tcm_loop_cmd_per_lun, uint, 0644);
+
 /*
  * Called from struct target_core_fabric_ops->check_stop_free()
  */
@@ -305,10 +314,8 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.eh_target_reset_handler = tcm_loop_target_reset,
-	.can_queue		= 1024,
 	.this_id		= -1,
 	.sg_tablesize		= 256,
-	.cmd_per_lun		= 1024,
 	.max_sectors		= 0xFFFF,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
@@ -342,6 +349,9 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh->max_lun = 0;
 	sh->max_channel = 0;
 	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
+	sh->nr_hw_queues = tcm_loop_nr_hw_queues;
+	sh->can_queue = tcm_loop_can_queue;
+	sh->cmd_per_lun = tcm_loop_cmd_per_lun;
 
 	host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
 		    SHOST_DIF_TYPE3_PROTECTION | SHOST_DIX_TYPE1_PROTECTION |
-- 
1.8.3.1
