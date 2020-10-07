From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 07 Oct 2020 20:54:52 +0000
Subject: [PATCH 07/16] vhost scsi: support delayed IO vq creation
Message-Id: <1602104101-5592-8-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

Each vhost-scsi device will need a evt and ctl queue, but the number
of IO queues depends on whatever the user has configured in userspace.
This patch has vhost-scsi create the evt, ctl and one IO vq at device
open time. We then create the other IO vqs when userspace starts to
set them up. We still waste some mem on the vq and scsi vq structs,
but we don't waste mem on iovec related arrays and for later patches
we know which queues are used by the dev->nvqs value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d412f1..ab1b656 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1401,7 +1401,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
-	for (index = 0; index < vs->dev.nvqs; ++index) {
+	for (index = 0; index < vs->dev.max_nvqs; ++index) {
 		/* Verify that ring has been setup correctly. */
 		if (!vhost_vq_access_ok(&vs->vqs[index].vq)) {
 			ret = -EFAULT;
@@ -1464,6 +1464,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		       sizeof(vs->vs_vhost_wwpn));
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (!vq->initialized)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -1503,7 +1506,7 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	mutex_lock(&vhost_scsi_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
-	for (index = 0; index < vs->dev.nvqs; ++index) {
+	for (index = 0; index < vs->dev.max_nvqs; ++index) {
 		if (!vhost_vq_access_ok(&vs->vqs[index].vq)) {
 			ret = -EFAULT;
 			goto err_dev;
@@ -1551,6 +1554,9 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	if (match) {
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
+			if (!vq->initialized)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, NULL);
 			mutex_unlock(&vq->mutex);
@@ -1632,8 +1638,13 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vqs[i] = &vs->vqs[i].vq;
 		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
 	}
-	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, VHOST_SCSI_MAX_VQ,
-			   UIO_MAXIOV, VHOST_SCSI_WEIGHT, 0, true, NULL))
+
+	/*
+	 * We will always need the ctl, evt and at least 1 IO vq. Create more
+	 * IO vqs if userspace requests them.
+	 */
+	if (vhost_dev_init(&vs->dev, vqs, 3, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+			   VHOST_SCSI_WEIGHT, 0, true, NULL))
 		goto err_dev_init;
 
 	vhost_scsi_init_inflight(vs, NULL);
-- 
1.8.3.1
