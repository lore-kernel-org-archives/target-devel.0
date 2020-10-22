From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:35:02 +0000
Subject: [PATCH 16/17] vhost scsi: multiple worker support
Message-Id: <1603326903-27052-17-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

Create a vhost_worker per IO vq. When using more than 2 vqs and/or
multiple LUNs per vhost-scsi dev, we hit a bottleneck with the single
worker where we want to start and complete all vqs and all LUNs from the
same thread.

Combined with the previous patches that allow us to increase the
queue depths and virtqueue count, for a single LUN/device with 8
virtqueues at queue depth of 128 cmds per queue, IOPs heavy workloads
(like 50/50 randrw 4K IOs with numjobs=virtqueues and iodepth=queue
depth) go from 180K to 400K where the native device can get 500K IOPs.

When using the null_blk driver, with a single LUN/device and the
same number of virtqueues/queuedepth and fio workload we see IOPs go
from 360K to 640K.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5d6dc15..4e91a90 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1624,6 +1624,22 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
 
+		/*
+		 * For compat, have the evt and ctl vqs share worker0 with
+		 * the first IO vq like is setup as default already. Any
+		 * additional vqs will get their own worker.
+		 *
+		 * Note: if we fail later, then the vhost_dev_cleanup call on
+		 * release() will clean up all the workers.
+		 */
+		ret = vhost_workers_create(&vs->dev,
+					   vs->dev.nvqs - VHOST_SCSI_VQ_IO);
+		if (ret) {
+			pr_err("Could not create vhost-scsi workers. Error %d.",
+			       ret);
+			goto undepend;
+		}
+
 		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
@@ -1631,6 +1647,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 
 			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
 				goto destroy_vq_cmds;
+			vhost_vq_set_worker(vq, i - VHOST_SCSI_VQ_IO);
 		}
 
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
-- 
1.8.3.1
