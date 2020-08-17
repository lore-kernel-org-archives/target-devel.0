From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:54:52 +0000
Subject: [PATCH 3/8] scsi: ibmvscsi: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-4-allen.cryptic@gmail.com>
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
 drivers/scsi/ibmvscsi/ibmvfc.c           | 6 +++---
 drivers/scsi/ibmvscsi/ibmvscsi.c         | 8 ++++----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 7 +++----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 77f4d37d5bd6..50f025cdabbd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3204,9 +3204,9 @@ static irqreturn_t ibmvfc_interrupt(int irq, void *dev_instance)
  * Returns:
  *	Nothing
  **/
-static void ibmvfc_tasklet(void *data)
+static void ibmvfc_tasklet(struct tasklet_struct *t)
 {
-	struct ibmvfc_host *vhost = data;
+	struct ibmvfc_host *vhost = from_tasklet(vhost, t, tasklet);
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq *crq;
 	struct ibmvfc_async_crq *async;
@@ -4676,7 +4676,7 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 
 	retrc = 0;
 
-	tasklet_init(&vhost->tasklet, (void *)ibmvfc_tasklet, (unsigned long)vhost);
+	tasklet_setup(&vhost->tasklet, (void *)ibmvfc_tasklet);
 
 	if ((rc = request_irq(vdev->irq, ibmvfc_interrupt, 0, IBMVFC_NAME, vhost))) {
 		dev_err(dev, "Couldn't register irq 0x%x. rc=%d\n", vdev->irq, rc);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b1f3017b6547..46b818daa957 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -208,9 +208,10 @@ static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
  * ibmvscsi_task: - Process srps asynchronously
  * @data:	ibmvscsi_host_data of host
  */
-static void ibmvscsi_task(void *data)
+static void ibmvscsi_task(struct tasklet_struct *t)
 {
-	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct ibmvscsi_host_data *hostdata = from_tasklet(hostdata, t,
+							   srp_task);
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 	struct viosrp_crq *crq;
 	int done = 0;
@@ -366,8 +367,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
 
-	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
-		     (unsigned long)hostdata);
+	tasklet_setup(&hostdata->srp_task, ibmvscsi_task);
 
 	if (request_irq(vdev->irq,
 			ibmvscsi_handle_event,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d9e94e81da01..e62fd6c67001 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3328,9 +3328,9 @@ static int ibmvscsis_rdma(struct ibmvscsis_cmd *cmd, struct scatterlist *sg,
  *
  * Note: this is an edge triggered interrupt. It can not be shared.
  */
-static void ibmvscsis_handle_crq(unsigned long data)
+static void ibmvscsis_handle_crq(struct tasklet_struct *t)
 {
-	struct scsi_info *vscsi = (struct scsi_info *)data;
+	struct scsi_info *vscsi = from_tasklet(vscsi, t, work_task);
 	struct viosrp_crq *crq;
 	long rc;
 	bool ack = true;
@@ -3541,8 +3541,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	dev_dbg(&vscsi->dev, "probe hrc %ld, client partition num %d\n",
 		hrc, vscsi->client_data.partition_number);
 
-	tasklet_init(&vscsi->work_task, ibmvscsis_handle_crq,
-		     (unsigned long)vscsi);
+	tasklet_setup(&vscsi->work_task, ibmvscsis_handle_crq);
 
 	init_completion(&vscsi->wait_idle);
 	init_completion(&vscsi->unconfig);
-- 
2.17.1
