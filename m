From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:05 +0000
Subject: [PATCH 05/10] vhost: poll support support multiple workers
Message-Id: <1605223150-10888-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

The final patches are going to have vhost scsi create a vhost worker
per IO vq. This patch converts the poll code to poll and queue work on
the worker that is tied to the vq (in this patch we maintain the old
behavior where all vqs use a single worker).

For drivers that do not convert over to the multiple worker support
or for the case where the user just does not want to allocate the
resources then we maintain support for the single worker case.

Note: This adds a new function vhost_vq_work_queue. It's used by
this patch and also the next one, so I exported it here.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  6 ++++--
 drivers/vhost/vhost.c | 14 +++++++++++---
 drivers/vhost/vhost.h |  6 ++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d..6a27fe6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1330,8 +1330,10 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 		       NULL);
 
-	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
-	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev,
+			vqs[VHOST_NET_VQ_TX]);
+	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev,
+			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
 	n->page_frag.page = NULL;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d229515..9eeb8c7 100644
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
@@ -284,6 +286,12 @@ void vhost_poll_flush(struct vhost_poll *poll)
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
@@ -301,7 +309,7 @@ bool vhost_has_work(struct vhost_dev *dev)
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_vq_work_queue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -528,7 +536,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
 			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+					EPOLLIN, dev, vq);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f334e90..232c5f9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -33,7 +33,6 @@ struct vhost_worker {
 };
 
 /* Poll a file (eventfd or socket) */
-/* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
 	poll_table		table;
 	wait_queue_head_t	*wqh;
@@ -41,16 +40,19 @@ struct vhost_poll {
 	struct vhost_work	work;
 	__poll_t		mask;
 	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 int vhost_vq_worker_add(struct vhost_dev *dev, struct vhost_virtqueue *vq);
 void vhost_vq_worker_remove(struct vhost_dev *dev, struct vhost_virtqueue *vq);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
-		     __poll_t mask, struct vhost_dev *dev);
+		     __poll_t mask, struct vhost_dev *dev,
+		     struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_flush(struct vhost_poll *poll);
-- 
1.8.3.1
