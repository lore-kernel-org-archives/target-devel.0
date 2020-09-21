From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 21 Sep 2020 18:23:02 +0000
Subject: [PATCH 2/8] vhost: add helper to check if a vq has been setup
Message-Id: <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

This adds a helper check if a vq has been setup. The next patches
will use this when we move the vhost scsi cmd preallocation from per
session to per vq. In the per vq case, we only want to allocate cmds
for vqs that have actually been setup and not for all the possible
vqs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 9 +++++++++
 drivers/vhost/vhost.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519c..5dd9eb1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -305,6 +305,15 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 	spin_lock_init(&call_ctx->ctx_lock);
 }
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
+{
+	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
+		return true;
+	else
+		return false;
+}
+EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
+
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c..3d30b3d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-- 
1.8.3.1
