From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:34:47 +0000
Subject: [PATCH 01/17] vhost scsi: add lun parser helper
Message-Id: <1603326903-27052-2-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

Move code to parse lun from req's lun_buf to helper, so tmf code
can use it in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/vhost/scsi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b22adf0..0ea78d0 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -907,6 +907,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
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
@@ -1045,12 +1050,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
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
