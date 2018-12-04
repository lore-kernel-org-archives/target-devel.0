From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 04 Dec 2018 00:48:23 +0000
Subject: [PATCH v2 4/4] vhost/scsi: Use copy_to_iter() to send control queue response
Message-Id: <1543884503-32281-5-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Uses copy_to_iter() instead of __copy_to_user() in order to ensure
user address range validation through access_ok().

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 drivers/vhost/scsi.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3eae17e..28c9cb6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1130,16 +1130,18 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			   struct vhost_virtqueue *vq,
 			   struct vhost_scsi_ctx *vc)
 {
-	struct virtio_scsi_ctrl_tmf_resp __user *resp;
 	struct virtio_scsi_ctrl_tmf_resp rsp;
+	struct iov_iter iov_iter;
 	int ret;
 
 	pr_debug("%s\n", __func__);
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = VIRTIO_SCSI_S_FUNCTION_REJECTED;
-	resp = vq->iov[vc->out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
+
+	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
+
+	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
+	if (likely(ret = sizeof(rsp)))
 		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
@@ -1150,16 +1152,18 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			struct vhost_virtqueue *vq,
 			struct vhost_scsi_ctx *vc)
 {
-	struct virtio_scsi_ctrl_an_resp __user *resp;
 	struct virtio_scsi_ctrl_an_resp rsp;
+	struct iov_iter iov_iter;
 	int ret;
 
 	pr_debug("%s\n", __func__);
 	memset(&rsp, 0, sizeof(rsp));	/* event_actual = 0 */
 	rsp.response = VIRTIO_SCSI_S_OK;
-	resp = vq->iov[vc->out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
+
+	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
+
+	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
+	if (likely(ret = sizeof(rsp)))
 		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_an_resp\n");
-- 
1.8.3.1
