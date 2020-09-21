From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 21 Sep 2020 18:23:05 +0000
Subject: [PATCH 5/8] vhost scsi: add lun parser helper
Message-Id: <1600712588-9514-6-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

Move code to parse lun from req's lun_buf to helper, so tmf code
can use it in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 26d0f75..736ce19 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -899,6 +899,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	return ret;
 }
 
+static u16 vhost_buf_to_lun(u8 *lun_buf)
+{
+	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
+}
+
 static void
 vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 {
@@ -1037,12 +1042,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			tag = vhost64_to_cpu(vq, v_req_pi.tag);
 			task_attr = v_req_pi.task_attr;
 			cdb = &v_req_pi.cdb[0];
-			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req_pi.lun);
 		} else {
 			tag = vhost64_to_cpu(vq, v_req.tag);
 			task_attr = v_req.task_attr;
 			cdb = &v_req.cdb[0];
-			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
+			lun = vhost_buf_to_lun(v_req.lun);
 		}
 		/*
 		 * Check that the received CDB size does not exceeded our
-- 
1.8.3.1
