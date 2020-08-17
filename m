From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:55:18 +0000
Subject: [PATCH 8/8] scsi: pmcraid: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-9-allen.cryptic@gmail.com>
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
 drivers/scsi/pmcraid.c | 29 +++++++++++++++--------------
 drivers/scsi/pmcraid.h |  9 +++++++--
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..b7bbefcbb11d 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4198,7 +4198,7 @@ static irqreturn_t pmcraid_isr_msix(int irq, void *dev_id)
 		}
 	}
 
-	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
+	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]).tasklet);
 
 	return IRQ_HANDLED;
 }
@@ -4267,7 +4267,7 @@ static irqreturn_t pmcraid_isr(int irq, void *dev_id)
 				pinstance->int_regs.ioa_host_interrupt_clr_reg);
 
 			tasklet_schedule(
-					&(pinstance->isr_tasklet[hrrq_id]));
+				&(pinstance->isr_tasklet[hrrq_id].tasklet));
 		}
 	}
 
@@ -4380,20 +4380,20 @@ static void pmcraid_worker_function(struct work_struct *workp)
  * Return Value
  *	None
  */
-static void pmcraid_tasklet_function(unsigned long instance)
+static void pmcraid_tasklet_function(struct tasklet_struct *t)
 {
-	struct pmcraid_isr_param *hrrq_vector;
-	struct pmcraid_instance *pinstance;
+	struct pmcraid_tsk_param *tsk_param = from_tasklet(tsk_param, t,
+							   tasklet);
+	int id = tsk_param->isr_tasklet_id;
+	struct pmcraid_instance *pinstance = container_of(tsk_param,
+							  typeof(*pinstance),
+							  isr_tasklet[id]);
 	unsigned long hrrq_lock_flags;
 	unsigned long pending_lock_flags;
 	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
-	int id;
 	u32 resp;
 
-	hrrq_vector = (struct pmcraid_isr_param *)instance;
-	pinstance = hrrq_vector->drv_inst;
-	id = hrrq_vector->hrrq_id;
 	lockp = &(pinstance->hrrq_lock[id]);
 
 	/* loop through each of the commands responded by IOA. Each HRRQ buf is
@@ -4882,10 +4882,11 @@ static int pmcraid_allocate_config_buffers(struct pmcraid_instance *pinstance)
 static void pmcraid_init_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
-	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_init(&pinstance->isr_tasklet[i],
-			     pmcraid_tasklet_function,
-			     (unsigned long)&pinstance->hrrq_vector[i]);
+	for (i = 0; i < pinstance->num_hrrq; i++) {
+		pinstance->isr_tasklet[i].isr_tasklet_id = i;
+		tasklet_setup(&pinstance->isr_tasklet[i].tasklet,
+			     pmcraid_tasklet_function);
+	}
 }
 
 /**
@@ -4900,7 +4901,7 @@ static void pmcraid_kill_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
 	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_kill(&pinstance->isr_tasklet[i]);
+		tasklet_kill(&pinstance->isr_tasklet[i].tasklet);
 }
 
 /**
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 15c962108075..68dab849d4c1 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -617,6 +617,11 @@ struct pmcraid_isr_param {
 	u8 hrrq_id;			/* hrrq entry index */
 };
 
+/* Tasklet parameters (one for each enabled tasklet) */
+struct pmcraid_tsk_param {
+	struct tasklet_struct tasklet;
+	u8 isr_tasklet_id;              /* isr_tasklet entry index */
+};
 
 /* AEN message header sent as part of event data to applications */
 struct pmcraid_aen_msg {
@@ -752,8 +757,8 @@ struct pmcraid_instance {
 	spinlock_t free_pool_lock;		/* free pool lock */
 	spinlock_t pending_pool_lock;		/* pending pool lock */
 
-	/* Tasklet to handle deferred processing */
-	struct tasklet_struct isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
+	/* Tasklet parameters and tasklets to handle deferred processing */
+	struct pmcraid_tsk_param isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Work-queue (Shared) for deferred reset processing */
 	struct work_struct worker_q;
-- 
2.17.1
