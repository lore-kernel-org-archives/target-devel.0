From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 18 Sep 2018 00:09:49 +0000
Subject: [PATCH 3/3] vhost/scsi: Use common handling code in request queue handler
Message-Id: <1537229389-16176-4-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Change the request queue handler to use common handling routines same
as the control queue handler.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 drivers/vhost/scsi.c | 361 +++++++++++++++++++++++----------------------------
 1 file changed, 164 insertions(+), 197 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d8c7612..3eae17e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -813,24 +813,120 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
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
+	 * FIXME: Not correct for BIDI operation
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
+					  &vc->out_iter))) {
+		vq_err(vq, "Faulted on copy_from_iter\n");
+	} else if (unlikely(*vc->lunp != 1)) {
+		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
+		vq_err(vq, "Illegal virtio-scsi lun: %u\n", *vc->lunp);
+	} else {
+		struct vhost_scsi_tpg **vs_tpg, *tpg;
+
+		vs_tpg = vq->private_data;	/* validated at handler entry */
+
+		tpg = READ_ONCE(vs_tpg[*vc->target]);
+		if (unlikely(!tpg)) {
+			vq_err(vq, "Target 0x%x does not exist\n", *vc->target);
+		} else {
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
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
 	struct vhost_scsi_tpg **vs_tpg, *tpg;
 	struct virtio_scsi_cmd_req v_req;
 	struct virtio_scsi_cmd_req_pi v_req_pi;
+	struct vhost_scsi_ctx vc;
 	struct vhost_scsi_cmd *cmd;
-	struct iov_iter out_iter, in_iter, prot_iter, data_iter;
+	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	unsigned int out = 0, in = 0;
-	int head, ret, prot_bytes;
-	size_t req_size, rsp_size = sizeof(struct virtio_scsi_cmd_resp);
-	size_t out_size, in_size;
+	int ret, prot_bytes;
 	u16 lun;
-	u8 *target, *lunp, task_attr;
+	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
-	void *req, *cdb;
+	void *cdb;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -841,85 +937,47 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	if (!vs_tpg)
 		goto out;
 
+	memset(&vc, 0, sizeof(vc));
+	vc.rsp_size = sizeof(struct virtio_scsi_cmd_resp);
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
-		/*
-		 * Check for a sane response buffer so we can report early
-		 * errors back to the guest.
-		 */
-		if (unlikely(vq->iov[out].iov_len < rsp_size)) {
-			vq_err(vq, "Expecting at least virtio_scsi_cmd_resp"
-				" size, got %zu bytes\n", vq->iov[out].iov_len);
-			break;
-		}
+		ret = vhost_scsi_get_desc(vs, vq, &vc);
+		if (ret)
+			goto err;
+
 		/*
 		 * Setup pointers and values based upon different virtio-scsi
 		 * request header if T10_PI is enabled in KVM guest.
 		 */
 		if (t10_pi) {
-			req = &v_req_pi;
-			req_size = sizeof(v_req_pi);
-			lunp = &v_req_pi.lun[0];
-			target = &v_req_pi.lun[1];
+			vc.req = &v_req_pi;
+			vc.req_size = sizeof(v_req_pi);
+			vc.lunp = &v_req_pi.lun[0];
+			vc.target = &v_req_pi.lun[1];
 		} else {
-			req = &v_req;
-			req_size = sizeof(v_req);
-			lunp = &v_req.lun[0];
-			target = &v_req.lun[1];
+			vc.req = &v_req;
+			vc.req_size = sizeof(v_req);
+			vc.lunp = &v_req.lun[0];
+			vc.target = &v_req.lun[1];
 		}
-		/*
-		 * FIXME: Not correct for BIDI operation
-		 */
-		out_size = iov_length(vq->iov, out);
-		in_size = iov_length(&vq->iov[out], in);
 
 		/*
-		 * Copy over the virtio-scsi request header, which for a
-		 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
-		 * single iovec may contain both the header + outgoing
-		 * WRITE payloads.
-		 *
-		 * copy_from_iter() will advance out_iter, so that it will
-		 * point at the start of the outgoing WRITE payload, if
-		 * DMA_TO_DEVICE is set.
+		 * Validate the size of request and response buffers.
+		 * Check for a sane response buffer so we can report
+		 * early errors back to the guest.
 		 */
-		iov_iter_init(&out_iter, WRITE, vq->iov, out, out_size);
+		ret = vhost_scsi_chk_size(vq, &vc);
+		if (ret)
+			goto err;
 
-		if (unlikely(!copy_from_iter_full(req, req_size, &out_iter))) {
-			vq_err(vq, "Faulted on copy_from_iter\n");
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
-		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
-		if (unlikely(*lunp != 1)) {
-			vq_err(vq, "Illegal virtio-scsi lun: %u\n", *lunp);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
+		ret = vhost_scsi_get_req(vq, &vc, &tpg);
+		if (ret)
+			goto err;
+
+		ret = -EIO;	/* bad target on any error from here on */
 
-		tpg = READ_ONCE(vs_tpg[*target]);
-		if (unlikely(!tpg)) {
-			/* Target does not exist, fail the request */
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
-		}
 		/*
 		 * Determine data_direction by calculating the total outgoing
 		 * iovec sizes + incoming iovec sizes vs. virtio-scsi request +
@@ -937,17 +995,17 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		 */
 		prot_bytes = 0;
 
-		if (out_size > req_size) {
+		if (vc.out_size > vc.req_size) {
 			data_direction = DMA_TO_DEVICE;
-			exp_data_len = out_size - req_size;
-			data_iter = out_iter;
-		} else if (in_size > rsp_size) {
+			exp_data_len = vc.out_size - vc.req_size;
+			data_iter = vc.out_iter;
+		} else if (vc.in_size > vc.rsp_size) {
 			data_direction = DMA_FROM_DEVICE;
-			exp_data_len = in_size - rsp_size;
+			exp_data_len = vc.in_size - vc.rsp_size;
 
-			iov_iter_init(&in_iter, READ, &vq->iov[out], in,
-				      rsp_size + exp_data_len);
-			iov_iter_advance(&in_iter, rsp_size);
+			iov_iter_init(&in_iter, READ, &vq->iov[vc.out], vc.in,
+				      vc.rsp_size + exp_data_len);
+			iov_iter_advance(&in_iter, vc.rsp_size);
 			data_iter = in_iter;
 		} else {
 			data_direction = DMA_NONE;
@@ -963,16 +1021,14 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 				if (data_direction != DMA_TO_DEVICE) {
 					vq_err(vq, "Received non zero pi_bytesout,"
 						" but wrong data_direction\n");
-					vhost_scsi_send_bad_target(vs, vq, head, out);
-					continue;
+					goto err;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesout);
 			} else if (v_req_pi.pi_bytesin) {
 				if (data_direction != DMA_FROM_DEVICE) {
 					vq_err(vq, "Received non zero pi_bytesin,"
 						" but wrong data_direction\n");
-					vhost_scsi_send_bad_target(vs, vq, head, out);
-					continue;
+					goto err;
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
 			}
@@ -1009,8 +1065,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			vq_err(vq, "Received SCSI CDB with command_size: %d that"
 				" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 				scsi_command_size(cdb), VHOST_SCSI_MAX_CDB_SIZE);
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
+				goto err;
 		}
 		cmd = vhost_scsi_get_tag(vq, tpg, cdb, tag, lun, task_attr,
 					 exp_data_len + prot_bytes,
@@ -1018,13 +1073,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		if (IS_ERR(cmd)) {
 			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
 			       PTR_ERR(cmd));
-			vhost_scsi_send_bad_target(vs, vq, head, out);
-			continue;
+			goto err;
 		}
 		cmd->tvc_vhost = vs;
 		cmd->tvc_vq = vq;
-		cmd->tvc_resp_iov = vq->iov[out];
-		cmd->tvc_in_iovs = in;
+		cmd->tvc_resp_iov = vq->iov[vc.out];
+		cmd->tvc_in_iovs = vc.in;
 
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cmd->tvc_cdb[0], cmd->tvc_lun);
@@ -1032,14 +1086,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			 " %d\n", cmd, exp_data_len, prot_bytes, data_direction);
 
 		if (data_direction != DMA_NONE) {
-			ret = vhost_scsi_mapal(cmd,
-					       prot_bytes, &prot_iter,
-					       exp_data_len, &data_iter);
-			if (unlikely(ret)) {
+			if (unlikely(vhost_scsi_mapal(cmd, prot_bytes,
+						      &prot_iter, exp_data_len,
+						      &data_iter))) {
 				vq_err(vq, "Failed to map iov to sgl\n");
 				vhost_scsi_release_cmd(&cmd->tvc_se_cmd);
-				vhost_scsi_send_bad_target(vs, vq, head, out);
-				continue;
+				goto err;
 			}
 		}
 		/*
@@ -1047,7 +1099,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		 * complete the virtio-scsi request in TCM callback context via
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
-		cmd->tvc_vq_desc = head;
+		cmd->tvc_vq_desc = vc.head;
 		/*
 		 * Dispatch cmd descriptor for cmwq execution in process
 		 * context provided by vhost_scsi_workqueue.  This also ensures
@@ -1056,112 +1108,27 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		 */
 		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
 		queue_work(vhost_scsi_workqueue, &cmd->work);
+		ret = 0;
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
 }
 
-static int
-vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-		    struct vhost_scsi_ctx *vc)
-{
-	int ret = -ENXIO;
-
-	vc->head = vhost_get_vq_desc(vq, vq->iov,
-				     ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
-				     NULL, NULL);
-
-	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-		 vc->head, vc->out, vc->in);
-
-	/* On error, stop handling until the next kick. */
-	if (unlikely(vc->head < 0))
-		goto done;
-
-	/* Nothing new?  Wait for eventfd to tell us they refilled. */
-	if (vc->head = vq->num) {
-		if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
-			vhost_disable_notify(&vs->dev, vq);
-			ret = -EAGAIN;
-		}
-		goto done;
-	}
-
-	/*
-	 * Get the size of request and response buffers.
-	 */
-	vc->out_size = iov_length(vq->iov, vc->out);
-	vc->in_size = iov_length(&vq->iov[vc->out], vc->in);
-
-	/*
-	 * Copy over the virtio-scsi request header, which for a
-	 * ANY_LAYOUT enabled guest may span multiple iovecs, or a
-	 * single iovec may contain both the header + outgoing
-	 * WRITE payloads.
-	 *
-	 * copy_from_iter() will advance out_iter, so that it will
-	 * point at the start of the outgoing WRITE payload, if
-	 * DMA_TO_DEVICE is set.
-	 */
-	iov_iter_init(&vc->out_iter, WRITE, vq->iov, vc->out, vc->out_size);
-	ret = 0;
-
-done:
-	return ret;
-}
-
-static int
-vhost_scsi_chk_size(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc)
-{
-	if (unlikely(vc->in_size < vc->rsp_size)) {
-		vq_err(vq,
-		       "Response buf too small, need min %zu bytes got %zu",
-		       vc->rsp_size, vc->in_size);
-		return -EINVAL;
-	} else if (unlikely(vc->out_size < vc->req_size)) {
-		vq_err(vq,
-		       "Request buf too small, need min %zu bytes got %zu",
-		       vc->req_size, vc->out_size);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static int
-vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
-		   struct vhost_scsi_tpg **tpgp)
-{
-	int ret = -EIO;
-
-	if (unlikely(!copy_from_iter_full(vc->req, vc->req_size,
-					  &vc->out_iter)))
-		vq_err(vq, "Faulted on copy_from_iter\n");
-	else if (unlikely(*vc->lunp != 1))
-		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
-		vq_err(vq, "Illegal virtio-scsi lun: %u\n", *vc->lunp);
-	else {
-		struct vhost_scsi_tpg **vs_tpg, *tpg;
-
-		vs_tpg = vq->private_data;	/* validated at handler entry */
-
-		tpg = READ_ONCE(vs_tpg[*vc->target]);
-		if (unlikely(!tpg))
-			vq_err(vq, "Target 0x%x does not exist\n", *vc->target);
-		else {
-			if (tpgp)
-				*tpgp = tpg;
-			ret = 0;
-		}
-	}
-
-	return ret;
-}
-
 static void
-vhost_scsi_send_tmf_resp(struct vhost_scsi *vs,
-			 struct vhost_virtqueue *vq,
-			 struct vhost_scsi_ctx *vc)
+vhost_scsi_send_tmf_reject(struct vhost_scsi *vs,
+			   struct vhost_virtqueue *vq,
+			   struct vhost_scsi_ctx *vc)
 {
 	struct virtio_scsi_ctrl_tmf_resp __user *resp;
 	struct virtio_scsi_ctrl_tmf_resp rsp;
@@ -1287,7 +1254,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			goto err;
 
 		if (v_req.type = VIRTIO_SCSI_T_TMF)
-			vhost_scsi_send_tmf_resp(vs, vq, &vc);
+			vhost_scsi_send_tmf_reject(vs, vq, &vc);
 		else
 			vhost_scsi_send_an_resp(vs, vq, &vc);
 err:
-- 
1.8.3.1
