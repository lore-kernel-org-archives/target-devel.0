From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 04 Nov 2020 22:26:36 +0000
Subject: [PATCH 03/11] vhost net: use goto error handling in open
Message-Id: <1604528804-2878-4-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

In the next patches vhost_dev_init will be able to fail. This patch has
vhost_net_open use goto error handling like is done in the other vhost
code to make handling vhost_dev_init failures easier to handle and
extend in the future.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d..831d824 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1286,27 +1286,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	if (!n)
 		return -ENOMEM;
 	vqs = kmalloc_array(VHOST_NET_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
-	if (!vqs) {
-		kvfree(n);
-		return -ENOMEM;
-	}
+	if (!vqs)
+		goto err_vqs;
 
 	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
 			      GFP_KERNEL);
-	if (!queue) {
-		kfree(vqs);
-		kvfree(n);
-		return -ENOMEM;
-	}
+	if (!queue)
+		goto err_queue;
 	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
 
 	xdp = kmalloc_array(VHOST_NET_BATCH, sizeof(*xdp), GFP_KERNEL);
-	if (!xdp) {
-		kfree(vqs);
-		kvfree(n);
-		kfree(queue);
-		return -ENOMEM;
-	}
+	if (!xdp)
+		goto err_xdp;
 	n->vqs[VHOST_NET_VQ_TX].xdp = xdp;
 
 	dev = &n->dev;
@@ -1338,6 +1329,14 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	n->refcnt_bias = 0;
 
 	return 0;
+
+err_xdp:
+	kfree(queue);
+err_queue:
+	kfree(vqs);
+err_vqs:
+	kvfree(n);
+	return -ENOMEM;
 }
 
 static struct socket *vhost_net_stop_vq(struct vhost_net *n,
-- 
1.8.3.1
