From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:35:00 +0000
Subject: [PATCH 14/17] vhost: poll support support multiple workers
Message-Id: <1603326903-27052-15-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The final patches are going to have vhost scsi create a vhost worker
per IO vq. This patch converts the poll code to poll and queue work on
the worker that is tied to the vq (in this patch we maintain the old
behavior where all vqs use a single worker).

For drivers that do not convert over to the multiple worker support
or for the case where the user just does not want to allocate the
resources then we maintain support for the single worker case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  6 ++++--
 drivers/vhost/vhost.c | 25 ++++++++++++++++++++++---
 drivers/vhost/vhost.h |  9 +++++++--
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index fce46f0..a316ed0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1322,8 +1322,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 			   NULL))
 		goto err_dev_init;
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 75866a2..991f781 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -187,13 +187,15 @@ void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
 
 /* Init poll structure */
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev)
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq)
 {
 	init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
 	init_poll_funcptr(&poll->table, vhost_poll_func);
 	poll->mask = mask;
 	poll->dev = dev;
 	poll->wqh = NULL;
+	poll->vq = vq;
 
 	vhost_work_init(&poll->work, fn);
 }
@@ -283,6 +285,12 @@ void vhost_poll_flush(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_flush);
 
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+	vhost_work_queue_on(vq->dev, work, vq->worker_id);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_queue);
+
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
@@ -302,7 +310,7 @@ bool vhost_has_work(struct vhost_dev *dev)
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -487,11 +495,12 @@ static void __vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	vq->indirect = NULL;
 	vq->heads = NULL;
 	vq->dev = dev;
+	vq->worker_id = 0;
 	mutex_init(&vq->mutex);
 	vhost_vq_reset(dev, vq);
 
 	if (vq->handle_kick)
-		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev, vq);
 }
 
 static int vhost_vq_init(struct vhost_dev *dev, int vq_idx)
@@ -642,6 +651,16 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+int vhost_vq_set_worker(struct vhost_virtqueue *vq, int worker_id)
+{
+	if (vhost_vq_get_backend(vq))
+		return -EBUSY;
+
+	vq->worker_id = worker_id;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_vq_set_worker);
+
 static void vhost_workers_free(struct vhost_dev *dev)
 {
 	struct vhost_worker *worker;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b0973e6..598aee7 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -16,6 +16,7 @@
 #include <linux/irqbypass.h>
 
 struct vhost_work;
+struct vhost_virtqueue;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
 #define VHOST_WORK_QUEUED 1
@@ -32,7 +33,6 @@ struct vhost_worker {
 };
 
 /* Poll a file (eventfd or socket) */
-/* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
 	poll_table		table;
 	wait_queue_head_t	*wqh;
@@ -40,15 +40,19 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
+int vhost_vq_set_worker(struct vhost_virtqueue *vq, int worker_id);
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
 int vhost_workers_create(struct vhost_dev *dev, int new_num_workers);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
@@ -91,6 +95,7 @@ struct vhost_virtqueue {
 
 	struct vhost_poll poll;
 
+	int worker_id;
 	/* The routine to call when the Guest pings us, or timeout. */
 	vhost_work_fn_t handle_kick;
 
-- 
1.8.3.1
