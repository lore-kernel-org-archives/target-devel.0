From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:07 +0000
Subject: [PATCH 07/10] vhost, vhost-scsi: flush IO vqs then send TMF rsp
Message-Id: <1605223150-10888-9-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

With one worker we will always send the scsi cmd responses then send the
TMF rsp, because LIO will always complete the scsi cmds first which
calls vhost_scsi_release_cmd to add them to the work queue.

When the next patch adds multiple worker support, the worker threads
could still be sending their responses when the tmf's work is run.
So this patch has vhost-scsi flush the IO vqs on other worker threads
before we send the tmf response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c  | 16 ++++++++++++++--
 drivers/vhost/vhost.c |  6 ++++++
 drivers/vhost/vhost.h |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 2bbe1a8..612359d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1178,11 +1178,23 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
 						  vwork);
 	int resp_code;
+	int i;
+
+	if (tmf->se_cmd.se_tmr_req->response = TMR_FUNCTION_COMPLETE) {
+		/*
+		 * When processing a TMF, lio completes the cmds then the
+		 * TMF, so with one worker the TMF always completes after
+		 * cmds. For multiple worker support, we must flush the
+		 * IO vqs that do not share a worker with the ctl vq (vqs
+		 * 3 and up) to make sure they have completed their cmds.
+		 */
+		for (i = 1; i < tmf->vhost->dev.num_workers; i++)
+			vhost_vq_work_flush(&tmf->vhost->vqs[i + VHOST_SCSI_VQ_IO].vq);
 
-	if (tmf->se_cmd.se_tmr_req->response = TMR_FUNCTION_COMPLETE)
 		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
-	else
+	} else {
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	}
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9eeb8c7..6a6abfc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -278,6 +278,12 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
+void vhost_vq_work_flush(struct vhost_virtqueue *vq)
+{
+	vhost_work_flush_on(vq->dev, vq->worker_id);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_work_flush);
+
 /* Flush any work that has been scheduled. When calling this, don't hold any
  * locks that are also used by the callback. */
 void vhost_poll_flush(struct vhost_poll *poll)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 232c5f9..0837133 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -46,6 +46,7 @@ struct vhost_poll {
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
+void vhost_vq_work_flush(struct vhost_virtqueue *vq);
 void vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 int vhost_vq_worker_add(struct vhost_dev *dev, struct vhost_virtqueue *vq);
 void vhost_vq_worker_remove(struct vhost_dev *dev, struct vhost_virtqueue *vq);
-- 
1.8.3.1
