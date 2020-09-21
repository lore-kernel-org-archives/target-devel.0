From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 21 Sep 2020 18:23:01 +0000
Subject: [PATCH 1/8] vhost vdpa: fix vhost_vdpa_open error handling
Message-Id: <1600712588-9514-2-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

We must free the vqs array in the open failure path, because
vhost_vdpa_release will not be called.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f..3301214 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -808,6 +808,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
+	kfree(vqs);
 err:
 	atomic_dec(&v->opened);
 	return r;
-- 
1.8.3.1
