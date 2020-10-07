From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 07 Oct 2020 20:55:01 +0000
Subject: [PATCH 16/16] vhost scsi: multiple worker support
Message-Id: <1602104101-5592-17-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

Create a vhost_worker per IO vq. When using a more than 2 vqs and/or
multiple LUNs per vhost-scsi dev, we hit a bottleneck with the single
worker. The problem is that we want to start and complete all vqs and
all LUNs from the same thread. Combine with the previous patches that
allow us to add more than 2 vqs, we see a IOPs workloads (like 50/50
randrw 4K IOs) go from 150K to 400K where the native device is 500K.
For the lio rd_mcp backend, we see IOPs go for from 400K to 600K.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4309f97..e5f73c1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1624,6 +1624,22 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
 
+		/*
+		 * For compat, have the evt and ctl vqs share worker0 with
+		 * the first IO vq like is setup as default already. Any
+		 * addition vqs will get their own worker.
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
