From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:28 +0000
Subject: [PATCH 02/15] tcmu: merge common block release code
Message-Id: <1511894441-8626-3-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Have unmap_thread_fn use tcmu_blocks_release.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 6bcaa8b..d9fd91e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1302,21 +1302,19 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static void tcmu_blocks_release(struct tcmu_dev *udev)
+static void tcmu_blocks_release(struct radix_tree_root *blocks,
+				int start, int end)
 {
 	int i;
 	struct page *page;
 
-	/* Try to release all block pages */
-	mutex_lock(&udev->cmdr_lock);
-	for (i = 0; i <= udev->dbi_max; i++) {
-		page = radix_tree_delete(&udev->data_blocks, i);
+	for (i = start; i < end; i++) {
+		page = radix_tree_delete(blocks, i);
 		if (page) {
 			__free_page(page);
 			atomic_dec(&global_db_count);
 		}
 	}
-	mutex_unlock(&udev->cmdr_lock);
 }
 
 static void tcmu_dev_kref_release(struct kref *kref)
@@ -1340,7 +1338,9 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	spin_unlock_irq(&udev->commands_lock);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(udev);
+	mutex_lock(&udev->cmdr_lock);
+	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	mutex_unlock(&udev->cmdr_lock);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
@@ -1978,8 +1978,6 @@ static int unmap_thread_fn(void *data)
 	struct tcmu_dev *udev;
 	loff_t off;
 	uint32_t start, end, block;
-	struct page *page;
-	int i;
 
 	while (!kthread_should_stop()) {
 		DEFINE_WAIT(__wait);
@@ -2027,13 +2025,7 @@ static int unmap_thread_fn(void *data)
 			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 			/* Release the block pages */
-			for (i = start; i < end; i++) {
-				page = radix_tree_delete(&udev->data_blocks, i);
-				if (page) {
-					__free_page(page);
-					atomic_dec(&global_db_count);
-				}
-			}
+			tcmu_blocks_release(&udev->data_blocks, start, end);
 			mutex_unlock(&udev->cmdr_lock);
 		}
 
-- 
1.8.3.1

