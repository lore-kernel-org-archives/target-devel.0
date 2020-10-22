From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:34:58 +0000
Subject: [PATCH 12/17] vhost poll: fix coding style
Message-Id: <1603326903-27052-13-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

We use like 3 coding styles in this struct. Switch to just tabs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9677870..08c5aef 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -28,12 +28,12 @@ struct vhost_work {
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
-	poll_table                table;
-	wait_queue_head_t        *wqh;
-	wait_queue_entry_t              wait;
-	struct vhost_work	  work;
-	__poll_t		  mask;
-	struct vhost_dev	 *dev;
+	poll_table		table;
+	wait_queue_head_t	*wqh;
+	wait_queue_entry_t	wait;
+	struct vhost_work	work;
+	__poll_t		mask;
+	struct vhost_dev	*dev;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
-- 
1.8.3.1
