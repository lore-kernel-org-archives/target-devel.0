From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 18 Sep 2018 00:09:48 +0000
Subject: [PATCH 2/3] vhost/scsi: Extract common handling code from control queue handler
Message-Id: <1537229389-16176-3-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Prepare to change the request queue handler to use common handling
routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 drivers/vhost/scsi.c | 271 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 172 insertions(+), 99 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index faf0dcf..d8c7612 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -203,6 +203,19 @@ struct vhost_scsi {
 	int vs_events_nr; /* num of pending events, protected by vq->mutex */
 };
 
+/*
+ * Context for processing request and control queue operations.
+ */
+struct vhost_scsi_ctx {
+	int head;
+	unsigned int out, in;
+	size_t req_size, rsp_size;
+	size_t out_size, in_size;
+	u8 *target, *lunp;
+	void *req;
+	struct iov_iter out_iter;
+};
+
 static struct workqueue_struct *vhost_scsi_workqueue;
 
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
@@ -1048,10 +1061,107 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	mutex_unlock(&vq->mutex);
 }
 
+static int
+vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
+		    struct vhost_scsi_ctx *vc)
+{
+	int ret = -ENXIO;
+
+	vc->head = vhost_get_vq_desc(vq, vq->iov,
+				     ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
+				     NULL, NULL);
+
+	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
+		 vc->head, vc->out, vc->in);
+
+	/* On error, stop handling until the next kick. */
+	if (unlikely(vc->head < 0))
+		goto done;
+
+	/* Nothing new?  Wait for eventfd to tell us they refilled. */
+	if (vc->head = vq->num) {
+		if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
+			vhost_disable_notify(&vs->dev, vq);
+			ret = -EAGAIN;
+		}
+		goto done;
+	}
+
+	/*
+	 * Get the size of request and response buffers.
+	 */
+	vc->out_size = iov_length(vq->iov, vc->out);
+	vc->in_size = iov_length(&vq->iov[vc->out], vc->in);
+
+	/*
+	 * Copy over the virtio-scsi request header, which for a
+	 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
+	 * single iovec may contain both the header + outgoing
+	 * WRITE payloads.
+	 *
+	 * copy_from_iter() will advance out_iter, so that it will
+	 * point at the start of the outgoing WRITE payload, if
+	 * DMA_TO_DEVICE is set.
+	 */
+	iov_iter_init(&vc->out_iter, WRITE, vq->iov, vc->out, vc->out_size);
+	ret = 0;
+
+done:
+	return ret;
+}
+
+static int
+vhost_scsi_chk_size(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc)
+{
+	if (unlikely(vc->in_size < vc->rsp_size)) {
+		vq_err(vq,
+		       "Response buf too small, need min %zu bytes got %zu",
+		       vc->rsp_size, vc->in_size);
+		return -EINVAL;
+	} else if (unlikely(vc->out_size < vc->req_size)) {
+		vq_err(vq,
+		       "Request buf too small, need min %zu bytes got %zu",
+		       vc->req_size, vc->out_size);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int
+vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
+		   struct vhost_scsi_tpg **tpgp)
+{
+	int ret = -EIO;
+
+	if (unlikely(!copy_from_iter_full(vc->req, vc->req_size,
+					  &vc->out_iter)))
+		vq_err(vq, "Faulted on copy_from_iter\n");
+	else if (unlikely(*vc->lunp != 1))
+		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
+		vq_err(vq, "Illegal virtio-scsi lun: %u\n", *vc->lunp);
+	else {
+		struct vhost_scsi_tpg **vs_tpg, *tpg;
+
+		vs_tpg = vq->private_data;	/* validated at handler entry */
+
+		tpg = READ_ONCE(vs_tpg[*vc->target]);
+		if (unlikely(!tpg))
+			vq_err(vq, "Target 0x%x does not exist\n", *vc->target);
+		else {
+			if (tpgp)
+				*tpgp = tpg;
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
 static void
 vhost_scsi_send_tmf_resp(struct vhost_scsi *vs,
-			   struct vhost_virtqueue *vq,
-			   int head, unsigned int out)
+			 struct vhost_virtqueue *vq,
+			 struct vhost_scsi_ctx *vc)
 {
 	struct virtio_scsi_ctrl_tmf_resp __user *resp;
 	struct virtio_scsi_ctrl_tmf_resp rsp;
@@ -1060,18 +1170,18 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	pr_debug("%s\n", __func__);
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = VIRTIO_SCSI_S_FUNCTION_REJECTED;
-	resp = vq->iov[out].iov_base;
+	resp = vq->iov[vc->out].iov_base;
 	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
 }
 
 static void
 vhost_scsi_send_an_resp(struct vhost_scsi *vs,
-			   struct vhost_virtqueue *vq,
-			   int head, unsigned int out)
+			struct vhost_virtqueue *vq,
+			struct vhost_scsi_ctx *vc)
 {
 	struct virtio_scsi_ctrl_an_resp __user *resp;
 	struct virtio_scsi_ctrl_an_resp rsp;
@@ -1080,10 +1190,10 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	pr_debug("%s\n", __func__);
 	memset(&rsp, 0, sizeof(rsp));	/* event_actual = 0 */
 	rsp.response = VIRTIO_SCSI_S_OK;
-	resp = vq->iov[out].iov_base;
+	resp = vq->iov[vc->out].iov_base;
 	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_an_resp\n");
 }
@@ -1096,13 +1206,9 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		struct virtio_scsi_ctrl_an_req an;
 		struct virtio_scsi_ctrl_tmf_req tmf;
 	} v_req;
-	struct iov_iter out_iter;
-	unsigned int out = 0, in = 0;
-	int head;
-	size_t req_size, rsp_size, typ_size;
-	size_t out_size, in_size;
-	u8 *lunp;
-	void *req;
+	struct vhost_scsi_ctx vc;
+	size_t typ_size;
+	int ret;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1112,52 +1218,28 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	if (!vq->private_data)
 		goto out;
 
+	memset(&vc, 0, sizeof(vc));
+
 	vhost_disable_notify(&vs->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov), &out, &in,
-					 NULL, NULL);
-		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-			 head, out, in);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
-			break;
-		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head = vq->num) {
-			if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
-				vhost_disable_notify(&vs->dev, vq);
-				continue;
-			}
-			break;
-		}
+		ret = vhost_scsi_get_desc(vs, vq, &vc);
+		if (ret)
+			goto err;
 
 		/*
-		 * Get the size of request and response buffers.
+		 * Get the request type first in order to setup
+		 * other parameters dependent on the type.
 		 */
-		out_size = iov_length(vq->iov, out);
-		in_size = iov_length(&vq->iov[out], in);
-
-		/*
-		 * Copy over the virtio-scsi request header, which for a
-		 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
-		 * single iovec may contain both the header + outgoing
-		 * WRITE payloads.
-		 *
-		 * copy_from_iter() will advance out_iter, so that it will
-		 * point at the start of the outgoing WRITE payload, if
-		 * DMA_TO_DEVICE is set.
-		 */
-		iov_iter_init(&out_iter, WRITE, vq->iov, out, out_size);
-
-		req = &v_req.type;
+		vc.req = &v_req.type;
 		typ_size = sizeof(v_req.type);
 
-		if (unlikely(!copy_from_iter_full(req, typ_size, &out_iter))) {
+		if (unlikely(!copy_from_iter_full(vc.req, typ_size,
+						  &vc.out_iter))) {
 			vq_err(vq, "Faulted on copy_from_iter tmf type\n");
 			/*
-			 * The size of the response buffer varies based on
-			 * the request type and must be validated against it.
+			 * The size of the response buffer depends on the
+			 * request type and must be validated against it.
 			 * Since the request type is not known, don't send
 			 * a response.
 			 */
@@ -1166,17 +1248,19 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 
 		switch (v_req.type) {
 		case VIRTIO_SCSI_T_TMF:
-			req = &v_req.tmf;
-			lunp = &v_req.tmf.lun[0];
-			req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);
-			rsp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+			vc.req = &v_req.tmf;
+			vc.req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);
+			vc.rsp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+			vc.lunp = &v_req.tmf.lun[0];
+			vc.target = &v_req.tmf.lun[1];
 			break;
 		case VIRTIO_SCSI_T_AN_QUERY:
 		case VIRTIO_SCSI_T_AN_SUBSCRIBE:
-			req = &v_req.an;
-			lunp = &v_req.an.lun[0];
-			req_size = sizeof(struct virtio_scsi_ctrl_an_req);
-			rsp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+			vc.req = &v_req.an;
+			vc.req_size = sizeof(struct virtio_scsi_ctrl_an_req);
+			vc.rsp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+			vc.lunp = &v_req.an.lun[0];
+			vc.target = NULL;
 			break;
 		default:
 			vq_err(vq, "Unknown control request %d", v_req.type);
@@ -1184,50 +1268,39 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		}
 
 		/*
-		 * Check for a sane response buffer so we can report early
-		 * errors back to the guest.
+		 * Validate the size of request and response buffers.
+		 * Check for a sane response buffer so we can report
+		 * early errors back to the guest.
 		 */
-		if (unlikely(in_size < rsp_size)) {
-			vq_err(vq,
-			       "Resp buf too small, need min %zu bytes got %zu",
-			       rsp_size, in_size);
-			/*
-			 * Notifications are disabled at this point;
-			 * continue so they can be eventually enabled
-			 * when processing terminates.
-			 */
-			continue;
-		}
+		ret = vhost_scsi_chk_size(vq, &vc);
+		if (ret)
+			goto err;
 
-		if (unlikely(out_size < req_size)) {
-			vq_err(vq,
-			       "Req buf too small, need min %zu bytes got %zu",
-			       req_size, out_size);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-
-		req += typ_size;
-		req_size -= typ_size;
-
-		if (unlikely(!copy_from_iter_full(req, req_size, &out_iter))) {
-			vq_err(vq, "Faulted on copy_from_iter\n");
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
+		/*
+		 * Get the rest of the request now that its size is known.
+		 */
+		vc.req += typ_size;
+		vc.req_size -= typ_size;
 
-		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
-		if (unlikely(*lunp != 1)) {
-			vq_err(vq, "Illegal virtio-scsi lun: %u\n", *lunp);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
+		ret = vhost_scsi_get_req(vq, &vc, NULL);
+		if (ret)
+			goto err;
 
-		if (v_req.type = VIRTIO_SCSI_T_TMF) {
-			pr_debug("%s tmf %d\n", __func__, v_req.tmf.subtype);
-			vhost_scsi_send_tmf_resp(vs, vq, head, out);
-		} else
-			vhost_scsi_send_an_resp(vs, vq, head, out);
+		if (v_req.type = VIRTIO_SCSI_T_TMF)
+			vhost_scsi_send_tmf_resp(vs, vq, &vc);
+		else
+			vhost_scsi_send_an_resp(vs, vq, &vc);
+err:
+		/*
+		 * ENXIO:  No more requests, or read error, wait for next kick
+		 * EINVAL: Invalid response buffer, drop the request
+		 * EIO:    Respond with bad target
+		 * EAGAIN: Pending request
+		 */
+		if (ret = -ENXIO)
+			break;
+		else if (ret = -EIO)
+			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
 	}
 out:
 	mutex_unlock(&vq->mutex);
-- 
1.8.3.1
