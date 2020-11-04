From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 04 Nov 2020 22:26:37 +0000
Subject: [PATCH 04/11] vhost: prep vhost_dev_init users to handle failures
Message-Id: <1604528804-2878-5-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

This is just a prep patch to get vhost_dev_init callers ready to handle
the next patch where the function can fail. In this patch vhost_dev_init
just returns 0, but I think it's easier to check for goto/error handling
errors separated from the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com> 
---
 drivers/vhost/net.c   | 11 +++++++----
 drivers/vhost/scsi.c  |  8 ++++++--
 drivers/vhost/test.c  |  9 +++++++--
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 14 ++++++++------
 drivers/vhost/vhost.h | 10 +++++-----
 drivers/vhost/vsock.c | 10 +++++++---
 7 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 831d824..fd30b53 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1316,10 +1316,11 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
-		       UIO_MAXIOV + VHOST_NET_BATCH,
-		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
-		       NULL);
+	if (vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
+			   UIO_MAXIOV + VHOST_NET_BATCH,
+			   VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT, true,
+			   NULL))
+		goto err_dev_init;
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);
@@ -1330,6 +1331,8 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 
 	return 0;
 
+err_dev_init:
+	kfree(xdp);
 err_xdp:
 	kfree(queue);
 err_queue:
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 86617bb..ed8baf9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1632,14 +1632,18 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0, true, NULL);
+	r = vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL);
+	if (r)
+		goto err_dev_init;
 
 	vhost_scsi_init_inflight(vs, NULL);
 
 	f->private_data = vs;
 	return 0;
 
+err_dev_init:
+	kfree(vqs);
 err_vqs:
 	kvfree(vs);
 err_vs:
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc..c255ae5 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,12 +119,17 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
-		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL);
+	if (vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+			   VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NULL)
+		goto err_dev_init;
 
 	f->private_data = n;
 
 	return 0;
+
+err_dev_init:
+	kfree(vqs);
+	return -ENOMEM;
 }
 
 static void *vhost_test_stop_vq(struct vhost_test *n,
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2754f30..c1615a7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -829,8 +829,10 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
-		       vhost_vdpa_process_iotlb_msg);
+	r = vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
+			   vhost_vdpa_process_iotlb_msg);
+	if (r)
+		goto err_dev_init;
 
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
@@ -850,6 +852,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
+err_dev_init:
 	kfree(vqs);
 err:
 	atomic_dec(&v->opened);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6818f71..b35229e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -458,12 +458,12 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 	return sizeof(*vq->desc) * num;
 }
 
-void vhost_dev_init(struct vhost_dev *dev,
-		    struct vhost_virtqueue **vqs, int nvqs,
-		    int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg))
+int vhost_dev_init(struct vhost_dev *dev,
+		   struct vhost_virtqueue **vqs, int nvqs,
+		   int iov_limit, int weight, int byte_weight,
+		   bool use_worker,
+		   int (*msg_handler)(struct vhost_dev *dev,
+				      struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -500,6 +500,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 			vhost_poll_init(&vq->poll, vq->handle_kick,
 					EPOLLIN, dev);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1365f33..9ad34b1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -167,11 +167,11 @@ struct vhost_dev {
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
-void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg));
+int vhost_dev_init(struct vhost_dev *dev, struct vhost_virtqueue **vqs,
+		   int nvqs, int iov_limit, int weight, int byte_weight,
+		   bool use_worker,
+		   int (*msg_handler)(struct vhost_dev *dev,
+				      struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f40205f..cae0083 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -630,9 +630,11 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
 	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
 
-	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
-		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
-		       VHOST_VSOCK_WEIGHT, true, NULL);
+	ret = vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
+			     UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
+			     VHOST_VSOCK_WEIGHT, true, NULL);
+	if (ret)
+		goto err_dev_init;
 
 	file->private_data = vsock;
 	spin_lock_init(&vsock->send_pkt_list_lock);
@@ -640,6 +642,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 	return 0;
 
+err_dev_init:
+	kfree(vqs);
 out:
 	vhost_vsock_free(vsock);
 	return ret;
-- 
1.8.3.1
