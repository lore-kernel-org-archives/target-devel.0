From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:34:56 +0000
Subject: [PATCH 10/17] vhost scsi: Add support for LUN resets.
Message-Id: <1603326903-27052-11-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

In newer versions of virtio-scsi we just reset the timer when an a
command times out, so TMFs are never sent for the cmd time out case.
However, in older kernels and for the TMF inject cases, we can still get
resets and we end up just failing immediately so the guest might see the
device get offlined and IO errors.

For the older kernel cases, we want the same end result as the
modern virtio-scsi driver where we let the lower levels fire their error
handling and handle the problem. And at the upper levels we want to
wait. This patch ties the LUN reset handling into the LIO TMF code which
will just wait for outstanding commands to complete like we are doing in
the modern virtio-scsi case.

Note: I did not handle the ABORT case to keep this simple. For ABORTs
LIO just waits on the cmd like how it does for the RESET case. If
an ABORT fails, the guest OS ends up escalating to LUN RESET, so in
the end we get the same behavior where we wait on the outstanding
cmds.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 134 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 2fa48dd..f543fa0 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -139,6 +139,7 @@ struct vhost_scsi_tpg {
 	struct se_portal_group se_tpg;
 	/* Pointer back to vhost_scsi, protected by tv_tpg_mutex */
 	struct vhost_scsi *vhost_scsi;
+	struct list_head tmf_queue;
 };
 
 struct vhost_scsi_tport {
@@ -211,6 +212,20 @@ struct vhost_scsi {
 	int vs_events_nr; /* num of pending events, protected by vq->mutex */
 };
 
+struct vhost_scsi_tmf {
+	struct vhost_work vwork;
+	struct vhost_scsi_tpg *tpg;
+	struct vhost_scsi *vhost;
+	struct vhost_scsi_virtqueue *svq;
+	struct list_head queue_entry;
+
+	struct se_cmd se_cmd;
+	struct vhost_scsi_inflight *inflight;
+	struct iovec resp_iov;
+	int in_iovs;
+	int vq_desc;
+};
+
 /*
  * Context for processing request and control queue operations.
  */
@@ -344,14 +359,32 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 	vhost_scsi_put_inflight(inflight);
 }
 
+static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
+{
+	struct vhost_scsi_tpg *tpg = tmf->tpg;
+	struct vhost_scsi_inflight *inflight = tmf->inflight;
+
+	mutex_lock(&tpg->tv_tpg_mutex);
+	list_add_tail(&tpg->tmf_queue, &tmf->queue_entry);
+	mutex_unlock(&tpg->tv_tpg_mutex);
+	vhost_scsi_put_inflight(inflight);
+}
+
 static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 {
-	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
+		struct vhost_scsi_tmf *tmf = container_of(se_cmd,
+					struct vhost_scsi_tmf, se_cmd);
+
+		vhost_work_queue(&tmf->vhost->dev, &tmf->vwork);
+	} else {
+		struct vhost_scsi_cmd *cmd = container_of(se_cmd,
 					struct vhost_scsi_cmd, tvc_se_cmd);
-	struct vhost_scsi *vs = cmd->tvc_vhost;
+		struct vhost_scsi *vs = cmd->tvc_vhost;
 
-	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
-	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+		llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
+		vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+	}
 }
 
 static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
@@ -390,7 +423,10 @@ static int vhost_scsi_queue_status(struct se_cmd *se_cmd)
 
 static void vhost_scsi_queue_tm_rsp(struct se_cmd *se_cmd)
 {
-	return;
+	struct vhost_scsi_tmf *tmf = container_of(se_cmd, struct vhost_scsi_tmf,
+						  se_cmd);
+
+	transport_generic_free_cmd(&tmf->se_cmd, 0);
 }
 
 static void vhost_scsi_aborted_task(struct se_cmd *se_cmd)
@@ -1120,9 +1156,9 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 }
 
 static void
-vhost_scsi_send_tmf_reject(struct vhost_scsi *vs,
-			   struct vhost_virtqueue *vq,
-			   struct vhost_scsi_ctx *vc)
+vhost_scsi_send_tmf_resp(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
+			 int in_iovs, int vq_desc, struct iovec *resp_iov,
+			 int tmf_resp_code)
 {
 	struct virtio_scsi_ctrl_tmf_resp rsp;
 	struct iov_iter iov_iter;
@@ -1130,17 +1166,87 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 
 	pr_debug("%s\n", __func__);
 	memset(&rsp, 0, sizeof(rsp));
-	rsp.response = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+	rsp.response = tmf_resp_code;
 
-	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
+	iov_iter_init(&iov_iter, READ, resp_iov, in_iovs, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret = sizeof(rsp)))
-		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, vq_desc, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
 }
 
+static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
+{
+	struct vhost_scsi_tmf *tmf = container_of(work, struct vhost_scsi_tmf,
+						  vwork);
+	int resp_code;
+
+	if (tmf->se_cmd.se_tmr_req->response = TMR_FUNCTION_COMPLETE)
+		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
+	else
+		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
+
+	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
+				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+	vhost_scsi_release_tmf_res(tmf);
+}
+
+static void
+vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
+		      struct vhost_virtqueue *vq,
+		      struct virtio_scsi_ctrl_tmf_req *vtmf,
+		      struct vhost_scsi_ctx *vc)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_tmf *tmf;
+
+	if (vhost32_to_cpu(vq, vtmf->subtype) !+	    VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET)
+		goto send_reject;
+
+	if (!tpg->tpg_nexus || !tpg->tpg_nexus->tvn_se_sess) {
+		pr_err("Unable to locate active struct vhost_scsi_nexus for LUN RESET.\n");
+		goto send_reject;
+	}
+
+	mutex_lock(&tpg->tv_tpg_mutex);
+	if (list_empty(&tpg->tmf_queue)) {
+		pr_err("Missing reserve TMF. Could not handle LUN RESET.\n");
+		mutex_unlock(&tpg->tv_tpg_mutex);
+		goto send_reject;
+	}
+
+	tmf = list_first_entry(&tpg->tmf_queue, struct vhost_scsi_tmf,
+			       queue_entry);
+	list_del_init(&tmf->queue_entry);
+	mutex_unlock(&tpg->tv_tpg_mutex);
+
+	tmf->tpg = tpg;
+	tmf->vhost = vs;
+	tmf->svq = svq;
+	tmf->resp_iov = vq->iov[vc->out];
+	tmf->vq_desc = vc->head;
+	tmf->in_iovs = vc->in;
+	tmf->inflight = vhost_scsi_get_inflight(vq);
+
+	if (target_submit_tmr(&tmf->se_cmd, tpg->tpg_nexus->tvn_se_sess, NULL,
+			      vhost_buf_to_lun(vtmf->lun), NULL,
+			      TMR_LUN_RESET, GFP_KERNEL, 0,
+			      TARGET_SCF_ACK_KREF) < 0) {
+		vhost_scsi_release_tmf_res(tmf);
+		goto send_reject;
+	}
+
+	return;
+
+send_reject:
+	vhost_scsi_send_tmf_resp(vs, vq, vc->in, vc->head, &vq->iov[vc->out],
+				 VIRTIO_SCSI_S_FUNCTION_REJECTED);
+}
+
 static void
 vhost_scsi_send_an_resp(struct vhost_scsi *vs,
 			struct vhost_virtqueue *vq,
@@ -1166,6 +1272,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 static void
 vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
+	struct vhost_scsi_tpg *tpg;
 	union {
 		__virtio32 type;
 		struct virtio_scsi_ctrl_an_req an;
@@ -1247,12 +1354,12 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
 		vc.req += typ_size;
 		vc.req_size -= typ_size;
 
-		ret = vhost_scsi_get_req(vq, &vc, NULL);
+		ret = vhost_scsi_get_req(vq, &vc, &tpg);
 		if (ret)
 			goto err;
 
 		if (v_req.type = VIRTIO_SCSI_T_TMF)
-			vhost_scsi_send_tmf_reject(vs, vq, &vc);
+			vhost_scsi_handle_tmf(vs, tpg, vq, &v_req.tmf, &vc);
 		else
 			vhost_scsi_send_an_resp(vs, vq, &vc);
 err:
@@ -1927,11 +2034,19 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 {
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tmf *tmf;
+
+	tmf = kzalloc(sizeof(*tmf), GFP_KERNEL);
+	if (!tmf)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&tmf->queue_entry);
+	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
 
 	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
+	list_add_tail(&tmf->queue_entry, &tpg->tmf_queue);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotplug(tpg, lun);
@@ -1946,11 +2061,16 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 {
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
+	struct vhost_scsi_tmf *tmf;
 
 	mutex_lock(&vhost_scsi_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
+	tmf = list_first_entry(&tpg->tmf_queue, struct vhost_scsi_tmf,
+			       queue_entry);
+	list_del(&tmf->queue_entry);
+	kfree(tmf);
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
 	vhost_scsi_hotunplug(tpg, lun);
@@ -2211,6 +2331,7 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 	}
 	mutex_init(&tpg->tv_tpg_mutex);
 	INIT_LIST_HEAD(&tpg->tv_tpg_list);
+	INIT_LIST_HEAD(&tpg->tmf_queue);
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-- 
1.8.3.1
