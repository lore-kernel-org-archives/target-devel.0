From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:55:26 +0000
Subject: [PATCH 4/8] scsi: isci: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-5-allen.cryptic@gmail.com>
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
 drivers/scsi/isci/host.c | 4 ++--
 drivers/scsi/isci/host.h | 2 +-
 drivers/scsi/isci/init.c | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7b5deae68d33..599adebd039e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1113,9 +1113,9 @@ void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_ta
  * @data: This parameter specifies the ISCI host object
  *
  */
-void isci_host_completion_routine(unsigned long data)
+void isci_host_completion_routine(struct tasklet_struct *t)
 {
-	struct isci_host *ihost = (struct isci_host *)data;
+	struct isci_host *ihost = from_tasklet(ihost, t, completion_tasklet);
 	u16 active;
 
 	spin_lock_irq(&ihost->scic_lock);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 6bc3f022630a..6abe23682d9b 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -478,7 +478,7 @@ void isci_tci_free(struct isci_host *ihost, u16 tci);
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task);
 
 int isci_host_init(struct isci_host *);
-void isci_host_completion_routine(unsigned long data);
+void isci_host_completion_routine(struct tasklet_struct *t);
 void isci_host_deinit(struct isci_host *);
 void sci_controller_disable_interrupts(struct isci_host *ihost);
 bool sci_controller_has_remote_devices_stopping(struct isci_host *ihost);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 085e285f427d..32a0117b5ff4 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -511,8 +511,7 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	init_waitqueue_head(&ihost->eventq);
 	ihost->sas_ha.dev = &ihost->pdev->dev;
 	ihost->sas_ha.lldd_ha = ihost;
-	tasklet_init(&ihost->completion_tasklet,
-		     isci_host_completion_routine, (unsigned long)ihost);
+	tasklet_setup(&ihost->completion_tasklet, isci_host_completion_routine);
 
 	/* validate module parameters */
 	/* TODO: kill struct sci_user_parameters and reference directly */
-- 
2.17.1
