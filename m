From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:00 +0000
Subject: [PATCH 1/1] qemu vhost scsi: add VHOST_SET_VRING_ENABLE support
Message-Id: <1605223150-10888-2-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

This patch made over the master branch allows the vhost-scsi
driver to call into the kernel and tell it to enable/disable
a virtqueue.

The kernel patches included with this set, will create
a worker per IO vq when multiple IO queues have been setup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 hw/scsi/vhost-scsi.c        |  6 ++++++
 hw/virtio/vhost-backend.c   | 30 ++++++++++++++++++++++++++++++
 linux-headers/linux/vhost.h |  1 +
 3 files changed, 37 insertions(+)

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 4d70fa0..bbb2ba3 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -93,6 +93,12 @@ static int vhost_scsi_start(VHostSCSI *s)
         return ret;
     }
 
+    ret = vsc->dev.vhost_ops->vhost_set_vring_enable(&vsc->dev, 1);
+    if (ret) {
+        error_report("Error enabling vhost-scsi vqs %d", ret);
+        vhost_scsi_common_stop(vsc);
+    }
+
     ret = vhost_scsi_set_endpoint(s);
     if (ret < 0) {
         error_report("Error setting vhost-scsi endpoint");
diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
index 88c8ecc..e190c8e 100644
--- a/hw/virtio/vhost-backend.c
+++ b/hw/virtio/vhost-backend.c
@@ -102,6 +102,35 @@ static int vhost_kernel_set_mem_table(struct vhost_dev *dev,
     return vhost_kernel_call(dev, VHOST_SET_MEM_TABLE, mem);
 }
 
+static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int enable)
+{
+    struct vhost_vring_state s;
+    int i, ret;
+
+    s.num = 1;
+    for (i = 0; i < dev->nvqs; ++i) {
+        s.index = i;
+
+        ret = vhost_kernel_call(dev, VHOST_SET_VRING_ENABLE, &s);
+        /* Ignore kernels that do not support the cmd */
+        if (ret = -EPERM)
+            return 0;
+        if (ret)
+            goto disable_vrings;
+    }
+
+    return 0;
+
+disable_vrings:
+    s.num = 0;
+    for (i--; i < dev->nvqs; ++i) {
+        s.index = i;
+        vhost_kernel_call(dev, VHOST_SET_VRING_ENABLE, &s);
+    }
+
+    return ret;
+}
+
 static int vhost_kernel_set_vring_addr(struct vhost_dev *dev,
                                        struct vhost_vring_addr *addr)
 {
@@ -302,6 +331,7 @@ static const VhostOps kernel_ops = {
         .vhost_scsi_get_abi_version = vhost_kernel_scsi_get_abi_version,
         .vhost_set_log_base = vhost_kernel_set_log_base,
         .vhost_set_mem_table = vhost_kernel_set_mem_table,
+        .vhost_set_vring_enable = vhost_kernel_set_vring_enable,
         .vhost_set_vring_addr = vhost_kernel_set_vring_addr,
         .vhost_set_vring_endian = vhost_kernel_set_vring_endian,
         .vhost_set_vring_num = vhost_kernel_set_vring_num,
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index 7523218..98dd919 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -70,6 +70,7 @@
 #define VHOST_VRING_BIG_ENDIAN 1
 #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
 #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+#define VHOST_SET_VRING_ENABLE _IOW(VHOST_VIRTIO, 0x15, struct vhost_vring_state)
 
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
-- 
1.8.3.1
