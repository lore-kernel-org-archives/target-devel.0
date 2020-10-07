From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 07 Oct 2020 20:54:56 +0000
Subject: [PATCH 11/16] vhost scsi: remove extra flushes
Message-Id: <1602104101-5592-12-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The vhost work flush function was flushing the entire work queue, so
there is no need for the double vhost_work_dev_flush calls in
vhost_scsi_flush.

And we do not need to call vhost_poll_flush for each poller because
that call also ends up flushing the same work queue thread the
vhost_work_dev_flush call flushed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f543fa0..b348e9c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1443,11 +1443,6 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
 	vhost_scsi_handle_vq(vs, vq);
 }
 
-static void vhost_scsi_flush_vq(struct vhost_scsi *vs, int index)
-{
-	vhost_poll_flush(&vs->vqs[index].vq.poll);
-}
-
 /* Callers must hold dev mutex */
 static void vhost_scsi_flush(struct vhost_scsi *vs)
 {
@@ -1466,9 +1461,6 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
 
 	/* Flush both the vhost poll and vhost work */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
-		vhost_scsi_flush_vq(vs, i);
-	vhost_work_dev_flush(&vs->dev);
 	vhost_work_dev_flush(&vs->dev);
 
 	/* Wait for all reqs issued before the flush to be finished */
-- 
1.8.3.1
