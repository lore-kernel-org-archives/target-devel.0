From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:08 +0000
Subject: [PATCH 08/10] vhost: move msg_handler to new ops struct
Message-Id: <1605223150-10888-10-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

The next patch adds a callout so drivers can perform some action when we
get a VHOST_SET_VRING_ENABLE, so this patch moves the msg_handler callout
to a new vhost_dev_ops struct just to keep all the callouts better
organized.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vdpa.c  |  7 +++++--
 drivers/vhost/vhost.c | 10 ++++------
 drivers/vhost/vhost.h | 11 ++++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2754f30..f271f42 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -802,6 +802,10 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static struct vhost_dev_ops vdpa_dev_ops = {
+	.msg_handler	= vhost_vdpa_process_iotlb_msg,
+};
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -829,8 +833,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
 	}
-	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
-		       vhost_vdpa_process_iotlb_msg);
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false, &vdpa_dev_ops);
 
 	dev->iotlb = vhost_iotlb_alloc(0, 0);
 	if (!dev->iotlb) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6a6abfc..2f98b81 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -504,9 +504,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
 		    int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg))
+		    bool use_worker, struct vhost_dev_ops *ops)
 {
 	struct vhost_virtqueue *vq;
 	int i;
@@ -524,7 +522,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
 	dev->use_worker = use_worker;
-	dev->msg_handler = msg_handler;
+	dev->ops = ops;
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
 	INIT_LIST_HEAD(&dev->pending_list);
@@ -1328,8 +1326,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (dev->msg_handler)
-		ret = dev->msg_handler(dev, &msg);
+	if (dev->ops && dev->ops->msg_handler)
+		ret = dev->ops->msg_handler(dev, &msg);
 	else
 		ret = vhost_process_iotlb_msg(dev, &msg);
 	if (ret) {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 0837133..a293f48 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -156,6 +156,10 @@ struct vhost_msg_node {
   struct list_head node;
 };
 
+struct vhost_dev_ops {
+	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+};
+
 struct vhost_dev {
 	struct mm_struct *mm;
 	struct mutex mutex;
@@ -175,16 +179,13 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
-	int (*msg_handler)(struct vhost_dev *dev,
-			   struct vhost_iotlb_msg *msg);
+	struct vhost_dev_ops *ops;
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
-		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
-				       struct vhost_iotlb_msg *msg));
+		    bool use_worker, struct vhost_dev_ops *ops);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
-- 
1.8.3.1
