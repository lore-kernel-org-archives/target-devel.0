From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:09 +0000
Subject: [PATCH 09/10] vhost: add VHOST_SET_VRING_ENABLE support
Message-Id: <1605223150-10888-11-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

This adds a new ioctl VHOST_SET_VRING_ENABLE that the vhost drivers can
implement a callout for and execute an operation when the vq is
enabled/disabled.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c      | 25 +++++++++++++++++++++++++
 drivers/vhost/vhost.h      |  1 +
 include/uapi/linux/vhost.h |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2f98b81..e953031 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1736,6 +1736,28 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 
 	return r;
 }
+
+static long vhost_vring_set_enable(struct vhost_dev *d,
+				   struct vhost_virtqueue *vq,
+				   void __user *argp)
+{
+	struct vhost_vring_state s;
+	int ret = 0;
+
+	if (vq->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(&s, argp, sizeof s))
+		return -EFAULT;
+
+	if (s.num != 1 && s.num != 0)
+		return -EINVAL;
+
+	if (d->ops && d->ops->enable_vring)
+		ret = d->ops->enable_vring(vq, s.num);
+	return ret;
+}
+
 long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 {
 	struct file *eventfp, *filep = NULL;
@@ -1765,6 +1787,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	mutex_lock(&vq->mutex);
 
 	switch (ioctl) {
+	case VHOST_SET_VRING_ENABLE:
+		r = vhost_vring_set_enable(d, vq, argp);
+		break;
 	case VHOST_SET_VRING_BASE:
 		/* Moving base with an active backend?
 		 * You don't want to do that. */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a293f48..1279c09 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -158,6 +158,7 @@ struct vhost_msg_node {
 
 struct vhost_dev_ops {
 	int (*msg_handler)(struct vhost_dev *dev, struct vhost_iotlb_msg *msg);
+	int (*enable_vring)(struct vhost_virtqueue *vq, bool enable);
 };
 
 struct vhost_dev {
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860..3ffd133 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -70,6 +70,7 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
1.8.3.1
