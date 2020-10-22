From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:34:52 +0000
Subject: [PATCH 06/17] vhost: support delayed vq creation
Message-Id: <1603326903-27052-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

This allows vq creation to be done when it's first accessed by
userspace. vhost-scsi doesn't know how many queues the user requested
until they are first setup, and we don't want to allocate resources
like the iovecs for 128 vqs when we are only using 1 or 2 most of the
time. In the next pathces, vhost-scsi will also switch to preallocating
cmds per vq instead of per lio session and we don't want to allocate
them for 127 extra vqs if they are not in use.

With this patch when a driver calls vhost_dev_init they pass in the
number of vqs that they know they need and the max they can support.
This patch has all the drivers pass in the same value for both the
initial number of vqs and the max. The next patch will convert scsi.
The other drivers like net/vsock have their vqs hard coded in the
kernel or setup/discovered via other methods like with vdpa.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/net.c   |  2 +-
 drivers/vhost/scsi.c  |  4 +--
 drivers/vhost/test.c  |  5 ++--
 drivers/vhost/vdpa.c  |  2 +-
 drivers/vhost/vhost.c | 71 ++++++++++++++++++++++++++++++++++-------------=
----
 drivers/vhost/vhost.h |  7 +++--
 drivers/vhost/vsock.c | 11 ++++----
 7 files changed, 66 insertions(+), 36 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index fd30b53..fce46f0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1316,7 +1316,7 @@ static int vhost_net_open(struct inode *inode, struct=
 file *f)
 		n->vqs[i].rx_ring =3D NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX, VHOST_NET_VQ_MAX,
 			   UIO_MAXIOV + VHOST_NET_BATCH,
 			   VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
 			   NULL))
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 63ba363..5d412f1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1632,8 +1632,8 @@ static int vhost_scsi_open(struct inode *inode, struc=
t file *f)
 		vqs[i] =3D &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick =3D vhost_scsi_handle_kick;
 	}
-	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-			   VHOST_SCSI_WEIGHT, 0, true, NULL))
+	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_MAX_VQ,
+			   UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL))
 		goto err_dev_init;
=20
 	vhost_scsi_init_inflight(vs, NULL);
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index c255ae5..9d2bfa3 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,8 +119,9 @@ static int vhost_test_open(struct inode *inode, struct =
file *f)
 	dev =3D &n->dev;
 	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
-	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
-			   VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL)
+	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, VHOST_TEST_VQ_MAX,
+			   UIO_MAXIOV, VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT,
+			   true, NULL)
 		goto err_dev_init;
=20
 	f->private_data =3D n;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 9c8a686..313ff5a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -810,7 +810,7 @@ static int vhost_vdpa_open(struct inode *inode, struct =
file *filep)
 		vqs[i] =3D &v->vqs[i];
 		vqs[i]->handle_kick =3D handle_vq_kick;
 	}
-	r =3D vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
+	r =3D vhost_dev_init(dev, vqs, nvqs, nvqs, 0, 0, 0, false,
 			   vhost_vdpa_process_iotlb_msg);
 	if (r)
 		goto err_dev_init;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a4a4450..2ca2e71 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -294,7 +294,7 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
 {
 	int i;
=20
-	for (i =3D 0; i < d->nvqs; ++i)
+	for (i =3D 0; i < d->max_nvqs; ++i)
 		__vhost_vq_meta_reset(d->vqs[i]);
 }
=20
@@ -331,6 +331,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->busyloop_timeout =3D 0;
 	vq->umem =3D NULL;
 	vq->iotlb =3D NULL;
+	vq->initialized =3D false;
 	vhost_vring_call_reset(&vq->call_ctx);
 	__vhost_vq_meta_reset(vq);
 }
@@ -411,7 +412,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 {
 	int i;
=20
-	for (i =3D 0; i < dev->nvqs; ++i)
+	for (i =3D 0; i < dev->max_nvqs; ++i)
 		vhost_vq_free_iovecs(dev->vqs[i]);
 }
=20
@@ -456,7 +457,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueu=
e *vq,
 	return sizeof(*vq->desc) * num;
 }
=20
-static int vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+static void __vhost_vq_init(struct vhost_dev *dev, struct vhost_virtqueue =
*vq)
 {
 	vq->log =3D NULL;
 	vq->indirect =3D NULL;
@@ -467,12 +468,29 @@ static int vhost_vq_init(struct vhost_dev *dev, struc=
t vhost_virtqueue *vq)
=20
 	if (vq->handle_kick)
 		vhost_poll_init(&vq->poll, vq->handle_kick, EPOLLIN, dev);
+}
+
+static int vhost_vq_init(struct vhost_dev *dev, int vq_idx)
+{
+	struct vhost_virtqueue *vq;
+	int ret;
+
+	if (vq_idx >=3D dev->max_nvqs)
+		return -ENOBUFS;
+
+	vq =3D dev->vqs[vq_idx];
+	__vhost_vq_init(dev, vq);
+	ret =3D vhost_vq_alloc_iovecs(dev, vq);
+	if (ret)
+		return ret;
=20
-	return vhost_vq_alloc_iovecs(dev, vq);
+	vq->initialized =3D true;
+	dev->nvqs++;
+	return 0;
 }
=20
 int vhost_dev_init(struct vhost_dev *dev,
-		   struct vhost_virtqueue **vqs, int nvqs,
+		   struct vhost_virtqueue **vqs, int nvqs, int max_nvqs,
 		   int iov_limit, int weight, int byte_weight,
 		   bool use_worker,
 		   int (*msg_handler)(struct vhost_dev *dev,
@@ -481,7 +499,8 @@ int vhost_dev_init(struct vhost_dev *dev,
 	int i;
=20
 	dev->vqs =3D vqs;
-	dev->nvqs =3D nvqs;
+	dev->nvqs =3D 0;
+	dev->max_nvqs =3D max_nvqs;
 	mutex_init(&dev->mutex);
 	dev->log_ctx =3D NULL;
 	dev->umem =3D NULL;
@@ -499,12 +518,15 @@ int vhost_dev_init(struct vhost_dev *dev,
 	INIT_LIST_HEAD(&dev->pending_list);
 	spin_lock_init(&dev->iotlb_lock);
=20
-
-	for (i =3D 0; i < dev->nvqs; ++i) {
-		if (vhost_vq_init(dev, dev->vqs[i]))
+	for (i =3D 0; i < nvqs; ++i) {
+		if (vhost_vq_init(dev, i))
 			goto err_vq_init;
 	}
=20
+	for (; i < dev->max_nvqs; ++i)
+		/* Just prep/clear the fields and set initialized=FAlse */
+		__vhost_vq_init(dev, dev->vqs[i]);
+
 	return 0;
=20
 err_vq_init:
@@ -652,7 +674,7 @@ void vhost_dev_reset_owner(struct vhost_dev *dev, struc=
t vhost_iotlb *umem)
 	/* We don't need VQ locks below since vhost_dev_cleanup makes sure
 	 * VQs aren't running.
 	 */
-	for (i =3D 0; i < dev->nvqs; ++i)
+	for (i =3D 0; i < dev->max_nvqs; ++i)
 		dev->vqs[i]->umem =3D umem;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
@@ -661,7 +683,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 {
 	int i;
=20
-	for (i =3D 0; i < dev->nvqs; ++i) {
+	for (i =3D 0; i < dev->max_nvqs; ++i) {
 		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
 			vhost_poll_stop(&dev->vqs[i]->poll);
 			vhost_poll_flush(&dev->vqs[i]->poll);
@@ -693,7 +715,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 {
 	int i;
=20
-	for (i =3D 0; i < dev->nvqs; ++i) {
+	for (i =3D 0; i < dev->max_nvqs; ++i) {
 		if (dev->vqs[i]->error_ctx)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
 		if (dev->vqs[i]->kick)
@@ -787,7 +809,7 @@ static bool memory_access_ok(struct vhost_dev *d, struc=
t vhost_iotlb *umem,
 {
 	int i;
=20
-	for (i =3D 0; i < d->nvqs; ++i) {
+	for (i =3D 0; i < d->max_nvqs; ++i) {
 		bool ok;
 		bool log;
=20
@@ -999,14 +1021,14 @@ static inline int vhost_put_used_idx(struct vhost_vi=
rtqueue *vq)
 static void vhost_dev_lock_vqs(struct vhost_dev *d)
 {
 	int i =3D 0;
-	for (i =3D 0; i < d->nvqs; ++i)
+	for (i =3D 0; i < d->max_nvqs; ++i)
 		mutex_lock_nested(&d->vqs[i]->mutex, i);
 }
=20
 static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 {
 	int i =3D 0;
-	for (i =3D 0; i < d->nvqs; ++i)
+	for (i =3D 0; i < d->max_nvqs; ++i)
 		mutex_unlock(&d->vqs[i]->mutex);
 }
=20
@@ -1462,7 +1484,7 @@ static long vhost_set_memory(struct vhost_dev *d, str=
uct vhost_memory __user *m)
 	d->umem =3D newumem;
=20
 	/* All memory accesses are done under some VQ mutex. */
-	for (i =3D 0; i < d->nvqs; ++i) {
+	for (i =3D 0; i < d->max_nvqs; ++i) {
 		mutex_lock(&d->vqs[i]->mutex);
 		d->vqs[i]->umem =3D newumem;
 		mutex_unlock(&d->vqs[i]->mutex);
@@ -1590,11 +1612,14 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigne=
d int ioctl, void __user *arg
 	r =3D get_user(idx, idxp);
 	if (r < 0)
 		return r;
-	if (idx >=3D d->nvqs)
-		return -ENOBUFS;
=20
-	idx =3D array_index_nospec(idx, d->nvqs);
+	idx =3D array_index_nospec(idx, d->max_nvqs);
 	vq =3D d->vqs[idx];
+	if (!vq->initialized) {
+		r =3D vhost_vq_init(d, idx);
+		if (r)
+			return r;
+	}
=20
 	if (ioctl =3D VHOST_SET_VRING_NUM ||
 	    ioctl =3D VHOST_SET_VRING_ADDR) {
@@ -1724,7 +1749,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool=
 enabled)
 	oiotlb =3D d->iotlb;
 	d->iotlb =3D niotlb;
=20
-	for (i =3D 0; i < d->nvqs; ++i) {
+	for (i =3D 0; i < d->max_nvqs; ++i) {
 		struct vhost_virtqueue *vq =3D d->vqs[i];
=20
 		mutex_lock(&vq->mutex);
@@ -1771,7 +1796,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned in=
t ioctl, void __user *argp)
 			r =3D -EFAULT;
 			break;
 		}
-		for (i =3D 0; i < d->nvqs; ++i) {
+		for (i =3D 0; i < d->max_nvqs; ++i) {
 			struct vhost_virtqueue *vq;
 			void __user *base =3D (void __user *)(unsigned long)p;
 			vq =3D d->vqs[i];
@@ -1794,7 +1819,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned in=
t ioctl, void __user *argp)
 			break;
 		}
 		swap(ctx, d->log_ctx);
-		for (i =3D 0; i < d->nvqs; ++i) {
+		for (i =3D 0; i < d->max_nvqs; ++i) {
 			mutex_lock(&d->vqs[i]->mutex);
 			d->vqs[i]->log_ctx =3D d->log_ctx;
 			mutex_unlock(&d->vqs[i]->mutex);
@@ -2609,7 +2634,7 @@ void vhost_set_backend_features(struct vhost_dev *dev=
, u64 features)
 	int i;
=20
 	mutex_lock(&dev->mutex);
-	for (i =3D 0; i < dev->nvqs; ++i) {
+	for (i =3D 0; i < dev->max_nvqs; ++i) {
 		vq =3D dev->vqs[i];
 		mutex_lock(&vq->mutex);
 		vq->acked_backend_features =3D features;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9ad34b1..9677870 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -132,6 +132,8 @@ struct vhost_virtqueue {
 	bool user_be;
 #endif
 	u32 busyloop_timeout;
+
+	bool initialized;
 };
=20
 struct vhost_msg_node {
@@ -148,6 +150,7 @@ struct vhost_dev {
 	struct mutex mutex;
 	struct vhost_virtqueue **vqs;
 	int nvqs;
+	int max_nvqs;
 	struct eventfd_ctx *log_ctx;
 	struct llist_head work_list;
 	struct task_struct *worker;
@@ -168,8 +171,8 @@ struct vhost_dev {
=20
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_=
len);
 int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue **vqs,
-		   int nvqs, int iov_limit, int weight, int byte_weight,
-		   bool use_worker,
+		   int nvqs, int max_nvqs, int iov_limit, int weight,
+		   int byte_weight, bool use_worker,
 		   int (*msg_handler)(struct vhost_dev *dev,
 				      struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a1a35e1..9200868 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -606,7 +606,7 @@ static int vhost_vsock_dev_open(struct inode *inode, st=
ruct file *file)
 {
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
-	int ret;
+	int ret, nvqs;
=20
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
@@ -615,7 +615,8 @@ static int vhost_vsock_dev_open(struct inode *inode, st=
ruct file *file)
 	if (!vsock)
 		return -ENOMEM;
=20
-	vqs =3D kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL);
+	nvqs =3D ARRAY_SIZE(vsock->vqs);
+	vqs =3D kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
 		ret =3D -ENOMEM;
 		goto out;
@@ -630,9 +631,9 @@ static int vhost_vsock_dev_open(struct inode *inode, st=
ruct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick =3D vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick =3D vhost_vsock_handle_rx_kick;
=20
-	if (vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
-			   UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-			   VHOST_VSOCK_WEIGHT, true, NULL))
+	if (vhost_dev_init(&vsock->dev, vqs, nvqs, nvqs, UIO_MAXIOV,
+			   VHOST_VSOCK_PKT_WEIGHT, VHOST_VSOCK_WEIGHT, true,
+			   NULL))
 		goto err_dev_init;
=20
 	file->private_data =3D vsock;
--=20
1.8.3.1
