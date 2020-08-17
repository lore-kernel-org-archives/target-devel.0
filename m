From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:55:26 +0000
Subject: [PATCH 5/8] scsi: megaraid: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-6-allen.cryptic@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jejb@linux.ibm.com, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>, Romain Perier <romain.perier@gmail.com>

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c       |  9 ++++-----
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 +++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++++++-------
 4 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 19469a2c0ea3..47b2d8045c9d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -119,7 +119,7 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 
 static irqreturn_t megaraid_isr(int, void *);
 
-static void megaraid_mbox_dpc(unsigned long);
+static void megaraid_mbox_dpc(struct tasklet_struct *t);
 
 static ssize_t megaraid_sysfs_show_app_hndl(struct device *, struct device_attribute *attr, char *);
 static ssize_t megaraid_sysfs_show_ldnum(struct device *, struct device_attribute *attr, char *);
@@ -878,8 +878,7 @@ megaraid_init_mbox(adapter_t *adapter)
 	}
 
 	// setup tasklet for DPC
-	tasklet_init(&adapter->dpc_h, megaraid_mbox_dpc,
-			(unsigned long)adapter);
+	tasklet_setup(&adapter->dpc_h, megaraid_mbox_dpc);
 
 	con_log(CL_DLEVEL1, (KERN_INFO
 		"megaraid mbox hba successfully initialized\n"));
@@ -2168,9 +2167,9 @@ megaraid_isr(int irq, void *devp)
  * it is being called.
  */
 static void
-megaraid_mbox_dpc(unsigned long devp)
+megaraid_mbox_dpc(struct tasklet_struct *t)
 {
-	adapter_t		*adapter = (adapter_t *)devp;
+	adapter_t		*adapter = from_tasklet(adapter, t, dpc_h);
 	mraid_device_t		*raid_dev;
 	struct list_head	clist;
 	struct scatterlist	*sgl;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5e4137f10e0e..ce361b2b9f14 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2531,7 +2531,7 @@ struct megasas_instance_template {
 	int (*check_reset)(struct megasas_instance *, \
 		struct megasas_register_set __iomem *);
 	irqreturn_t (*service_isr)(int irq, void *devp);
-	void (*tasklet)(unsigned long);
+	void (*tasklet)(struct tasklet_struct *t);
 	u32 (*init_adapter)(struct megasas_instance *);
 	u32 (*build_and_issue_cmd) (struct megasas_instance *,
 				    struct scsi_cmnd *);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 861f7140f52e..dba60cc1cf41 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -217,7 +217,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance);
 u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
-static void megasas_complete_cmd_dpc(unsigned long instance_addr);
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	int seconds);
@@ -2217,14 +2217,14 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
  *
  * Tasklet to complete cmds
  */
-static void megasas_complete_cmd_dpc(unsigned long instance_addr)
+static void megasas_complete_cmd_dpc(struct tasklet_struct *t)
 {
 	u32 producer;
 	u32 consumer;
 	u32 context;
 	struct megasas_cmd *cmd;
-	struct megasas_instance *instance -				(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t,
+							 isr_tasklet);
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
@@ -2769,7 +2769,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
 			 */
-			megasas_complete_cmd_dpc((unsigned long)instance);
+			megasas_complete_cmd_dpc(&instance->isr_tasklet);
 		}
 
 		msleep(1000);
@@ -6180,8 +6180,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	dev_info(&instance->pdev->dev,
 		"RDPQ mode\t: (%s)\n", instance->is_rdpq ? "enabled" : "disabled");
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		(unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	/*
 	 * Below are default value for legacy Firmware.
@@ -7719,8 +7718,7 @@ megasas_resume(struct pci_dev *pdev)
 	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
 		goto fail_init_mfi;
 
-	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-		     (unsigned long)instance);
+	tasklet_setup(&instance->isr_tasklet, instance->instancet->tasklet);
 
 	if (instance->msix_vectors ?
 			megasas_setup_irqs_msix(instance, 0) :
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0824410f78f8..67b07660971a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3705,15 +3705,15 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 
 /**
  * megasas_complete_cmd_dpc_fusion -	Completes command
- * @instance_addr:			Adapter soft state address
+ * @t:	Instance of the tasklet being run
  *
  * Tasklet to complete cmds
  */
 static void
-megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+megasas_complete_cmd_dpc_fusion(struct tasklet_struct *t)
 {
-	struct megasas_instance *instance -		(struct megasas_instance *)instance_addr;
+	struct megasas_instance *instance = from_tasklet(instance, t,
+							 isr_tasklet);
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -4062,7 +4062,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	if (reason = MFI_IO_TIMEOUT_OCR) {
 		dev_info(&instance->pdev->dev,
 			"MFI command is timed out\n");
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		if (instance->snapdump_wait_time)
 			megasas_trigger_snap_dump(instance);
 		retval = 1;
@@ -4078,7 +4078,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				   "FW in FAULT state Fault code:0x%x subcode:0x%x func:%s\n",
 				   abs_state & MFI_STATE_FAULT_CODE,
 				   abs_state & MFI_STATE_FAULT_SUBCODE, __func__);
-			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+			megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 			if (instance->requestorId && reason) {
 				dev_warn(&instance->pdev->dev, "SR-IOV Found FW in FAULT"
 				" state while polling during"
@@ -4122,7 +4122,7 @@ megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			}
 		}
 
-		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+		megasas_complete_cmd_dpc_fusion(&instance->isr_tasklet);
 		outstanding = atomic_read(&instance->fw_outstanding);
 		if (!outstanding)
 			goto out;
-- 
2.17.1
