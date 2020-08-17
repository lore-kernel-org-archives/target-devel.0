From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:55:12 +0000
Subject: [PATCH 7/8] scsi: pm8001: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-8-allen.cryptic@gmail.com>
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
 drivers/scsi/pm8001/pm8001_init.c | 55 ++++++++++++++++++-------------
 drivers/scsi/pm8001/pm8001_sas.h  |  6 +++-
 2 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 20fa96cbc9d3..818816c8b295 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -187,12 +187,15 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
  * @opaque: the passed general host adapter struct
  * Note: pm8001_tasklet is common for pm8001 & pm80xx
  */
-static void pm8001_tasklet(unsigned long opaque)
+static void pm8001_tasklet(struct tasklet_struct *t)
 {
-	struct pm8001_hba_info *pm8001_ha;
+	struct tsk_param *tsk_param = from_tasklet(tsk_param, t, tasklet);
+	struct pm8001_hba_info *pm8001_ha = container_of(tsk_param,
+						typeof(*pm8001_ha),
+						tasklet[tsk_param->irq_id]);
 	struct isr_param *irq_vector;
 
-	irq_vector = (struct isr_param *)opaque;
+	irq_vector = &pm8001_ha->irq_vector[tsk_param->irq_id];
 	pm8001_ha = irq_vector->drv_inst;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
@@ -221,7 +224,7 @@ static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
 		return IRQ_NONE;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
+	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id].tasklet);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 #endif
@@ -246,7 +249,7 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 		return IRQ_NONE;
 
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[0]);
+	tasklet_schedule(&pm8001_ha->tasklet[0].tasklet);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 #endif
@@ -507,13 +510,16 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 #ifdef PM8001_USE_TASKLET
 	/* Tasklet for non msi-x interrupt handler */
 	if ((!pdev->msix_cap || !pci_msi_enabled())
-	    || (pm8001_ha->chip_id = chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
+	    || (pm8001_ha->chip_id = chip_8001)) {
+		pm8001_ha->tasklet[0].irq_id = 0;
+		tasklet_setup(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet);
+	} else {
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
+			pm8001_ha->tasklet[j].irq_id = j;
+			tasklet_setup(&pm8001_ha->tasklet[j].tasklet,
+				      pm8001_tasklet);
+		}
+	}
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -1162,10 +1168,10 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id = chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
+		tasklet_kill(&pm8001_ha->tasklet[0].tasklet);
 	else
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
+			tasklet_kill(&pm8001_ha->tasklet[j].tasklet);
 #endif
 	scsi_host_put(pm8001_ha->shost);
 	pm8001_free(pm8001_ha);
@@ -1212,10 +1218,10 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id = chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
+		tasklet_kill(&pm8001_ha->tasklet[0].tasklet);
 	else
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
+			tasklet_kill(&pm8001_ha->tasklet[j].tasklet);
 #endif
 	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
@@ -1281,13 +1287,16 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 #ifdef PM8001_USE_TASKLET
 	/*  Tasklet for non msi-x interrupt handler */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-	    (pm8001_ha->chip_id = chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
+	    (pm8001_ha->chip_id = chip_8001)) {
+		pm8001_ha->tasklet[0].irq_id = 0;
+		tasklet_setup(&pm8001_ha->tasklet[0].tasklet, pm8001_tasklet);
+	} else {
+		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++) {
+			pm8001_ha->tasklet[j].irq_id = j;
+			tasklet_setup(&pm8001_ha->tasklet[j].tasklet,
+				      pm8001_tasklet);
+		}
+	}
 #endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ae7ba9b3c4bc..6dbaa394a08b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -494,6 +494,10 @@ struct isr_param {
 	struct pm8001_hba_info *drv_inst;
 	u32 irq_id;
 };
+struct tsk_param {
+	struct tasklet_struct tasklet;
+	u32 irq_id;
+};
 struct pm8001_hba_info {
 	char			name[PM8001_NAME_LENGTH];
 	struct list_head	list;
@@ -549,7 +553,7 @@ struct pm8001_hba_info {
 				[PM8001_NAME_LENGTH+1+3+1];
 #endif
 #ifdef PM8001_USE_TASKLET
-	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
+	struct tsk_param	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
 	u32			logging_level;
 	u32			link_rate;
-- 
2.17.1
