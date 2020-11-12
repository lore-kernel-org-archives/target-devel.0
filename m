From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:19:06 +0000
Subject: [PATCH 06/10] vhost scsi: make SCSI cmd completion per vq
Message-Id: <1605223150-10888-8-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

In the last patches we are going to have a worker thread per IO vq.
This patch separates the scsi cmd completion code paths so we can
complete cmds based on their vq instead of having all cmds complete
on the same worker thread.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4725a08..2bbe1a8 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -178,6 +178,7 @@ enum {
 
 struct vhost_scsi_virtqueue {
 	struct vhost_virtqueue vq;
+	struct vhost_scsi *vs;
 	/*
 	 * Reference counting for inflight reqs, used for flush operation. At
 	 * each time, one reference tracks new commands submitted, while we
@@ -192,6 +193,9 @@ struct vhost_scsi_virtqueue {
 	struct vhost_scsi_cmd *scsi_cmds;
 	struct sbitmap scsi_tags;
 	int max_cmds;
+
+	struct vhost_work completion_work;
+	struct llist_head completion_list;
 };
 
 struct vhost_scsi {
@@ -202,9 +206,6 @@ struct vhost_scsi {
 	struct vhost_dev dev;
 	struct vhost_scsi_virtqueue vqs[VHOST_SCSI_MAX_VQ];
 
-	struct vhost_work vs_completion_work; /* cmd completion work item */
-	struct llist_head vs_completion_list; /* cmd completion queue */
-
 	struct vhost_work vs_event_work; /* evt injection work item */
 	struct llist_head vs_event_list; /* evt injection queue */
 
@@ -380,10 +381,11 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	} else {
 		struct vhost_scsi_cmd *cmd = container_of(se_cmd,
 					struct vhost_scsi_cmd, tvc_se_cmd);
-		struct vhost_scsi *vs = cmd->tvc_vhost;
+		struct vhost_scsi_virtqueue *svq =  container_of(cmd->tvc_vq,
+					struct vhost_scsi_virtqueue, vq);
 
-		llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
-		vhost_work_queue(&vs->dev, &vs->vs_completion_work);
+		llist_add(&cmd->tvc_completion_list, &svq->completion_list);
+		vhost_vq_work_queue(&svq->vq, &svq->completion_work);
 	}
 }
 
@@ -545,18 +547,17 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
  */
 static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 {
-	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
-					vs_completion_work);
-	DECLARE_BITMAP(signal, VHOST_SCSI_MAX_VQ);
+	struct vhost_scsi_virtqueue *svq = container_of(work,
+				struct vhost_scsi_virtqueue, completion_work);
 	struct virtio_scsi_cmd_resp v_rsp;
 	struct vhost_scsi_cmd *cmd, *t;
 	struct llist_node *llnode;
 	struct se_cmd *se_cmd;
 	struct iov_iter iov_iter;
-	int ret, vq;
+	bool signal = false;
+	int ret;
 
-	bitmap_zero(signal, VHOST_SCSI_MAX_VQ);
-	llnode = llist_del_all(&vs->vs_completion_list);
+	llnode = llist_del_all(&svq->completion_list);
 	llist_for_each_entry_safe(cmd, t, llnode, tvc_completion_list) {
 		se_cmd = &cmd->tvc_se_cmd;
 
@@ -576,21 +577,16 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret = sizeof(v_rsp))) {
-			struct vhost_scsi_virtqueue *q;
+			signal = true;
 			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
-			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
-			vq = q - vs->vqs;
-			__set_bit(vq, signal);
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
-	vq = -1;
-	while ((vq = find_next_bit(signal, VHOST_SCSI_MAX_VQ, vq + 1))
-		< VHOST_SCSI_MAX_VQ)
-		vhost_signal(&vs->dev, &vs->vqs[vq].vq);
+	if (signal)
+		vhost_signal(&svq->vs->dev, &svq->vq);
 }
 
 static struct vhost_scsi_cmd *
@@ -1799,6 +1795,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
+	struct vhost_scsi_virtqueue *svq;
 	struct vhost_scsi *vs;
 	struct vhost_virtqueue **vqs;
 	int r = -ENOMEM, i;
@@ -1814,7 +1811,6 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	if (!vqs)
 		goto err_vqs;
 
-	vhost_work_init(&vs->vs_completion_work, vhost_scsi_complete_cmd_work);
 	vhost_work_init(&vs->vs_event_work, vhost_scsi_evt_work);
 
 	vs->vs_events_nr = 0;
@@ -1825,8 +1821,14 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	vs->vqs[VHOST_SCSI_VQ_CTL].vq.handle_kick = vhost_scsi_ctl_handle_kick;
 	vs->vqs[VHOST_SCSI_VQ_EVT].vq.handle_kick = vhost_scsi_evt_handle_kick;
 	for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
-		vqs[i] = &vs->vqs[i].vq;
-		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
+		svq = &vs->vqs[i];
+
+		vqs[i] = &svq->vq;
+		svq->vs = vs;
+		init_llist_head(&svq->completion_list);
+		vhost_work_init(&svq->completion_work,
+				vhost_scsi_complete_cmd_work);
+		svq->vq.handle_kick = vhost_scsi_handle_kick;
 	}
 	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
 		       VHOST_SCSI_WEIGHT, 0, true, NULL);
-- 
1.8.3.1
