From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 04 Dec 2018 00:48:20 +0000
Subject: [PATCH v2 1/4] vhost/scsi: Respond to control queue operations
Message-Id: <1543884503-32281-2-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The vhost-scsi driver currently does not handle any control queue
operations. In particular, vhost_scsi_ctl_handle_kick, merely prints out
a debug message but does nothing else. This can cause guest VMs to hang.

As part of SCSI recovery from an error, e.g., an I/O timeout, the SCSI
midlayer attempts to abort the failed operation. The SCSI virtio driver
translates the abort to a SCSI TMF request that gets put on the control
queue (virtscsi_abort -> virtscsi_tmf). The SCSI virtio driver then
waits indefinitely for this request to be completed, but it never will
because vhost-scsi never responds to that request.

To avoid a hang, always respond to control queue operations; explicitly
reject TMF requests, and return a no-op response to event requests.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 drivers/vhost/scsi.c | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 190 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c24bb69..faf0dcf 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1048,9 +1048,199 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	mutex_unlock(&vq->mutex);
 }
 
+static void
+vhost_scsi_send_tmf_resp(struct vhost_scsi *vs,
+			   struct vhost_virtqueue *vq,
+			   int head, unsigned int out)
+{
+	struct virtio_scsi_ctrl_tmf_resp __user *resp;
+	struct virtio_scsi_ctrl_tmf_resp rsp;
+	int ret;
+
+	pr_debug("%s\n", __func__);
+	memset(&rsp, 0, sizeof(rsp));
+	rsp.response = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	resp = vq->iov[out].iov_base;
+	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
+	if (!ret)
+		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+	else
+		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
+}
+
+static void
+vhost_scsi_send_an_resp(struct vhost_scsi *vs,
+			   struct vhost_virtqueue *vq,
+			   int head, unsigned int out)
+{
+	struct virtio_scsi_ctrl_an_resp __user *resp;
+	struct virtio_scsi_ctrl_an_resp rsp;
+	int ret;
+
+	pr_debug("%s\n", __func__);
+	memset(&rsp, 0, sizeof(rsp));	/* event_actual = 0 */
+	rsp.response = VIRTIO_SCSI_S_OK;
+	resp = vq->iov[out].iov_base;
+	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
+	if (!ret)
+		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+	else
+		pr_err("Faulted on virtio_scsi_ctrl_an_resp\n");
+}
+
+static void
+vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
+{
+	union {
+		__virtio32 type;
+		struct virtio_scsi_ctrl_an_req an;
+		struct virtio_scsi_ctrl_tmf_req tmf;
+	} v_req;
+	struct iov_iter out_iter;
+	unsigned int out = 0, in = 0;
+	int head;
+	size_t req_size, rsp_size, typ_size;
+	size_t out_size, in_size;
+	u8 *lunp;
+	void *req;
+
+	mutex_lock(&vq->mutex);
+	/*
+	 * We can handle the vq only after the endpoint is setup by calling the
+	 * VHOST_SCSI_SET_ENDPOINT ioctl.
+	 */
+	if (!vq->private_data)
+		goto out;
+
+	vhost_disable_notify(&vs->dev, vq);
+
+	for (;;) {
+		head = vhost_get_vq_desc(vq, vq->iov,
+					 ARRAY_SIZE(vq->iov), &out, &in,
+					 NULL, NULL);
+		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
+			 head, out, in);
+		/* On error, stop handling until the next kick. */
+		if (unlikely(head < 0))
+			break;
+		/* Nothing new?  Wait for eventfd to tell us they refilled. */
+		if (head = vq->num) {
+			if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
+				vhost_disable_notify(&vs->dev, vq);
+				continue;
+			}
+			break;
+		}
+
+		/*
+		 * Get the size of request and response buffers.
+		 */
+		out_size = iov_length(vq->iov, out);
+		in_size = iov_length(&vq->iov[out], in);
+
+		/*
+		 * Copy over the virtio-scsi request header, which for a
+		 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
+		 * single iovec may contain both the header + outgoing
+		 * WRITE payloads.
+		 *
+		 * copy_from_iter() will advance out_iter, so that it will
+		 * point at the start of the outgoing WRITE payload, if
+		 * DMA_TO_DEVICE is set.
+		 */
+		iov_iter_init(&out_iter, WRITE, vq->iov, out, out_size);
+
+		req = &v_req.type;
+		typ_size = sizeof(v_req.type);
+
+		if (unlikely(!copy_from_iter_full(req, typ_size, &out_iter))) {
+			vq_err(vq, "Faulted on copy_from_iter tmf type\n");
+			/*
+			 * The size of the response buffer varies based on
+			 * the request type and must be validated against it.
+			 * Since the request type is not known, don't send
+			 * a response.
+			 */
+			continue;
+		}
+
+		switch (v_req.type) {
+		case VIRTIO_SCSI_T_TMF:
+			req = &v_req.tmf;
+			lunp = &v_req.tmf.lun[0];
+			req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);
+			rsp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+			break;
+		case VIRTIO_SCSI_T_AN_QUERY:
+		case VIRTIO_SCSI_T_AN_SUBSCRIBE:
+			req = &v_req.an;
+			lunp = &v_req.an.lun[0];
+			req_size = sizeof(struct virtio_scsi_ctrl_an_req);
+			rsp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+			break;
+		default:
+			vq_err(vq, "Unknown control request %d", v_req.type);
+			continue;
+		}
+
+		/*
+		 * Check for a sane response buffer so we can report early
+		 * errors back to the guest.
+		 */
+		if (unlikely(in_size < rsp_size)) {
+			vq_err(vq,
+			       "Resp buf too small, need min %zu bytes got %zu",
+			       rsp_size, in_size);
+			/*
+			 * Notifications are disabled at this point;
+			 * continue so they can be eventually enabled
+			 * when processing terminates.
+			 */
+			continue;
+		}
+
+		if (unlikely(out_size < req_size)) {
+			vq_err(vq,
+			       "Req buf too small, need min %zu bytes got %zu",
+			       req_size, out_size);
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
+		req += typ_size;
+		req_size -= typ_size;
+
+		if (unlikely(!copy_from_iter_full(req, req_size, &out_iter))) {
+			vq_err(vq, "Faulted on copy_from_iter\n");
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
+		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
+		if (unlikely(*lunp != 1)) {
+			vq_err(vq, "Illegal virtio-scsi lun: %u\n", *lunp);
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
+		if (v_req.type = VIRTIO_SCSI_T_TMF) {
+			pr_debug("%s tmf %d\n", __func__, v_req.tmf.subtype);
+			vhost_scsi_send_tmf_resp(vs, vq, head, out);
+		} else
+			vhost_scsi_send_an_resp(vs, vq, head, out);
+	}
+out:
+	mutex_unlock(&vq->mutex);
+}
+
 static void vhost_scsi_ctl_handle_kick(struct vhost_work *work)
 {
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						poll.work);
+	struct vhost_scsi *vs = container_of(vq->dev, struct vhost_scsi, dev);
+
 	pr_debug("%s: The handling func for control queue.\n", __func__);
+	vhost_scsi_ctl_handle_vq(vs, vq);
 }
 
 static void
-- 
1.8.3.1
