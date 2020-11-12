From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:10 +0000
Subject: [PATCH 10/10] vhost-scsi: create a woker per IO vq
Message-Id: <1605223150-10888-12-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

This patch has vhost-scsi create a worker thread per IO vq.
It also adds a modparam to enable the feature, because I was thinking
existing setups might not be expecting the extra threading use, so the
default is to use the old single thread multiple vq behavior.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 612359d..3fb147f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -62,6 +62,12 @@
  */
 #define VHOST_SCSI_WEIGHT 256
 
+static bool vhost_scsi_worker_per_io_vq;
+module_param_named(thread_per_io_virtqueue, vhost_scsi_worker_per_io_vq, bool,
+		   0644);
+MODULE_PARM_DESC(thread_per_io_virtqueue,
+		 "Create a worker thread per IO virtqueue. Set to true to turn on. Default is false where all virtqueues share a thread.");
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -1805,6 +1811,36 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	return 0;
 }
 
+static int vhost_scsi_enable_vring(struct vhost_virtqueue *vq, bool enable)
+{
+	struct vhost_scsi *vs = container_of(vq->dev, struct vhost_scsi, dev);
+	/*
+	 * For compat, we have the evt, ctl and first IO vq share worker0 like
+	 * is setup by default. Additional vqs get their own worker.
+	 */
+	if (vq = &vs->vqs[VHOST_SCSI_VQ_CTL].vq ||
+	    vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq ||
+	    vq = &vs->vqs[VHOST_SCSI_VQ_IO].vq)
+		return 0;
+
+	if (enable) {
+		if (!vhost_scsi_worker_per_io_vq)
+			return 0;
+		if (vq->worker_id != 0)
+			return 0;
+		return vhost_vq_worker_add(vq->dev, vq);
+	} else {
+		if (vq->worker_id = 0)
+			return 0;
+		vhost_vq_worker_remove(vq->dev, vq);
+		return 0;
+	}
+}
+
+static struct vhost_dev_ops vhost_scsi_dev_ops = {
+	.enable_vring = vhost_scsi_enable_vring,
+};
+
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
 	struct vhost_scsi_virtqueue *svq;
@@ -1843,7 +1879,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		svq->vq.handle_kick = vhost_scsi_handle_kick;
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
-		       VHOST_SCSI_WEIGHT, 0, true, NULL);
+		       VHOST_SCSI_WEIGHT, 0, true, &vhost_scsi_dev_ops);
 
 	vhost_scsi_init_inflight(vs, NULL);
 
-- 
1.8.3.1
