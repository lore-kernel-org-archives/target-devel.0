From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 07 Oct 2020 20:54:50 +0000
Subject: [PATCH 05/16] vhost: move vq iovec allocation to dev init time
Message-Id: <1602104101-5592-6-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The next patches allow us to create vqs on demand after vhost_dev_init
and vhost_dev_set_owner have been called. For vhost-scsi we don't
know the number of vqs we really want until the vring/vq setup
operations have started up. For other devices we know the number of vqs
at vhost_dev_init time, so for those devs we init the vq and allocate
the needed iovecs. For vhost-scsi we will do it later when userspace has
instructed us to setup a specific vq.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 71 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b05e690..d6af5a4 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -384,29 +384,27 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 	vq->heads = NULL;
 }
 
-/* Helper to allocate iovec buffers for all vqs. */
-static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
+static int vhost_vq_alloc_iovecs(struct vhost_dev *dev,
+				 struct vhost_virtqueue *vq)
 {
-	struct vhost_virtqueue *vq;
-	int i;
+	vq->indirect = kmalloc_array(UIO_MAXIOV, sizeof(*vq->indirect),
+				     GFP_KERNEL);
+	if (!vq->indirect)
+		return -ENOMEM;
+
+	if (!dev->iov_limit)
+		return 0;
+
+	vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log), GFP_KERNEL);
+	vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
+				  GFP_KERNEL);
+	if (!vq->log || !vq->heads)
+		goto err_nomem;
 
-	for (i = 0; i < dev->nvqs; ++i) {
-		vq = dev->vqs[i];
-		vq->indirect = kmalloc_array(UIO_MAXIOV,
-					     sizeof(*vq->indirect),
-					     GFP_KERNEL);
-		vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log),
-					GFP_KERNEL);
-		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
-					  GFP_KERNEL);
-		if (!vq->indirect || !vq->log || !vq->heads)
-			goto err_nomem;
-	}
 	return 0;
 
 err_nomem:
-	for (; i >= 0; --i)
-		vhost_vq_free_iovecs(dev->vqs[i]);
+	vhost_vq_free_iovecs(vq);
 	return -ENOMEM;
 }
 
@@ -459,6 +457,21 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 	return sizeof(*vq->desc) * num;
 }
 
+static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+{
+	vq->log = NULL;
+	vq->indirect = NULL;
+	vq->heads = NULL;
+	vq->dev = dev;
+	mutex_init(&vq->mutex);
+	vhost_vq_reset(dev, vq);
+
+	if (vq->handle_kick)
+		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+
+	return vhost_vq_alloc_iovecs(dev, vq);
+}
+
 int vhost_dev_init(struct vhost_dev *dev,
 		   struct vhost_virtqueue **vqs, int nvqs,
 		   int iov_limit, int weight, int byte_weight,
@@ -466,7 +479,6 @@ int vhost_dev_init(struct vhost_dev *dev,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg))
 {
-	struct vhost_virtqueue *vq;
 	int i;
 
 	dev->vqs = vqs;
@@ -490,19 +502,16 @@ int vhost_dev_init(struct vhost_dev *dev,
 
 
 	for (i = 0; i < dev->nvqs; ++i) {
-		vq = dev->vqs[i];
-		vq->log = NULL;
-		vq->indirect = NULL;
-		vq->heads = NULL;
-		vq->dev = dev;
-		mutex_init(&vq->mutex);
-		vhost_vq_reset(dev, vq);
-		if (vq->handle_kick)
-			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+		if (vhost_vq_init(dev, dev->vqs[i]))
+			goto err_vq_init;
 	}
 
 	return 0;
+
+err_vq_init:
+	for (--i; i >= 0; --i)
+		vhost_vq_free_iovecs(dev->vqs[i]);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
 
@@ -607,10 +616,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 			goto err_cgroup;
 	}
 
-	err = vhost_dev_alloc_iovecs(dev);
-	if (err)
-		goto err_cgroup;
-
 	return 0;
 err_cgroup:
 	if (dev->worker) {
-- 
1.8.3.1
